Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8072338C8
	for <patches@lists.linux.dev>; Wed, 16 Feb 2022 23:03:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=04yGtd4f6eZlW79JD0OqJAH/1ApQze5QxrUuo4E2UT4=; b=GKk3MtOpenGles+Y5HPX9ZzCfx
	G/OH8YLgkJVRJ29VUNGY0DgW//NXH++WS3lxn0qlc/tfLnegf9pRwLaq1KjLuXG2U1R08ekcjHnOi
	1euTBRcZxOv410lMH3ycK45MgoZA9S5EaTJ9tspSCL7DQZVrr1RKr4oeUmtBXGkH22J0pH4wgr1ys
	yU68P7i1s6NnFO4c0q2PuQ72hP0Bw615HZCFyRFV6h/a2abtbcREin4Jxi/2fMv2y/WtuUgOK4ALw
	G9fnIW9c2+azk8tGYQuL1aRZbzbkO8OzyNDHm52lNQ1mveoBn8CGmsGVkEMWeKa95O+GxBEFBTcn6
	0F5s2nVw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
	id 1nKTKy-008VBD-1X; Wed, 16 Feb 2022 23:03:52 +0000
Date: Wed, 16 Feb 2022 15:03:52 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Jessica Yu <jeyu@kernel.org>, Colin Ian King <colin.king@intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	patches@lists.linux.dev,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-modules@vger.kernel.org, Aaron Tomlin <atomlin@redhat.com>,
	Vimal Agrawal <avimalin@gmail.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Michal Suchanek <msuchanek@suse.de>
Subject: Modules fixes for v5.17-rc5
Message-ID: <Yg2C2NTphV3eMkUp@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Luis Chamberlain <mcgrof@infradead.org>

Linus,

So far only one fix has trickled through for modules. It is part of this
pull request. It's a minor build fix for when CONFIG_SYSFS=n. Let me
know if there are any issues with this.

And just small heads up for v5.18 I'm actually not seeing anything quite
ready so you may not see any pull request for me then except for fixes.
There is quite a bit of development work for modules though, but nothing is
quite ready, and I want to get **tons** of testing done for that. But do
expect substantial changes for v5.19 though. There is work which you might
see for a v5.19 from Aaron, Christophe, Vimal and Michal, in that order. I'm
Cc'ing them just as a heads up to them as well in so far as my expectations
and test requirements. During v5.18 I expect modules-next to carry all
the pending changes and test the hell out of them on linux-next though.

The following changes since commit 3593030761630e09200072a4bd06468892c27be3:

  tty: n_tty: do not look ahead for EOL character past the end of the buffer (2022-02-16 10:13:23 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/modules-5.17-rc5

for you to fetch changes up to a8e8f851e8299703a005cf23dfb9ec854a2611e5:

  module: fix building with sysfs disabled (2022-02-16 12:51:32 -0800)

----------------------------------------------------------------
Fixes module decompression when CONFIG_SYSFS=n

The only fix trickled down for v5.17-rc cycle so far is
the fix for module decompression when CONFIG_SYSFS=n. This
was reported through 0-day.

----------------------------------------------------------------
Dmitry Torokhov (1):
      module: fix building with sysfs disabled

 kernel/module_decompress.c | 2 ++
 1 file changed, 2 insertions(+)
