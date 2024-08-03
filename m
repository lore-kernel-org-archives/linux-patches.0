Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B3E410A0A;
	Sat,  3 Aug 2024 17:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722705599; cv=none; b=t34Gpsb86EYLZlM9IUOG0LpatUJ9kHOzbTP5npZpstWDaW/LEVZx+NsWJW3LDpFdEtlLCW+88V/+986D61GIItup/v0/Vvla0RZef/LgIuMkdVCOsBXuc/RM7qQrohIszzF9My/cGFa336CaSF9KQ4AxK9/XLiTfIDB7X8Cyfvc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722705599; c=relaxed/simple;
	bh=VfN/nZcW4JOMsSCGnmvvoyx0OMAk+JYcLvVI7PtCf1c=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cMzHVO6aMeA2eTRLJi+igXOWr4uxU4vOIZhOfTH28E68PPRkfbVeZ95VLknMf1p09cOxepNR+MI94rwSJOsou+2GegO8Hd22GxkuVCgifG0hLBqQtdfujfwmz7+qTrDzxbw5rxfLIl1hn8XBn1UwySOYVFovQR+iSxx9F9VBKlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=p0522xXP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p0522xXP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6FDAC116B1;
	Sat,  3 Aug 2024 17:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1722705598;
	bh=VfN/nZcW4JOMsSCGnmvvoyx0OMAk+JYcLvVI7PtCf1c=;
	h=From:To:Cc:Subject:Date:From;
	b=p0522xXP4CjCAPm0IvZ0FS3Qi1214nJMVkYyW4VT1XpUCSxfxBOKGjWdnG2HABBia
	 nmf8n9EtZh99xcJ3VESMyUYxnUGr/4DZKiC+jG5afZ3ZuWf1ZuQVSfw4zrqAD8fCFU
	 5Lq6lJb9ZpWxqz2n31aspXXCqzzD2l/eAnCQP/CdtMVUHkOucLNa2ft9Kr5jnCijNg
	 nMeUNTsgJAZ05bvFcO7B/3c7l8q/YcZUcRLV96icbGjFDO/lDK9aQ2n4vqFDqZIf1p
	 VgHW8M+z2HYaYZrJYZr9qLywg5TI3vBOuc+jsjpkVgFmbAEuycMY83z6XiezjcjZnk
	 omg7kllUHliPg==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	llvm@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 1/5] Compiler Attributes: update GCC and Clang's `counted_by` URLs
Date: Sat,  3 Aug 2024 19:19:29 +0200
Message-ID: <20240803171933.483316-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clang 18 was released with support for `counted_by`, thus point to the
documentation now instead of the implementation PR.

Similarly, GCC's bugzilla issue is now closed and GCC has a documentation
page for it.

Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 include/linux/compiler_attributes.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index 32284cd26d52..b658136e6cda 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -98,8 +98,8 @@
  * Optional: only supported since gcc >= 15
  * Optional: only supported since clang >= 18
  *
- *   gcc: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=108896
- * clang: https://github.com/llvm/llvm-project/pull/76348
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Variable-Attributes.html#index-counted_005fby-variable-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#counted-by
  */
 #if __has_attribute(__counted_by__)
 # define __counted_by(member)		__attribute__((__counted_by__(member)))

base-commit: 8400291e289ee6b2bf9779ff1c83a291501f017b
-- 
2.46.0

