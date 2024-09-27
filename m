Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE03C14D43D;
	Fri, 27 Sep 2024 21:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727472543; cv=none; b=FpZMVjdY7kdgYRbA5cZ5+QlymMt/NZ+Ds2M41CHlYbI+T9cf1tydP+QOz+Exkye7K12/l1Z4AnNum9qCspi/p8UOTpOyPV1hhFiN9Xu3xNR445n541ktY+Yscfi8VIHCfN7n/8os4zyGmIXLhyjLCTNdR5IOUUmjwy//yIgxkQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727472543; c=relaxed/simple;
	bh=pH33JBA1XiLy2oH0ddyRqN1FptJn9l9jJKHzfLHfq0w=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=GNrDctKYjDyYN1eDvsvN+6mILtEFeYCqxqSdEMl8bvArclQmEbcTW3CryO8OHwXkCztI4QjA3zPnZAe/BDzVSQlJ1SXY3z4LMkqpg7hHlgCgpTyf+5Dvl9LlD1I37bwwaQJ+v9auLAoB526PeBTfvG2SkWzrKFjRG40OOy1TrK4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G8Ah7msH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G8Ah7msH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AEF7C4CEC4;
	Fri, 27 Sep 2024 21:29:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1727472542;
	bh=pH33JBA1XiLy2oH0ddyRqN1FptJn9l9jJKHzfLHfq0w=;
	h=Date:From:To:Cc:Subject:From;
	b=G8Ah7msHY/Yh9Vhmqa7j32k1LcmH7052ZB2GYCv4MU2KF/zg75r5/O56XEKBAQz2I
	 JDY04yPKVbQXWYHY5fS5lUfAyWF8Arth/73KnUF0eLppnfdMEWDbJRLSc4FXTPTTFC
	 Xq1qccZeEi2Nd10HZt4lIM78xZ84v3/gxdl0cuJet5GMo1/WxvBKfNpkxoATtEB0yk
	 68pAl1fEYyiFNeaM5ZEo4qr96PBIH7Kjd0942To6NstglINSZntdpdJX+m5DEckzlf
	 TZMfH2tsFS4VyaYCfs5xBryctjSUhX8iVmWpVqw0w079nPXeR2f7nJyQCxzK+n4gE5
	 uGXgguFUDs0Lg==
Date: Fri, 27 Sep 2024 14:29:00 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, samitolvanen@google.com,
	petr.pavlu@suse.com, da.gomez@samsung.com,
	linux-modules@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	vdonnefort@google.com, song@kernel.org, catalin.marinas@arm.com,
	chunhui.li@mediatek.com, xion.wang@mediatek.com,
	masahiroy@kernel.org, mcgrof@kernel.org
Subject: [GIT PULL] Modules changes for v6.12-rc1
Message-ID: <ZvcjnE9Me0hCy4yK@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 47ac09b91befbb6a235ab620c32af719f8208399:

  Linux 6.11-rc4 (2024-08-18 13:17:27 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/modules-6.12-rc1

for you to fetch changes up to b319cea80539df9bea0ad98cb5e4b2fcb7e1a34b:

  module: Refine kmemleak scanned areas (2024-09-13 09:55:17 -0700)

----------------------------------------------------------------
Modules changes for v6.12-rc1

There are a few fixes / cleanups from Vincent, Chunhui, and Petr, but the
most important part of this pull request is the Rust community stepping
up to help maintain both C / Rust code for future Rust module support. We
grow the set of modules maintainers by 3 now, and with this hope to scale to
help address what's needed to properly support future Rust module support.

A lot of exciting stuff coming in future kernel releases.

This has been on linux-next for ~ 3 weeks now with no issues.

----------------------------------------------------------------
Chunhui Li (1):
      module: abort module loading when sysfs setup suffer errors

Luis Chamberlain (1):
      MAINTAINERS: scale modules with more reviewers

Petr Pavlu (2):
      module: Split modules_install compression and in-kernel decompression
      module: Clean up the description of MODULE_SIG_<type>

Vincent Donnefort (1):
      module: Refine kmemleak scanned areas

 MAINTAINERS                    |  3 ++
 kernel/module/Kconfig          | 77 +++++++++++++++++++++---------------------
 kernel/module/debug_kmemleak.c | 18 +++-------
 kernel/module/sysfs.c          | 63 ++++++++++++++++++++++------------
 scripts/Makefile.modinst       |  2 ++
 5 files changed, 90 insertions(+), 73 deletions(-)
