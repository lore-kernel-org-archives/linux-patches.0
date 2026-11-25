Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620078;
	b=hLkgwAYqytFJw/RM7lljTB0eBiS8IdgzrvJGa+tF6gU7Vb+GG6Lru8B+ekPlxmuf1nKh
	 QW27nCl3e87cjmKf4zFAMXHtJQd+ydCSUAKAA4k5s/HoznCm3GI3BLXdMhk16r80zCXVb
	 qYScT/TEoOyPIXNUEonq/OKE67alPeTK63iiKvWLFGkLnMAoYfp8IbPc/1+KQnIEF2cSG
	 nVgZAaTKTzu+wbp/dj/I1vR2bgys5DuGktyTOc9UMflQ3n/4YCAV/GI6vxr1PIDAn5Fl+
	 aklc4LTyxRekY6hcTHNgQiCKLcKsLV+QzyWgU+ttEEzqvTNJ7NPnsdGRuup+Symmn8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620078;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/EOzYlIUpkNScVgAn7mOTbPEaGOsVISTO0uLz+wxXeE=;
	b=dKFhXcmZWc6c1zT/q1Me1rHu1kpVZK3nHiZMEXQVz7+UD8mEhySRj6fsbcf27Xsan2Xk
	 Bbq7TeZ5P4RS5+aUUHq3eZp0Ff6STB8MTLg+7YMJ62J8zCPhEB5Z6aFxo9pN1g0ab69uq
	 FYYoP0u1W4yYviP9/2wXxLV2NroIaC/k0X7WnMzLy7HQ0rhBd6MTAzBhWE0jZULAge6fs
	 Y2eHJCFZFm4FB/GhXlRp33J1ffFGu2z+Qkp8eXxrMwjLXH1AJkHy8AhLni8eYcL22orQG
	 VCseWoGZk3o5cQK36ecwD0+Yvk7RqfD/DkKjWpS3V8yPewUx0PhgWoFgu++Lq5YV0Zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bcDjCL98;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52A7C606A31E;
	Wed, 25 Nov 2026 15:21:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bcDjCL98
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732481F000D2;
	Wed, 25 Nov 2026 15:21:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620078;
	bh=/EOzYlIUpkNScVgAn7mOTbPEaGOsVISTO0uLz+wxXeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bcDjCL98Hj1Ay0+oOyF+jpkME0e6UudolI/JBkJjm1yZWPOj6FyhntXmZnLucv3Hr
	 q2YoOXxSmJ102/vRdgAkorIoQzl2HFvOpEZzuhKt+EmCEC0v4JYY4AGah11to2i2eA
	 CeAv7Ep6A4OOydnp1SzzAlBfVqZDgdTRRTbZWyJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.3 0802/1005] wifi: mac80211: recheck the OCB station limit before insertion
Date: Wed, 25 Nov 2026 15:35:40 +0100
Message-ID: <20261125143840.521443393@linuxfoundation.org>
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

commit 27e29a077b4887d0e0a813337f8b7e06bd020c81 upstream.

Frames from successive unknown OCB peers can make the deferred worker
install more than 128 stations.

The receive path checks local->num_sta before allocating each station,
but pending stations are not included in that count. Several allocations
can therefore pass before the worker inserts any of them, and the worker
then drains the list without rechecking the limit.

Recheck the installed-station limit in the worker under the wiphy mutex
and free entries that no longer fit.

LLM assistance was used to find the bug and review.

Fixes: 239281f803e2 ("mac80211: 802.11p OCB mode support")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261028142302.16634-2-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/mac80211/ocb.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/mac80211/ocb.c
+++ b/net/mac80211/ocb.c
@@ -139,8 +139,12 @@ void ieee80211_ocb_work(struct ieee80211
 		list_del(&sta->list);
 		spin_unlock_bh(&ifocb->incomplete_lock);
 
-		ieee80211_ocb_finish_sta(sta);
-		rcu_read_unlock();
+		if (sdata->local->num_sta >= IEEE80211_OCB_MAX_STA_ENTRIES) {
+			sta_info_free(sdata->local, sta);
+		} else {
+			ieee80211_ocb_finish_sta(sta);
+			rcu_read_unlock();
+		}
 		spin_lock_bh(&ifocb->incomplete_lock);
 	}
 	spin_unlock_bh(&ifocb->incomplete_lock);


