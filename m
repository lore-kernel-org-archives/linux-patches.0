Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215655;
	b=gvPA3ESmNbmjD6GUv7e4F1+VNkj0puG4aV2XTHHzgrl/l7JPL68R7yOR9yMpARmJhP4h
	 eaZNUj4SLOe8IpVHGogjsubffwQNHk4t27674U4vuRh45SDuX/jHo8WIUemGm5V/8ZH7z
	 Axm/ql29u07/+phhweSGVOJ9pskZ8rgj7Gzzmp1Ricrs7Ss4YJYL+Q6Q4sUo+C7oV+vgY
	 ZbNgs/VF6So7PBF7quUvrYsSOtJQtHhWnl9d3AIJ7Gev8cVPwB//jmHyCfBB+MNmW+OqZ
	 TgoldsN3G9S/KBLebi2abe5saS/GGaZlC3HiuosGSfojPLmdYdSPpaHQxK/ITe6QIOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215655;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iIci0C1cdVf1ptWdW5ABajeFQjSVMclGDACP9L2lrpc=;
	b=3rVZQftHT2dg4G4LMMN+OVsHyEl44+afEmwp0LfZIEwj6wsqhmvl9dN6dvUe9USgHXka
	 /LAOZ1NsimHWqLIiK89GtL1ows2ZIRRpZkjCxtOGSgufnC7iwzfUkcQ5OKAZeCfpAkfoV
	 Hh6AULTWdNAWqPKVevTKI6a4TBa+6Wyt6JuQnrTNZqXMeGXIwnYr9lqrXMyCYoZMz21wf
	 Aqqeku1zFfv7McctR/d+756N8kh5W0uIMU4IebA3JpiG+T2Vqa0QJmgI9M2nKQAHCWVfo
	 YySSOFHKzguekMG2tC5quw5PrnAX6hHRUS0acNs6cou4pgevhecykp0lojTF9NyB2rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A2WceUBX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB488606A31C;
	Wed, 28 Oct 2026 19:27:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A2WceUBX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 166DD1F01825;
	Wed, 28 Oct 2026 19:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215654;
	bh=iIci0C1cdVf1ptWdW5ABajeFQjSVMclGDACP9L2lrpc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A2WceUBX84h4Z6ERZPkyBFOkD/7y/DccT3H3C/nnEY9GCIemtAry9z/spVuGiqoao
	 EMhF8RuM+JoZW7qe/jYAVdFwV2o9/pH1xhZO+U+wFpZP6nG7J/GA0A2bC7wTL/JO9B
	 urr7qHNEgN0ML2NE3SlnhBZiT1vPKpqgvCFLwMDU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1287/1887] selftests: tls: add getsockopt test
Date: Wed, 28 Oct 2026 17:56:23 +0100
Message-ID: <20261028170528.714473740@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit f27ad62fe38cf7c0a561628734f348217777127b ]

The kernel accepts fetching either just the version and cipher type,
or exactly the per-cipher struct. Also check that getsockopt returns
what we just passed to the kernel.

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/81a007ca13de9a74f4af45635d06682cdb385a54.1692977948.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 1c8629651cb5 ("tls: rx: restore msg_iter before TLS 1.3 optimistic retry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tls.c | 35 +++++++++++++++++++++++++++++++
 1 file changed, 35 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index d89ee6e1926c7..4c97940d965ff 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -29,6 +29,7 @@ static int fips_enabled;
 
 struct tls_crypto_info_keys {
 	union {
+		struct tls_crypto_info crypto_info;
 		struct tls12_crypto_info_aes_gcm_128 aes128;
 		struct tls12_crypto_info_chacha20_poly1305 chacha20;
 		struct tls12_crypto_info_sm4_gcm sm4gcm;
@@ -1460,6 +1461,40 @@ TEST_F(tls, shutdown_reuse)
 	EXPECT_EQ(errno, EISCONN);
 }
 
+TEST_F(tls, getsockopt)
+{
+	struct tls_crypto_info_keys expect, get;
+	socklen_t len;
+
+	/* get only the version/cipher */
+	len = sizeof(struct tls_crypto_info);
+	memrnd(&get, sizeof(get));
+	EXPECT_EQ(getsockopt(self->fd, SOL_TLS, TLS_TX, &get, &len), 0);
+	EXPECT_EQ(len, sizeof(struct tls_crypto_info));
+	EXPECT_EQ(get.crypto_info.version, variant->tls_version);
+	EXPECT_EQ(get.crypto_info.cipher_type, variant->cipher_type);
+
+	/* get the full crypto_info */
+	tls_crypto_info_init(variant->tls_version, variant->cipher_type, &expect);
+	len = expect.len;
+	memrnd(&get, sizeof(get));
+	EXPECT_EQ(getsockopt(self->fd, SOL_TLS, TLS_TX, &get, &len), 0);
+	EXPECT_EQ(len, expect.len);
+	EXPECT_EQ(get.crypto_info.version, variant->tls_version);
+	EXPECT_EQ(get.crypto_info.cipher_type, variant->cipher_type);
+	EXPECT_EQ(memcmp(&get, &expect, expect.len), 0);
+
+	/* short get should fail */
+	len = sizeof(struct tls_crypto_info) - 1;
+	EXPECT_EQ(getsockopt(self->fd, SOL_TLS, TLS_TX, &get, &len), -1);
+	EXPECT_EQ(errno, EINVAL);
+
+	/* partial get of the cipher data should fail */
+	len = expect.len - 1;
+	EXPECT_EQ(getsockopt(self->fd, SOL_TLS, TLS_TX, &get, &len), -1);
+	EXPECT_EQ(errno, EINVAL);
+}
+
 FIXTURE(tls_err)
 {
 	int fd, cfd;
-- 
2.53.0



