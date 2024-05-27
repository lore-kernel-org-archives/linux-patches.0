Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E40E15FCFC;
	Mon, 27 May 2024 19:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837775; cv=none; b=LZM3n+3IY6M8d+aRCfB1TLQBJIxvYqV/fV7Dqtw6rw66p7nxlPjImcO/xAzRpu2T3ZrzKz8255Py4FtpM9a8WJJymLA0pmLKS2nNB9VeiwTyQe3UxPayoqrcQjkOfbeT0u4VM6vEaGiGbqz+GOy959FTyvdAJCim+uQpMwKwKAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837775; c=relaxed/simple;
	bh=+m0ya4MSXjRlJDjkMebri4JPcifeXj0z5yfIBAAiiWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qTMgmbK/N+nXx8KX8pKgl7Jgi4hRLc2+NKtMHRKGGrPyaHMPl+dpLTbVQR3bhXaDg80MvEQZXENHfXa0n1zhrGEHqJmb15AXbdN8zQQrDUNZQ43i8yzqjLRNgA45IM0DRElnnnu86Mjw++IpCe70m8poSbMzVknbF73smwAutsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ThfAyHKS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ThfAyHKS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20F46C32786;
	Mon, 27 May 2024 19:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837775;
	bh=+m0ya4MSXjRlJDjkMebri4JPcifeXj0z5yfIBAAiiWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ThfAyHKSVdh7wgDvrhEtdUho2OtE69WLxFfvP1+SxrvA0rEiCZBEJfAkHBFjsyX4I
	 b/g0kA3HwbAlgPMvSAvSkIx/RQxe45zmXMXogXoZ6cn1YEdWt6Q/1urtRg5sZ8QG4m
	 D/Pc4kKizLIw+c3eH1lGewRKMLKtPPy0t0YJPZNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adam Guerin <adam.guerin@intel.com>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 141/493] crypto: qat - improve error logging to be consistent across features
Date: Mon, 27 May 2024 20:52:23 +0200
Message-ID: <20240527185635.068317304@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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



