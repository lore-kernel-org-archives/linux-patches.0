Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055460;
	b=bKXDu/jLiQn4u2oGyPafJuy3zOjXdfAj3ibs/3RuvyRAmLgXwl/ceJ7/w7Z1BL1UkzPh
	 hZbxccu6PkjK14UbqidSphgOTWrtVh4Vxj8zrBc/LxhLucGI9mhO6kwh7fEJmMkq9FGy4
	 +CNsrY5YLvVPbS52dhqgJf+AkIUYCmTfBzjHsxCaZYPp+TGrVRCL6aOFdXM7vNaaMqH0k
	 j4+Z2F9pr2MBWn7IEcmmsuPV5ic9JuIfKXIPGn4EAfJ9jwxuj1sElh5abJN6lIXsSV3WQ
	 PFy2IPdW32Wpol+C4hsixi+sgbPfT2eV2HiDe8QNSnJRUGI3yIkVfyGj2v1rcizuiCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055460;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BOB5h46uLOQD/iNzti39UcfVB4aPJ3G+jxDsk7+/gw8=;
	b=q7wfF7qiVraG54994uCc8h5Ho/U17geaxUoNIBU6FP0k5X2uTzwMc69ojn/A63xfKWc0
	 Z1eq6B2ypHGXPFAF2H+jnNIVvhM7IPDb9y08lzk+hk/VJYvkkhIXlQ8J8OBd2/y/AXlwG
	 2ecuRx2pxCnsziqYlyXUHgbm7c81LO3MIrb7JsadCkoZTrGuca8Ory6LYTyOz3QB9feAu
	 QDeWjjQa36BaZZlFZyFaPBjl9+o9QOMDImzmTDKBB039C/Ig5DQcCDUFh4+X6yUTcCj7e
	 5hjzeRZZHGjftVq80i5zKUulYchFEvPgs8uhF4FMIauorJhSmE45VM1i3ff1R//9dcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Z0YB0/Af";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A300606A31C;
	Thu, 19 Nov 2026 02:31:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z0YB0/Af
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA0F1F000C4;
	Thu, 19 Nov 2026 02:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055460;
	bh=BOB5h46uLOQD/iNzti39UcfVB4aPJ3G+jxDsk7+/gw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z0YB0/Af/0QVBV/NVjrxloK9fcTqIM6GdKIwr/osKMe0oAGkDYiybOk/ff2QbEZTp
	 Dg0B1ltJz4s/eKXCZp2FpiJt0MlJlTs1XiOT5jc0B3MSFG6CQC5wGqge38lD+9Seos
	 lyhd0tMvmwBvbXK1wN5/6gk60adi6wlKYbBFtnCI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1598/2214] ASoC: rt1011: return cache sync errors from resume
Date: Wed, 18 Nov 2026 15:54:34 +0100
Message-ID: <20261118150115.890490603@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 432734a00bfae17baeff1a83b61bfc9c2ab20c12 ]

rt1011_resume() restores cached registers during component resume but
discards the regcache_sync() result and returns success. A failed replay
can therefore leave the hardware register state stale without reaching
the component error reporting path.

Return the cache synchronization result. The ASoC component wrapper
reports a negative callback result and retains the established
best-effort resume state, so this adds observability without introducing
rollback or retry semantics.

The successful resume path is unchanged.

The issue was found by a tool we developed.

Fixes: d6e65bb7ff0d ("ASoC: rt1011: Add RT1011 amplifier driver")
Assisted-by: gpt 5
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260902013256.93072-7-pengpeng@iscas.ac.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1011.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/sound/soc/codecs/rt1011.c b/sound/soc/codecs/rt1011.c
index faff2b558687d..58495058178ea 100644
--- a/sound/soc/codecs/rt1011.c
+++ b/sound/soc/codecs/rt1011.c
@@ -2048,9 +2048,7 @@ static int rt1011_resume(struct snd_soc_component *component)
 	struct rt1011_priv *rt1011 = snd_soc_component_get_drvdata(component);
 
 	regcache_cache_only(rt1011->regmap, false);
-	regcache_sync(rt1011->regmap);
-
-	return 0;
+	return regcache_sync(rt1011->regmap);
 }
 #else
 #define rt1011_suspend NULL
-- 
2.53.0



