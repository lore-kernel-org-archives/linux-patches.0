Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062526;
	b=JADBqT4UZ3Cs7Sfg250f6U5sCMIdgNhyVc0uGt+DBeO0S+zmnHb9puw4Kb2nlsQhZGa3
	 XPH5ZKtpFVTF1fIxeusaqXar3jwkhSdEqPOwzyWYLlmKY+g3Hq0e1rJq95zqzGS+Uck3g
	 p9rVJCPUFGCGy9rBAz1+4eBS1jaSIgpVFYDler6ONg2sodX1XvnhbXIapzaUloIWvgu5w
	 zPSVH+cv4d2lcI8l2KsGupyVczxZSuY7xJwsTHEgq98GR9L0Msf/LrCMzM7wengtP5fOh
	 aKYyoqKCdWxrorK4MhY1ZYKWeU4qyInUd64he1FRfu8lxgqByIcItyZwNWf7fG5O+RQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062526;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2xyWFquSXpiLVzuXKQVu1X6jx87cj0LEgRETqqiQj5E=;
	b=ReUmHYiBNELFLGu5U4MUYybPti9ftrfCeWn/mYVE7Sq7s53njS4VX8dnuDD1ZBebqDTk
	 xk4UuqQCtvJdLGROKNCiBnqLBogdnSuF/oN4/wuWwC/yedFMnfLdkPIo+/IGdUoSzGiSu
	 uNLNPiQCWwPWFFPSOXaqEQda2b2eQCPJ/rz9zt5lh0CitIOSK12l5tCNVnO20zgn0Gysg
	 8+ACJIFrdPFxlLDcagRsWgIpjKCZqThj7rxNwoXug7ZBsvzuHXVHwYlPf+r4OHg8kcB1G
	 gIXXrdenWqXRje6f7ZO+4N85uz1kDU7P2+4iaBFeUtnviQ+4/x7qYcJKaPTcxuN3Irw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uhO1CaGD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03E98606D80F;
	Sat,  7 Nov 2026 14:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uhO1CaGD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 516A81F008A1;
	Sat,  7 Nov 2026 14:42:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062525;
	bh=2xyWFquSXpiLVzuXKQVu1X6jx87cj0LEgRETqqiQj5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uhO1CaGDo5AnJ+f5sNN7pJ+hk0LAE0Z1Ri/ZwhM2pA2Tgk1MyXsdhDSr8dUzjNZp1
	 9j47oi/RiuzEEnaCf1eO2MhZYn713a1D6dxuVD+UVaLyiPCQX+VtFsOV5j6LH918D6
	 GeVKSEZO3m4U0amULrv9ljY3vP8Lj3eQDrwDbcFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1419/1536] tpm: tpm_nsc: stop using the cleanup callback as dev.release
Date: Sat,  7 Nov 2026 08:57:15 -0500
Message-ID: <20261107135037.684695886@linuxfoundation.org>
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

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit df0ef271087623439a1e900f323ed2a57204706d ]

tpm_nsc_remove() is called explicitly from cleanup_nsc() and also
runs as the platform device release callback on the final
platform_device_put(), so the cleanup executes twice on module
exit; the second invocation operates on a chip that has already
been freed by the devm cleanup, and the I/O region is released
twice.

Overwriting the release callback installed by
platform_device_alloc() also keeps platform_device_release() from
running, leaking the platform object allocation.

Leave the default release callback in place; the explicit call in
cleanup_nsc() remains the single cleanup point.

Cc: stable@vger.kernel.org
Fixes: 570302a31149 ("[PATCH] tpm: move nsc driver off pci_dev")
Assisted-by: GLM-5.3
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Link: https://lore.kernel.org/r/a6155310e6772f708b47291cc959e02c05b90eb7.1791015549.git.xiaopei01@kylinos.cn
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_nsc.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/char/tpm/tpm_nsc.c b/drivers/char/tpm/tpm_nsc.c
index b165b274680d6..2f715c195b50e 100644
--- a/drivers/char/tpm/tpm_nsc.c
+++ b/drivers/char/tpm/tpm_nsc.c
@@ -326,7 +326,6 @@ static int __init init_nsc(void)
 
 	pdev->num_resources = 0;
 	pdev->dev.driver = &nsc_drv.driver;
-	pdev->dev.release = tpm_nsc_remove;
 
 	if ((rc = platform_device_add(pdev)) < 0)
 		goto err_put_dev;
-- 
2.53.0



