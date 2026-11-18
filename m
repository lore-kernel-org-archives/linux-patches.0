Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048229;
	b=Qh7U6hfVzLaeDuO2cKFwU/0OYsGpHrNzb8g06z60bYP53LcNMzv9MsKGaq+bKGy0TR3k
	 C8BXjHuPzxuiF6BcVNpKdoyENHTutrNEl3ShI31dS3zErJ6C443FvoPvmwL5qnN/AIH1t
	 aU/4UMe4z1sG0kj/AKv2mZ2HKbBDHieYlYAIk0bEI8JqkmdnrZ0l8KiHdlYbVkyJtrDFm
	 XMTKlU4HubOO/C4vj8JYbdEAgh7dJcc/0TtXoSHgaUplfptYavBxjwWyFFYN+A6pol8X+
	 lrhQTiSmQhgtbNru6Z0+qZPhJwFn5FDQjIyiPpeva0wZnAvMgt594NLfL9p8ev2af8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048229;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5Q1T+sQWMcT3S0Td1jFo0EMJ6LKGRdJ/CSxld4gTfEw=;
	b=SXQp8uyjHR2d2Z3xPL4hI4kU02K48Tyr7UgP6zHBPYgJJRiwoaaUnBvO0RLwvoouivBA
	 6nI/3wzWkt7w6oTvTCfEFN6la1qjs93+k++DkvtFpkbrjMde5PpwhvNrO/kG+5nwl/zx9
	 zuSd2V/ZjHyuyAsy9Grj+3dN9Reb86ebkbbshg2qmMeT9dbz8CYprTjELApiKr783ZyiL
	 yBzaEsHp5TL3Pa9yA21Sn1X+L+mkQ/o8sxORmM+H4P4bntHmkLm4Cc9g/VsbAt8Lt0ZKV
	 9SY3XvxWLqSKenRwrXQH/TkKXXQO51NBd+ZpER6SLiIwvdQKuFNyLhSmtANHF7G03Rg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pxHLZdhx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0053606A32F;
	Thu, 19 Nov 2026 00:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pxHLZdhx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FDB21F000C4;
	Thu, 19 Nov 2026 00:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048229;
	bh=5Q1T+sQWMcT3S0Td1jFo0EMJ6LKGRdJ/CSxld4gTfEw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pxHLZdhxmOsm3upuZ+pYI0TUh7zd/uuAR8pMHqN7KqNWiGqTFZFLa/grXAbuIeWCI
	 jBmQkvWpGWCZAa1uFFqq4k7jLvMACa0wCOz/fS2o+Qvfmv0FnuSDRVzUwA5GPxZa/0
	 l8zzM35ocqFVdFvX9TBlNfN82mPRP8Q4Ycm3ISzI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1920/2857] regulator: qcom-rpmh: Fix the return value in rpmh_regulator_vrm_get_optimum_mode() kernel-doc
Date: Wed, 18 Nov 2026 15:49:14 +0100
Message-ID: <20261118150310.342205511@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index b7c168972e48d..8af1a39867a66 100644
--- a/drivers/regulator/qcom-rpmh-regulator.c
+++ b/drivers/regulator/qcom-rpmh-regulator.c
@@ -317,7 +317,7 @@ static unsigned int rpmh_regulator_vrm_get_mode(struct regulator_dev *rdev)
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



