Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16322F9D4;
	Tue, 14 May 2024 11:59:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687948; cv=none; b=qpfI0yWcuqUSrKofdyvop5SjYZc5v8fRoppx79nX187Mo11FRHgy7S+LlHr0V8vzG2Ev0RkwEr22vUReu4Zk2mEEges1TN1mmPxF2gwrace476pAxiqFtYr/YtZ5RMMO10Llrqq7WbvXMIzPDycHgXN8ZT1/CWPtbYclSWUSeY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687948; c=relaxed/simple;
	bh=PzYECumVNweACoihCkiR5HseUw6jIP+J3+t2i7iMXlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oK+yfdWa8qSKx60j3MnB4LABpbVvWVTj1OoquiVXDFgSpXrCdDPtli0GZdQFlIpiOfm/SU+MWG20ieK1Sz01ByW2PMwnwh9J7QFX7vP7ZFPME/L0THlmDdY+aGkR436Luto0I3DdQldc1EVWaJMirl09VdRTVciOlzWZjU1sj+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KmGDXWU5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KmGDXWU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 882D5C2BD10;
	Tue, 14 May 2024 11:59:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687947;
	bh=PzYECumVNweACoihCkiR5HseUw6jIP+J3+t2i7iMXlE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KmGDXWU5Fumqq1H8XSRUl2OQc8el7HuP+R47KXTXlJbz4eI4FSGZMj9kBfU+WKttp
	 rKZKGIqACgow1YUEr/JnOWYqKjbj/eZ0Vudq8aLhLb9dp0KVNe/VtzL5yaGobWe63G
	 Yjga/jDsdLpoFOfezi9j9Ed92T/Mqhg3dQkLEVog=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.15 161/168] mei: me: add lunar lake point M DID
Date: Tue, 14 May 2024 12:20:59 +0200
Message-ID: <20240514101012.835845569@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101006.678521560@linuxfoundation.org>
References: <20240514101006.678521560@linuxfoundation.org>
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


