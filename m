Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FF320D503;
	Fri,  7 Mar 2025 22:50:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387853; cv=none; b=YvX+uTwVm31JLvuMf3mjiAxZzF7/OkyCLoH4WzpVu1SseYu3rxciMtlk+AOOD8vXKNdQI9+REe50ay8DPWtH8EbfcMwg9DwsA+8xBZnqiFFEYd4s3UPLCDikE4L5CBI5ee7a0RZjzx6EdCZr+yxiUf9SSL6cBZvL6M+c6Z+nZjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387853; c=relaxed/simple;
	bh=elAMw0skEjEp+PWEkndtiJ/F0vgmlxmwaXcdBwn/aT0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMJxd9AmB+9MZRzCVWAOjS6+2mNL/MhImA3gU9SlJrzEij43kEN4MOSjCAkGjI0EJo8NpKvQVLdZl9Qzek84Pyota6e/U7mAQ/1nxUe1sgYlhvFgb99vAC9iJZTDyo6I31aF8LGi42MyI8rr+ClRqzwH4lqhApKLR1fgylbM0zM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Utj2wFWD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Utj2wFWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74B3AC4CEE5;
	Fri,  7 Mar 2025 22:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387852;
	bh=elAMw0skEjEp+PWEkndtiJ/F0vgmlxmwaXcdBwn/aT0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Utj2wFWDogU9Oxd/BNiScXWkLwBSju6dFEe0W4son8pUf3ndNhLALH9Nk1AnxWSAe
	 M8240DIuBk5+p5p8cF6QdXoBclgWbvWWrY61lWSt2XZOh1FPpBRDTjUoKU+2MrQVFl
	 k4DHcCRcRsURErPBNX8uPUTRPFGNkaVByuTt95S0qJPwniOMdi6nETNbS0RK1v2lez
	 cdnFWUjO6KJE6FIhnJimecX4eFD9qINv/PHXhLq3ZuqMYfv6lfu2v4YnXU6azw95s4
	 libqUMs9pHJPOf44LG4NraNlpdPvlm3ZQQl9j9x9uQcICrPpTvD3E8jBMu0OnxW1r2
	 FS39JlY9vTyWw==
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
Subject: [PATCH 6.12.y 06/60] rust: enable `clippy::unnecessary_safety_doc` lint
Date: Fri,  7 Mar 2025 23:49:13 +0100
Message-ID: <20250307225008.779961-7-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit 23f42dc054b3c550373eae0c9ae97f1ce1501e0a upstream.

In Rust 1.67.0, Clippy added the `unnecessary_safety_doc` lint [1],
which is similar to `unnecessary_safety_comment`, but for `# Safety`
sections, i.e. safety preconditions in the documentation.

This is something that should not happen with our coding guidelines in
mind. Thus enable the lint to have it machine-checked.

Link: https://rust-lang.github.io/rust-clippy/master/index.html#/unnecessary_safety_doc [1]
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-7-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/Makefile b/Makefile
index 295d52b677f8..13d8aa4a41d3 100644
--- a/Makefile
+++ b/Makefile
@@ -460,6 +460,7 @@ export rust_common_flags := --edition=2021 \
 			    -Wclippy::no_mangle_with_rust_abi \
 			    -Wclippy::undocumented_unsafe_blocks \
 			    -Wclippy::unnecessary_safety_comment \
+			    -Wclippy::unnecessary_safety_doc \
 			    -Wrustdoc::missing_crate_level_docs
 
 KBUILD_HOSTCFLAGS   := $(KBUILD_USERHOSTCFLAGS) $(HOST_LFS_CFLAGS) \
-- 
2.48.1

