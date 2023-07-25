Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B5B825140
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 17:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690307418;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=ofcHR9i21vUkgd+y9BiEJpoyobnlC1eSUMdsvDQGlv0=;
	b=cfnmv56o6nKntinGONy917p/k2EI5xZyb7jIYjOKhu+eLX7owoaIY9LkAb1PG9arngP/8c
	WtAHEBXU16ik+DnS2xqKOcPmkkTBok3BBTchOJPB5o2l7MnU860kTc3TIAiXwuoND5Lyer
	/Amq9LoYhhfYPt1emL1uiW+0ta9y9YI=
Received: from mail-pl1-f197.google.com (mail-pl1-f197.google.com
 [209.85.214.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-170-a-krUVGxPd-mNtnIaGESbg-1; Tue, 25 Jul 2023 13:50:15 -0400
X-MC-Unique: a-krUVGxPd-mNtnIaGESbg-1
Received: by mail-pl1-f197.google.com with SMTP id d9443c01a7336-1bbb7ae553aso7899045ad.3
        for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:50:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690307414; x=1690912214;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ofcHR9i21vUkgd+y9BiEJpoyobnlC1eSUMdsvDQGlv0=;
        b=N6e0zLyHcJKxYPT9gV+htM6NZYaPwTLlQKAHjE/KmBDqz/8DaMQLqd2ZOeFgibh4gX
         2HLpMi3NOtsWJzOeG55hbDgb+obohnJweHExtutg7wK5kDrTLYXfdnbRwk+wYISsCJEK
         2kaxIBVSJGDn8ThBnDjUOnhPctHNYhtugzlwM2+ajIskcKImj52ZAwWdvyuJ0uhQpbwO
         pRwAT4BnY6whtgdKqav1AQHQquuyI4gF37BfZiUvf98W8bsmanb4x5ATLz9fbuWMGxRH
         Hn9TR/oLoPFSe+D85nKVRcKv22kwP5JDRKtky8fAxdDLtkllxqxbgTUHu5HIqskstJ9y
         EqMg==
X-Gm-Message-State: ABy/qLbbVRmSImLOUZ0SmqstvNXA+W1yK4vXgS5QDyc+XZSZ7KhLpb72
	ThXHLWmSnufYXtwlS3Eu8iUzjHMmSvz7zQ/HTqtH5IjfSWSd1lJoDlPLsoy3ggS/87VPiNHL3Wy
	0Iwt86HnuA9VJ/PZuGUpST3iaHvfwuFE=
X-Received: by 2002:a17:902:e890:b0:1b6:4bbd:c3b6 with SMTP id w16-20020a170902e89000b001b64bbdc3b6mr13434243plg.9.1690307413932;
        Tue, 25 Jul 2023 10:50:13 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHNsSBHwJphNTbtkW9JruDV0UxK7MpgcFSpPmHbJ+8/6yHsKeFpz31cLMGPa//IoEFaj7H+SQ==
X-Received: by 2002:a17:902:e890:b0:1b6:4bbd:c3b6 with SMTP id w16-20020a170902e89000b001b64bbdc3b6mr13434227plg.9.1690307413590;
        Tue, 25 Jul 2023 10:50:13 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id f20-20020a170902ab9400b001bb7a736b46sm7734730plr.104.2023.07.25.10.50.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 10:50:13 -0700 (PDT)
Date: Wed, 26 Jul 2023 01:50:09 +0800
From: Zorro Lang <zlang@redhat.com>
To: "Darrick J. Wong" <djwong@kernel.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>, fstests@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH] fstests: add helper to canonicalize devices used to
 enable persistent disks
Message-ID: <20230725175009.jv4hbqxtags6qh5r@zlang-mailbox>
References: <20230720061727.2363548-1-mcgrof@kernel.org>
 <20230725081307.xydlwjdl4lq3ts3m@zlang-mailbox>
 <20230725155439.GF11340@frogsfrogsfrogs>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230725155439.GF11340@frogsfrogsfrogs>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 25, 2023 at 08:54:39AM -0700, Darrick J. Wong wrote:
> On Tue, Jul 25, 2023 at 04:13:07PM +0800, Zorro Lang wrote:
> > On Wed, Jul 19, 2023 at 11:17:27PM -0700, Luis Chamberlain wrote:
> > > The filesystem configuration file does not allow you to use symlinks to
> > > devices given the existing sanity checks verify that the target end
> > > device matches the source.
> > > 
> > > Using a symlink is desirable if you want to enable persistent tests
> > > across reboots. For example you may want to use /dev/disk/by-id/nvme-eui.*
> > > so to ensure that the same drives are used even after reboot. This
> > > is very useful if you are testing for example with a virtualized
> > > environment and are using PCIe passthrough with other qemu NVMe drives
> > > with one or many NVMe drives.
> > > 
> > > To enable support just add a helper to canonicalize devices prior to
> > > running the tests.
> > > 
> > > This allows one test runner, kdevops, which I just extended with
> > > support to use real NVMe drives. The drives it uses for the filesystem
> > > configuration optionally is with NVMe eui symlinks so to allow
> > > the same drives to be used over reboots.
> > > 
> > > Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> > > ---
> > 
> > Hi Luis,
> > 
> > Hmmm... this's a default behavior change for fstests, although I'm not sure
> > what will be affect. I'm wondering if we should do this in fstests. I don't
> > want to tell the users that the device names they give to fstests will always
> > be truned to real names from now on.
> > 
> > Generally the users of fstests provide the device names, so the users
> > might need to take care of the name is "/dev/mapper/testvg-testdev"
> > or "/dev/dm-4". The users can deal with the device names when their
> > script prepare to run fstests.
> > 
> > If more developers prefer this change, I'd like to make it to be
> > optional by an option of ./check at least, not always turn devname
> > to realpath. Welcome review points from others.
> 
> Hmm.  SCRATCH_DEV=/dev/testvg/testlv works right now, it'd be sort of
> annoying to have "/dev/dm-4" get written into the report and then you've
> lost the correlation to whatever the user passed in.
> 
> Oh wait.  My giant mound of ./check wrapper script already does that
> canonicalization and has for years.
> 
> Ok.  Sounds good to me then. :P

So you hope fstests can do this translation (use real device name) by default?

> 
> > >  check         |  1 +
> > >  common/config | 44 +++++++++++++++++++++++++++++++++++++++++++-
> > >  2 files changed, 44 insertions(+), 1 deletion(-)
> > > 
> > > diff --git a/check b/check
> > > index 89e7e7bf20df..d063d3f498fd 100755
> > > --- a/check
> > > +++ b/check
> > > @@ -734,6 +734,7 @@ function run_section()
> > >  	fi
> > >  
> > >  	get_next_config $section
> > > +	_canonicalize_devices
> > >  
> > >  	mkdir -p $RESULT_BASE
> > >  	if [ ! -d $RESULT_BASE ]; then
> > > diff --git a/common/config b/common/config
> > > index 936ac225f4b1..f5a3815a0435 100644
> > > --- a/common/config
> > > +++ b/common/config
> > > @@ -655,6 +655,47 @@ _canonicalize_mountpoint()
> > >  	echo "$parent/$base"
> > >  }
> > >  
> > > +# Enables usage of /dev/disk/by-id/ symlinks to persist target devices
> > > +# over reboots
> > > +_canonicalize_devices()
> > > +{
> > > +	if [ ! -z "$TEST_DEV" ] && [ -L $TEST_DEV ]; then
> > 
> > I think [ -L "$TEST_DEV" ] is enough.
> 
> I don't think it is.
> 
> $ unset moo
> $ [ -L $moo ]

The double quotation marks "" are needed.

> $ echo $?
> 0
> $ realpath -e $moo
> realpath: missing operand
> Try 'realpath --help' for more information.
> 
> > > +		TEST_DEV=$(realpath -e $TEST_DEV)
> > 
> > Anyone knows the difference of realpatch and readlink?
> 
> readlink doesn't follow nested symlinks; realpath does:
> 
> $ touch /tmp/a
> $ ln -s /tmp/a /tmp/b
> $ ln -s /tmp/b /tmp/c
> $ readlink /tmp/c
> /tmp/b
> $ realpath /tmp/c
> /tmp/a
> $ readlink -m /tmp/c
> /tmp/a

The -e option helps:

# readlink -e /tmp/c
/tmp/a
# realpath -e /tmp/c
/tmp/a

> 
> > > +	fi
> > > +
> > > +	if [ ! -z "$SCRATCH_DEV" ] && [ -L $SCRATCH_DEV ]; then
> > > +		SCRATCH_DEV=$(realpath -e $SCRATCH_DEV)
> 
> Extra question: Shouldn't we be putting theis ^^^ variables in quotes?

Make sense to me.

Thanks,
Zorro

> 
> Supposing someone starts passing in
> SCRATCH_DEV=/dev/disk/by-label/har har"
> 
> This expression will barf everywhere:
> 
> $ SCRATCH_DEV=$(realpath -e $SCRATCH_DEV)
> realpath: /dev/disk/by-label/har: No such file or directory
> realpath: har: No such file or directory
> 
> Due to the lack of quoting on its way to turning that into /dev/sda3.
> Granted fstests has historically required no spaces in anything, but
> still, it's bad hygiene.
> 
> [writing anything in bash is bad hygiene, but for the sweet sweet pipe
> goodness]
> 
> > > +	fi
> > > +
> > > +	if [ ! -z "$TEST_LOGDEV" ] && [ -L $TEST_LOGDEV ]; then
> > > +		TEST_LOGDEV=$(realpath -e $TEST_LOGDEV)
> > > +	fi
> > > +
> > > +	if [ ! -z "$TEST_RTDEV" ] && [ -L $TEST_RTDEV ]; then
> > > +		TEST_RTDEV=$(realpath -e $TEST_RTDEV)
> > > +	fi
> > > +
> > > +	if [ ! -z "$SCRATCH_RTDEV" ] && [ -L $SCRATCH_RTDEV ]; then
> > > +		SCRATCH_RTDEV=$(realpath -e $SCRATCH_RTDEV)
> > > +	fi
> > > +
> > > +	if [ ! -z "$LOGWRITES_DEV" ] && [ -L $LOGWRITES_DEV ]; then
> > > +		LOGWRITES_DEV=$(realpath -e $LOGWRITES_DEV)
> > > +	fi
> > > +
> > > +	if [ ! -z "$SCRATCH_DEV_POOL" ]; then
> > > +		NEW_SCRATCH_POOL=""
> > > +		for i in $SCRATCH_DEV_POOL; do
> > > +			if [ -L $i ]; then
> > > +				NEW_SCRATCH_POOL="$NEW_SCRATCH_POOL $(realpath -e $i)"
> > > +			else
> > > +				NEW_SCRATCH_POOL="$NEW_SCRATCH_POOL $i)"
> >                                                                      ^^^
> > 
> > What's this half ")" for ?
> 
> Some kind of typo, I assume...
> 
> --D
> 
> > 
> > Thanks,
> > Zorro
> > 
> > 
> > > +			fi
> > > +		done
> > > +		SCRATCH_DEV_POOL="$NEW_SCRATCH_POOL"
> > > +	fi
> > > +}
> > > +
> > >  # On check -overlay, for the non multi section config case, this
> > >  # function is called on every test, before init_rc().
> > >  # When SCRATCH/TEST_* vars are defined in config file, config file
> > > @@ -785,7 +826,6 @@ get_next_config() {
> > >  	fi
> > >  
> > >  	parse_config_section $1
> > > -
> > >  	if [ ! -z "$OLD_FSTYP" ] && [ $OLD_FSTYP != $FSTYP ]; then
> > >  		[ -z "$MOUNT_OPTIONS" ] && _mount_opts
> > >  		[ -z "$TEST_FS_MOUNT_OPTS" ] && _test_mount_opts
> > > @@ -901,5 +941,7 @@ else
> > >  	fi
> > >  fi
> > >  
> > > +_canonicalize_devices
> > > +
> > >  # make sure this script returns success
> > >  /bin/true
> > > -- 
> > > 2.39.2
> > > 
> > 
> 

