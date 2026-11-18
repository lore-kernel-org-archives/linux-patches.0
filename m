Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795015551;
	b=Dxen3911MXOkTB7WBqwEjIt5/YF5fo3KDzbFBanr2cQ72aBLOGAMidmDfzdlfJcKCIBW
	 3qi9j6yqKWafsbXVFkkjpnfnDV3iTWdbHCbZM3AyyRMS/Ev+/f5jysnKFPm/Zf7dkyOHz
	 U6tZTOHLo6ZGQFnR1MoGxe4AV4Eq82PPpd6Z9Y4WcUhL3dn3CHRKe8If9CgSyv4/CzerT
	 Mzacvgl6wzqXsKRaNM5YHjZOiGBLe7zoVV2yUTjAaqVQJtzvpVLwGNvLXt7r2esb4Yly4
	 CUxOa72fc4fKVlAh1BsGwzsukcgEwo+/rlYHWwkDriOcW1acx+pqY2o1KJiLwxlXwUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795015551;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8tQjRrrSvEGlz116GKq63qmemNGUyB/wWvQkdcxal7s=;
	b=MyQKVoVi2mNFOBLKW1n7vSlV3AoCiIkd6SjT/2/Jlq933TDw77gSsgfHU8JqqF6tSbBE
	 EKQCzKH5BmTDGbxosNhsZSLzesUGGCtxwaV6AQQ2JOkI/jCtMt7KwhVomFzifFlHWu/Ui
	 gR3w1QpIFrohkcKiD79iD+1hKPj8FwUX5X9uRZQ1kP7U3sc9gcVljAh+RAdTvvKpm5F1l
	 0/O532iFC/qfRnweDyRA1ZdzSXpwwssstVnS7E/R0aRKvn3dx5X9Lm7zRzxDMR27KVBpw
	 5D/e9fbERF0hYB3nMcAHSY/UV8CYEde55rIXQ3X1x3eO+ZuNRS7g+6S/56pi/dyMHQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FLdI3V87;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A6F606A325;
	Wed, 18 Nov 2026 15:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=FLdI3V87
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1388F1F000C4;
	Wed, 18 Nov 2026 15:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795015551;
	bh=8tQjRrrSvEGlz116GKq63qmemNGUyB/wWvQkdcxal7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FLdI3V87tlBAuNRE9Rv63Mpj9l00JPGeMAfjOPLxrzeZueOM14i+OQ5qiYMJmsGkK
	 KpTnk1R1A16dVBbFtj9c5UbInUQFB+CaEqRWwfLbmY71DuLgeu9+tGXFuYPvuwkXvm
	 QhtaxFcrGLtdKKfhsW4GWp2Jfmk34/0KXeKgLyHE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrice Derepas <fabrice.derepas@canonical.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0215/2651] crypto: asymmetric_keys - fix OOB read in pefile_parse_binary
Date: Wed, 18 Nov 2026 15:24:15 +0100
Message-ID: <20261118150255.612398253@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Fabrice Derepas <fabrice.derepas@canonical.com>

[ Upstream commit 37d550172c2d3cdb3a5ace3e6cb0625967d86349 ]

pefile_parse_binary() reads the size field of the certificate table's
data-directory entry, which sits at fixed index 4 of the PE optional
header's data directory:

	ctx->certs_size = ddir->certs.size;

but nothing ensures index 4 is present. n_data_dirents (the untrusted
NumberOfRvaAndSizes) is only upper-bounded against header_size and may be
0, and header_size need only satisfy cursor < header_size < datalen. A
crafted PE with n_data_dirents = 0 and a tiny header_size therefore causes
the ddir->certs.size read to land past the end of the image (CWE-125). The
chkaddr() that bounds the certificate blob runs only after this read.

verify_pefile_signature() is reached from kexec_file_load() (the
lockdown/secure-boot enforced PE-image signature path), and the image is
parsed before its signature is checked. The trigger needs CAP_SYS_BOOT and
the access is out-of-bounds read only (no write).

Require the certificate table's data-directory entry (index 4) to be
present; the existing upper-bound check then keeps ddir->certs within
[cursor, header_size).

Fixes: 26d1164be37f ("pefile: Parse a PE binary to find a key and a signature contained therein")
Assisted-by: copilot-cli:claude-opus-4-6 frama-c
Signed-off-by: Fabrice Derepas <fabrice.derepas@canonical.com>
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 crypto/asymmetric_keys/verify_pefile.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/crypto/asymmetric_keys/verify_pefile.c b/crypto/asymmetric_keys/verify_pefile.c
index cec99db14129a..1efd5c0d0e9ce 100644
--- a/crypto/asymmetric_keys/verify_pefile.c
+++ b/crypto/asymmetric_keys/verify_pefile.c
@@ -87,6 +87,11 @@ static int pefile_parse_binary(const void *pebuf, unsigned int pelen,
 	if (ctx->n_data_dirents > (ctx->header_size - cursor) / sizeof(*dde))
 		return -ELIBBAD;
 
+	/* the certificate table entry must be present in the data directory */
+	if (ctx->n_data_dirents <=
+	    offsetof(struct data_directory, certs) / sizeof(*dde))
+		return -ELIBBAD;
+
 	ddir = pebuf + cursor;
 	cursor += sizeof(*dde) * ctx->n_data_dirents;
 
-- 
2.53.0



