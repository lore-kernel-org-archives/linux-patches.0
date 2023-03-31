Received: from mail-40133.protonmail.ch (mail-40133.protonmail.ch [185.70.40.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E26848F54
	for <patches@lists.linux.dev>; Fri, 31 Mar 2023 21:51:57 +0000 (UTC)
Date: Fri, 31 Mar 2023 21:51:35 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
	s=protonmail3; t=1680299509; x=1680558709;
	bh=hROJyTm6NeZLJh+vRRO9kol8Xhevc/WCzv7AS4Ky5PI=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=Sn5nYBKD4eegGoUxIP+3J1/1yvip3+a7+UsizNlGLHFjc01CEf209czQb+8GedlKG
	 cBniXokJuBvOCMJlntdiBYTEPRWEHdZbhp2a8PbBYxb7wkv1ezhu+AI/2290vA8ZE5
	 Km/+vS2sKTFvG5fWcBJdaOLLmamgK0a2GhGSkLH8prturH5H/yfc9KcFfqo1BPLeXo
	 f6WJ0ku3qmNl/4GSTMm1s/A/DqusdRUtAMa+aVe4fiU9R75Z91zz7RuO/yJRS2hovq
	 ylSQ99BL8puCfTLoi80axvR49EyZ7r+TgHGOGiFxl5j6VV01tRgSQJwmDhBUpLoYcu
	 BIZ/vS1rKzQUw==
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Wedson Almeida Filho <wedsonaf@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Alice Ryhl <alice@ryhl.io>
From: y86-dev@protonmail.com
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, patches@lists.linux.dev, Benno Lossin <y86-dev@protonmail.com>, Andreas Hindborg <a.hindborg@samsung.com>, Alice Ryhl <aliceryhl@google.com>
Subject: [PATCH v4 01/15] rust: enable the `pin_macro` feature
Message-ID: <20230331215053.585759-2-y86-dev@protonmail.com>
In-Reply-To: <20230331215053.585759-1-y86-dev@protonmail.com>
References: <20230331215053.585759-1-y86-dev@protonmail.com>
Feedback-ID: 40624463:user:proton
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

From: Benno Lossin <y86-dev@protonmail.com>

This feature enables the use of the `pin!` macro for the `stack_pin_init!`
macro. This feature is already stabilized in Rust version 1.68.

Signed-off-by: Benno Lossin <y86-dev@protonmail.com>
Cc: Gary Guo <gary@garyguo.net>
Cc: Andreas Hindborg <a.hindborg@samsung.com>
Cc: Alice Ryhl <aliceryhl@google.com>
---
 rust/kernel/lib.rs | 1 +
 1 file changed, 1 insertion(+)

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 223564f9f0cc..4317b6d5f50b 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -17,6 +17,7 @@
 #![feature(core_ffi_c)]
 #![feature(dispatch_from_dyn)]
 #![feature(generic_associated_types)]
+#![feature(pin_macro)]
 #![feature(receiver_trait)]
 #![feature(unsize)]

--
2.39.2


