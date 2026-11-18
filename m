Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056255;
	b=uk8U6b4cHjUSqPjKcmeTnY+VYZXAQQ+/7G1hayDQgdRTIuAtv3FL34dCmuzQmxV/7e3J
	 sYo7kMK6FePZ28rPkGFEgpZ+6mW1zfVSNP3Wkj5beT0Cd+bjOo9yGn97jq0tPHU02VcWa
	 7bc2sCAG0r6ggNamdt2q7bSoI4IYOrL0OoDiC2J5nhRzZ56g62qZJDM3Wqefl8w5uhZ2Y
	 01lLKRi9crAeCOtSOJ71NKz41ji6J0nX3bjj2asxguoDzykKTPocrURLUJRlh1Xl2qw7I
	 CfH+SkSUYNtWqwHWQhzIGIH57Ll8H3NG5JVIkgqRBrF/a2+vw/rhT5dy3zXkOhZeZCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dpEOlYyv5Uzhm29+E0Aeseo9i6TE83V8wxGvD3eZvFo=;
	b=xVE1HrjbI6zIqfk0UPKIjm+phlE7jZYv6gMyssfDo1FITbP/Ev+422uV6nFD/Q9XZVGL
	 uaA1BcOjCphFXDWV0eHPmdAnO0Xoun6qfa3ditIYi525O4no6Jyqb2SB76Ci8cmqP72eu
	 hDi5+mCB43vVCWN24nEUO0tRNIGeEoAKjbFUdzW5IjgkOitHKChUjqGkbMgTzqtDgoWRo
	 aLHA3dgfI62wSWnRgD8yQZGpsmpKJsHDCbzcJDIwXJsnlpEKSor/gKB+roppn6z4+jwJ8
	 oYVzgubuPPYKg8eT5AyehN2dZ8xNpsAMCygaa75K06C2IeucDCxAWP4E+nxlg4Y2/6Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t1NurJcv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2076F606A320;
	Thu, 19 Nov 2026 02:44:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=t1NurJcv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D50C1F000C8;
	Thu, 19 Nov 2026 02:44:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056255;
	bh=dpEOlYyv5Uzhm29+E0Aeseo9i6TE83V8wxGvD3eZvFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t1NurJcvCBSMTJl9aQSpqcIlPWrci7hb+8idFs4IUX+ufdZGuaW/3xF7A7xGxikvz
	 bNj/rVwmQLPQqLArLAw2CTlXZ0DHwR/65nAvuj6svJjd528UiX5ja/Nt9HPoeT6gEX
	 w/lXmlSYfiNP5oC1P4/MSCLlSmkbvAYCdKZ/dCb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1922/2214] ASoC: codecs: wm_hubs: Fix definition of MIXINR to MIXOUTR volume control
Date: Wed, 18 Nov 2026 15:59:58 +0100
Message-ID: <20261118150127.940660558@linuxfoundation.org>
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
index 0c881846f485f..3b0cc340bfec9 100644
--- a/sound/soc/codecs/wm_hubs.c
+++ b/sound/soc/codecs/wm_hubs.c
@@ -426,7 +426,7 @@ SOC_SINGLE_TLV("Right Output Mixer IN2RP Volume",
 SOC_SINGLE_TLV("Right Output Mixer Left Input Volume",
 	       WM8993_OUTPUT_MIXER6, 3, 7, 1, outmix_tlv),
 SOC_SINGLE_TLV("Right Output Mixer Right Input Volume",
-	       WM8993_OUTPUT_MIXER6, 6, 7, 1, outmix_tlv),
+	       WM8993_OUTPUT_MIXER6, 0, 7, 1, outmix_tlv),
 SOC_SINGLE_TLV("Right Output Mixer DAC Volume",
 	       WM8993_OUTPUT_MIXER6, 9, 7, 1, outmix_tlv),
 
-- 
2.53.0



