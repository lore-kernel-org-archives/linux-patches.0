Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EF0D310636;
	Fri,  9 Jan 2026 12:42:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962561; cv=none; b=ExvEmPoB3lC8iEQPx6ky3Tg/HQLnduxSVFGRp87mqyqy9ChiglSQAEKsqZ9IfXxjK4Vl0k83kNUWQ6YP7RMXXNcDSX7K0jW7Nf17iR19rhL339VE9NF46NS6L4Iw+/oOEQ7Z1OZOu8zexF8Qn/2SnoraVqMgoQzXumMHDdcnfXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962561; c=relaxed/simple;
	bh=Ul766+HfMNwT/NI/l+cpVjVgLK5gbHKakbLww6f4dsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jVhOcNg9MPqpMSz0kPqRQAclwWya7OEA1UCs7RmEV0HlyH/XIFzYeYHeN4lfmaLcpGvTgsoz1WVg0uox8mEb3dkyyIhvHU7rkXBFEM7Yc/CyHrcoFBBT9bAltJ4Jnx+IHchEb63iNsghajqPs+i6RR85ZTln15CBs4t35J/XMI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C5K3Wtta; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C5K3Wtta"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3916C4CEF1;
	Fri,  9 Jan 2026 12:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962561;
	bh=Ul766+HfMNwT/NI/l+cpVjVgLK5gbHKakbLww6f4dsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C5K3WttajGQO23KBXrz63iKf3TwO4J47lV1/wY02/uoAK5ybPII5SgxI2ScFfPHsw
	 jRNWO13uOWXaVcIISiWXhLjZ4p7RgHMh3w1PvZKI08D24ENlG1M5Y50iKaHZ418Kj8
	 VyowN4CSH/kLE3Vq+MVsEaw7+TwvfIzS6UHZH0qw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Fourier <fourier.thomas@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 408/634] platform/x86: msi-laptop: add missing sysfs_remove_group()
Date: Fri,  9 Jan 2026 12:41:26 +0100
Message-ID: <20260109112132.882961874@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



