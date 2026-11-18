Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795040593;
	b=Qw/ghbzEz/oAYWZg/Ctj1PeSSPDvMv4K2yRNceOWjby1T2C6dB8HFfAST4X8aeY1FV2Z
	 rNNwEzHruG1Fly6PxybC92SXnag1Xu3R0srd/wfU3cm8+DBzs0lF+lm2jADAzWM4H9H+L
	 cpiApKixqjFw5yiMkp8ow9VtVoU8v+QPEg5LSWTIq/P/zlpIqplhGQcevpPa2La3yCqQC
	 6vwu+ByJ6FPSOalyDaPW0KLnAyHBjHTP1dVj7q2BlEp1qgvIUpvISMqVqBRGb6W1l0+f5
	 KoipyFdnE3Zq37KQ212YmWBwmlJifshEIMl8sSnmgJIERxMqBlNjC60NRUWWYDhXXzA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795040593;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2RiP9+cPMsI0GkFFmzM2B2fnkRDcwBs06rDwxXApH+c=;
	b=gqpWGOttrAW2j9ijnzORrj6Wk9PuYrSqxmTF9nF6ITK2FaLt3B4MMmqa3QK5dR9g/UdP
	 pd6AbmjCy8NIOaekKjF9apsKVFCQ35VlU41AKcOnNaHEkmYkMEzQvZqsBpV47qXV1GIyZ
	 zrJnaha1stxVtCdgs3Ds8x13XoT2S8drXKnLxVB2HhFxBocbRfmi1qPkL35O7q3JAGrQ8
	 1vvRpZoLt2NyBVuNIa62ljtFO69DSKDLV/0ok0FrfWjsqh4moPmPtm2zEXk9Affjsm+f4
	 yOrBuvcF2ODNnwRJY/gmFaGsmRqP5uWazoAu+pv1FBaBAB4yrIETJq1o4Y/n797deFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PiRNlXg1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D2D606A31C;
	Wed, 18 Nov 2026 22:23:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=PiRNlXg1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62C201F000C4;
	Wed, 18 Nov 2026 22:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795040592;
	bh=2RiP9+cPMsI0GkFFmzM2B2fnkRDcwBs06rDwxXApH+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PiRNlXg16Qp2SLQwjTzIdMc/pF9CDg9EoTgd59zBc9OYxs2d3S4mnp1B7GSRt3dBF
	 wM51clSwT2Ki1c9iS9hUE4PXq3L8KTd5Hztwj/ZFEu4E0j+GgeLh0Rk2bHe0XV00C4
	 MK5ZhVqlopQU3KUyIkT4xpk1Lj33l0zXsY+NDm/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2513/3318] hwrng: intel - return -ENOMEM when kmalloc_obj() fails
Date: Wed, 18 Nov 2026 15:52:15 +0100
Message-ID: <20261118150436.773581421@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



