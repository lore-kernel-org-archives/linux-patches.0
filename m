Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E584315A;
	Sun,  7 Sep 2025 20:41:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757277720; cv=none; b=KrEXe/RomLDEvuuDPE4RoUsQHRxz008Y1hQeUICrDV6Ywt/H18gMBKfNGC+rRj7lcR7wYSkldE7E0ohm1YREsoNJSi7yu3vPl68V1jMr5D3ms2Ne7Oct4Gi1dK1EkGEzgHFhUKGjrJJntyDiR93Sg5ZjTDxlOVUuw+5KR0LG7X8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757277720; c=relaxed/simple;
	bh=pF643DOCiEoKJKzd9RQnWeXbaUUMlwBArZuFd1pkOTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ctLSJR5gAPwUAeZD+Ghxx27N77/7PYeNZxB+1k720xx8+rwFwwtEermuORX7T2voI9AV9yuZDu1e/La78ObpNuCBQ/fZi1uSDkaECzt5FlelsRPcFttFruH79IHgqr6y21xDGpsYDuTEO8c4SHNlRvRi0FxV1XzI0QkbL6UCWLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KHCQDJDk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KHCQDJDk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1271BC4CEF0;
	Sun,  7 Sep 2025 20:41:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757277719;
	bh=pF643DOCiEoKJKzd9RQnWeXbaUUMlwBArZuFd1pkOTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KHCQDJDkjTLeyErMunQQ/H9vjMZBnp6A/evTi3zzQpcovCLUyfogs5/ufEf6J5JbV
	 SP/jnpbsAp7WVYi92eE8fygz1B7wgyqQcSVrlCwEgagxv5sAD4h3S+JzCtBYrkYZbi
	 dfA5YRcwYqUINR6uyAEKcxkOLaOQrOo+FzC9Sa6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baptiste Lepers <baptiste.lepers@gmail.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	Jann Horn <jannh@google.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.16 101/183] rust: mm: mark VmaNew as transparent
Date: Sun,  7 Sep 2025 21:58:48 +0200
Message-ID: <20250907195618.188970932@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250907195615.802693401@linuxfoundation.org>
References: <20250907195615.802693401@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Baptiste Lepers <baptiste.lepers@gmail.com>

commit 5cc5e030bce2ec97ae5cdb2c1b94a98b1047b3fa upstream.

Unsafe code in VmaNew's methods assumes that the type has the same layout
as the inner `bindings::vm_area_struct`.  This is not guaranteed by the
default struct representation in Rust, but requires specifying the
`transparent` representation.

Link: https://lkml.kernel.org/r/20250812132712.61007-1-baptiste.lepers@gmail.com
Fixes: dcb81aeab406 ("mm: rust: add VmaNew for f_ops->mmap()")
Signed-off-by: Baptiste Lepers <baptiste.lepers@gmail.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Cc: Alex Gaynor <alex.gaynor@gmail.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Björn Roy Baron <bjorn3_gh@protonmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Danilo Krummrich <dakr@kernel.org>
Cc: Gary Guo <gary@garyguo.net>
Cc: Jann Horn <jannh@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Trevor Gross <tmgross@umich.edu>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/mm/virt.rs | 1 +
 1 file changed, 1 insertion(+)

diff --git a/rust/kernel/mm/virt.rs b/rust/kernel/mm/virt.rs
index 6086ca981b06..a1bfa4e19293 100644
--- a/rust/kernel/mm/virt.rs
+++ b/rust/kernel/mm/virt.rs
@@ -209,6 +209,7 @@ pub fn vm_insert_page(&self, address: usize, page: &Page) -> Result {
 ///
 /// For the duration of 'a, the referenced vma must be undergoing initialization in an
 /// `f_ops->mmap()` hook.
+#[repr(transparent)]
 pub struct VmaNew {
     vma: VmaRef,
 }
-- 
2.51.0



