Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063593;
	b=DiYHbjFzuVj+4bTZvR/5av8rO4wwPiFLjfTC26XPXWFCHo3RQKaGhFPRBOTGfIwl3/Al
	 yQrMfWiIU0blDV0zcTpLZfZMjw9Cn/aR6w1shdmLW9p794oB6vlFVDGGMlHdLZC0SMKMy
	 /+Cqsap48LeP2o2odLoBDxITouduy9OY2ZWNHESzaCFiNLugv4z6dwwjThkExj45m2Wh8
	 o5B1x+CJPp7iT+VFIIKXU4wFAt0MaXrQ2KGn6HoEoRlFO4oMb5pZtRvBrPSOT8kVNZVK6
	 njXrzJSj3Bb5pEjirJkORWPSWpFnKX6I4IFQ1l15gF5OqRf1XH8CUDaWbItcP5el1KA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5940KJ0DlpGhwXUPk8Ur4fSYhKS8EPhSvUjNlMaB4Uc=;
	b=VaJ7J+KNOohzPRiIbPLKdGlqu0TJjcgi5+W6TjzzvZFd2sDkzEbRMhn7HUp4ylT0Vy6z
	 3b+RWeySx7kCIg+C1e10ziz9T5ymGk1EhZdeuwlZZifNzMhpDaNlJwDoAXOfjNbA2w87l
	 +z3IxkZe00GHNyxIfmbkf9BPv1OZB7uKrEWk/2/cVqega42wGpx1GBxfqdD23d/VyIgMX
	 Dwbs9Ep4LUIb89eny+dLvCD8ZyM1maPO5Z3891zPW223yhIgUcCizOi4EJTF5RSXP4E9u
	 aEVFCZqJ/ZCGU0SHyQzU0UC/rgl32JAikCHLqUCYMhDDUwMhyDX6nV3YD1mNLNVW8Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s3L97MDh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C267A606D826;
	Sat,  7 Nov 2026 14:59:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=s3L97MDh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711451F008AB;
	Sat,  7 Nov 2026 14:59:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063592;
	bh=5940KJ0DlpGhwXUPk8Ur4fSYhKS8EPhSvUjNlMaB4Uc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=s3L97MDhQ7i06kxy1KQ1KPMR0EniQBv96IBfLmf7+p9Mc9Ux/LX1+ZQ8pdAt6GKy7
	 Ofh21eDsVC6qqAcJji5oZ7wJP0aBN3U4dmJUUORlHypypmdQSsKM6Y4O6Bz3yFfn0g
	 jZu7JEtnXIYMV1wXxLfTOJdedxiYf+26SBbDXsH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 718/869] tpm: tpm_nsc: stop using the cleanup callback as dev.release
Date: Sat,  7 Nov 2026 08:56:40 -0500
Message-ID: <20261107134917.186824642@linuxfoundation.org>
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



