Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705390;
	b=q8Dl32Tmg0mlBjJ7A5+599B5gui2wL9+YLBEgWtATjUi5ULT3wGJbruej2Sv1869kabo
	 Wd0ET84LyEFE5gK1ZF0Y+VrggXNq+8KbZnCXP60HO9ncpvGPJhnOMYf+gbbzOM9Za7dGV
	 6Ze2jmg5/3uSduboUTg9lRx2EpKuj9W4LO0ERKYqENgybP4mFIHx3P7ty91roYWWAKcT2
	 7WUHx/hWdwTGhksuTutcfS+n/6olAtMTQItUwJLqbvW34gi8rcK7FwyTSovW6LbJFyf6H
	 8oP9kkZj/QXn05mAdwwnm1fB6GT0dBEhfYGr6e24y81dtE/75T1QLAWOtdoQIqhqyDQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705390;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wwILFwZxl3hJDE1hJngziz3Ie9KgI9CxvfiBpC5Zbww=;
	b=sLjlVskrrQzb1Bwh5e2HQ7U67SA7w9/ORyLiV0+CeEXadaoc48Yyyz/ckC4DLlcM2POo
	 1WvodmmEFtrSsSaSx3OodoCVcLGrLz0n07iZ+6+gH5GD/uSsU2Tasaxix2aDXrKMYoLNo
	 /DReMQippm1V4O5z0Ki33VQRVlI6Nd7EKQEBjtfH4DhQkvWQmN7ZCzeU8t4XWEhORIYkW
	 uHNVfwee8cfK+5Ga9GSoyJGaZF2ZaVcuAhTuyAozWQL6YSXr2zaFY/V/cKrfH4qjYlJw1
	 SApRfqGLUZCHsRgJGcAHUEqZQpE8Y6eDhWSUHSpneV2J5B5P0IsvylRbm6/6C8LkWcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OlHDsRE8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0CA606A31C;
	Thu, 26 Nov 2026 15:03:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=OlHDsRE8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1741C1F000C4;
	Thu, 26 Nov 2026 15:03:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705390;
	bh=wwILFwZxl3hJDE1hJngziz3Ie9KgI9CxvfiBpC5Zbww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OlHDsRE8MtVvL2X2fi1YbXS3lKzXOviLVqbnwNjAqslgBOtZmdfht3nBvzpHpTU4S
	 nnmdemhxpbFIBgwFJk9Dci1F4HiTKd2VmDkYrpWvV5ZV98vwjxHWvyU1IhhiRUJztR
	 Jmja6d4qP9NXC820ZRofyy6GnASF4CBDLyw+RSYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 183/319] nvmem: core: Check input parameter for NULL in nvmem_unregister()
Date: Thu, 26 Nov 2026 15:39:11 +0100
Message-ID: <20261126144010.876703057@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 8c751e0d9a5264376935a84429a2d468c8877d99 ]

nvmem_unregister() frees resources and standard pattern is to allow
caller to not care if it's NULL or not. This will reduce burden on
the callers to perform this check.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
Link: https://lore.kernel.org/r/20220220151527.17216-4-srinivas.kandagatla@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvmem/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nvmem/core.c b/drivers/nvmem/core.c
index 4ded50d6176e5..374fae3348125 100644
--- a/drivers/nvmem/core.c
+++ b/drivers/nvmem/core.c
@@ -896,7 +896,8 @@ static void nvmem_device_release(struct kref *kref)
  */
 void nvmem_unregister(struct nvmem_device *nvmem)
 {
-	kref_put(&nvmem->refcnt, nvmem_device_release);
+	if (nvmem)
+		kref_put(&nvmem->refcnt, nvmem_device_release);
 }
 EXPORT_SYMBOL_GPL(nvmem_unregister);
 
-- 
2.53.0



