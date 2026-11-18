Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055493;
	b=ali9JN2hVnRj/5UsrVxFZDNWO9MUXuvFCp/weiMWcO179Kd5NDeN+7h1jLfMPWelrj0D
	 eH8MNhVmLkpfuYZlDMNEEjKguohV2kHY5lP/KWqo0FtqdJn8LLycgyFl7+qHc8xhamcsT
	 FtUUee9ZUSRkdOBGaSSGnHWuP0W5d/3j3D25gL935SuYls+i9ee+Cotcg6NpjYnR/DOVi
	 ALcJ/NRLy/7zAmGEZryDBAu42V6Gvg5J9SzA9IbDcBeZ8FdOJ3DyqQTczWA4vhTZYTFSy
	 9PzCVCmB2IlMF8NZDS1ROiFNwBTsxH9YMAyjJstrLVR0xNKVPcEJ7stJrkwKESSjqBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055493;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=R6rtNhJnZJIpHJndztVOjqySILCwTdLlRhkYmzkeK4g=;
	b=S7ozn23261D0dHjgbv5hUEQNnYwxfHV2ZpDesxjI1u9HqApcU+RCjNM9vPKuMJGLtELc
	 y4SOslwDsX9M3wS2hoURabuzxCqXMxYb7RjkCjTtj7JFNn6Brv6H0PpeWpFuQI2plNE2x
	 /ooFRPgR1KsUh43OO2BMFEaTD2KnRXEhj3nAMWHg7tNzrgWpq41FcHJOJtuzRUtqc8q8d
	 hmKEcvjRvqd8AKlXnzR3Kra2BNQS6upJB+UVqy/kIppQSN53505fv0d1N0NabN2r6gxVJ
	 hvma++TaRELJEWIB4+nRrPsufJhHTEORYTtJEOGcANlSQD4+Eqb1ViCb2xxtZXmBA/w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TYp+jDSb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C61D606A31C;
	Thu, 19 Nov 2026 02:31:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TYp+jDSb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAF431F000C4;
	Thu, 19 Nov 2026 02:31:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055493;
	bh=R6rtNhJnZJIpHJndztVOjqySILCwTdLlRhkYmzkeK4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TYp+jDSbp4g4e4ksTUB3D+ywqbxb4KYzGwYEBzOawyGP2x6k8PrZfwCagUidcju6x
	 FWy87epEo2fx82GJDo/Le0l/ocFdv4IDNu1dTOkoywqgYOA1i+XLbBakMj12feut68
	 HTXZ7G9QvRIOTkAkjoRYi4WpRWpeQUnXTYFELMbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	bui duc phuc <phucduc.bui@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1652/2214] ASoC: mediatek: mt8192: Handle regcache_sync() failure in runtime resume
Date: Wed, 18 Nov 2026 15:55:28 +0100
Message-ID: <20261118150117.983987491@linuxfoundation.org>
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

From: bui duc phuc <phucduc.bui@gmail.com>

[ Upstream commit d9e264741b041fc9dffc555bc1ab68708658cefd ]

Currently, the return value of regcache_sync() in
mt8192_afe_runtime_resume() is ignored. If regcache_sync() fails, the
function continues execution with clocks enabled and regcache out of sync.

Fix this by checking the return value of regcache_sync(). On failure,
restore regcache to cache-only mode and disable the clocks enabled
earlier in the function.

Fixes: 125ab5d588b0 ("ASoC: mediatek: mt8192: add platform driver")
Signed-off-by: bui duc phuc <phucduc.bui@gmail.com>
Link: https://patch.msgid.link/20260918133912.133799-11-phucduc.bui@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8192/mt8192-afe-pcm.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c b/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
index 765889f3fae0d..dd325ce6aaa81 100644
--- a/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
+++ b/sound/soc/mediatek/mt8192/mt8192-afe-pcm.c
@@ -2107,7 +2107,11 @@ static int mt8192_afe_runtime_resume(struct device *dev)
 		goto skip_regmap;
 
 	regcache_cache_only(afe->regmap, false);
-	regcache_sync(afe->regmap);
+	ret = regcache_sync(afe->regmap);
+	if (ret) {
+		regcache_cache_only(afe->regmap, true);
+		mt8192_afe_disable_clock(afe);
+	}
 
 	/* enable audio sys DCM for power saving */
 	regmap_update_bits(afe_priv->infracfg,
-- 
2.53.0



