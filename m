Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 236D8DDC1;
	Wed, 30 Jul 2025 13:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753880848; cv=none; b=o4iiRCZT675aJ/3j8VhMPjMXHBWn6jb0vLPLzseAN/Uyu04pWOXipE1FvBrkx80fbj8XpK4m4WhtQ43r41DM4VlwgsACQbypMyqqWH5agSq93YSzWN5hNydQmpZgi4S18vh4J0uwpQPZ5XkveZtVs44yC0BtsfuEdDzzLPam1gw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753880848; c=relaxed/simple;
	bh=pi2a7GnrhCAqcsm+sfSbg+NpUqiSUzYvwlb+GLh/v0A=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=Yw1f4V+AxJC6rApILW9Ozcd1PgxMqUT6WAkbAEXOP9gR60YnzzE9+spcyXgjCCnFzYQUKDovQ2CUFcWJJ0lCWzYB2WOsuSh7/RZ/9xZr5UTffp/0pW2EsfcI8LvlGvFjOjPuwL+zBMJ0XBHUo85/D4nw7vTJr8QkkR49B5SI/3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CBHRoL/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CBHRoL/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86555C4CEE7;
	Wed, 30 Jul 2025 13:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753880847;
	bh=pi2a7GnrhCAqcsm+sfSbg+NpUqiSUzYvwlb+GLh/v0A=;
	h=From:To:Cc:Subject:Date:From;
	b=CBHRoL/icwQ6+Mnzy0gpLoncSiBBNfdVoReTQsgdMr7uWpY5SpiLhN5LjydwTPqhS
	 gkoReMcZez/a8Y7ioc+6oPbNMjFK8yb7PI+GIk0MxRR3TXxdohex09/XLKVavKm5jA
	 oAwgarUCyCu0XTnRnJWkloO16Zhf6BhYL9tYjTtGtakRoMCYpxF1mCC+uadNRHjRTG
	 zSjh0vWLFgyBcveit5PvjiuqrMYfxW0idDa61w5ek9kNIlRAZKEjKm3X02H8cas8Nc
	 /JMpBSIk44M12REke/StKsklFhnzRM++4Pmqpx4Q2bExGHiM3JePsKAPSzakzTL2D3
	 Kle0SI7wP4qyQ==
From: Miguel Ojeda <ojeda@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>,
	Alex Gaynor <alex.gaynor@gmail.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>
Cc: Boqun Feng <boqun.feng@gmail.com>,
	Gary Guo <gary@garyguo.net>,
	=?UTF-8?q?Bj=C3=B6rn=20Roy=20Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	rust-for-linux@vger.kernel.org,
	linux-block@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: [PATCH 0/3] Fix broken `srctree/` links and warn about them
Date: Wed, 30 Jul 2025 15:07:13 +0200
Message-ID: <20250730130716.3278285-1-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

This fixes a handful of broken links and introduces a warning to
prevent them from happening in the future.

Relatedly, we could also perhaps check the other side of the links, but
perhaps there are cases we want to customize. Alternatively, we could
also in the future introduce custom syntax for these that avoids
repetition or a fancier preprocessing step.

Miguel Ojeda (3):
  rust: block: fix `srctree/` links
  rust: drm: fix `srctree/` links
  rust: warn if `srctree/` links do not exist

 rust/Makefile                    | 6 ++++++
 rust/kernel/block/mq/gen_disk.rs | 2 +-
 rust/kernel/drm/device.rs        | 2 +-
 rust/kernel/drm/driver.rs        | 2 +-
 rust/kernel/drm/file.rs          | 2 +-
 rust/kernel/drm/gem/mod.rs       | 2 +-
 rust/kernel/drm/ioctl.rs         | 2 +-
 7 files changed, 12 insertions(+), 6 deletions(-)

--
2.50.1
