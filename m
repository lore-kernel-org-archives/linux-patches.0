Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5547D646;
	Tue,  3 Dec 2024 15:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239094; cv=none; b=Xa4uuILPIONRHOpP+3pyq5wXkS8cO+2v5tqoH2ejqfoc5PxG2GRik/lVbWGUWnafu9aartTa8+CNPb+Gc5PoCZMpmzsDxypIrAVGdt406cqoHEb74X59aRu7OsT8BpYChPtRYx/GY0bGLvKfCIllqFKJNefpL8FVJIQw9w4vqS8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239094; c=relaxed/simple;
	bh=dTXl4ySEKhv+FUaq3unsfnhTvv4CyLbUVjiJz4lnA+8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=unoubwoPWh4YAxfOukgDydLUZWMUmendEOpQfOebRnthmkPAhQLXT/cRNyvrXKs8dOl9tx93QxBxVZPRaA0HPqe6USFPtqUIlvoX7i5Z3hOYVRvQP+HTk6OA4O7GcnciDySM7hbZbj80Z4WGnLy9fDs/+RlKE2qOJFbKDlKXhOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=keKsoHlC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="keKsoHlC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2358C4CECF;
	Tue,  3 Dec 2024 15:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239094;
	bh=dTXl4ySEKhv+FUaq3unsfnhTvv4CyLbUVjiJz4lnA+8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=keKsoHlCchXtIJYU3YuDxf/nVEcmpl3s6uj+U4gvaykN1n+EFarG2wqR2bihpvWX2
	 b91mRkgy+BNLJjeSN9NxLrmWKNaHnhGtpLVAYzvm8qcPSyi8uoToygvaAuiMt2jDGB
	 THxuJnZ+xJmEIAU4PBxvQnLb5cOOwOXE/WMc16nA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paolo Bonzini <pbonzini@redhat.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 500/817] rust: macros: fix documentation of the paste! macro
Date: Tue,  3 Dec 2024 15:41:12 +0100
Message-ID: <20241203144015.391925025@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paolo Bonzini <pbonzini@redhat.com>

[ Upstream commit 15541c9263ce34ff95a06bc68f45d9bc5c990bcd ]

One of the example in this section uses a curious mix of the constant
and function declaration syntaxes; fix it.

Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Fixes: 823d4737d4c2 ("rust: macros: add `paste!` proc macro")
Link: https://lore.kernel.org/r/20241019072208.1016707-1-pbonzini@redhat.com
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 rust/macros/lib.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/macros/lib.rs b/rust/macros/lib.rs
index 5be0cb9db3ee4..8a2ed9472bb08 100644
--- a/rust/macros/lib.rs
+++ b/rust/macros/lib.rs
@@ -355,7 +355,7 @@ pub fn pinned_drop(args: TokenStream, input: TokenStream) -> TokenStream {
 /// macro_rules! pub_no_prefix {
 ///     ($prefix:ident, $($newname:ident),+) => {
 ///         kernel::macros::paste! {
-///             $(pub(crate) const fn [<$newname:lower:span>]: u32 = [<$prefix $newname:span>];)+
+///             $(pub(crate) const fn [<$newname:lower:span>]() -> u32 { [<$prefix $newname:span>] })+
 ///         }
 ///     };
 /// }
-- 
2.43.0



