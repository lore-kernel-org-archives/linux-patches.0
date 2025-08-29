Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15D11C84C7;
	Fri, 29 Aug 2025 19:23:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756495382; cv=none; b=l8gwKzzNIRIrP09Yl3Bw/JKxQHAkDT3+Q0Zzh6h3wlgV3IbnPzfVdwqacBqsDR9EAQh1PpVjWidRWF+8m6EkG6vsar/VDiqOAQIshdAYMcrwFvvYzECWkVrkSdP8Z4ncDXHJEgMlNQF6/5+U0FzWaqawiWzpYrx+TYw4bzT/SVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756495382; c=relaxed/simple;
	bh=OEqfpYaXjoesa3749aicLTFrLaKPE0VOx63A9aywxp0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=f3dn12aQ6rki9qAfczVUgdc4t51zXiEBUC1A+U11yzRMUHseZFHi20xRm3skWZQZx0eC3w+RLMeRKHvvXBm8NcK15+FDpE4sCiBwKAryNKTLEct/JF8CDhmjPyXuT4yPwSAWdj8eE62/cWDyAjYXw7ke6dzFF5V8SZyqv1kDmAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B/Y0siOg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B/Y0siOg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A0BC4CEF0;
	Fri, 29 Aug 2025 19:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756495381;
	bh=OEqfpYaXjoesa3749aicLTFrLaKPE0VOx63A9aywxp0=;
	h=From:To:Cc:Subject:Date:From;
	b=B/Y0siOgPRydyoN32IMA+eOdAJFX1dxY5dFllqHRse/t6KaNBdx7nQhU+W+m8SONs
	 rrCcnfziu10EqCeLBY3cJ6W0qIsaqIiXDq3x49Fc1AabRdY/7mENJV9ueAvYUCaNis
	 bjDRIOg+CRyRLUCgPFJwBwWCkFoOWB2vxVRvghBbKZrYeT67py8w6mBKp/7BnScvS4
	 jcy59gJwakSkVqeDz9o7pwJZVXF32fFg4Qii5GCQ1BWXkwdI6qFv2dmCUBZjsnxQDf
	 8dKWBgGcZaVKRODomUe0d2IypMKP5GKJncXK7vqXX1SZ5QE03a4sV9t6LH97agY83X
	 n51Qm/jPEKugQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 0/3] Error improvements
Date: Fri, 29 Aug 2025 21:22:40 +0200
Message-ID: <20250829192243.678079-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A couple improvements from the past that I rebased prompted by the
discussion at [1].

Link: https://rust-for-linux.zulipchat.com/#narrow/channel/288089-General/topic/x/near/535616940 [1]

Miguel Ojeda (3):
  rust: error: improve `Error::from_errno` documentation
  rust: error: improve `to_result` documentation
  rust: error: replace `WARN_ON_ONCE` comment with `debug_assert!`

 rust/kernel/error.rs | 62 ++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 57 insertions(+), 5 deletions(-)

--
2.51.0
