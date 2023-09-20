Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BCFA2AB5E
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 12:11:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C3F6C433CA;
	Wed, 20 Sep 2023 12:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1695211863;
	bh=irmkspfCLEV6dsWlEkhpruqyRKEdtmQOlQBQQRkKCdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pY3NWh7kd/dYaZB7AK4s1RdxHKFM0OgCHu810u6+MpWlwlyb8THZBmk+cOPaGLAU/
	 J8bt1CX8kiJE9ttuUyi8FGej02WZ+ueaATOgiX8NynwJAOriO5QKOR+fMFWdE/fnIN
	 AzoMivcISdR2Bh2XpDICMXjlZh8RXd5n8gojnlYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 4.19 038/273] powerpc/32s: Fix assembler warning about r0
Date: Wed, 20 Sep 2023 13:27:58 +0200
Message-ID: <20230920112847.604462223@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit b51ba4fe2e134b631f9c8f45423707aab71449b5 upstream.

The assembler says:
  arch/powerpc/kernel/head_32.S:1095: Warning: invalid register expression

It's objecting to the use of r0 as the RA argument. That's because
when RA = 0 the literal value 0 is used, rather than the content of
r0, making the use of r0 in the source potentially confusing.

Fix it to use a literal 0, the generated code is identical.

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/2b69ac8e1cddff6f808fc7415907179eab4aae9e.1596693679.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/head_32.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/head_32.S
+++ b/arch/powerpc/kernel/head_32.S
@@ -987,7 +987,7 @@ start_here:
 	 */
 	lis	r5, abatron_pteptrs@h
 	ori	r5, r5, abatron_pteptrs@l
-	stw	r5, 0xf0(r0)	/* This much match your Abatron config */
+	stw	r5, 0xf0(0)	/* This much match your Abatron config */
 	lis	r6, swapper_pg_dir@h
 	ori	r6, r6, swapper_pg_dir@l
 	tophys(r5, r5)


