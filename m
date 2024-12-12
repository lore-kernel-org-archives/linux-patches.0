Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB184F218;
	Thu, 12 Dec 2024 16:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021208; cv=none; b=rjqJPni+SryvMMKwWznVrx/ne3mmk4zz4vyA6On0oer1Py5Dj4WLZcjfjFrrZ1SEn6YNKhQQ18dk58wQhl8edhzqDrqL8lPK/TyS0BJ/DTD6Ko/3rWl3EhTC8XC1aEhzmpctkJP2HruuFca859useXQjrGZkm9xN6g9FJiMp5wk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021208; c=relaxed/simple;
	bh=UI3CpgTB+NPMtBsn65XKctQm6b79vgf5gwB/PJ0yy5Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9SEgY1aUu/vfUdWVlks9kAaHho0cWHRR86othwRHPCJkTe7ki1eFv7zZBzlhqiZO0pTHELjEMzjO/VHtfNgsWe84P9V45eH+S1pmA6zrmLDRhKFn8qvKiQhbKaKZJs1GtkseegeAcXF6ovMXiAlm5kOM7lzjxOg9NBSGBUGVtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z20i9TmT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z20i9TmT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBBBAC4CECE;
	Thu, 12 Dec 2024 16:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021208;
	bh=UI3CpgTB+NPMtBsn65XKctQm6b79vgf5gwB/PJ0yy5Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z20i9TmT8rwsAfPQIxKNDRJr4ZrcFzhE5hGtkakwIiM2CFVC2pT4LuUKFcJmz4aqU
	 C7EjhLrbUbun49OgPPsTGawazMLKnGLprBWILMYyVpazvntYC3ncSeDoxf1TDbF9z0
	 tVQLOMfgaqyrbh5JtP4+t0xWVKJb8uyA4NTODG2s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 675/772] wifi: ath5k: add PCI ID for Arcadyan devices
Date: Thu, 12 Dec 2024 16:00:20 +0100
Message-ID: <20241212144417.809964387@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit f3ced9bb90b0a287a1fa6184d16b0f104a78fa90 ]

Arcadyan made routers with this PCI ID containing an AR2417.

Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://patch.msgid.link/20240930180716.139894-3-rosenp@gmail.com
Signed-off-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath5k/pci.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/ath5k/pci.c b/drivers/net/wireless/ath/ath5k/pci.c
index 35a6a7b1047a3..f583e0f3932b8 100644
--- a/drivers/net/wireless/ath/ath5k/pci.c
+++ b/drivers/net/wireless/ath/ath5k/pci.c
@@ -47,6 +47,7 @@ static const struct pci_device_id ath5k_pci_id_table[] = {
 	{ PCI_VDEVICE(ATHEROS, 0x001c) }, /* PCI-E cards */
 	{ PCI_VDEVICE(ATHEROS, 0x001d) }, /* 2417 Nala */
 	{ PCI_VDEVICE(ATHEROS, 0xff16) }, /* Gigaset SX76[23] AR241[34]A */
+	{ PCI_VDEVICE(ATHEROS, 0xff1a) }, /* Arcadyan ARV45XX AR2417 */
 	{ PCI_VDEVICE(ATHEROS, 0xff1b) }, /* AR5BXB63 */
 	{ 0 }
 };
-- 
2.43.0



