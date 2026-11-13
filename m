Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585750;
	b=LufaYSn/o4dqxFnf/v3DdQFljxAj3ThgSrhQuQ80cruB+hXQFX/8zC13Q30sTFQ3OUnr
	 s6dkP5pL5clxr3qFyqZYhfo+CZ+89HLaE5bJ2MQXxw5Jq1Dg34WAEOjyNrjLA63/4N1/K
	 Yb5jo4JkOhjT0CoxdQLq0mgHFBxxR3yZsY1htKh0i4VU9Hdqia+E9rVIlUO6St1tiahr0
	 B5+YRJZOjLqi9fjV2aUA7letJ3E69x9FWhf2X9HCw/2NShKtE1YpKZJLCHnuuVakiiBzR
	 OIlHB2WIcPOpyFMJP1XkSqbJkieddQgJ7J6ybMvtJIzKI5ZFf0BSkd1Sjjke3Kg16hA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585750;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CUjhdbOciSSI4CclMnHBWs2y17Ohcs62EnTFh4KVT68=;
	b=o8GnCp1I3csFTiJmwi/SCjf+sQ63klU3efFT9z8hIo/9hJL/fZZbVU85EtExJrKpw7+G
	 x2quO5FfOXuTmPNMNJFmTq0myT/NN/nJreHdQl0a0gU+HaV4Q8fpSPnvR6x8EJuw3eOzu
	 ajlUrUXt3Rp3eifWYH24q7NJKMl6jPqHaqb0zhmQ4RJ8S2Gsnj1njP52xCaRHAsKEDQaf
	 JncfdCW5/A5Q/NlepyuhNb3hWHpBzF61wO2ETv+cS1axUE9WdQNT+BicFgVlPhES4X08A
	 E/ZNniW9mkkDgQCkzOU51BBrfZgyKciNMi70tFR8ylXWaM5BAJlsOG4C2YlgaQPQUFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ugaS6Tr2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 638B8606A336;
	Fri, 13 Nov 2026 16:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ugaS6Tr2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFF6B1F000C4;
	Fri, 13 Nov 2026 16:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585750;
	bh=CUjhdbOciSSI4CclMnHBWs2y17Ohcs62EnTFh4KVT68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ugaS6Tr29eR4nB34+QmPLES9i3fJ4pMSmTkxEaw3SyRlKofdgAj3WybNYPfeLzATd
	 oW8/n1mGlPisAagW7l2ajeaDgSImvyJZy8OodrLfn9eiRGXfgfuWd3evRSyn2lQoNO
	 14YA6sP08eJouiGZ4GrzUvyBjHoHAPRDS1BRl4dA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 346/507] nvme-keyring: Add a missing key_put() call to nvme_tls_key_lookup()
Date: Fri, 13 Nov 2026 10:50:50 -0500
Message-ID: <20261113153807.120762112@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Jarkko Sakkinen <jarkko@kernel.org>

[ Upstream commit 404a8f6caa63822c1d2a45adbf07fd9c0567a7ef ]

Call key_put() before returning -EKEYREVOKED, as the reference count gets
incremented by key_lookup().

Cc: stable@vger.kernel.org # v6.12+
Fixes: 5bc46b49c828 ("nvme-tcp: check for invalidated or revoked key")
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/common/keyring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/nvme/common/keyring.c b/drivers/nvme/common/keyring.c
index 32d16c53133be..87cb51e1f5a7f 100644
--- a/drivers/nvme/common/keyring.c
+++ b/drivers/nvme/common/keyring.c
@@ -35,6 +35,7 @@ struct key *nvme_tls_key_lookup(key_serial_t key_id)
 	}
 	if (nvme_tls_psk_revoked(key)) {
 		pr_err("key id %08x revoked\n", key_id);
+		key_put(key);
 		return ERR_PTR(-EKEYREVOKED);
 	}
 	return key;
-- 
2.53.0



