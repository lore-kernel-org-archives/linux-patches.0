Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 694031EC012;
	Tue,  7 Jan 2025 13:05:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736255102; cv=none; b=Mn0p/7R0RkD5JLK9N0MoCufDKj59uTdfM1pz4Cm7xzE8tPEwMqOgTdw18sOkc4uTkzUGPfz+aTD8JSW/+AeZHNrE25fONyrJgvEPgDSNS7ViWfJrKQz4gB47eSlpoRxRMHWfJeHpvrFg8kdXUkPDOE+vcBwExQTNnkaBsXb5Xv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736255102; c=relaxed/simple;
	bh=fzQJ5DSo4tOwiKG/WioIWvOiZMoaV8kr97wO8nrdETQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uSlGUO56AgpG3QBo603hdsAaqreupMJFegTZxzX36vAVRU3dNRJkvEaNqIzYKmaWh6+RKPP7UJiRUJqwAaCrEsUSgVxADdhqO6mzrBJxYGDbmn0hdOhGvsl6J+lqC+7V/vp/hCDOOfygf0XO0BkLVHQDCXBdLkIRP1qK1zPgfs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I5bUaUT4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I5bUaUT4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A696C4CED6;
	Tue,  7 Jan 2025 13:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736255102;
	bh=fzQJ5DSo4tOwiKG/WioIWvOiZMoaV8kr97wO8nrdETQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I5bUaUT49/Ja30/xOIfqPMTU7INb09OZds5z1uASo5X/I92AdpowcWdWTGjql3psW
	 kdqwd0qU+/U+aRSZ0XST2K0AOpAAIQtayEGvFjCFy78W1cL9Z1Ogz7JQsFilZQ6R1F
	 7ZXg9icu1Fio2MR9Nu4zUtZFGE3cII1ZkEG83enY=
Date: Tue, 7 Jan 2025 14:04:58 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ilya Dryomov <idryomov@gmail.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Patrick Donnelly <pdonnell@redhat.com>,
	Milind Changire <mchangir@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 118/222] ceph: print cluster fsid and client
 global_id in all debug logs
Message-ID: <2025010737-fancy-blurb-f510@gregkh>
References: <20250106151150.585603565@linuxfoundation.org>
 <20250106151155.069105214@linuxfoundation.org>
 <CAOi1vP9_s3oW8XP6bytvKm3JocPO0-odkv9LQFuuEU==JBgfaw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOi1vP9_s3oW8XP6bytvKm3JocPO0-odkv9LQFuuEU==JBgfaw@mail.gmail.com>

On Tue, Jan 07, 2025 at 01:21:12PM +0100, Ilya Dryomov wrote:
> On Mon, Jan 6, 2025 at 4:28 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > 6.6-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Xiubo Li <xiubli@redhat.com>
> >
> > [ Upstream commit 38d46409c4639a1d659ebfa70e27a8bed6b8ee1d ]
> >
> > Multiple CephFS mounts on a host is increasingly common so
> > disambiguating messages like this is necessary and will make it easier
> > to debug issues.
> >
> > At the same this will improve the debug logs to make them easier to
> > troubleshooting issues, such as print the ino# instead only printing
> > the memory addresses of the corresponding inodes and print the dentry
> > names instead of the corresponding memory addresses for the dentry,etc.
> >
> > Link: https://tracker.ceph.com/issues/61590
> > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>
> > Reviewed-by: Milind Changire <mchangir@redhat.com>
> > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > Stable-dep-of: 550f7ca98ee0 ("ceph: give up on paths longer than PATH_MAX")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >  fs/ceph/acl.c        |   6 +-
> >  fs/ceph/addr.c       | 279 +++++++++--------
> >  fs/ceph/caps.c       | 710 +++++++++++++++++++++++++------------------
> >  fs/ceph/crypto.c     |  39 ++-
> >  fs/ceph/debugfs.c    |   6 +-
> >  fs/ceph/dir.c        | 218 +++++++------
> >  fs/ceph/export.c     |  39 +--
> >  fs/ceph/file.c       | 245 ++++++++-------
> >  fs/ceph/inode.c      | 485 ++++++++++++++++-------------
> >  fs/ceph/ioctl.c      |  13 +-
> >  fs/ceph/locks.c      |  57 ++--
> >  fs/ceph/mds_client.c | 558 +++++++++++++++++++---------------
> >  fs/ceph/mdsmap.c     |  24 +-
> >  fs/ceph/metric.c     |   5 +-
> >  fs/ceph/quota.c      |  29 +-
> >  fs/ceph/snap.c       | 174 ++++++-----
> >  fs/ceph/super.c      |  70 +++--
> >  fs/ceph/super.h      |   6 +
> >  fs/ceph/xattr.c      |  96 +++---
> >  19 files changed, 1747 insertions(+), 1312 deletions(-)
> 
> Hi Greg,
> 
> This is a huge patch, albeit mostly mechanical.  Commit 550f7ca98ee0
> ("ceph: give up on paths longer than PATH_MAX") for which this patch is
> a dependency just removes the affected log message, so it could be
> backported with a trivial conflict resolution instead of taking in
> 5c5f0d2b5f92 ("libceph: add doutc and *_client debug macros support")
> and 38d46409c463 ("ceph: print cluster fsid and client global_id in all
> debug logs") to arrange for a "clean" backport.
> 

Great, can you send such a backport?

> Were these cherry picks done in an automated fashion by a tool that
> tries to identify and pull prerequisite patches based on "git blame"
> output?

Yes.

> The result appears to go against the rules laid out in
> Documentation/process/stable-kernel-rules.rst (particularly the limit
> on the number of lines), so I wanted to clarify the expected workflow
> of the stable team in this area.  Are "clean" backports considered to
> justify additional prerequisite patches of this size even when the
> conflict resolution is "take ours" or otherwise trivial?

Yes.  Keeping the tree in sync is almost always preferred over "one-off"
changes that have to be hand-provided, when the maintainer is not
involved to ensure that we don't break anything.  But if you want to
provide a working patch that you think should do the same thing without
these dep-of: patches, that would be great!

thanks,

greg k-h
