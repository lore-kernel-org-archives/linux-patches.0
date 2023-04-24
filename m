Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 284A42108
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 13:32:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5624C433EF;
	Mon, 24 Apr 2023 13:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682343167;
	bh=0Sm3/m/sbl6YkZnwnL8cRMncGNL49HXMeMUIbD4wg4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gXejPbC0N9TVpq/89bvKOdUaCrzgJFIe37LZ6SPk8rmIwnwEMneC5q+ImKwRjas3S
	 T3LXteVEqV47knQ0OpTslCFAlecqccxbGm8JiLkG6hdaZ9XKXhDI3LSW6eWLicdtGH
	 Lvw+z6akHMr8ljG7PETRBAg1wQX+cevGvHj4OR30=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Gow <davidgow@google.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.2 062/110] rust: kernel: Mark rust_fmt_argument as extern "C"
Date: Mon, 24 Apr 2023 15:17:24 +0200
Message-Id: <20230424131138.643637908@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Gow <davidgow@google.com>

commit c682e4c37d2b8ba3bde1125cbbea4ee88824b4e2 upstream.

The rust_fmt_argument function is called from printk() to handle the %pA
format specifier.

Since it's called from C, we should mark it extern "C" to make sure it's
ABI compatible.

Cc: stable@vger.kernel.org
Fixes: 247b365dc8dc ("rust: add `kernel` crate")
Signed-off-by: David Gow <davidgow@google.com>
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Björn Roy Baron <bjorn3_gh@protonmail.com>
Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
[Applied `rustfmt`]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/print.rs |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/rust/kernel/print.rs
+++ b/rust/kernel/print.rs
@@ -18,7 +18,11 @@ use crate::bindings;
 
 // Called from `vsprintf` with format specifier `%pA`.
 #[no_mangle]
-unsafe fn rust_fmt_argument(buf: *mut c_char, end: *mut c_char, ptr: *const c_void) -> *mut c_char {
+unsafe extern "C" fn rust_fmt_argument(
+    buf: *mut c_char,
+    end: *mut c_char,
+    ptr: *const c_void,
+) -> *mut c_char {
     use fmt::Write;
     // SAFETY: The C contract guarantees that `buf` is valid if it's less than `end`.
     let mut w = unsafe { RawFormatter::from_ptrs(buf.cast(), end.cast()) };


