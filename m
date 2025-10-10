Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0514D4A02;
	Fri, 10 Oct 2025 17:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760118263; cv=none; b=jON8DPt3E2trFFj4vKaAoSsI2tBIdUhgSJ2NiIItrQtyDbyEmEWDVuZxTQnsCJVcftjigfsjswzwkjUa0OfovEgqIUpmJvfQtudqOmztYc4iFf4GfR5RQQXe9W9zCyy30PhqiQiHMpBjX1+yBXIOc8ryFtdpW6c+MgQXNd+CH7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760118263; c=relaxed/simple;
	bh=mQm2jQdRz8ffZElgCp07lKUPeuSqaJpiZY/N6609SY4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Dy41zqRuUZ0hyWd7ZUmOJeOoSOrt17AUleTMcfd6EI1anclqRCqXI6UKyLgnCP8uYtp6LgMKfR+d0/4vcCN767FvI0O72rBJCkkq9wuVOJnlxijobTiyUJF1aykBniPsHZ+ykwgiZXWNev54r9b6uPPvxlB4/a5YUkyVWenSrco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PeW/XGVU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PeW/XGVU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B807BC4CEF5;
	Fri, 10 Oct 2025 17:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1760118262;
	bh=mQm2jQdRz8ffZElgCp07lKUPeuSqaJpiZY/N6609SY4=;
	h=From:To:Cc:Subject:Date:From;
	b=PeW/XGVULkJ7Vb1ngwWuipibZn2jFoJFfZbtcQjf0i/VvDvOHvpy5I7Y7ymbFt5Yd
	 jvNMiTcb696uWzQTL6oHn0xc0K6HjvxKoUZ9lzM5ofGsyFDAcMm+uBbdev464Lae4i
	 5/9WaDue3sAXVe/mWNdiDqLBN3scBSmRmIBr/ChKIMGJMqqEL2/pY6E+tCGS25Wrv2
	 9ZBEvHtxlzofOUMSArD0LNgM+JXlX8gtzvPVbVNvPVWLm/MxrMzrS39dkowYpdIVMp
	 ey4nn9ESx0SG2Pziiah2u+9EiR4zhZoOa8P3itR7hNPS9QxeSxSfgb6AUNqpGtfuKy
	 FoZzYfxffA0CQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 0/3] Clean `rustfmt` formatting and define imports style
Date: Fri, 10 Oct 2025 19:43:48 +0200
Message-ID: <20251010174351.948650-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Linus,

Please see these commits, especially the documentation one. It is a
follow-up of the discussion on `rustfmt`.

If you are OK with it, please pick them up for -rc1 -- this should make
CIs green and let people work easily after -rc1, which would help even
if we decide to do something differently later on.

I can send a quick PR if you prefer.

Thanks!

Miguel Ojeda (3):
  docs: rust: add section on imports formatting
  rust: alloc: employ a trailing comment to keep vertical layout
  rust: cpufreq: fix formatting

 Documentation/rust/coding-guidelines.rst | 75 ++++++++++++++++++++++++
 rust/kernel/alloc/kvec.rs                |  2 +-
 rust/kernel/cpufreq.rs                   |  3 +-
 3 files changed, 77 insertions(+), 3 deletions(-)

--
2.51.0
