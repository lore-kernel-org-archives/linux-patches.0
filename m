Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FCB1A00EC;
	Thu, 15 Aug 2024 13:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723728874; cv=none; b=fS6mjdSWBYclw0ySJGXHytlACS9w1sTk2xbWioOZxmiMH8kBJUrD7vllHpOCvQdtLBIM3gecHbIeQMS/7sHaJoMOw8tIrOmbFurkAR0iF3jq4kWwsKHUi+kVulE8dMHhdiSjwMFsBYJDKi9cuuVURLouiF0uMOyRX5fLi12kfkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723728874; c=relaxed/simple;
	bh=lwJFPvVfUKf9WASlvvAPIpXYQ4DXBpO7qJf2fNtoOMM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i5MST1ilpQcOFRx/CcKXikzTZ6+K/QiTBjjQpfi3U4s0F3nRzlgvJvHnMFudNFET+ObF8M6A7qmCEJPyZ7RErv3pm62RvtEDlCoUNWyAVl657QrTF9oLR967ckzlJ3NLt0wZTi2XaS4uYBJP7mofL9h191/6I27IccbJk7shlT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=igocpjuB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="igocpjuB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 653ADC4AF0A;
	Thu, 15 Aug 2024 13:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723728873;
	bh=lwJFPvVfUKf9WASlvvAPIpXYQ4DXBpO7qJf2fNtoOMM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=igocpjuBqE8tXYE/DEf/ZmOZeRl0J2R1U6zJDVl5khjx0VliLFRCV53a9A1aZIV+A
	 htIpfenOa8hx6XQA022iq1PS6Jdec8sZwycud3aFPsZH763h3AUVKDE9zDkVAVcZ0/
	 9DGS9lzkCQ1w0zzijVbzYYtr/daogfLO5q9D6n3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 137/196] PCI: Add Edimax Vendor ID to pci_ids.h
Date: Thu, 15 Aug 2024 15:24:14 +0200
Message-ID: <20240815131857.317030225@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131852.063866671@linuxfoundation.org>
References: <20240815131852.063866671@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 3ac7b92b35b9d..91193284710f1 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2136,6 +2136,8 @@
 
 #define PCI_VENDOR_ID_CHELSIO		0x1425
 
+#define PCI_VENDOR_ID_EDIMAX		0x1432
+
 #define PCI_VENDOR_ID_ADLINK		0x144a
 
 #define PCI_VENDOR_ID_SAMSUNG		0x144d
-- 
2.43.0



