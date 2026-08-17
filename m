Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29B4420E98;
	Mon, 17 Aug 2026 15:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980500; cv=none; b=HbbC/lVfFVKY3P9tQqbU0Bmd4cTS48e1X7RmMT38GgPyd6fSWcprGgwoaGbW2iRo9PFB0ISVrGYA300odRaZmxLYzlgvsPyc3I1gUH9aqhcf7PCbSGYQAjnKl5CPe90MO2gW7JIMCtdNYxb5Gz7lKWCVpfdf/sLJeGXOPlCNLCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980500; c=relaxed/simple;
	bh=HCYiYAg7wc1/Cz0wsNPu/OzFLQtYAsNU1o0McUqXUls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y70MxaIlQ+7j5pivrmBlXoykFnvLgPj0uy4MezloJ18t/DkuKufcTqnhfED+Pau+XCg22K+tY2iVV8TDomXOc+m8A/rXjGeFiuKRGBNrVk6eg/wpNFyxIXzSaihKfgmBgxbu8LJYnTILFQfCv5jiAt6cXIcE9h6VobwA94EW8Lk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XxDEM4zz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XxDEM4zz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51F5B1F000E9;
	Mon, 17 Aug 2026 15:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980498;
	bh=SqnF973W2Jkd9oZCGqqyKtiGgT/SNcsQhTaQ3rVmAZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XxDEM4zz8bAl/xlHywWr73jaS8cwB7fk8L1h3o0lkke/YLZ/2ilB+vx2n/NdtVqjf
	 OpNtucmUxDUqVPKkrNyCumLK+eMnaudgOUxmdS0rhdUONaQrNfOCtdsflah7gaCeRy
	 KJaCrEmU+fxwHvNu4AnX6Mr4WtoIUaML/m5R50ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Lukasz Luba <lukasz.luba@arm.com>
Subject: [PATCH 6.1 594/609] Revert "thermal/drivers/hwmon: Cleanup coding style a bit"
Date: Mon, 17 Aug 2026 15:34:50 +0200
Message-ID: <20260817132603.528803040@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit ff8da20b6f47c48d46e47f93f7a59e2d56ee9107 upstream.

Revert commit 030a48b0f6ce ("thermal/drivers/hwmon: Cleanup coding style
a bit") that introduced a use-after-free into the error path of
thermal_add_hwmon_sysfs() by removing a valid check from it.

Link: https://lore.kernel.org/linux-hwmon/20260803183915.4ED7D1F000E9@smtp.kernel.org/
Cc: All applicable <stable@vger.kernel.org>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reviewed-by: Lukasz Luba <lukasz.luba@arm.com>
Link: https://patch.msgid.link/5123895.31r3eYUQgx@rafael.j.wysocki
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/thermal/thermal_hwmon.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/thermal/thermal_hwmon.c
+++ b/drivers/thermal/thermal_hwmon.c
@@ -209,7 +209,8 @@ int thermal_add_hwmon_sysfs(struct therm
 	if (new_hwmon_device)
 		hwmon_device_unregister(hwmon->device);
  free_mem:
-	kfree(hwmon);
+	if (new_hwmon_device)
+		kfree(hwmon);
 
 	return result;
 }


