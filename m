Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829626;
	b=ydNpSo4kQdDaQYcLsUB2mAAe2dnTJwlUn0Mwm2O9UY1F1v7knRUoknPFC2TKxeUMzKhp
	 MUd+l55avzLVVlmdN7GCmCM0ENNhvZZ6xLdvLrfS0aUrg6w6F58xheW9Z739ojPrZEPt9
	 pQm8TUdRZ60elqMi6U63pnn1RPbHTwo2e3TY2G5FfRVxOoGDOqOEnOGRYmkj8pXZaT5Fr
	 BvB7XIaVakebXWEQFuuDl0gigiVJDJyZ3aS99Oyw35NGHRRY1vaoiPh0CjVn45wJWvdtK
	 i1VdErJhovOjMh4kUsM0GIHC5w8RYzHji+Rfz02BIzfpF9f5xmrwgB2WYo22/rNJTTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829626;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tNUN3Cp2MyuQaxizIyg0OQe2oLJ/5w6sdydqd7RLlIY=;
	b=yVJB3HwCXs7fPrP20c1PHK3b3tBmAa73Q1NQayXHeNzrm7mJpe9wbLcGo0cBOdofcMfv
	 Wd0WMahZXi9HF+xK7/Wnb1H800U+THXI/RaDATsKVjsckzu18yIqRC5xgBWUPKqW3TnUV
	 lmr9XwJPKNYmsYn8D5mM8FOP6yBc37FrqpqUC76FckjY/+Mi1TH51fQKqWFArCukKYoao
	 XCSPuVISYDcDebpURZ2ifx1SHXfCapPgJR0O9oSmRCraKlP6l6gsHOaU156Zpv95FzjOc
	 PhZxlnPTp/9PKplMDzACOpdF2ZX2w0e1fgswIrX1/ezzlsRFFbtRlGRtMTNsN2nvwag==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2kjN6Fnx;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F947606A84C;
	Wed,  4 Nov 2026 22:00:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2kjN6Fnx
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B39B71F0093A;
	Wed,  4 Nov 2026 22:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829626;
	bh=tNUN3Cp2MyuQaxizIyg0OQe2oLJ/5w6sdydqd7RLlIY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2kjN6FnxJp25Yhl+8SUzK+bAsgDIH+nnUZ+e0icpxHeFvG5fsMkTC57vkKqTA5BXi
	 hME5JaAlNNHNKpsw87dK5PLgVYN5XAKKPyq1UqxRdTGP6JGwUcIl6bF9G8Eu/PDP4J
	 2Op8zHTe7nE4BiHjwfFU7xtrxg2CVxJdXtqKClMs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0242/1005] fs/ntfs3: reserve NUL byte when converting UTF-16 names
Date: Wed,  4 Nov 2026 15:59:35 -0500
Message-ID: <20261104211050.634967079@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 4871fedaabbfd574ac0a075b80e75afdd532e11e ]

ntfs_utf16_to_nls() appends a trailing NUL to the converted output,
but it passes the caller-supplied size directly to the conversion loop.
For the UTF-8 path, utf16s_to_utf8s() can legitimately fill all
buf_len bytes and return buf_len, after which ntfs_utf16_to_nls()
writes the terminator one byte past the end of the destination buffer.

The same contract problem exists for the NLS path when a converted
character consumes the last available byte.

Reserve one byte for the terminator before doing either conversion.
The function continues to return the number of converted bytes,
excluding the NUL terminator.

Assisted-by: Codex:gpt-5.5
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ntfs3/dir.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index 6e1d2ad8c12ea..6d588efaf9fdf 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -24,6 +24,11 @@ int ntfs_utf16_to_nls(struct ntfs_sb_info *sbi, const __le16 *name, u32 len,
 
 	static_assert(sizeof(wchar_t) == sizeof(__le16));
 
+	if (buf_len <= 0)
+		return -EINVAL;
+
+	buf_len -= 1;
+
 	if (!nls) {
 		/* UTF-16 -> UTF-8 */
 		ret = utf16s_to_utf8s((wchar_t *)name, len, UTF16_LITTLE_ENDIAN,
-- 
2.53.0



