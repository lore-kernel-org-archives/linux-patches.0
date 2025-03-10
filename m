Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88F4422D799;
	Mon, 10 Mar 2025 17:19:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627191; cv=none; b=Xu/h/gUthExklVrTj+V+dkwDqnvbTKDRPaa5TsJXXHfVpL232UtEi6bNFIcVzQbMcpCU61Uoi7sAL154bpx9VVD8bL07PqVtizOxSf00ofFNSGQViJo3HrtxogqjEbC2INnWgRiIS5HkJNdqos/PQptbv/cjEKh4y78udpBTyFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627191; c=relaxed/simple;
	bh=qOV7px6G1ISugbHd1R5zc10Jc+n3SrY2zrzPDmV21Bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h428C6dRN2lDT+BHmzJvQw6dqvW19+RlRJgdGzDJJHxhG+Xdb5E3ZCmfK/KWyPKkZcoqaLMsjH6K6EiJPjfBi3Y/EqaY39lmCiEGDu3nZL3YgNwy3O2mZrWVBL0Tikzb7AsSqAl7jLwqb0BJZYfguW/WrWfLPJSH/HEwOi0w/BU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EHsfBEgL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EHsfBEgL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97DD7C4CEE5;
	Mon, 10 Mar 2025 17:19:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627191;
	bh=qOV7px6G1ISugbHd1R5zc10Jc+n3SrY2zrzPDmV21Bc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EHsfBEgL073ZQftcB5IsyFc1LgRfopeZlVLAQe9ifglbGshFBsJql7oyxiQX+vY4Z
	 r9xzZ0b/FSOQzIgh5Bflfd+G8uwYe/yAFJ48nqqAu6bokRhLP7X7nrpvLPk2aaLXTJ
	 gECbVN7Ax5UZbmvK6y011enhbf5Ly+Kr5A1er/Vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trevor Gross <tmgross@umich.edu>,
	Alice Ryhl <aliceryhl@google.com>,
	Gary Guo <gary@garyguo.net>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 013/269] rust: sort global Rust flags
Date: Mon, 10 Mar 2025 18:02:46 +0100
Message-ID: <20250310170458.234035307@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miguel Ojeda <ojeda@kernel.org>

commit a135aa3d30d28f26eb28a0ff5d48b387b0e0755f upstream.

Sort the global Rust flags so that it is easier to follow along when we
have more, like this patch series does.

Reviewed-by: Trevor Gross <tmgross@umich.edu>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-3-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -446,19 +446,19 @@ KBUILD_USERLDFLAGS := $(USERLDFLAGS)
 export rust_common_flags := --edition=2021 \
 			    -Zbinary_dep_depinfo=y \
 			    -Astable_features \
-			    -Dunsafe_op_in_unsafe_fn \
 			    -Dnon_ascii_idents \
+			    -Dunsafe_op_in_unsafe_fn \
+			    -Wmissing_docs \
 			    -Wrust_2018_idioms \
 			    -Wunreachable_pub \
-			    -Wmissing_docs \
-			    -Wrustdoc::missing_crate_level_docs \
 			    -Wclippy::all \
+			    -Wclippy::dbg_macro \
 			    -Wclippy::mut_mut \
 			    -Wclippy::needless_bitwise_bool \
 			    -Wclippy::needless_continue \
 			    -Aclippy::needless_lifetimes \
 			    -Wclippy::no_mangle_with_rust_abi \
-			    -Wclippy::dbg_macro
+			    -Wrustdoc::missing_crate_level_docs
 
 KBUILD_HOSTCFLAGS   := $(KBUILD_USERHOSTCFLAGS) $(HOST_LFS_CFLAGS) \
 		       $(HOSTCFLAGS) -I $(srctree)/scripts/include


