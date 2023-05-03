Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C63D67E9
	for <patches@lists.linux.dev>; Wed,  3 May 2023 02:33:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Transfer-Encoding:
	MIME-Version:Message-Id:Date:Subject:Cc:To:From:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=pkPRiNpgcA+BA4XuLGFxUCQunbLSHZaA3tE3Dh0LC9s=; b=FouYfGdYkd5pD47/llJH/3W9f1
	kHN8sMMmiVL1RPjgTpRQcLmxriPr5K0FKc3gwbncG9+slHPjZazlQq/IHKNQRFRMVqFy2hzfPJ7HW
	x1qFvRUuskRpBrE8alYulmTaUIj90gAo+h9Z2jZm9BFPZumuynrwlwVb9ZI+nhYHuNz4aqTlKjASb
	d8gVhcAFKFEd2xI/lXLR6uoDdxYMekV3ywcgIMbIM/ckXa6AlWOv0765DgNr/CWhoN6hClj1eJL6r
	Z0FW1FpGR1N4gL6VrPcE/Ks+WI9Ut5ErDAg+YGTbl1d5nTvsxY81bfIOIfd6oALnnLCEjsPwYCyCV
	R/csgQnw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1pu2J8-0039fF-2N;
	Wed, 03 May 2023 02:33:30 +0000
From: Luis Chamberlain <mcgrof@kernel.org>
To: torvalds@linux-foundation.org
Cc: ebiederm@xmission.com,
	keescook@chromium.org,
	yzaikin@google.com,
	j.granados@samsung.com,
	patches@lists.linux.dev,
	ebiggers@kernel.org,
	jeffxu@google.com,
	akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luis Chamberlain <mcgrof@kernel.org>
Subject: [PATCH 0/2] sysctl: death to register_sysctl_paths()
Date: Tue,  2 May 2023 19:33:27 -0700
Message-Id: <20230503023329.752123-1-mcgrof@kernel.org>
X-Mailer: git-send-email 2.38.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Luis Chamberlain <mcgrof@infradead.org>

Linus,

As mentioned on my first pull request for sysctl-next, for v6.4-rc1
we're very close to being able to deprecating register_sysctl_paths().
I was going to assess the situation after the first week of the merge
window.

That time is now and things are looking good. We only have one stragglers
on the patch which had already an ACK for so I'm picking this up here now and
the last patch is the one that uses an axe. Some careful eyeballing would
be appreciated by others. If this doesn't get properly reviewed I can also
just hold off on this in my tree for the next merge window. Either way is
fine by me.

I have boot tested the last patch and 0-day build is ongoing. You can give
it a day for a warm fuzzy build test result.

Luis Chamberlain (2):
  kernel: pid_namespace: simplify sysctls with register_sysctl()
  sysctl: remove register_sysctl_paths()

 fs/proc/proc_sysctl.c     | 55 +++------------------------------------
 include/linux/sysctl.h    | 12 ---------
 kernel/pid_namespace.c    |  3 +--
 kernel/pid_sysctl.h       |  3 +--
 scripts/check-sysctl-docs | 16 ------------
 5 files changed, 6 insertions(+), 83 deletions(-)

-- 
2.39.2

