Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061985;
	b=xovKJrLz7ndOJhpsynq4FwkzgY1oCvyuYbBwhjeDVY9CEDbeFHwStSFjnc39LxfajB6W
	 /CYpR5IAU0YlcvmGvaUOJFnjsjuF/GzKleQKt5POHiAuJMWdInKCToYW4LqGlBhZpUgqV
	 Ujjl0UjDzzEJJJ4WEgRbAnbg4bLQKq3Q/GX5Lbd20uHCzTn51Q062Q6UdzrgxqXLyWGsJ
	 u/8yYkLV4hDfCcZdXVzWIWpvbeR2y1j6qmF7iZ0NmsaC7D/T/qRgf0BhsnJUBYDUdofZu
	 JdLLh9A3SKv+R7ciHGD/PsURYxDCEmS5Fj/4dRkKy7kW9gmzmWm2tmgQ12RAPxzz0CQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WVDqm4q+jNU587JVQTP5si+AY7pJRXzChVVcZ6mDobg=;
	b=mfYcPuho8p6Pj2EJZvgX9K4iNP7nmzwowGhjJE+7rPkQePZ9UVOolSLr18cuoBAjMj6w
	 Z1jOCMOctBTWaRm1qvBWh6/Og0OKJAfH7lMkee1UtU4ppjzp1JZTfs/GrWqSWB2HjhMMQ
	 TIemAURuSUPlCz8KdZc63V5BfhU70hB5jz0oVL4SNbvmYu1Gu0nuKdC8y5BM8fsrvvz+l
	 caPz35xTQn/Zl3PsuZYkTfJt2mxmmZlDb4mCdIuYYR9Yb3z7tQO8N5EB1GBA7lzxfFgQi
	 0yrveejPRKHOH7llXAQ+cpKJ2KHb1f6vb5wgUOIeVlVUVUIqDwBX/1UyHvnMBFlRtwQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="yk/twkV6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE38606A334;
	Sat,  7 Nov 2026 14:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=yk/twkV6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2649B1F008A4;
	Sat,  7 Nov 2026 14:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061985;
	bh=WVDqm4q+jNU587JVQTP5si+AY7pJRXzChVVcZ6mDobg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yk/twkV6tZZBLhw6zERPZJ4b4kWOOkM9fhknp/daIyDk8dM1dP9XseSdyjxpx8wdy
	 m/oaBj6ReEwDft3nmKjbBaocO7OHpp/wHClSCwXYX7Bhfx6sUAFH4VegsPqlrUYhkm
	 6LcMRj/+1ROiZ7CQ7YrGi9V/LxV6tqz+QOHKocqQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>,
	"Mario Limonciello (AMD)" <superm1@kernel.org>
Subject: [PATCH 6.12 0977/1536] crypto: ccp - Initialize DBC ioctl mutex before registering device
Date: Sat,  7 Nov 2026 08:49:53 -0500
Message-ID: <20261107135025.088950898@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 5b105a23f6997..c9a4431ec80e5 100644
--- a/drivers/crypto/ccp/dbc.c
+++ b/drivers/crypto/ccp/dbc.c
@@ -249,6 +249,8 @@ int dbc_dev_init(struct psp_device *psp)
 		goto cleanup_mbox;
 	}
 
+	mutex_init(&dbc_dev->ioctl_mutex);
+
 	dbc_dev->char_dev.minor = MISC_DYNAMIC_MINOR;
 	dbc_dev->char_dev.name = "dbc";
 	dbc_dev->char_dev.fops = &dbc_fops;
@@ -257,8 +259,6 @@ int dbc_dev_init(struct psp_device *psp)
 	if (ret)
 		goto cleanup_mbox;
 
-	mutex_init(&dbc_dev->ioctl_mutex);
-
 	return 0;
 
 cleanup_mbox:
-- 
2.53.0



