Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795043312;
	b=QJtuqNkr07wTURPfI6x92ngQYpAEgI4De2Jy1IN36lUEQreMCpha2LgLPMTyFHrhZskE
	 ZNTOeImDVlroIj50NeYX2eWox30KK1/a7gaGRdm1KSaUEFyNfNoBRgwj8cROSu3zqpv7x
	 m/mb/XTmQHBRSeE2V0VbfTN+UqgVNWQAEu5CfxnlkivjEQM60yqrgt+Um6SJa1PZCYJT8
	 ggijMzfmk0UYT5xdKembyGhSqPYzfmXLqdNZaLJhxBlLU+3Wh6u2UVrAh/nNRV88B7dgT
	 YM+VSSMR1ha4s9ajktdK9bWj1IbHnAJFevJcnbs+mrUJIoQGBI103mUfqUZ2N++D6vQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795043312;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Fwt+26TyKRAwmgYFK0357XUa72s3SkS7/1vZofazNGI=;
	b=cATIBU1915ynI4rXnVCL5BOu87wZ616H82MZJlWZ1k0wXPirqnbk71NcRzGoGaA3Fpw2
	 evdj0RzmjmeUe9fHxtaX6CQYklZwj3D1ejOWtTcoie+kQSE79hKRN9fh8V9nkOgk2Xy6z
	 eQmqeyzLDVBoe6j9xWHbE1M9UrKZUNYuPmJdVt3H/uqIYsAuoSMEPVu1lFtNY7ab9DOdf
	 LZw/xhFHWe47B0xfyFaA1t80zYyeOP0B6GRYgoCy8zB6vmtEfF/YKohqhrSB9P1DDG6sa
	 gDksB3F+buPwpeeM4iLpEWo2bS0XSR1y02a9lPGhMkAe7sNRvNm52UR+KnPEpm5kxIQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YkZvSJHy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 515C5606A31C;
	Wed, 18 Nov 2026 23:08:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YkZvSJHy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CB31F000C4;
	Wed, 18 Nov 2026 23:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795043312;
	bh=Fwt+26TyKRAwmgYFK0357XUa72s3SkS7/1vZofazNGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YkZvSJHyBhdcDBqdnmutRv1TsqUETYsyYOyAU+hODO8S1NT2fNIbM28GnvSOKCAP1
	 SlfFDbNQN3MlMmRi1FwdVvyZuKZzkurnZbFp+02hco35wJDymf9I3JGhLLNvEkIkx0
	 rutkV5uWCBa3DmETeJv/40mq/lqjWgfH/E0odBH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0149/2857] fs/ntfs3: reserve NUL byte when converting UTF-16 names
Date: Wed, 18 Nov 2026 15:19:43 +0100
Message-ID: <20261118150206.713588305@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index ca13b5a1fdabf..0215850964d79 100644
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
 		ret = utf16s_to_utf8s(name, len, UTF16_LITTLE_ENDIAN, buf,
-- 
2.53.0



