Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEEE12BF32;
	Tue, 30 Apr 2024 11:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476631; cv=none; b=kx1cVnOSCrIvYzfOJ8D+uIsLWMnIVmgHm4yRv6y9BeFORerSnasN39mU8zPMzMz7VYfSh8okaaF1hGskQeaoZlyrQQFAv4k8xm/jUb6mcHp43BIDNWeQNSWKUqDFHTugtAgCPZGq2OLIvAJryS3Qa5Aa1QxuK0I1ZfYZMvaBoHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476631; c=relaxed/simple;
	bh=kqH5bPA0+R3sIvSAS52hMWA9I2uDabNEW6QXwMQNukc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kWo7QZqDKNV1hbVddqL6QGPgf3i0RHDhx1YC3M3KLje2m+x+sJxAaWLmuAkb/BI9n06ONbs76NAnmdo9xJZOn+PYxZqr33VHBB4M51RxeXvejfAgCdfbO4lAlTbKNRjgpG8MSXZn1c9Hg0xCf0UfIe77FYYAxe2pFG+vYsRqFCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xc8r190n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xc8r190n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB61DC2BBFC;
	Tue, 30 Apr 2024 11:30:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476631;
	bh=kqH5bPA0+R3sIvSAS52hMWA9I2uDabNEW6QXwMQNukc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xc8r190nzGis00iT+ogDkm6jAUO1HT5jJ2qF+Kt1pw5Ss6AfDVOOy5QBBmOkLeYey
	 XMGlzxrnPhCUCiKi8mjWQSiNZitF4b0r70pPVsFWCgymCTgIYw5K5czk7OlPm6VFvv
	 JPXDWomPYiPqvrPzwWHwm2o5lW5ssozhvS+PyAVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aswin Unnikrishnan <aswinunni01@gmail.com>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.1 090/110] rust: remove `params` from `module` macro example
Date: Tue, 30 Apr 2024 12:40:59 +0200
Message-ID: <20240430103050.228484242@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -27,18 +27,6 @@ use proc_macro::TokenStream;
 ///     author: b"Rust for Linux Contributors",
 ///     description: b"My very own kernel module!",
 ///     license: b"GPL",
-///     params: {
-///        my_i32: i32 {
-///            default: 42,
-///            permissions: 0o000,
-///            description: b"Example of i32",
-///        },
-///        writeable_i32: i32 {
-///            default: 42,
-///            permissions: 0o644,
-///            description: b"Example of i32",
-///        },
-///    },
 /// }
 ///
 /// struct MyModule;


