Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0931121ABC6;
	Tue, 29 Apr 2025 18:03:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949837; cv=none; b=USSZeFgJkPQPESPn0bOHEIaW7h9CnRcTncIDlXjWZL6ZjRlo3Qq9uY/r1Sj4H7w7QdX+DcaToNrdJ+8L+GvyqWVWLoyyHprMMFY++w9xc0mMXywMTYQjg/F29/THcSu3G2s2dQvh/sJgZNz4Qh2Eu+kVPRqu4WAgGQ9hxJzVDug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949837; c=relaxed/simple;
	bh=fufFM2Usaj09oI811cyg54t7fBWyaJk8hS2blmLMDsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ppb8mt91N2pGMJdFMmNK6I9TMBUkY2flF6/SDTYelSiLnge3ZwhRrgZvDn1FIVxRnjz3GUPKKK8eoK2Lj5Q7vH/S1V6QNjpXUtE12xBGYxF+5pGmvobJhI69Ph6xnYwFVX04isATQNTnQ4l8X/8JOF8jvSEXjkei8XIAGUCNmeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UQ2Xn3w1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UQ2Xn3w1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61818C4CEE3;
	Tue, 29 Apr 2025 18:03:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949836;
	bh=fufFM2Usaj09oI811cyg54t7fBWyaJk8hS2blmLMDsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UQ2Xn3w1vDbvET/0U3EXsS+my2jLHbsHNM0tYn7YwSfJW8omSUpfO1X2ZtFFMlb2C
	 XcdzheWU09sd/PSZpQeepNaTVMDS0E5TmwO/VClMXQ8PH36Wws7+zxUU1IG0+0ONX/
	 6esYEG+NY/msjOXmvvFL4AleTGSi79V9jizWSnUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Tomas Winkler <tomasw@gmail.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>
Subject: [PATCH 6.1 073/167] mei: me: add panther lake H DID
Date: Tue, 29 Apr 2025 18:43:01 +0200
Message-ID: <20250429161054.718262888@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Usyskin <alexander.usyskin@intel.com>

commit 86ce5c0a1dec02e21b4c864b2bc0cc5880a2c13c upstream.

Add Panther Lake H device id.

Cc: stable <stable@kernel.org>
Co-developed-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Tomas Winkler <tomasw@gmail.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://lore.kernel.org/r/20250408130005.1358140-1-alexander.usyskin@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/hw-me-regs.h |    1 +
 drivers/misc/mei/pci-me.c     |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/misc/mei/hw-me-regs.h
+++ b/drivers/misc/mei/hw-me-regs.h
@@ -117,6 +117,7 @@
 
 #define MEI_DEV_ID_LNL_M      0xA870  /* Lunar Lake Point M */
 
+#define MEI_DEV_ID_PTL_H      0xE370  /* Panther Lake H */
 #define MEI_DEV_ID_PTL_P      0xE470  /* Panther Lake P */
 
 /*
--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -124,6 +124,7 @@ static const struct pci_device_id mei_me
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_LNL_M, MEI_ME_PCH15_CFG)},
 
+	{MEI_PCI_DEVICE(MEI_DEV_ID_PTL_H, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_PTL_P, MEI_ME_PCH15_CFG)},
 
 	/* required last entry */


