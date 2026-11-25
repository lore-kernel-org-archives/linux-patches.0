Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622246;
	b=4Sv5AZOGwERjBCSo06XWprbSmNmBRmphgEMQEsvi8dmPKjmsIS13nA8i3Pijrwbs+HKH
	 m0Xxyk5++yNkjmcEuOcM3NyWfQGk9rgaEgbuJVozolgU9shJnwRhnZpoCcSFwdQ44MMqO
	 s2C1ekZwk23sVVq3GgM762XyueW053ywN/EXorn7LRnRLEb7FMKJ8v0V0ARaRosswB+Uw
	 wrdXoI/dc7yZTDXgafs6ZPFlteiEfaUZwtMq/WP7JwjogxK/ZQEvLuxPemJiRxJg9kHLt
	 ADijbIZN5YKY/vWHbh48BlfEJjZcgtIhhlaAsU04grNBJ8fOeikOcxeldAb4J1pZYUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=x0MqZka/QZeHMVxbUKFP3V1zQvgfCo7r3A6pk9m8EWE=;
	b=qqM3yNDNpZHJZmO62MUnyJUGuVfm3c/5RRKgWlzBmEEOXQ5JsBAApAtBYtW+9FrCg5kl
	 bwelo2Hzc8gHSiISq81NcJVuzsSd/GNp8avnhs8oLVZuObk77YiK54SbhKvIUObL9uctx
	 LUFkWn42RJdbaH0XAmGo80ccBv4S5Jk3eDb7fMUWQ8LXmqUxzUNdL8VWV7UZfkdmfUiJc
	 DAFjBhMyVk56TGCg9AS51dCnNzHEKwhtuLt0Baob103fZAaegpH/irBIeXJcAEepQMVv3
	 2T54BH6gSEWNOLw618S3nX/a1e2X1wuaxJtgvSExPwbDyYIeXfhW74Gu/ZDnIugfSOw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UvZspfF3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80977606A321;
	Wed, 25 Nov 2026 15:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UvZspfF3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D04861F000CA;
	Wed, 25 Nov 2026 15:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622246;
	bh=x0MqZka/QZeHMVxbUKFP3V1zQvgfCo7r3A6pk9m8EWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UvZspfF3UOuAbiM1RrwoSziVQqOU+4PiB2/LFbAtKgygi3LpjYThrYmvSV9RzrKoR
	 UOetrCNFRd67vpk1vLmpiY5be4YyvUCdUlkaDKKPE5C8V61rwYrnpQrLrwQqXC7Gkm
	 WUqkeW+z/Yet1Wdiq+TyeYB3UG2Q9EKZ/RtkgYv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 476/990] selftests: tls: Skip the zero_len tests when TLS is unavailable
Date: Wed, 25 Nov 2026 15:30:43 +0100
Message-ID: <20261125143833.245556698@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Chuck Lever <cel@kernel.org>

[ Upstream commit 77389a6d30a262fa94d427c03a393c05c013665c ]

FIXTURE_SETUP(zero_len) returns early when ulp_sock_pair() reports
that the TCP_ULP setsockopt failed, so on a kernel built without
CONFIG_TLS the TLS_RX setsockopt never runs. TEST_F(zero_len, test)
then sends its raw records over a plain TCP socket, which returns
the ciphertext verbatim. All eight variants FAIL on a machine that
lacks TLS, and those failures mask any real regression in the same
run.

Skip the test when the fixture recorded notls, as the other
fixtures in this file do.

Fixes: a61a3e961baf ("selftests: tls: add tests for zero-length records")
Signed-off-by: Chuck Lever <cel@kernel.org>
Link: https://patch.msgid.link/20261111185522.2859004-4-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tls.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index b37ebc2beac7a..462f80a46b900 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -2558,6 +2558,9 @@ TEST_F(zero_len, test)
 	int rec_off;
 	int i;
 
+	if (self->notls)
+		SKIP(return, "no TLS support");
+
 	for (i = 0; i < 4 && variant->recs[i]; i++)
 		EXPECT_EQ(send(self->fd, variant->recs[i]->cipher_data,
 			       variant->recs[i]->cipher_len, 0),
-- 
2.53.0



