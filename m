Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591258;
	b=0oZs81i/ovLNq8QESnP4TgGdCUQy7hzQmbYHDlAWDhh4np/8lGLI38dHrFOSO4Ea7cEL
	 u2WgMks3mx2qdhxPWQXjChDrknkux1LskyX3hJj+PTYUEvR+M9BCZMqPQuc793AUaGSBf
	 WRfvWf+TfKGtoaXxj8Tj1pcm3tacvBDWKydqQWOggb/YCTiwK65GsRI/qCLFHh5TsarFN
	 ENd/BAIJgMady10qDqdLel+BgU6eHx22aOZJDbR/HhXLLsW1me0RJ/xo9iEMWamNNuLyF
	 MZD+Q8sDfriDomahcoOeYaqJ7+tqdJwjSM6xikmOIhxI8uPn4K4HcItPB3ddt6eAbjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591258;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tbEnoXWEHq7giVc/uNFJUZkMubPoMQkqwEye/I2lZx4=;
	b=l6TJc4RVm/RYWDTHWDSYpNulqa4FF6Wi7HH6m/sz29kVaC0Ja5N+fIx6nK87j+hITIFz
	 9cijiip7YF3vgT5TtiM0O9mHbCMOYu/x/aE/7h+e7wOsftA0Y/dBfrHW87ChqVSKDLeWB
	 ytNaLLjMhgH3gd6tjErVvXpidWqA5/xDzgiBUY0gkfyXDW/ERMjU/yWWrHodAJpFFmX1T
	 /RcQNnJCx3k9ThtpGnRntFifwz6Pr/ah7y6IFB8CS0Ut0kElHTQjRXUcaBxNJyrbGsfGP
	 ag6SYQ2F1eq41fIn7wKY9SJm//gG5CLB6qJhXVmbkrWjYKjYFxH7e9/JRq1Ryi/YpbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H4MMlvEM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 240606076F84;
	Fri, 13 Nov 2026 17:34:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=H4MMlvEM
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C39CC1F000C4;
	Fri, 13 Nov 2026 17:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591258;
	bh=tbEnoXWEHq7giVc/uNFJUZkMubPoMQkqwEye/I2lZx4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H4MMlvEMweL7CCe4MTx32rHJc4lJ3hZF+6bKIFlI6MvLVkAqzrfjWXbtZ3967F+Zp
	 h/zfs2Pdwg5W7msMlzB7Pej9FXK6hWa40yA5e2v/mBxT9Z0llAE94+Oen8v37zwa0g
	 RnGR5PQk0J56ky8t9LufyCvpEpZXqq0LRJ9C0K84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 340/670] nvme-keyring: Add a missing key_put() call to nvme_tls_key_lookup()
Date: Fri, 13 Nov 2026 10:48:24 -0500
Message-ID: <20261113153823.374301997@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index ed5167f942d89..9f8c72c7bba71 100644
--- a/drivers/nvme/common/keyring.c
+++ b/drivers/nvme/common/keyring.c
@@ -36,6 +36,7 @@ struct key *nvme_tls_key_lookup(key_serial_t key_id)
 	}
 	if (nvme_tls_psk_revoked(key)) {
 		pr_err("key id %08x revoked\n", key_id);
+		key_put(key);
 		return ERR_PTR(-EKEYREVOKED);
 	}
 	return key;
-- 
2.53.0



