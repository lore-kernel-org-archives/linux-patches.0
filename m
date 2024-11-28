Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 799FA19882B;
	Thu, 28 Nov 2024 19:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732822022; cv=none; b=lD5abIp/lsseXk/B2tO4OriYDT9Ld3dP9n1zIG/Nk/8UETTIVotta890cBD9iepJpo+8fUqubrDEIRH8lYxcGOU5x51A/lWEcn6qjLrt6+FHsMrvnsTJDKFsfRyxGmkZwEXg6aUBEu8uSMJpufwtVosQ361v9zKPr0luISIB66E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732822022; c=relaxed/simple;
	bh=uhCpIRnB22gOek6/ItoKHE65ZGFfikpPq/Ra+s61V1M=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=hloLtmXH0nnVWpwINUcs0kPVP1OUOlUlRN0hxx9x3JNg58xGCTexBh8xfQ6LRXJUfnfumIEce6jclK3HyEDOhC4pihzJ6NeEDHK44dHkab2YfbHDFmEHXkV+BhttexkKDpNg2zh59HFuhmJJYzzAQ6POpriW5RT3EV0vBBnhk/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CxJcZ1E0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CxJcZ1E0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FA9C4CED2;
	Thu, 28 Nov 2024 19:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1732822021;
	bh=uhCpIRnB22gOek6/ItoKHE65ZGFfikpPq/Ra+s61V1M=;
	h=Date:From:To:Cc:Subject:From;
	b=CxJcZ1E0uKkObjtme+VKhayhvIy0ZqUKrWUEuhHtHJdkEG6x3cP0cnlPeOlAX1GJT
	 tyOf7vPjcGPucWYFc67KodYfVXDIgjkm65L2onsjmp6nTpSfuLBzBLGzWjjOWyXcjB
	 yOW7dHIbi+8lSFJ0+968aOgi80I3HizmRmN+AlPSTCA0aCWU1NItm1gmSlnP+bFriJ
	 uWlRWSrYGnyn31C0bxuPwlYfNur6pZVfJoS213vQCBtWjfGXHtqicf1S8SacLemuqT
	 KDAhj+My0YSDeQkTWK/f5US4WNbWaq+DzFXgOyBx7G+jKG7EHFUD3rw8bXGYM2ktm3
	 vSVwuekNAR/rA==
Date: Thu, 28 Nov 2024 11:27:00 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>, samitolvanen@google.com,
	petr.pavlu@suse.com, da.gomez@samsung.com,
	linux-modules@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	geert@linux-m68k.org, masahiroy@kernel.org, mmaurer@google.com,
	arnd@arndb.de, deller@gmx.de, song@kernel.org
Subject: [GIT PULL] Modules fixes for v6.13-rc1
Message-ID: <Z0jEBLLRoUKoBVPk@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The following changes since commit b86545e02e8c22fb89218f29d381fa8e8b91d815:

  Merge tag 'acpi-6.13-rc1-2' of git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm (2024-11-27 14:50:31 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/modules/linux.git/ tags/modules-6.13-rc1-v2

for you to fetch changes up to c5efad88a94613cf60fed010b96dbc3044389316:

  selftests: find_symbol: Actually use load_mod() parameter (2024-11-28 11:17:38 -0800)

----------------------------------------------------------------
Modules fixes for v6.13-rc1

This consists of 3 fixes, the main one build that we build the kallsyms
test modules all over again if we just run make twice.

----------------------------------------------------------------
Geert Uytterhoeven (1):
      selftests: find_symbol: Actually use load_mod() parameter

Luis Chamberlain (2):
      selftests: kallsyms: fix double build stupidity
      selftests: kallsyms: fix and clarify current test boundaries

 lib/Kconfig.debug                             | 32 ++++++++++++++++++++++++++-
 lib/tests/module/Makefile                     | 17 +++++++-------
 lib/tests/module/gen_test_kallsyms.sh         |  9 ++++++--
 tools/testing/selftests/module/find_symbol.sh |  4 ++--
 4 files changed, 48 insertions(+), 14 deletions(-)
