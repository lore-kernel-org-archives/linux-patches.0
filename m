Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 852ED27A476;
	Thu, 30 Jul 2026 14:27:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421674; cv=none; b=S5iIh74igogyT72MY7+YgVnOKDeYupj5EVSk4Tu9rBK3z1IQWIKlcGrq4MY1w9hacO3LvylZjnasgAIMX9oqwCuL/0wUDtL59cdUOwB+lRjtwrth7NU6YWUMz0UHi2TY0Oixcc6O1Kd6i5iYN6LddELsQSSN77jlynjwHkMOeyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421674; c=relaxed/simple;
	bh=X1cO4f3amstRyQK5It4Hnh4Z1NXz4HUZ6rrrGLarGWk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KtIsEuiE+zRRvjxgS8uB92eqbh7ySbTTA0bWFresN5JL6wOziHoyI7jzNwvbSL81wIYJj+CKKapZj1/uXafY3CmMEzzntlqQlzA0sJiATn0Ofv1+ZUK1dDfPL6+cnXIiOfEssMW5AgCCfEpa0e75UL7rW+B39aj6R3vLVQzFoO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=glLB7qXk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="glLB7qXk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E02191F000E9;
	Thu, 30 Jul 2026 14:27:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421673;
	bh=TrVVUDLUIo2goKjVGt+SvBdTN6yD0MXF2VxnWS0IUyU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=glLB7qXkdjiaV636hs1KjQGrWechzzGMh/zitonmqRcuSShNCqggkeaYYXcR3kzxX
	 1ZRn9rA+kaIphU07VOyz4mXYE85bpWSxNHqOKtgHmw0/ZZRkdn72cTeOLclf0n1xe9
	 jCqRkEaDBghHVy+JeHyGqZK9FkC60GCCiqKJOT60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Travers Biddle <traversbiddle@gmail.com>,
	Denis Benato <denis.benato@linux.dev>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 184/744] platform/x86: asus-wmi: temporarily revert to setting a charge limit
Date: Thu, 30 Jul 2026 16:07:37 +0200
Message-ID: <20260730141448.196655672@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Denis Benato <denis.benato@linux.dev>

[ Upstream commit 78bf392ba77dd8b2a25656e489449d2f91cfd1eb ]

A userspace regression has been observed leaving the battery charging
threshold unconfigured, so while the fix is being shipped revert
the change keeping the infrastructure in place to return to the
preferred behaviour as soon as it's appropriate to do.

Link: https://lore.kernel.org/all/5db117b7-aad1-437f-a3d4-ba7b29fc68b3@redhat.com/
Link: https://gitlab.freedesktop.org/upower/upower/-/work_items/347
Closes: https://lore.kernel.org/all/CABsFS_g+V_Owum6knLhenhM15EXJRrsF0FcLiw30WZxarsTpUA@mail.gmail.com/
Fixes: 186bf9031666 ("platform/x86: asus-wmi: do not enforce a battery charge threshold")
Reported-by: Travers Biddle <traversbiddle@gmail.com>
Signed-off-by: Denis Benato <denis.benato@linux.dev>
Link: https://patch.msgid.link/20260710165841.59957-1-denis.benato@linux.dev
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-wmi.c | 26 +++++++++++++++++++++++---
 1 file changed, 23 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
index 80144c412b902f..a459b7ad18ba0f 100644
--- a/drivers/platform/x86/asus-wmi.c
+++ b/drivers/platform/x86/asus-wmi.c
@@ -1566,6 +1566,8 @@ static DEVICE_ATTR_RW(charge_control_end_threshold);
 
 static int asus_wmi_battery_add(struct power_supply *battery, struct acpi_battery_hook *hook)
 {
+	int ret, rv;
+
 	/* The WMI method does not provide a way to specific a battery, so we
 	 * just assume it is the first battery.
 	 * Note: On some newer ASUS laptops (Zenbook UM431DA), the primary/first
@@ -1583,12 +1585,30 @@ static int asus_wmi_battery_add(struct power_supply *battery, struct acpi_batter
 
 	/* The charge threshold is only reset when the system is power cycled,
 	 * and we can't read the current threshold, however the majority of
-	 * platforms retains it, therefore signal the threshold as unknown
-	 * until user explicitly sets it to a new value.
+	 * platforms retains it.
+	 *
+	 * Setting a negative value would signal the threshold as unknown
+	 * until user explicitly sets it to a new value, however to avoid
+	 * regressing userspace, we initialize it to a value of 100.
 	 */
-	charge_end_threshold = -1;
+	charge_end_threshold = 100;
+	ret = asus_wmi_set_devstate(ASUS_WMI_DEVID_RSOC, charge_end_threshold, &rv);
+	if (ret) {
+		pr_err("Failed to reset battery charge threshold\n");
+		goto asus_wmi_battery_add_err;
+	}
+
+	if (rv != 1) {
+		pr_err("Error in battery charge threshold reset\n");
+		ret = -EIO;
+		goto asus_wmi_battery_add_err;
+	}
 
 	return 0;
+asus_wmi_battery_add_err:
+	device_remove_file(&battery->dev,
+			   &dev_attr_charge_control_end_threshold);
+	return ret;
 }
 
 static int asus_wmi_battery_remove(struct power_supply *battery, struct acpi_battery_hook *hook)
-- 
2.53.0



