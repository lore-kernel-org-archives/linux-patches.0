Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15057176AA1;
	Thu, 12 Dec 2024 17:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023308; cv=none; b=AZUn04jzGuSSvvdwLmuKOpyYJZjHI1lXQh0+1aoF4fGFusBlxaACvOIE5Unzt6jxIo8OGFR17yBGjFhDjvIbs3RnOjZp9oZR7cJGfBvPe7M2ik3GqbFRzUlHGbDC7Uwvzqw82WqD+x6xFVmBTF9eS9GresKQoPbFCfcHw24ur4M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023308; c=relaxed/simple;
	bh=jMaN16uJ4KqkGdCgzOt2ILQQKR0Gl/ndlNiQUsQjEkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E924NkV91jboyPT6y7tsj6X1md/7nG+xYnykRxSW7jDRNkTUh0YDdYH3ioQm3hxNLKc9iySZYAHBBs1+YX7wYM0v77NvEiSUPlZsapEJyNCFkQJ7NOKHpEuwtHlOdssgmFkZyWI5KlFS4xd0Jjih1yWosub2yweQX0GWvRZoiFo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cEMcwoEF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cEMcwoEF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A705C4CECE;
	Thu, 12 Dec 2024 17:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023307;
	bh=jMaN16uJ4KqkGdCgzOt2ILQQKR0Gl/ndlNiQUsQjEkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cEMcwoEFJiUZufbETXobbAVOy3k+Ft1SZtlpa15J0LK6uZ+RH8MgZC+3gTE5CtdX0
	 s0pmM4P+qKdwQ6ILGEIFGvGPZr7oROorJELOskZTH9n9Hb+g3uLcM/MnEuTXjAspLB
	 bU/irSD60BJnu8Fy6QHZrCyasfVlJoBkmFf2uUXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 492/565] wifi: ath5k: add PCI ID for SX76X
Date: Thu, 12 Dec 2024 16:01:27 +0100
Message-ID: <20241212144331.216088944@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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



