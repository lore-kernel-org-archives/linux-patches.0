Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016373;
	b=qohz+VweNBafe3neuogF1uiJCqIrIrbr8KoeLS86olhNqE0eRrcEaoqDpFfPpbaqfUBo
	 5umfZVt2gZ+UAogUHOTXhrTrfX5LExkMZHCpoGyk0yMUrTMdzgH6pnwYY+1eOqo6d1mLu
	 CQXU8GBNQ3dKy7c0HY1x0GnhyCkDb+2EvFv4odqCtD+VbxZLmKupNp+axHLy56WXtZkLE
	 BPEn4lk8aPXDZMKz6uIB7ok9XSDRR2ff3L4RHXt9pZv8po9fYSMaHUkIv0sKGlWHxfEV4
	 2eecdVhC+b1Qp/uEUXKLSOz1P8KXcEIHH0sUHepXWLOGAFaCe4oBmPHHJbCFhJSazqA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016373;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/+FqOT3Rbw+TxI8ENLcMzWdxXRTMWZiyoPncPzfK2x0=;
	b=ybdVMdaK/6u84GQ4JRlBXsKftkxCgeILr5rBORrlgXn09bqpGp6o+nut863qdSWY/oUE
	 MpzlY/KOEauVAdyPXvXjXckYgSxtiSW5D5IJBg/7KbJOpqLVTs7/dLKMJZlvSa3nJxjWV
	 q18qaZiogFIxg5fcbEVEAtkKTBGiUr8dR1XOeQ6oVXKTfFj7QtQF+HiO0UeE+2W9RIF1F
	 5JGqHyL/dc9GBEK9Sxf08aNcpOxPBwNVTDStfojHvMdB07zQ80JsfSRPjmdRpXEZ4iwav
	 +kKPC3c2WtzHqwQ7KxCrTtK13kjpz6RKdHA3j8CnApLL1gRaBWoi5/C6+K2IcCByh4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="DeDlpbv/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B108560A2606;
	Wed, 18 Nov 2026 15:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DeDlpbv/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11EA41F000C4;
	Wed, 18 Nov 2026 15:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016373;
	bh=/+FqOT3Rbw+TxI8ENLcMzWdxXRTMWZiyoPncPzfK2x0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DeDlpbv/Yvh1Do7vT129e91WdS2NYlXOlfg6YiM44Uk8BfNkQL7ZSZap1z0RBizE3
	 FG/ePXffqb9P13EkL079m9FsKqjvxOq43D8nErUqPjGO/T1BbPb7T01KbnkYmTjErv
	 ofkjsC4T/1BIk4+zVmd0G6i3ynczD/Cp46ONOfmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C8=98tefan=20Ghe=C8=9Bu?= <stefanghetu9@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0505/2651] ASoC: SOF: imx: Prevent stack OOB read in DSP panic dump
Date: Wed, 18 Nov 2026 15:29:05 +0100
Message-ID: <20261118150305.943033254@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ștefan Ghețu <stefanghetu9@gmail.com>

[ Upstream commit 48ed992bfbe53537ad1cbc8ad68f7031e7ac0af3 ]

Commit 58bb5081cba1 ("ASoC: SOF: Xtensa: dump ar registers to restore
call stack") added a shared Xtensa helper that iterates over a flexible
array of AR registers (`ar[]`) controlled by `plat_hdr.numaregs`.

While Intel IPC4 allocates dynamic storage for the AR block, the i.MX
IPC3 path reads the oops message into a stack-allocated struct without
backing storage for `ar[]`, while leaving `numaregs` unvalidated. This
causes a stack out-of-bounds read when printing a DSP panic.

Clear `numaregs` to 0 on i.MX since the AR block is not fetched or
supported on this platform, preventing unsafe out-of-bounds memory
accesses in the shared Xtensa helper.

Fixes: 58bb5081cba1 ("ASoC: SOF: Xtensa: dump ar registers to restore call stack")
Signed-off-by: Ștefan Ghețu <stefanghetu9@gmail.com>
Link: https://patch.msgid.link/20260908170740.276800-1-stefanghetu9@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sof/imx/imx-common.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/sound/soc/sof/imx/imx-common.c b/sound/soc/sof/imx/imx-common.c
index 7a03c8cc5dd47..436fe49246ba8 100644
--- a/sound/soc/sof/imx/imx-common.c
+++ b/sound/soc/sof/imx/imx-common.c
@@ -34,6 +34,7 @@ void imx8_get_registers(struct snd_sof_dev *sdev,
 
 	/* first read registers */
 	sof_mailbox_read(sdev, offset, xoops, sizeof(*xoops));
+	xoops->plat_hdr.numaregs = 0;
 
 	/* then get panic info */
 	if (xoops->arch_hdr.totalsize > EXCEPT_MAX_HDR_SIZE) {
-- 
2.53.0



