Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216337;
	b=pfYWpySf+MBoCmX5bVUeAGWAfh1ih25izsBfHPdeO66penSn/lUob42Lfkl79l+8RDJ5
	 S1DOLNF9yxaB01dI+htP1bEysleVi/4oi7IR8pI6BoQjD899XR/z/ZReZFP/OGI1dXZWm
	 YPBgJZJjl5sel8dRi6dr+9oQ9qSsAhyrnLU5dlOTmg/eNa2Lda5SEGa4C8ETZ+FnNfOIl
	 qszaRT7ByX0Ojsg48pABUp5iylaFIb1Szj0zbDSi/FiZVMb9JAF/ZmGnoKgZkaORhZMWV
	 yD1bwIM2D1cszueBAnd5unkDF+JpLYNWpxknUNcisOpzbXRfXEMe0bZ6+O/gIAgKY8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216337;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5j5dul/e/jTOSIA8AvO323Al6iK1fym6r5/65YR7sBM=;
	b=NKu/jfOKY/c+4HpH6XqxYOZvgaXrJpATxd/flMK6Vlr/ER0yi5xISv4+B+OIeC2QXMJJ
	 QhuB0DRRO5Hvqli3tx2ZAymxUxm15kr81vju0oJBmKSn6QH5R7WmT7yIvsM6lGHuBp/ZJ
	 a3ozr5UxIusvSUSoOPZFiswwNU18K9gqi+HxD0D6NKckOxEKmZ7OWtjzFyO7rC8aIewqX
	 aZdBS6x8jg1TgNHKyHW9LF/zNAqVD/sxzrK3cinohJyA1dT2ucdlSMOuPBItoNHULwyE2
	 bPLrdLZe46nt4yI9NnEvxKsbkn3T+WJQX9Pkdqp7j17muKdmERAqc6Umgoc6ixSPk5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z3x1xaHN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFD8606A31A;
	Wed, 28 Oct 2026 19:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=z3x1xaHN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AE4C1F01825;
	Wed, 28 Oct 2026 19:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216336;
	bh=5j5dul/e/jTOSIA8AvO323Al6iK1fym6r5/65YR7sBM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=z3x1xaHNrJAoyqi2hAaSdxEiy0xYWmk4d7rSD4V36ztd859/qMN2vEcWCeQnk32kt
	 air+SIftKElpeqrpqhlH4JqZNt6b+2RRKbyv+0sDtPqacN7YStBeDX9RNRvrHX5+sx
	 XAs/FxOLg70G9bf+fDQjQH8bfnHPgiP5R6Ssce6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bill Wendling <morbo@google.com>,
	Qing Zhao <qing.zhao@oracle.com>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Tom Rix <trix@redhat.com>,
	llvm@lists.linux.dev,
	Kees Cook <keescook@chromium.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1506/1887] Compiler Attributes: Add __counted_by macro
Date: Wed, 28 Oct 2026 18:00:02 +0100
Message-ID: <20261028170533.732273353@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

[ Upstream commit dd06e72e68bcb4070ef211be100d2896e236c8fb ]

In an effort to annotate all flexible array members with their run-time
size information, the "element_count" attribute is being introduced by
Clang[1] and GCC[2] in future releases. This annotation will provide
the CONFIG_UBSAN_BOUNDS and CONFIG_FORTIFY_SOURCE features the ability
to perform run-time bounds checking on otherwise unknown-size flexible
arrays.

Even though the attribute is under development, we can start the
annotation process in the kernel. This requires defining a macro for
it, even if we have to change the name of the actual attribute later.
Since it is likely that this attribute may change its name to "counted_by"
in the future (to better align with a future total bytes "sized_by"
attribute), name the wrapper macro "__counted_by", which also reads more
clearly (and concisely) in structure definitions.

[1] https://reviews.llvm.org/D148381
[2] https://gcc.gnu.org/bugzilla/show_bug.cgi?id=108896

Cc: Bill Wendling <morbo@google.com>
Cc: Qing Zhao <qing.zhao@oracle.com>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Tom Rix <trix@redhat.com>
Cc: llvm@lists.linux.dev
Signed-off-by: Kees Cook <keescook@chromium.org>
Reviewed-by: Gustavo A. R. Silva <gustavoars@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Acked-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://lore.kernel.org/r/20230517190841.gonna.796-kees@kernel.org
Stable-dep-of: 7e07d3e4c389 ("usb: gadget: f_midi: initialize work in f_midi_alloc()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/compiler_attributes.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index b9778e13b0a08..2ecc58fdfe4fc 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -144,6 +144,19 @@
 # define __designated_init
 #endif
 
+/*
+ * Optional: only supported since gcc >= 14
+ * Optional: only supported since clang >= 17
+ *
+ *   gcc: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=108896
+ * clang: https://reviews.llvm.org/D148381
+ */
+#if __has_attribute(__element_count__)
+# define __counted_by(member)		__attribute__((__element_count__(#member)))
+#else
+# define __counted_by(member)
+#endif
+
 /*
  * Optional: only supported since clang >= 14.0
  *
-- 
2.53.0



