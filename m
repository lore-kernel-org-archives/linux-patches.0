Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D85534CC3
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 21:01:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B412BC433D2;
	Wed,  7 Jun 2023 21:01:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171697;
	bh=XafiMvi6pniguY3dOE4WmTLMg0zaHdHzxP2bGOjoW+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RvxLSOXZ2zl4uqxjFe8ZtuEuJZVVfWWy6YcoemDu0lwmrz6fuLyKX1oTJRWMusSEB
	 BYWqkfQyJAePHN9xCYefh7/1L0lr6/AGazEwA5IaBeMzA2nnZ9Qyld+9afUeEkPC5R
	 CprDFzlVvMR5ZaZEB6UnRS35BJzNoe32qIsTK0AM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Berg <johannes.berg@intel.com>,
	Gregory Greenman <gregory.greenman@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/159] wifi: mac80211: simplify chanctx allocation
Date: Wed,  7 Jun 2023 22:16:28 +0200
Message-ID: <20230607200906.478670086@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Johannes Berg <johannes.berg@intel.com>

[ Upstream commit 860e1b43da94551cd1e73adc36b3c64cc3e5dc01 ]

There's no need to call ieee80211_recalc_chanctx_min_def()
since it cannot and won't call the driver anyway; just use
_ieee80211_recalc_chanctx_min_def() instead.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Gregory Greenman <gregory.greenman@intel.com>
Link: https://lore.kernel.org/r/20230504134511.828474-3-gregory.greenman@intel.com
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mac80211/chan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/mac80211/chan.c b/net/mac80211/chan.c
index 63e15f583e0a6..f32d8d07d6a30 100644
--- a/net/mac80211/chan.c
+++ b/net/mac80211/chan.c
@@ -563,7 +563,7 @@ ieee80211_alloc_chanctx(struct ieee80211_local *local,
 	ctx->conf.rx_chains_dynamic = 1;
 	ctx->mode = mode;
 	ctx->conf.radar_enabled = false;
-	ieee80211_recalc_chanctx_min_def(local, ctx);
+	_ieee80211_recalc_chanctx_min_def(local, ctx);
 
 	return ctx;
 }
-- 
2.39.2



