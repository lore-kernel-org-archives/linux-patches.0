Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EECE14A99
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="01OmN6B0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6F8C433CB;
	Mon, 23 Oct 2023 11:13:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059619;
	bh=moxeWhXuepqlxXF8ggTXvBhwAX1hDED4dqO+IowhgEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=01OmN6B06+WQ41aPn/IsxC3cZAQ/3cdY8jGdjlfAIiKRj8G1CKLJZ4nhkHxsF+IBC
	 szAroIAaRPzFn8QqbGzausgyNZgParvk4tBtrR1Z7rBSmXyOQSqFpINht0v5MjXjzK
	 RBejXD8PI11k/qbyCr8AhrhVdklFeXQJP8cj/IT0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wedson Almeida Filho <walmeida@microsoft.com>,
	Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
	Trevor Gross <tmgross@umich.edu>,
	Finn Behrens <me@kloenk.dev>,
	Alice Ryhl <aliceryhl@google.com>,
	Miguel Ojeda <ojeda@kernel.org>
Subject: [PATCH 6.5 211/241] rust: error: fix the description for `ECHILD`
Date: Mon, 23 Oct 2023 12:56:37 +0200
Message-ID: <20231023104838.993608503@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wedson Almeida Filho <walmeida@microsoft.com>

commit 17bfcd6a81535d7d580ddafb6e54806890aaca6c upstream.

A mistake was made and the description of `ECHILD` is wrong (it reuses
the description of `ENOEXEC`). This fixes it to reflect what's in
`errno-base.h`.

Signed-off-by: Wedson Almeida Filho <walmeida@microsoft.com>
Reviewed-by: Martin Rodriguez Reboredo <yakoyoku@gmail.com>
Reviewed-by: Trevor Gross <tmgross@umich.edu>
Reviewed-by: Finn Behrens <me@kloenk.dev>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
Fixes: 266def2a0f5b ("rust: error: add codes from `errno-base.h`")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230930144958.46051-1-wedsonaf@gmail.com
[ Use the plural, as noticed by Benno. ]
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 rust/kernel/error.rs | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/rust/kernel/error.rs b/rust/kernel/error.rs
index 05fcab6abfe6..0f29e7b2194c 100644
--- a/rust/kernel/error.rs
+++ b/rust/kernel/error.rs
@@ -37,7 +37,7 @@ macro_rules! declare_err {
     declare_err!(E2BIG, "Argument list too long.");
     declare_err!(ENOEXEC, "Exec format error.");
     declare_err!(EBADF, "Bad file number.");
-    declare_err!(ECHILD, "Exec format error.");
+    declare_err!(ECHILD, "No child processes.");
     declare_err!(EAGAIN, "Try again.");
     declare_err!(ENOMEM, "Out of memory.");
     declare_err!(EACCES, "Permission denied.");
-- 
2.42.0



