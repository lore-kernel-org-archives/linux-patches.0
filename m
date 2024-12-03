Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554821FE461;
	Tue,  3 Dec 2024 15:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240163; cv=none; b=FZiUMqoY3u34xOPcxIsZ1V1DDijySViRNHp6xr4S2hIqGLb8wArQimGGwRDoQnq/dLbNDTBre3JmjA8bEdfnubSXkykjNz5FKZykiQvwmdbF0wjLUKsI67cuyXutaUOmlkipUk0jLfgCdGNk5qwX6kktEYoIiLLvJY/8B3oQjWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240163; c=relaxed/simple;
	bh=9pO1pI1OcTWpnqkTINnQ4vqOAsy8s6YuPAw4KtjljxE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PMqP1sInjEV9pgL9rtkyC1vfCW2THuZMverZbcdxXjGpvZOnGMb52DVaiRxyXr0WQUS9PW8SMa9FtJGSdXKb3+QQJaPWKZsd0kjJPcn+B/yMliraneV0hYwvQK2cYkm1QFMiQlnhwjU1771YpaeQ0DaEOKDObPDReSHFWUsHs8I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CVMoPVpn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CVMoPVpn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D140EC4CECF;
	Tue,  3 Dec 2024 15:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240163;
	bh=9pO1pI1OcTWpnqkTINnQ4vqOAsy8s6YuPAw4KtjljxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CVMoPVpns1O8Mlo8sJL1D3DU+ysXXTKi4JYaoTCR9+53Py6wsjkDEtiDLZAeZyDaW
	 idXeGmO/ArKcZyU4yssH5q3UERYbRTBTTMvmo5Srvg6yCzXyI3Of1r45UDoTQ6+pZZ
	 1wGFkQQZfEMKpwfYgeiVQcCe9univXdw+Om7JglY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Giovanni Cabiddu <giovanni.cabiddu@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 045/826] crypto: qat/qat_420xx - fix off by one in uof_get_name()
Date: Tue,  3 Dec 2024 15:36:12 +0100
Message-ID: <20241203144745.222257356@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



