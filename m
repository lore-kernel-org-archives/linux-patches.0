Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26BC4FBF1
	for <patches@lists.linux.dev>; Thu, 29 Jun 2023 22:24:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=j73TsJ8p6bLbCGEbkQLwUvgvSOenhS26pj4KF68J9QY=; b=RxoPjxQGYLUgC54v7oHes1xDio
	2Ifww8slldw/LrlgSJ/QP87+MQqsmgRDwFydFpk7HSUlbmSJt6D8H1tf0yFX8f27ufSzXOClu8DXp
	6hNg+1J6D9WLx/4EnVGG+67QAGc05pph6ynErKeCVYDb85LtREBoLA4arq5L5VlZT14/B05fKRbXl
	5PWg9Ip92QIfaN1CgjcJ7/67QF2aGFV91ghWWuKlcAAy2gYydHQnSbtGAbDiSRJ59lnBYWRaLOfya
	tW45bGTBPhLIpe0uzgL59e3NvWkTGLWw8dU4cGgIKzpw5nM+TAUFpQNqkQrywy1W/i5QcygbAVkKb
	2OO2FCnQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1qF03m-002KrV-3B;
	Thu, 29 Jun 2023 22:24:18 +0000
Date: Thu, 29 Jun 2023 15:24:18 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: arnd@arndb.de, matthieu.baerts@tessares.net, rdunlap@infradead.org,
	ebiederm@xmission.com, keescook@chromium.org, yzaikin@google.com,
	j.granados@samsung.com, patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	mcgrof@kernel.org
Subject: [GIT PULL] sysctl fixes for v6.5-rc1
Message-ID: <ZJ4EkpN71LEsakct@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Luis Chamberlain <mcgrof@infradead.org>

The following changes since commit c6b0271053e7a5ae57511363213777f706b60489:

  Merge tag 'fs_for_v6.5-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/jack/linux-fs (2023-06-29 13:39:51 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/sysctl-6.5-rc1-fixes

for you to fetch changes up to 554588e8e932e7a0fac7d3ae2132f2b727d9acfe:

  sysctl: fix unused proc_cap_handler() function warning (2023-06-29 15:19:43 -0700)

----------------------------------------------------------------
sysctl-6.5-rc1-fixes

Linus, included in this pull request is just a minor fix which
Matthieu Baerts noted I had not picked up. I adjusted the Fixes
commit ID to reflect the latest tree.

----------------------------------------------------------------
Arnd Bergmann (1):
      sysctl: fix unused proc_cap_handler() function warning

 kernel/umh.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
