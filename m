Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058656;
	b=Ij+CY5FSP8ir5D3Vrps7P6ZmKrttQPI61E4fuZ7N/KkwodmHx+M3+fdFimRAHplM2bPJ
	 1mQ97FvI6JucTUI4DpOD6ZLkzNmxs5qALWrgcSCsSg+DJRONTxpva9lshSw6mYuvcN4Z2
	 eFX2ACdNwtNCCi2W+mRITb8lNJaOKdQBgMhIRLs/ONyH3+Pu6LXdCAalK5x5WEyj3NBT7
	 zDr0cP/73CDT7qpb3AJKTYZGeoH+D8/rKH/TPkGZul5pXTbDG2V47rNU2ciZdj1NyFQ7j
	 5k0Kf8Rsq7U+wpSvTPbkD4nzXL46UlVbLZJPBiWYC3LD6TctCn5fOC9T8QjG8NI8y+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058656;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ycVWTPXUWrIgKsUjPuTJ1DlyXsFkcVX5OpG5vsd4tdk=;
	b=eLzrNGQNuAdSdmFAUJNoVPu+fQX1q53cV5F5nuptWLXXCTuRqVAV4MaJV3X3RjyrYQ/o
	 CNbwzR50zdwL6AN5pZbRUk7WaLs4Cd9THKjdgsfTel07mRT1xBNFMTdSCnVw0W76/w4Az
	 d8NzqiOqs/aL+6XlnyAzggWDI7jewR//XesRAN3R5BCtcI3DWCvbwzqreikGviPCA/KYG
	 gUlggXprWTXfLyqCtMbtv8AqnBvapn1qTYSreT4NG8FmSf1ozmsBpJhbcDx/CaZn58zgs
	 zgEa11+OhIFbLl4HBhrx5ZzTqpzb4NVamun+M7pJ0mDFmKC6HMfzA9o0sUMc4gN3A3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WvBp+1od;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8C4606A31C;
	Thu, 19 Nov 2026 03:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WvBp+1od
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4B031F000C4;
	Thu, 19 Nov 2026 03:24:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058656;
	bh=ycVWTPXUWrIgKsUjPuTJ1DlyXsFkcVX5OpG5vsd4tdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WvBp+1odQiTT3et1kA4+3RmRUMWvemd/b6Y6UwGPnPfRDUf0qI6qodMDHEUkZ5AMT
	 dZffIzbu8w9AV+6Oh71nxANnfKRF/UEMfYlQ/X6pDIIPvcXGyptcIVhrBVnRXnNilh
	 YrV9enJJe7WJmlTt4JTlWQFuraSuNThSWfhzJDOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0562/1848] tpm: tpm_nsc: stop using the cleanup callback as dev.release
Date: Wed, 18 Nov 2026 15:43:20 +0100
Message-ID: <20261118145938.469879924@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index bec0b1fcad27a..c33d49172df23 100644
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



