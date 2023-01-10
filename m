Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 851466FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:18:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF4B0C433D2;
	Tue, 10 Jan 2023 18:18:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374722;
	bh=nbEQCC/a/+NsXj6d7pAHo1OtVx4lNUjq9z845PL8KLE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fLzUhOGlboFPJRSlEgoq+ZzzUuRB09X5YS0jcHgPRsY5ykZUEn4dfw+O0U5gpZegK
	 oPYKYJiu4w9i82k9lCCo4y5JFe8heWnvTD3hWwSBe7WwpnZpu+hWAu2g97TqnAkNGR
	 XAVD+6I9sNZjQ8vhqklCYypuoqW5Gz0hBhbiKtdA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	YC Hung <yc.hung@mediatek.com>,
	Curtis Malainey <cujomalainey@chromium.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 112/159] ASoC: SOF: mediatek: initialize panic_info to zero
Date: Tue, 10 Jan 2023 19:04:20 +0100
Message-Id: <20230110180021.858949235@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180018.288460217@linuxfoundation.org>
References: <20230110180018.288460217@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: YC Hung <yc.hung@mediatek.com>

[ Upstream commit 7bd220f2ba9014b78f0304178103393554b8c4fe ]

Coverity spotted that panic_info is not initialized to zero in
mtk_adsp_dump. Using uninitialized value panic_info.linenum when
calling snd_sof_get_status. Fix this coverity by initializing
panic_info struct as zero.

Signed-off-by: YC Hung <yc.hung@mediatek.com>
Reviewed-by: Curtis Malainey <cujomalainey@chromium.org>
Link: https://lore.kernel.org/r/20221213115617.25086-1-yc.hung@mediatek.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/mediatek/mtk-adsp-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/sof/mediatek/mtk-adsp-common.c b/sound/soc/sof/mediatek/mtk-adsp-common.c
index 1e0769c668a7..de8dbe27cd0d 100644
--- a/sound/soc/sof/mediatek/mtk-adsp-common.c
+++ b/sound/soc/sof/mediatek/mtk-adsp-common.c
@@ -60,7 +60,7 @@ void mtk_adsp_dump(struct snd_sof_dev *sdev, u32 flags)
 {
 	char *level = (flags & SOF_DBG_DUMP_OPTIONAL) ? KERN_DEBUG : KERN_ERR;
 	struct sof_ipc_dsp_oops_xtensa xoops;
-	struct sof_ipc_panic_info panic_info;
+	struct sof_ipc_panic_info panic_info = {};
 	u32 stack[MTK_ADSP_STACK_DUMP_SIZE];
 	u32 status;
 
-- 
2.35.1



