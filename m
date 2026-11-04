Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829475;
	b=OScLBdbeaWbtxFhauZw7IwLuN+kGCBhXS5hJKGvUvltrE+dulnhrYdIBUtFZ8Vv8TCrn
	 SDvRfq/BaOP18a0eKPRvH8PvkNdKyxaEIULTEaXwG9jaL2LlrqU/80h4Xzg6WtN5gubbd
	 JlCRCUgsranqnKjUVvRT4oxN7FpHrRwvW7VjKuVQNumoYlZMJoRa1OLA8w23AREr5Fn/l
	 xp2TtqxPbWfVEyeEhvE8eNR77OYI0TNGkbpq/nZ2RrL3ZQ63UzcvejR+4MIQ17kslwKhH
	 pddNJ+Px+RHQtU66G6xbmX4UtleJd7ugUNw/vP1k1b19OIJAi6CIno76XDpmaFLafMw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829475;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mbQq7k47tv1ZMlNU9oA9luibiFfXmZjj0DGmRXNxYxM=;
	b=XDyGpd5ochd4fOnQKaWBzKr90F8COJ2hmlf0KJDSRDvX2JHYzdxUOoDqlSF2xhv9A01u
	 WDqgY/r5MxukbsqXL1A/6S0fgiLdSocxkV4ji6xaC1n3Z1fNDTXIdZ7CH9D6VqqSMfXWc
	 VMUX0v+Wcnni2XjvMfXR/FtVqULxjkz3I+7Tyam4EGfB5Yuj6AwN7UTpLpFmLzSJyIref
	 q52YR6BhXPRKbJikGMAWmlhNk8sZKq40zniNiD3iOtFHQZ5xFZ4+KPSFsw7Ce/+aWg0+l
	 Uw+BN31XJt+a0IWFjAsisMNwhq8jmCXTN/t234Ck2y1FoDRc3oRELENePS2l+HDCEUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AShHbXCn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB56606AB20;
	Wed,  4 Nov 2026 21:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AShHbXCn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C3661F000C1;
	Wed,  4 Nov 2026 21:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829474;
	bh=mbQq7k47tv1ZMlNU9oA9luibiFfXmZjj0DGmRXNxYxM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AShHbXCniRMRSlAjH/zkwg/JdHfTvZXSVN0H0QA5OtjV2DEscSjyFgseNAMY1uMbo
	 8ZBcbimO99IA+hMD6kwfCSK+ybS0oRjfGccj74ZQmVhxT0gDtb9LgZ9LOqtlS1tRJv
	 Yx9k1NdfSwLovBCCdjBemBOJODjbSm75OLUaMGKo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Gmeiner <cgmeiner@igalia.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0149/1005] drm/etnaviv: check all modules for idle after reset
Date: Wed,  4 Nov 2026 15:58:02 -0500
Message-ID: <20261104211047.885729003@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 1006d1f7c03d92b28c252333836635df8e165401 ]

While the FE is an important part of the GPU, which needs to be idle
after reset, all other modules should be idle after a proper reset.
Check all present modules for being idle to determine whether the
reset was successful.

Reviewed-by: Christian Gmeiner <cgmeiner@igalia.com>
Link: https://patch.msgid.link/20260511085148.652256-1-l.stach@pengutronix.de
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
index cf0d9049bcf1e..368e799fc0c5d 100644
--- a/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
+++ b/drivers/gpu/drm/etnaviv/etnaviv_gpu.c
@@ -582,9 +582,9 @@ static int etnaviv_hw_reset(struct etnaviv_gpu *gpu)
 		/* read idle register. */
 		idle = gpu_read(gpu, VIVS_HI_IDLE_STATE);
 
-		/* try resetting again if FE is not idle */
-		if ((idle & VIVS_HI_IDLE_STATE_FE) == 0) {
-			dev_dbg(gpu->dev, "FE is not idle\n");
+		/* try resetting again if any module is not idle */
+		if ((idle & gpu->idle_mask) != gpu->idle_mask) {
+			dev_dbg(gpu->dev, "GPU modules not idle\n");
 			continue;
 		}
 
-- 
2.53.0



