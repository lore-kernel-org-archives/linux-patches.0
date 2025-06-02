Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE5211F4165;
	Mon,  2 Jun 2025 14:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748874176; cv=none; b=nmrbPdWy2cvsQAN11amkZs4CDnufKlP0lBgicifblOghHKECkPs5uAJY5ZrHzdi9+CSvdeUj+ntwqhXhxIfgQz7EYQz0vXRva8n//PwCyv8IiNwd599nU1kpJ41yphyjkNLuZwOI0rW8xnJoPNcItluVjfhgIesRUHYZN2wfE9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748874176; c=relaxed/simple;
	bh=zdDnEj5SKHLUFalBt5F3+wRcd9wC2z82pPKkgkYQO0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=atYdvcp29LbYOYIxdpvCPO79xrwrSMCgkTbvbpzJUaJ9SX3F7z/vfOQ2cDAusIEh55dQ1ThwUI1M8qhUdWCoyv9Hi78yV6yMEsX78d0RX3fqw/Yu18hxhkLImFpwxczGDj/r6A/w/qAtbm8GFcFwf01ccs7pCChuaZjs4VoNljU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ctCceThV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ctCceThV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDAEAC4CEEB;
	Mon,  2 Jun 2025 14:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748874175;
	bh=zdDnEj5SKHLUFalBt5F3+wRcd9wC2z82pPKkgkYQO0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ctCceThVDxUXjSDgfot1b4traSdw1pKcjwFVxQqM4aqm8hSXBWrxUkExFQvRhaehZ
	 biRN0XZcfGhqNFds+j5Dt6Y+mSEjmqH6VHlOZIZvvsIpw1zgf1rDvUQ411EacDhx/o
	 2bOrNMU+0kpT3prpD5MoXHtoon8Wr9cS0soUUuPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Dobriyan <adobriyan@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	"H. Peter Anvin (Intel)" <hpa@zytor.com>,
	Hendrik Donner <hd@os-cillation.de>
Subject: [PATCH 6.6 383/444] x86/boot: Compile boot code with -std=gnu11 too
Date: Mon,  2 Jun 2025 15:47:27 +0200
Message-ID: <20250602134356.457680581@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Dobriyan <adobriyan@gmail.com>

commit b3bee1e7c3f2b1b77182302c7b2131c804175870 upstream.

Use -std=gnu11 for consistency with main kernel code.

It doesn't seem to change anything in vmlinux.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Acked-by: H. Peter Anvin (Intel) <hpa@zytor.com>
Link: https://lore.kernel.org/r/2058761e-12a4-4b2f-9690-3c3c1c9902a5@p183
Cc: Hendrik Donner <hd@os-cillation.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Makefile |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/Makefile
+++ b/arch/x86/Makefile
@@ -43,7 +43,7 @@ endif
 
 # How to compile the 16-bit code.  Note we always compile for -march=i386;
 # that way we can complain to the user if the CPU is insufficient.
-REALMODE_CFLAGS	:= -m16 -g -Os -DDISABLE_BRANCH_PROFILING -D__DISABLE_EXPORTS \
+REALMODE_CFLAGS	:= -std=gnu11 -m16 -g -Os -DDISABLE_BRANCH_PROFILING -D__DISABLE_EXPORTS \
 		   -Wall -Wstrict-prototypes -march=i386 -mregparm=3 \
 		   -fno-strict-aliasing -fomit-frame-pointer -fno-pic \
 		   -mno-mmx -mno-sse $(call cc-option,-fcf-protection=none)


