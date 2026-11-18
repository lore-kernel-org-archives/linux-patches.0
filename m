Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046270;
	b=hDQls7jgnUaJvzVrPbupPXsoOWfeVXw7EABLbpe2fh912CrKSW88ahU/iEKiSQ/iVgaj
	 suA4knM/Vz73jV6pRXdCtdVy/IrfCrI4FYb0VQ4b0ubAi8yfFW/XcnTidyE5nCfUnWyxz
	 hT8cRAyivFqYm/aIy0LF8eyfCocaGatAJCidEWqAfchJ3xVkvy3OObzRNwqVVsO27D5Hp
	 juEFqpEjOI24A57mvLWf5ymqHsgCfIvsxxHGU+Z1t4Lg1gV9bbrWCuLIl7t8S/scem6dS
	 HvhulaDdePOmMSf7NZxJs2E8XlMApZ+epvK1q+7QxAVUAXVatCyuDeFR5Ut+NXbJn1A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046270;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=cb5lCMs85vIBHsBESTjvHAXK01YDOa7b/bYMDoCeUNs=;
	b=vdqHi59vo82WaWClBGxBvg2ToE5/LLlgxpNUxS1V1uC9KrVDMUheetNpA1MPS++rfAFM
	 Tb0CzvlBy+47BbGcd9BPsqvCKqegftrzyAcCw7dJDhbe1EnKOVS7Ib/06RAil97nGmzie
	 8sFYMffy626O4qgazJnWTOx82TyAtM8/3X+R2hIv18UDGXpzXimDh7V0p8rYgrikKZDXy
	 CtJCMHCyK8qRj+1s1Hz0phZetedWbL5Ge4+M3TcPfa04lRRbMYmzqjeKHN39SgLaUAnWP
	 SDK/cLO2Mu6CrPlXZ8b3Nf/+BY9nM2zoG7yo0x0MkLnd3RqmLq18PStVQoqRwHsicqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PhJlPL8K;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3A3B606A32A;
	Wed, 18 Nov 2026 23:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PhJlPL8K
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A0671F000C4;
	Wed, 18 Nov 2026 23:57:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046270;
	bh=cb5lCMs85vIBHsBESTjvHAXK01YDOa7b/bYMDoCeUNs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PhJlPL8KxBkUQrN00gO3HKhK2JH48WNe2GaeiRzTPlaJiDdwCc9BpRinlqPwMvKYX
	 rhQrdUpXFDy3/0aZGFPw2Fz5CNk1lDX/RAGuV/V5L+4/ZPqxtBYxfwK+nDtXWgr1Ci
	 o0NGmlula8kRSdurMS+lxytHcp3ueRO/wpggQAyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1204/2857] batman-adv: dat: initialize orig_node of unfilled candidate slots
Date: Wed, 18 Nov 2026 15:37:18 +0100
Message-ID: <20261118150244.954592920@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sven Eckelmann <sven@narfation.org>

[ Upstream commit 4eb19a389d74f06901b4cd6f24b996b2e84eaefc ]

batadv_dat_select_candidates() allocates the candidate array without
zeroing it. batadv_choose_next_candidate() marks each slot as
BATADV_DAT_CANDIDATE_NOT_FOUND but only sets orig_node when an eligible
originator was found. In the following rounds,
batadv_is_orig_node_eligible() compares res[j].orig_node of all previous
slots against the evaluated originator. For slots without candidates, it
reads uninitialized memory.

The orig_node has to be cleared together with the
BATADV_DAT_CANDIDATE_NOT_FOUND type.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Closes: https://sashiko.dev/#/bug/linux-b25d9aa4-10bb-427c-a145-ccaadc2a1bb9
Fixes: 785ea1144182 ("batman-adv: Distributed ARP Table - create DHT helper functions")
Acked-by: Linus Lüssing <linus.luessing@c0d3.blue>
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/batman-adv/distributed-arp-table.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/batman-adv/distributed-arp-table.c b/net/batman-adv/distributed-arp-table.c
index b622feb6800fa..5706dfa922e6a 100644
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -583,6 +583,7 @@ static void batadv_choose_next_candidate(struct batadv_priv *bat_priv,
 	 * NOT_FOUND
 	 */
 	cands[select].type = BATADV_DAT_CANDIDATE_NOT_FOUND;
+	cands[select].orig_node = NULL;
 
 	/* iterate over the originator list and find the node with the closest
 	 * dat_address which has not been selected yet
-- 
2.53.0



