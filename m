Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030825;
	b=tKXenIJrCNzyMPzLYIPsqpRV1FWlA39WyOEnbRHPt4qieoaBa6rcB8PX4aFsAVx5uayo
	 xYvROf8yIKG3b8o5pSpYB3Kr3IbsQKMVxIkKugdt2YZa3TaBwMo5ANZgwI/5+7l1PFiw4
	 5M39uQmLwILzRWbh47X3ssBL1+rLjOJ5IIv4veD7cnCdwKWhk/L3YDo7pPwt3vBXeInJJ
	 CoGLiuECW3JR2oY1PxpCC5SBA2Cmbs5f3ZZVCotpxbQJst3eciZLKtBHEybtaJCfB06Hm
	 vnfKWzVGb532v4mxPg1AaarY7fBev1NcEBFz1Xxym/uL6fYDTNoNGsQJorEModHG2tw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030825;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ttfFqzz5Xpt193KwEUKVPOjevscQxLhHlz2Ny5kDCvI=;
	b=5K95jTqj3FFCIKLYP7iL6h0pP2xU5AqxRnX9+TNagJ5MtJe+odKQmimAAtuP7Qos1MwJ
	 aTok2Vv8itc/0Ydlmod1Gaelgu7I0KJq51i29u5rxNNDQGGa5pyS2cftmUUq3kze9MbBX
	 HigP7D4pfZWgp5LFZXWUXQp4P1GAiUUnBVtVD9dwBn05CuElWYiCOhYB1WLunFjdJSwsa
	 Ll0TfBMxOyXV6pKuA7M+Qb5E8ujbBpyBo/L8fzNViI8Ys1hlg8gZU905KOURGg82CA0BH
	 BJpVdiTIITPvJufm/lafTvN7G+UFyRWZnPYv3qLgAAll2ZJ9+U4nvZVn7C9iScewwjw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Pb4/UMXb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC4D606A92E;
	Wed, 18 Nov 2026 19:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Pb4/UMXb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42F121F000C4;
	Wed, 18 Nov 2026 19:40:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030825;
	bh=ttfFqzz5Xpt193KwEUKVPOjevscQxLhHlz2Ny5kDCvI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Pb4/UMXbg2mjGzPdfVA8mOuk5fFiXdWbtffq1gmPhVu5YsI6Xd0pPfl4kfMnndGPK
	 yCZw8izLqo/AByel6SeMgCyveRRS/sPDc+c82+x5p8yRkmOrWpdKBKI71WjMEzrLAo
	 +H9Mm3pTF8EyGYfSeUxOmERvmVmUGCfb8j44i9OM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0843/1756] ASoC: rt712-sdca: always cancel jack work on remove
Date: Wed, 18 Nov 2026 15:49:30 +0100
Message-ID: <20261118150042.994785737@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit c7d07df95ee7ce7859e6c873a76d19ea9c64b6fd ]

rt712_sdca_sdw_remove() cancels the jack work only when hw_init is true.
rt712_sdca_update_status() clears hw_init when the SoundWire slave
becomes unattached, but jack work may already have been queued by
rt712_sdca_interrupt_callback() or the jack initialization path.

A remove after that status update can therefore skip the cancellation and
leave delayed work pending after the codec private data has been freed.

The work objects are initialized during probe, so cancel them
unconditionally instead of relying on the mutable hw_init state.

Fixes: 6c39710da75c ("ASoC: rt712-sdca: Add RT712 SDCA driver for Jack and Amp topology")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20260925145019.2290367-5-yaojiale02@163.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt712-sdca-sdw.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/sound/soc/codecs/rt712-sdca-sdw.c b/sound/soc/codecs/rt712-sdca-sdw.c
index 90d5aaddbd5b9..9c970e6235994 100644
--- a/sound/soc/codecs/rt712-sdca-sdw.c
+++ b/sound/soc/codecs/rt712-sdca-sdw.c
@@ -378,10 +378,8 @@ static int rt712_sdca_sdw_remove(struct sdw_slave *slave)
 {
 	struct rt712_sdca_priv *rt712 = dev_get_drvdata(&slave->dev);
 
-	if (rt712->hw_init) {
-		cancel_delayed_work_sync(&rt712->jack_detect_work);
-		cancel_delayed_work_sync(&rt712->jack_btn_check_work);
-	}
+	cancel_delayed_work_sync(&rt712->jack_detect_work);
+	cancel_delayed_work_sync(&rt712->jack_btn_check_work);
 
 	pm_runtime_disable(&slave->dev);
 
-- 
2.53.0



