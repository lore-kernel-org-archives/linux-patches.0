Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9410036AFD;
	Wed, 18 Oct 2023 16:02:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IpcbsVRk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C014AC433C8;
	Wed, 18 Oct 2023 16:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1697644921;
	bh=S4u2uK3OTPufLjif5hMUcF3c2nnunc5rUfO81Cu7CWo=;
	h=From:To:Cc:Subject:Date:From;
	b=IpcbsVRki8Xu/+UQY9COIpBUPxyOq9Z1B1YEJ4bk8F4OHy9o4mEscn5cYBEbrcjnq
	 2ULnjIzKC6eJ9kPanKoKK5L2Mw8VoTTfPz6GS++BKJqf9MDkFmiMfs4IiXqVNTqtez
	 mbjQDNlV8ajwyy23WpCPN8ahaMp92d1uOfLTvn30LSgmAs5w3gg3mn180TkgE9FdY2
	 SqeHQX6dkPgTa3428Y/E/paUhNaNMz0GaWIoAiyn44H1eBTU3r/94vADWpQJFzprk7
	 UuLrkXO9h2faxgLYYssw/GTwtni4jLG/yG9TyazKI5Vo1SbvPO+pmQlch1nyhRJW+N
	 4VGP7S1ytGK4Q==
From: Miguel Ojeda <ojeda@kernel.org>
To: Masahiro Yamada <masahiroy@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Carlos Bilbao <carlos.bilbao@amd.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	Alice Ryhl <aliceryhl@google.com>,
	linux-kbuild@vger.kernel.org,
	linux-doc@vger.kernel.org,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev,
	Akira Yokosawa <akiyks@gmail.com>,
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Subject: [PATCH 1/2] docs: rust: update Rust docs output path
Date: Wed, 18 Oct 2023 18:01:44 +0200
Message-ID: <20231018160145.1017340-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

The Rust code documentation output path moved from `rust/doc` to
`Documentation/output/rust/rustdoc`, thus update the old reference.

Fixes: 48fadf440075 ("docs: Move rustdoc output, cross-reference it")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Documentation/rust/general-information.rst | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Documentation/rust/general-information.rst b/Documentation/rust/general-information.rst
index 49029ee82e55..081397827a7e 100644
--- a/Documentation/rust/general-information.rst
+++ b/Documentation/rust/general-information.rst
@@ -29,7 +29,7 @@ target with the same invocation used for compilation, e.g.::
 
 To read the docs locally in your web browser, run e.g.::
 
-	xdg-open rust/doc/kernel/index.html
+	xdg-open Documentation/output/rust/rustdoc/kernel/index.html
 
 To learn about how to write the documentation, please see coding-guidelines.rst.
 

base-commit: 8a749fd1a8720d4619c91c8b6e7528c0a355c0aa
-- 
2.42.0

