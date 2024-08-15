Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3882D1A0710;
	Thu, 15 Aug 2024 14:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732729; cv=none; b=JwxY+LI9EG0zl7FHx0VhouKwlGxy9RA+siJgEp31ZtJ5BIYK5l9wNuiKC+FqhOfiYtEHGRS2jHYeFFsC5HzSCTMIFa8bNu2l85xIipLmljf9sTI9HE87aJvJMXpFt00++aoM23MPeVtNFvadLpGbcAmGUQOEjKEwakZyQQVqi04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732729; c=relaxed/simple;
	bh=XsMQGKx4djBXik5Vm0afr1lJAS21+fL19WhSwCnMhTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=g6loZ6a7SXNh9RG1Ca1YUYzQqo4HIIy8IlSHPPuAMSRwIZxoSaDj0mXDkxl4O0idI2pLzpXA24rOdwrsDOzQiWV6BbV+5egNh8Zz3T/EOIMD7rS2EY7tHW9b2VK/A3PzVTY3LB4N5xMWgPqVynjzLryJ6kGqhjKrWFypAQIrORQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OcxFH9Jm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OcxFH9Jm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B518EC32786;
	Thu, 15 Aug 2024 14:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732729;
	bh=XsMQGKx4djBXik5Vm0afr1lJAS21+fL19WhSwCnMhTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OcxFH9JmlwF/Kz1RIqtA6j7UmxJJd8Xp0ZThqRAQd+sQjDqvT6ChuJGYkviL2HPkF
	 WF0ojNzz6859rs8A6jMU75ruZXAkMcbducRIKpVjMXZZVRpBof540HBxFShQMdelBl
	 FMUDF8/zbtzJWoDlWL5k6oUYgtA2cyHDBm9vZPx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 268/352] PCI: Add Edimax Vendor ID to pci_ids.h
Date: Thu, 15 Aug 2024 15:25:34 +0200
Message-ID: <20240815131929.804041892@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 80744a7b5e333..b2418bfda4a98 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2137,6 +2137,8 @@
 
 #define PCI_VENDOR_ID_CHELSIO		0x1425
 
+#define PCI_VENDOR_ID_EDIMAX		0x1432
+
 #define PCI_VENDOR_ID_ADLINK		0x144a
 
 #define PCI_VENDOR_ID_SAMSUNG		0x144d
-- 
2.43.0



