Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3717F25DD1E;
	Mon, 29 Dec 2025 16:24:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025469; cv=none; b=b+DibvumvtCwsx7HuiCgJ31b+DwJsgJX2nvPB5Wud9hu8rdjtSfr69/j+bo/mwgQHcJk6LsWPbkAcyaEN4xC4qoEk+EJuxVkoixkgayD7Xe7rJSm0fQpG55Yrv9YJ/fhP5Tp2jF2jXg2p/NN4XcVfXEQXVUzUYP5EZ9Dm7DDSaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025469; c=relaxed/simple;
	bh=a4r8mYPlw9zuwh6lXTjeWbKjizptse7b2/6zpK0DKqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QOhNEakeFTcEy6gFlyNHIPIrXeY4LMid54NSjerJlGU8SJEP9BWlhTHS2WlmZ4ZMCmbT33m9tFB8zfQWGdk15SMLUAw4qZWWXztciNjSIpikrYvPQfQc3DDcVqPDrEbewriZbayaA5myQjFNwVSiJYV4Jgb5hz+MXzIh0YDeORU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RnE4tICr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RnE4tICr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80F7AC4CEF7;
	Mon, 29 Dec 2025 16:24:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025468;
	bh=a4r8mYPlw9zuwh6lXTjeWbKjizptse7b2/6zpK0DKqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RnE4tICr8axItpJFiT4oWkgKbaSzHhZJg1azo0NFAdngvCDusa5d+k5JF7qSupWp9
	 s/Sn0kE0+XH76ZY+W4QpcJZjWtdP2uUdwlTRSGHh20npZIwSkfG0XAoF2zqxYzOIs7
	 304gGGwBnaniBeKRx/Tc+9kX588A/81xXGnioe6w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>
Subject: [PATCH 6.18 224/430] rust: io: define ResourceSize as resource_size_t
Date: Mon, 29 Dec 2025 17:10:26 +0100
Message-ID: <20251229160732.595222432@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alice Ryhl <aliceryhl@google.com>

commit 919b72922717e396be9435c83916b9969505bd23 upstream.

These typedefs are always equivalent so this should not change anything,
but the code makes a lot more sense like this.

Cc: stable@vger.kernel.org
Signed-off-by: Alice Ryhl <aliceryhl@google.com>
Fixes: 493fc33ec252 ("rust: io: add resource abstraction")
Link: https://patch.msgid.link/20251112-resource-phys-typedefs-v2-1-538307384f82@google.com
Signed-off-by: Danilo Krummrich <dakr@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/io/resource.rs |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/rust/kernel/io/resource.rs
+++ b/rust/kernel/io/resource.rs
@@ -16,7 +16,7 @@ use crate::types::Opaque;
 ///
 /// This is a type alias to either `u32` or `u64` depending on the config option
 /// `CONFIG_PHYS_ADDR_T_64BIT`, and it can be a u64 even on 32-bit architectures.
-pub type ResourceSize = bindings::phys_addr_t;
+pub type ResourceSize = bindings::resource_size_t;
 
 /// A region allocated from a parent [`Resource`].
 ///


