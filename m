Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44C4179C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:52:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD484C433C1;
	Wed, 30 Nov 2022 18:52:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669834351;
	bh=3VdAy2PEBXUnn1HvDET1/q+F/baVPl6abTe7pVq/tPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=coXJBFYzAgaUnAa0v69Ft7ECvbXYMGQkKj5xmrmVLAdGsTg4QtcQhUfSUFQkT2BM8
	 rzf78umunoEyu6eH7v+FELfmnz+P5LM/40X+cr49fzLWgp4AeOz9omdHCnZnnoArEQ
	 mgUdSFdPZm4BqW7y/us0hsyH/SeS/22n4aNgeWtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gaosheng Cui <cuigaosheng1@huawei.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.0 221/289] ASoC: Intel: fix unused-variable warning in probe_codec
Date: Wed, 30 Nov 2022 19:23:26 +0100
Message-Id: <20221130180549.128057955@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Gaosheng Cui <cuigaosheng1@huawei.com>

commit 515626a33a194c4caaf2879dbf9e00e882582af0 upstream.

In configurations with CONFIG_SND_SOC_INTEL_SKYLAKE_HDAUDIO_CODEC=n,
gcc warns about an unused variable:

sound/soc/intel/skylake/skl.c: In function ‘probe_codec’:
sound/soc/intel/skylake/skl.c:729:18: error: unused variable ‘skl’ [-Werror=unused-variable]
  struct skl_dev *skl = bus_to_skl(bus);
                  ^~~
cc1: all warnings being treated as errors

Fixes: 3fd63658caed9 ("ASoC: Intel: Drop hdac_ext usage for codec device creation")
Signed-off-by: Gaosheng Cui <cuigaosheng1@huawei.com>
Acked-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20220822035133.2147381-1-cuigaosheng1@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/skylake/skl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/intel/skylake/skl.c
+++ b/sound/soc/intel/skylake/skl.c
@@ -726,8 +726,8 @@ static int probe_codec(struct hdac_bus *
 	unsigned int cmd = (addr << 28) | (AC_NODE_ROOT << 20) |
 		(AC_VERB_PARAMETERS << 8) | AC_PAR_VENDOR_ID;
 	unsigned int res = -1;
-	struct skl_dev *skl = bus_to_skl(bus);
 #if IS_ENABLED(CONFIG_SND_SOC_INTEL_SKYLAKE_HDAUDIO_CODEC)
+	struct skl_dev *skl = bus_to_skl(bus);
 	struct hdac_hda_priv *hda_codec;
 #endif
 	struct hda_codec *codec;


