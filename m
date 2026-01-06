Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7882935975;
	Tue,  6 Jan 2026 17:47:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721648; cv=none; b=I6zZZFHBOW6qYYYIqdUNfD5nH/6yRPM92+MSRcu0TQ/XKTjWqml4mhmpGHtHJzD/As9Bm/MRjOiiPrUon8MssszYoI+CvTOaR1ElYBXRoTnkg3rsffA9rnGDGZp++7Grz5qV22LfUWK4ib6LQmK1q5xODU1bCtJeVAUhaKujuXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721648; c=relaxed/simple;
	bh=8l9T+XZJFPo6x43jinIhPXJFYnrF+KJJBVQilAl2x00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pSwOzduGiAWfhO+VeGR8ZTZNIoRyva2Bs++/+zgC3zZ8GetYi/wrj/1+KsQtEt0Ts0iBY0zZzWI78GsHtU6yguyv7NYYvY0KpcBDUt9XrH6GbYJ0p8I/GJQCtCuBwiKyXPm6i+pmZrP0H4mqqcz1CjUrSK3UUvIwUrqxtRbinVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gm5E9i4c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gm5E9i4c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB0A3C116C6;
	Tue,  6 Jan 2026 17:47:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721648;
	bh=8l9T+XZJFPo6x43jinIhPXJFYnrF+KJJBVQilAl2x00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gm5E9i4cwlMU8wLGrrzi6ISUrDvgQaUdDFPMz/7SegbvtAfROg98K4WFshGgwLhR/
	 Hyesp6SRpFnTnRU6dibbxTDdlMF7wUY4BewRNLHkljHwCqlL7Nv0C2+oRIjvw7y21b
	 MU9/MGgqWETyXzHcCFo8h8IG+UQgvrb9O2RWdLcM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 031/312] platform/x86: msi-laptop: add missing sysfs_remove_group()
Date: Tue,  6 Jan 2026 18:01:45 +0100
Message-ID: <20260106170548.983288268@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Fourier <fourier.thomas@gmail.com>

[ Upstream commit 1461209cf813b6ee6d40f29b96b544587df6d2b1 ]

A sysfs group is created in msi_init() when old_ec_model is enabled, but
never removed. Remove the msipf_old_attribute_group in that case.

Fixes: 03696e51d75a ("msi-laptop: Disable brightness control for new EC")
Signed-off-by: Thomas Fourier <fourier.thomas@gmail.com>
Link: https://patch.msgid.link/20251217103617.27668-2-fourier.thomas@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/msi-laptop.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
index c4b150fa093f..ddef6b78d2fa 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -1130,6 +1130,9 @@ static void __exit msi_cleanup(void)
 	sysfs_remove_group(&msipf_device->dev.kobj, &msipf_attribute_group);
 	if (!quirks->old_ec_model && threeg_exists)
 		device_remove_file(&msipf_device->dev, &dev_attr_threeg);
+	if (quirks->old_ec_model)
+		sysfs_remove_group(&msipf_device->dev.kobj,
+				   &msipf_old_attribute_group);
 	platform_device_unregister(msipf_device);
 	platform_driver_unregister(&msipf_driver);
 	backlight_device_unregister(msibl_device);
-- 
2.51.0



