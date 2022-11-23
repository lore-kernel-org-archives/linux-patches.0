Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B32387B
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 08:55:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0760FC433D6;
	Wed, 23 Nov 2022 08:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669193700;
	bh=qqO23cHMtZVwJ1INEUBOr68uYf5yMqFtBCQ9+LUu5Jw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=y9g3r6KwAGw/xZZpEFBBRnoERmaJU9VTsyj9HrbFJidl2gD/YyG4x8mWWxe6nhWU3
	 3OALgsXs+N400Qc7MkGpbNcBlQh5bQA9AZV2Mjx1cV0e3JA/dVsBzd14cdR09DRc7J
	 d8y4idMAiK7uhotEl1BbXo36tDBf20Etg89fUQ1E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Zhongjin <chenzhongjin@huawei.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 37/76] ASoC: soc-utils: Remove __exit for snd_soc_util_exit()
Date: Wed, 23 Nov 2022 09:50:36 +0100
Message-Id: <20221123084547.948645656@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084546.742331901@linuxfoundation.org>
References: <20221123084546.742331901@linuxfoundation.org>
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
index 393e8f0fe2cc..ec84b75ecbce 100644
--- a/sound/soc/soc-utils.c
+++ b/sound/soc/soc-utils.c
@@ -186,7 +186,7 @@ int __init snd_soc_util_init(void)
 	return ret;
 }
 
-void __exit snd_soc_util_exit(void)
+void snd_soc_util_exit(void)
 {
 	platform_device_unregister(soc_dummy_dev);
 	platform_driver_unregister(&soc_dummy_driver);
-- 
2.35.1



