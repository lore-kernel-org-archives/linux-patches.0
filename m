Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0160130E27;
	Mon, 12 Aug 2024 16:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479286; cv=none; b=uz0+drSoGAjArTe1E0djomfdZ7uO+LH8cEcFbZFSHdhtmtyjncH7C38/HuhNNlNQZPwBr/RqZUkWQ7KALtUuMTJSEE0sLEDELNALH5npq2ncJG51z87wGXS/KyZhLcbzVftV0GCQ+ByXkBaGlueNecDWSw8cHPrIDDe75M1sg9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479286; c=relaxed/simple;
	bh=ctWrwB8s8wghcJdVioPkzm0RnbFVprqebZ0PbMVU37k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rvDXvbkMGl6MTGV3erj8nmsTl/2QA84NkHTX5fU+mn2dc849jMeoBpRWjAQczjS+CxQaupQ30FnUqgFdo5Gav6bV8kNgm7VNCLi4XrtUQjcUcA8WJ4QHvZEi80OXwbUPymbYrLfuvCln0zKsKndretXFiYrCsf+unx9PKLUdVwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RgDSXA8t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RgDSXA8t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D58EC32782;
	Mon, 12 Aug 2024 16:14:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479286;
	bh=ctWrwB8s8wghcJdVioPkzm0RnbFVprqebZ0PbMVU37k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RgDSXA8twu8FryqhPdrPHfV2dUbfT+6farcdc/F9vUVelQmWdFo0+M8S5LbHYH7LO
	 s3XaZ2EC3tMMomeeOWLHsHlvq3chWtU5cw++QNgbal/XFou9tzCHRif+MxzadMnMtm
	 x1G+KkaNkpH3aVaHNK2dIcaYKY57pul8UYcOm0II=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/189] PCI: Add Edimax Vendor ID to pci_ids.h
Date: Mon, 12 Aug 2024 18:01:36 +0200
Message-ID: <20240812160133.689534301@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160132.135168257@linuxfoundation.org>
References: <20240812160132.135168257@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 0a85ff5c8db3c..abff4e3b6a58b 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2124,6 +2124,8 @@
 
 #define PCI_VENDOR_ID_CHELSIO		0x1425
 
+#define PCI_VENDOR_ID_EDIMAX		0x1432
+
 #define PCI_VENDOR_ID_ADLINK		0x144a
 
 #define PCI_VENDOR_ID_SAMSUNG		0x144d
-- 
2.43.0



