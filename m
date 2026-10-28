Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793212183;
	b=Sj4VVOA0bvcZqC7GckNSgsVRgH5e8crupn2XxnAmE0H79E+pZzvcMQnK2XhvioCX6Nc8
	 R8jL1CM+jbKoIuoWT0Ye7RcFXA/UkKBlfYTF7+scnseLrlQ1xnb9/GKoJUCfwICqgzt4i
	 Ck72h56PE9zgF22aRGgDkeKTae4Q29AdqfnoTYCm4u9IVSJ5PoBhtv5oVcSodzz7A0DgH
	 TFUHa8bMuJCfUUBGTT37STYXMxCblCM1AafPOWbrwMpRI9pODK/uf+ALm0zIvcmnLhTNY
	 xwsFsalOtVfjLg8YG9vPPf0QeL8cLC8bVUIk9E0QwNjBhM4h7MsuKvNOXmLdQoDyFbg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793212183;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wteubEXCvyB9ZHBxHaHWwn8gOJalQXdh3D9iL4iIlu8=;
	b=L9sYAEjV0SYaE8nE+nxYmSuGpkuf1DXMPWWxbCBLqstwgP8/XZ4lhZaf9avhexKFBpqT
	 yKn7PxUIwsaJS3HhS5R7T8nmKWLtFbzP0R82aPYTmj3ELA5Qblqzv8w2QVA9zP7iDuNPR
	 gjEVxAXuCNyTBlMxU4+prNBOqWLX0jY57MY11e3AiNQ+19CR+d49BesijsvXVfmVpuPJi
	 iChZoxBwBjDgCpN31r8OHzGtcv6DZLOwuKPBgpgz41JnKOfoWx6oQwnq7eEO1ST56OzKL
	 USyft+SaPCEz2zBSuMN1JpesJ5TXqhxIQc+cSMU+6nzUMTVzU6gPAhfNJSi8ANcxfxQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cHh7oBsm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E087606A31E;
	Wed, 28 Oct 2026 18:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cHh7oBsm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF1921F01825;
	Wed, 28 Oct 2026 18:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793212183;
	bh=wteubEXCvyB9ZHBxHaHWwn8gOJalQXdh3D9iL4iIlu8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cHh7oBsmRQqByX5By++Sfd+BN+nXVFGBfYxQGtEBkzDHhmiK7/467VmBvqssMqlaC
	 qbXBcpzr28x1BpshjocId8TgTDM2SowGTfBAcrnfyjkSCiGUcM+11RS/np9fjBoX+6
	 CtPkRQjs9CbngNv09JOqDN7zz0M85NR85KXUFZ5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Stephen Rothwell <sfr@rothwell.id.au>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 0023/1887] mips: unhide uasm_in_compat_space_p() declaration
Date: Wed, 28 Oct 2026 17:35:19 +0100
Message-ID: <20261028170459.749443190@linuxfoundation.org>
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

From: Arnd Bergmann <arnd@arndb.de>

commit e9f98feb17207addcd66435d8211ccf9c0a563dd upstream.

uasm_in_compat_space_p() has a conditional declaration but is defined
unconditionally because of another local user, which causes a warning:

arch/mips/mm/uasm.c:421:5: error: no previous prototype for 'uasm_in_compat_space_p' [-Werror=missing-prototypes]

Make the declaration unconditional to avoid this.

Link: https://lkml.kernel.org/r/20231204115710.2247097-10-arnd@kernel.org
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@rothwell.id.au>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/mips/include/asm/uasm.h |    2 --
 1 file changed, 2 deletions(-)

--- a/arch/mips/include/asm/uasm.h
+++ b/arch/mips/include/asm/uasm.h
@@ -193,9 +193,7 @@ struct uasm_label {
 
 void uasm_build_label(struct uasm_label **lab, u32 *addr,
 			int lid);
-#ifdef CONFIG_64BIT
 int uasm_in_compat_space_p(long addr);
-#endif
 int uasm_rel_hi(long val);
 int uasm_rel_lo(long val);
 void UASM_i_LA_mostly(u32 **buf, unsigned int rs, long addr);


