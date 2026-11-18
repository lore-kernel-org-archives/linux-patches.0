Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061224;
	b=XeOI2043y+as/xjja1Qnmv5ZYKtGPyva728S0xoIh5cuOSKruKR8In9wBgojtXc5ElPh
	 YKdBy5EYSG/LWFXRmwZTfyI7G2ktgrrca00BLmf9nY7xTw25mZ7KCmSao/uWMEjgkioek
	 Y5/h6nQvUzOEawoJC91Ju2MzTGqg65743sReQovaBHdT3qyQKyVJyLnD0z/z6RUKQfFBQ
	 v00A16UCjkL1lS6LY/ZE6LNFWXbely5Um84kE5RieQzWpLP0Whsn72oQ/MP5qHUCQKDFh
	 kbpxuq50iYAO5qAjEsDIIgSgxFcqYaeLjggjEGIkXI22w9Rsu/pyL6cHgEL4LMnTl+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061224;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=v5Y4D4JMoJ5Mhj44sL23pWbXg3hAH5S59M2OpX8678A=;
	b=xyAToOvdQwFuEfMdiqxdFM1Xn24nOBeub8zzZqL5QM1dhW6eTcWh5bgQ5ZmO3Qq3DVuf
	 ecob61t5duDlhFi7+U8b3Tv2+loIYwXEQ5aWBsPwlOqsTWI5Sx6Y4a4Lw+B1yFBBI1+bH
	 q4TzUgNJ5sCu3GG5M6herZYWxoLYedyIpjCrMo1osRZKY3JAnlBTorqFKRiEHcJhaSZBp
	 G3olrOMiW7WjJ6WVsWrq3cpfYYHj4FTRrxoZN4SgT+wfcLCAY4ehcADK39pgw4JgB/+bF
	 CKlTWkcaupn0ULD30Mu58Jmn6luXHzUSENCkQHjrlVf/Nk3zzu+O2kzgGEy+ckHhNzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0RvgTyg3;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E6E2606A320;
	Thu, 19 Nov 2026 04:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0RvgTyg3
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAE761F000C4;
	Thu, 19 Nov 2026 04:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061224;
	bh=v5Y4D4JMoJ5Mhj44sL23pWbXg3hAH5S59M2OpX8678A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0RvgTyg39yqX3C7pPqe6nm4WaVGLjbUNUm/RQvAyLcfMazehRidxLZkEAeX2me4y8
	 bCKmnWg2XT6u8mPMX//BukBVfngqkCtqJo5n4WUw004gcT7zgiOIGqAwCVMgNG/yEW
	 9hvobs6CSwCpdIjq8Qtle+9uelm0HtHMI94XajCQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Anna Schumaker <anna.schumaker@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1477/1848] NFS: filelayout: calculate dense stripe width in 64 bits
Date: Wed, 18 Nov 2026 15:58:35 +0100
Message-ID: <20261118150021.119019332@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

[ Upstream commit 9ba13ef0e3ad033d3ddbaeb740b12d135a88363d ]

filelayout_get_dense_offset() calculates the stripe width from the
stripe unit and count, where both values are provided by the server.
Their product is stored on 32 bits, and can wrap to zero despite
passing individual checks. For example, a 1 GiB stripe unit (0x40000000)
and four stripes (4) cause the following div_u64() to raise a divide
error during the first read through the dense layout.

Update u32 to u64 and use div64_u64() instead of div_u64().
stripe_unit is a u32 and stripe_count is limited to 4096, so the
product cannot overflow a u64.

Fixes: cfe7f4120f8b ("NFSv4.1: filelayout i/o helpers")
Assisted-by: Codex:gpt-5
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Anna Schumaker <anna.schumaker@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/filelayout/filelayout.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/nfs/filelayout/filelayout.c b/fs/nfs/filelayout/filelayout.c
index 449a0bab7e0a1..cf00f99619da9 100644
--- a/fs/nfs/filelayout/filelayout.c
+++ b/fs/nfs/filelayout/filelayout.c
@@ -55,12 +55,13 @@ static loff_t
 filelayout_get_dense_offset(struct nfs4_filelayout_segment *flseg,
 			    loff_t offset)
 {
-	u32 stripe_width = flseg->stripe_unit * flseg->dsaddr->stripe_count;
+	u64 stripe_width = (u64)flseg->stripe_unit *
+			   flseg->dsaddr->stripe_count;
 	u64 stripe_no;
 	u32 rem;
 
 	offset -= flseg->pattern_offset;
-	stripe_no = div_u64(offset, stripe_width);
+	stripe_no = div64_u64(offset, stripe_width);
 	div_u64_rem(offset, flseg->stripe_unit, &rem);
 
 	return stripe_no * flseg->stripe_unit + rem;
-- 
2.53.0



