Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59452611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:49:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8498C433EF;
	Sun, 28 May 2023 19:49:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303389;
	bh=VvpJDmCc/TNYqMDyFaSIriBvU21n2LX02zpMU4Zo9wE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e5GlNON9RXzCUjLIZyra4PA8oGSjWfcD3Rd8ZJjs3wCxO3VApkQYTjjlw6tl+m7zw
	 KTFOqWp8bUBElY33NImLl3rnA5zbdJAp7TewALAOgEUddkKfxzN1D7svGXhnSrGXhA
	 S85wTkalZrG6KB0DKyHTJfwBmWsENDD4QKznFWxA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 56/69] ASoC: Intel: Skylake: Fix declaration of enum skl_ch_cfg
Date: Sun, 28 May 2023 20:12:16 +0100
Message-Id: <20230528190830.465238227@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.358612414@linuxfoundation.org>
References: <20230528190828.358612414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Cezary Rojewski <cezary.rojewski@intel.com>

commit 95109657471311601b98e71f03d0244f48dc61bb upstream.

Constant 'C4_CHANNEL' does not exist on the firmware side. Value 0xC is
reserved for 'C7_1' instead.

Fixes: 04afbbbb1cba ("ASoC: Intel: Skylake: Update the topology interface structure")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20230519201711.4073845-4-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/uapi/sound/skl-tplg-interface.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/include/uapi/sound/skl-tplg-interface.h
+++ b/include/uapi/sound/skl-tplg-interface.h
@@ -66,7 +66,8 @@ enum skl_ch_cfg {
 	SKL_CH_CFG_DUAL_MONO = 9,
 	SKL_CH_CFG_I2S_DUAL_STEREO_0 = 10,
 	SKL_CH_CFG_I2S_DUAL_STEREO_1 = 11,
-	SKL_CH_CFG_4_CHANNEL = 12,
+	SKL_CH_CFG_7_1 = 12,
+	SKL_CH_CFG_4_CHANNEL = SKL_CH_CFG_7_1,
 	SKL_CH_CFG_INVALID
 };
 


