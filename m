Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC7AD46AA6B;
	Tue, 21 Jul 2026 15:40:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648437; cv=none; b=AQmGzc3JSW1Y3NYFHRWGd0nKs/IQFZBd9avWaoZGk+Hy4JhXgpD/zSxqDq1JMHr7zgk2gdUtvra6pogD34Pi9EzmpPMaWRNfVRYJhmGVypwriw5lnmLz7b2yh8Yp5kY8oaNF+yPgl0KQC+Gxan5PuwhgejfVhg2OBChduGt1dTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648437; c=relaxed/simple;
	bh=Gd8/J5Urcv101ceBQTR2DG/xvN2XZWLoyp9MMbZjx0E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jo/iYQZeJkcZspR0RN5XONsOV+WUDx2Mv72W6cRcwcreDOe6n1LAK61A0r1v7yljVgrLKjwFaUz22hBW2xLp/w2guNen7UWgZPITo8JHs48gmgLhD4MFAP1IrRjtn/CiXh26qY+8JRfxMSzvdq4qb0xpru/tZVxlGkjYYTDDSg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SfJpg/WN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SfJpg/WN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E4CE1F000E9;
	Tue, 21 Jul 2026 15:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648436;
	bh=vyImLr48aXRL8P+3cY3ciYYRb89kTz42Iav5qZrHNsM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SfJpg/WNG3JdjVNhTuqEqfWflSKi6ia6mfYfzxYsydAsvT0zIXLhDIuFfYoWh8k66
	 6efxk3E9Y00xXLB6J9TQJ467HpUNbw0z1o0TvzmuntUW6LUtsAdir0KTRsbkalV4dA
	 fjdtwTqwR6byGDZUypIYTCf5qx/qYbefxrzXuQ3g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0199/2077] platform/chrome: chromeos_tbmc: Check ACPI_COMPANION()
Date: Tue, 21 Jul 2026 16:57:52 +0200
Message-ID: <20260721152557.374102519@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

[ Upstream commit c15dbae7c856fb53cc6ffb86c6c64ebb816d07c8 ]

Every platform driver can be forced to match a device that doesn't match
its list of device IDs because of device_match_driver_override(), so
platform drivers that rely on the existence of a device's ACPI companion
object need to verify its presence.

Accordingly, add a requisite ACPI_COMPANION() check against NULL to the
chromeos_tbmc driver.

Fixes: a2676ead257f ("platform/chrome: chromeos_tbmc: Convert to a platform driver")
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Link: https://lore.kernel.org/r/1875121.VLH7GnMWUR@rafael.j.wysocki
Signed-off-by: Tzung-Bi Shih <tzungbi@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/chrome/chromeos_tbmc.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/chrome/chromeos_tbmc.c b/drivers/platform/chrome/chromeos_tbmc.c
index 5133806b2d9587..fd756761a481f4 100644
--- a/drivers/platform/chrome/chromeos_tbmc.c
+++ b/drivers/platform/chrome/chromeos_tbmc.c
@@ -69,9 +69,13 @@ static int chromeos_tbmc_probe(struct platform_device *pdev)
 {
 	struct input_dev *idev;
 	struct device *dev = &pdev->dev;
-	struct acpi_device *adev = ACPI_COMPANION(dev);
+	struct acpi_device *adev;
 	int ret;
 
+	adev = ACPI_COMPANION(dev);
+	if (!adev)
+		return -ENODEV;
+
 	idev = devm_input_allocate_device(dev);
 	if (!idev)
 		return -ENOMEM;
-- 
2.53.0



