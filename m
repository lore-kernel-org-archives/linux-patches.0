Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702BB213E6F;
	Thu, 12 Dec 2024 17:32:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024757; cv=none; b=qbtFreZdGo03kXP/stLTMuCm3N5qVic5fblvFda32gFGl7n3Ngy9/k/BcmtdXrtappMIFAhb9oozVTpd9FZpsdMGorkuNmNjXbHHHV/hrOKi6yDiePCJyEkk0QcqAGDStn2hBVmTh81HWy4y8ykmsIgXj/cViAgQHIIt9txWuH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024757; c=relaxed/simple;
	bh=GxjP/WVnM2eIj0u/MPXt5AnjpfpS2sxpDelpOlud2JE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3Wy9vG4TO8U6/5KE0HC1dCdesaYE5NKTwAEfbDeFxVnhwNY3VZxZptJetQ2jvSRnia4MLw0dz0d18GRlhHWNMTKqDUjB7svwdpj0fI0mWKnkb8HRN27VkPUD62dSa7UNJaHYhaIHEtlqS0kvsLbDImh6wTfIl87fGDX005WJro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yUHfzjwz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yUHfzjwz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2C8CC4CED0;
	Thu, 12 Dec 2024 17:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024757;
	bh=GxjP/WVnM2eIj0u/MPXt5AnjpfpS2sxpDelpOlud2JE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yUHfzjwzX0PtwUdSK6O7V+75JYSG9dBdI/OvO8o3jZ+e537CKRSZXZxrUWIA/cJ7m
	 7TJ8ToWwaAGBl95zXeXMU1hBU6LfBXrK2VYjTS6rgv4KyxprMFFMePHxcxri72aDNo
	 KT3OCTfsJoAIJ2eq9uEz8KCbCUZ5dXGhoyRUgZNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 401/459] wifi: ath5k: add PCI ID for Arcadyan devices
Date: Thu, 12 Dec 2024 16:02:19 +0100
Message-ID: <20241212144309.605659246@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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
index 0892970a99637..e8f557423ac2d 100644
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



