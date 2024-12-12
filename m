Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D92215764;
	Thu, 12 Dec 2024 15:21:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016894; cv=none; b=Lg0Mr+lvUbpbVB3666sR8TW4Y2y5OJlvS3z+q/TNxS5BI3C9z1IER4HFYR5ocraUrPlk4OgJnibjisNHo0T/25hslRrgoW+7LV4XoQBOdETYz8UY8/vTQr/bHfQVbxzR3suE3ZOpxopQ0TOL0oZxpoQIKfgFZB33uGU4QVOccsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016894; c=relaxed/simple;
	bh=XKa3Pzrvkg3T4biLG+HXER//Go1XftwJENesiAjq5zc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jfe46QXl0Dd/9Qz0MO2LWU8qbF7y1dLDPr43x5oNVfb/wIO5Q2fG54tBREiQmt2dIZz5QqsqZKplqzKu1PMS3OTqG/BCGrGyHpVhlvYv9zSucprWTBAjJDhk4UIXF+UtT6Rdb+hzLqpcgcHch04GqNLkuuDBe5tdxkfSknOB0/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bc5XQ0FD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bc5XQ0FD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB638C4CED4;
	Thu, 12 Dec 2024 15:21:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016894;
	bh=XKa3Pzrvkg3T4biLG+HXER//Go1XftwJENesiAjq5zc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bc5XQ0FDocgsg1tWHytyfqSYZs/tGtmQsboAkvsiVb1vkYxlioHViITcWFtzNFk01
	 Hpo4QMlMWvszV71kpZNBV+yh1+tJYwvgMAMAHltcZhrlr3ZHujJxicTgZXMkT2a77n
	 tiYKZu/7u0DUcpuIw2Gm7ODiync3JrgBMwa/F9Eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 296/466] wifi: ath5k: add PCI ID for Arcadyan devices
Date: Thu, 12 Dec 2024 15:57:45 +0100
Message-ID: <20241212144318.476457230@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
References: <20241212144306.641051666@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index b3137f60e8791..f5ca2fe0d0749 100644
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



