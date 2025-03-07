Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97CCD18BC36;
	Fri,  7 Mar 2025 22:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387901; cv=none; b=KOZmx/pj/KVpgfRiuU7o5CHCqhjds02yZlJ56LxLGalvTUsE0QhDUAQkYjKT8vWg4ZLHKw/PQYU8e9zdjPvN/E/Z6n1I1C1OlTfBgkYoKM4zoZafIVWf4Sq71tGvQCv9+MMnj5YFQWLK3fzDs/ci3rgTd60kRLBGf7XA2hvg2rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387901; c=relaxed/simple;
	bh=mEgUDXcuZiRypS8vloGZU6p/Dz1tWQZR0IxYDUQysOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O+UDqi7m9u8gaqNm/5EFT/c2mWXMTAF9D1BFd4U0m0X9vVTBlHPwr7U9evsaB34TgzTpNiGZTEMh7xLzMi7qiXk+RoLZ3M5O2D+9T6py2U3JnU/RQoscm6Yr4ShLKJA3+Zn9IoDnsHKli1ulOSSHHNG6ZVkul2vvFmb7c+ck5io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gQpbYfL+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gQpbYfL+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5821EC4CEE9;
	Fri,  7 Mar 2025 22:51:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387901;
	bh=mEgUDXcuZiRypS8vloGZU6p/Dz1tWQZR0IxYDUQysOE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gQpbYfL+NVDZoaAVbrO6yffosVlnWd88v8VvdbKMee3T4Ka+nPCa41JHlEV2VdCHr
	 7fOxi8Llm4PzGS0ZsNemeFvqwZl4e3EkWZkE0Qpo6mbuhXpQlCS3iGF0GgiYr8VA3C
	 fzzTk/BVsXPODnxjSAxRAq0bLBgUPRw+zqqjFzSEQxgBX4k1knB65Yv+a0zazjZL1x
	 /oy6hIKHDqZThi39+sG1kXVPSMZXkXc7GwTrKvPqoOLruAskDGK5iMzfqcry5RbX4E
	 BzTUbZCvBYLzK7cdyvDT0gp+McMggKkzbdQ0NA943kdkHT4g6+Py2QR2oigBcjuRv6
	 ysdpDOyJlfSyw==
From: Miguel Ojeda <ojeda@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org
Cc: Danilo Krummrich <dakr@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Alyssa Ross <hi@alyssa.is>,
	NoisyCoil <noisycoil@disroot.org>,
	patches@lists.linux.dev,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12.y 24/60] rust: alloc: make `allocator` module public
Date: Fri,  7 Mar 2025 23:49:31 +0100
Message-ID: <20250307225008.779961-25-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Danilo Krummrich <dakr@kernel.org>

commit a87a36f0bf517dae22f3e3790b05c979070f776a upstream.

Subsequent patches implement allocators such as `Kmalloc`, `Vmalloc`,
`KVmalloc`; we need them to be available outside of the kernel crate as
well.

Reviewed-by: Benno Lossin <benno.lossin@proton.me>
Reviewed-by: Gary Guo <gary@garyguo.net>
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Link: https://lore.kernel.org/r/20241004154149.93856-6-dakr@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/alloc.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/alloc.rs b/rust/kernel/alloc.rs
index 95d402feb6ff..2203852c3712 100644
--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -4,7 +4,7 @@
 
 #[cfg(not(test))]
 #[cfg(not(testlib))]
-mod allocator;
+pub mod allocator;
 pub mod box_ext;
 pub mod vec_ext;
 
-- 
2.48.1

