Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52CC212D77C;
	Tue, 30 Apr 2024 11:12:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475532; cv=none; b=QDRBRZrPNtX6HJ3H7OXAlJU/s3dDZn4GOyhEyXDnfa9MnOUdwDqP+JgBb5DQyHy4n1KWjZqcD9dsCSa6VbNy8mEw6mcyrLhkfFdRElI+HN7a4LmT1PEBusfxWN+yv5JGFeb+rLY3T1aCKtrHs6FcOkt3cFUWjk65N6Oxp3F1i54=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475532; c=relaxed/simple;
	bh=Ckuv/WcTnFhJEBA/yTyZSVkqw9grPUtNY188TKbjwrM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prXtDbpiAmVNvGZ4DinfKyJDAcv099Bnbfggy9QqvXEqlZRlmYwr5W2Z0G6SoSoCDauExtX+bIoD+IzMByghSE/NVNMynQYNIC1y4LS58BYF5/2sxaSQA6KE83pq9FHQNsglZW6kFQPlkKExjGHA6v2u8tHdFeqnVZu4Drgt2SE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nUTupM+G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nUTupM+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2268C2BBFC;
	Tue, 30 Apr 2024 11:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475532;
	bh=Ckuv/WcTnFhJEBA/yTyZSVkqw9grPUtNY188TKbjwrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nUTupM+GZ48s1milH0xT4Au2V4bHlRSFVtP6SR81Web16VOMaykVdIj5sksWYric8
	 qlgY/+0VcV/eHIE+5dulhbhF8MAn+c1+DcY7IXT8rqr3TGvBJJWlCzVYqpYOP1YgtQ
	 M/GJ+mbqNpd1Acaiah5zBlkrCaCI/XCab/AHAxso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aswin Unnikrishnan <aswinunni01@gmail.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.6 117/186] rust: remove `params` from `module` macro example
Date: Tue, 30 Apr 2024 12:39:29 +0200
Message-ID: <20240430103101.429747303@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Aswin Unnikrishnan <aswinunni01@gmail.com>

commit 19843452dca40e28d6d3f4793d998b681d505c7f upstream.

Remove argument `params` from the `module` macro example, because the
macro does not currently support module parameters since it was not sent
with the initial merge.

Signed-off-by: Aswin Unnikrishnan <aswinunni01@gmail.com>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Cc: stable@vger.kernel.org
Fixes: 1fbde52bde73 ("rust: add `macros` crate")
Link: https://lore.kernel.org/r/20240419215015.157258-1-aswinunni01@gmail.com
[ Reworded slightly. ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/macros/lib.rs |   12 ------------
 1 file changed, 12 deletions(-)

--- a/rust/macros/lib.rs
+++ b/rust/macros/lib.rs
@@ -35,18 +35,6 @@ use proc_macro::TokenStream;
 ///     author: "Rust for Linux Contributors",
 ///     description: "My very own kernel module!",
 ///     license: "GPL",
-///     params: {
-///        my_i32: i32 {
-///            default: 42,
-///            permissions: 0o000,
-///            description: "Example of i32",
-///        },
-///        writeable_i32: i32 {
-///            default: 42,
-///            permissions: 0o644,
-///            description: "Example of i32",
-///        },
-///    },
 /// }
 ///
 /// struct MyModule;


