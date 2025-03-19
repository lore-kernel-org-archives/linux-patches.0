Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDEB41DDA36;
	Wed, 19 Mar 2025 14:36:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742394972; cv=none; b=DtIcqevAnhxQEkcSVQpelkoMdr22gaLizZ3I/cRcqiJbNbm4+EmZ3/64YFv3S3wvTryPdkO0T7YV217XZzL2O0adrW1ZgvWjZpMy0LHp09fXLQYiRWAnT7/PwpXczM/r1/GrxOyMyZGw5b1k42F01GS1+uy1Jxp3NvtI7xPGuhQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742394972; c=relaxed/simple;
	bh=XZgxHZv4yPo1SUB9pIayEgyWWSQJ9NQYkHm24x+wYjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RLm2Uyg5RAwz0DwgDnSBtL/rewAWR8vIFHex87Ou/T2KCkf5YxOQ5TOddmIaXbzynMosGiO5g1NRulXUA+7BlC0z9jxqw3aDQnbuTERd+mvQzIdENzKlglI0x4ypqzNJJVBw/iTMrjv3OJSsEpScoZnpb2GpqNjIZ5fe+FEufnc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PIjB0SeM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PIjB0SeM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1460C4CEE4;
	Wed, 19 Mar 2025 14:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742394971;
	bh=XZgxHZv4yPo1SUB9pIayEgyWWSQJ9NQYkHm24x+wYjg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PIjB0SeM+Mi+1a6SprkckRJi8l11HUbgcJgQ6UZA9747vSDIU42SL09FSBL92d+9Y
	 LqL9gc4qnVBGREKHi69BDwjFQnK6c0SRkw3dloBe9hwP5rVAXAh1mVlH+uyvjEVWAU
	 Pi+TVo+YDoAtcRAWVuCtyAzTbDmD0fS0vOFOaduM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>,
	Alban Kurti <kurti@invicto.ai>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 207/241] rust: error: add missing newline to pr_warn! calls
Date: Wed, 19 Mar 2025 07:31:17 -0700
Message-ID: <20250319143032.864618407@linuxfoundation.org>
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



