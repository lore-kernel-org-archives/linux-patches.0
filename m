Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590437;
	b=HIymArOwDeS1pdIXf8/0yfHRGMr0SFGXd9R/qSlj6DCsc7lq4HiUgobxY/JFWKMZ1vOY
	 NOB+s+q2RuwUnv0GnKtr3YxZHAm6jPRriqEixzwcqRBwfT9ctUe3SuVxHPs6Tiyrs7lN2
	 z49XZ8Bg2LHcw3/Dw4kLKl7pN2iG58dZzQPM53v4rIWmVPu/n+Z96gcYKE8470r+Dgs4t
	 Rk532BcsqsNgxLsJdWFZ5kCsjM0mihvvSTTAbSmkvwi3tEu47NCGlt+hac7rgkfJEQXhX
	 YL25dcE9DHck1USkTZRzEM/89LmX0OgLPd2cWEOUZJRcEUR+lyyYcDTHvlx5A1MtVuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590437;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=asXW5Ykk1jadtyo4ghgFLO36hUTvS8q3MzDO/tWeHII=;
	b=qxG26dc5CrFq1U9mBvBCa3aRxNEqpetbbCQy57YB7FYrFxu6+Rw62sSEebUoBCk+Ds4I
	 qrfyeQbKICV85TmVfqEuJ+Oe9r5XKKi6nX3upx8SoBixP/4xhZkTinbTtZPWwC+balqsw
	 yLoxLCn7lk3KpxfS+yYUH928K+LjTsMAXGtyEokmsJsqwPIXSgzOxHtIrLxPjcu7fJWAQ
	 vTy8qlM1x66akkQhmERE5VPsAC/b3hVAnRrGMZV3f5FJjS2CyMFuoc7cBbOG9JywUbzIV
	 q94dnYfwKJ4f0CVEWY/UnUfkCWAdnEbPuiQysFEOxI2A87YiWL2U3/q0MHhKiJrY/gA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zwK6ulX0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE00160703DB;
	Fri, 13 Nov 2026 17:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zwK6ulX0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896681F000C4;
	Fri, 13 Nov 2026 17:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590437;
	bh=asXW5Ykk1jadtyo4ghgFLO36hUTvS8q3MzDO/tWeHII=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zwK6ulX0N8vIC/JE4HYbwx4LXdyNHHp3mu5k4rRg3pZ9iH3EFbiuSFzzPQipjWVLb
	 kXneDFWpXkPE8k3L/HiPqY8NWRL7MFMmhi6TQWiqaVJJURJnizQwXyVm5QsrWR117m
	 vG36S/CJF5lL2IwoFIAZkQaTPWxOO2SPDjBHkxu4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 397/686] nvme-keyring: Add a missing key_put() call to nvme_tls_key_lookup()
Date: Fri, 13 Nov 2026 10:48:50 -0500
Message-ID: <20261113153834.450384932@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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



