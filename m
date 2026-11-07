Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064363;
	b=Vn75aPiR194aKrNIjf4JHJiWOxu/NYUD+/4Ecvj2MMI5SlVuiX1U1O0DqmI6dSvMC4+j
	 OVJzgH+FzoLT66PriFfssCUbB0LlyLgc0l1+/qqjiXDeXJmW7ALcQPCPPfQeKJ5DDjctr
	 1ptfEBzv0C5dMfq+lVBL9GfO+psoENTGrVI1RBKMR1Hj1YWbE/5A1Y1hOFk/a+tbyockF
	 nshmWF17xod6gRuuJLxk2WsH31SsrkEEq0zONFsv4StmJv+NOjnpTdfZ12QTbUhjLxSOt
	 lgymYcfIF1/eI4+nqMwLP94WhTIeQ6jr1ICoOWOhdOTk6aEFao2JQQ4xO5GCSy5JSKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064363;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fjyt+UbeObWcYSCApn9X8Nt0JIWpC3MLJVJp07/L6xw=;
	b=Lb/3agnpExMYPAu4Yrr1NcF1LCdSPzd2UJOBP9T0z6OmWdYUgFVduLmkrm+Ie/wmSu61
	 pwY91Fb3DJtT/Kgz4NFPj9c6Q0Jyh7os0vMbEg8atC+fjOyI6/NsniPCulaSBI1EftFOG
	 y8+VuzRZJISNHF7lo/5vwD9QFRmHeAgtMx+SZRTLIrMYLavBOu6pZvji6IoqkqWnxSqQv
	 CVc4RCKwWsXjCUUJkLzMaVV2GXa2qCXW/gKAqxBZktA946YGeOjXxxKNYZSR0aDo5ExwP
	 p18YwbJWhYibRmrDOYgjbySaMz+DCuHS4B/ndNWou40hKv2eo0+hx0zIQInxXV4sabw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EqOMsiJh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05188606A339;
	Sat,  7 Nov 2026 15:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EqOMsiJh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F521F0089F;
	Sat,  7 Nov 2026 15:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064362;
	bh=Fjyt+UbeObWcYSCApn9X8Nt0JIWpC3MLJVJp07/L6xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EqOMsiJhYcXmcJ4i0XF1JrR2fXk5DSG3m0mV7F35adagrRWf/gMFyjv2rSGPUHreg
	 JvpY4QOWbzyCJEBY+S5CKROHNRVtQhmaYox3ICBKva0jwtq+cS23zinqvG1waX5EP3
	 odPLCzBU5KZQXYvRcZtxcv1A50hnkYqbQS4SuqAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	Jai Luthra <jai.luthra@ideasonboard.com>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0444/1257] media: imagination: Fix value clamping in calculate_qp_tables
Date: Sat,  7 Nov 2026 08:45:40 -0500
Message-ID: <20261107134951.747521705@linuxfoundation.org>
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
index 42ad9ee3993b4..420cb8bfdb12a 100644
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



