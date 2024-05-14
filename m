Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606F556B79;
	Tue, 14 May 2024 11:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687468; cv=none; b=EuKgNwby899cHIAn8Od1Ua606NoLgudwskxXBwGShfYJ8rjCtQUGb3B2IMf6yUPnBx1YS0AOqjfPP8i+wZ3qMGN5Zi8HnqddeTFsr9bGo6no8pb5T13NDEDIS9v/M1YLjpFRxrHjvNfmMr5A1NUoU9h+BAE5i4oRdsqoLwkQA+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687468; c=relaxed/simple;
	bh=HNwmx20SnWQY639Awp9bDeg5/Eg2NmtwpEt9Szfc0g8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P2683kd2aG+4Q5Iqw1QXI5t3+LfM01SZOxE2m4ZacLGFTje6usvZ7YkAgT5fpsMJU8TdvopBtyhyH9HEVgFT6CIzuWuUKUnCBO9gpRfMchUauNvRCW3ZhOvjrkVtuqTzZboL+TwRgLPpqb6fQkyjWcw8KlxUD9Sj7Z0AkakgEkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KcC7WW7P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KcC7WW7P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAC67C2BD10;
	Tue, 14 May 2024 11:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687468;
	bh=HNwmx20SnWQY639Awp9bDeg5/Eg2NmtwpEt9Szfc0g8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KcC7WW7PaAYL10nageCsJ22/fl8GX5v6Pi9cy55hISE7tUM0TDdJTQbqf9MkWnvYk
	 WsS+8Y0qXQBCWb54PdUQO6P6znwV0n8FvUsp8yXOkcMCqbql4IwsK4RSAmJbJnCN2B
	 v3Aepl4pDrchPvwa/sjOszjxA3FY+kiC4URcNffo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.10 107/111] mei: me: add lunar lake point M DID
Date: Tue, 14 May 2024 12:20:45 +0200
Message-ID: <20240514101001.198396183@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100957.114746054@linuxfoundation.org>
References: <20240514100957.114746054@linuxfoundation.org>
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

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 4108a30f1097eead0f6bd5d885e6bf093b4d460f upstream.

Add Lunar (Point) Lake M device id.

Cc: stable@vger.kernel.org
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20240421135631.223362-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    2 ++
 drivers/misc/mei/pci-me.c     |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -115,6 +115,8 @@
 #define MEI_DEV_ID_ARL_S      0x7F68  /* Arrow Lake Point S */
 #define MEI_DEV_ID_ARL_H      0x7770  /* Arrow Lake Point H */
 
+#define MEI_DEV_ID_LNL_M      0xA870  /* Lunar Lake Point M */
+
 /*
  * MEI HW Section
  */
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -121,6 +121,8 @@ static const struct pci_device_id mei_me
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ARL_S, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ARL_H, MEI_ME_PCH15_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_LNL_M, MEI_ME_PCH15_CFG)},
+
 	/* required last entry */
 	{0, }
 };


