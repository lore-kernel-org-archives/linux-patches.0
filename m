Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B76571078F;
	Mon, 27 May 2024 19:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716836477; cv=none; b=igLIXZOrPoHCamWr9eKzM6UK8sqCauF7XHNbKtF/0U/Btqm0KMyol2UcNkduc0tf+vr3Yp3wlCSIxBW5+MDz3oorFLqv6uwo9zH2mkrRXUr51FyVxZOGfw3bnrG5dCZA4l3tNzBYJjzDAqS2UcWNoSUB2OiAe3OAfRQXS1S+XPk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716836477; c=relaxed/simple;
	bh=ARrKtzkyJM09n4yXoDAVzOoXiGxTPKtNgkvZvH5Hhas=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NTLfNg8pVap+AUvbG7rMghitHtjVb3rnYCIHb9Ndns+eDc2EgNl75lJzY9Hz9Rbd7t+EhiJIUcxNntQDm6w3vlzLDOnnZxciTPUUh9OddYr+QLXRaZLW2bkJHAO0ZEDKwwHqSxNqJ/k1fc0nAMSu6NFMnxeK+0VSGp56hyAGTYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UKkhPsTx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UKkhPsTx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DFC8C2BBFC;
	Mon, 27 May 2024 19:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716836477;
	bh=ARrKtzkyJM09n4yXoDAVzOoXiGxTPKtNgkvZvH5Hhas=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UKkhPsTxTSeDCwN2NoLaV61pOCd0pq7LblFcPBhwMWvoGUXvJMIuL9QQDzDbRFbYY
	 ouu+49pYR8LOjP7ctabXu0Hei3h5LgAEu63jgxiTydcYp0hcozVSl6DXTjg2+INWqY
	 VbTpQrRhAuAPwFOfreLAx+xRFycAcA1fZFsk512w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Guerin <adam.guerin@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 069/427] crypto: qat - improve error logging to be consistent across features
Date: Mon, 27 May 2024 20:51:56 +0200
Message-ID: <20240527185608.256287491@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adam Guerin <adam.guerin@intel.com>

[ Upstream commit d281a28bd2a94d72c440457e05a2f04a52f15947 ]

Improve error logging in rate limiting feature. Staying consistent with
the error logging found in the telemetry feature.

Fixes: d9fb8408376e ("crypto: qat - add rate limiting feature to qat_4xxx")
Signed-off-by: Adam Guerin <adam.guerin@intel.com>
Reviewed-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_common/adf_rl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_common/adf_rl.c b/drivers/crypto/intel/qat/qat_common/adf_rl.c
index d4f2db3c53d8c..e10f0024f4b85 100644
--- a/drivers/crypto/intel/qat/qat_common/adf_rl.c
+++ b/drivers/crypto/intel/qat/qat_common/adf_rl.c
@@ -1125,7 +1125,7 @@ int adf_rl_start(struct adf_accel_dev *accel_dev)
 	}
 
 	if ((fw_caps & RL_CAPABILITY_MASK) != RL_CAPABILITY_VALUE) {
-		dev_info(&GET_DEV(accel_dev), "not supported\n");
+		dev_info(&GET_DEV(accel_dev), "feature not supported by FW\n");
 		ret = -EOPNOTSUPP;
 		goto ret_free;
 	}
-- 
2.43.0



