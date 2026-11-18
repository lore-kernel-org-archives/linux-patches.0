Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045267;
	b=VX8ipN9VSt2AfpGORiK4Uyjpq8CPQhDW4oKvOwjoE/0gkxu9AnTt91jcebcaOTKFpBLb
	 5GMGe7CRlkTFO5HWXJF+1SbjyvDj2xuNkvxiRcYydM0UAKcaKS3X+ir+s8OYWk2Ui8yOU
	 hDdIZpRpneuDcoezV5aVDKSr2/151+p/OVioufrPOUcTjSVXC90MqYT3uKiEF8H8RKqGq
	 O346iI0UlM2tbzI966XOK+M6tqMuO4a55QvbcEs4kH/wibt+3eXr//wY5XAy1EI83CKgb
	 k+BuNXSdPKKV0K5shAV2y7iJz8u2LjszeSbKCPl3p5iWhAK39ckDV/IadlSD+VfJvSw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045267;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gTYq7rS3FYAVb4ipKtNcYBywvO94CqSx59k6hkAoA4g=;
	b=kJ2TEgEKBfBN64DhnP/RVXpZhUG6/S6+Wp1gDB1J1GSxMW0bNEiZ/TpmSRzEoZRpI8j4
	 dZNZmkgqXmo8DeQu2hfoD/ZcUl8rTgU3y+H/rvY7KdzPdyhPMA8xaBUYXAhzuqAL1Hssz
	 abji18uZ5PPVZYVdSaeJXyC1WAx2EVFxkjgeRsDwoShIy5qWJFdtU5mSesF0jmFBUsKaV
	 GbSaRFDPcFMqFOQJfCTEu61IXbetA2JbZ8PBf2PYpaBhUSlbrD6yaWwxfWQKjzGWCshPL
	 szhOZT50Z6TkpUwohc1Nqdivh8Mmy2vho8PRYqVLNj9qv5AwaWxZ797zsmnToTJp2JQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GbHT9Tui;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10AC9606A320;
	Wed, 18 Nov 2026 23:41:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=GbHT9Tui
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CF81F000C4;
	Wed, 18 Nov 2026 23:41:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045266;
	bh=gTYq7rS3FYAVb4ipKtNcYBywvO94CqSx59k6hkAoA4g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GbHT9TuiMRh46StYeTjkqgUUMLDna2h76ypDBE4xX43cMXfCIYVT1ECzVgoWTi+2V
	 uhnzDOMrn+Ur45a9vcKemJurpHoPvte8T8TMU4JK3ygHK7EZayCoh7iSNKgfMbHqXe
	 4HAA8Q+bnlRK9g7gAGB5f6qnZ7VOiI4A52Po2gwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0862/2857] hwrng: core - reject unknown RNG names
Date: Wed, 18 Nov 2026 15:31:36 +0100
Message-ID: <20261118150232.602796657@linuxfoundation.org>
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

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit 7e7be8815143751c20260f80cb4e7fe14dd24b74 ]

In rng_current_store(), err is 0 after successfully locking rng_mutex,
and if the requested RNG name cannot be found, the function reports
success even though the current RNG was not changed.

Set err = -ENODEV before searching the RNG list to reject unknown names.

Fixes: 142a27f0a731 ("hwrng: core - Reset user selected rng by writing "" to rng_current")
Cc: stable@vger.kernel.org
Signed-off-by: Thorsten Blum <blum@kernel.org>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/hw_random/core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/char/hw_random/core.c b/drivers/char/hw_random/core.c
index 4b1a0fed48ab6..24a12fc636029 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -388,6 +388,7 @@ static ssize_t rng_current_store(struct device *dev,
 	if (sysfs_streq(buf, "")) {
 		err = enable_best_rng();
 	} else {
+		err = -ENODEV;
 		list_for_each_entry(rng, &rng_list, list) {
 			if (sysfs_streq(rng->name, buf)) {
 				err = set_current_rng(rng);
-- 
2.53.0



