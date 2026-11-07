Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065323;
	b=qQdNlTs8GqKLjKDq1+Y2DEVm+wU6LM3TKMZGarTcaHTMvY4XydCJfNMDONegyRYr9BJE
	 eOqeS/R+Bw2cE8OosGt9dnUSXQfy6/xIpg8ETbKdi4lLALFYGEFqDTqBUp+/u4/2Gv+GR
	 gw9bhJhIpExdVBzN7plYUAeRot/amqa0EmHg0rXdUyO3HX55z0LWCID/VcIzm+EgDTPg5
	 p5Laoyq5iM2ie+4Yb3LrSdJF5OZTC6Lz/n3wBRDxlJ8RFthJKOT6NudWjWGRN0Zz/50r8
	 kM5JPA9zOPqIHDryZgenZZskmYM6YDLwWomU9SVQM7huLI1qI0vF0rCSVO50KMBGY5Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065323;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4pgaKOB6q1xj/iov7Z3Nn/Q4GT3ne/PAWQrgQyMakjs=;
	b=uYjPW+hibfJ18J7DYqK90yrPcCH/aSVMaQknz5VbWGMFTppWPStY/nw+WIkmYZLxxmy5
	 yDW9RcUebCmTYnVH5f/R70m5nDhOAcLd4EVHR/Tv/aN5aB5HbBk5qnj/JVL80s0VEMo8L
	 sFJBDi1oam8DRaOSV+UPDFTgUbpDQfg7a0iW8nBDFtDRN4SIlL+KvrTm+eBClUm/PgmaJ
	 u19UUwVmtUF5T01oTPTeyAUIRTmrpufN1j/Qopl1I8N8rBT8Rwf97bdekng7UmViy26Z0
	 tbdEjWOxK4GIY+Ip/kanPWxyiIiCaip57D0g8NuHZHaQ15mnbjKVd+9o6u4U4Q0qcJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QtstBpGp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE2F606A32C;
	Sat,  7 Nov 2026 15:28:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QtstBpGp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86A921F0089F;
	Sat,  7 Nov 2026 15:28:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065322;
	bh=4pgaKOB6q1xj/iov7Z3Nn/Q4GT3ne/PAWQrgQyMakjs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QtstBpGp7DxoVpJGwJjBFor5Vg0gy+9T7piDyN9Om1qrtkO2ZqMVGJlT36bp1LCtq
	 gUxCwynvK4ZU0COIjK3lP3iloO5ej03xmd4+0n6frWxlgwUxiTqx1QOhl/O2iq74CB
	 V9lFQ95MZ1Up5mXYfpQU0MFoWqQy+DJbatP4f9rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1031/1257] tpm: tpm_nsc: stop using the cleanup callback as dev.release
Date: Sat,  7 Nov 2026 08:55:27 -0500
Message-ID: <20261107135007.796694820@linuxfoundation.org>
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
index 46a52dc99b148..bcfa2a1a208a9 100644
--- a/drivers/char/tpm/tpm_nsc.c
+++ b/drivers/char/tpm/tpm_nsc.c
@@ -327,7 +327,6 @@ static int __init init_nsc(void)
 
 	pdev->num_resources = 0;
 	pdev->dev.driver = &nsc_drv.driver;
-	pdev->dev.release = tpm_nsc_remove;
 
 	if ((rc = platform_device_add(pdev)) < 0)
 		goto err_put_dev;
-- 
2.53.0



