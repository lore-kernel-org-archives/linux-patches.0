Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060807;
	b=SDWzKaA2WKvSV7lS3gaRQAbMU5TE8Hy7hDb6U873AavlwP7XswCOKXrB/rJNTxpFbXnf
	 BYqsUDw7nxT1Xs0+qGk/iJBtWpyYM5vZe2lTm3CCQGG6qBuuFxZkmR9LVc7LFX2dP4ppR
	 uUYzHMn8gCmkrVXQOwKuWyzCD7hw+OAMD/BHxaDBEJTbJXbB4gqp2b2ExUWrcZ5KwMf/H
	 etKUVNwQQwi6ETBghP7pHGpu2DX5X2U5MhjEeqfIgiLppkbY1WZB4IN6YBo5EiSMoUDsq
	 Fx3eQ71CAz5D/vcZEmjPy2RpHIaUSnJaASgYU7VF5T5n9cVTNq3ERPt1VuBHJZ8Hcmg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060807;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=xKnoi8mScAKtEeikgUh1IWDn1KExV2Y2m5xAQcUM9gE=;
	b=wPgOJOQdt099vSre+SURBjTeasLWIXo/XO5rs376Pr40jIiqzHifpcKzPT/xjl+Himle
	 /ZglguOpzPTavZM3gzmZI9FfsOOi4eXYC0E1UgjtSTylkcM0ceHVyyhrO9KEu1cbz2SV4
	 NCwM9vyYq3thwMsSGgGHFFV/7nwnYiVzHcSe/fgOiaphYRCgaghdqgTm0g/5jDDSey5LW
	 tLOcuB9chQBtWTjKj+t2NPuCIvJw3/69YWkWvZpgtydC3tnk3BxBzsNlE680ttpCuGhfs
	 3dGf3gc/2l7MHAFZ2SgHH2qGL+iUz/dqocq36V8nnNTr1XVjLUGK6NTcq49q1yJESLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="hjbrU/DJ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54C1606A326;
	Sat,  7 Nov 2026 14:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hjbrU/DJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 936E41F0089F;
	Sat,  7 Nov 2026 14:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060806;
	bh=xKnoi8mScAKtEeikgUh1IWDn1KExV2Y2m5xAQcUM9gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hjbrU/DJCEiiWQOwGRQnK4EcRUN0EtuRKLb6NYWwUBvrd3ktL+5RHjR5hlYqw+aqv
	 sGEwwqxW96aAjeWeU+mkR9YRZiAd1JuF3DrUuCw2jx2cQI/aGuEDMWTr6IfO+B+MnF
	 YsurrtxyvPWeVF/JOES580mfqseky5c0LPBj1e9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0204/1536] fs/ntfs3: reserve NUL byte when converting UTF-16 names
Date: Sat,  7 Nov 2026 08:37:00 -0500
Message-ID: <20261107135003.387904513@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 43a9b927bd89f..77d3066560253 100644
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



