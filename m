Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A9BE1DA33
	for <patches@lists.linux.dev>; Wed, 26 Jul 2023 16:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Jpqp2YP168gbIvGSKxOfPUl7nleHM5Mjb5NJJ+LbOQE=; b=xRoJcZVvl6iJJ88vsjo/XnQJFL
	SZpq2dgdbpT1Pq1g5mExcn+E8LnYtfGE3vtFn0iSsZyD2w7a0nQLJWjnyW5K+K9bZz3Gtc5tAIs6o
	HNSdBzRI8XLC9QXNMF9CZ6U56Myz3lv8rZdifmunoEV7LzZxMt7sNyW/YFWXFeikZnWMAF1awRvs9
	L4tQheeiid+rzxChSupLmabXdqRu33f39aL3qvQnd32rYIASE+GcgRtu/qn4Z2xE2mgkJnylpOnT5
	X3AdzbhQW7m1u80CeopAF6adlQXI1hD6LT64QTTkaRSC1PCTLvVfrF6FPY4JANyW+399Za/gK+w5i
	R+1O5SGA==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
	id 1qOhN9-00B0HX-10;
	Wed, 26 Jul 2023 16:28:23 +0000
Date: Wed, 26 Jul 2023 09:28:23 -0700
From: Luis Chamberlain <mcgrof@kernel.org>
To: Theodore Ts'o <tytso@mit.edu>
Cc: "Darrick J. Wong" <djwong@kernel.org>, Zorro Lang <zlang@redhat.com>,
	fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] fstests: add helper to canonicalize devices used to
 enable persistent disks
Message-ID: <ZMFJp5OZN3vnT/yI@bombadil.infradead.org>
References: <20230720061727.2363548-1-mcgrof@kernel.org>
 <20230725081307.xydlwjdl4lq3ts3m@zlang-mailbox>
 <20230725155439.GF11340@frogsfrogsfrogs>
 <20230726044132.GA30264@mit.edu>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230726044132.GA30264@mit.edu>
Sender: Luis Chamberlain <mcgrof@infradead.org>

On Wed, Jul 26, 2023 at 12:41:32AM -0400, Theodore Ts'o wrote:
> On Tue, Jul 25, 2023 at 08:54:39AM -0700, Darrick J. Wong wrote:
> > On Tue, Jul 25, 2023 at 04:13:07PM +0800, Zorro Lang wrote:
> > > On Wed, Jul 19, 2023 at 11:17:27PM -0700, Luis Chamberlain wrote:
> > > > The filesystem configuration file does not allow you to use symlinks to
> > > > devices given the existing sanity checks verify that the target end
> > > > device matches the source.
> 
> I'm a little confused.  Where are these "sanity checks" enforced?
> I've been using
> 
> SCRATCH_DEV=/dev/mapper/xt-vdc
> 
> where /dev/mapper/xt-vdc is a symlink to /dev/dm-4 (or some such)
> without any problems.  So I don't quite understand why we need to
> canonicalize devices?

That might work, but try using /dev/disk/by-id/ stuff, that'll bust. So
to keep existing expecations by fstests, it's needed.

  Luis
