Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABD8613AD0
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 08:13:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1690272793;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=NVFlpvoBG2Pd8ROblvK7dT35aA2f9UXwu06vV3Or/NA=;
	b=OeGPpe1vX6rkNjSacJ7OVh/IqR7AN6eTAzpuB7u+vLFCkpee2xH1bvsvBsDTB5M90clLBX
	3P999EGOZB2Jm1OytbcIxZ9qzOS/W8JrzDIZy6UerdKe83t5tywyu9qq0959p0jMTVMnvu
	lW74v/bJCuog8DKj3iZF5Qz2phWdig8=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-379-SBYWSD8vMyKAMCoXJRMLtg-1; Tue, 25 Jul 2023 04:13:12 -0400
X-MC-Unique: SBYWSD8vMyKAMCoXJRMLtg-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1bba5563cd6so8731345ad.3
        for <patches@lists.linux.dev>; Tue, 25 Jul 2023 01:13:12 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690272791; x=1690877591;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NVFlpvoBG2Pd8ROblvK7dT35aA2f9UXwu06vV3Or/NA=;
        b=RnptYptAmjZpUzfKuIjpm3FldKqV2BnGXB1SU51acSXDOF7XZE0NB9CvfNPDwJmgQc
         khOB64LsCbfKuenUF1NH6PtDnoAcYiZMswmpggYgVb4QAu1+bjdKA9SSPGPfKrRq9YOK
         l7Q5tcFGaSqb6FNbhgKhiOgx2jlfN0y7ihfSs9LdTnxTVcTuRUo4up6FweDLF1LwW+qz
         jOcsWLCqxKzzSvqwF7s2We3ZSIMkqVyZLm/HBxaDg+qY8n64zi1zhpLY1H4Loq8Wede3
         O774yFtLF2rsCF8Ov2S0pSJZMyfjGtNdMtzhDlVJfT9sVz5ecoTl+6j04CB2YgPFNkjY
         RjBw==
X-Gm-Message-State: ABy/qLZG+2toLXg8Hkn+GcU3AKw/r2ChptALbp3jI4fTyrRFA2TSpXwC
	65W0tiwmjAvtAdUN8lq0skYJ6u7gUWxIcnOfOiYb5Y55mzG8zZuLZxZStwvnCHthGgK/XWNzkfe
	5depAok0XNqxLVVcQBA==
X-Received: by 2002:a17:902:f548:b0:1b9:cac2:362c with SMTP id h8-20020a170902f54800b001b9cac2362cmr12058438plf.4.1690272791183;
        Tue, 25 Jul 2023 01:13:11 -0700 (PDT)
X-Google-Smtp-Source: APBJJlEq1fexnKTyNCUR/yxdcgQOvSDPp01kvwpLQVONYeZSgHJc/XafdI7Sh+/hed7HrS5zH9QEpg==
X-Received: by 2002:a17:902:f548:b0:1b9:cac2:362c with SMTP id h8-20020a170902f54800b001b9cac2362cmr12058424plf.4.1690272790838;
        Tue, 25 Jul 2023 01:13:10 -0700 (PDT)
Received: from zlang-mailbox ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id o10-20020a170902bcca00b001b850c9af71sm10285837pls.285.2023.07.25.01.13.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 Jul 2023 01:13:10 -0700 (PDT)
Date: Tue, 25 Jul 2023 16:13:07 +0800
From: Zorro Lang <zlang@redhat.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: fstests@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH] fstests: add helper to canonicalize devices used to
 enable persistent disks
Message-ID: <20230725081307.xydlwjdl4lq3ts3m@zlang-mailbox>
References: <20230720061727.2363548-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230720061727.2363548-1-mcgrof@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 19, 2023 at 11:17:27PM -0700, Luis Chamberlain wrote:
> The filesystem configuration file does not allow you to use symlinks to
> devices given the existing sanity checks verify that the target end
> device matches the source.
> 
> Using a symlink is desirable if you want to enable persistent tests
> across reboots. For example you may want to use /dev/disk/by-id/nvme-eui.*
> so to ensure that the same drives are used even after reboot. This
> is very useful if you are testing for example with a virtualized
> environment and are using PCIe passthrough with other qemu NVMe drives
> with one or many NVMe drives.
> 
> To enable support just add a helper to canonicalize devices prior to
> running the tests.
> 
> This allows one test runner, kdevops, which I just extended with
> support to use real NVMe drives. The drives it uses for the filesystem
> configuration optionally is with NVMe eui symlinks so to allow
> the same drives to be used over reboots.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---

Hi Luis,

Hmmm... this's a default behavior change for fstests, although I'm not sure
what will be affect. I'm wondering if we should do this in fstests. I don't
want to tell the users that the device names they give to fstests will always
be truned to real names from now on.

Generally the users of fstests provide the device names, so the users
might need to take care of the name is "/dev/mapper/testvg-testdev"
or "/dev/dm-4". The users can deal with the device names when their
script prepare to run fstests.

If more developers prefer this change, I'd like to make it to be
optional by an option of ./check at least, not always turn devname
to realpath. Welcome review points from others.

>  check         |  1 +
>  common/config | 44 +++++++++++++++++++++++++++++++++++++++++++-
>  2 files changed, 44 insertions(+), 1 deletion(-)
> 
> diff --git a/check b/check
> index 89e7e7bf20df..d063d3f498fd 100755
> --- a/check
> +++ b/check
> @@ -734,6 +734,7 @@ function run_section()
>  	fi
>  
>  	get_next_config $section
> +	_canonicalize_devices
>  
>  	mkdir -p $RESULT_BASE
>  	if [ ! -d $RESULT_BASE ]; then
> diff --git a/common/config b/common/config
> index 936ac225f4b1..f5a3815a0435 100644
> --- a/common/config
> +++ b/common/config
> @@ -655,6 +655,47 @@ _canonicalize_mountpoint()
>  	echo "$parent/$base"
>  }
>  
> +# Enables usage of /dev/disk/by-id/ symlinks to persist target devices
> +# over reboots
> +_canonicalize_devices()
> +{
> +	if [ ! -z "$TEST_DEV" ] && [ -L $TEST_DEV ]; then

I think [ -L "$TEST_DEV" ] is enough.

> +		TEST_DEV=$(realpath -e $TEST_DEV)

Anyone knows the difference of realpatch and readlink?

> +	fi
> +
> +	if [ ! -z "$SCRATCH_DEV" ] && [ -L $SCRATCH_DEV ]; then
> +		SCRATCH_DEV=$(realpath -e $SCRATCH_DEV)
> +	fi
> +
> +	if [ ! -z "$TEST_LOGDEV" ] && [ -L $TEST_LOGDEV ]; then
> +		TEST_LOGDEV=$(realpath -e $TEST_LOGDEV)
> +	fi
> +
> +	if [ ! -z "$TEST_RTDEV" ] && [ -L $TEST_RTDEV ]; then
> +		TEST_RTDEV=$(realpath -e $TEST_RTDEV)
> +	fi
> +
> +	if [ ! -z "$SCRATCH_RTDEV" ] && [ -L $SCRATCH_RTDEV ]; then
> +		SCRATCH_RTDEV=$(realpath -e $SCRATCH_RTDEV)
> +	fi
> +
> +	if [ ! -z "$LOGWRITES_DEV" ] && [ -L $LOGWRITES_DEV ]; then
> +		LOGWRITES_DEV=$(realpath -e $LOGWRITES_DEV)
> +	fi
> +
> +	if [ ! -z "$SCRATCH_DEV_POOL" ]; then
> +		NEW_SCRATCH_POOL=""
> +		for i in $SCRATCH_DEV_POOL; do
> +			if [ -L $i ]; then
> +				NEW_SCRATCH_POOL="$NEW_SCRATCH_POOL $(realpath -e $i)"
> +			else
> +				NEW_SCRATCH_POOL="$NEW_SCRATCH_POOL $i)"
                                                                     ^^^

What's this half ")" for ?


Thanks,
Zorro


> +			fi
> +		done
> +		SCRATCH_DEV_POOL="$NEW_SCRATCH_POOL"
> +	fi
> +}
> +
>  # On check -overlay, for the non multi section config case, this
>  # function is called on every test, before init_rc().
>  # When SCRATCH/TEST_* vars are defined in config file, config file
> @@ -785,7 +826,6 @@ get_next_config() {
>  	fi
>  
>  	parse_config_section $1
> -
>  	if [ ! -z "$OLD_FSTYP" ] && [ $OLD_FSTYP != $FSTYP ]; then
>  		[ -z "$MOUNT_OPTIONS" ] && _mount_opts
>  		[ -z "$TEST_FS_MOUNT_OPTS" ] && _test_mount_opts
> @@ -901,5 +941,7 @@ else
>  	fi
>  fi
>  
> +_canonicalize_devices
> +
>  # make sure this script returns success
>  /bin/true
> -- 
> 2.39.2
> 

