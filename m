Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062905;
	b=Vb7GrxbRWG+ajc5SK8+8PSlfp+GUO00jWUMD36KER3VYv+kDfErpYfgq5fhv8XlFfWm6
	 mQVaA/b8i2IPSPtrZCTO03JuJCbbLXEYu5MO78vcTW8su3xI8UF4DmwnYmrtr8zYgBYFi
	 LPUl47on7SnNWgI7OvQDTVUhC4Ng5OT4SKKP+QyjZOgUL/usTZew2buoWsYoKD8sjKeyI
	 eGx+x6vmA2jl8Q4cdQMNfRlVwWAXbaWZUVHxPURh/w5n3wNaKlo5EwzoYfmHq9c0I/OG4
	 3lIr7YS5Z/+xR9hFAgHBUf7kqm3YRHl+jQEebSlpqhndEXsKatIxL17pc77vzWjUndQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062905;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xg131+0GUT9Dth/i0Fa87uOg8x5PDRLISmbwIkurU60=;
	b=XdT2pUa7ksYbVMZHUr073QARTtRJSao4kuJjgsW12Qa6XyAbsCjaIr+VSXtG/EeL1xko
	 8OyD+tk3GlOcKfomUPVW1jk9fMT7zN9j+BZbNMTUjhUg1ytYXx2iV7pTTAsQmGOMNrEWR
	 lrefQgSf05npiIKwoMkgzxqn9sBhSMPNA6EGqiNoU+iZFU8tgksWP1AtRawa0enEupLng
	 oFVcwkbDERekH6tKxWRzxHa/0OwGJc6vPDQH4y9Zch3yrpu38rAi7Zc7iqYv6CiTfQI7r
	 zo8knhS1LerKbGTfmC3eq8E8/WgaslJ49GzhLpBmwjJcm2Coim3doD30L9zq47OLZTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OqI3B98a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7304F606A326;
	Sat,  7 Nov 2026 14:48:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OqI3B98a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8741F008A1;
	Sat,  7 Nov 2026 14:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062905;
	bh=xg131+0GUT9Dth/i0Fa87uOg8x5PDRLISmbwIkurU60=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OqI3B98acHSnr96FTD3Ru8LyeBQ6tYDf9BkYoM3VhYSZwuzRTVm8enbsk4fS+8jZM
	 VgWjtEEOPKFHkv3ZYF7ZwE05JUoa9MGOEUXghEH39+iSAeSbU4NNv/GLmyoGv7U2dl
	 vFXmWAf96+X2kSsov0d0/4mjPMBxP0B8b0uIwbfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>
Subject: [PATCH 6.18 130/869] crypto: ccp - Initialize DBC ioctl mutex before registering device
Date: Sat,  7 Nov 2026 08:46:52 -0500
Message-ID: <20261107134856.872144739@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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



