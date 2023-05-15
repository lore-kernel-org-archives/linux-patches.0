Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E54FBEC
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0132DC4339B;
	Mon, 15 May 2023 17:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684172956;
	bh=cyChaYvj51cFxDn4xEgEXRLhmxA4nvUJY/q76OQu4oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GQnI6zs0L73+b93lNe2+yugLGaTyyv/ZBPkM9TYg1g0xrpC/YkCHgK6X1vXXtlPQS
	 E7mMeIrwB9EgrkhyG6CiTOZTzvAcd1YviufUbbB2XZOXGwjskH16+4jzZej066MkWo
	 cRrd14EdU/Sy71FMq2hNp344sj2DvIyibLjD5AOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miles Chen <miles.chen@mediatek.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 292/381] sound/oss/dmasound: fix dmasound_setup defined but not used
Date: Mon, 15 May 2023 18:29:03 +0200
Message-Id: <20230515161749.977774996@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161736.775969473@linuxfoundation.org>
References: <20230515161736.775969473@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Miles Chen <miles.chen@mediatek.com>

commit 357ad4d898286b94aaae0cb7e3f573459e5b98b9 upstream.

We observed: 'dmasound_setup' defined but not used error with
COMPILER=gcc ARCH=m68k DEFCONFIG=allmodconfig build.

Fix it by adding __maybe_unused to dmasound_setup.

Error(s):
sound/oss/dmasound/dmasound_core.c:1431:12: error: 'dmasound_setup' defined but not used [-Werror=unused-function]

Fixes: 9dd7c46346ca ("sound/oss/dmasound: fix build when drivers are mixed =y/=m")
Signed-off-by: Miles Chen <miles.chen@mediatek.com>
Acked-by: Randy Dunlap <rdunlap@infradead.org>
Link: https://lore.kernel.org/r/20220414091940.2216-1-miles.chen@mediatek.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/oss/dmasound/dmasound_core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/oss/dmasound/dmasound_core.c
+++ b/sound/oss/dmasound/dmasound_core.c
@@ -1442,7 +1442,7 @@ void dmasound_deinit(void)
 		unregister_sound_dsp(sq_unit);
 }
 
-static int dmasound_setup(char *str)
+static int __maybe_unused dmasound_setup(char *str)
 {
 	int ints[6], size;
 


