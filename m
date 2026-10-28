Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213662;
	b=C7VV/OGF+3694DemCvfUbKB2IUK8bM8B6l6ZCJyevowT6Rz+Ffy8Ldiug5l+haFjd4fj
	 CNBldpD+gfsKxXIfsODeOg4I4SNrawCTEcqaR32RtGPooHCELX03OhLre3VoyQcacQP9L
	 wQIkZ02ZCfX6GpGsAdRdnVBKD1wFuUgVMIVIN5iW+mLaZHL9E+8L2eNRrv0W0gE6YUrB3
	 aMJS+gd9TWCU2dEzfGJBaxaZw5LagDtVdNgLHScNIRmqfD9AoKYLSzcDPqSfQvWgn506F
	 fi30wLpgb73hB7h5XFUYvskc9f/kSOFwzLOGzUdmpSITOVKD2Gv6F2QPQC3TdtyO0TA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213662;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dEQqgy/ZokkOUfVJjTtb5PwYWohTBwH/7D8EE8UK3QA=;
	b=lsL5KEOKbEXm38i9WYAlz0wjQG7YhzLF9GOptOn0RgMJfnXdrsZ5vIhYEG22Ie9W+20v
	 jy7KFjsZAeY4YIu4PQYQmvdv/ojBjxzZGCppctLWL/mu1yHzTuSWcAMN3ZCU6jyx2BHn6
	 2EZnkzOMSDBuPKogFhV+if/mBc3i6iwWO87+qMMHENolZwydUiZOlwI+A+kpvui5OvPGc
	 C/H9qT4xMDgAxzVGFBsEj0Ua+m7MYm5TbvxmbFNOme5C2WuXgxuhrge+rFOWdNbRiXSUt
	 y7jNQMDw/83UXpkrkS2Cu2lnLuMDQVZ+noAGbMRvlQTUe+++LhHCc49y8cLqrWu8ONQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0RNCSiA1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89DE5606A31D;
	Wed, 28 Oct 2026 18:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0RNCSiA1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF091F01825;
	Wed, 28 Oct 2026 18:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213662;
	bh=dEQqgy/ZokkOUfVJjTtb5PwYWohTBwH/7D8EE8UK3QA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0RNCSiA18epYb6W4w9WJbntV9SsuHBjCPC4RWAQ39hTAtWA7F9IbsD6EKKNgFLtCn
	 F7dW2yfpWbaFiqEZytIDKWGJWlGFyuh8VL4rHKxyYMe0v3C1dYnWjkDgNOrv+JN41M
	 aE9NG9zznSwUsVt5bsVKYTfXw8djhNDverUVFCHQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Colin Ian King <colin.i.king@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0586/1887] ASoC: qcom: Fix uninitialized pointer dmactl
Date: Wed, 28 Oct 2026 17:44:42 +0100
Message-ID: <20261028170512.757649029@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Colin Ian King <colin.i.king@gmail.com>

[ Upstream commit 1382d8b55129875b2e07c4d2a7ebc790183769ee ]

In the case where __lpass_get_dmactl_handle is called and the driver
id dai_id is invalid the pointer dmactl is not being assigned a value,
and dmactl contains a garbage value since it has not been initialized
and so the null check may not work. Fix this to initialize dmactl to
NULL. One could argue that modern compilers will set this to zero, but
it is useful to keep this initialized as per the same way in functions
__lpass_platform_codec_intf_init and lpass_cdc_dma_daiops_hw_params.

Cleans up clang scan build warning:
sound/soc/qcom/lpass-cdc-dma.c:275:7: warning: Branch condition
evaluates to a garbage value [core.uninitialized.Branch]

Fixes: b81af585ea54 ("ASoC: qcom: Add lpass CPU driver for codec dma control")
Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
Link: https://msgid.link/r/20240221134804.3475989-1-colin.i.king@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/qcom/lpass-cdc-dma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/qcom/lpass-cdc-dma.c b/sound/soc/qcom/lpass-cdc-dma.c
index 31b9f1c22beea..97c240e8bec38 100644
--- a/sound/soc/qcom/lpass-cdc-dma.c
+++ b/sound/soc/qcom/lpass-cdc-dma.c
@@ -258,7 +258,7 @@ static int lpass_cdc_dma_daiops_trigger(struct snd_pcm_substream *substream,
 				    int cmd, struct snd_soc_dai *dai)
 {
 	struct snd_soc_pcm_runtime *soc_runtime = asoc_substream_to_rtd(substream);
-	struct lpaif_dmactl *dmactl;
+	struct lpaif_dmactl *dmactl = NULL;
 	int ret = 0, id;
 
 	switch (cmd) {
-- 
2.53.0



