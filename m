Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795619416;
	b=p0GCgqDEW3MSUcJc7+BUItnRWzSkzVJSlDMZ8ruR7RYfhTCuwuY/TajJeiqYiXdwvrhf
	 9pm38HRNFPJ9jgyxo5479mutXV7qMwi7OurLMb/GlYBbbPzEfSa8dmFTQjkfYOuZhsKQd
	 6LGzSl9G/dN0TTlsLE5xFk8pVETkXTBRarzN3/Ugc+HrnD5VnBhxKY6yN4yofgVkGPO+w
	 s/tp8s5ULXsrAP59Zmh1NJoDYNKfqXTzWC4dDM03wEE2V9EWrGGoT4B3cr0OK+RJPDcRh
	 datJOA4cUJGNeZ6yDmbzsqCM4PxvjLmLJLfKh9Z5860e27u3KozvavFE3H8e1OtwtcA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795619416;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RRPPRaVEXwdSDa61/oHMmv3knDbxnRoRZZ1qn4+0j5c=;
	b=HjsvULTZkdFUrSHcG77dLHOJ+DUpz5B96yUcAJCvLuQ03Q9N07NJSvhg+N2hZ9+0WUrk
	 8HX2BckbZgKz4sGi+C35MO4P6Q6LxynCs7cOGV37xfinwc5Mv9mntwDi/wJLRP3MbG27U
	 MMlSz/6WmqY3YJOODQxN8fFyMseMu4bPx+6BKzTcQTU3hIZ4yMVMm5khykwIavDeCCvWy
	 LR4Ndqvk4DUdpemych5YBtt8JfymPjHk0NhbIEQ/3bP2zVV6BFJAnpQ7iXNq3F+0/DlG7
	 Lj3O6yRdpcPeh0XnItD8g4EXpYhfKysP3OZ3b3u6RdbT70mRTwVkZScKvXD337vWZ2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pSNH3eEq;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D81F8606A31E;
	Wed, 25 Nov 2026 15:10:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pSNH3eEq
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E251F000C6;
	Wed, 25 Nov 2026 15:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795619416;
	bh=RRPPRaVEXwdSDa61/oHMmv3knDbxnRoRZZ1qn4+0j5c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pSNH3eEqQbRbDpsHjen3VsbM+6to63P/uwWI0DBRKc1f3bggn6+Sj0kbd0Vb7jEr1
	 ZyolsWjNxlEXMsn7ehjH27OMaTlCpLMe/XOSMCu8EArh0sBmv3Exg+qTMv5G4bbDB7
	 gTn5l9zGVUqw8RhR2nqVL1UgB4FAOKs/4l1fEYxU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <cel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0552/1005] selftests: tls: Skip the zero_len tests when TLS is unavailable
Date: Wed, 25 Nov 2026 15:31:30 +0100
Message-ID: <20261125143834.675908690@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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
index 9d3cd4fff062b..0bc43728262e0 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -2639,6 +2639,9 @@ TEST_F(zero_len, test)
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



