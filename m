Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4572A2561B;
	Sat,  3 Aug 2024 17:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722705607; cv=none; b=j0Zdayos3/FbSVXegekL61OV6KYhL9mnWk051pOXh/mcQM005QeCmaW6DSipu/pcLFE7L7MHjpCbctdwLvqPtF5M3A68cBI/J+FFYKJXU9B4IZpjruAxp/2SHsbl0UWbyAXjFAdnBu8qQxqM/jvQvkUvgTb7aY1KJ9ru1msjt2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722705607; c=relaxed/simple;
	bh=Srfi3Dbl2mVsUf8lHrRzpRnCT2ZEY7fCNifbqYjiFGI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h6cpS/9MZCAcC4NA8GxJgh1iKmfd076Uuo6IVNhbx8bDqKBmTsjlx4Ai8qQeO7/hxv5IxrFvA9h8VgGCIVYsImW6Ncs6aXQPg+n8h9wKjQnF01SseE09GfELrb5wv6MF5TfNopNAygxLakGg/P5M7/RRaaEHogaPJvuck9D05Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D8yQeC6q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D8yQeC6q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B85FEC4AF09;
	Sat,  3 Aug 2024 17:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722705606;
	bh=Srfi3Dbl2mVsUf8lHrRzpRnCT2ZEY7fCNifbqYjiFGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D8yQeC6qP65UXm+VzQRtwqIxKPoqUPA/ILKYik5cwzq/y7+BriQyCBU8YLjH/OLSj
	 y0pfBg08KTYvc0emg8rE1BIspAaOyuyo4l8ADFg5g78IY7kgRL9Ism4/YIuwg6qK/y
	 3h01Oq/y+LC5KO21Ip+nWTR/ogMAhDq7XghB98w65vJxVaH59dE1A4VcxwWAXttL4h
	 LoFZOGfJp846/i3R1N+TWiWEjMRFTH+A/2X5pqaCzTMQJO2hzObXE2HQdPLWudymNC
	 Xi2ODoYW9Utznc5r9aRxdlny1ZvPCoMIPRw20TfRYT4VhY892wgcSdhxOnTPWI7AZa
	 JiWPRswcnFWfg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 4/5] Compiler Attributes: fix formatting of GCC/Clang doc links
Date: Sat,  3 Aug 2024 19:19:32 +0200
Message-ID: <20240803171933.483316-4-ojeda@kernel.org>
In-Reply-To: <20240803171933.483316-1-ojeda@kernel.org>
References: <20240803171933.483316-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Over time, some links have been added that did not follow the formatting
of the rest. Fix it for consistency.

No non-whitespace changes intended.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 include/linux/compiler_attributes.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index 2d1ad2a74a4e..a6e8c9406f7a 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -226,7 +226,7 @@
  *   goto <label>;
  *   return [expression];
  *
- *  gcc: https://gcc.gnu.org/onlinedocs/gcc/Statement-Attributes.html#Statement-Attributes
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Statement-Attributes.html#Statement-Attributes
  * clang: https://clang.llvm.org/docs/AttributeReference.html#fallthrough
  */
 #if __has_attribute(__fallthrough__)
@@ -236,7 +236,7 @@
 #endif
 
 /*
- * gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#Common-Function-Attributes
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#Common-Function-Attributes
  * clang: https://clang.llvm.org/docs/AttributeReference.html#flatten
  */
 # define __flatten			__attribute__((flatten))
@@ -264,8 +264,8 @@
 /*
  * Optional: only supported since GCC >= 7.1
  *
- *      gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-no_005fprofile_005finstrument_005ffunction-function-attribute
- *    clang: https://clang.llvm.org/docs/AttributeReference.html#no-profile-instrument-function
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-no_005fprofile_005finstrument_005ffunction-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#no-profile-instrument-function
  */
 #if __has_attribute(__no_profile_instrument_function__)
 # define __no_profile                  __attribute__((__no_profile_instrument_function__))
@@ -283,7 +283,7 @@
  * Optional: only supported since GCC >= 11.1
  *
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-no_005fstack_005fprotector-function-attribute
- *   clang: https://clang.llvm.org/docs/AttributeReference.html#no-stack-protector-safebuffers
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#no-stack-protector-safebuffers
  */
 #if __has_attribute(__no_stack_protector__)
 # define __no_stack_protector		__attribute__((__no_stack_protector__))
-- 
2.46.0

