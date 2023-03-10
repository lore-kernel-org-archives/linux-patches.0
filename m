Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 316BA846C
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:32:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EAF0C433EF;
	Fri, 10 Mar 2023 14:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678458740;
	bh=FI+4ILnJi4OdEpqjWZQmWvque4LccXJCLE24wc0D2fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WYSl9BH6nNWZZe4DHmAU4kZUkzMGCSkgYvLWT+sFOYVDUZk6Jaga/VRleHxScb/qL
	 RBnqVD00B6s6g5i+vtYM1xGfW1pVeTpMAoF0mSOkrzdOtkwYA1TKvwOB6ccss8M5EF
	 IVLsku/Pt03bHwROXJHpw7gWfrexLfYSFonkd3V4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@google.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 129/357] ASoC: dapm: declare missing structure prototypes
Date: Fri, 10 Mar 2023 14:36:58 +0100
Message-Id: <20230310133740.367027115@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tzung-Bi Shih <tzungbi@google.com>

[ Upstream commit 3d62ef4280a377bb2ccaee4e8f6c5093f5b8f9d4 ]

To fix compilation warnings:

- struct 'snd_soc_pcm_runtime' declared inside parameter list will not
  be visible outside of this definition or declaration
- struct 'soc_enum' declared inside parameter list will not be visible
  outside of this definition or declaration

Declares the missing structure prototypes.

Signed-off-by: Tzung-Bi Shih <tzungbi@google.com>
Link: https://lore.kernel.org/r/20200625153543.85039-3-tzungbi@google.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: fdff966bfde7 ("ASoC: soc-dapm.h: fixup warning struct snd_pcm_substream not declared")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/sound/soc-dapm.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/sound/soc-dapm.h b/include/sound/soc-dapm.h
index 6e8a312253838..8c8988bfef8f4 100644
--- a/include/sound/soc-dapm.h
+++ b/include/sound/soc-dapm.h
@@ -16,6 +16,8 @@
 #include <sound/asoc.h>
 
 struct device;
+struct snd_soc_pcm_runtime;
+struct soc_enum;
 
 /* widget has no PM register bit */
 #define SND_SOC_NOPM	-1
-- 
2.39.2



