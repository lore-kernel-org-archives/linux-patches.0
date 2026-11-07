Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063963;
	b=Z6+DWakm+JRYuyMbNmU46TYMhmMVN0ALfRlPTJdExt7J/qtnJWW/eWfzbgZQXJT0YMUy
	 fMAt2GhBRtReGSKKWsq93lYy7dLpt8sVODW4yim2xn9YqrXtklU4aO3JOOmA0vrR81fDY
	 gihA+oPrmu/4/Z18nN8vFDSXjXD2rFWXT5QjKlgc42xAQcMfIKchqn40JLnxHA96NW77/
	 N5UKh+dns39BsCXUbTtygWKqHB3LUF5zKM2BjX1oAkydUizA6gBqHhKtX4BcC8RF+N5pu
	 sEcUPc5L+ttFmpzHoo/fuIN+rdHH02LMQx+ZTeNwVvquN0stdKVMdWA5z9FmQhE6zOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063963;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=G8qlTyWqRIcwMA0UCy5qSmZmsQqwsg/Msm2SO+nKJls=;
	b=HsgbzalfsaxmMBHO/r0kQ6cu7nec1rnhuDXdLfKLJZTGi7g9xOTcBymaehuUJ39gEdrG
	 TKFpeIqJJQCcBdfF98PhF+K4JKL1vv9iKPLuMmqYDTGVOKo5I1bvQ7hhIXwu/Egrp7Qxm
	 yMr47BsC/G6EuprwcBKD68FC1OWHF0+vFgrG7mJMT36U4rUtcju+QoCMRse01tuXY1GUU
	 lQ6veP0d+UHppYxhLZMuLZGVn5t13QeWN0oHn5znRX5X0f5TbBOHyeiBJCo05TtHfGbXZ
	 ajOpzGYzl1MSMQsMoV9DUF2HpskDgue3iWn66Q7vQWsCzJJOv8yLBiap9dPqGsZrPZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BAjVbi5w;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8519D606EE97;
	Sat,  7 Nov 2026 15:06:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BAjVbi5w
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 040B91F008A7;
	Sat,  7 Nov 2026 15:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063963;
	bh=G8qlTyWqRIcwMA0UCy5qSmZmsQqwsg/Msm2SO+nKJls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BAjVbi5wrQwTrSADjum36Q/A4U6AYxmRMX3eaw0fxcqBIPHKazPVZnKCZLeU61IjP
	 U3i3G1/fydEyISBfTlsA8On/uQWAoS0wbCCvOnU4vAm34ZFwZLyLk2LTxANC39NIS3
	 IjUAX8qFpauq0Lmda1zfPfkHBlBcIZifCcDWLpFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>
Subject: [PATCH 7.3 0150/1257] crypto: ccp - Initialize DBC ioctl mutex before registering device
Date: Sat,  7 Nov 2026 08:40:46 -0500
Message-ID: <20261107134943.457845686@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

[ Upstream commit e9b1d168f2a70c0764d5748893fdf631c504c171 ]

dbc_dev_init() registers the DBC misc device before initializing
ioctl_mutex. Once misc_register() publishes the device, userspace can
open it and invoke dbc_ioctl() while the mutex is still uninitialized.

Initialize ioctl_mutex before calling misc_register() so the published
ioctl callback always sees an initialized mutex.

Fixes: c04cf9e14f10 ("crypto: ccp - Add support for fetching a nonce for dynamic boost control")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20260829133410.1708684-1-runyu.xiao@seu.edu.cn/
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Assisted-by: Codex:GPT-5
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Mario Limonciello (AMD) <superm1@kernel.org>> ---
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/crypto/ccp/dbc.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/crypto/ccp/dbc.c b/drivers/crypto/ccp/dbc.c
index 410084a9039c9..4db49a14550c9 100644
--- a/drivers/crypto/ccp/dbc.c
+++ b/drivers/crypto/ccp/dbc.c
@@ -236,6 +236,8 @@ int dbc_dev_init(struct psp_device *psp)
 		goto cleanup_mbox;
 	}
 
+	mutex_init(&dbc_dev->ioctl_mutex);
+
 	dbc_dev->char_dev.minor = MISC_DYNAMIC_MINOR;
 	dbc_dev->char_dev.name = "dbc";
 	dbc_dev->char_dev.fops = &dbc_fops;
@@ -244,8 +246,6 @@ int dbc_dev_init(struct psp_device *psp)
 	if (ret)
 		goto cleanup_mbox;
 
-	mutex_init(&dbc_dev->ioctl_mutex);
-
 	return 0;
 
 cleanup_mbox:
-- 
2.53.0



