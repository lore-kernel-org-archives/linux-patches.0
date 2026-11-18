Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033884;
	b=SlZsbxdULomCL1I05yAtP7mlKHbB4qTtm212cVYEqUjN0JjY9AB38Ym7Js57T7+U4RJ8
	 IBAWgR7+ayksqOHt4ZysX/WPkiLtuFWN4tuJjsKIqWJBg6nSUaaWSioaDnovofOH7o9E0
	 zF3GbS+jUHFIbvJf3fr9XGs48tSqnxLwnBfLsPKHxyXKI6Nke9eyuC1OIzGhh7T8qDul+
	 p0RhQUMsak7hwXUIYs2OFP0gJx0zLKro6IKb1kyy/9FFN95hGdOYjHorNgSG33IZQEjT2
	 EkTI7raXmyFtGaE8+wBXsdfMLRBamSbEc66o35Crkgm4wfRSb0e4LLUu167jG4gkMIQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033884;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7log7iXcM0QI+NsDlbib1TYNZ+dZr2CInAAET6/ZXmQ=;
	b=wujsH9dMn8+9FOC/lRV+2PtHLAzQbaI+AHz0v/182aFG0HM5up/9lZPlWouB4614A+q8
	 N872JQgqYeENWYVvBBeNp/CqC9L7WiQAiKSIXSflP5jY/np2YaH6+GnoeneAhSNVwwIZC
	 yTsF+2eRC5oDiKvLW8t76wXTUD7NN+Or3ZZi5TuO7lgp96+8movkEMQy2GKym4IUH1biM
	 AMjCBvrsBSjFmoPF3MahHdYfWPgPzrfSAlvJ4x/xxfvuUnEQ8qHpKCIrMi3qgjW+nanxM
	 6VF50sjKTX7kKonIDILWEM+l2oCnLbiNblmwbDCWzyI/WopRXYmCPOE12QQpSxSHtlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eoUewY4J;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51CAB606A31C;
	Wed, 18 Nov 2026 20:31:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eoUewY4J
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A87B71F000C4;
	Wed, 18 Nov 2026 20:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033884;
	bh=7log7iXcM0QI+NsDlbib1TYNZ+dZr2CInAAET6/ZXmQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eoUewY4J5W8oOe3/3acEivwSjYZZ9c2pqxNkYFUnQRGhKwwyCi8j3T6spLODLrZvG
	 X9TJXYy/a3UETzJYRlrlBPkdJFzaxno4Q5aZmktca6zbeYm6TGWXLK+Vurc6fP4fzx
	 0P2kzOuKbyU5PTGz10PGLWooLtzmarvSuCG9nLy4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0174/3318] fs/ntfs3: reserve NUL byte when converting UTF-16 names
Date: Wed, 18 Nov 2026 15:13:16 +0100
Message-ID: <20261118150319.893701184@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9335d706e2005..cde23d4f103c7 100644
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



