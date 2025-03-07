Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6BC18BC36;
	Fri,  7 Mar 2025 22:50:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741387841; cv=none; b=W1CFBkm6BcBFtWEITw9kQwEOqvkjQVZJRmoe+CYgeDb5eCyCJuXgTN+ZFcrIyInUMyqIUVF9s1zIbcn0wXckhlgVTztlDtKDMuidrJ1RSjGdLQ6hct2HY8ecbp4B50jzjJGhZ4ii53luNggfrHJ90+dEGYQtsI2p69xqcTCqOCU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741387841; c=relaxed/simple;
	bh=xD0I6VzCbr7NoCGuNbqr77eCCxKd25ShZqxsW9Vtor0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NoEYWi2cHKkbCow2okxVGgVSebBoNDOyalBU63vR1FYmpCHvg8JR5uLBRBYDcNHfIJ/Wlm22vzzMlWTkSCZAnYypo1JnfhelGp6qJZpEckRrx2qfCKE0IAbnTx9R8hTCaUgI7rThdrT2tCyFHUkW0WLp4uXXcV95Y8oG9K6cDAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rrA5u83+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rrA5u83+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77A31C4CEE3;
	Fri,  7 Mar 2025 22:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741387841;
	bh=xD0I6VzCbr7NoCGuNbqr77eCCxKd25ShZqxsW9Vtor0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rrA5u83+J4DQ/ktoJBDat89HVBwjU58yxl7MILij2tPhtgD6C2n8FW9jS+mkp0p5Y
	 CI4YARd6auUyWaUNeLr8Nl5rLatx+H4CqJf/u+AN7ufdPOE96OkCz2f+XhRU+UxLcX
	 RAkZHbNvlaNOk0hkaz70MKETRo6syWYipFeEy0gxTJKJs9muGuNYskkK3h+dYtRaW/
	 tBAJ8NNBX62uHKIr/l1FC0IKmkT6ikZuqk7cqDDfoxqvXcTuYQQCwC0FEj2T+s9xZz
	 Zq/CcKM8VFwy/gkwy0yKB/WeKCLRWgQmI69IyFA75JJDKVPu+xhb5MXMrv3M4FLlu2
	 +KCfnjxjcp66A==
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
Subject: [PATCH 6.12.y 02/60] rust: sort global Rust flags
Date: Fri,  7 Mar 2025 23:49:09 +0100
Message-ID: <20250307225008.779961-3-ojeda@kernel.org>
In-Reply-To: <20250307225008.779961-1-ojeda@kernel.org>
References: <20250307225008.779961-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

commit a135aa3d30d28f26eb28a0ff5d48b387b0e0755f upstream.

Sort the global Rust flags so that it is easier to follow along when we
have more, like this patch series does.

Reviewed-by: Trevor Gross <tmgross@umich.edu>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Tested-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Gary Guo <gary@garyguo.net>
Link: https://lore.kernel.org/r/20240904204347.168520-3-ojeda@kernel.org
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Makefile | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Makefile b/Makefile
index 17dfe0a8ca8f..6fbdb2e8ffff 100644
--- a/Makefile
+++ b/Makefile
@@ -446,19 +446,19 @@ KBUILD_USERLDFLAGS := $(USERLDFLAGS)
 export rust_common_flags := --edition=2021 \
 			    -Zbinary_dep_depinfo=y \
 			    -Astable_features \
-			    -Dunsafe_op_in_unsafe_fn \
 			    -Dnon_ascii_idents \
+			    -Dunsafe_op_in_unsafe_fn \
+			    -Wmissing_docs \
 			    -Wrust_2018_idioms \
 			    -Wunreachable_pub \
-			    -Wmissing_docs \
-			    -Wrustdoc::missing_crate_level_docs \
 			    -Wclippy::all \
+			    -Wclippy::dbg_macro \
 			    -Wclippy::mut_mut \
 			    -Wclippy::needless_bitwise_bool \
 			    -Wclippy::needless_continue \
 			    -Aclippy::needless_lifetimes \
 			    -Wclippy::no_mangle_with_rust_abi \
-			    -Wclippy::dbg_macro
+			    -Wrustdoc::missing_crate_level_docs
 
 KBUILD_HOSTCFLAGS   := $(KBUILD_USERHOSTCFLAGS) $(HOST_LFS_CFLAGS) \
 		       $(HOSTCFLAGS) -I $(srctree)/scripts/include
-- 
2.48.1

