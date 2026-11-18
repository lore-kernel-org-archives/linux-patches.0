Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035911;
	b=az41HBPFTyuKok79SlFlJlmH6tNlv0crc2E4SPNquXUztpfVu7li0r5tJ0Qpzwnr+zpp
	 R08ooe0HglHu69OBhyO8kIDVdduG9cS5UFNI3Er/u7gTj7jYrP7n2iTd2Q5nQq16pOYJu
	 /OCNKbAoIpkzg9IVUchFcLVCLMAGHIyWxIUqGFLwVYUt8rDVAFhJkPb8/6NYaKwbygpc6
	 bgdNni1j/6aWbF9yCVdMx/DPI8Iteu1LaBRW7Wxd4S0gDdTJqfZdvbausSNtmuAGgG5PA
	 O2bsXL4MwICUROg/KOjrV8be6rdOdA7K7/jjYhvX/LDtn0Yf1xZUeSqKISOT/9ibsAA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035911;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XumF2Rn+ZYiZcVX0lr6Hgfe2M+bY3teyDI5d8bknJfQ=;
	b=tMXNg0CkzFxxR8oSnKzWE/O0g2x1OB32f2sVwNzs5Qah6QymLEEFUBkMiOqz1YHUeCMZ
	 pQn8TTG9fLWhbEPMQYyK8/SRM75bWUqfosFincBjxUnZOPpuuQ/Xg7Utw595Xd06VClVh
	 +gSFXdNg6GeCJtWK2pZXKE3VsiejQh8fpM7iK6CKG/gz/Vkp6JY1ayuElpkPACd5tT31Q
	 bQMVqC8LgzOL5jxzt/ChG5+UKhc4cXHR1itPD0WqVjGIacc2vvdi1yr0lTyh6XbvJbVZI
	 2TVVdzuEfGjRn5MksfxvwYwPnnBy6sDKp+iTH5Wwzf4ox204mAEJyRRpcmhqafiskeA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="keu40u/F";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03DC6606A900;
	Wed, 18 Nov 2026 21:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=keu40u/F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A251F000C4;
	Wed, 18 Nov 2026 21:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035910;
	bh=XumF2Rn+ZYiZcVX0lr6Hgfe2M+bY3teyDI5d8bknJfQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=keu40u/F9c10lfvzL1/56UzKJRPc7746lOzdGHa7CysQQQ1CUoMGYuHyArfrE0sT3
	 BFUOjAnARjozhXluHpdO9dktQRbQa3Q0qeka7vqKlSm2AtYzc+CItwD+VN3MkzKpWw
	 CRQEMTAJ/RgX0Qg9qamFja0zdjEYF3EMfg+UGilQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>
Subject: [PATCH 6.6 0870/3318] crypto: ccp - Initialize DBC ioctl mutex before registering device
Date: Wed, 18 Nov 2026 15:24:52 +0100
Message-ID: <20261118150345.401765798@linuxfoundation.org>
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
index 6f33149ef80df..11c8590df138a 100644
--- a/drivers/crypto/ccp/dbc.c
+++ b/drivers/crypto/ccp/dbc.c
@@ -227,6 +227,8 @@ int dbc_dev_init(struct psp_device *psp)
 		goto cleanup_mbox;
 	}
 
+	mutex_init(&dbc_dev->ioctl_mutex);
+
 	dbc_dev->char_dev.minor = MISC_DYNAMIC_MINOR;
 	dbc_dev->char_dev.name = "dbc";
 	dbc_dev->char_dev.fops = &dbc_fops;
@@ -235,8 +237,6 @@ int dbc_dev_init(struct psp_device *psp)
 	if (ret)
 		goto cleanup_mbox;
 
-	mutex_init(&dbc_dev->ioctl_mutex);
-
 	return 0;
 
 cleanup_mbox:
-- 
2.53.0



