Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 548CF1C07ED;
	Tue, 15 Oct 2024 13:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997813; cv=none; b=kh/SHPryA7pwVXxvKRpVlorPBHMwks2uKh5ERFuAznucVAv368bi+7i4A8nve6eERAQvBT+6hCL/CzR0OTeGhghDiG/Lp1swr94p6B41GLGt9x/UvR5CmLmeStP5bc3G05XdnEnIhqJ3ZV5nf91ipDWujkHIjJYFfwuQXtBl5kU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997813; c=relaxed/simple;
	bh=TzQV8dM0pHuHzU9zjC3cewNLzqjCFDLoiDrdwKBgwlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UfLJvPPrl5ln/WQFwopf/oLWoOv7NjWQ9R9xnbvokPw7q3rVp641z/rSLK1uJY2gEA1NVfFxhMIKZwdlGkbBZlWboEZvJqmSwc5w6hgZte87yUWG6DhyOu9gTC1XKzKu+1zwal/M8+OhN8gWgfdMQYATG+wiJAIdaZh2HDWUkU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OyMYm/e7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OyMYm/e7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7BCEC4CEC6;
	Tue, 15 Oct 2024 13:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997813;
	bh=TzQV8dM0pHuHzU9zjC3cewNLzqjCFDLoiDrdwKBgwlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OyMYm/e7hfeOjd0rtoGiyw+ynnyZMQPFdYLnhHPGKT1eAqCQ0DbzCXv/YczdqoScy
	 XobI/gKjxJWPgdqtgGBdUX+s+l6Njs1XzRBJwXXsBpNVq20bvjC0G9o/VPv9U31KRo
	 pE7WC67tKuPigFTIRa2xcL2PRoWrIkik3+IH9TDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Kandybka <d.kandybka@gmail.com>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 294/518] wifi: ath9k: fix possible integer overflow in ath9k_get_et_stats()
Date: Tue, 15 Oct 2024 14:43:18 +0200
Message-ID: <20241015123928.337584077@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 8d98347e0ddff..8631258b1ea7a 100644
--- a/drivers/net/wireless/ath/ath9k/debug.c
+++ b/drivers/net/wireless/ath/ath9k/debug.c
@@ -1316,11 +1316,11 @@ void ath9k_get_et_stats(struct ieee80211_hw *hw,
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



