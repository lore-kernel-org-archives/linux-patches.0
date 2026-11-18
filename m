Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795048947;
	b=JsI/yAP4pZLq4eRR0qALCXMM4PS4psnF+ajboSbT30mU4pGUKBr9/vlkgl37GkB5uz7l
	 vQuokPu3asxtZ0QFplOecfbP3Zh48XjbRmMwrCYNDdYAUbp1YhYs3b3mgKaIETU6+mwQq
	 kJREZ3wUUNFYvS/oFxv7gWe2Ha1vYCtmL4Qg2GwmcgZsipE/4PTjRMQOR3D/GuSVdKgdS
	 9xlvo+Tc16IxF5D04hPv0schTTqlmpD3PD/K6R+GJTm5F4BEL/e2IzVvEM3vd3kPFNvvw
	 Aez29KVfg1JHzcVubPxJ2/f2zI994tgjC/LA2q08DBNjgPdoBHdk6HJ/x3j0dkTxZ8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795048947;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4LY0qgjdRIpjweea5EM9HmCUWqBh2YhUhP0ejcUue4o=;
	b=sjoc4lLcFAwlGHbUnhWtsSUuFXcXpzunxa9xjb9PmKC8Hy+Eneugl5uin3mIPNIbquel
	 K09tdaVBRVYknKOTnjc+hNd+/zQTzCAMyd6kWyQLmNcUPsftwJEDgRwAfcQXQ1Oh5KX7T
	 9orHGxBLf0YpuVFYiFqm9lLw6dzjHvB1EI18antl6/k9SlwQMS3XzzCKUQ6oZm6duHoRz
	 1vLEhXfXh7gLOoiO7dwbvXeLlJ/cBULgXqPfDkUckfyc5xlCibx5hgVGAOdU9iyHJzMvG
	 ngn5VGg3va5KuTNl8CdiEjIoED+pwksFgdS8S42LYiOmx9Epc4Q1ZiTi88M0xKTh07A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=osSCEQfu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03C3A606A31C;
	Thu, 19 Nov 2026 00:42:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=osSCEQfu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 568941F000C5;
	Thu, 19 Nov 2026 00:42:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795048946;
	bh=4LY0qgjdRIpjweea5EM9HmCUWqBh2YhUhP0ejcUue4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=osSCEQfuIcEXUXeJ3Wp/I3EaHYePPdr9iniXs5VOMIj6ZiFhYyDSUdQTVn42AEpRX
	 eClbbceIX5v/6LB3mcunAxr1YWPDB58S2EHn3kPJenYXlExGckQvhtazT2N04xS77P
	 1qelQ607SoBay3+O0AQLuReU6vG8i+bHReDEFp1Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2177/2857] hwrng: intel - return -ENOMEM when kmalloc_obj() fails
Date: Wed, 18 Nov 2026 15:53:31 +0100
Message-ID: <20261118150319.786377740@linuxfoundation.org>
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



