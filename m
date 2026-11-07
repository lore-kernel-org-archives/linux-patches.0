Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064348;
	b=wPrkgJxP9s1B0Sz1cycf06eOnRPWy9AWCzytiHdVHLOlWkOweXbgg7tQ1OAjrV2JOO5R
	 jZQLehRaUX9611w2ktfhnrWsIifl2jcLbmtJEOslMXh2fRZ4SsXjroM8mdUdTYRwvrGpc
	 RgM6CEEZEVn8Ytbw2zNxtv5IGPJ1nKiHQ6Phyx5VwC2R8ySTAeeF0FMblks6zz+VLDYWZ
	 pTBvKBgrLlKkB/Bem/AOor74DzQQkTiT2889+Ovl7n9sbzlymi+yqfZBOjt4wg5SZVlQM
	 FZFzE6zjmhTCX9S/bqZxrMTTLcDv4396pi2kmlRIXDgaHxdkpEqMhSdB2ojTdXaectQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064348;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+5HcCw0Y5s2MiJDn0R1SbDKIcS12Rw78nDP4/ly4Qc0=;
	b=n4IzI6e8J6ZT9NpbW0Fp/nhiafm31gQuYbMfV/HsYvKmF1GZAfscf1y5Txi6vW0F46zF
	 aSeJOq83sibzQlIAXDjbSOsHlw0iGiyalHhqOjeY6a9nWK3uV6+admq8AJjD/1fAaUIYA
	 rvBiVH/1iLaKFwetdhJp9gGVWpqIhyisSjEDTp/cKU4KnGhlqMzxmSZT50KHUiQ0m79iM
	 fEq99xG+t39xX2AKHPAlWSbkg65LV4oFKJl70X/AmFucKh+AK6jw+oDVmn+II55n5TLOs
	 Ny8GBummkYCKAqGkpHiei/1B1PwsxLLFEfGGkidNogY6yn9jA3ri/BgnNuqxeX2hNww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kq2giJH7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D3B606CE75;
	Sat,  7 Nov 2026 15:12:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kq2giJH7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3171F1F0089F;
	Sat,  7 Nov 2026 15:12:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064348;
	bh=+5HcCw0Y5s2MiJDn0R1SbDKIcS12Rw78nDP4/ly4Qc0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kq2giJH7jzh/HcXh5KwvKz4jyXr6+w/8C8POa5VAGPfZPWbLppLHXfOfoz/jTvrXi
	 k+cvV03qx4if38sCBzYN8BJMrRfiePjviZCBQP1+q5/VMHCus1wZzYy2OWUmgHa9hf
	 Cqj4qS/hPIKGDMzm4yLOoD0du3IkW+sg9AkPeYo4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0433/1257] hwrng: core - reject unknown RNG names
Date: Sat,  7 Nov 2026 08:45:29 -0500
Message-ID: <20261107134951.443648135@linuxfoundation.org>
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
index 57eeefe90da92..1f9e31cdc7f00 100644
--- a/drivers/char/hw_random/core.c
+++ b/drivers/char/hw_random/core.c
@@ -376,6 +376,7 @@ static ssize_t rng_current_store(struct device *dev,
 		cur_rng_set_by_user = 1;
 		drop_current_rng();
 	} else {
+		err = -ENODEV;
 		list_for_each_entry(rng, &rng_list, list) {
 			if (sysfs_streq(rng->name, buf)) {
 				err = set_current_rng(rng);
-- 
2.53.0



