Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058997;
	b=oEuKDPYAQH/B0p1A+09zVeQzGp9ZMJFrtIn/+MbTbBNd97krlYcLp4ONoJbS8se4bAtv
	 NpGK0EC8QhQ8T5o7GMTRIsjW4lO+HIBf7VwfKiTZj2jne1qlVYnXGWWvnraFxXxriIwFv
	 K9RdAMrG2bogewX6UA9N0mwSUg6nYM/coqIc/ZFnTQKWbXUW3YAIOirxgAkkjppnLADfN
	 x398zR4wuTH2rFyS5k9Jd6fX/4V+rsEiPwNkyp6HhLynEO5m/YN/N8USAidz+aHZeEnTk
	 SSD0iP2aRzELTJjIIgglWkv8yILBzdDm1jTsbx0UIWfuEBpQxHvk7nxbVjJTpmGd8DQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058997;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=X1WuxQDG1+IGSAQegCp3ARvvWnACRVIv7BGDf3G8rd4=;
	b=kmdroFNuxEkqTDYiu7J/dIDMCWHCUm39xcz5KNjbz7WQCUc+wD5EzK+MmuGqpn64rXno
	 ZO+Fv5ymH0orMEnfLnKamQhUgnPyKjOS0LCPcpU8wu/2VPq/0Aw/FfRnifOZmPAFT1yJj
	 1p7rj9aMuO93RvtSceftB2pGSZNphAqIKLQ2m8/xLa733VmaZQ/ZqGrfGcZNxWQkB4evG
	 /tjK8TMfqxxQxSanz+107FEaMKy4shL67uO+P59VinulmU6Nq6ii/aNdkWCiR5TH8JJ90
	 6TswuJ7O/Na6D3qhloN4YnMygU76SU4WxRCpB1EwffmsFDFIWf1KzfPJGXtR9NIsQXA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P38AwmoI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C87606A31C;
	Thu, 19 Nov 2026 03:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P38AwmoI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF2531F000C4;
	Thu, 19 Nov 2026 03:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058997;
	bh=X1WuxQDG1+IGSAQegCp3ARvvWnACRVIv7BGDf3G8rd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P38AwmoIM9P8mtfW1Nb6vNbHLYLm/cz73MHe1l2a+OV1OT3CapvTRyPBgNvNdYJ8G
	 9HCu8hDlM8WEygCNVaZ8gHbeob1z0hPZeFVRQme9wdh29fmoEUAKVO0vT6h9+dNZdi
	 X6yIKcFBFkvbiNHBIQx7o6gltz26cZC6rnKWjR5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	=?UTF-8?q?Linus=20L=C3=BCssing?= <linus.luessing@c0d3.blue>,
	Sven Eckelmann <sven@narfation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0685/1848] batman-adv: dat: initialize orig_node of unfilled candidate slots
Date: Wed, 18 Nov 2026 15:45:23 +0100
Message-ID: <20261118145944.638969604@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 6ff856a803dd1..a3af95b5f42db 100644
--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -585,6 +585,7 @@ static void batadv_choose_next_candidate(struct batadv_priv *bat_priv,
 	 * NOT_FOUND
 	 */
 	cands[select].type = BATADV_DAT_CANDIDATE_NOT_FOUND;
+	cands[select].orig_node = NULL;
 
 	/* iterate over the originator list and find the node with the closest
 	 * dat_address which has not been selected yet
-- 
2.53.0



