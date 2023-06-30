Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C34AAD45
	for <patches@lists.linux.dev>; Fri, 30 Jun 2023 23:53:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:Content-Type:MIME-Version:
	Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=tBguVH6T/Ggb9KVY+w61Ct5mLTCQ9Iqp8l22Kr6DhxI=; b=MabUXmWDLVXSP2c2FuXcWIDfp1
	uUvyGklSWvPYC71KNDgurI2Y/1FclgUWbLmkS5nNRfp+1I/4prXDlmr/7DbL36Ij1kO+ErvMDp7Dm
	c0I40RudgurdGpW44pDi3U2yaMerbJKU4vnlqA4VP+SUTRdmWHBEtqkOHFyKrSz+ibBjbfLQENpyv
	sjUJGrF1XSW8qnNtUp50UbdxU5WiKEEjVoZ2yHrRshXqMx0F0zOu7NmHaXrFP3Y9j61oYVS1eThxS
	2Nsc1k6IZQflMH0tMy4VacldcwMqWeb6sf/MUucg0vptusfBvXG9QPkM/2YxxFdBYXtpSwDABu9eL
	fMr3jZZw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1qFNvE-004nU5-2m;
	Fri, 30 Jun 2023 23:53:04 +0000
Date: Fri, 30 Jun 2023 16:53:04 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: trix@redhat.com, keescook@chromium.org, ebiederm@xmission.com,
	yzaikin@google.com, j.granados@samsung.com, patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	mcgrof@kernel.org
Subject: [GIT PULL] second set of sysctl fixes v6.5-rc1
Message-ID: <ZJ9q4AUkeaENryE7@bombadil.infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: Luis Chamberlain <mcgrof@infradead.org>

The following changes since commit b25f62ccb490680a8cee755ac4528909395e0711:

  Merge tag 'vfio-v6.5-rc1' of https://github.com/awilliam/linux-vfio (2023-06-30 15:22:09 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux.git/ tags/sysctl-fixes-v2-v6.4-rc1

for you to fetch changes up to 7fffbc71075dcb733068d711c2593127cdce86f0:

  sysctl: set variable sysctl_mount_point storage-class-specifier to static (2023-06-30 16:19:47 -0700)

----------------------------------------------------------------
sysctl-fixes-v2-v6.4-rc1

Just one minor nit I forgot to merge.

----------------------------------------------------------------
Tom Rix (1):
      sysctl: set variable sysctl_mount_point storage-class-specifier to static

 fs/proc/proc_sysctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
