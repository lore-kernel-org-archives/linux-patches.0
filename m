Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25DE530DECC;
	Tue,  2 Sep 2025 13:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756819510; cv=none; b=i1QfO2dwL9ss5siM3IMHxQZYaVIs4x/lLsTMk8rW/kzhD2JQlCcYSH7C67n4WZp+uDbLk7T5qhB0i08ZxPJiK2E9Yf64WlU3GQFRnmK3HIE9q3GxOTYW6PqUbBVdZe1Xq/bXkGaUpmV2ffoSvrZFcW7DpJWiu9+X7sjcvjLVjAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756819510; c=relaxed/simple;
	bh=TwcBuZDZ43lkT5UzkpBTQhnH0nkBFxRVPCJtS7OJVEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JuI5By4HZ03g80QRD21rlCB1mgr6/P8q4OqMnLRtnm7YxjHPNiLpVGhpLYBT8PD8q1A70A8VNAgiElOZtSmmf/mc7UM8TblhEH3NhioruFkqfREgXpp4EV5sWJSgjzxenf8tyVAtnDc1uGRJuwHJfWJ1EjdJ4eU6k4R6jBTpUBk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0jSZ9KQm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0jSZ9KQm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D4B7C4CEED;
	Tue,  2 Sep 2025 13:25:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756819510;
	bh=TwcBuZDZ43lkT5UzkpBTQhnH0nkBFxRVPCJtS7OJVEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0jSZ9KQm54NA6B03IldA5O09zNEdPEBsUB2Z+k7EEVvWdpBQYPEZboc6yyd2qPw9E
	 eRJKm1GLzdM4/yYC6zI32BlggOqhaH8YmNbWP5tTkCKOvwAd0KmUK1NyPuq6nDslVV
	 hG8zmYl13u8EWqsz4xZcGlGCDMOVOz7T6xYfpAJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Stanner <phasta@kernel.org>,
	Timur Tabi <ttabi@nvidia.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 055/142] drm/nouveau: remove unused increment in gm200_flcn_pio_imem_wr
Date: Tue,  2 Sep 2025 15:19:17 +0200
Message-ID: <20250902131950.360556731@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131948.154194162@linuxfoundation.org>
References: <20250902131948.154194162@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Timur Tabi <ttabi@nvidia.com>

[ Upstream commit f529b8915543fb9ceb732cec5571f7fe12bc9530 ]

The 'tag' parameter is passed by value and is not actually used after
being incremented, so remove the increment.  It's the function that calls
gm200_flcn_pio_imem_wr that is supposed to (and does) increment 'tag'.

Fixes: 0e44c2170876 ("drm/nouveau/flcn: new code to load+boot simple HS FWs (VPR scrubber)")
Reviewed-by: Philipp Stanner <phasta@kernel.org>
Signed-off-by: Timur Tabi <ttabi@nvidia.com>
Link: https://lore.kernel.org/r/20250813001004.2986092-2-ttabi@nvidia.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nvkm/falcon/gm200.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/nouveau/nvkm/falcon/gm200.c b/drivers/gpu/drm/nouveau/nvkm/falcon/gm200.c
index b7da3ab44c277..6a004c6e67425 100644
--- a/drivers/gpu/drm/nouveau/nvkm/falcon/gm200.c
+++ b/drivers/gpu/drm/nouveau/nvkm/falcon/gm200.c
@@ -103,7 +103,7 @@ gm200_flcn_pio_imem_wr_init(struct nvkm_falcon *falcon, u8 port, bool sec, u32 i
 static void
 gm200_flcn_pio_imem_wr(struct nvkm_falcon *falcon, u8 port, const u8 *img, int len, u16 tag)
 {
-	nvkm_falcon_wr32(falcon, 0x188 + (port * 0x10), tag++);
+	nvkm_falcon_wr32(falcon, 0x188 + (port * 0x10), tag);
 	while (len >= 4) {
 		nvkm_falcon_wr32(falcon, 0x184 + (port * 0x10), *(u32 *)img);
 		img += 4;
-- 
2.50.1



