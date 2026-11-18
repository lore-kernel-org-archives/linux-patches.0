Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795021353;
	b=18mGde/goZ6esAvrn65ycHHDh2wh+FPIeUtqDz3ypquw/sn35aIoGV/F6aQsxKzBSQyA
	 nuzKv8EhJ83olGv1U8sLL5ksiAH3HJBWklZH3huE0a6dALXjasdfEjGAdR9a37dpV476Q
	 Mq4WPbJSu409ExNSL5/K32l6U2dQ3k3u53ZJc3PsX0cvBui5Rg6ca/fJoZ3m/TTncNGXc
	 O9O5G57/oZtYirg+7QwkGrrGlQ3AwMMSJHGYQuyOUzR+XVVCZIwxccBVEtJQzQgGuHCbz
	 RNp37AngAQxaKt/Y1GEEMMVIQbreUaM4dY4xiTh3D1gHTcMKY4ZZnECF1JJjXaeDLoQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795021353;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NvSGTezijMWa27tMY3baDsyGnkiPf2w7qkamjdwamWo=;
	b=hFCVaONOzxD1z5tZkkQwOZEhtBC0hscBY9mdJcPELbVaAzlX8kiwvUeBA2An2t+j8J5g
	 RAXp/AnEvF9NS9CNMQTD7ijHM1rKGv8gLF8jIcCTTuUq+26wbKegmFz8iv9XIymNPxL3o
	 nBlD4iygOBjmVZtSZ35BsT81hb0IgYqWcX7AYDiZWEbsjfQAfYjtMLUB+rEXrpbzv6kSD
	 wZJPd7paVrL76wb0JCmLgQIwPz1OgVdDK9JpQwg1+8Km5cgZBj4qkvk8ywSmK43ACqcGy
	 X+vXKxs4eNDIXIg3MXMA6YHnmJryedSiO5HIFagKmRIzo/bQKs/cbTCyoGnqEyi3mhQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kkEQ7b1S;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63C16606A32A;
	Wed, 18 Nov 2026 17:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kkEQ7b1S
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804661F000C4;
	Wed, 18 Nov 2026 17:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795021353;
	bh=NvSGTezijMWa27tMY3baDsyGnkiPf2w7qkamjdwamWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kkEQ7b1Sr0vzrmSXmN16cysKchcccvYRIhNDelPIKhpixP/4xuWyIre2IvJU/rZAr
	 OajftTHpDYM540W1OmAkZQxE//Kz0XCvMW6yFluCtT6AJR9H8E+jIo1f7vJI8kj0/U
	 GqCRjvU/oA5dyrM7EOQfHIdnQbNaMUxK8BckyId4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Jiri Pirko <jiri@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Daniel Machon <daniel.machon@microchip.com>,
	Ivan Vecera <ivecera@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2236/2651] net/mlx5: DPLL, fix fractional frequency offset scaling
Date: Wed, 18 Nov 2026 15:57:56 +0100
Message-ID: <20261118150406.001854167@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit 0edb8222b852f430e5b5e0475cc2650d409214a0 ]

The frequency_diff is reported by firmware in parts-per-trillion, which
is exactly what the DPLL core now expects from the ffo_get callback.

Commit bc443c253fcd ("dpll: expose fractional frequency offset in ppt")
switched the callback contract to ppt but assumed frequency_diff was in
ppm and scaled it by 1000000 to "convert" it. Since the value was
already ppt, this makes both exported attributes wrong.

Report frequency_diff as is and let the core divide it down for the
legacy ppm attribute.

Fixes: f035dca34ede ("net/mlx5: DPLL, Implement fractional frequency offset get pin op")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Reviewed-by: Ivan Vecera <ivecera@redhat.com>
Link: https://patch.msgid.link/20261015074035.1092340-1-tariqt@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/dpll.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/dpll.c b/drivers/net/ethernet/mellanox/mlx5/core/dpll.c
index 7c69d9029bfa4..54ba7c330d667 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/dpll.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/dpll.c
@@ -138,7 +138,7 @@ mlx5_dpll_pin_ffo_get(struct mlx5_dpll_synce_status *synce_status,
 {
 	if (!synce_status->oper_freq_measure)
 		return -ENODATA;
-	*ffo = 1000000LL * synce_status->frequency_diff;
+	*ffo = synce_status->frequency_diff;
 	return 0;
 }
 
-- 
2.53.0



