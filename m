Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AAE79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:49:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC262C433D7;
	Wed, 30 Nov 2022 18:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834161;
	bh=wjuZpImrOt5tYxE2xLChIjGTwjQlYHYcXhpbAtIIFAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qnU+phUvV5bCpt2HY2oUV61p9MeUi5pJ/UozMlsGJwyCy6dY6R1BmDHFYVkQAxAF0
	 Nz1l/co3DC0Z4zv0WA3Gc9es+vom/6YeObGS46P4GqFc4yTVwsZgrGiQUR0fexUpbA
	 TwaONtvEEc7Vq5O9o8M9D2ZBrjOF53svmX9SJ/BI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiasheng Jiang <jiasheng@iscas.ac.cn>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 152/289] octeontx2-pf: Add check for devm_kcalloc
Date: Wed, 30 Nov 2022 19:22:17 +0100
Message-Id: <20221130180547.581133988@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit cd07eadd5147ffdae11b6fd28b77a3872f2a2484 ]

As the devm_kcalloc may return NULL pointer,
it should be better to add check for the return
value, as same as the others.

Fixes: e8e095b3b370 ("octeontx2-af: cn10k: Bandwidth profiles config support")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Link: https://lore.kernel.org/r/20221122055449.31247-1-jiasheng@iscas.ac.cn
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
index 0879a48411f3..3dc90060d70d 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_nix.c
@@ -4979,6 +4979,8 @@ static int nix_setup_ipolicers(struct rvu *rvu,
 		ipolicer->ref_count = devm_kcalloc(rvu->dev,
 						   ipolicer->band_prof.max,
 						   sizeof(u16), GFP_KERNEL);
+		if (!ipolicer->ref_count)
+			return -ENOMEM;
 	}
 
 	/* Set policer timeunit to 2us ie  (19 + 1) * 100 nsec = 2us */
-- 
2.35.1



