Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45A57DA7D;
	Thu, 15 Aug 2024 13:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723730326; cv=none; b=l3HlQK+VUkeM3Rq3UTel2fEckqlkchezJ+2zqiU76kTExEw7SDGqJmAAUk2e1OD9yc9RXXI1ggRHhF0SYM311smU2pXz+ed2oGqhtqEsxeD/clpvS3FK6K5kfKbbiPwBrriGUQL2RK+0WSQJvE6KuyHJ+pUg/KfXatdxApjIqoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723730326; c=relaxed/simple;
	bh=l32XORWvp2RFclzlfOOEDwgOTZ9z84PQh4BLhqUN0GU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fmNjLKBKyS2oJOJPwI821m6L/jUHd4xFYZVG31CcfNkqXJFci4hzTUcf/Y51g04xmGPkxRUZWdecCfW8pEl2eXYOaQQDhfUWyGrxKjsv9GP9B5I2rdEt7uDGSo4dOxM63M6ANpGPr+AlUyTbJ7Ad6ROsoXQXmPTIUbZsaqLS39c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B/9UAOUr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B/9UAOUr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5FB6C32786;
	Thu, 15 Aug 2024 13:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723730326;
	bh=l32XORWvp2RFclzlfOOEDwgOTZ9z84PQh4BLhqUN0GU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B/9UAOUrYtN+M4Tnha4Zi4HcXhpx8EnWWbw6zVlyOnTHuAZAbdMXTjthtmy/ToVPP
	 HhMAREtwXabL7M14Musyga86wVgymJiXr8UaeNBuvFakOEmI/sSt9DJtQv4S6kpzKi
	 Md6PGo6uCyQsf49wHFwDozFJ1378mSWOChxrORoA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	FUJITA Tomonori <fujita.tomonori@gmail.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 374/484] PCI: Add Edimax Vendor ID to pci_ids.h
Date: Thu, 15 Aug 2024 15:23:52 +0200
Message-ID: <20240815131955.889907949@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 2590ccda29ab9..66e95df2e6867 100644
--- a/include/linux/pci_ids.h
+++ b/include/linux/pci_ids.h
@@ -2113,6 +2113,8 @@
 
 #define PCI_VENDOR_ID_CHELSIO		0x1425
 
+#define PCI_VENDOR_ID_EDIMAX		0x1432
+
 #define PCI_VENDOR_ID_ADLINK		0x144a
 
 #define PCI_VENDOR_ID_SAMSUNG		0x144d
-- 
2.43.0



