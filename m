Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9951979FD;
	Thu, 11 Apr 2024 10:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712832578; cv=none; b=R3pCHm/XohYOfd1l7mge1ENqxqHjwplPCRd0O45CqtRiHTS5/gPdJ1bhKowIYrfEudoU+7goP/gagU9vjEPhh1L88D0/GtqUg1LUDBb7cV07Reua7Jk79ihlTq1vU8gabOUXt1XI+RCSJ+XFIL71/sdJzdcVwOvOpkd4UMnr1Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712832578; c=relaxed/simple;
	bh=XU04F/lLskPO5SrzqQDUGXH9oMXQ/PCsp1wsrqYe1N4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pz+WbG7sT6S+URJYvNugvUstmpSgOBxV8VOckrvGXZpq8SCz+ij4u5RIASqGjkQePItZtQDw4WDr3T+vEQtIzyDm91qtDwwBI5q3NRS0W7eAfI3Gs7a5OevvHIv82Y2SVmt/l7J3xoPEeGAlMz9BnWkyfMIeTZzR5aj21kEhAVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qTlEZXZF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qTlEZXZF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F08CC433C7;
	Thu, 11 Apr 2024 10:49:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712832578;
	bh=XU04F/lLskPO5SrzqQDUGXH9oMXQ/PCsp1wsrqYe1N4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qTlEZXZF1HuD0OiAxkvQhTYCjI/fhe3yrk98oRq5B6N/XfPVr6E0U716Al11qPjwj
	 TAAf2HgRkQIiAO5X5rWRuq/KyChYddhCjkDHNvcpWiNBFdanbuMUQXeKWrDj1Ycy1H
	 OwsuqH6otWQnBNhWbp6RLM6gAMVjjQJBevk+0UzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Antipov <dmantipov@yandex.ru>,
	=?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 02/57] wifi: ath9k: fix LNA selection in ath_ant_try_scan()
Date: Thu, 11 Apr 2024 11:57:10 +0200
Message-ID: <20240411095408.059624060@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095407.982258070@linuxfoundation.org>
References: <20240411095407.982258070@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Antipov <dmantipov@yandex.ru>

[ Upstream commit d6b27eb997ef9a2aa51633b3111bc4a04748e6d3 ]

In 'ath_ant_try_scan()', (most likely) the 2nd LNA's signal
strength should be used in comparison against RSSI when
selecting first LNA as the main one. Compile tested only.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Signed-off-by: Dmitry Antipov <dmantipov@yandex.ru>
Acked-by: Toke Høiland-Jørgensen <toke@toke.dk>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20231211172502.25202-1-dmantipov@yandex.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath9k/antenna.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath9k/antenna.c b/drivers/net/wireless/ath/ath9k/antenna.c
index 988222cea9dfe..acc84e6711b0e 100644
--- a/drivers/net/wireless/ath/ath9k/antenna.c
+++ b/drivers/net/wireless/ath/ath9k/antenna.c
@@ -643,7 +643,7 @@ static void ath_ant_try_scan(struct ath_ant_comb *antcomb,
 				conf->main_lna_conf = ATH_ANT_DIV_COMB_LNA1;
 				conf->alt_lna_conf = ATH_ANT_DIV_COMB_LNA1_PLUS_LNA2;
 			} else if (antcomb->rssi_sub >
-				   antcomb->rssi_lna1) {
+				   antcomb->rssi_lna2) {
 				/* set to A-B */
 				conf->main_lna_conf = ATH_ANT_DIV_COMB_LNA1;
 				conf->alt_lna_conf = ATH_ANT_DIV_COMB_LNA1_MINUS_LNA2;
-- 
2.43.0



