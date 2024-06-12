Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3691314F132
	for <patches@lists.linux.dev>; Wed, 12 Jun 2024 08:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718179262; cv=none; b=cjSbxF30ltEpt3qaXH+Y62/Y62TLzKpZcjRP0geva1BDuMohR/xtE+CFfzDjTKKCmGrbOg0NfA0qwbfUqj7hQ/DWQ+VhRLLJpJgYL8wN2Byd5r/q8p3MrKB3q++t0R7X2RwF5ZmuGS1muhiYXyM0YwKe25xQHHstvinZmgqAqbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718179262; c=relaxed/simple;
	bh=0OWZytV7iidTSRsiJbmntqWHMzCgSbj+2IHoc91k3X0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=Iw5auu/k8EcMxvxmN9UebMR3n9Eh4swNjjQC4FRbxHi4san2SFjJCuAh1ruByeS75ILt1/DMyRFg7m5NSVyVv9Ty0tVBJFaIahNa4UMRUIrB5R4FFpuxqG4XOPBMfTL3y7daW/cvFYxNVRXoaGV02RdncObAPZaXEg9MPG9xXXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HxiZFkj1; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HxiZFkj1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718179260;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=p/SC79B0SQx0Kv68DpQnR4beG6Hiq5QD/FW1/evjIEo=;
	b=HxiZFkj1fMf5lkZU/wdfPudc1YHecKu4KeIT022VwMRAZv2HP5t+DiC9VZ52LUSQcVxNS0
	OvUY9SyARfeJ/OFsb6msP/AAJNjqqy5x/P+dMprysNPDn3UhxDAo/pZm47am0tbEFApUMI
	WoiOaaXLuhwkL0tPQLhbWgRUwNzQGD4=
Received: from mail-pg1-f200.google.com (mail-pg1-f200.google.com
 [209.85.215.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-408-YmE4OfuiODe172lIq0Loiw-1; Wed, 12 Jun 2024 04:00:59 -0400
X-MC-Unique: YmE4OfuiODe172lIq0Loiw-1
Received: by mail-pg1-f200.google.com with SMTP id 41be03b00d2f7-6e67742bee6so1644125a12.1
        for <patches@lists.linux.dev>; Wed, 12 Jun 2024 01:00:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718179257; x=1718784057;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p/SC79B0SQx0Kv68DpQnR4beG6Hiq5QD/FW1/evjIEo=;
        b=FzXZopAUJwxSHI8ka0d+csX3ao9oIF10K9mAKwdEKY32WKLx72kwZBH8Bn0G5FFkQe
         Ecjb5XbWyh/dhuthHI7BbtSoSvBEBLc6o/zZoUuGsNvf35b2gAzG1f6g5EdYge9hRBmJ
         U7e+QyhEQ9pwXfzReaWVCwqaVcfssp7Yibw2KZ95h2GqxI3SSskIxpahucgtQWWIMIl0
         LWnMbjwTb+Tz+Fp31b6SMv8a5AKbkZ35dhs7/1ogepA+slWUHoRGEKVgCYsT0p1ZI1s4
         GAS0EHD7gX5RB1FZaiEkiB3hl/c2bUkmCAZnsThkjH982lK296SyMMpMy1mG+4PiqDx+
         xFgA==
X-Gm-Message-State: AOJu0YwlLYpM8/ndlVzVWzfsdCS2jonqFtgoiJJgh8QwH0eT9BVeqf/f
	A1FT81sVP6VAH7R1sFwtaAPqgvLY6f4v0eQjmJKgsM8aZyaim1Lfd0K7s340L/xURkOM6V0Z+dW
	IgfsIZHzemsN9BfJeOtvClKoYRoJci8MDyvgdxffvYuHyq5VTW9Lhi+Y=
X-Received: by 2002:a05:6a20:8423:b0:1b8:7df1:595b with SMTP id adf61e73a8af0-1b8a9ba7d01mr1293383637.21.1718179256874;
        Wed, 12 Jun 2024 01:00:56 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGAPrr/MJx8mrt70uE7M9aB9/SWIUme1NLj1rWoKuRef2sjVdMtlSpkqcr6UXpxn4s/+VwzgQ==
X-Received: by 2002:a05:6a20:8423:b0:1b8:7df1:595b with SMTP id adf61e73a8af0-1b8a9ba7d01mr1293331637.21.1718179256174;
        Wed, 12 Jun 2024 01:00:56 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-705a16c7803sm4123812b3a.144.2024.06.12.01.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Jun 2024 01:00:55 -0700 (PDT)
Date: Wed, 12 Jun 2024 16:00:48 +0800
From: Zorro Lang <zlang@redhat.com>
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: patches@lists.linux.dev, fstests@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
	ziy@nvidia.com, vbabka@suse.cz, seanjc@google.com,
	willy@infradead.org, david@redhat.com, hughd@google.com,
	linmiaohe@huawei.com, muchun.song@linux.dev, osalvador@suse.de,
	p.raghav@samsung.com, da.gomez@samsung.com, hare@suse.de,
	john.g.garry@oracle.com
Subject: Re: [PATCH 3/5] fstests: add fsstress + compaction test
Message-ID: <20240612080048.dnbc3rzmeo7jtubv@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240611030203.1719072-1-mcgrof@kernel.org>
 <20240611030203.1719072-4-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240611030203.1719072-4-mcgrof@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 10, 2024 at 08:02:00PM -0700, Luis Chamberlain wrote:
> Running compaction while we run fsstress can crash older kernels as per
> korg#218227 [0], the fix for that [0] has been posted [1] that patch
> was merged on v6.9-rc6 fixed by commit d99e3140a4d3 ("mm: turn
> folio_test_hugetlb into a PageType"). However even on v6.10-rc2 where
> this kernel commit is already merged we can still deadlock when running
> fsstress and at the same time triggering compaction, this is a new
> issue being reported now this through patch, but this patch also
> serves as a reproducer with a high confidence. It always deadlocks.
> If you enable CONFIG_PROVE_LOCKING with the defaults you will end up
> with a complaint about increasing MAX_LOCKDEP_CHAIN_HLOCKS [1], if
> you adjust that you then end up with a few soft lockup complaints and
> some possible deadlock candidates to evaluate [2].
> 
> Provide a simple reproducer and pave the way so we keep on testing this.
> 
> Without lockdep enabled we silently deadlock on the first run of the
> test without the fix applied. With lockdep enabled you get a splat about
> the possible deadlock on the first run of the test.
> 
> [0] https://bugzilla.kernel.org/show_bug.cgi?id=218227
> [1] https://gist.github.com/mcgrof/824913b645892214effeb1631df75072
> [2] https://gist.github.com/mcgrof/926e183d21c5c4c55d74ec90197bd77a
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  common/rc             |  7 +++++
>  tests/generic/750     | 62 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/750.out |  2 ++
>  3 files changed, 71 insertions(+)
>  create mode 100755 tests/generic/750
>  create mode 100644 tests/generic/750.out
> 
> diff --git a/common/rc b/common/rc
> index e812a2f7cc67..18ad25662d5c 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -151,6 +151,13 @@ _require_hugepages()
>  		_notrun "Kernel does not report huge page size"
>  }
>  
> +# Requires CONFIG_COMPACTION
> +_require_vm_compaction()
> +{
> +	if [ ! -f /proc/sys/vm/compact_memory ]; then
> +	    _notrun "Need compaction enabled CONFIG_COMPACTION=y"
> +	fi
> +}
>  # Get hugepagesize in bytes
>  _get_hugepagesize()
>  {
> diff --git a/tests/generic/750 b/tests/generic/750
> new file mode 100755
> index 000000000000..334ab011dfa0
> --- /dev/null
> +++ b/tests/generic/750
> @@ -0,0 +1,62 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2024 Luis Chamberlain.  All Rights Reserved.
> +#
> +# FS QA Test 750
> +#
> +# fsstress + memory compaction test
> +#
> +. ./common/preamble
> +_begin_fstest auto rw long_rw stress soak smoketest
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $runfile
> +	rm -f $tmp.*
> +	kill -9 $trigger_compaction_pid > /dev/null 2>&1
> +	$KILLALL_PROG -9 fsstress > /dev/null 2>&1
> +
> +	wait > /dev/null 2>&1
> +}
> +
> +# Import common functions.
> +
> +# real QA test starts here
> +
> +_supported_fs generic
> +
> +_require_scratch
> +_require_vm_compaction
> +_require_command "$KILLALL_PROG" "killall"
> +
> +# We still deadlock with this test on v6.10-rc2, we need more work.
> +# but the below makes things better.
> +_fixed_by_git_commit kernel d99e3140a4d3 \
> +	"mm: turn folio_test_hugetlb into a PageType"
> +
> +echo "Silence is golden"
> +
> +_scratch_mkfs > $seqres.full 2>&1
> +_scratch_mount >> $seqres.full 2>&1
> +
> +nr_cpus=$((LOAD_FACTOR * 4))
> +nr_ops=$((25000 * nr_cpus * TIME_FACTOR))
> +fsstress_args=(-w -d $SCRATCH_MNT -n $nr_ops -p $nr_cpus)
> +
> +# start a background trigger for memory compaction
> +runfile="$tmp.compaction"
> +touch $runfile
> +while [ -e $runfile ]; do
> +	echo 1 > /proc/sys/vm/compact_memory
> +	sleep 5
> +done &
> +trigger_compaction_pid=$!
> +
> +test -n "$SOAK_DURATION" && fsstress_args+=(--duration="$SOAK_DURATION")
> +
> +$FSSTRESS_PROG $FSSTRESS_AVOID "${fsstress_args[@]}" >> $seqres.full
> +wait > /dev/null 2>&1

Won't this "wait" wait forever (except a ctrl+C), due to no one removes
the $runfile?

Thanks,
Zorro

> +
> +status=0
> +exit
> diff --git a/tests/generic/750.out b/tests/generic/750.out
> new file mode 100644
> index 000000000000..bd79507b632e
> --- /dev/null
> +++ b/tests/generic/750.out
> @@ -0,0 +1,2 @@
> +QA output created by 750
> +Silence is golden
> -- 
> 2.43.0
> 
> 

