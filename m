Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620083;
	b=LHFSiUQoWYvaTb4p+oxKgbZ1CtWYnwDVrkfahY+vZpDeUv6zyQbe6JdTS2TeMA2u5VmL
	 54ep95aF2OqyDRVsIZmku3thIT0XrolYt1NskxP5oIRMcxaavxpwt9MQ3AcV+kI+scttQ
	 SV1qb7ZBiTaX9luP1jjWkeZk4Dh9djj9CfRgmLXji002/PnUbsTPklA7q49jJf4DpQ/Ti
	 bk1ApSVuXVU+xYK1Ct/bSwl8//S4i8C0Wy1cp5pcGPgwp6zuh24aOt8JqIVai3v2cLMR9
	 TetLphf8qFtXrmXsVZtQqynCcneaHs3YJU1XLQffxsaY4+bUL8vVuabpYWPOUCOf4ow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620083;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KxMmcHYIr1taDaQap9E/Tn+9e0PgRWH2epLoUlf5mNU=;
	b=sfqetVVt+7Ow3TQ3bC53k5LSUfhWNXwmuJ0XLbiIo/3owfvDE/salQZqtk1ox98NvQTk
	 Lw363FWynwmZWQzuBNi78kkSG7A9bQMpZV0TIOeHV9IvhbayLd+DViRY9Gm+nVJ1tUAxx
	 ECq6aHMo5RwsaxDUNXtUdYuI9dXL2AiHs81bWpih74y0+DV9mNcOUD46guT+oTfhVn+tf
	 kfguXfuq8WPfQRqK8DIA60eeefIpMXUVUZLvneocCgweVfM5Vbsgwis2AVJOuLEdaker2
	 +3YKJ9pthLNaVp85nd0Et+s7uFzgCA/RY1MSwGiOlraJsmkVF5N6I89O7wrS3cSdq7Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wzq1RbPe;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0DB606A31E;
	Wed, 25 Nov 2026 15:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wzq1RbPe
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1988B1F000C6;
	Wed, 25 Nov 2026 15:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620083;
	bh=KxMmcHYIr1taDaQap9E/Tn+9e0PgRWH2epLoUlf5mNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wzq1RbPedFLRGewwBv5jRCH8q9UZY1TxV0PSqjurZWmYnZUp8q1phtEZRbA8OJKjn
	 8wQjh41ADT6q46D5tiOxxPqUVzdiZdnUi5Hk8ZE4tXlWkd+ZNEuUsyYsu2kbYMySt1
	 PnT5ZF1NSQnWBokzONwnXL1WdTBz2cNqbuk459zA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.3 0804/1005] wifi: mac80211: restore dormant links when link updates fail
Date: Wed, 25 Nov 2026 15:35:42 +0100
Message-ID: <20261125143840.566936641@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Li <enderaoelyther@gmail.com>

commit bb22f3b2d8f8a2f883944f24678cf84e18b162e8 upstream.

A failed MLO link update can leave the interface with the requested
dormant-links bitmap instead of its previous one. This can disable active
links or trigger a bitmap warning during rollback.

The error path restores the old valid-links bitmap but passes the new
dormant_links argument to ieee80211_set_vif_links_bitmaps().

Save the old dormant bitmap before changing link state and use it when
restoring the old configuration.

LLM assistance was used to find the bug and review.

Fixes: 6d543b34dbcf ("wifi: mac80211: Support disabled links during association")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261028142123.13072-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/link.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/mac80211/link.c
+++ b/net/mac80211/link.c
@@ -296,6 +296,7 @@ static int ieee80211_vif_update_links(st
 {
 	u16 old_links = sdata->vif.valid_links;
 	u16 old_active = sdata->vif.active_links;
+	u16 old_dormant = sdata->vif.dormant_links;
 	unsigned long add = new_links & ~old_links;
 	unsigned long rem = old_links & ~new_links;
 	unsigned long sta_rem = rem;
@@ -405,7 +406,7 @@ static int ieee80211_vif_update_links(st
 		/* restore config */
 		memcpy(sdata->link, old_data, sizeof(old_data));
 		memcpy(sdata->vif.link_conf, old, sizeof(old));
-		ieee80211_set_vif_links_bitmaps(sdata, old_links, dormant_links);
+		ieee80211_set_vif_links_bitmaps(sdata, old_links, old_dormant);
 		/* drain RCU readers before cancelling work they may queue */
 		synchronize_rcu();
 		for_each_set_bit(link_id, &add, IEEE80211_MLD_MAX_NUM_LINKS) {


