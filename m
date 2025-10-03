Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A298292B4B;
	Fri,  3 Oct 2025 16:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759507614; cv=none; b=NTsRdj0+3jcKrKfxPxMXG86Lj5slPUetuSDX3ycp+p+Q3AO+YHD7aX62AMdvYOqXrLxqGPvr9ncwJ2VgsT8hlb3O8ICW1FHvfTljwQge2qDxN8Pu9kN0UBalEZf0IjH+sO7U1unVk/pe/J8SzFzGBpTMaFJj6bQKsOS0F/dVH6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759507614; c=relaxed/simple;
	bh=jKvewCb70Lke/L+XfB+boYOWi1BcLyNSo6IWUbC1bAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gBbUpoUIDN/tFmX4V/EJ/wkdAK27tQGsh5ya96k6s/s8PEq349Avst5bL6Veiwt9eLrkpT9bS1zsTn9n/3djiO9Cy4fl57krI2kh0Cv2gULn5ZyRPExC96T7ITkmL3ln7lOxC0A9ygjT3t+mfGp/3F+0MSSpHuXNn70ViTGsvvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iN6MCgKr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iN6MCgKr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC5BC4CEF5;
	Fri,  3 Oct 2025 16:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759507614;
	bh=jKvewCb70Lke/L+XfB+boYOWi1BcLyNSo6IWUbC1bAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iN6MCgKrrAPJTl2DLCv7xlzvvK9xG5B0is4XoZ6jbUmvo1Uv+6MO1H42S6PlnrZMo
	 xrtUZ9+cK4yy7P4vRVOSELSL1RgPJOfBb47lcPbqXz9IKuZQsKIz4u+NNmwpXDblYU
	 u/DgU5ZLWvW/Nrw9AuNzAYOoTxicbEE4LufCrcIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Fore <csfore@posteo.net>,
	Kees Cook <kees@kernel.org>
Subject: [PATCH 6.17 02/15] gcc-plugins: Remove TODO_verify_il for GCC >= 16
Date: Fri,  3 Oct 2025 18:05:26 +0200
Message-ID: <20251003160359.942543976@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251003160359.831046052@linuxfoundation.org>
References: <20251003160359.831046052@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -173,10 +173,17 @@ static inline opt_pass *get_pass_for_id(
 	return g->get_passes()->get_pass_for_id(id);
 }
 
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
 


