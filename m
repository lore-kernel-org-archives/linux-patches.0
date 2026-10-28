Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215657;
	b=VtZix0A0elAT3odXnp56XDyAHSvuvd69ftzalimNtgVovFSeh1Z+eMMD9xfJZt8GWtyN
	 uzAvx9JPFVx5QmfmFVvcTlkO62EiXicPoZyuQut6tO4Y0Vr7FP/SqEaU+BPEgqUbWQuoM
	 iY2w0kPu5qR+VVJwSahl57uopp4vggfcVQ8LHlsVosSEnjif8krOZ0QfT8flBinzBhfjp
	 +28mDIYjSgb5vbYcOPfF6M7lM8UBEd5wrY4IMuq4C3xzcwfUiSJfwAEVuprEtc5Y3F9hJ
	 zbKGrvi9/dTEilEruWuxVzgGDXItwQLSCLc8uU/pr/WGIgRwF3Z/WFuSyj4t9BV0WiQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215657;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qbF/SzpURoWn+My2irAWFpDWQmtuy2R12c3ZJW0SPys=;
	b=NCb/QdZwqKCIB0qW2ANZjhiGJooLA2VE5qHJ3SRcjmfWTO2u8f2dL0HVo30g48ArE9rD
	 vDBgNHOOxBzZbGcIdb4Mvb6DCmN7A8ZEKcBXHLbmFn7KCvswSVaxqC/v8WXMY/PQ+8h2c
	 OVLcLzIbvw1T1DRpReXsnIL3a4BLYTnKF22XKRL4Temuysp3z4au3Oj2kCQa+H1bbUFv6
	 uJqGNZhhDwIlx+hot7vRUkCeyedrAPGP16I0IcW70VtgIwKjlb0ILDlw2AG38yek+MxBi
	 00eQmV1q7X6n3U31LhTgokrHwpZX2gRBOmRsPcIRLCnX96iAdY3/I7xL8tZLTRZcxyA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Aa2lzdfd;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F9C606A31A;
	Wed, 28 Oct 2026 19:27:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Aa2lzdfd
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E92681F01825;
	Wed, 28 Oct 2026 19:27:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215657;
	bh=qbF/SzpURoWn+My2irAWFpDWQmtuy2R12c3ZJW0SPys=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Aa2lzdfdcy+FQA8MxL96Fql76MQwBuTiqkbF9ulHYVpuuP5eCXmKcI4DN9l52XlQz
	 dRZExgs57kPE14EJ5AU+OU3Y6qWo2PWyG5UqdFyZ6be641i6WGGuycyPR36b6QRaQ1
	 nR6ia+pnfhkEo0VzoBtbov/pKYmuQN/eiWaj8hH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1288/1887] selftests: tls: add test with a partially invalid iov
Date: Wed, 28 Oct 2026 17:56:24 +0100
Message-ID: <20261028170528.736059039@linuxfoundation.org>
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

[ Upstream commit dc54b813df63020e946ccdef35b64d4fa99fd622 ]

Make sure that we don't return more bytes than we actually received if
the userspace buffer was bogus. We expect to receive at least the rest
of rec1, and possibly some of rec2 (currently, we don't, but that
would be ok).

Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/720e61b3d3eab40af198a58ce2cd1ee019f0ceb1.1711120964.git.sd@queasysnail.net
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 1c8629651cb5 ("tls: rx: restore msg_iter before TLS 1.3 optimistic retry")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/net/tls.c | 34 +++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/tools/testing/selftests/net/tls.c b/tools/testing/selftests/net/tls.c
index 4c97940d965ff..b9a470038ab33 100644
--- a/tools/testing/selftests/net/tls.c
+++ b/tools/testing/selftests/net/tls.c
@@ -1495,6 +1495,40 @@ TEST_F(tls, getsockopt)
 	EXPECT_EQ(errno, EINVAL);
 }
 
+TEST_F(tls, recv_efault)
+{
+	char *rec1 = "1111111111";
+	char *rec2 = "2222222222";
+	struct msghdr hdr = {};
+	struct iovec iov[2];
+	char recv_mem[12];
+	int ret;
+
+	if (self->notls)
+		SKIP(return, "no TLS support");
+
+	EXPECT_EQ(send(self->fd, rec1, 10, 0), 10);
+	EXPECT_EQ(send(self->fd, rec2, 10, 0), 10);
+
+	iov[0].iov_base = recv_mem;
+	iov[0].iov_len = sizeof(recv_mem);
+	iov[1].iov_base = NULL; /* broken iov to make process_rx_list fail */
+	iov[1].iov_len = 1;
+
+	hdr.msg_iovlen = 2;
+	hdr.msg_iov = iov;
+
+	EXPECT_EQ(recv(self->cfd, recv_mem, 1, 0), 1);
+	EXPECT_EQ(recv_mem[0], rec1[0]);
+
+	ret = recvmsg(self->cfd, &hdr, 0);
+	EXPECT_LE(ret, sizeof(recv_mem));
+	EXPECT_GE(ret, 9);
+	EXPECT_EQ(memcmp(rec1, recv_mem, 9), 0);
+	if (ret > 9)
+		EXPECT_EQ(memcmp(rec2, recv_mem + 9, ret - 9), 0);
+}
+
 FIXTURE(tls_err)
 {
 	int fd, cfd;
-- 
2.53.0



