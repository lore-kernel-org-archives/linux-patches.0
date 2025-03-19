Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13E131DF267;
	Wed, 19 Mar 2025 14:40:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395257; cv=none; b=l43526IoVP7u4XqcLpW5a8R65/9nC04zXQInyGR0JgWW8DFyRGGotH+uqtRLVHnOnxa8iixXlWjPuNq065N5d/jDmAYprWhNJsgjk1+3SqwxORDcZTtzWbfIn9Z3MXEbutxDZvGS4J2t70qz7iCWQjZocTc9tOWeBpWVZKPacI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395257; c=relaxed/simple;
	bh=htzoDjVyzDxsieW1PCtlUJPWd2LizVy1k2vtpR5iQYY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DsowVlo/+4fTrrSN4nAJFFz9JmG+lwK/PnC8ZAY1+ifHqW6jLKQUln/p0IaQz/8vgx1d2rdyS6OeNKzqzXC3ZX3X1KoZtiqt3JtODUnVN5m+Hbsk+8w30WHKzDL0Wlexq1voGR8DaNxkFReGXN8nuZTX+fcDb+jRA7HgiIhGrh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qGxyHazP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qGxyHazP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD047C4CEE4;
	Wed, 19 Mar 2025 14:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395257;
	bh=htzoDjVyzDxsieW1PCtlUJPWd2LizVy1k2vtpR5iQYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qGxyHazPXJ4p63irID4aZ9kpNi9CT2PyVvzSLnfzFeqH0mZmj832wupmBlOX4u1zN
	 mPUTPyaj7XFxI8JJFlBN2dyjlWFsxetY1q/rTQ+7DGLLLYkXnUO/KGGTeC8A7Re9hA
	 Xx+8ZQDlSFBHEhsfHef59ukhRyKBMxCKGOXOul4M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Alban Kurti <kurti@invicto.ai>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 140/166] rust: error: add missing newline to pr_warn! calls
Date: Wed, 19 Mar 2025 07:31:51 -0700
Message-ID: <20250319143023.812642234@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

From: Alban Kurti <kurti@invicto.ai>

[ Upstream commit 6f5c36f56d475732981dcf624e0ac0cc7c8984c8 ]

Added missing newline at the end of pr_warn! usage
so the log is not missed.

Fixes: 6551a7fe0acb ("rust: error: Add Error::from_errno{_unchecked}()")
Reported-by: Miguel Ojeda <ojeda@kernel.org>
Link: https://github.com/Rust-for-Linux/linux/issues/1139
Signed-off-by: Alban Kurti <kurti@invicto.ai>
Link: https://lore.kernel.org/r/20250206-printing_fix-v3-2-a85273b501ae@invicto.ai
[ Replaced Closes with Link since it fixes part of the issue. - Miguel ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/kernel/error.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/error.rs b/rust/kernel/error.rs
index 032b645439539..e82d31aa1f307 100644
--- a/rust/kernel/error.rs
+++ b/rust/kernel/error.rs
@@ -103,7 +103,7 @@ impl Error {
         if errno < -(bindings::MAX_ERRNO as i32) || errno >= 0 {
             // TODO: Make it a `WARN_ONCE` once available.
             crate::pr_warn!(
-                "attempted to create `Error` with out of range `errno`: {}",
+                "attempted to create `Error` with out of range `errno`: {}\n",
                 errno
             );
             return code::EINVAL;
-- 
2.39.5



