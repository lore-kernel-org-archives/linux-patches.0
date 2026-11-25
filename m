Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795620195;
	b=Yih0r1FNVAeIm4Szq5aC8wh9m6B4EpjDaSvEQt5zYaUy3Rb5OJ/J1RXmdse44vqTN3Uf
	 S0TpwnyREKuFJpbo4BI+GocfzTb6M2P/mMd8ggZuyBcC33yLG61TL52zyJlqPucvFJpRP
	 OrCAx7qQQCw1bdse/3YE9sy17z09ioc8h1nOn3BzoAGc3ALTVVCi2o9TMgsaYbKGy1I7V
	 J40jXyby5zjmuyF5VtTOtt1ml2Fnsz8Zd0RzilbVp14HiNH3ieVqe0VQbg6N0x93Kc2GU
	 ctn57XyDDkKuYkkezA5nT/0RDjCgIxn5mOLWUygeY8Vl/vaJxpNCL3O/CQd1KcklTzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795620195;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FMubXkfWuir88L/bO18pqkKMaGpYpPDPjSTbLdp6BZA=;
	b=amEfVuT4oYXRN8Sanoe2JsKoDqE7X7l2VfZKqAwrfZQYkfGhJY5+r+VOWWAqaKL/cztY
	 u25yaq9k9wGwfn7fRjm0gM7AgS/mKItWvHhQdN2kk1wRDgjBIAs8+ilPVxo+m64e/YYT4
	 dQ4e76GsiTY3yiSGvCl/U78P701Lwk/wXqHBZ4pKfUEOle0kY0gu4acBldUL/x1dvI9eg
	 030ps6/MTwtvecJbTOjHn9EMpO9VJjnXxuYYjiQhu/M0mhXuPC3VWooCgJMVy5FWznFAB
	 QQVDwCiUM+zm830MXfg/SY6c+ed/C8we3ctX6ZkqevtzUtu4PJw+TfmqlXayNAh3fCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2uCqaARP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCDB4606A333;
	Wed, 25 Nov 2026 15:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2uCqaARP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ABF31F000C0;
	Wed, 25 Nov 2026 15:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795620195;
	bh=FMubXkfWuir88L/bO18pqkKMaGpYpPDPjSTbLdp6BZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2uCqaARPXeZaHcHJSZnwXunmLJP1tVqfqyJPZaAis2Qxqf50HYVPbV5tk84leII+8
	 4jsj7ogmehm6lZ/mmlhPtfBSu+4QyLrLAlbZHvfjdvwUcdgzNKYGP8sI6L7jWDyvk3
	 hGXgiHpEpHjXxR0Ug/5ZElIm9i1bx+e4XqY1jXOQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhao Li <enderaoelyther@gmail.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 7.3 0795/1005] wifi: cfg80211: release rejected nontransmitted BSS reference
Date: Wed, 25 Nov 2026 15:35:33 +0100
Message-ID: <20261125143840.360106171@linuxfoundation.org>
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

commit f3c45d5b741a7d7586e639c2f55d2557029f2e1a upstream.

Repeated MBSSID reports without an SSID can leak BSS entries outside the
scan cache, where the BSS entry limit cannot account for them.

__cfg80211_bss_update() returns a referenced BSS. If adding it to the
transmitting BSS list fails, unlinking drops the cache reference, but the
caller reference is lost when res is cleared.

Release the caller reference before discarding the unlinked BSS.

LLM assistance was used to find the bug and review.

Fixes: 0b7808818cb9 ("wifi: cfg80211: fix BSS refcounting bugs")
Cc: stable@vger.kernel.org
Signed-off-by: Zhao Li <enderaoelyther@gmail.com>
Link: https://patch.msgid.link/20261028141731.6185-1-enderaoelyther@gmail.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/wireless/scan.c |    1 +
 1 file changed, 1 insertion(+)

--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -2452,6 +2452,7 @@ cfg80211_inform_single_bss_data(struct w
 		if (cfg80211_add_nontrans_list(data->source_bss, &res->pub)) {
 			if (__cfg80211_unlink_bss(rdev, res)) {
 				rdev->bss_generation++;
+				bss_ref_put(rdev, res);
 				res = NULL;
 			}
 		}


