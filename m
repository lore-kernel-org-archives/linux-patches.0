Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68F3217A309;
	Wed, 20 May 2026 17:07:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296855; cv=none; b=P7TnAaxnj+umz+Fzb2+DtpV+AfOy5Ol21xKRCt0xhRNTC+TZgEFZvXvXW1GBMZsEQdLq9+XJrVoq7+0QVMPon8vwZ43VsB5VeS+jkWKZQoPtN91xCS1K8eRUe+MK2v/5/t3zUR9sWJNL6+5khCfjK34IYdgppzM0Vy7iyv5y054=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296855; c=relaxed/simple;
	bh=blIOpEUQtX7lySNcgr3+u1LaqAaSn3BUonLC5AzU/yw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhOrfvrfRUkL1YjIFWCy0o+JFi2Mb37Oq9KAwXGIdL9kMGR9iBsHTUynvukJhohD8TEXGTqd9uya9FR/ws7vqTsMkm7qk6ol5xv5yJvJh/Ihln3o+V3o3ZaGXTi3ey8f1av7GGLs4pI5oCyRFNnnVdZm09YbPJYaJpnbXCKU/C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lMRNypqL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lMRNypqL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FAF61F000E9;
	Wed, 20 May 2026 17:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296853;
	bh=s8Ik0YbmAyP9THwMVTuMatvXzZfwGhHmR4Ny62a+9qY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lMRNypqL0QaJYM1QGRSkuD9kDgmX761CVVufNYTGhpSjlYYYv0Hj+FfhmVh4keU8Y
	 Ook1881HJ2HpGn7eq2LrhaPmh8SEAvQRllKPNguXVL7rA3ZtLgxP+qOZbi8hDO/7lH
	 uglcDtVRXH42U5twxy28bbgHtu4rY5KnqSW+l3tI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Myeonghun Pak <mhun512@gmail.com>,
	Ijae Kim <ae878000@gmail.com>,
	Taegyu Kim <tmk5904@psu.edu>,
	Yuho Choi <dbgh9129@gmail.com>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0916/1146] drm/sysfb: ofdrm: fix PCI device reference leaks
Date: Wed, 20 May 2026 18:19:26 +0200
Message-ID: <20260520162208.971024749@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yuho Choi <dbgh9129@gmail.com>

[ Upstream commit 4aa8110000b0d215deef8eed283565dd0c1def88 ]

display_get_pci_dev_of() gets a referenced PCI device via
pci_get_device(). Drop that reference when pci_enable_device() fails and
release it during the managed teardown path after pci_disable_device().

Without that, ofdrm leaks the pci_dev reference on both the error path
and the normal cleanup path.

Fixes: c8a17756c425 ("drm/ofdrm: Add ofdrm for Open Firmware framebuffers")
Co-developed-by: Myeonghun Pak <mhun512@gmail.com>
Signed-off-by: Myeonghun Pak <mhun512@gmail.com>
Co-developed-by: Ijae Kim <ae878000@gmail.com>
Signed-off-by: Ijae Kim <ae878000@gmail.com>
Co-developed-by: Taegyu Kim <tmk5904@psu.edu>
Signed-off-by: Taegyu Kim <tmk5904@psu.edu>
Signed-off-by: Yuho Choi <dbgh9129@gmail.com>
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Signed-off-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://patch.msgid.link/20260420002513.216-1-dbgh9129@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/sysfb/ofdrm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/sysfb/ofdrm.c b/drivers/gpu/drm/sysfb/ofdrm.c
index d38ba70f4e0d3..247cf13c80a05 100644
--- a/drivers/gpu/drm/sysfb/ofdrm.c
+++ b/drivers/gpu/drm/sysfb/ofdrm.c
@@ -350,6 +350,7 @@ static void ofdrm_pci_release(void *data)
 	struct pci_dev *pcidev = data;
 
 	pci_disable_device(pcidev);
+	pci_dev_put(pcidev);
 }
 
 static int ofdrm_device_init_pci(struct ofdrm_device *odev)
@@ -375,6 +376,7 @@ static int ofdrm_device_init_pci(struct ofdrm_device *odev)
 	if (ret) {
 		drm_err(dev, "pci_enable_device(%s) failed: %d\n",
 			dev_name(&pcidev->dev), ret);
+		pci_dev_put(pcidev);
 		return ret;
 	}
 	ret = devm_add_action_or_reset(&pdev->dev, ofdrm_pci_release, pcidev);
-- 
2.53.0



