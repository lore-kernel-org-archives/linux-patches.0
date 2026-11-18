Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795023712;
	b=Vv2BiM5hfGv6jEX8qdWZUz77k0xin/9Y+7teSs10cbz9mKPiglsnWzZ3pLuwCPmtFroN
	 II/kLNsgCPG+06KRKXwSsUY4gTZVlVrr1JEca+NeTmF/LGqmmdf+z8s2Z3aDnQgHZ9Yqf
	 xgDu0Bw5t1fydWRDNEzYY/UGF+ZLbxoDWCMD71NgpSyHJ396lNrYYiGMUIGNrBufyco9m
	 wMS6xrn7f2oaioakdCpCuSSaRVCOW1jSi3C17PQtxcGNKqnVEJXJETswZ76LQukBo/+4U
	 kRxpeqjiulqgy67NCAUHth7FWtCxjhfPyDGOr26dSrewnga7EkRWBLRTfto1HWe2OWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795023712;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=MD9ReW8ieRm0QmpUe44jtzj0uEuFWZCFyQQ9UpBiSWM=;
	b=OGhrqcwVRdHMsw1avYsQkYSJbdjQxy4XxObL1wviCToL9FAkjxWfjS1KEzcZLeUx3ib+
	 3HfAzEBdi5Bh5IWstSiZ1CpAHrU3GFok2T5LnzU07IlPnbkkpl1u93w2ZhUYwlJV1ah+W
	 sEPSt9XZu1uQoSQGbrLElUAovGYq3oxub1NKuAlHi3N+7yLSRTxmkThovFmrTi8y0D+KP
	 CKF7CmnlaCSBtspXhKCrrxWKx3YYw6+7bqgw/wCNIA0Cla+j0RFnVfXs7jNlm/I10b0cl
	 b3p2CS8OYvwkeMibgasB3lWfDQ6v9a4Jkg88RVuVm3c9OaCtwRQdjTB6lFHeUr3ZnJw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vtCXf3QS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B43F2606A325;
	Wed, 18 Nov 2026 17:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vtCXf3QS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EE0C1F000C4;
	Wed, 18 Nov 2026 17:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795023712;
	bh=MD9ReW8ieRm0QmpUe44jtzj0uEuFWZCFyQQ9UpBiSWM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vtCXf3QS/35/WJ8Bf5bCZmONCC9OYcD1M1g9L6pu3QJZv+wKBI1fs5/i34LgVX1aQ
	 6VWHudSQyoNg3U6LGm5+CjMEZCHF+IlXWdnKsPIj2SZZbWwNDYo+oFBa5PhBOqa0yv
	 IMEJpOAuq+4nHtb1TyZVOqBP9TJ50XwR1Xoxe9gA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0430/2151] regulator: qcom-rpmh: Fix the return value in rpmh_regulator_vrm_get_optimum_mode() kernel-doc
Date: Wed, 18 Nov 2026 15:36:05 +0100
Message-ID: <20261118150137.712730752@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 51d6888b51e0c962250311b2cbfe5666da31dc0e ]

rpmh_regulator_vrm_get_optimum_mode() returns REGULATOR_MODE_NORMAL or
REGULATOR_MODE_IDLE and cannot fail, but its kernel-doc says "0 on
success, or a negative error number on failure", which was never true.
Describe the mode.

Fixes: efb0cb50c427 ("regulator: qcom-rpmh: Implement get_optimum_mode(), not set_load()")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260912000606.34614-1-kmehltretter@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/regulator/qcom-rpmh-regulator.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/regulator/qcom-rpmh-regulator.c b/drivers/regulator/qcom-rpmh-regulator.c
index 933eb0c28fa65..1081a36d88b0d 100644
--- a/drivers/regulator/qcom-rpmh-regulator.c
+++ b/drivers/regulator/qcom-rpmh-regulator.c
@@ -319,7 +319,7 @@ static unsigned int rpmh_regulator_vrm_get_mode(struct regulator_dev *rdev)
  * This function is used in the regulator_ops for VRM type RPMh regulator
  * devices.
  *
- * Return: 0 on success, or a negative error number on failure
+ * Return: the regulator mode to use for the load
  */
 static unsigned int rpmh_regulator_vrm_get_optimum_mode(
 	struct regulator_dev *rdev, int input_uV, int output_uV, int load_uA)
-- 
2.53.0



