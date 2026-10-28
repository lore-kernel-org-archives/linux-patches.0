Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213263;
	b=o1VXKyPiXGeNpd/CgqC8OOPGkC2rvbDYDXACrelilF6IUOIVN9Sjk1ith2PsMqtR5RFD
	 +qPU153+lUZw8JczxQfRVPsBAJvVxQcsBM3i4/Vkj5f+uSdZ/T0Wq3HAsR/ka10jNMYby
	 7rQePqIOs8Tvq1gjsT41zW8bh5wu8lO8/RWTcRwJhXTQ6BegbktMor202X2fHgqiE6sxE
	 26OHnRWpWSS2D72rgireLKPyUZddcYL2Y6xKy9HZuqByfnwApssppSA4SeEnHtTxpYisS
	 9bgJv6YVGZ2XJoVuda0jf0FWaQJTyKxGYQRTyiJCeCwvJMYPfLOX9qHiDUP7TBIvltg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213263;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/l/fj9oSdXe3V9TwS2VpNxnJ4g3z0+TQDQoaxmIJxWQ=;
	b=j+r3coUJEgqYp1ULgFybk+7HXQPXzftmQ2wWj/iOXYIGhJwb8mxNBzMKUuO+2OO9Q1bW
	 CoQkHOZQju6ELjpsUyk/noYhd0EmNq82E54/3ly6t4qMM2AyNJrMt+reRvJBHYC3H8ZUP
	 HRXiD0on3wM+iFnzhHFnYxjNe5fgcgZ7aG6hOOpuJh4iouUtNse6Q0bhyXlT3GnVcG7be
	 8TlfcKGcjxdEcB5lEFZM+T2mAYBTtGWilVmJCsT/PDbfT2GK0yWAWEMH83a11Jk2em1Ve
	 XcrSOsLYedeK5DdE3zYea8vMY5bpWXMgz4m9KHmtpvLV1saeMQTaaTZ/5VRBfhgxjiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o5zxKQEF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D313606A31A;
	Wed, 28 Oct 2026 18:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o5zxKQEF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6DB1F01825;
	Wed, 28 Oct 2026 18:47:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213263;
	bh=/l/fj9oSdXe3V9TwS2VpNxnJ4g3z0+TQDQoaxmIJxWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o5zxKQEF8csIithNLp5ffrP5cc3JmgDPrd28MHTtd+ALlus5kUDiq8lLtsuS+jCLG
	 oAlGMx3B079EJbCpJX5jaYRRDN5kYWGUiK04ZQNS4TXnikvItvEa7+AHGb08uHXVIe
	 FxkBIjK2FiR5Xu65WLzcU+A3CdJvf2oi1/I5DL9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.1 0445/1887] Revert "wifi: libertas: reject short monitor TX frames"
Date: Wed, 28 Oct 2026 17:42:21 +0100
Message-ID: <20261028170509.358218423@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -117,13 +117,6 @@ netdev_tx_t lbs_hard_start_xmit(struct s
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
 


