Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045730;
	b=DuPjR65tKrPXT2ssRrHQ0ifHNFvecJLad5HT8lMhMzJxBbXB3kagNqWBUmcXRUhYSnNY
	 /34zIB9Wak24la4PZKH0ZW8to2Vt6K9Rfopx0vh5M9wTzVNEK6EW9t9whaEoiuomOQXRX
	 wFNIQAdbLX/DXpkzgkThvQUOumTmQLQexCmp3JNkeAFTnQ/hpkuFJa9jMTI0jqQ3RPtVe
	 kfvy1s/uKsaqBQ6xut0lCASKnj1Pp1rgzLpMZxozmY8x0kT+eI5xvTdQJ6XqKHqJ0QJPc
	 2UwJo6LpNsNmrJeP7g2q/s6sRxzBYn0n9HnKlEY3C6gIycHWgJBsez+J5D/KRfE2t6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045730;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5g6EnrsJzdiO/nbLTqdYjOrhLRZunvXrz3jFqEjKUb8=;
	b=Rof5ts7DRh/u8raBqWkYYGh5oxmC4LorIbQ7Ewo0i6KpZS3bLq8HD5f0NtMF/EScEz72
	 hNega9xGGFd5omJEu9ulq5acI+jIA+ye8sU5SrP8lpdCB0MyijWaxj/HGXuKa/mV2pXlz
	 NbHYsbZcEl5gjh7VdZk4lmyE7UidnTTTRfEl9r0js+nBgSupFPzX05xjczYaIeUjrolpR
	 pzk3Q360tD5Py/pENM4yVRWRzs8quauqq0sgbBrflnC32Qik5W654pH8FhcBSK6XCm6Rs
	 tk0hu3LfRXT1Ajh072dgIYLc2AAG9g2NfNQ8KvUTLuZDC0PtL/KLMOCKoGpj/jyP0Qg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2IM8HC2s;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EC15606A325;
	Wed, 18 Nov 2026 23:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2IM8HC2s
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0462F1F000C4;
	Wed, 18 Nov 2026 23:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045730;
	bh=5g6EnrsJzdiO/nbLTqdYjOrhLRZunvXrz3jFqEjKUb8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2IM8HC2s3fvA42z2QFGlXUheTafhfH/FZcEz8A9ultrtEmX/A/nCFNoofxRzoWNuP
	 y5DJx4N0Q2/HZ8yRKqlfU4mrP73q10UMqTezq9i1nHN7g7PuCZM5jr+T8qMJVhVAHn
	 Kjxl/j68GrZlyQRaTWHhxgLO9oCdg5RWV6DJzc5c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1026/2857] tpm: tpm_nsc: stop using the cleanup callback as dev.release
Date: Wed, 18 Nov 2026 15:34:20 +0100
Message-ID: <20261118150238.542793172@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



