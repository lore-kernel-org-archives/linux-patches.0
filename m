Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026637;
	b=Rh8a4mKUwn7tpxaoTX6uzvh7v3yiLdcmEl22FbV8DGT07nCcVXJIAzZoebt34A+ZyPKu
	 2L0Ldv/jT/61/vB5q1fWsj1fw8reLZAbvW0EqNgJBnDt5/YPJtCqWAnQzyTbaQ79Zq08A
	 r43E2S3eeO37r+aHMD25k4ISzqwcCHDJihRUJanZSZPKXk4fTrODBMD1HE8bh+13cUe1q
	 JBTnLy4wxrq5JRMFGAh4O53CETdLU6g2flnrxc2KKJGdfg8nSjoszeTtRwKb/LYx4w0MU
	 OcLvizez3qLBJLXR9OXewcctt3Wfi2pQ4dj6RL8gVXRDXjN0mw6IDhXYInptairMPZA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026637;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WI1avGzZcgjxlhkXlVOwb14W4invH+aNTtSrzgQXoSM=;
	b=Sn+uhQu+vri1tAinnwo/nZXnd+rwjqXiua8kRbifOwekfqx5V/UiWUI1BzY7go7w5uMm
	 5tzqB84YbuETPkNBHl++qPc1dwiFGpsvVFIrJZwWuQgFz/G26lbduxyT3t7eJwIZLyJ8E
	 jBEdGN1ex5mfG9XHNjw5BPp8gbO2SJIezE/kZcCuYGM45aPt+yoiatOdFiQpJendS+rZB
	 sZEoVgCrTPrF5jsIel8VC5d0dfZXbpJaP8KQrHMectN5kRSjE50nJMpC8hOihjVUMH1YB
	 TQnEIuvARYWoVcxDTgWI2nP6TGTAoJhKfOs00fkpOH1f6pGc9u67BKBB6dlKuwOOnuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FntOwbOf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E1D606A31C;
	Wed, 18 Nov 2026 18:30:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FntOwbOf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3ED861F000C4;
	Wed, 18 Nov 2026 18:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026636;
	bh=WI1avGzZcgjxlhkXlVOwb14W4invH+aNTtSrzgQXoSM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FntOwbOf8KeDmoMGtOBtFnS0aPpaDv+NNFFT0AFdvBWPeik/DUe1KlbELv+4T5xNQ
	 tAsGE+lNaeng166rnIfAQhcb9Wtz4FxZH4tz+GH/5A3OOw7Nb6GO4BeXZ/aUQr6B/Z
	 c6TIRBju9GsVz4pXET6ZYpst77nyeaayB00BxA+s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Priyanka Mani <priyankamani2100@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1468/2151] ASoC: mediatek: mt8365: Fix out-of-bounds read in get_iir_coef()
Date: Wed, 18 Nov 2026 15:53:23 +0100
Message-ID: <20261118150215.372426908@linuxfoundation.org>
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

From: Priyanka Mani <priyankamani2100@gmail.com>

[ Upstream commit e913917febd31998e3d0b9e8c861e538a6185045 ]

get_iir_coef() looks up a resampling coefficient set by reading an
index "k" from iir_coef_tbl_matrix[][] and using it to index
iir_coef_tbl_list[], which has 8 entries (valid indices 0..7).

Before the lookup, "k" is only rejected when it is >= IIR_NO_NEED (11),
or equal to IIR_RATIOVER (9) or IIR_INV_COEF (10). The value 8 is
neither a sentinel nor a valid table index, so it falls through to the
else branch and iir_coef_tbl_list[8] is read one element past the end
of the array. The bogus coef pointer and count are then returned to
mt8365_dai_set_config(), which dereferences coef.

The current matrix never produces 8, so this cannot be triggered today,
but the bounds check is wrong: it relies on the matrix contents instead
of the size of the array it guards. Bound the lookup with the actual
array size so only valid indices reach the table.

This was found by Smatch:

  sound/soc/mediatek/mt8365/mt8365-dai-i2s.c:271 get_iir_coef()
  error: buffer overflow 'iir_coef_tbl_list' 8 <= 8

Fixes: 402bbb13a195 ("ASoC: mediatek: mt8365: Add I2S DAI support")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/all/67af3580-a907-403d-8bfd-76b5c304ab99@stanley.mountain/
Signed-off-by: Priyanka Mani <priyankamani2100@gmail.com>
Link: https://patch.msgid.link/403cc04bb103dff096edf72b99ae6868ee91f359.1791782072.git.priyankamani2100@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/mediatek/mt8365/mt8365-dai-i2s.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/mediatek/mt8365/mt8365-dai-i2s.c b/sound/soc/mediatek/mt8365/mt8365-dai-i2s.c
index cb9beb172ed59..527d131b4f478 100644
--- a/sound/soc/mediatek/mt8365/mt8365-dai-i2s.c
+++ b/sound/soc/mediatek/mt8365/mt8365-dai-i2s.c
@@ -267,7 +267,7 @@ static const u32 *get_iir_coef(unsigned int input_fs,
 		if (k >= IIR_NO_NEED) {
 		} else if (k == IIR_RATIOVER) {
 		} else if (k == IIR_INV_COEF) {
-		} else {
+		} else if (k < ARRAY_SIZE(iir_coef_tbl_list)) {
 			coef = iir_coef_tbl_list[k].coef;
 			cnt = iir_coef_tbl_list[k].cnt;
 		}
-- 
2.53.0



