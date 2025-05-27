Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EA4B2566;
	Tue, 27 May 2025 17:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748368280; cv=none; b=OvBc0sl07MDjx2lTstYGRr4neWUz8nM1zKqJp09LHzDmcL8bTQufJ1b1bvSPcWH5higXOB8eF7JajVSKJniKfftUnnCWaa5Tke1tyYCpctx2JqRTs2ETeOYwEFFg1VQdRGpojIY/4GYDpM0dSPpOlmvcw4UBTXr6H71TmHzZ3OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748368280; c=relaxed/simple;
	bh=YnprLaPpD/igTPhnRfBMFugtTNPtW4NAl/ceYN/1cfU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wja1p8GvS7quPxcxYQFxqXqMaS5dmxOJgKaov2QKBf3V8jfJY1u1I9QT0vH3wAzQ9JsnKUrlzgYz6NAwIVf38pxj8DmlAOA8fN9/w1QhCLIy8XHoKdnNdetxsyY5+V2vggGuB+tBgBxamRGoxKT4/wXFSnfAHdhauiowGpsnMLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x1pPiGyu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x1pPiGyu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749B1C4CEE9;
	Tue, 27 May 2025 17:51:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748368279;
	bh=YnprLaPpD/igTPhnRfBMFugtTNPtW4NAl/ceYN/1cfU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x1pPiGyuVJyLrSzCFynj6tD78dnrRdNaAcKZziGDRFfDbzeLZz1mPn7xxpIFPhgr/
	 FAdeoLVaxIlLSX7vXuLFa+0lqS0M5IQojvOmgRDFCdqnHUItcf/gYf/Wkb/vcpMaZE
	 QJA2Ysma4tw6l0eugQrMx++v1pRimsp7Qf0CO4Tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maarten Lankhorst <dev@lankhorst.se>,
	Tvrtko Ursulin <tvrtko.ursulin@igalia.com>,
	Sunil Khatri <sunil.khatri@amd.com>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 657/783] drm/ttm: fix the warning for hit_low and evict_low
Date: Tue, 27 May 2025 18:27:34 +0200
Message-ID: <20250527162539.883543013@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sunil Khatri <sunil.khatri@amd.com>

[ Upstream commit 76047483fe94414edf409dc498498abf346e22f1 ]

fix the below warning messages:
ttm/ttm_bo.c:1098: warning: Function parameter or struct member 'hit_low' not described in 'ttm_bo_swapout_walk'
ttm/ttm_bo.c:1098: warning: Function parameter or struct member 'evict_low' not described in 'ttm_bo_swapout_walk'

Cc: Maarten Lankhorst <dev@lankhorst.se>
Cc: Tvrtko Ursulin <tvrtko.ursulin@igalia.com>
Signed-off-by: Sunil Khatri <sunil.khatri@amd.com>
Reviewed-by: Maarten Lankhorst <dev@lankhorst.se>
Signed-off-by: Christian König <christian.koenig@amd.com>
Link: https://lore.kernel.org/r/20250423042442.762108-1-sunil.khatri@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_bo.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index ea5e498588573..72c675191a022 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -1092,7 +1092,8 @@ struct ttm_bo_swapout_walk {
 	struct ttm_lru_walk walk;
 	/** @gfp_flags: The gfp flags to use for ttm_tt_swapout() */
 	gfp_t gfp_flags;
-
+	/** @hit_low: Whether we should attempt to swap BO's with low watermark threshold */
+	/** @evict_low: If we cannot swap a bo when @try_low is false (first pass) */
 	bool hit_low, evict_low;
 };
 
-- 
2.39.5



