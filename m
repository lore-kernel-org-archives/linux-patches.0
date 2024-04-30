Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B194612B176;
	Tue, 30 Apr 2024 11:01:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474885; cv=none; b=JkgmcO2KMQmpNDAAzj3cVKdJqUJqr3wVKJRJzsR+iTJcuSSEn6GEIHU8MmQ+5e0sx0+RdCocJtiXrgAaxTmgx1++sABIqhoLSd35CU0dXk8ysW2pMUTUnl70CB6P5c1cYIxx5gdxLBZR1mBmGHnRV19RkxEUyadBIkjqlbY7XzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474885; c=relaxed/simple;
	bh=FJ5WJInlAGYh3sz6qFrWhDp+XrviwiBff/CNsSoJR9c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SjqpnjBqTwlItWKdhNWqud41XwBhfFe5TGbBCiLRrP90WSJrXg2dzFicUaBeyLQiPXQ7EPQ2iUr8Dx7wWQvcLLYHDCT9QMwRdV8/b9Z9kQZz+Rj0Hw3Ygte4oz96vHPY2GNg5SS/dOpljBw6qpEUmac70oK8invaBqcRXr61388=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RnLrXBvc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RnLrXBvc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5BCAC4AF18;
	Tue, 30 Apr 2024 11:01:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474885;
	bh=FJ5WJInlAGYh3sz6qFrWhDp+XrviwiBff/CNsSoJR9c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RnLrXBvc7QCB7cbpgCL/jm3eIlCCKzHjbnjgO8xrzHbvZIHOWFicXA38WYbO2uJoh
	 95NNtDSsQ5PkGhPSgJlDBOc3zoM9svAll2djI7IPQ0TxyRtYWFlMuxwkWovtUGWAbe
	 RfiKvlahIm2SHH0E2HeSsSwYWZD4vhwZnL5ZhQYQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: [PATCH 5.10 065/138] mei: me: disable RPL-S on SPS and IGN firmwares
Date: Tue, 30 Apr 2024 12:39:10 +0200
Message-ID: <20240430103051.337123111@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

commit 0dc04112bee6fdd6eb847ccb32214703022c0269 upstream.

Extend the quirk to disable MEI interface on Intel PCH Ignition (IGN)
and SPS firmwares for RPL-S devices. These firmwares do not support
the MEI protocol.

Fixes: 3ed8c7d39cfe ("mei: me: add raptor lake point S DID")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Signed-off-by: Tomas Winkler <tomas.winkler@intel.com>
Link: https://lore.kernel.org/r/20240312051958.118478-1-tomas.winkler@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/mei/pci-me.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/misc/mei/pci-me.c
+++ b/drivers/misc/mei/pci-me.c
@@ -115,7 +115,7 @@ static const struct pci_device_id mei_me
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_P, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ADP_N, MEI_ME_PCH15_CFG)},
 
-	{MEI_PCI_DEVICE(MEI_DEV_ID_RPL_S, MEI_ME_PCH15_CFG)},
+	{MEI_PCI_DEVICE(MEI_DEV_ID_RPL_S, MEI_ME_PCH15_SPS_CFG)},
 
 	{MEI_PCI_DEVICE(MEI_DEV_ID_MTL_M, MEI_ME_PCH15_CFG)},
 	{MEI_PCI_DEVICE(MEI_DEV_ID_ARL_S, MEI_ME_PCH15_CFG)},


