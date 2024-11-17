Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 150356FB0;
	Sun, 17 Nov 2024 13:31:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731850298; cv=none; b=oVJyz0zhMwayO6idNuZqxYI6TzrfuEuNbDCPHjcJ/SaLeMS9s3A5JjRsC1JZx3F5/KqhN7wm8Euu82TWQVBZ4pV6Pp2jSBnk0DyvitFYdOuF98HqZmEtQqeYINeMVcCYJR0VGWBTiKwZ4ULWtEZuesdpUZkWyao+vskVf2WAPp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731850298; c=relaxed/simple;
	bh=GqOQ+eUqfPKPaqsDhUk28dFOZErq76wUx4qvkmEWdXk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ttOqvMB/d19oQmecy6Yjm/uIbmJ02WmNAiD3hyEQql5JB0yeSJXUvAoizMKbIh4vVU10ipB590f/PIancOl9dfPoc6LkkP6SeQ6NvRmIpf89B+9kMHNOR0rAHw/EVoPALO/QWlYSdqnXrjDlH4Yyr3aEMxwhRtCWFUNBZJQRvkU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CH3fGJAl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CH3fGJAl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE382C4CECD;
	Sun, 17 Nov 2024 13:31:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731850297;
	bh=GqOQ+eUqfPKPaqsDhUk28dFOZErq76wUx4qvkmEWdXk=;
	h=From:To:Cc:Subject:Date:From;
	b=CH3fGJAlDXH+U30BMtb2JUfT+YcDez4g346QX51jmi15xpsWsJbpHK34wcMv869Gl
	 KwE7fps2IO+5lp2HWvCpCVQXDDC7uEOVoQOugAxruOZnP+KJX7zYAR4f7XFPcy2LjY
	 iG5HrfcI30yXdk1QCC2eykh7IcVevfrEH5yXf6dbBLsqZl74b/7bxjfRc/UFFx+wyl
	 uAeC2cKIJtqbFaNE3Sx/bvxnY5smMGE/F7HxtB8NzeEM3GYJfCxLLtKACe7RWMSBvN
	 WJ02eBDaLu/xLuS4iOzLdeT6+U3XrE2RsS5VJCN1Z/HVf9V2w4WXqQPCgefZgEmCSC
	 arbr/XbBO+syQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <benno.lossin@proton.me>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH] docs: rust: remove spurious item in `expect` list
Date: Sun, 17 Nov 2024 14:31:27 +0100
Message-ID: <20241117133127.473937-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This list started as a "when to prefer `expect`" list, but at some point
during writing I changed it to a "prefer `expect` unless...` one. However,
the first bullet remained, which does not make sense anymore.

Thus remove it. In addition, fix nearby typo.

Fixes: 04866494e936 ("Documentation: rust: discuss `#[expect(...)]` in the guidelines")
Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
---
 Documentation/rust/coding-guidelines.rst | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/Documentation/rust/coding-guidelines.rst b/Documentation/rust/coding-guidelines.rst
index f7194f7124b0..a2e326b42410 100644
--- a/Documentation/rust/coding-guidelines.rst
+++ b/Documentation/rust/coding-guidelines.rst
@@ -296,9 +296,7 @@ may happen in several situations, e.g.:
 It also increases the visibility of the remaining ``allow``\ s and reduces the
 chance of misapplying one.
 
-Thus prefer ``except`` over ``allow`` unless:
-
-- The lint attribute is intended to be temporary, e.g. while developing.
+Thus prefer ``expect`` over ``allow`` unless:
 
 - Conditional compilation triggers the warning in some cases but not others.
 

base-commit: b2603f8ac8217bc59f5c7f248ac248423b9b99cb
-- 
2.47.0

