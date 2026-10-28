Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210945;
	b=L2FiKMEdBM/w2Nj5pAp0EFTx/arFnWuDPtjWEj8S7pEd1R1kdnEUEw/SR/w0Bc8ryY7c
	 BO9KvrsoRgD8SwMNjMqSSsYBoTnojflD8GsdbptRwYochNY4JskunCn9rEMRg1Hv49WmZ
	 YoGUFVQryVvR0qH1xHTvgUcyNltoEg1bLk/mpgZ3pW8EPdSaEE+I9cRkgmKATZZpxJjwf
	 z90njxw3PRcdyvMVXXGPbZ6nqnpK6lGkTHrshxdBOLgaJVAuSMGtoQX/EpaMb7ms74WfC
	 N18typbVAscw6KOzYHWtafdiGxPhqmGZozKzWxArFJeqWFyso806yI8FvzFSQtHqLIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210945;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7uThLKcm67kTlYEbrKUC+J3PKyiN+xp80d3Ubhzf+C4=;
	b=noFGRZpCNeAOOwDlsD4f6FJAyqLyq3Qj1A0Xj30ZmcrTMMLcgMNyzW6qpZtQCweD8uau
	 9svhUtcd47W8pKv5nPus7gy+3BnmEuSVFdyHIXiqcrTzqqcDY5z1kCwAppXHK/fwNnY/L
	 0H7ZRc9h1bPagl/if8O3BCh+TgkxnyM97swqzTZDivJsafF8PayovPiC3faCnrUrYfSUL
	 E5g8po69RyAVs5QZ2oZjgjvM+N2JreWTt9fF4i3wWB9ijvoWdMzX5XEbux/B7FIcQwXmG
	 Wq5GIw4gdXsBgnYWcjcbkNdfKQ2e+ponH6Lt5ZIh4lKfFk4JS8DhslggriOz1RYJ5bg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VTNliJ6S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0BDF606A325;
	Wed, 28 Oct 2026 18:09:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VTNliJ6S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 148B11F01825;
	Wed, 28 Oct 2026 18:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210944;
	bh=7uThLKcm67kTlYEbrKUC+J3PKyiN+xp80d3Ubhzf+C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VTNliJ6SieUzq7RHo9HnYv1r2N7wWjAvPqKaCqHkGluQK1/qvCqiZXRJ//MsD6Vmb
	 lUx4yTXFmyLQ9off2E0PcrA7xMc4ZETWhu2bHf3Q37fc9VXlQsuc6IKS4ub4Vx+e/K
	 0VsVdGR7Ocs7AbkS9XhJtPi32oybsr36w7El/yJ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 177/571] net: systemport: Fix RUNT MIB counter register offset calculation
Date: Wed, 28 Oct 2026 17:55:24 +0100
Message-ID: <20261028170012.212274833@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <florian.fainelli@broadcom.com>

[ Upstream commit 242935adfeb096f09b29fb2cfcf12f9eb2911fc6 ]

In UniMAC hardware, there is a 0xC byte gap between the RX MIB counters
and the TX MIB counters, and a second 0xC byte gap between the TX MIB
counters and the RX RUNT MIB counters.

In bcm_sysport_update_mib_counters(), 'offset' was only set to
UMAC_MIB_STAT_OFFSET (0xC) for all non-RX counters, omitting the second
0xC gap for BCM_SYSPORT_STAT_RUNT counters. As a result, all 4 RUNT MIB
counters were read from unmapped gap register space.

Fix this by setting offset to 2 * UMAC_MIB_STAT_OFFSET (0x18) when
reading BCM_SYSPORT_STAT_RUNT counters.

Fixes: 80105befdb4b ("net: systemport: add Broadcom SYSTEMPORT Ethernet MAC driver")
Reviewed-by: Nicolai Buchwitz <nb@tipi-net.de>
Signed-off-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20260922232440.598918-6-florian.fainelli@broadcom.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bcmsysport.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bcmsysport.c b/drivers/net/ethernet/broadcom/bcmsysport.c
index fa140c5175a65..055ab74d861b2 100644
--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -422,8 +422,10 @@ static void bcm_sysport_update_mib_counters(struct bcm_sysport_priv *priv)
 			if (priv->is_lite)
 				continue;
 
-			if (s->type != BCM_SYSPORT_STAT_MIB_RX)
+			if (s->type == BCM_SYSPORT_STAT_MIB_TX)
 				offset = UMAC_MIB_STAT_OFFSET;
+			else if (s->type == BCM_SYSPORT_STAT_RUNT)
+				offset = 2 * UMAC_MIB_STAT_OFFSET;
 			val = umac_readl(priv, UMAC_MIB_START + j + offset);
 			break;
 		case BCM_SYSPORT_STAT_RXCHK:
-- 
2.53.0



