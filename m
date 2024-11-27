Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F00A28E8;
	Wed, 27 Nov 2024 01:10:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732669834; cv=none; b=anWmo09b9E4VspFr6JPn4gCkqMpw71WoIfxeNKu5E8qcN/5r2oEcp7sARYeRdXHaWzk0Edk8w7BNk2Rv3FxFByRYwK3H7kV+EOP2aBdPIeE1+UVao1St4fmgINq7EyHYdPw98wxL40v/HNmMWbfnvt1bS6ZR/2zY176TjE7MpUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732669834; c=relaxed/simple;
	bh=PQ3J3RnuIxle5Ti4rLewqRZE0iwYuE5MuhrnEiN8pRM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=oUorEPCIeqJRD4e8ixlGPT91jm+FHUzBERLaa/TMFfiKN98+849Tj9/wbu5XLsrGf76N/RRjJMwpUq1GbDj9t6iSrd+1ZPQBtEhsejg1gHYZAi2RH/y6l+ADHnDcmpjpAR7SI1x3jR6Bcimw1rQc/qsNtMp3AzO/0IO2MiS1l1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=miCTHw7X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="miCTHw7X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7DE00C4CECF;
	Wed, 27 Nov 2024 01:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732669833;
	bh=PQ3J3RnuIxle5Ti4rLewqRZE0iwYuE5MuhrnEiN8pRM=;
	h=Date:From:To:Cc:Subject:From;
	b=miCTHw7XpauR2/+KAigQacgeuD6RApV2TlYwvn9TQaVTi6sFWgYKK/YT59RQfxgRx
	 /G4wj5xAep54ECFKxmmADITjdCquZVpAHNRzGrEFHk8jfPk6hc0wew5RtBOpPttiJI
	 jIk5ldh6v8wum6IQ2CzAscnRKMWErx+guEvhwkuyuTlSLK4EbIXTdqmoOygUrMmAG1
	 tPsa5kzg6+/JmvKqWHIZWGZABngtXcVa8dlTvvfRvPHIqXV25xEmutxhKOdsei/0Dz
	 dZLBiSiZMk/SM5dWxg5lYBvaYWfgX218TSV4ue9TmXx9mzDICWLTNnuQcHXtnp4S9g
	 O2vGc1ln+vShQ==
Date: Tue, 26 Nov 2024 17:10:32 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, samitolvanen@google.com,
	petr.pavlu@suse.com, da.gomez@samsung.com,
	linux-modules@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	masahiroy@kernel.org, mmaurer@google.com, arnd@arndb.de,
	deller@gmx.de, song@kernel.org, mcgrof@kernel.org
Subject: [GIT PULL] Modules changes for v6.13-rc1
Message-ID: <Z0ZxiLw9hauUynTS@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit 8e929cb546ee42c9a61d24fae60605e9e3192354:

  Linux 6.12-rc3 (2024-10-13 14:33:32 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/modules/linux.git/ tags/modules-6.13-rc1

for you to fetch changes up to 2466b31201424ccb7eda00277222302a4d6576cb:

  tests/module/gen_test_kallsyms.sh: use 0 value for variables (2024-11-07 14:32:55 -0800)

----------------------------------------------------------------
Modules changes for v6.13-rc1

Highlights for this merge window:

  * The whole caching of module code into huge pages by Mike Rapoport is going
    in through Andrew Morton's tree due to some other code dependencies. That's
    really the biggest highlight for Linux kernel modules in this release. With
    it we share huge pages for modules, starting off with x86. Expect to see that
    soon through Andrew!

  * Helge Deller addressed some lingering low hanging fruit alignment
    enhancements by. It is worth pointing out that from his old patch series
    I dropped his vmlinux.lds.h change at Masahiro's request as he would
    prefer this to be specified in asm code [0].

    [0] https://lore.kernel.org/all/20240129192644.3359978-5-mcgrof@kernel.org/T/#m9efef5e700fbecd28b7afb462c15eed8ba78ef5a

  * Matthew Maurer and Sami Tolvanen have been tag teaming to help
    get us closer to a modversions for Rust. In this cycle we take in
    quite a lot of the refactoring for ELF validation. I expect modversions
    for Rust will be merged by v6.14 as that code is mostly ready now.

  * Adds a new modules selftests: kallsyms which helps us tests find_symbol()
    and the limits of kallsyms on Linux today.

  * We have a realtime mailing list to kernel-ci testing for modules now
    which relies and combines patchwork, kpd and kdevops:

    - https://patchwork.kernel.org/project/linux-modules/list/
    - https://github.com/linux-kdevops/kdevops/blob/main/docs/kernel-ci/README.md
    - https://github.com/linux-kdevops/kdevops/blob/main/docs/kernel-ci/kernel-ci-kpd.md
    - https://github.com/linux-kdevops/kdevops/blob/main/docs/kernel-ci/linux-modules-kdevops-ci.md

    If you want to help avoid Linux kernel modules regressions, now its simple,
    just add a new Linux modules sefltests under tools/testing/selftests/module/
    That is it. All new selftests will be used and leveraged automatically by
    the CI.

----------------------------------------------------------------
Arnd Bergmann (1):
      selftests: kallsyms: add MODULE_DESCRIPTION

Helge Deller (2):
      modules: Ensure 64-bit alignment on __ksymtab_* sections
      modules: Add missing entry for __ex_table

Luis Chamberlain (2):
      selftests: add new kallsyms selftests
      tests/module/gen_test_kallsyms.sh: use 0 value for variables

Matthew Maurer (13):
      module: Take const arg in validate_section_offset
      module: Factor out elf_validity_ehdr
      module: Factor out elf_validity_cache_sechdrs
      module: Factor out elf_validity_cache_secstrings
      module: Factor out elf_validity_cache_index_info
      module: Factor out elf_validity_cache_index_mod
      module: Factor out elf_validity_cache_index_sym
      module: Factor out elf_validity_cache_index_str
      module: Group section index calculations together
      module: Factor out elf_validity_cache_strtab
      module: Additional validation in elf_validity_cache_strtab
      module: Reformat struct for code style
      scripts: Remove export_report.pl

 Makefile                                      |   6 +-
 kernel/module/internal.h                      |   7 +-
 kernel/module/main.c                          | 569 +++++++++++++++++++-------
 lib/Kconfig.debug                             | 105 +++++
 lib/Makefile                                  |   1 +
 lib/tests/Makefile                            |   1 +
 lib/tests/module/.gitignore                   |   4 +
 lib/tests/module/Makefile                     |  15 +
 lib/tests/module/gen_test_kallsyms.sh         | 129 ++++++
 scripts/export_report.pl                      | 186 ---------
 scripts/module.lds.S                          |   9 +-
 tools/testing/selftests/module/Makefile       |  12 +
 tools/testing/selftests/module/config         |   3 +
 tools/testing/selftests/module/find_symbol.sh |  81 ++++
 14 files changed, 785 insertions(+), 343 deletions(-)
 create mode 100644 lib/tests/Makefile
 create mode 100644 lib/tests/module/.gitignore
 create mode 100644 lib/tests/module/Makefile
 create mode 100755 lib/tests/module/gen_test_kallsyms.sh
 delete mode 100755 scripts/export_report.pl
 create mode 100644 tools/testing/selftests/module/Makefile
 create mode 100644 tools/testing/selftests/module/config
 create mode 100755 tools/testing/selftests/module/find_symbol.sh
