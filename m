Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 518711A682B;
	Tue, 16 Jun 2026 15:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781623646; cv=none; b=PKTe2+F0glC0BfMw7HLe6tSJ7O2fn4qAouaJypSx5ky/akH9//DjoIAyPj86fmpz6jGvMVXQzRQHYZGhrJs3bIVNoYijJv2R2IEJXQtzE5ndGVFvxbpywBjY3ihrfLswon+1M4HTFsQ/QK8E17wbwX1Lf8PzYB+bX0QmIYDFS8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781623646; c=relaxed/simple;
	bh=9tXI9MQGL4B6qV3hjvrPMPAAXXL6d/DaxQ7MLUplzwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NHUaN8HaGBBZfTmVwrtWmD/rcAocP5XnfuL9OsHgvdc+t1MG4qxFYkaLkoG+Ci3rqqR4c9vA45UMzGU7xMzmmyffv7GN3gm/R7lh12DHH5Jfu6qLZxuZ1YkHsHfgOEDp5pwdo3mILmu+g3oSj+8nLbMXVaNSvOZkv6tuQjDLRvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jkI1sokz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jkI1sokz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B83F1F000E9;
	Tue, 16 Jun 2026 15:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781623645;
	bh=bABYLFc8yjP3jXPtaQePA0BbpEY2sYwVnZ6EnHFHncQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jkI1sokzp0SHPCscoHPgdmm52QTan7rHmoNMiqwF6CsVz6GTv+F2NHnP2k3nAw2Q1
	 yLupEChIm0aJ70VlzA1KNHogMILgJA/Dasf6q9Gts5vOqLScI3rvwYg5f1OxauNFRg
	 XSfU5DpDOMrVZdlZ/pBwByyMOjM7piIW0WKk8NiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Christian Schrefl <chrisi.schrefl@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 7.0 189/378] ARM: Do not select HAVE_RUST when KASAN is enabled
Date: Tue, 16 Jun 2026 20:27:00 +0530
Message-ID: <20260616145120.331733976@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 84a0f7caafc679f763d3868635837e22bb89651a upstream.

When KASAN is enabled, such as with allmodconfig, the build fails when
building the Rust code with:

  error: kernel-address sanitizer is not supported for this target

  error: aborting due to 1 previous error

  make[4]: *** [rust/Makefile:654: rust/core.o] Error 1

The arm-unknown-linux-gnueabi target does not support KASAN, so avoid
saying Rust is supported when it is enabled.

Cc: stable@vger.kernel.org
Fixes: ccb8ce526807 ("ARM: 9441/1: rust: Enable Rust support for ARMv7")
Link: https://github.com/Rust-for-Linux/linux/issues/1234
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Christian Schrefl <chrisi.schrefl@gmail.com>
Link: https://patch.msgid.link/20260511-arm-avoid-rust-with-kasan-v1-1-24d55f4a900b@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm/Kconfig
+++ b/arch/arm/Kconfig
@@ -135,7 +135,7 @@ config ARM
 	select MMU_GATHER_RCU_TABLE_FREE if SMP && ARM_LPAE
 	select HAVE_REGS_AND_STACK_ACCESS_API
 	select HAVE_RSEQ
-	select HAVE_RUST if CPU_LITTLE_ENDIAN && CPU_32v7
+	select HAVE_RUST if CPU_LITTLE_ENDIAN && CPU_32v7 && !KASAN
 	select HAVE_STACKPROTECTOR
 	select HAVE_SYSCALL_TRACEPOINTS
 	select HAVE_UID16


