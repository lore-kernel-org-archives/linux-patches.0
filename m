Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055659;
	b=dPJrOo9RiqZKP2ICnlCKgZ2u6qlyB8TiReMfXDW4YFGB57D9k/30ntMgn74g7a0q1FDg
	 FnWANwZMPCLriND+f8SiIHQCSwoF7hrHJ7X+K1ps2Y/pYkc8a8xue624sp/FHSKsUb2zE
	 KHPsRMq8LSqOHLJvbgr0/qFF1Y6RO84HR1X4E5+KrI1wmLem4DxAYbFMnPEiGaz/Vd3NC
	 oXwmlk/Tu/IMaJ7xbQ5509oHQREE5OccUQ7++9jvkPRwqXtaotfiMamkU0pFICsBS090G
	 /I7SYI2ebGQdsla2gZfxgsekj61bVHjFsQQPslTscvOTEz2bPoDQlV/IWj+AsHFG97Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055659;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UKjGObCBI5Of1DDVFt7IwxkmDKFeUnntbXgYutC32rY=;
	b=C+yMBBCGkCYgG8+P5ZeFldpnGv/74FCRHEQCMDEnFGHngevq3hazKoYcBfkm4PcMjXND
	 xjDfAeNG3AJWJsuNCds7G5Ayi3HkEa0rKsu2SrIOcJCuuKjnsVXjJg49XTYAgG34O1eW0
	 qyZGgohY8k9VRIZyTGYnrfeer0lVmBKLPBHHTuNj9mb2J27VvKlpDGb0QhsAUTIw/Vroq
	 l6Bi1C6ou8GRNjoqx00uKCSyCbvn60owbEH2ljO2bxe9qIEmepoVUSrRCLEo8AJHHHS5u
	 eFjjEPGbTc0zbP6tmsab8NdLCzIOet70NzFatiu85NBpzYPJ6R1iOx5iEcwy+UOH3pg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vClYpDzr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E65B9606A31C;
	Thu, 19 Nov 2026 02:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=vClYpDzr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4920C1F000C4;
	Thu, 19 Nov 2026 02:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055658;
	bh=UKjGObCBI5Of1DDVFt7IwxkmDKFeUnntbXgYutC32rY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vClYpDzrOp2frf3p6xt+QRwwYj1ciKAcEyOxZKyPHDUuA01Sw8OwAtFqpnfhIrdRs
	 Q6AV60Tfv3wV3fSk9yKmztnMKp9/GZAzEBsFmYf1nS+Ari3T02j2mqiDveoPDfTvjm
	 7AoyybdwFgrIIG2jDWW+fJ21AWnd+odWOiHhDGQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1709/2214] hwrng: intel - return -ENOMEM when kmalloc_obj() fails
Date: Wed, 18 Nov 2026 15:56:25 +0100
Message-ID: <20261118150120.140811635@linuxfoundation.org>
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



