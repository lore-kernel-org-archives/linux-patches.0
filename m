Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA2F329D26D;
	Fri,  3 Oct 2025 16:08:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759507732; cv=none; b=O3mEk/t5tK76I+1Yv7OuQAn4YBL0HYRAwTOGses6KOZcWl9HnHciSklS7kgHTcLKc0R92pg5kZDPT1mBLja16dVUjYS3ebHAmqPRcy7yuAhieQ79tMzWxgJ+d4eFrV8EYOLMJLBNjGdk1+2Icmv0m0VAqSZ/kFOSx5wLYy1lihk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759507732; c=relaxed/simple;
	bh=xjiBEv/oYxnNnwDix3sU2uhNEedC0fh9J7O8rxbElmU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VXCad6qhOdkZqz4u6l8gN5xrOUIx0ejpDvAF/YUbCrRkhlp2k6lYE25tsAhJ2453j+O8EOrWuISCCv9iy8dfuyqS7mblw9Jmxux6NQeGVMLIWCC9OY01C6mJMStsTjLoiQAGpB5Y3gsZMkjFgzM0zPdhgHwQdG+MNeHbtIXkONI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MPRFpuFY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MPRFpuFY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD10C4CEF5;
	Fri,  3 Oct 2025 16:08:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759507732;
	bh=xjiBEv/oYxnNnwDix3sU2uhNEedC0fh9J7O8rxbElmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MPRFpuFYFEiC10iWaPnQbCjUxnboart2Jw9GULj8AnegkvsrCZFb/1pLCqiXyC7cV
	 mXqsVeIdoeZ9wFZwuwRji37zL6CZ6CVrWRaknGZg9Jy/XEAFM5al9rF2ParCj1TeOZ
	 7+o53e+z6c0q7uqnDoRtKSM2qS4LVmCY8vhB3G8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Fore <csfore@posteo.net>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 6.6 2/7] gcc-plugins: Remove TODO_verify_il for GCC >= 16
Date: Fri,  3 Oct 2025 18:06:10 +0200
Message-ID: <20251003160331.562053807@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251003160331.487313415@linuxfoundation.org>
References: <20251003160331.487313415@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kees Cook <kees@kernel.org>

commit a40282dd3c484e6c882e93f4680e0a3ef3814453 upstream.

GCC now runs TODO_verify_il automatically[1], so it is no longer exposed to
plugins. Only use the flag on GCC < 16.

Link: https://gcc.gnu.org/git/?p=gcc.git;a=commit;h=9739ae9384dd7cd3bb1c7683d6b80b7a9116eaf8 [1]
Suggested-by: Christopher Fore <csfore@posteo.net>
Link: https://lore.kernel.org/r/20250920234519.work.915-kees@kernel.org
Signed-off-by: Kees Cook <kees@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 scripts/gcc-plugins/gcc-common.h |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/scripts/gcc-plugins/gcc-common.h
+++ b/scripts/gcc-plugins/gcc-common.h
@@ -196,10 +196,17 @@ inline bool is_a_helper<const gassign *>
 }
 #endif
 
+#if BUILDING_GCC_VERSION < 16000
 #define TODO_verify_ssa TODO_verify_il
 #define TODO_verify_flow TODO_verify_il
 #define TODO_verify_stmts TODO_verify_il
 #define TODO_verify_rtl_sharing TODO_verify_il
+#else
+#define TODO_verify_ssa 0
+#define TODO_verify_flow 0
+#define TODO_verify_stmts 0
+#define TODO_verify_rtl_sharing 0
+#endif
 
 #define INSN_DELETED_P(insn) (insn)->deleted()
 


