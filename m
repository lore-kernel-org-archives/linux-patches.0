Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 008822EAD10;
	Fri,  9 Jan 2026 12:12:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767960746; cv=none; b=ZQ8QDe0xjUUQEldO6d3FXWN8FvmzBixEEhfqpdaybMKnTGz9HzfNG2aDwJ7cGewjuIwtK13BfkT3ebe5tsm6/O0kB4tptEB/b4px1FU0KtyyOLC7LlaS+Gi42PzBpqfg9YEeCB4/1vuZsz/Bl9M2+tMM2sAi/KxHg7vcu0HbD08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767960746; c=relaxed/simple;
	bh=UfrQXmYzbhPSBKJ0aJV+QUlwtAXAXVZZ/PI2QaaR0Ho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FAuGlV7EjuvR4C+UFIFazdV/nua61rRdtvcqnaXvZyK7dhw/c+pdrYmrgAFvLH4Hx8jSzqnmH3DEZSEnMla6wPKqRY2TRFgn1kMLCHNzaUPkZ+u0MdrV7IWoMu0C8H48GtRBAkLICO3YHF/eryGylp5cj0uXeCLd2EDb5n6TMxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0kW+4c+4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0kW+4c+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80B69C4CEF1;
	Fri,  9 Jan 2026 12:12:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767960745;
	bh=UfrQXmYzbhPSBKJ0aJV+QUlwtAXAXVZZ/PI2QaaR0Ho=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0kW+4c+4NWMYqq95DC/VVzjLZtXx8iy5HIXDvyt5t1j4FrDtRgqosqK4ppNymItIc
	 lQXJRlbJ/q4QHenC3omUMcjLYMedgDG2lA0fvw1BGeXhJWJqwQeEeHd+q0XZFyNH81
	 l4VRUwzAmo7SE9Maa7ZaHD9M5cbyvaxhLOwVAC60=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 511/737] platform/x86: msi-laptop: add missing sysfs_remove_group()
Date: Fri,  9 Jan 2026 12:40:50 +0100
Message-ID: <20260109112153.220628444@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112133.973195406@linuxfoundation.org>
References: <20260109112133.973195406@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index f4c6c36e05a5..2a8839135492 100644
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



