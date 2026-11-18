Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051342;
	b=CxaOStrHGu2HpQxNDYz1qDvQFxhZyY2zyisRhhgLgXbQnMDUZ8TRBgEKNwk/f0X9zFr5
	 Tgg7VBwcRUa2r8hagjW4CzX+63QS8uEFGLPbV63oncqr3qKfexmNimEdDALydVYrf5myj
	 oruVI111C0cHk9aKjDcJKRIYO7GVuIoDUNcd2qFeMK1U0kICC0hP9jUsJssCymXU0d+hj
	 FM+8RDygYonnjUAOPo4TON4TpvChKCv8J79xmzfQq3VwUlMoCUhJzffCvuvXvBWIQ9KA+
	 3Ydu28F+MlO5vEoCoDLU7t/XyT/KjjbwVhj2zVeVofm2q4tsEgxsY4wZSKNBQlU0pkg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051342;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZzF75BCNipmcOgz1GVxmU/G6ZQ3buAHRPm2D2kiQ5SA=;
	b=v2Fde1owKe58sZDifXAENt0ZoV4bKgXe87lo65+IvcqZybk67QHPE5mVM7KLbclreBif
	 fCuI1ahFleZa3TvZh8+5Ve/0454w9uBJ9SyruG0f38JAmWNoLH6mkQsiZLemojtW78uis
	 hJrrl749ffRRUKUBrikxye8P3QTagiEpz0KIdOWrSkXQGWHL4kaypWEg8KqkqnShKW6Iy
	 WNyIN0xGEUHMRCXAfk5knIXnpTGH/cn6k9AilTtjADfdw+w2qf9G2iu7lgCPVuWBXpLuf
	 ncSETPSCL0Awrm42jPAT36PFtjBqdwcKRYT0FmLZT5dyXYhzD+yY01p8LcXDJyQI4uw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LdW7Sj3R;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00764606A325;
	Thu, 19 Nov 2026 01:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LdW7Sj3R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 505751F000C4;
	Thu, 19 Nov 2026 01:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051341;
	bh=ZzF75BCNipmcOgz1GVxmU/G6ZQ3buAHRPm2D2kiQ5SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LdW7Sj3R/r7GykDBVLNn7KKceky+vOM5wcCxceU1iNcZ05ODSgcqh/p8TlgPyikja
	 pMBi1oFMp9evG1GS4Ju1i6+c9JwMIw1zBppfjxwg8mP04FJ6Mc95yad4VLbDyFslsZ
	 ZW5PR4qnCcRqN9q1mBaA1uGMsbBb7E3udc3gOnKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0133/2214] fs/ntfs3: reserve NUL byte when converting UTF-16 names
Date: Wed, 18 Nov 2026 15:30:09 +0100
Message-ID: <20261118150015.531634982@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



