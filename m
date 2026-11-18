Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016211;
	b=UbskT+mojzEFA+98VpVgMj88IMnmf5OFulqamUjUBxoGhsZUl+AtwMAO7W6B9ccOm/+7
	 TDuxRtDr8XgRLCtfFwDPASPVALuJ7gLY3c5VRiX3qH24syeGfEQqYuRCkgxEojUP8ijZo
	 eq+2dUsZffXb1Oz3HVoyt2o5X88pJd3EanxtyiTjsWOG+ElolV52OAE9PSILoYCSYwZ4e
	 kGlRiOck0YDO4nZtrDe7GV/meD1f2DSMhzByNZq0lSTS9TMH7hP9iNRhJ1uMZoYHFudnC
	 97iDCW4v84Semw2/wHkHfxLyfqIVWwBfOc4PMvw14cDrQwECSaPfV982ggLhTLeIVgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016211;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wUVjle8Rl+gslcNNOZP1jBJtcR0f9RbhLxf6snEgrfA=;
	b=2acK0x3NCiZvjYWau/WKo+gJ9jhqczO+p5/3sAQ4wHc37+fsGLBI8w67J2CacVHbLlT1
	 7s9t3SL0r222++s8FgVtHHHzG8uScw5AwIo+85OL3WBQDaIHYtOMJumAiLFkYCBS3ferQ
	 VY5ysOPxmqzCR+m66zTwYMmxfCaxO4mmiyV5tySfsx9ZhEdNXCLXUr4gU4k2cGQGNX9hA
	 MEhz6Vo77CiKe6elJugZCUYXg2+3pdOk9YbPn1QKAC6WN5fuVuJ1PZyt15+fYgEKa4qej
	 VAfaqQ4a8WrR+rv/Py9TnrvYsE4OKahPD/zvzU5S66DdPxxpLM92A18N3jmDHL7J1IQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Z/dQBzke";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2154A606A31C;
	Wed, 18 Nov 2026 15:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z/dQBzke
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 729731F000C4;
	Wed, 18 Nov 2026 15:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016211;
	bh=wUVjle8Rl+gslcNNOZP1jBJtcR0f9RbhLxf6snEgrfA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z/dQBzkecG2zEXrixCb2WTRxah8ZbYLUClX1lQfJjzs3mLOkcqWnLqeYyTTyhnQnu
	 W1IbEiN4kh7mMeFWRnKkFem53B5CNApwhwSt1WME9q0YjrusihytNglsFqDq2JfJtS
	 GljQkGfwuUxSK6yUHPU5GErscSo017s/cAwPuj1Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0448/2651] regulator: qcom-rpmh: Fix the return value in rpmh_regulator_vrm_get_optimum_mode() kernel-doc
Date: Wed, 18 Nov 2026 15:28:08 +0100
Message-ID: <20261118150303.941641196@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 25c14de3cd8b5..7db5730240e25 100644
--- a/drivers/regulator/qcom-rpmh-regulator.c
+++ b/drivers/regulator/qcom-rpmh-regulator.c
@@ -400,7 +400,7 @@ static unsigned int rpmh_regulator_vrm_get_mode(struct regulator_dev *rdev)
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



