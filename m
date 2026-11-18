Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795052803;
	b=V+EcW086XwTY6XDb4LfZd+ZPiMBrjHuqTBvfYw07wYI3niqfXt8wLIcqUz+7u4v+5j3f
	 giUCRWvI4C9KMhT4OiRiNQ8qpHaRAexEgFK+nTkBLFq16GEwrIcq3OxuHbUAS0g6RExAq
	 vEryzVmeamw0na6uy/5CxbEssXPkMar7WbfkhN4jFr5tIw/ogMgZW8ZMNGrP0k8mFB2yd
	 sBO8KreL0VQc8BiLf8hMKzhNIzPbML08vj2gWIF7frB20cK72C2CN8FdxNM3gfCaEMLUL
	 w1lbZEDtjbYESK7lORSjivKLvJCbbVmjYkJ4Y75Ix55hBEZs1cItZJuC3eKvzxq6AXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795052803;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O2k8H//X7qS2B1OnNMdLBXUxhSoxeAXAlOPWG/6Q+to=;
	b=Dfv39x0UN6I3OxxpkndYRj5KVqZyQ1Ux/bH+58r24QN5FgxB08AFoRhlO3JbluJGJxsZ
	 Y5Uqk5JQf4HBSpekIfGBCuaEBhZlXeYRKYwERU/QroME/K8cjLSZL9wL//1lzcnJ/FPCe
	 uOwV8SMWJDsWSZscHTo/aOufBuUzN695ChmjQA6U+v4LjGzl2/GOY4Q2CXrCpzUu+Ghrz
	 GROIX2NVw9ATYrh96zGgAF1yPfg2VD9y41MxZ6PjtkafN3jQVEyhaLLZvjVU+B4MzJGUQ
	 XFexZ/Nhaiipfskm7U9g0Cmh5aSk3GSILtteMYRo5LsJjTFcvDl6YiBu+z9nflj8EQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="vayiCgR/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3988D606A31C;
	Thu, 19 Nov 2026 01:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vayiCgR/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8D21F000C4;
	Thu, 19 Nov 2026 01:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795052803;
	bh=O2k8H//X7qS2B1OnNMdLBXUxhSoxeAXAlOPWG/6Q+to=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vayiCgR/BsMuj9KToZmttx4SBuMCR8SyFOXKKEg7QjNQmEjq6Jd65N6AaT9D8VAfu
	 xWrnHPDIFH7YQX77V0w9rMputfniWAZf3k/MuEYxvrWzdWipVlDQgUFC/PLqrwZOsk
	 YMjleaEvtLfgek9uvVS6/ZYk43KvjaXezINDszCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0695/2214] tpm: tpm_nsc: stop using the cleanup callback as dev.release
Date: Wed, 18 Nov 2026 15:39:31 +0100
Message-ID: <20261118150039.615562190@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



