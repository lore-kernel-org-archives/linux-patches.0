Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A912153FC;
	Thu, 12 Dec 2024 15:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734016891; cv=none; b=EGhYannuaDXDzNehE9TinCL1eotZq/E+moE7ba2JqSEGYrn5crgSnUJYqaKCYnelC2rZj7dDl6qA9xcpuA5YxQd4SLHJUdVJdvouDPSI3A8clJaqUyF5IB15hyIfad1gEICpPi+SyTj7KSWNeGsMKQWZvR/P+vyog7GGJSYezEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734016891; c=relaxed/simple;
	bh=TyjmSPBqkuq/ddz52Qo2jMFe0dlLT7R00X+1RIZyMWs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6JNBGxm1H4y7RAu7v8fFktWw+2VOr0vk5kW0aEabI12zH9zRH0LJlPut1W7YPpI01/fOoI2HFZYnOY9UATinrjrz9KCwTOIQ+xhklB10ly0ydnOaHMNlVQDm1m3E9t8tJiPVttd3qxewYRRuJgi++LQLqLC3SXW94ZiU8BiWxQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HjQhQ7qM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HjQhQ7qM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B5DC4CECE;
	Thu, 12 Dec 2024 15:21:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734016890;
	bh=TyjmSPBqkuq/ddz52Qo2jMFe0dlLT7R00X+1RIZyMWs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HjQhQ7qM4vJea/WNs06gCFhDQoGFwNl0Ya/apA1BpkD+kKumai8sU8bqfDnbBPy9/
	 z+m7L3Jgx8puALJQYpxTQFFNEuB3sZ1V8/JOYPiOWG+aNkEsVqyfhK+9EffM9qik/v
	 lJ4QzBwQwtZLS0SoodxCIy0btwIpPxZtyckHQeAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 295/466] wifi: ath5k: add PCI ID for SX76X
Date: Thu, 12 Dec 2024 15:57:44 +0100
Message-ID: <20241212144318.439210565@linuxfoundation.org>
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
index b51fce5ae2602..b3137f60e8791 100644
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



