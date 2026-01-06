Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 991DC2BE7B2;
	Tue,  6 Jan 2026 17:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720679; cv=none; b=SBWKyyrp3W2CDM0lD6WinviukDHKscxXtuURjYTxBbuMmVIox0p/uusonM5GUNPnedUtQa0JOVY1/6txHLMQe5RpB9CKbSqWpWJKnTEwdyAYFiZR9qG2B9/kJu2E+HgXEGOBRLpGyYU319FeEDvjmFgEQvSuk0I8jZ7xWSFVpek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720679; c=relaxed/simple;
	bh=jnKVWHRzQZhPuuYneZ90KPRyX2AaFpz/TW9I7PFmkl8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Qv9ALATH7pCmwbD7I+KmbpAnVmGsNTi0sOGNlkVrlf3IBhAc5u7Lr3AgcJC9SwuzBPajbNn7+neHDEy7J91dkU90ljx4pWx0xDk9pTbkGjEZrmHIWT2aDLtWu9/gd9CkADKvcmmV09ZpiqE+ZUtndSJVwz+1RX8bntxYL2h9HaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EcPJ5me2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EcPJ5me2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2FD7C116C6;
	Tue,  6 Jan 2026 17:31:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720679;
	bh=jnKVWHRzQZhPuuYneZ90KPRyX2AaFpz/TW9I7PFmkl8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EcPJ5me2F1JOBy/lHPqwXckyyMAm15LVoxmTJEZmzoi1kHbri+bp+Ykvb4wYxDGnV
	 Xs5brunrbIL1t2GZeYgnjen2n7xlv42McGeGglH5YpffuwH0Jd5HQL5HJ4++IlmIf5
	 NmdpKZipKsZXf0ENS6s701sox44QDOv65vV/R+2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 308/567] platform/x86: msi-laptop: add missing sysfs_remove_group()
Date: Tue,  6 Jan 2026 18:01:30 +0100
Message-ID: <20260106170502.722296056@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index e5391a37014d..db3dadd29b29 100644
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



