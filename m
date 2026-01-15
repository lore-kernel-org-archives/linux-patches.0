Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8663B1A08AF;
	Thu, 15 Jan 2026 17:10:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768497043; cv=none; b=DJrzUfDG9QnHRzkv7WmdBcPwnn1UP7jk4lzFGDNWr32YLGQIXbd3Rou1MrGsRN5SVXti9cpgu2/3eDzjYsYf7Rkcp3jYd34vqmxF/74BmpL7voti5oSFY8O4Axik/zUy/rIR9KSiQhxCqHuMMLIJ/VwHFT48iDLXV2V/FDJCwK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768497043; c=relaxed/simple;
	bh=rQ6m91mdkPQG3vise2l2fkWWR1Ja9hucj3QbnxhRwZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y2gJl2jsc9eGA+j7OnUs/uOQ7zpVREby6/IF2v1tX7NdG9g9Kj1bms8/9T+FozFtjLPgNKOn+b8Jxq6af1uwDGLaZbHYLxEzDru10EYLIKiRi9eu86OxluHsaRxxojypOBypKfFkpg4K8v03raA65WqC85UZua7x2p7HcA2Z6qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D2pc1BK0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D2pc1BK0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13334C116D0;
	Thu, 15 Jan 2026 17:10:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768497043;
	bh=rQ6m91mdkPQG3vise2l2fkWWR1Ja9hucj3QbnxhRwZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D2pc1BK0HBSwLJLKfpDVRBHrJuTHPRoewmQjA50zeYC+Xtxcfx90Azz+FlanifOUj
	 YF+0q4q2+LjBlg+Na0PQV7I4VdPQb1QyJex42lae9Gmw9yOvjJtRLzvd2fZzb2MaZp
	 kYVU5WoiNn8BDLnnwmvcPme0lhw1gmtJhUs+/sZs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 6.1 04/72] mei: me: add nova lake point S DID
Date: Thu, 15 Jan 2026 17:48:14 +0100
Message-ID: <20260115164143.650227365@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164143.482647486@linuxfoundation.org>
References: <20260115164143.482647486@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 420f423defcf6d0af2263d38da870ca4a20c0990 upstream.

Add Nova Lake S device id.

Cc: stable <stable@kernel.org>
Co-developed-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://patch.msgid.link/20251215105915.1672659-1-alexander.usyskin@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    2 ++
 drivers/misc/mei/pci-me.c     |    2 ++
 2 files changed, 4 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -122,6 +122,8 @@
 
 #define MEI_DEV_ID_WCL_P      0x4D70  /* Wildcat Lake P */
 
+#define MEI_DEV_ID_NVL_S      0x6E68  /* Nova Lake Point S */
+
 /*
  * MEI HW Section
  */
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -129,6 +129,8 @@ static const struct pci_device_id mei_me
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_WCL_P, MEI_ME_PCH15_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_NVL_S, MEI_ME_PCH15_CFG)},
+
 	/* required last entry */
 	{0, }
 };


