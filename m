Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F23B414D431;
	Tue, 23 Jul 2024 17:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721754843; cv=none; b=TOKRd4fZy3hzvWhqSrnkBWo1w3WqLF87budNXr+IOBWeIWaaeeJq1CU7NDWkBXbg4pKhtsTbbgIoCcL9RYIgZerWXyqaPjz5Jt34KLHn+GuSt7sF866YWE1yXU8294kqW9kMqRkdCsiaUNVMRseW5/mnXtqHiDWji8Go40cDqJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721754843; c=relaxed/simple;
	bh=GIngIWude+j/qr1OnbTt1GO6wFk2NXyz73HIaqvJeOM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=qr4HE9Dcvp4bWyCMFMRW6ZYI1DizHhGk6E+eNq90oR3hKABRWYiScyDHInSg8YB4E2Sz8fA0AtGNPxS8TuOoTT5mULmIbfVjYl9ULJ6kuBLd31zPc6+8qjK+VNyDwqeCNBK84sU6dht5QZs604mSopnu61N+YLgajMYfNa1I/r4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=sikEBLSb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="sikEBLSb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=UO2d2kJ6zH5N1mKS5rOkIV3SiF3aSx7WorIRVLgkbP8=; b=sikEBLSb9Ay9GuOTqeVyQp0i0u
	Zo3u1xKpAr5H9+4ruT8dq1HnU/Rgkbi6ZHDwhTUKbU6A3KGVn2byjynH5whNCKWG/XrgUIKVCJBVD
	N2Rix8fAsTWF3L+PYf5YJ0Q7TnEIHSlex3K/KV+LJGxvLCx49QCTYArjLu8e+2PRnPT0AwSoOclnQ
	qYAGHBF3bqV1V+6qWhV9BignH+DrrA3SfXBQQMXmg6dkqEaXyIvAeVKodWonMZixK64ZC3F6g5LGD
	MWhNHrhzqf07Go4b7tYpSa1QTVKr9q4+i2FLRuTzKrO5ZYI9CEto1c9UQC0PCogJjJ7wH/6grqREt
	OnZETrNA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.97.1 #2 (Red Hat Linux))
	id 1sWJ5N-0000000D6A1-0Q0s;
	Tue, 23 Jul 2024 17:14:01 +0000
Date: Tue, 23 Jul 2024 10:14:01 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
	linux-modules@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
	jtornosm@redhat.com, lucas.demarchi@intel.com, mcgrof@kernel.org
Subject: [GIT PULL] Modules changes for v6.11-rc1
Message-ID: <Zp_k2XEViIlDavXX@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Luis Chamberlain <mcgrof@infradead.org>

The following changes since commit 6ba59ff4227927d3a8530fc2973b80e94b54d58f:

  Linux 6.10-rc4 (2024-06-16 13:40:16 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/modules-6.11-rc1

for you to fetch changes up to 61842868de13aa7fd7391c626e889f4d6f1450bf:

  module: create weak dependecies (2024-06-30 18:57:20 -0700)

----------------------------------------------------------------
Modules changes for v6.11-rc1

This is a super boring development cycle this time around for modules,
there is only one patch in this pull request. The patch deals with a
corner case set of dependencies which is not resolved today to ensure
users get the modules they need on initramfs. Currently only one modules
is known to exist which needs this, however this can grow to capture
other corner cases likely escaped and not reported before. The kernel
change is just a section update, the real work is done and merged
already on upstream kmod.

This has been on linux-next for 3 weeks now.

----------------------------------------------------------------
Jose Ignacio Tornos Martinez (1):
      module: create weak dependecies

 include/linux/module.h | 6 ++++++
 1 file changed, 6 insertions(+)
