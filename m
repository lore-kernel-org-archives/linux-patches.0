Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016851;
	b=p0TkMsdz3Ud0ITriJF0dnhvIPhz+d/2GwBt0Zhgx9Z62OcGfBFoglq/mZhJzV5u0d5ji
	 qyQfObJeGkEZbxVhiBa47CXvy23MUR70rsCYGutuRt73ug6myCNpDFKZ6H2TfFcb0NuIy
	 aGwTLOfi24NfjD9v3g9VWhY1IBQEWmvPd/MaJuULXM+IU7nC5XUMsmlmgnFL6PIi3Qn6S
	 DJWorY5sv1Ot3nMCDOETKvIpkmK2v7si+3m/UbE4SQMZsWKcpy/gFAyeKGwZftYY3kWHV
	 UYmzWxF7fV8glVqdCe/dIwIOkO1VKGSmLAhvd/aEGeqLb8jgqav3ywFhgNT4rc9z7sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KwM64uKEnAIKF/cro5+DBSnq4ujyL2oHUVJHpyNbCG8=;
	b=vA/K2Z3JACCCyz5spT91mgqvXmviDnLoPiXN5hjrOcgB6cJOhC+VSz8HAYLB/tPXovvA
	 AIqj6gyDYJAe1suiUt3Yx+8Um2Fhoe7KRTGLjnSUDFFbeZ8wF8SojOssQxZ9QuI0EBgNa
	 P2hPJGwz4puuzj8xPWtvlHOCzr5/icRDa3bt0fq+zzPx6jztGVTvUnURNZB8vdSbfzma7
	 Apka1V2r7ASkbjicLK+RhS0IDd2pmQGZJdUt+zD/0ogkfpI+5dDytoKw5sfhVAqYwGWgp
	 w4VH7UpoE3rDOMH7TLrnZ94q8hs20JiYSuURTtU8SvzJqY3Y1xjnc1JwxpZBIekZdJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sgL0fqAl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7F3606A31C;
	Wed, 18 Nov 2026 15:47:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=sgL0fqAl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39B3A1F000C4;
	Wed, 18 Nov 2026 15:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016850;
	bh=KwM64uKEnAIKF/cro5+DBSnq4ujyL2oHUVJHpyNbCG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sgL0fqAl5xeSsbsj8XbEJykmSl/63JvclSsbAUcuPRaGYti+MhSDOcqeaYAIM/nm3
	 MMIX8U9JNzTn+ueSM7Y6djIcSxAweDQy5sjoY022hVrOD1VU99BDPQZW4XetSokzBE
	 uxw98/Eznq9aDWlK6WQguZtQYd7D5Dd9BDJrwg3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"H. Peter Anvin" <hpa@zytor.com>,
	Mauricio Faria de Oliveira <mfo@igalia.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0675/2651] x86/boot: Remove redundant "cc" clobber in memcmp() and document it
Date: Wed, 18 Nov 2026 15:31:55 +0100
Message-ID: <20261118150312.172892766@linuxfoundation.org>
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

From: Mauricio Faria de Oliveira <mfo@igalia.com>

[ Upstream commit 94509668fccfa098e0a3d57e7093a9afd88aea9f ]

The "cc" clobber remains recognized for source compatibility, but it has
no meaning anymore; it is automatically generated without condition-code
constraints:

  https://lore.kernel.org/all/57b0d188-b256-bde4-43e6-99dae4f59d60@suse.de

Comment out the redundant "cc" clobber for documentation purposes.

  [ bp: Massage commit message. ]

Fixes: a8c171c107c0 ("x86/boot: Add volatile, clobbers and zero-length test in memcmp()")
Reported-by: "H. Peter Anvin" <hpa@zytor.com>
Signed-off-by: Mauricio Faria de Oliveira <mfo@igalia.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://patch.msgid.link/20260921-pvh-kasan-inline-v10-1-08da47943d8e@igalia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/boot/string.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/arch/x86/boot/string.c b/arch/x86/boot/string.c
index 1632d40e1f545..e10260ed58b69 100644
--- a/arch/x86/boot/string.c
+++ b/arch/x86/boot/string.c
@@ -36,11 +36,15 @@ int memcmp(const void *s1, const void *s2, size_t len)
 	/*
 	 * Make sure ZF is properly set in the len==0 case because in it,
 	 * RCX==0 and the REPE; CMPSB won't get executed.
+	 *
+	 * The "cc" clobber has no meaning anymore, just source compatibility.
+	 * On x86 the flag status bits are automatically added to the clobber
+	 * set when there are no =@ccXY constraints. Keep it as documentation.
 	 */
 	asm volatile("test %3, %3\n\t"
 		     "repe cmpsb"
 		     : "=@ccnz" (diff), "+D" (s1), "+S" (s2), "+c" (len)
-		     : : "cc", "memory");
+		     : : /* "cc", */ "memory");
 	return diff;
 }
 
-- 
2.53.0



