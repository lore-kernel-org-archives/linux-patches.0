Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030580;
	b=5NIQM/ugAuNye36YpOtds+46JnJkAdZO1WZx+ZI63iuwcgewIT4y2VBlBiljMGfoiwNJ
	 c1leqHvwgG6W5at4UVteGEm36qLQppMS+oSAn1kOpe9Ep/Ue/hM4DZ7UEzHLiWvUJJ9oz
	 Xnn3D/ObRC4fCoDK+Lv9mYPPZaS5Sjtlyw8A1PSbaURgmP+w2JF/vsFk/oxXmLlJSUp4N
	 IruotLZp4judD/5tFqvPsgDl2BREa0txsXyjTgvMEqZnuGlhZM+B6ggGeFZ5UYRTfV5Q0
	 sF55H7MCwOOsO2uztnd++TmZRrO/oDs29GiDxamYdMU6mPxB9qRgzzJ3IUmJET8HxtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030580;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gdx9TWD6ionsPxTdiVgDJNej+Cv/r3QOYi1lm6fL6zA=;
	b=km1oiHR/5OfgKrV+JIGTraWhbgtaW8QkLOnrOTir/vHWcGsPfUpTfgpwx7vdUaJgZl9o
	 +s8SMP9ynHZeAhgl/2uWmI1VnKYtol2Ome5n/T4OPb2qk0PbHZGSDgW0jj03YAglz4SlB
	 FAzgb7RhNcxE8pZy6UTWPA2YgrpOmPEp/BH5YHz4Nqw305cCOlzQ/2UpwJiXyGgnNlT2y
	 mQHkEozOdcUXBnT5uu9hrN4o8KFFqhujvic8E7tXhs4qKM5C7FECyChs5Qy2ptXGBOU2b
	 nyh+MB2l781sSqsvFHIkaFke59nr1Fw4XtJhvDp+wlG9KtZbMl7KwmxeE9Liho8klPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="ZIxHy/0y";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1590B60A3809;
	Wed, 18 Nov 2026 19:36:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZIxHy/0y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6950C1F000C4;
	Wed, 18 Nov 2026 19:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030579;
	bh=Gdx9TWD6ionsPxTdiVgDJNej+Cv/r3QOYi1lm6fL6zA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZIxHy/0ymEd8lgi7hwlle99pnebPg6bw/kzgjuYup82YQreN6rXIDd9qqLP8Nh5FP
	 Pds0y/WKPesEQvBK7ICJJPx3pkSugzZimabhXOk7tMM6ymg1/sV3XEqxiaIyQARDsk
	 9NhsywsPagnntydHTR01EPVeirEHBLOxpCM3aitA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0756/1756] hwrng: intel - return -ENOMEM when kmalloc_obj() fails
Date: Wed, 18 Nov 2026 15:48:03 +0100
Message-ID: <20261118150039.733406376@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit a0590c556cdbf88373d38494a23f1503d39b0ab2 ]

intel_rng_mod_init() incorrectly returns -ENODEV when kmalloc_obj()
fails. Return -ENOMEM instead.

Fixes: ee527cd3a20c ("Use stop_machine_run in the Intel RNG driver")
Signed-off-by: Thorsten Blum <blum@kernel.org>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/intel-rng.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/intel-rng.c b/drivers/char/hw_random/intel-rng.c
index 7b171cb3b825f..94f7116e96682 100644
--- a/drivers/char/hw_random/intel-rng.c
+++ b/drivers/char/hw_random/intel-rng.c
@@ -349,6 +349,7 @@ static int __init intel_rng_mod_init(void)
 	intel_rng_hw = kmalloc(sizeof(*intel_rng_hw), GFP_KERNEL);
 	if (!intel_rng_hw) {
 		pci_dev_put(dev);
+		err = -ENOMEM;
 		goto out;
 	}
 
-- 
2.53.0



