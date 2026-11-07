Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064383;
	b=pYnBTnKr93x2nUsWPwXqqbROg6GRBGaPfPEI66Fumx5rTUR+IiIrGlQzkCrhJZSr//cM
	 uwET14W6+3tFxCFxauf4mz1Jcv3AUyBHTO0DwPrm+U251F/fTEWbN+1GYoP7524P4+5Ra
	 0bgHXqZ9hyp3xwzBuZuQ9cQjJOPgReqWRvNSqe5PfMhYEpWa6ctKbqusqlRetm0Jt6CaI
	 OmXo0wAq0jrvMF5QTpiJ53+uHSsezVLRrGHQcsjQgWj6h9H/vbkyjSRWpe4yO0fFXP0X5
	 fkRkrpFnVdOrGAQsEH8vRocb4JYHT4rPB3MPJR9Sk86zgFimXJ0FRsykJIptZeoxKnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064383;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gv73ECWVL4vNbDt3g/vLyVNGIvMAVCmkic8UHTCgOZM=;
	b=dwv7J0I9Z0hj/CH8fX1JQnjSNXwmd7AORK3R2CvliNnFuM02Q6NWYUCktBKo7jRHyEvH
	 xL9vO/4Z/NoZ8grdONL5vaaJLZiMuDxaMLU3kuuh4FxkmOcBI8C7PbZCxQnuXQi120rP8
	 shvZFdkqRdYikcOmvrh8f+leo1JygjluKMIVkr3pcFSdgKdCk7zasxf+E/gEN5GOspkkr
	 90PvdXBAVyQuKZ4RVy9qqFDuTszsr0GlKRG+zEaStNw1P7hihXyDRDMi+NA6PaUj30ZBO
	 tCWPPwKubMTUDArzUdJmr1yqmf6SbfBZolJu3yvXKoeQhugnHmea/5GQmwiisUDjHLA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zubYfIei;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9B6606D811;
	Sat,  7 Nov 2026 15:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zubYfIei
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BD8A1F008A2;
	Sat,  7 Nov 2026 15:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064383;
	bh=Gv73ECWVL4vNbDt3g/vLyVNGIvMAVCmkic8UHTCgOZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zubYfIeiMvC3njXxF8xtddB1V9yI+90UOxJ/XB1+2OA+iITE3GtQOIm7hheLbi1SC
	 MrjVFKQhve8OWsuj4QCPSryYRzyqiuR88+gjDvTlXqNnz4TOXjtWCGxlNrQM3gdRcb
	 hG3AwkaYJ/rDyM7ls7N0/Mo78R/hiLx9TZc3e+NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guangshuo Li <lgs201920130244@gmail.com>,
	Detlev Casanova <detlev.casanova@collabora.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0459/1257] media: rkvdec: do not destroy borrowed SRAM pool
Date: Sat,  7 Nov 2026 08:45:55 -0500
Message-ID: <20261107134952.147020083@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Guangshuo Li <lgs201920130244@gmail.com>

[ Upstream commit 19449e913cf0cb866957fe7ddc9b357f7244d079 ]

rkvdec_probe() obtains a provider-owned SRAM pool with
of_gen_pool_get(), but its error path incorrectly destroys the borrowed
pool with gen_pool_destroy().

of_gen_pool_get() returns a pool managed by the SRAM provider. The pool
is not created or owned by the rkvdec driver and is destroyed by the
provider when its own managed resources are released.

Destroying it when rkvdec_v4l2_init() fails can invalidate the pool
while the provider and other consumers still reference it, and can also
result in the provider attempting to destroy it again later.

Remove the incorrect gen_pool_destroy() call from the probe failure
path.

This issue was found by manual code inspection.

Fixes: e5640dbb991c ("media: rkvdec: Add RCB and SRAM support")
Cc: stable@vger.kernel.org
Signed-off-by: Guangshuo Li <lgs201920130244@gmail.com>
Reviewed-by: Detlev Casanova <detlev.casanova@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/rockchip/rkvdec/rkvdec.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/media/platform/rockchip/rkvdec/rkvdec.c b/drivers/media/platform/rockchip/rkvdec/rkvdec.c
index 061281f903f3c..4541ef9ee3b98 100644
--- a/drivers/media/platform/rockchip/rkvdec/rkvdec.c
+++ b/drivers/media/platform/rockchip/rkvdec/rkvdec.c
@@ -1857,9 +1857,6 @@ static int rkvdec_probe(struct platform_device *pdev)
 	pm_runtime_dont_use_autosuspend(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
 
-	if (rkvdec->sram_pool)
-		gen_pool_destroy(rkvdec->sram_pool);
-
 	return ret;
 }
 
-- 
2.53.0



