Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0F20107A2
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 16:42:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6557BC433D6;
	Thu, 10 Nov 2022 16:42:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1668098565;
	bh=zrkavDKsBthT94ju0QKne8tZOVOAyQVpPnOep6nNbD4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=defv2G9CQv4RktVFNQNYIolUchVkLP9Wq9ByfDiqNu63DeSvdvWA0Ax4wY/j5/Sd1
	 tRNOsoPy3x6hDXT9L2L30RD+6Cgv27U2nN1UaLW2p2TO+f8Bx1FerAC5tJM8Q5luE7
	 5KGB+tgEub5+QyLrVQAhnAr/adNRgT7mi9c0U880z1OslWQY9D8+jCSGjYprxnCpPG
	 4NgMnIkawCVT2rS9XKBnQwo6+VNsLqaiGNTSzs1+OjXhtZwRSKsS8rnWmL4Lw1//7P
	 JF680DAc4dhz7Ozt17PuKli23dQr/kaHvXY5dvv4rGBlm6nnKrdyLamMhtImSZ5/wF
	 kQ+e8ErUC2YSQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>
Cc: rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Viktor Garske <viktor@v-gar.de>
Subject: [PATCH v1 09/28] rust: error: add codes from `errno-base.h`
Date: Thu, 10 Nov 2022 17:41:21 +0100
Message-Id: <20221110164152.26136-10-ojeda@kernel.org>
In-Reply-To: <20221110164152.26136-1-ojeda@kernel.org>
References: <20221110164152.26136-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Viktor Garske <viktor@v-gar.de>

Only a few codes were added so far. With the `declare_err!`
macro in place, add the remaining ones (which is most of them)
from `include/uapi/asm-generic/errno-base.h`.

Co-developed-by: Wedson Almeida Filho <wedsonaf@gmail.com>
Signed-off-by: Wedson Almeida Filho <wedsonaf@gmail.com>
Signed-off-by: Viktor Garske <viktor@v-gar.de>
[Reworded, adapted for upstream and applied latest changes]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 rust/kernel/error.rs | 33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/rust/kernel/error.rs b/rust/kernel/error.rs
index b843f3445483..861746f2422d 100644
--- a/rust/kernel/error.rs
+++ b/rust/kernel/error.rs
@@ -17,7 +17,40 @@ pub mod code {
         };
     }
 
+    declare_err!(EPERM, "Operation not permitted.");
+    declare_err!(ENOENT, "No such file or directory.");
+    declare_err!(ESRCH, "No such process.");
+    declare_err!(EINTR, "Interrupted system call.");
+    declare_err!(EIO, "I/O error.");
+    declare_err!(ENXIO, "No such device or address.");
+    declare_err!(E2BIG, "Argument list too long.");
+    declare_err!(ENOEXEC, "Exec format error.");
+    declare_err!(EBADF, "Bad file number.");
+    declare_err!(ECHILD, "Exec format error.");
+    declare_err!(EAGAIN, "Try again.");
     declare_err!(ENOMEM, "Out of memory.");
+    declare_err!(EACCES, "Permission denied.");
+    declare_err!(EFAULT, "Bad address.");
+    declare_err!(ENOTBLK, "Block device required.");
+    declare_err!(EBUSY, "Device or resource busy.");
+    declare_err!(EEXIST, "File exists.");
+    declare_err!(EXDEV, "Cross-device link.");
+    declare_err!(ENODEV, "No such device.");
+    declare_err!(ENOTDIR, "Not a directory.");
+    declare_err!(EISDIR, "Is a directory.");
+    declare_err!(EINVAL, "Invalid argument.");
+    declare_err!(ENFILE, "File table overflow.");
+    declare_err!(EMFILE, "Too many open files.");
+    declare_err!(ENOTTY, "Not a typewriter.");
+    declare_err!(ETXTBSY, "Text file busy.");
+    declare_err!(EFBIG, "File too large.");
+    declare_err!(ENOSPC, "No space left on device.");
+    declare_err!(ESPIPE, "Illegal seek.");
+    declare_err!(EROFS, "Read-only file system.");
+    declare_err!(EMLINK, "Too many links.");
+    declare_err!(EPIPE, "Broken pipe.");
+    declare_err!(EDOM, "Math argument out of domain of func.");
+    declare_err!(ERANGE, "Math result not representable.");
 }
 
 /// Generic integer kernel error.
-- 
2.38.1

