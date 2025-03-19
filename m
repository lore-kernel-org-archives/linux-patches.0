Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6AB21CC46;
	Wed, 19 Mar 2025 14:38:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395134; cv=none; b=dRI/Akrr/gmAyLNFiRYNv+4XwHkg/XlowKCVs7muAZDxMs/Z3tTzzJvdvEztbDbahHgBWyvPbOS8+gWq57/NDEMopb+rs5tscRMWycGaQMasFBktn95Qi/ZY/3b2snOBFWsLuWVCqOkLV4wHKizkvAf4GPQpog/ux5B23OoQLPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395134; c=relaxed/simple;
	bh=yTd1HU+q4JUglJIK09xlrl7J2s4ryjrPQziGBZ98ehU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=moDmpjlJ+NQFhnfPJAAj8ggZ+4QF+oTN4cB7iAmUFbk0oW07MRVwu9FbPdZp9Hga73EPaxV/jdRLgjnbkSNuea04aJFVyyVSFhA4oIJNp/lBWKqPo7AAIp75SvhcUsvqZ4NLA9GopZwnu5jSh/jmy0b1vBjiGx2TabF6Lm5LK9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a8SLZ8Gu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a8SLZ8Gu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FDCC4CEE4;
	Wed, 19 Mar 2025 14:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395134;
	bh=yTd1HU+q4JUglJIK09xlrl7J2s4ryjrPQziGBZ98ehU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a8SLZ8GuSiAgGXsWPk4flMyMAIuHoIJ19Pwlu5ilrOUMX1uq0BiyBZHB/mq9Gos81
	 Va8uFSZWxDdeU4oGwD5wjcLdDCT/ix4FKnd4T5PUDhVQpYWDzuXN4NhANTIXyOmz7y
	 qXWLQTbONwnuLYI1+G1duXIVSFTpW950okvlPjJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Alban Kurti <kurti@invicto.ai>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 199/231] rust: error: add missing newline to pr_warn! calls
Date: Wed, 19 Mar 2025 07:31:32 -0700
Message-ID: <20250319143031.760612793@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143026.865956961@linuxfoundation.org>
References: <20250319143026.865956961@linuxfoundation.org>
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
index 5fece574ec023..4911b294bfe66 100644
--- a/rust/kernel/error.rs
+++ b/rust/kernel/error.rs
@@ -104,7 +104,7 @@ impl Error {
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



