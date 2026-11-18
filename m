Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023835;
	b=DGH7bRABa7Fd0RPD/9CR3j7no3fF20qzjCNTDw9PDcOai/MUtxpPknbe8QTW8BrWj02Z
	 36cokp0jLxwuFggkfuRfXt2PoOBdHaCShz9H5zmJ9uEHC7uXzCkBOwOt86zB8Uy0Ybg/U
	 aSJ48g7qPlZVzl+sSYZ2lZINTIeee8N57RLO4g8PrZskS809+uLFYseKUk6ZtrVbnSDLp
	 FnCNAh5/YDv+VzqbHNxTWWTR7Dq+FtTOkA08Z6yky3uV9PU+Ei6K1mzKEX98ZhU4TnGTL
	 exVg4hLtIDn8R/NxPCv4UczrftfR6VF6ojYp5/MJh8r/SqRSsBUve6fTXpetnD0nHgg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023835;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=hP1NEHKbyDBtY4rYRHC1Np1aO8iG404vKUBeDAIcKmo=;
	b=Y2LCcd7UYxfZh4yXMiXEgJ+HGvY7b2gchiSk9HMOn5Fg7qG4KzRCs/blWukApNHGeeja
	 HCjLrzI/WcwY01vS4o1KIlQAvVtGanA+Kcv4kMo3NZBn26mSA42dFELQI12Nq50u7hhTO
	 r8MlOZnOwkUujAkWw5P5RyOZ4nPe3MEZZx95sp4Hjlef+w0pzaHvB8LnwKV52/50HBwOS
	 oSXAQ9AD6cphJvt0JWRtR4QoFacxtQazZpi5I/R2L1yAATl0KwPzYZ/L0G0U9pW3lThas
	 Xi9FixDZrR1KiScVvVqW0TJAa+FBMdNkFlIICbxikbvQLjvCY9VmS7i8hjZt1vs1CJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w9NvHkTv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA386606A320;
	Wed, 18 Nov 2026 17:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=w9NvHkTv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 039821F000C5;
	Wed, 18 Nov 2026 17:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023835;
	bh=hP1NEHKbyDBtY4rYRHC1Np1aO8iG404vKUBeDAIcKmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=w9NvHkTvkVsSXYoW4nWY978ZDjGJJHYIMUxnQtK2vpR1/uEEOn6IhVa682DFnCI/5
	 UPXrP6RXot+/JzTJ4uUNTwSthrcpVclHJ1L0KE5fmhXQLcP5YbWfgAHi3ArhpMJygo
	 MM0gFb5tEE2iWhoL5LJe4xN+tGpJdiu43t0vYJtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?=C8=98tefan=20Ghe=C8=9Bu?= <stefanghetu9@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0474/2151] ASoC: SOF: imx: Prevent stack OOB read in DSP panic dump
Date: Wed, 18 Nov 2026 15:36:49 +0100
Message-ID: <20261118150139.282463444@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index e787d3932fbbf..1f506e606b012 100644
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



