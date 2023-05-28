Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2532569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:32:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F297C433EF;
	Sun, 28 May 2023 19:32:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302352;
	bh=ZboSLQHg0uXKIp7399sNffB/1ROGbYi7M8sQgCN+aTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b1IRmmrt7GmIl4TmWIAyPKShlfkqy0a7z333yar/zN4aEzRrOuUyb180PZUVTSrzu
	 KjBkOZvweErzPUgrh4vfMmIOwwSg1JZQtNFjhs2r2znsqYaRrouzlhR+V7Gu4EXBoG
	 8FYqq42YCiJOLgnXnh+xgcJs2ZWT9NMPVzGAVCDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.3 101/127] ASoC: Intel: avs: Fix declaration of enum avs_channel_config
Date: Sun, 28 May 2023 20:11:17 +0100
Message-Id: <20230528190839.572987439@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>
References: <20230528190836.161231414@linuxfoundation.org>
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

commit 1cf036deebcdec46d6348842bd2f8931202fd4cd upstream.

Constant 'C4_CHANNEL' does not exist on the firmware side. Value 0xC is
reserved for 'C7_1' instead.

Fixes: 580a5912d1fe ("ASoC: Intel: avs: Declare module configuration types")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://lore.kernel.org/r/20230519201711.4073845-5-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/intel/avs/messages.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/intel/avs/messages.h
+++ b/sound/soc/intel/avs/messages.h
@@ -619,7 +619,7 @@ enum avs_channel_config {
 	AVS_CHANNEL_CONFIG_DUAL_MONO = 9,
 	AVS_CHANNEL_CONFIG_I2S_DUAL_STEREO_0 = 10,
 	AVS_CHANNEL_CONFIG_I2S_DUAL_STEREO_1 = 11,
-	AVS_CHANNEL_CONFIG_4_CHANNEL = 12,
+	AVS_CHANNEL_CONFIG_7_1 = 12,
 	AVS_CHANNEL_CONFIG_INVALID
 };
 


