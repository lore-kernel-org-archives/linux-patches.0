Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703C73C1FCA;
	Thu, 15 Jan 2026 17:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768499582; cv=none; b=mh+R2ZqSypNBzPDyqWlpapF0tbECCDZFE8QefDK2Gzj7LDjMiZDwWbMzAD3Ru8KSd0PHQJlIOQ447N+N2lkjxqiQaGxz1PpnURM7Xbbrvfex3Ok6ngN38PmCU2I/x3uqe5y1AyrzS+xYTc/3zaSNaDRd+/bIbY488HDhQvGiXnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768499582; c=relaxed/simple;
	bh=MqarYFSHpJrXz5IF7R2Ccgu26Pzebmzk/aCgHn/8IOI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gxA2L8VmSwhkeNW5tS7L0gicIiORy8PdESaU/SHCnI4DYbAJX4AtdRguUEokZjNZGQVHq09gRSrW3XMJ9WPReT6uP32ViQhIewnnDulbNJQuMtswmsGxD/RgyK7OCAhRif2FOM1FS2GKcdsO3p/UEa9Bal4e6Z+cxyhetzGHvu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MQJUxlEA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MQJUxlEA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E52BBC116D0;
	Thu, 15 Jan 2026 17:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768499582;
	bh=MqarYFSHpJrXz5IF7R2Ccgu26Pzebmzk/aCgHn/8IOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MQJUxlEAJBr04TsgcO+pBq14NYq/2XjNtK1NVhYTONb6wexWvYcPvw2SBbSpDwWGw
	 +Rllj7M1UJFRQ4RDISFROTjJb33hljz3oA1m2srVTiYfnHnV3ghT9hNYrf9koFdhLA
	 CZsSwQbO6mmVRIiQYU76XpVQdPffWhcvG1vDxDS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 278/451] platform/x86: msi-laptop: add missing sysfs_remove_group()
Date: Thu, 15 Jan 2026 17:47:59 +0100
Message-ID: <20260115164240.940244296@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index dfb4af759aa7..fd6b3383ac4f 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -1146,6 +1146,9 @@ static void __exit msi_cleanup(void)
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



