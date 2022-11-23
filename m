Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 088791C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B192C433C1;
	Wed, 23 Nov 2022 09:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195295;
	bh=MA59D5WIQvHUCpoCxRHqWsIPVJ/UvRO5gbe223FpQQI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pmXJdeBqC4mPPMRuoMJ5pfRc36RReYrMJTjApGQmc8N20Jv52RAk99xXDUlNEleFh
	 YNIdnQ7IKBVG9cSIUigKGYYmKqHfoPBnFvFFM8yxsRZvQsVoTdtZT1rmyUNW+A2Qoi
	 BiDVT1HBFA1HT6Xqt+9mL8hUU5yQfaVjt29M4yAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 044/149] ASoC: soc-utils: Remove __exit for snd_soc_util_exit()
Date: Wed, 23 Nov 2022 09:50:27 +0100
Message-Id: <20221123084559.540186582@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.945845710@linuxfoundation.org>
References: <20221123084557.945845710@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chen Zhongjin <chenzhongjin@huawei.com>

[ Upstream commit 314d34fe7f0a5836cb0472950c1f17744b4efde8 ]

snd_soc_util_exit() is called in __init snd_soc_init() for cleanup.
Remove the __exit annotation for it to fix the build warning:

WARNING: modpost: sound/soc/snd-soc-core.o: section mismatch in reference: init_module (section: .init.text) -> snd_soc_util_exit (section: .exit.text)

Fixes: 6ec27c53886c ("ASoC: core: Fix use-after-free in snd_soc_exit()")
Signed-off-by: Chen Zhongjin <chenzhongjin@huawei.com>
Link: https://lore.kernel.org/r/20221031134031.256511-1-chenzhongjin@huawei.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-utils.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/soc-utils.c b/sound/soc/soc-utils.c
index f27f94ca064b..6b398ffabb02 100644
--- a/sound/soc/soc-utils.c
+++ b/sound/soc/soc-utils.c
@@ -171,7 +171,7 @@ int __init snd_soc_util_init(void)
 	return ret;
 }
 
-void __exit snd_soc_util_exit(void)
+void snd_soc_util_exit(void)
 {
 	platform_driver_unregister(&soc_dummy_driver);
 	platform_device_unregister(soc_dummy_dev);
-- 
2.35.1



