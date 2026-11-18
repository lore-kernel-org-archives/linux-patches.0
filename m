Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025116;
	b=z+PRIlPG6Ybha0lpwNvY1bBKAevGnHaK3/hx0NZ9SolnxBueUU3OHvseQ8yB6jE92Cyc
	 QofijqhlmkX7asJC8nBc5UqTHhBYvujIrA4zLvDs2QElIHFlxjF6iL1Lo1bI5ldrj+BeK
	 O7v59MdX6wMg9OYUxbaTMDVh4QCc773BD5C9XLD4xmmmDRacapzLrXkJkxCULSfsugzuA
	 /PUn3JgLKuuB8ZImC8b9qdv9R7IcLG421zHn6nFcXarHUHko5bk/LSeVP8v5V8yPLad8K
	 09UzoZd85zAZMAI93o2gbfPc4c1SVMpP9ERGj/AfKDfz8Tn7W2KXJhq4Mm99n1WmHxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025116;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gl0hff775uLrACmD/MQVB6BUJBLJ9zcNLeU7qLe8Zhg=;
	b=aZlNCEuBAgA0OlRjkIBjIWH1M6T5+MCwEPt3zUeq0O1tmxpd3DYXD34MhGcYatk24dAZ
	 YwNC8plAjEBmRW1hmn+dI4WaP7ulndPw8gO7O2b/AVA2HIeQh9KPRzMmhp5+kLWWu1oVU
	 ky5Qij4xmD/S95Nug9JDu2IRbAoqRRKdPcsPyPPw9g5qRK7Aep/GARB+C0ANp/q8ovpIo
	 0Zc0WbywjYmEsZtZjiDpG3rH/QJdlY7fzpRiKmdaCZpxbWIO8Y5hSeCeg4Fkhphf8AYSt
	 UrfUBm0+IEU01ojsFaM7H0TVGAEkn29zBbbBMKNfPiFy0UHcxdhrV8RnGuzmhD3nucg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y2P58Gek;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 291CB606A336;
	Wed, 18 Nov 2026 18:05:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y2P58Gek
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2391F000C6;
	Wed, 18 Nov 2026 18:05:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025116;
	bh=Gl0hff775uLrACmD/MQVB6BUJBLJ9zcNLeU7qLe8Zhg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y2P58GekQM/5E4nab6mP9P+s+fYJ7EufyGFw9WlERAZdCB/KuXJSE316yCX6GGLjG
	 FOEJoiJwC2prcb33QBrZPS5SkfYlVoJhQTTXahsaKPoFx+uPuUFyCQ+Hh5DI7clt5V
	 wTDHkr8AN3mlngKfl6z6oqaWr+/hydLwOujbiQOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0964/2151] hwrng: intel - return -ENOMEM when kmalloc_obj() fails
Date: Wed, 18 Nov 2026 15:44:59 +0100
Message-ID: <20261118150157.636008020@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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



