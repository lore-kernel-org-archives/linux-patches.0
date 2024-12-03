Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 674611F4283;
	Tue,  3 Dec 2024 14:57:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237874; cv=none; b=q2PDvxE8elGlXd8apypYXacwQ1nQFlkhKrk3dYYCcYo4vIhgFoxO1B8bKPNuzplQb/iRIjP/bi2ixoryvxd1rOuWoigTnpO10i0o7WDV8YHwLrGLxnun/d9WuEIbp6jmv6y+mZD+tJAmtOSpjJCYRzUnzZm4zEsYiwmkX98SEZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237874; c=relaxed/simple;
	bh=JbWQ7NigycLmy7/TjhZHZDjf1lNLCyYuYmRq7xXgpbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gYq49TNbXi9ZEKaj2lJUjYBZZxm8Rn2BidH76ft/Z+CdBSHY8lVGnww34ZD2W12lVKJKCfSHD/DpFnxAheHqM5KREsvFGjE4ccJwOzwMEZ1xSBX2wfoQSwyLdMyAYepsEYhhzM+UQMHfIyxAWzIkTnyYR5E3G9U2TCHsBLAEGo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vseA/CRq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vseA/CRq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4D68C4CECF;
	Tue,  3 Dec 2024 14:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237874;
	bh=JbWQ7NigycLmy7/TjhZHZDjf1lNLCyYuYmRq7xXgpbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vseA/CRqy3Iq4iYoiq3oSSzeuDJtkmuWngEdR/+33cXdZyLHlKpnqeSbYT0dNXkup
	 yWX78xvgRb9qpySTkgsleGwkGh9wEZRBDMak6OA+WaDfbYdiqPskGv/MiwX+tikJLJ
	 bkrmXI5rMxLtrDEKy/vy766PUScDmeg6LkzqXgmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 093/817] crypto: qat/qat_420xx - fix off by one in uof_get_name()
Date: Tue,  3 Dec 2024 15:34:25 +0100
Message-ID: <20241203143959.334535809@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 93a11608fb3720e1bc2b19a2649ac2b49cca1921 ]

This is called from uof_get_name_420xx() where "num_objs" is the
ARRAY_SIZE() of fw_objs[].  The > needs to be >= to prevent an out of
bounds access.

Fixes: fcf60f4bcf54 ("crypto: qat - add support for 420xx devices")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Acked-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
index 78f0ea49254db..9faef33e54bd3 100644
--- a/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
+++ b/drivers/crypto/intel/qat/qat_420xx/adf_420xx_hw_data.c
@@ -375,7 +375,7 @@ static const char *uof_get_name(struct adf_accel_dev *accel_dev, u32 obj_num,
 	else
 		id = -EINVAL;
 
-	if (id < 0 || id > num_objs)
+	if (id < 0 || id >= num_objs)
 		return NULL;
 
 	return fw_objs[id];
-- 
2.43.0



