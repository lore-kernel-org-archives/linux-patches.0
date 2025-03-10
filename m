Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24CAF22154C;
	Mon, 10 Mar 2025 17:19:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627165; cv=none; b=lLvE95c2a8QPGLmrRzuec+3wMABLUBkHV5zZWT6z/6BYsjv2EdNJ1MtHqZNy3q8SlfwPiB8FhNqYCNCu4vvCOeLrZRrb80/DOtJcwmW3UhecPVxItd74sQY5TgjkxOl08xqsgj8lsc5RyYjrqc9ADbLoWMFvGMObHHPLLjg1oVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627165; c=relaxed/simple;
	bh=HCwRmZudjIoIDH5UKn8V9JYr/j/G7Cml/SRdqavsCbA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UL2WRV3PdI9hH+g5JgZSQhqHXg/m/SZWtFBarYt+Z+kbmSoT/9Pul9AHREbLmCVHiI9kgIgFqe5OQpPdhUwHE+oUd/v0SyMzPICZDQvhEt4MOgg5Df2Yz+llCN7OMAdndZgOGAsnJnVr3n/rAcGj2w1W9qS4jFWAFH+aLotv38U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iVw1U3GE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iVw1U3GE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97324C4CEE5;
	Mon, 10 Mar 2025 17:19:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627165;
	bh=HCwRmZudjIoIDH5UKn8V9JYr/j/G7Cml/SRdqavsCbA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iVw1U3GEuko6NNwcvOBFGvH8Mh3YB5oVnB/ZG7w9IhzRu8CxymIX4E0I6ROAXa32R
	 V2B6rvT1sZI46+h0ZqlC7sBV6u92V9TkXfaDzN8yTseN08qgz463nKLU9Epc2qP8hA
	 BRvKL5CrBrBKwCkjjELEdjHru4Fz0uwK8O7f8Tuw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benno Lossin <benno.lossin@proton.me>,
	Gary Guo <gary@garyguo.net>,
	Danilo Krummrich <dakr@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.12 035/269] rust: alloc: make `allocator` module public
Date: Mon, 10 Mar 2025 18:03:08 +0100
Message-ID: <20250310170459.117251389@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/alloc.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/kernel/alloc.rs
+++ b/rust/kernel/alloc.rs
@@ -4,7 +4,7 @@
 
 #[cfg(not(test))]
 #[cfg(not(testlib))]
-mod allocator;
+pub mod allocator;
 pub mod box_ext;
 pub mod vec_ext;
 


