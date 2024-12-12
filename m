Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E2776F2FE;
	Thu, 12 Dec 2024 15:45:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018325; cv=none; b=MJ8DGDRyaesw5yOYW7H7bKZMb4odhRTVFghVbi8O22343PLOjy3E0q9KW1Bsjyp9b9gS2VDtxcdE07Q6Q1DXTWEFXzVcRqIhxNsa6lY2RtWGNOI6FY410HEgdmzdZpkD3glSIyP3VzrOhBmZbOuvIn+mI2fLaeL7Ra9ouQhZLsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018325; c=relaxed/simple;
	bh=F8a/zE5c5ubtLNF8WYwp8s6YmKziNPNbyOe/frkvMlU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HbZ5e+6YyXXskl17gbr7OOyMtatl3toe9msHM+fLNjWFrpPER4seex3ADzYJ4Qhw3lP5X/DMAytRlqJgLHmMR7MA8qso25z3FrCV3oliiITVnPXPB2WRNQo1aTx6bhmnhsIXT/c7aacA7kqb351pb27nhPfENto9ZQIjuJIQcF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iE8ehgg+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iE8ehgg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F26FCC4CECE;
	Thu, 12 Dec 2024 15:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018325;
	bh=F8a/zE5c5ubtLNF8WYwp8s6YmKziNPNbyOe/frkvMlU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iE8ehgg+3Gyud/qpCSQJJwQI3bAaEwGAMNGSKu6FpbjtG74VgOEdZ+Q1ibT85ugyZ
	 m24c2aVikTCnL+TU1W19p5hLOWJgv/wlehQVjNlWNJQzMtYoz50wWav5CG3D07xfkB
	 TefePij2AuoOUykiPsLKqJ8TkA76fiQB9uSTxBME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 231/356] wifi: ath5k: add PCI ID for SX76X
Date: Thu, 12 Dec 2024 15:59:10 +0100
Message-ID: <20241212144253.749855399@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 86b8cb975b1ac..35a6a7b1047a3 100644
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



