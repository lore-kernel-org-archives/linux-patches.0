Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062179;
	b=fOrmxdnvq9Fh14VhcqvxT6Z84K2FOugrbnzRnQgYSCCK/TFlV+oSafyYxOB9r2spDVAk
	 Vk8MKHTZdWFyJQDzpzpGehVBFySDU4mWJtZ+I1WhF+ySqlIgO5HGTrD160IlqeqSnrPP6
	 GFOdGpe9Bxt8s0I4BzHppVYSrDylrvDamm0gSE7h8LQzUNX/7vVNpadm6P9fXnWHdsayW
	 JaE6aOb811PXXmCESpPuGTYhOqZ3EtQy3Eaz5bNjpPjk3uchqlkar8KuPFfdxkY/w1mK5
	 NSQ72ED3gue9KrPfPtP0rPqAg/4sGLiKvCPRYWXKO+rheapbaugVdxFOdoDtKqr01FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062179;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=3b8qO0bGl599X1vJz6pmeM3oeJqIrIDcmlopHbGEFiQ=;
	b=I0sPULibymeQ4wX28YnVQqXK9NiFVa1aqF+11YkqwxaIYuCb3A2WGXXNwbNVZFG3JX7A
	 rFtcZCl6G7uWa4FuAxJwTE2WEJAukUZqAtwJkfwPBYW7LSKJNg2D6HLC2AXh0XcdBF2s3
	 R2a4mTN1uGp/9om+QRRbqkjVfzsl+mp9qOSCTBlYMBIGTpLRMn+pL+polU8r08tBcv1gU
	 PmKRBpI4LsXAUCNzNv20TH99gNE63h/HcBBrwVjGXVnOh7cEST/pD3Pbhni3LvAFc/QNy
	 0ndxmSa+liibaIpu4Y139LQz4+if7EnSLepszREFwmvzXCrsdAed2UiKPTtq7UsAkUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AQVLi7+S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD729606A326;
	Sat,  7 Nov 2026 14:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AQVLi7+S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C7A21F008A1;
	Sat,  7 Nov 2026 14:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062178;
	bh=3b8qO0bGl599X1vJz6pmeM3oeJqIrIDcmlopHbGEFiQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AQVLi7+SNhWLu5RXn7jVtznTAgcKnQJRtHG8C1j6MoS9wJjs9TxK3zI95Nkm8HUYL
	 5Fzrcm43yy48brfP7ljkHVh/zhph0+ogdrffU4JuOnc4PF1T1gf9mhM/vm08vj4yg/
	 y62crMoGoBTbuNBKyDzgxfTVnXDO063C0bdCrD90=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1138/1536] media: imagination: Fix value clamping in calculate_qp_tables
Date: Sat,  7 Nov 2026 08:52:34 -0500
Message-ID: <20261107135029.676559879@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit c8454a41da59d51fbcc5743f8c71a03b096a770f ]

The local variable 'val' was never clamped to 1 or 255 because the
return value of clamp() was not used. Fix this by assigning the clamped
value back to 'val'.

Cc: stable@vger.kernel.org
Fixes: a1e294045885 ("media: imagination: Add E5010 JPEG Encoder driver")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Jai Luthra <jai.luthra@ideasonboard.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/imagination/e5010-jpeg-enc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/imagination/e5010-jpeg-enc.c b/drivers/media/platform/imagination/e5010-jpeg-enc.c
index cb1f7de1b6321..e051ed0b474d4 100644
--- a/drivers/media/platform/imagination/e5010-jpeg-enc.c
+++ b/drivers/media/platform/imagination/e5010-jpeg-enc.c
@@ -175,12 +175,12 @@ static void calculate_qp_tables(struct e5010_context *ctx)
 		long long delta = v4l2_jpeg_ref_table_chroma_qt[i] * contrast + luminosity;
 		int val = (int)(v4l2_jpeg_ref_table_chroma_qt[i] + delta);
 
-		clamp(val, 1, 255);
+		val = clamp(val, 1, 255);
 		ctx->chroma_qp[i] = quality == -50 ? 1 : val;
 
 		delta = v4l2_jpeg_ref_table_luma_qt[i] * contrast + luminosity;
 		val = (int)(v4l2_jpeg_ref_table_luma_qt[i] + delta);
-		clamp(val, 1, 255);
+		val = clamp(val, 1, 255);
 		ctx->luma_qp[i] = quality == -50 ? 1 : val;
 	}
 
-- 
2.53.0



