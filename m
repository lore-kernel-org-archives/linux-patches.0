Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548EF186E3D;
	Mon, 12 Aug 2024 16:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478862; cv=none; b=Ut2DDOhos70GBbgZIH5rG/YIAVMp7LQeEg8eeZW0E2rPS3f03dFpA3py+hgWUIM8NLusVF33oYUPMWRjhmKXKnhO9CmAHEvj+JJdMUukOILkSBF4uc5eXStEFwbH/J3V7040W63EQgcADUUebq2Zc+HYd8SO+LM3dNBhTn0Afn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478862; c=relaxed/simple;
	bh=uuo3jUDk9YdZ/lo33LYw5SKz4w0TNHPcDh8g+omoDqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SU8ki05+cfiwKe6XeoW63Sd+MaNkZXiZq+V7gH/CW3UcFcV7qx16537ELwXXNPVYnjdgD6GzFn/f999fL1/BnczF9yTIOlAHNbS65iL86p3iiQ9qCINv0L6qpl0MCHAWC2h5lxSOiYCYYa/9jA3159Y1ftleVjeuRnYwYlesNvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7lZGWgJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7lZGWgJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC129C4AF0D;
	Mon, 12 Aug 2024 16:07:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478862;
	bh=uuo3jUDk9YdZ/lo33LYw5SKz4w0TNHPcDh8g+omoDqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7lZGWgJqA3d34acKPII8IiygOfwDWoE6SmjMm8rQpLhGWgY7G0RQmS5TlcAkXG0V
	 M5PboIqTUvuP7v01NfMxCvGMrYIrGI0jMP19J3AuHH6/LHq+2EvIy2c8cl8oFHatSv
	 eE6mIeXwrf+MhNYGJt3DEHtYzLQKNgCNJZxxfkRI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 028/150] PCI: Add Edimax Vendor ID to pci_ids.h
Date: Mon, 12 Aug 2024 18:01:49 +0200
Message-ID: <20240812160126.252113075@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: FUJITA Tomonori <fujita.tomonori@gmail.com>

[ Upstream commit eee5528890d54b22b46f833002355a5ee94c3bb4 ]

Add the Edimax Vendor ID (0x1432) for an ethernet driver for Tehuti
Networks TN40xx chips. This ID can be used for Realtek 8180 and Ralink
rt28xx wireless drivers.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@gmail.com>
Acked-by: Bjorn Helgaas <bhelgaas@google.com>
Link: https://patch.msgid.link/20240623235507.108147-2-fujita.tomonori@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pci_ids.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
index 2c1371320c295..f680897794fa2 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2109,6 +2109,8 @@
 
 #define PCI_VENDOR_ID_CHELSIO		0x1425
 
+#define PCI_VENDOR_ID_EDIMAX		0x1432
+
 #define PCI_VENDOR_ID_ADLINK		0x144a
 
 #define PCI_VENDOR_ID_SAMSUNG		0x144d
-- 
2.43.0



