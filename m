Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209022;
	b=HYagdCEGpO5mOpxAAvy4RhNqLsAXqblRtLigdpV25ZaknyW+4kjJsBRGMHMEGjW3X8M+
	 sk5hkQwNQ6HYQMt4afgE7hrsESnrxXrFbZezxq9mF3RUdDT6aDfaty8H4XCdCUBNkjXBQ
	 9MmA0XhkAbkE4noab2lBOggG2bHmmscDBOex0Viy1s3TaYSEybwRF/hgkplZcgk16Ng21
	 rGZU82ZM8wU/dQhbuFiQGnQVN+aIrmzzoZbSluPE3yPaSWjSPMAjmYvHggrRb7TtH3Dzg
	 dzqB2j2pvSykJODJvpNvnKXdG7fnMhhqnoQxSXN3wxSE21ugCYejXoJIA/iD8ZVYojg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209022;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=GCWreYiNnMoVsvmhwQf59McuQ6/nLkV5rbexqRgOET8=;
	b=IarNKVHaytb7gaIkKIarJEnctG9PGNOYHvSYTX0MBBgOes4wjitPIcfY030f+w81Ofoc
	 tEqv6Ta0fPlm4XLw0RxA3S81BvY3i1tHAGbQu8VP/5CSwPf2VXCNF/CezJallRHg0pogl
	 1xoL5v7E5LuXSVUk/JYfjv6fRIrisd486S/Jvjnd51uGm60c6QUnFXspQJI5zkRbWYXGX
	 7FmgKvJVTI+L4/aWUe6YeoSDO/Ak/6H4LwZ3+kNXbdfFDceLAet91oSAszmuKIPaK0lMW
	 h+LmszQyh4FwX2pdsjPPrZ4BnVlnlEfl1d9ZU/qEoz32QxvtD9UMUuUcFhKhPbPF17w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K1OLL8IV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BE0C606A31A;
	Wed, 28 Oct 2026 17:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K1OLL8IV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB2151F01825;
	Wed, 28 Oct 2026 17:37:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209022;
	bh=GCWreYiNnMoVsvmhwQf59McuQ6/nLkV5rbexqRgOET8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K1OLL8IVZbPq8Q1XMXMQFIbBUtALh8VzeBW28/NK0KfdNarFUxTqATKSt6Yeu3Q62
	 vTJj7hILDdCj2LW9KF9NNTvXmYzbqdHUh+1jPqX58aZK5lECIaXMBZ8E0QkqSX+XiO
	 Joc7XQt7b+FTF7NVEEpNfXbX32RrHlYekce+d0sY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.10 323/516] Revert "wifi: libertas: reject short monitor TX frames"
Date: Wed, 28 Oct 2026 17:57:55 +0100
Message-ID: <20261028170011.140522390@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Berg <johannes.berg@intel.com>

commit 9727d1c4e1c971fc42b049b645fdda6852758835 upstream.

This reverts commit 13ff543e0b2c713aedeaadadde686686e949dc78.

The 'goto free' just made things worse, causing a spinlock
to be handled incorrectly. Revert this for now.

Reported-by: Takashi Iwai <tiwai@suse.de>
Cc: stable@vger.kernel.org
Fixes: 13ff543e0b2c ("wifi: libertas: reject short monitor TX frames")
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/marvell/libertas/tx.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/net/wireless/marvell/libertas/tx.c
+++ b/drivers/net/wireless/marvell/libertas/tx.c
@@ -116,13 +116,6 @@ netdev_tx_t lbs_hard_start_xmit(struct s
 	if (priv->wdev->iftype == NL80211_IFTYPE_MONITOR) {
 		struct tx_radiotap_hdr *rtap_hdr = (void *)skb->data;
 
-		if (skb->len < sizeof(*rtap_hdr) + 4 + ETH_ALEN) {
-			lbs_deb_tx("tx err: short monitor frame %u\n", skb->len);
-			dev->stats.tx_dropped++;
-			dev->stats.tx_errors++;
-			goto free;
-		}
-
 		/* set txpd fields from the radiotap header */
 		txpd->tx_control = cpu_to_le32(convert_radiotap_rate_to_mv(rtap_hdr->rate));
 


