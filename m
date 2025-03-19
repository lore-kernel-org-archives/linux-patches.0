Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DAED1C8618;
	Wed, 19 Mar 2025 14:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394982; cv=none; b=OaG8n3xJw2cIvmRGs/dlkt+vrAZl2cU9HBPaxL+UswhJcKGbUMwWjpo0GcUz4/kNvhj2uQscXw/TOBffBfJ9/T0HwIicYoAFAyF89VK9Qyx/0S91pUfdY2XN3JCVZcxvFj1vZwMDiexNUc+8Snmz5Z1djirmn97pP9OGTbgHmao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394982; c=relaxed/simple;
	bh=rcNYgkHa0Wq97Mul8M7SrC0yxXSthTTxn1eBk+fsdFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ouz9xrS4OqLppxJCWF8SpvANdTkGnP5jjK/cvVlR6UBXNedRWR+AoBu20nROX4zSbycvghtCTkQfQcQGRilwys4hQyL8jNs7sxTzjjsp/2mwFw/5uEh34EuTRxL0abQCHi6xhQlhgnPGpk6USOsSSv0rQm6YTD9CGkgZi3ujlfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vvVosp8R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vvVosp8R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7C16C4CEE4;
	Wed, 19 Mar 2025 14:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394982;
	bh=rcNYgkHa0Wq97Mul8M7SrC0yxXSthTTxn1eBk+fsdFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vvVosp8REH5/vgfdxu2iFuTuzObYtVxWs2LdFnNpk3BsV1aOMIZZuiDUoCYXLx1x2
	 MOnQYwYN/v8e6CmkmN1RZew3EYtAj0EP+ZfNT4Ghn5+xD0H0R2/sXfdUT2hsUtnnzj
	 B1yk66IN2xZlUwJW79BFeeJXTquvleM4pMSY1oqE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tamir Duberstein <tamird@gmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 221/241] scripts: generate_rust_analyzer: add uapi crate
Date: Wed, 19 Mar 2025 07:31:31 -0700
Message-ID: <20250319143033.215636553@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
References: <20250319143027.685727358@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tamir Duberstein <tamird@gmail.com>

[ Upstream commit a1eb95d6b5f4cf5cc7b081e85e374d1dd98a213b ]

Commit 4e1746656839 ("rust: uapi: Add UAPI crate") did not update
rust-analyzer to include the new crate.

Add the missing definition to improve the developer experience.

Fixes: 4e1746656839 ("rust: uapi: Add UAPI crate")
Signed-off-by: Tamir Duberstein <tamird@gmail.com>
Tested-by: Andreas Hindborg <a.hindborg@kernel.org>
Link: https://lore.kernel.org/r/20250210-rust-analyzer-bindings-include-v2-2-23dff845edc3@gmail.com
[ Slightly reworded title. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 scripts/generate_rust_analyzer.py | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/scripts/generate_rust_analyzer.py b/scripts/generate_rust_analyzer.py
index 2a64067b09b0c..d1f5adbf33f91 100755
--- a/scripts/generate_rust_analyzer.py
+++ b/scripts/generate_rust_analyzer.py
@@ -110,7 +110,8 @@ def generate_crates(srctree, objtree, sysroot_src, external_src, cfgs):
         }
 
     append_crate_with_generated("bindings", ["core"])
-    append_crate_with_generated("kernel", ["core", "macros", "build_error", "bindings"])
+    append_crate_with_generated("uapi", ["core"])
+    append_crate_with_generated("kernel", ["core", "macros", "build_error", "bindings", "uapi"])
 
     def is_root_crate(build_file, target):
         try:
-- 
2.39.5



