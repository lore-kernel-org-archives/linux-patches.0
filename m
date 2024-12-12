Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09C6C2080D9;
	Thu, 12 Dec 2024 17:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734025857; cv=none; b=vDbjATCARaXn7OZ+sH0EEQ8KEqr1iEXxriS8tBBp/KE+LrSxdpHOWWCPgC3TSF0QeoynKUctcqe1Euua7ymcsNdO/wo5LPkansMp0T/L53gZ8eJkSYsGgDFvBaBgc9zm+12lOMuqXIIkrHb2IFU/9XoA4gD87OM3kWYmzn30djg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734025857; c=relaxed/simple;
	bh=bytM5ratefbMU++/FVNYTjy/Dm+JAfimezFQ043Bwok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9JFT91WprNIXCGEgE5PrRVyc/wxtP4AV1F1NrgA16K36ppORetw9koQSDOd8cSjwwruWUGJe+ZtFlf2BY9+PgFrE5Z85KyAc+jlSYuTF869gqDuwMbFpx10N7/SfwecUaJbIBvu34fvnn0c+BqdMPKqRrrmMpTrxEptU7vMlkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZB+dwRuK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZB+dwRuK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 839CCC4CECE;
	Thu, 12 Dec 2024 17:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734025856;
	bh=bytM5ratefbMU++/FVNYTjy/Dm+JAfimezFQ043Bwok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZB+dwRuKnPoj7+PnzJT2/P0xAsGNEFWyyCUUF2wBXurC2F583D+00rW7IwHs0z9IW
	 1IfFE6i2fkFUDy6u5F2ELchNPd/wpksMYUzHc/MRYN21vfI6ZA+AAQOCVUJzMpyL6x
	 HJgNZWLwoGFkuu3jYAdUdMomguz8SFvIkMoF/8ic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 280/321] wifi: ath5k: add PCI ID for SX76X
Date: Thu, 12 Dec 2024 16:03:18 +0100
Message-ID: <20241212144241.039423095@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144229.291682835@linuxfoundation.org>
References: <20241212144229.291682835@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit da0474012402d4729b98799d71a54c35dc5c5de3 ]

This is in two devices made by Gigaset, SX762 and SX763.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://patch.msgid.link/20240930180716.139894-2-rosenp@gmail.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath5k/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath5k/pci.c b/drivers/net/wireless/ath/ath5k/pci.c
index d5ee32ce9eb3d..b7f62c472b879 100644
--- a/drivers/net/wireless/ath/ath5k/pci.c
+++ b/drivers/net/wireless/ath/ath5k/pci.c
@@ -46,6 +46,7 @@ static const struct pci_device_id ath5k_pci_id_table[] = {
 	{ PCI_VDEVICE(ATHEROS, 0x001b) }, /* 5413 Eagle */
 	{ PCI_VDEVICE(ATHEROS, 0x001c) }, /* PCI-E cards */
 	{ PCI_VDEVICE(ATHEROS, 0x001d) }, /* 2417 Nala */
+	{ PCI_VDEVICE(ATHEROS, 0xff16) }, /* Gigaset SX76[23] AR241[34]A */
 	{ PCI_VDEVICE(ATHEROS, 0xff1b) }, /* AR5BXB63 */
 	{ 0 }
 };
-- 
2.43.0



