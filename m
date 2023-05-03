Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88C9DF43
	for <patches@lists.linux.dev>; Wed,  3 May 2023 19:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=4ZmM4HTiK/znMvvowe1LUd4PXCYNKLo7UX2p4qgTXGU=; b=VOJAVkEssu13qwWK2bqnx1KNc1
	GZOztv8i2scsmcBqy1XJuLA7jOp8fZ5iN9T0EgmHYFXY0yTYipLKabV+U2edQrMvVEaN1TAVLpjeb
	J6u02nSaz1f6pUu/q13fENzJCV/2VrXRNRRZquKp5PlaZ0BSYwTA6A/X6ph81tFdjzGSPNmI+jsPW
	H0J5Cog8m3/n8MlP8061pfzaWc5+YdXBOhOE99YdAYPr+1luMCswGomVXPmxeUgUUK3ieEsZYMd4X
	Sp+Z5Vg3WaBmIj77MONOGh37xsRghjira2MU4x7F/n01heKmwQohqL6ouIdyLpmT16BaLavGhgqpw
	7ltG5cEQ==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1puHzB-005ZOl-2h;
	Wed, 03 May 2023 19:17:57 +0000
Date: Wed, 3 May 2023 12:17:57 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: ebiederm@xmission.com, keescook@chromium.org, yzaikin@google.com,
	j.granados@samsung.com, patches@lists.linux.dev,
	ebiggers@kernel.org, jeffxu@google.com, akpm@linux-foundation.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	mcgrof@kernel.org
Subject: [GIT PULL] sysctl changes for v6.4-rc4 v2
Message-ID: <ZFKzZeAs5Mdfv5ha@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Luis Chamberlain <mcgrof@infradead.org>

The following changes since commit 348551ddaf311c76b01cdcbaf61b6fef06a49144:

  Merge tag 'pinctrl-v6.4-1' of git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl (2023-05-02 15:40:41 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/sysctl-6.4-rc1-v2

for you to fetch changes up to 0199849acd07d07e2a8e42757653ca8b14a122f5:

  sysctl: remove register_sysctl_paths() (2023-05-02 19:24:16 -0700)

----------------------------------------------------------------
sysctl-6.4-rc1-v2

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

I have boot tested the last patch and 0-day build completed successfully.

----------------------------------------------------------------
Luis Chamberlain (2):
      kernel: pid_namespace: simplify sysctls with register_sysctl()
      sysctl: remove register_sysctl_paths()

 fs/proc/proc_sysctl.c     | 55 ++++-------------------------------------------
 include/linux/sysctl.h    | 12 -----------
 kernel/pid_namespace.c    |  3 +--
 kernel/pid_sysctl.h       |  3 +--
 scripts/check-sysctl-docs | 16 --------------
 5 files changed, 6 insertions(+), 83 deletions(-)
