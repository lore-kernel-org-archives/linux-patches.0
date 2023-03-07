Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D841BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD36C433D2;
	Tue,  7 Mar 2023 18:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678215274;
	bh=In982eKzMfEwU31y4cLmnSk2EsWJfMJSLyCrumuLseI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UjzD/mq76bqEmZAjIfoxIsCz/5/j54lSxuyoSjNFFwhH2HMve5ziJI7gOzdLt/Qpi
	 8su7rrih8NfBnLzQO0n+vHPhmekof4xkZzB1Dgm5KwwE6PC9Oo2daCAIWevJaQvO1h
	 Y3o3sp4s3koMaElFe9nTipmGGTfVvNEUEFitDcXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Alexey V. Vissarionov" <gremlin@altlinux.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 190/567] ALSA: hda/ca0132: minor fix for allocation size
Date: Tue,  7 Mar 2023 17:58:46 +0100
Message-Id: <20230307165914.186073780@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexey V. Vissarionov <gremlin@altlinux.org>

[ Upstream commit 3ee0fe7fa39b14d1cea455b7041f2df933bd97d2 ]

Although the "dma_chan" pointer occupies more or equal space compared
to "*dma_chan", the allocation size should use the size of variable
itself.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 01ef7dbffb41 ("ALSA: hda - Update CA0132 codec to load DSP firmware binary")
Signed-off-by: Alexey V. Vissarionov <gremlin@altlinux.org>
Link: https://lore.kernel.org/r/20230117111522.GA15213@altlinux.org
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/hda/patch_ca0132.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/pci/hda/patch_ca0132.c b/sound/pci/hda/patch_ca0132.c
index 801dd8d44953b..c0cb6e49a9b65 100644
--- a/sound/pci/hda/patch_ca0132.c
+++ b/sound/pci/hda/patch_ca0132.c
@@ -2455,7 +2455,7 @@ static int dspio_set_uint_param(struct hda_codec *codec, int mod_id,
 static int dspio_alloc_dma_chan(struct hda_codec *codec, unsigned int *dma_chan)
 {
 	int status = 0;
-	unsigned int size = sizeof(dma_chan);
+	unsigned int size = sizeof(*dma_chan);
 
 	codec_dbg(codec, "     dspio_alloc_dma_chan() -- begin\n");
 	status = dspio_scp(codec, MASTERCONTROL, 0x20,
-- 
2.39.2



