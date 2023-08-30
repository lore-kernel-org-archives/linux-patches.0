Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 057A23FFB;
	Wed, 30 Aug 2023 17:00:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B8F3C433C7;
	Wed, 30 Aug 2023 17:00:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1693414833;
	bh=kX3mbHSLmaQyCEL60tmf9cx9ZOhGXkKv6MDHN2D63vs=;
	h=From:To:Cc:Subject:Date:From;
	b=jF6UcKfH/Ijm8BSR75OyktOFykk2hCPJ+WW84zdAuI8LFdEyqrl7Ohkei3L30Y2Zf
	 otGqyih898gvIjejvVAGC+2UKXeyYWmcj4nuzrttxOPrf501BtbrB52+eHOSe4FLlN
	 E6ZWRiupNKoNyYHHoG1E7LuOKn+ttvWkzJc9yNHXyNqO4YEW1F8XVCbxkysmVJUGmw
	 6RQ+ZBT+fjuN4hpd2o6TfbTudgzRL4P1EWVCayRjSKcchD7A4Bg85EejZqw7bpLxtM
	 581+8pz6W3QmP+knhYUvvdmVvIV3LAhGRlWFXmjh4BkrCyDYQmTjy7r9Yo9iISD/Hd
	 r+A9OD4DZg+aQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 1/2] MAINTAINERS: update Rust webpage
Date: Wed, 30 Aug 2023 18:59:48 +0200
Message-ID: <20230830165949.127475-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A few months ago we started a webpage for the Rust subsystem and
the overall Rust for Linux project [1].

The current `W:` field of the Rust entry points to the GitHub
repository, since originally we kept information in a `README.md`
file that got rendered by GitHub when visiting that URL.

That information was moved into the webpage and got expanded.
The webpage is also nowadays the entry point to the project,
and we pointed the "Website" GitHub metadata field to it.

Thus update the `W:` field to point to the actual webpage.

Link: https://rust-for-linux.com [1]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 MAINTAINERS | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 12601a47c839..7c8088e9a11b 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18558,7 +18558,7 @@ R:	Andreas Hindborg <a.hindborg@samsung.com>
 R:	Alice Ryhl <aliceryhl@google.com>
 L:	rust-for-linux@vger.kernel.org
 S:	Supported
-W:	https://github.com/Rust-for-Linux/linux
+W:	https://rust-for-linux.com
 B:	https://github.com/Rust-for-Linux/linux/issues
 C:	zulip://rust-for-linux.zulipchat.com
 T:	git https://github.com/Rust-for-Linux/linux.git rust-next

base-commit: 4af84c6a85c63bec24611e46bb3de2c0a6602a51
-- 
2.42.0

