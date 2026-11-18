Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020169;
	b=3N+2sRIcTyMRtJD1imNyDh+Nzh//xN9IVN4+zWDXIhOUbOu9ZagAVgoNbw8Ayw4v4IPX
	 3bw9mr9FNSyfcmuiGkjat4Lm/Te3ZlkFlwzmULzHezJ6ypSWvamsYjivQVThkBQXeHhI2
	 /rjMIJLX+zAFUexEfh5VQvNGxuaAzm72YNiP46SJq3Vt8mpeHzn0MHRjJW5DxqT6j8X+s
	 SCOg8Tm9ojMW8huAlfNYiRxPQwlBxf1NdYnVESSCcFZJdoJrVfkYJXFyhMryIQzltqPpN
	 fbyaLE62sulXSFjI5aMYnVWXb6uLnzpdhpEbUL9ls5GzRQ2FQeMRl6egWO6f8vR9MOQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020169;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5rVohFBqRPuEhxQFewxbHZ4xPRz/GCN33uY/YHXJURI=;
	b=DcmQSzrHdoK0Q2ncYtJvequcA4BNq8/wt37zNi4IGdoqf4//NkzI4GqQj1e7Qm1FurFh
	 TUoqaCbKFKRzNThO4ph6fNor0qAd2WdEfRsTR4nIswUlTuzZXqpo7DSkaus3OmlLBe0Rt
	 4S6r3aci0wJTIBxWWtiwSp5UgmCQJXZtwZPLdZz8VwEBZYr34gqXaX0bHZFS9FsyQwRew
	 Vcj3+bJzeAC2dqiaVlKvyABtUFJVK0Le1mv0mWleKky7juVx0T660a6NLDVulRcCIXmEz
	 /SAvk1eDPb0d4EkMe6BrkbGMQkNKQLQPqUEW4xs0t97mL47IjqT0D7C3Uo3V/rP4GMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MjMveUay;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1229C606A32F;
	Wed, 18 Nov 2026 16:42:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MjMveUay
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A7961F000C5;
	Wed, 18 Nov 2026 16:42:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020168;
	bh=5rVohFBqRPuEhxQFewxbHZ4xPRz/GCN33uY/YHXJURI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MjMveUaybw+DFUmT8qUBFKkMS1WDMrqNlwgx2rh+0oMHwx3m4d8SqgOzZNnIj64BN
	 pTzsNjr9yp48rfSzUwXN4Wul24YHDlq5iyBsY2rIZPm15YVonGJAxYz9645F38kktE
	 ugV915HyeoFtWiKH+atNR1xmyBbp+V4rekEx1GWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1856/2651] ASoC: codecs: wm_hubs: Fix definition of MIXINR to MIXOUTR volume control
Date: Wed, 18 Nov 2026 15:51:36 +0100
Message-ID: <20261118150353.838259241@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit 22bfcedd3febd6acc63ecf8bfd9638210e4b9a5e ]

The Right Output Mixer Right Input Volume (MIXINR_MIXOUTR_VOL) is at
bits 2:0 of Output Mixer6, not at bits 8:6, which hold the IN2LN volume
(IN2LN_MIXOUTR_VOL).

Fixes: 942c435ba79f ("ASoC: Add WM8993 CODEC driver")
Assisted-by: Claude:claude-opus-5-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Reviewed-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Link: https://patch.msgid.link/1ea1d115cea5b183dd51bba5cd9e38157b3482ee.1791959026.git.sammiee5311@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/wm_hubs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/wm_hubs.c b/sound/soc/codecs/wm_hubs.c
index f80dfc488e3ce..ce16f27509799 100644
--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -427,7 +427,7 @@ SOC_SINGLE_TLV("Right Output Mixer IN2RP Volume",
 SOC_SINGLE_TLV("Right Output Mixer Left Input Volume",
 	       WM8993_OUTPUT_MIXER6, 3, 7, 1, outmix_tlv),
 SOC_SINGLE_TLV("Right Output Mixer Right Input Volume",
-	       WM8993_OUTPUT_MIXER6, 6, 7, 1, outmix_tlv),
+	       WM8993_OUTPUT_MIXER6, 0, 7, 1, outmix_tlv),
 SOC_SINGLE_TLV("Right Output Mixer DAC Volume",
 	       WM8993_OUTPUT_MIXER6, 9, 7, 1, outmix_tlv),
 
-- 
2.53.0



