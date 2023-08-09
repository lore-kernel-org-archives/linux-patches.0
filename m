Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F192C174CA
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 10:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721CBC433C9;
	Wed,  9 Aug 2023 10:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578666;
	bh=n68iowoRtjxql//MY+G/2L9qlsw75EYYpF7B+GECjfk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NTm5pv3PKsgzoq9iYee76iLghGcvEwzBMRYygtuGGq8dEASReu9p8vjJ8v5o0syNt
	 L8wOEjCccx3YeFyTc68hC6JJ57Fx7e2DKLhYB+q3xA7QCifxorQOcF9s7+FEs9eaI+
	 zbigBSSg3VArDedzhksgT16kyxr/N1llq0U3lh8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilan Peer <ilan.peer@intel.com>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 14/92] wifi: cfg80211: Fix return value in scan logic
Date: Wed,  9 Aug 2023 12:40:50 +0200
Message-ID: <20230809103634.081953913@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103633.485906560@linuxfoundation.org>
References: <20230809103633.485906560@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilan Peer <ilan.peer@intel.com>

[ Upstream commit fd7f08d92fcd7cc3eca0dd6c853f722a4c6176df ]

The reporter noticed a warning when running iwlwifi:

WARNING: CPU: 8 PID: 659 at mm/page_alloc.c:4453 __alloc_pages+0x329/0x340

As cfg80211_parse_colocated_ap() is not expected to return a negative
value return 0 and not a negative value if cfg80211_calc_short_ssid()
fails.

Fixes: c8cb5b854b40f ("nl80211/cfg80211: support 6 GHz scanning")
Closes: https://bugzilla.kernel.org/show_bug.cgi?id=217675
Signed-off-by: Ilan Peer <ilan.peer@intel.com>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230723201043.3007430-1-ilan.peer@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/wireless/scan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index a565476809f02..c7192d7bcbd76 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -641,7 +641,7 @@ static int cfg80211_parse_colocated_ap(const struct cfg80211_bss_ies *ies,
 
 	ret = cfg80211_calc_short_ssid(ies, &ssid_elem, &s_ssid_tmp);
 	if (ret)
-		return ret;
+		return 0;
 
 	/* RNR IE may contain more than one NEIGHBOR_AP_INFO */
 	while (pos + sizeof(*ap_info) <= end) {
-- 
2.40.1



