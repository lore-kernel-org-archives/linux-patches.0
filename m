Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025525;
	b=Ji4BVbcy4zHf9lItfruUHpUPkkR2ZN3z4MTvvZt4QCyCGlX1S3n+9Yhlpwzp91B3/BD2
	 EUaEq5RyVFe5Gf3dUwtesHK1zq8dsmSNS9cKpo+1YgtHongwYN9bx5nb0g3leH9hTCRCx
	 kZbE6DjNV6HEgiRbrAfTgmL8PLhbtOD4YSYmXS9fLykM1Ary5gSX3bleiUtnvYxcc+l7s
	 +egsE4HTJwQvTwjQFgmldoXry1kFt3y4hXHBuC6C/N3UdxIXe9NABbTWNzOknbgCez1N1
	 Wk9yRcqsrxz+tOJkwdtob4ixm7jafv6rZnlYKT/51UQpsxKF6zFJHtFOKLFDSZ5wgoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025525;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X4avgIJvaubaNwHp4K6DsuQmiAV3Ypp/NnV4oW3WToI=;
	b=hCyN9Mrl/SCgsQl0/rikJBc5x4jk7V9/GSbMcNWGDpEJdgw/fwicsP3Q7uLMTqbM0haL
	 uEyY7UYOZIxznszSL5VdduZlKyoFBBw2zVrFh85DLBgiC4NMyGlkuvGS2JhdM8DNZDqJn
	 iU9zPe1EHznLsbO0FkCRVz8+IK8aagThprKlnPX+L0F6WKEp9FH3E8aEGlYYDfKSIfzKn
	 SLo+Saq3P3tRa5DYZx8l70NXA01dQGBhPTTtfAKR/U5GBoWmgv28k0TohJAcuyL4jfIlO
	 l3lhuGp99VNrwvFSWNp7+ATv3Ic8RJUEYvXYz3NROGr1SLqq0ntY/iQ44E7ExOxuqHw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EaZ10dJo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F00606A31C;
	Wed, 18 Nov 2026 18:12:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=EaZ10dJo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0B91F000C4;
	Wed, 18 Nov 2026 18:12:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025525;
	bh=X4avgIJvaubaNwHp4K6DsuQmiAV3Ypp/NnV4oW3WToI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EaZ10dJoqcETN4cRmvFi6FvZ8/yfqyzwbRtp0GJJWj5um+z6DVV3u/9KX1XkHOfjW
	 GkgUaRbzD0CGaKfizL9mrO06QZbbh0VW0z9f3EqeN2OE06A/XRouzwrgNWO/Q+rXk1
	 lsnl+rj/d5RtJTn3f+H3vLUn17m0BBIonHVWBcrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1068/2151] ASoC: rt5682-sdw: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:46:43 +0100
Message-ID: <20261118150201.198520059@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 9a98f7e955d35e0831fb179e88e98cf9bc0e001e ]

rt5682_sdw_remove() cancels jack_detect_work only when hw_init is true.
rt5682_update_status() clears hw_init when the SoundWire slave becomes
unattached, but jack_detect_work may already have been queued by
rt5682_interrupt_callback() or the jack initialization path.

A remove after that status update can therefore skip the cancellation and
leave delayed work pending after the codec private data has been freed.

The work object is initialized during probe, so cancel it unconditionally
instead of relying on the mutable hw_init state.

Fixes: ac63716da307 ("ASoC: Realtek/Maxim SoundWire codecs: disable pm_runtime on remove")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260925145019.2290367-2-yaojiale02@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5682-sdw.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/sound/soc/codecs/rt5682-sdw.c b/sound/soc/codecs/rt5682-sdw.c
index 055bea0a4a3ba..5be8005fbff67 100644
--- a/sound/soc/codecs/rt5682-sdw.c
+++ b/sound/soc/codecs/rt5682-sdw.c
@@ -694,8 +694,7 @@ static int rt5682_sdw_remove(struct sdw_slave *slave)
 {
 	struct rt5682_priv *rt5682 = dev_get_drvdata(&slave->dev);
 
-	if (rt5682->hw_init)
-		cancel_delayed_work_sync(&rt5682->jack_detect_work);
+	cancel_delayed_work_sync(&rt5682->jack_detect_work);
 
 	pm_runtime_disable(&slave->dev);
 
-- 
2.53.0



