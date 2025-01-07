Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F0001EF08D
	for <patches@lists.linux.dev>; Tue,  7 Jan 2025 15:52:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736265163; cv=none; b=GkZ/qlKd/yYQNQscoKz0AuWQVfp6DGmrctzOsttExoTs2H1AZpjRYfDO/slSA8E+4Ccc1rKHYybrAPK6rdGneCsX85CSuAioZK7iVtwJ2nTTrYdBmwNQERYym1ShmZzQkcU4cGjyN0re0yk9UtzyaToZebfeEwdATogBxHsp4iA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736265163; c=relaxed/simple;
	bh=Y3K6VnkTj0agsEpHyH49R+8Yy718tcYTrz5OV5nifrg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VLS9UMhYDwtwFq8D1F/nUVHej3JGrN+J5/TZQE8lnaDm7UskjLyXA7Y6CxYkMyYf+V718VMaYFdhKeNorSMI132mcsKEpgYR9QFmvb4v457CvRr3pFUQQMuSe0B/0jINiwl7/t+ndeqe565uTkZcin6JSEIaY3KubCKNZIJYWVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JBxHfvJ0; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JBxHfvJ0"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2164b662090so203652275ad.1
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 07:52:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736265158; x=1736869958; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5akAFf1ZPesAMt6W0eaVJbcjKXPbLry7I/lEXkZAboA=;
        b=JBxHfvJ0hsli5XaQfbfSyzNCj6bjkOSOi+LJeGZ9q35SE1vAeBrVpf0doYarhFEz2b
         wIALuDVSyshKbD7WlI2nei1QcFs6NEuW/GM3kZCfBYOV5P+gDxDH4O/SrnDth8EcUaKr
         2egURTkqyGNZ5rMJ1Sar5DRdG3pQoys7kDc1FqiXHwlaSAJGnnUFMwsVBxxxdjqhlVvO
         8JffMiU7QrjaKsiU58Bbmi7EEsRwjqtoqh1pgpesfBxyV87BOYSNZnggJRuMsUABygkN
         EDoOiLk4cLrJ/q1QEGvazgqSqzni1wSvBIlRoBJieLt2fp7MVyciMzDsnV2bx7gcMW8B
         WfNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736265158; x=1736869958;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5akAFf1ZPesAMt6W0eaVJbcjKXPbLry7I/lEXkZAboA=;
        b=oP6HIcyMYolk2p47UX6TsviICjXjg5+6OT76pkhaIrDzkj0jYQpGr+9SIr4aHrlif/
         7HaEhyl6nCWwC5BYtawVj81IxK6QtZdW3Dv5CZuqpSVsqpQlX5kQhF9vq41IGp/USaBK
         QlX42I25XiwD6buo9jreDoyhOnA0hv/oxNZ6XEqo+oWCDx4DEkuGzyomF83Aj8G32YMY
         XR25MMcfjxTCD+uxaXXcfGyk2nfGEcPZ/KMcGj51oaW5wogBto8q/F2CgXT29ZS7YQpI
         HWZIG1tWio2nS0cl5NbgGiDgkjdfO8LCi/1zyrYgoGQzcPaObnkD8d3qa764bemK7obR
         Ptfg==
X-Forwarded-Encrypted: i=1; AJvYcCVFHcZdwduEFpoaaDQkeTnpFNVw+lsbdFx1tikziTwckB69kO9FT9h8Uf50Ux9TWCn6Ie27gcaQ@lists.linux.dev
X-Gm-Message-State: AOJu0YxE/Obm8WHDVEyU1Vh+/h//HE/1tdWj+/LzEjjvVv6r5XWnL3Rb
	5ptZigs1TCDVrb8FwMISmBTT+NKr+PVwPRA8Y4Rx3ycm/xeUr87LUVCQv8jgPgDrX1sRnidBxLW
	a0xeVlpRxjOGegOcKExbrGABDssk=
X-Gm-Gg: ASbGnctRJILLa+ujIu/34hTXO9F7nHBgQ/UIfyKX1AOljN8Yhd6+ZMk7jmRVgzWKejv
	7H39KvSBgTZnDyUNSaZ5cO2WVM4IvlY+mQyvr5Q==
X-Google-Smtp-Source: AGHT+IH1MJiukfAycq+hK/y+HEGZQSzQHUwwsUw+2RmnbE5MF9cXH6e29VZImIdEQGJyw1Y4KMMtUvA/kp6Z7oPQwDk=
X-Received: by 2002:a17:90b:37c3:b0:2ee:8008:b583 with SMTP id
 98e67ed59e1d1-2f452e2fe28mr96830234a91.16.1736265158427; Tue, 07 Jan 2025
 07:52:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250106151150.585603565@linuxfoundation.org> <20250106151155.069105214@linuxfoundation.org>
 <CAOi1vP9_s3oW8XP6bytvKm3JocPO0-odkv9LQFuuEU==JBgfaw@mail.gmail.com> <2025010737-fancy-blurb-f510@gregkh>
In-Reply-To: <2025010737-fancy-blurb-f510@gregkh>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Tue, 7 Jan 2025 16:52:26 +0100
Message-ID: <CAOi1vP-aoU4mSvVm8OsLozka3=-S_LqroU9VAgZY-ptdrGZ+GA@mail.gmail.com>
Subject: Re: [PATCH 6.6 118/222] ceph: print cluster fsid and client global_id
 in all debug logs
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Xiubo Li <xiubli@redhat.com>, Patrick Donnelly <pdonnell@redhat.com>, 
	Milind Changire <mchangir@redhat.com>, Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 7, 2025 at 2:05=E2=80=AFPM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Jan 07, 2025 at 01:21:12PM +0100, Ilya Dryomov wrote:
> > On Mon, Jan 6, 2025 at 4:28=E2=80=AFPM Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > 6.6-stable review patch.  If anyone has any objections, please let me=
 know.
> > >
> > > ------------------
> > >
> > > From: Xiubo Li <xiubli@redhat.com>
> > >
> > > [ Upstream commit 38d46409c4639a1d659ebfa70e27a8bed6b8ee1d ]
> > >
> > > Multiple CephFS mounts on a host is increasingly common so
> > > disambiguating messages like this is necessary and will make it easie=
r
> > > to debug issues.
> > >
> > > At the same this will improve the debug logs to make them easier to
> > > troubleshooting issues, such as print the ino# instead only printing
> > > the memory addresses of the corresponding inodes and print the dentry
> > > names instead of the corresponding memory addresses for the dentry,et=
c.
> > >
> > > Link: https://tracker.ceph.com/issues/61590
> > > Signed-off-by: Xiubo Li <xiubli@redhat.com>
> > > Reviewed-by: Patrick Donnelly <pdonnell@redhat.com>
> > > Reviewed-by: Milind Changire <mchangir@redhat.com>
> > > Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
> > > Stable-dep-of: 550f7ca98ee0 ("ceph: give up on paths longer than PATH=
_MAX")
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  fs/ceph/acl.c        |   6 +-
> > >  fs/ceph/addr.c       | 279 +++++++++--------
> > >  fs/ceph/caps.c       | 710 +++++++++++++++++++++++++----------------=
--
> > >  fs/ceph/crypto.c     |  39 ++-
> > >  fs/ceph/debugfs.c    |   6 +-
> > >  fs/ceph/dir.c        | 218 +++++++------
> > >  fs/ceph/export.c     |  39 +--
> > >  fs/ceph/file.c       | 245 ++++++++-------
> > >  fs/ceph/inode.c      | 485 ++++++++++++++++-------------
> > >  fs/ceph/ioctl.c      |  13 +-
> > >  fs/ceph/locks.c      |  57 ++--
> > >  fs/ceph/mds_client.c | 558 +++++++++++++++++++---------------
> > >  fs/ceph/mdsmap.c     |  24 +-
> > >  fs/ceph/metric.c     |   5 +-
> > >  fs/ceph/quota.c      |  29 +-
> > >  fs/ceph/snap.c       | 174 ++++++-----
> > >  fs/ceph/super.c      |  70 +++--
> > >  fs/ceph/super.h      |   6 +
> > >  fs/ceph/xattr.c      |  96 +++---
> > >  19 files changed, 1747 insertions(+), 1312 deletions(-)
> >
> > Hi Greg,
> >
> > This is a huge patch, albeit mostly mechanical.  Commit 550f7ca98ee0
> > ("ceph: give up on paths longer than PATH_MAX") for which this patch is
> > a dependency just removes the affected log message, so it could be
> > backported with a trivial conflict resolution instead of taking in
> > 5c5f0d2b5f92 ("libceph: add doutc and *_client debug macros support")
> > and 38d46409c463 ("ceph: print cluster fsid and client global_id in all
> > debug logs") to arrange for a "clean" backport.
> >
>
> Great, can you send such a backport?

Sure, you should have one for 5.10-6.1 and a separate one for 6.6 in
your inbox now.

>
> > Were these cherry picks done in an automated fashion by a tool that
> > tries to identify and pull prerequisite patches based on "git blame"
> > output?
>
> Yes.
>
> > The result appears to go against the rules laid out in
> > Documentation/process/stable-kernel-rules.rst (particularly the limit
> > on the number of lines), so I wanted to clarify the expected workflow
> > of the stable team in this area.  Are "clean" backports considered to
> > justify additional prerequisite patches of this size even when the
> > conflict resolution is "take ours" or otherwise trivial?
>
> Yes.  Keeping the tree in sync is almost always preferred over "one-off"
> changes that have to be hand-provided, when the maintainer is not
> involved to ensure that we don't break anything.  But if you want to

In this case this lead to pulling in

  1 file changed, 38 insertions(+)

and

  19 files changed, 1747 insertions(+), 1312 deletions(-)

patches as dependencies to satisfy the backport of

  1 file changed, 4 insertions(+), 5 deletions(-)

patch.  Is this OK given that stable-kernel-rules.rst still has "It
cannot be bigger than 100 lines, with context." as one of the rules for
what kind of patches are accepted?

Thanks,

                Ilya
