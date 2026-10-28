Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211383;
	b=jQbiuasCuDXo5WwDpXFFlJiv+53dQlueyBXjJG6GGsXFpVqVQXNwGXcYO3kz1HA+g+1H
	 J+QusOAI2dH1g6kuK+d3UI/1y9OoVT1ebH922dqvqDV6CffSVmARYgjbzUsoDEdq+nPZ9
	 hnsgLBm89FXWbzxVwTooDS1F2+hGB2l5G3lBjQIOQHVooCLSaKRFykOm+AgPHlj9zoPiD
	 fqzJQBguT2j+QXFvqgOaoGl0iOKc8DIwMhCH6LeZWCe8De5KOrk2SFKgJrRcB5lwRD2Uw
	 laEDMPYvuufAfJgVgySxh/HOS1xn+TFk12bkPWQlrvpAnRob162MhBNPVIVo/VJdZ+Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rwWgAzDm8hqT2OWYGGGkc/S5MMzwi8dipYFyB5Nxfqw=;
	b=IEzHZNSDBDu1fkTBzuYsTnvuWRCHGfP4zdWN1gtuGyxtUHXfcP1MdKyyYRc2Jdz33RtJ
	 TayVQh4DvpT61lGsOMhKWgRR5EcjKYi4KR65aVbEFtNEBJ/4miq9gRq5u0ce0tN36s9NF
	 GVLRcI2zI1bUpgQdmu+2Czprlnb0fsexzhzcu9Zh1C9rnNICh4xOjyZ5uEXPZ6VELP6TF
	 v+UZabgguesCV9bNv9S9qweSs+94HLmX2GQ1vIqogNRSTALhxjLO80Ab3rSsAc1W/SB5v
	 qOYSRLj8UtF0spzgazCnUXxgg01LAdpE6KNvhzTWbVh5aPr9Cv4fGC3qRFiqe6LA9Pw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IQvnibaM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294C3606A325;
	Wed, 28 Oct 2026 18:16:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IQvnibaM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AB001F01825;
	Wed, 28 Oct 2026 18:16:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211382;
	bh=rwWgAzDm8hqT2OWYGGGkc/S5MMzwi8dipYFyB5Nxfqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IQvnibaMGb8PARD+jPJ3E8JL5LbXyPI8lvg/ISYvxZbjBXzNl26rlzINL6i1TEBQd
	 Ww8D1Fz4DQx6qIWmZyCkJwAseDjYgBWLY39iUzs2nNOLHeOaJ/H1IE1F60jdJOipwC
	 n3l90qFIfM3A4M70uBMoqmCj7BAERT+0HxoAd49w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.15 356/571] Revert "wifi: libertas: reject short monitor TX frames"
Date: Wed, 28 Oct 2026 17:58:23 +0100
Message-ID: <20261028170016.465250731@linuxfoundation.org>
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
 


