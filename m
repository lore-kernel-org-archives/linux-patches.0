Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795039718;
	b=IqV1U8yUPR++W463DIruaRn22Gdf2XVcd+UY1KgpbZQPZyvRaZfQ3mVlgWRKPQZEde+3
	 tFOLvWFoG6Q3OPkEJXjGBQ6vLzsj4szy7Bc+ibdWrFPIZQaw/P3ocj2kJwYSQ4e0SHGrn
	 rz94mqhnQ/o3h8UuPnqhTz9ulssU/iBUM9V/xdAB72E2xBbvr49/7/UwizsxeT8zUyRNB
	 O2Ol3cKvUn3738TucCPSDLwq7Nzoakoe/9SapFAPDGZQO3KQGwz9r1XQGRAeivnUJITJb
	 Q1tmbBQbZuNmQxTLm/NeG8iVZgrQZ/cn31kPNSrnNNqzfy3W7ItGTSynbJmr3YeqYjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795039718;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=dGXCo2kMCkvKyxs6JK5prMhyw5uvZFqodSBxr0q3Neo=;
	b=ASIZZDTi3qJ/7S6tmenV4rowh23JBvTVn8FGdt+jnuIu/60a2Oevc7pdINS2tkZa43RF
	 1dx/Os/yfzgp/+ZcS5OdOVp8Zx2veD6TTjox+Nennd8cACV51+dBchYdrYT7DWtgi5clB
	 TSyHECMk+3U2WIoDXPYTrNjtC+Jw9QwHKJJmpy/UYknOeB5w66owQMAb06L2YxGJ2rjEP
	 WlqUpMt6t9OriPT0Hfhtlwk5DeAMtyDJol485tvyzccqxazHmTxjAGDhiC9jmqwfsWfNL
	 UZa9OonqCnKtkTmCipbLFPg8WH/Xq+xliDuQLbEVeJHabFbtLa5ttzVMdy6sCQb108Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nlnihr4q;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 356CB606A334;
	Wed, 18 Nov 2026 22:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Nlnihr4q
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888D61F000C5;
	Wed, 18 Nov 2026 22:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795039718;
	bh=dGXCo2kMCkvKyxs6JK5prMhyw5uvZFqodSBxr0q3Neo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nlnihr4qrPodu1GeemBSNYitJ8Z4lpeDtPd7iyM6AAsCXboIRn0BQFx0Mvo26zixP
	 h3MHuY+GbF0imIv9R9tpls7dSj8iSh+oBvz1bcci6ZaaBuxsWLL15J4fOAge8aX03D
	 4X1bq/oeJzE2wY83BgJjry1FQUQGXZl8JSEqaVKk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2201/3318] regulator: qcom-rpmh: Fix the return value in rpmh_regulator_vrm_get_optimum_mode() kernel-doc
Date: Wed, 18 Nov 2026 15:47:03 +0100
Message-ID: <20261118150427.962260073@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 49de3d4fe63d7..1a12b9a3a3cd0 100644
--- a/drivers/regulator/qcom-rpmh-regulator.c
+++ b/drivers/regulator/qcom-rpmh-regulator.c
@@ -316,7 +316,7 @@ static unsigned int rpmh_regulator_vrm_get_mode(struct regulator_dev *rdev)
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



