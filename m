Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17831A76A5;
	Mon, 14 Oct 2024 15:12:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728918765; cv=none; b=W0V1iFcq8YMOH/dyujPxGH1/Xjomz9K2PCEq2JHGyWRSOl5mATRsp5euVikubee8WUnj/RXpeamYKeRFOQPePLczY8z+Vb89pj+ddhmAvbEH01HPvMDrv9i+sg60pp6+KnrBKSZh+fspHPqXYJGJnF4raBoqII+gMaL1yyD6n44=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728918765; c=relaxed/simple;
	bh=ZWGf7mPJWsTRc9K0NHLbZjjE2wL/rzhIB/Yl2yGaUM8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bHohuzor9FIxhKEfc8/s6cDQib+q7fmC1XTJNxTJ69xARnR0zwjBgPe7Jteb/HFJOQxaqzIIuurBH/0LqHOJQov+0R++OeAuDlj8ZAanGfF6Qz/xbp37iiVdx7AEMOkDiIVcfpb5X3ZaSf2MGjyAYNZIbryZ6jNUUJfB8jG9/wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HgFBRysC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HgFBRysC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0890C4CEC3;
	Mon, 14 Oct 2024 15:12:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728918765;
	bh=ZWGf7mPJWsTRc9K0NHLbZjjE2wL/rzhIB/Yl2yGaUM8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HgFBRysCaArF7EW3oX1Y2oXHFH6uzjBLbHQuRjlfIygfEvBNGCSCnD4XyRCY4d03T
	 r+KhjHGzZPlUUV4xI34s/NF4CVuXo4dfY4NJvqW6FaTgw3rUhhzZ9PIDLHvDatwqoa
	 qWUJtsMkH6Wzlw9RO9ZaDpqEuwg6r489YKGB52qk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Kandybka <d.kandybka@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 417/798] wifi: ath9k: fix possible integer overflow in ath9k_get_et_stats()
Date: Mon, 14 Oct 2024 16:16:11 +0200
Message-ID: <20241014141234.329473591@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Kandybka <d.kandybka@gmail.com>

[ Upstream commit 3f66f26703093886db81f0610b97a6794511917c ]

In 'ath9k_get_et_stats()', promote TX stats counters to 'u64'
to avoid possible integer overflow. Compile tested only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Dmitry Kandybka <d.kandybka@gmail.com>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://patch.msgid.link/20240725111743.14422-1-d.kandybka@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/debug.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/debug.c b/drivers/net/wireless/ath/ath9k/debug.c
index 9955b9c4df2b4..9d2e1728d4edb 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1365,11 +1365,11 @@ void ath9k_get_et_stats(struct ieee80211_hw *hw,
 	struct ath_softc *sc = hw->priv;
 	int i = 0;
 
-	data[i++] = (sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BE)].tx_pkts_all +
+	data[i++] = ((u64)sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BE)].tx_pkts_all +
 		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BK)].tx_pkts_all +
 		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VI)].tx_pkts_all +
 		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VO)].tx_pkts_all);
-	data[i++] = (sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BE)].tx_bytes_all +
+	data[i++] = ((u64)sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BE)].tx_bytes_all +
 		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_BK)].tx_bytes_all +
 		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VI)].tx_bytes_all +
 		     sc->debug.stats.txstats[PR_QNUM(IEEE80211_AC_VO)].tx_bytes_all);
-- 
2.43.0



