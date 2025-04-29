Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B9A188A0E;
	Tue, 29 Apr 2025 18:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950606; cv=none; b=fy5t22U3clK1xfS839j7wFaxcrRRnuRm8+AqT4GNnzIHtYEW/rpJBkQairixbQcomF0VUHkaNbw7+Yj+Z8ItZd4CMQGpav3CZYDfHocnz3d7QnWnkmUhX3APGs4XoOzMrig2we2KkyV8lx2DPD1oNPwA5PUbQlfopcwg3ieDFQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950606; c=relaxed/simple;
	bh=3K3bhizG3PbK0MH0U/G0ueqTJ9br5phob0M70/pvuLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m78aSDDc2RBGbo85KSgtec+yKMAHYjgsjuryyWNHfVENiARAcSfj8ABbpIFdzqf6X5GUXsTqKfX/2p6fSBHvsqudwvDiEMB9YgxIQZr+erlGWwl8KM/CK4/2UFcZDfnq5/IwRfeQQ0Xztez8mSBXgJtly01rOv0W07PEeKKokFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M9q3M5SQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M9q3M5SQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB920C4CEE3;
	Tue, 29 Apr 2025 18:16:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950606;
	bh=3K3bhizG3PbK0MH0U/G0ueqTJ9br5phob0M70/pvuLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M9q3M5SQUGhN2ZB2gMxb7bg93iEFtqarG9sWRLkzRFCLo97au7Mf6KI5JVxYXPDUO
	 UQELnUB/WAyzUNaxkk77/RYIF6Y5t/wGtpbRvLKU5NY6MhDqpKDKmFCbMA7dbWXBtd
	 nGW5UytTRuO11xfPUrKmGA5GuVY7Q2UW+lOflK2o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Basavaraj Natikar <Basavaraj.Natikar@amd.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 148/204] ntb_hw_amd: Add NTB PCI ID for new gen CPU
Date: Tue, 29 Apr 2025 18:43:56 +0200
Message-ID: <20250429161105.478042895@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Basavaraj Natikar <Basavaraj.Natikar@amd.com>

[ Upstream commit bf8a7ce7e4c7267a6f5f2b2023cfc459b330b25e ]

Add NTB support for new generation of processor.

Signed-off-by: Basavaraj Natikar <Basavaraj.Natikar@amd.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/amd/ntb_hw_amd.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/ntb/hw/amd/ntb_hw_amd.c b/drivers/ntb/hw/amd/ntb_hw_amd.c
index d687e8c2cc78d..63ceed89b62ef 100644
--- a/drivers/ntb/hw/amd/ntb_hw_amd.c
+++ b/drivers/ntb/hw/amd/ntb_hw_amd.c
@@ -1318,6 +1318,7 @@ static const struct pci_device_id amd_ntb_pci_tbl[] = {
 	{ PCI_VDEVICE(AMD, 0x148b), (kernel_ulong_t)&dev_data[1] },
 	{ PCI_VDEVICE(AMD, 0x14c0), (kernel_ulong_t)&dev_data[1] },
 	{ PCI_VDEVICE(AMD, 0x14c3), (kernel_ulong_t)&dev_data[1] },
+	{ PCI_VDEVICE(AMD, 0x155a), (kernel_ulong_t)&dev_data[1] },
 	{ PCI_VDEVICE(HYGON, 0x145b), (kernel_ulong_t)&dev_data[0] },
 	{ 0, }
 };
-- 
2.39.5



