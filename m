Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005843C199B;
	Thu, 15 Jan 2026 18:01:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768500100; cv=none; b=i21FpSrKAHayv/02xkkLWCc3X+xptEXOcF7wkpfWKLRIRDEgb4W8x7ge71nJx9gCjbL4N25ys9yG+yIDZF4l0uAG+X78yZnvNjOWL9mo27bMejk5oBFpHOahuOHslq4J75e06MmxvGykqXmOPAlwwtv5t1lkfTilm/yo46Flsew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768500100; c=relaxed/simple;
	bh=ww9HNR1/DXEVLmfLq089fCRYUnh24Xd5aTNfx5JOzWM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DfyovWm7XpW6LBQiEvhn6/LpZnQyDu2Ecv5P9ZN6tgZ1dM1j7unouQyb+VlPKVtcodT9/6RgMsnlVaoFctUf8xSq8KvmJ+pA5DPvdL4UDYkjEOxUvNPXIBe6MSh9deUTX0nLzpNlRJIfdZGJBKkfdkjJth9/Iz17KEXuU6mi/jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BxT16C0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BxT16C0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7971FC116D0;
	Thu, 15 Jan 2026 18:01:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768500099;
	bh=ww9HNR1/DXEVLmfLq089fCRYUnh24Xd5aTNfx5JOzWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BxT16C0jpK0F6wKPljS8sWRBHnqyfvY31vnbsPWvM7K7lIYfNNLUMiMoIgGLHbkRP
	 6p/FQBGbZbGPcV5gbJU2fgC2CfAoEaB9qRNIXeW6M+5oJrmjITO4lqwaItw2KvRdl1
	 Gj5ApYoNB049+I3DGT29RILRU+Bf2iVUfRwLwJCc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 450/451] ASoC: fsl_sai: Add missing registers to cache default
Date: Thu, 15 Jan 2026 17:50:51 +0100
Message-ID: <20260115164247.227138187@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164230.864985076@linuxfoundation.org>
References: <20260115164230.864985076@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 90ed688792a6b7012b3e8a2f858bc3fe7454d0eb ]

Drivers does cache sync during runtime resume, setting all writable
registers. Not all writable registers are set in cache default, resulting
in the erorr message:
  fsl-sai 30c30000.sai: using zero-initialized flat cache, this may cause
  unexpected behavior

Fix this by adding missing writable register defaults.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://patch.msgid.link/20251216102246.676181-1-alexander.stein@ew.tq-group.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_sai.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/fsl/fsl_sai.c b/sound/soc/fsl/fsl_sai.c
index 0314d4257b2de..60df490cb7647 100644
--- a/sound/soc/fsl/fsl_sai.c
+++ b/sound/soc/fsl/fsl_sai.c
@@ -773,6 +773,7 @@ static struct reg_default fsl_sai_reg_defaults_ofs0[] = {
 	{FSL_SAI_TDR6, 0},
 	{FSL_SAI_TDR7, 0},
 	{FSL_SAI_TMR, 0},
+	{FSL_SAI_TTCTL, 0},
 	{FSL_SAI_RCR1(0), 0},
 	{FSL_SAI_RCR2(0), 0},
 	{FSL_SAI_RCR3(0), 0},
@@ -796,12 +797,14 @@ static struct reg_default fsl_sai_reg_defaults_ofs8[] = {
 	{FSL_SAI_TDR6, 0},
 	{FSL_SAI_TDR7, 0},
 	{FSL_SAI_TMR, 0},
+	{FSL_SAI_TTCTL, 0},
 	{FSL_SAI_RCR1(8), 0},
 	{FSL_SAI_RCR2(8), 0},
 	{FSL_SAI_RCR3(8), 0},
 	{FSL_SAI_RCR4(8), 0},
 	{FSL_SAI_RCR5(8), 0},
 	{FSL_SAI_RMR, 0},
+	{FSL_SAI_RTCTL, 0},
 	{FSL_SAI_MCTL, 0},
 	{FSL_SAI_MDIV, 0},
 };
-- 
2.51.0



