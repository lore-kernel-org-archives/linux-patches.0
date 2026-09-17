Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5307459E355;
	Thu, 17 Sep 2026 15:30:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659031; cv=none; b=RXlFO10W52cNpVl+OvNZ/S/xxH8AHmILeNN8AtfRv+/EBS5lyU4nydfr31AJLYK2DSgcGwUc3495vW2ubparfEAcoGjf1fHPCUaXgg8Y5Gt9FRf+FsbOj0IKTyHxBW99Awz4bGVehkB4Z5XJrdezx5f617/iq6NdCVk6ZgRGm4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659031; c=relaxed/simple;
	bh=RKvA1Xe8N9+QROrypKiA4PXo/3yXnCpsjHm5aBOCCUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z9KpjNI+Z67w93ylBpnDuh/JCOQAmzW9ErP6odtqO/d6rwl66sjWPd7svI8tGvZ4oUPrMn4H9odO8NT9xv0qX8vGJP32JTCl3KaJlyNGcLRCMks7OQQay5aDlbWIXZer0wV7fHqBkcYitBo+ar/pa2ccCvPyLykQX0Iyv2HrCmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PYRkRwef; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PYRkRwef"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E56F31F00893;
	Thu, 17 Sep 2026 15:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659022;
	bh=Uk67zEDKWrmkDCCbQ1Q3Px2NsU0Z0FwFhRz/v+wdo2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PYRkRwefPnFworSag71Xp5o8gdVsqU8Ga5FReJFD+eqhbUFtoSy90BjRltguKQ8gV
	 Ae6I9hO0UYvIn0NB3SEbnvKNz+QWOEQ4pLCXsuVhNNIvbXJA/0EKmKzE+nlsvFY3HX
	 s3M41IWnRppAAdyIK6Oq86Sw7hDT7O8SmRSJiL/w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mo Jun <royclark086@gmail.com>,
	Armin Wolf <W_Armin@gmx.de>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 116/733] platform/x86: asus-laptop: Fix ACPI event handling
Date: Thu, 17 Sep 2026 16:07:04 +0100
Message-ID: <20260917151353.885744661@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 6bb4fb72c00dc2a9cb663e2d16adce15e4170cdf ]

The event codes inside asus_keymap[] span a wide range from 0x02
till 0xC5, but using ACPI_DEVICE_NOTIFY prevents us from receiving
event codes below 0x80.

Fix this by using ACPI_ALL_NOTIFY instead.

Fixes: 378500dc1313 ("platform/x86: asus-laptop: Register ACPI notify handler directly")
Reported-by: Mo Jun <royclark086@gmail.com>
Closes: https://bugs.debian.org/1146124
Tested-by: Mo Jun <royclark086@gmail.com>
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://patch.msgid.link/20260830235058.324140-1-W_Armin@gmx.de
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/asus-laptop.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 140ac8a105372..19024fa3796e6 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -1887,7 +1887,7 @@ static int asus_acpi_probe(struct platform_device *pdev)
 	if (result && result != -ENODEV)
 		goto fail_pega_rfkill;
 
-	result = acpi_dev_install_notify_handler(device, ACPI_DEVICE_NOTIFY,
+	result = acpi_dev_install_notify_handler(device, ACPI_ALL_NOTIFY,
 						 asus_acpi_notify, asus);
 	if (result)
 		goto fail_pega_rfkill;
@@ -1917,7 +1917,7 @@ static void asus_acpi_remove(struct platform_device *pdev)
 {
 	struct asus_laptop *asus = platform_get_drvdata(pdev);
 
-	acpi_dev_remove_notify_handler(asus->device, ACPI_DEVICE_NOTIFY,
+	acpi_dev_remove_notify_handler(asus->device, ACPI_ALL_NOTIFY,
 				       asus_acpi_notify);
 	asus_backlight_exit(asus);
 	asus_rfkill_exit(asus);
-- 
2.53.0



