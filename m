Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B0425EFAC
	for <patches@lists.linux.dev>; Wed, 26 Mar 2025 21:10:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743023454; cv=none; b=Z71d744TyTmJ8UPS5i3+d7G0XxVZfQUNAQRjaNoT4cE9EtquB0VJU1d/FON0m9X52MVVFZXvf5CIl9Y4oNwtjTXLXDupYQ+Q6+kYq9aREyqFmsFCmIVeaHBUwXMoVrD+WtLqKu0rPCcZhxsJ8lt5VKlnLp07TPsD/HUhITHiAc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743023454; c=relaxed/simple;
	bh=KtFDJQf3LCeM6WKs6szT70ZPm1vK4ET1jMCs1JH8pQs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oeMdAGECuA4jXXhbqyQG9LI0o1TvzqlmtAaHSlQZeEI7AxjzY7jS9bkwaMTR/gOxp3HKiW6S3r5a9hmBEgyDkTewT21Wh2yUPpHBGgyfWNKQe4Em40fOKugBcvlppbUcXgLLz71qKZgl6NVeCvW7yRbT2Yje9NYz8gzC2chwbUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=nptmnjTC; arc=none smtp.client-ip=209.85.216.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="nptmnjTC"
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-3014cb646ecso321244a91.1
        for <patches@lists.linux.dev>; Wed, 26 Mar 2025 14:10:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1743023451; x=1743628251; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=8r5zblQElbPQO87GHLZRnHgdEdr+1fSpbnjgQJ9+CIo=;
        b=nptmnjTCvolae3sU3kVlJXEQf9t7GfzI+59rGh00FO5N7J8vUe+/a0RrkFG/WNxAv5
         1Xn1k0j8c3vOGx/fg4TkjUerkVNWpsih6j9u5WybCx8j/Eq2rpfTGerB74xhGx/4+uyz
         33iyER4TBQ1e6GedCsH2Yf7c5M4rlhsTCpC8ODCU4XaQ01TtAWl6qf2NQU4er1oRjHaZ
         QnlBbn7/ddVtSBdh0hLwjWjdvozH+qoi2IuvWtDS5jDyoWFqVJ/vldBP3lSLAZX7jHof
         VoDhObanTpdY1qZg5O/XOz5OOao0ETjBk6VHME3yNzpr0iWolWnoQiD6JsgCm+ennx+N
         eQeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743023451; x=1743628251;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8r5zblQElbPQO87GHLZRnHgdEdr+1fSpbnjgQJ9+CIo=;
        b=B2qqTb6eAC/GZDROPC50mU6JsnctSBzz7dGaL6rA19zJ2qSdgKf2Zwd4f+gqpvz0kH
         E46Ks1h8zQNGTbO9oKgRNUrV4LzDQydz9ALgvVsaESqElJL9iBAP0Cr4SfqaAqRqBX0k
         AT/SZsCYvjC8sYBqykDerU3IPZ7f1ewHr1Uc/6AjhRkuZyPFsA8uiEPduu5qbZKhrQaU
         qO20PqMkYANjAVADUt8UTe/hbs1RVTWjOaHB+/yVfguo1iEqcYuKZjKhOe1tRL3qbjYH
         j9IehALbnmaHJTS3wS7s6oTCR9lieeDJTRkPuoiVx6IzA5UtF4psQT8O0Rwbo+nBxSnn
         QdUw==
X-Gm-Message-State: AOJu0YzJbB/x+m3m6vuGoWwhjETj+nz8MyebguBQnG9fcOYXK/T857MB
	fKPePJ6Ut5us+Do71nvnsyVDTlDmqhtqOzO5lyUwNQnzwR+UPR4sqhOKCHv5k7vAkQeQ8yFcJOo
	S
X-Gm-Gg: ASbGncuJH/wCWLPl+4T+bxOqpQscGaR4SWiEC/E4SW2kRjMefGLm4vi3Zrq1EazORWQ
	pcq3u989NPp4UaZfajn0y4qZp6HqqqIa+p5sxMhdNJzhLdiL60CCPCJ2b9C5blun4MgpMEj64A4
	aD2d7WYEHfH1+BlPaIe0wnAhDgJZluyPZ8N2VuwTd5qxx5nATUanE0bFUAuELAsmS0nzrGxQBAm
	vvLZOkvS9TaBiYf5BNL+hJW//stlLUBYIftOqXcIWgbsH3TMWYBbNaT1xiFIb+O2SuFSjpC/MD4
	W02oycFg1xcnG+a10YuiavfEgmHcKK6MHM204Np3TULKS9907arD7IxLS1jvWqRdDR/llTYyIzl
	VdZ2+eK4=
X-Google-Smtp-Source: AGHT+IH74ag5XeN4ls7BanUgMSLHcrsUvl+HEw2fiukQfAGjZxR0vReelBylQGQRPmjYWqz5PrQAvw==
X-Received: by 2002:a17:90a:d2cb:b0:2ff:7b28:a51a with SMTP id 98e67ed59e1d1-303a815a72cmr2059828a91.17.1743023450937;
        Wed, 26 Mar 2025 14:10:50 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-227811b2ae1sm114999645ad.114.2025.03.26.14.10.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Mar 2025 14:10:50 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1txY1P-00000000h3J-1N9l;
	Thu, 27 Mar 2025 08:10:47 +1100
Date: Thu, 27 Mar 2025 08:10:47 +1100
From: Dave Chinner <david@fromorbit.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: patches@lists.linux.dev, fstests@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
	oliver.sang@intel.com, hannes@cmpxchg.org, willy@infradead.org,
	jack@suse.cz, apopple@nvidia.com, brauner@kernel.org, hare@suse.de,
	oe-lkp@lists.linux.dev, lkp@intel.com, john.g.garry@oracle.com,
	p.raghav@samsung.com, da.gomez@samsung.com, dave@stgolabs.net,
	riel@surriel.com, krisman@suse.de, boris@bur.io,
	jackmanb@google.com, gost.dev@samsung.com
Subject: Re: [PATCH] generic/764: fsstress + migrate_pages() test
Message-ID: <Z-RtV6OO_IhggLvT@dread.disaster.area>
References: <20250326185101.2237319-1-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250326185101.2237319-1-mcgrof@kernel.org>

On Wed, Mar 26, 2025 at 11:50:55AM -0700, Luis Chamberlain wrote:
> 0-day reported a page migration kernel warning with folios which happen
> to be buffer-heads [0]. I'm having a terribly hard time reproducing the bug
> and so I wrote this test to force page migration filesystems.
> 
> It turns out we have have no tests for page migration on fstests or ltp,
> and its no surprise, other than compaction covered by generic/750 there
> is no easy way to trigger page migration right now unless you have a
> numa system.
> 
> We should evaluate if we want to help stress test page migration
> artificially by later implementing a way to do page migration on simple
> systems to an artificial target.
> 
> So far, this doesn't trigger any kernel splats, not even warnings for me.
> 
> Reported-by: kernel test robot <oliver.sang@intel.com>
> Link: https://lore.kernel.org/r/202503101536.27099c77-lkp@intel.com # [0]
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  common/config         |  2 +
>  common/rc             |  8 ++++
>  tests/generic/764     | 94 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/764.out |  2 +
>  4 files changed, 106 insertions(+)
>  create mode 100755 tests/generic/764
>  create mode 100644 tests/generic/764.out
> 
> diff --git a/common/config b/common/config
> index 2afbda141746..93b50f113b44 100644
> --- a/common/config
> +++ b/common/config
> @@ -239,6 +239,8 @@ export BTRFS_MAP_LOGICAL_PROG=$(type -P btrfs-map-logical)
>  export PARTED_PROG="$(type -P parted)"
>  export XFS_PROPERTY_PROG="$(type -P xfs_property)"
>  export FSCRYPTCTL_PROG="$(type -P fscryptctl)"
> +export NUMACTL_PROG="$(type -P numactl)"
> +export MIGRATEPAGES_PROG="$(type -P migratepages)"
>  
>  # udev wait functions.
>  #
> diff --git a/common/rc b/common/rc
> index e51686389a78..ed9613a9bf28 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -281,6 +281,14 @@ _require_vm_compaction()
>  	fi
>  }
>  
> +_require_numa_nodes()
> +{
> +	readarray -t QUEUE < <($NUMACTL_PROG --show | awk '/^membind:/ {for (i=2; i<=NF; i++) print $i}')

sed makes this easier: remove the membind token, then remove all the
lines that have ":"s left in them. This leaves behind the membind
node string.

$ numactl --show | sed -e 's/membind://' -e '/:/d'
 0 1 2 3
$

Also should have:

	_require_command "$NUMACTL_PROG" "numactl"

built into it, rather than requiring the test to declare it first.

> +	if (( ${#QUEUE[@]} < 2 )); then
> +		_notrun "You need a system with at least two numa nodes to run this test"
> +	fi
> +}



> +
>  # Requires CONFIG_DEBUGFS and truncation knobs
>  _require_split_huge_pages_knob()
>  {
> diff --git a/tests/generic/764 b/tests/generic/764
> new file mode 100755
> index 000000000000..91d9fb7e08da
> --- /dev/null
> +++ b/tests/generic/764
> @@ -0,0 +1,94 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Luis Chamberlain.  All Rights Reserved.
> +#
> +# FS QA Test 764
> +#
> +# fsstress + migrate_pages() test
> +#
> +. ./common/preamble
> +_begin_fstest auto rw long_rw stress soak smoketest
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $runfile
> +	rm -f $tmp.*
> +	kill -9 $run_migration_pid > /dev/null 2>&1
> +	kill -9 $stress_pid > /dev/null 2>&1
> +
> +	wait > /dev/null 2>&1
> +}

If you implement this using the fsstress wrappers like I mention
below, and get rid of running the main migration loop in background,
this cleanup function can go away completely.

> +
> +_require_scratch
> +_require_command "$NUMACTL_PROG" "numactl"
> +_require_command "$MIGRATEPAGES_PROG" "migratepages"
> +_require_numa_nodes
> +
> +readarray -t QUEUE < <($NUMACTL_PROG --show | awk '/^membind:/ {for (i=2; i<=NF; i++) print $i}')
> +if (( ${#QUEUE[@]} < 2 )); then
> +	echo "Not enough NUMA nodes to pick two different ones."
> +	exit 1
> +fi

You've implemented this twice.

> +echo "Silence is golden"
> +
> +_scratch_mkfs > $seqres.full 2>&1
> +_scratch_mount >> $seqres.full 2>&1
> +
> +nr_cpus=$((LOAD_FACTOR * 4))
> +nr_ops=$((25000 * nr_cpus * TIME_FACTOR))

Don't scale ops with nr_cpus - you've already scaled processes
with nr_cpus.

> +fsstress_args=(-w -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus)
> +test -n "$SOAK_DURATION" && fsstress_args+=(--duration="$SOAK_DURATION")
> +
> +runfile="$tmp.migratepages"
> +pidfile="$tmp.stress.pid"
> +
> +run_stress_fs()
> +{
> +	$FSSTRESS_PROG $FSSTRESS_AVOID "${fsstress_args[@]}" &
> +	stress_pid=$!
> +	echo $stress_pid > $pidfile
> +	wait $stress_pid
> +	rm -f $runfile
> +	rm -f $pidfile
> +}

Don't reimplement _run_fsstress(), call it instead.

> +
> +run_stress_fs &

Actually, you want _run_fsstress_bg() here, and then
_kill_fsstress() when you want it to die.

> +touch $runfile
> +stress_pid=$(cat $pidfile)

Don't need either of these.

> +
> +while [ -e $runfile ]; do

while [ -n "_FSSTRESS_PID" ]; do


> +	readarray -t QUEUE < <(numactl --show | awk '/^membind:/ {for (i=2; i<=NF; i++) print $i}')

Third time this is implemented.

> +	# Proper Fisher–Yates shuffle
> +	for ((i=${#QUEUE[@]} - 1; i > 0; i--)); do
> +		j=$((RANDOM % (i + 1)))
> +		var=${QUEUE[i]}
> +		QUEUE[i]=${QUEUE[j]}
> +		QUEUE[j]=$var
> +	done
> +
> +	RANDOM_NODE_1=${QUEUE[0]}
> +	RANDOM_NODE_2=${QUEUE[1]}

If all you are doing is picking two random nodes, then you could
just use RANDOM for the array index and drop the whole shuffle
thing, yes?

> +	if [[ -f $pidfile ]]; then

no need for this if we gate the loop on _FSSTRESS_PID

> +		echo "migrating parent fsstress process:" >> $seqres.full
> +		echo -en "\t$MIGRATEPAGES_PROG $pid $RANDOM_NODE_1 $RANDOM_NODE_2 ..." >> $seqres.full
> +		$MIGRATEPAGES_PROG $stress_pid $RANDOM_NODE_1 $RANDOM_NODE_2
> +		echo " $?" >> $seqres.full
> +		echo "migrating child fsstress processes ..." >> $seqres.full
> +		for pid in $(ps --ppid "$stress_pid" -o pid=); do
> +			echo -en "\tmigratepages $pid $RANDOM_NODE_1 $RANDOM_NODE_2 ..." >> $seqres.full
> +			$MIGRATEPAGES_PROG $pid $RANDOM_NODE_1 $RANDOM_NODE_2
> +			echo " $?" >> $seqres.full
> +		done
> +	fi
> +	sleep 2
> +done &
> +run_migration_pid=$!

why is this put in the background, only to then wait on it to
complete? The loop will stop when fsstress finishes, yes?
Which means this doesn't need to be run in the background at all,
and then cleanup doesn't need to handle killing this, either.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
