Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79DF51FA5
	for <patches@lists.linux.dev>; Tue, 18 Jul 2023 05:44:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 329F3C433C7;
	Tue, 18 Jul 2023 05:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689659082;
	bh=fMxCFJdsUJm8JBt25eJ62JnVPqBMNzOsIhTVtRXpBFg=;
	h=From:To:Cc:Subject:Date:From;
	b=AeLUpJrvbntC/9V1r8aaaRBAa4dOcdWTTmtDAdmwEnVw1CN4SGsmmtzsLg1CtUszm
	 JgYZhV9okcXuAMGW8Zl6MDBxesukgHZNL8SVxX2+5hZ2Yxlcg2x/kQU8Tqbpz7wO+L
	 K2nv6XjXC/4cGG3Dqq/vyq2OK1Q3xWy6ItFleXN4gNa+2OvJ4YR9cOuiuNqPZelo1i
	 uC/2QiD37dwh6X8zeH+WSaYEvFUpXFO4ADEVJVbtvYR5BJQmxGoXZQguKIpx4MRCqU
	 nHu31sVaSq89Nrjdr5StYvTDycYQJHMbN1vqi9zwRP+GaaviRQSCE0pbE5lCgndorw
	 Wp9NNcGKcav7w==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Wedson Almeida Filho <wedsonaf@gmail.com>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <a.hindborg@samsung.com>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] MAINTAINERS: add Andreas Hindborg as Rust reviewer
Date: Tue, 18 Jul 2023 07:44:25 +0200
Message-ID: <20230718054426.1048583-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Andreas has been involved with the Rust for Linux project for more than
a year now. He has been primarily working on the Rust NVMe driver [1],
presenting it in several places (such as LPC [2][3] and Kangrejos [4]).

In addition, he recently submitted the Rust null block driver [5] and
has been reviewing patches in the mailing list for some months.

Thus add him to the `RUST` entry as reviewer.

Link: https://rust-for-linux.com/nvme-driver [1]
Link: https://lpc.events/event/16/contributions/1180/attachments/1017/1961/deck.pdf [2]
Link: https://www.youtube.com/watch?v=BwywU1MqW38 [3]
Link: https://kangrejos.com/A%20Linux%20(PCI)%20NVMe%20Driver%20in%20Rust.pdf [4]
Link: https://lore.kernel.org/rust-for-linux/20230503090708.2524310-1-nmi@metaspace.dk/ [5]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 3be1bdfe8ecc..f2f0426258f3 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -18542,6 +18542,7 @@ R:	Boqun Feng <boqun.feng@gmail.com>
 R:	Gary Guo <gary@garyguo.net>
 R:	Björn Roy Baron <bjorn3_gh@protonmail.com>
 R:	Benno Lossin <benno.lossin@proton.me>
+R:	Andreas Hindborg <a.hindborg@samsung.com>
 L:	rust-for-linux@vger.kernel.org
 S:	Supported
 W:	https://github.com/Rust-for-Linux/linux

base-commit: 06c2afb862f9da8dc5efa4b6076a0e48c3fbaaa5
-- 
2.41.0

