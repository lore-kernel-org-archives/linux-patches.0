Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 580871DA24
	for <patches@lists.linux.dev>; Tue, 18 Jun 2024 14:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718719830; cv=none; b=PLlGWcW1uRa6tiVLzHB4DYhfzFq9zvjhIDYV2FVKKyli96ebWvDpdWy01FvMA5P79KOZVCDchEjCcZSENQPB/s/fzLOKmpiYBZbVxBqfe01jpEHWyN9hEcWWFb59qgoiCOu8QeM655eS1eAUdH/k2uNJJu+xZMPcnI9EmDtjh2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718719830; c=relaxed/simple;
	bh=tGl1yxfkuDeMIQeSADjyhPZolC20UrVrh9Ke7p4VEgk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=sH/V4Z0oGylj0hrf+mUsn4QLnjZYHiHfdLY71OZs2yt39TiuA4P7Tq9ELyBmEWFPgpUfnotj6yUCg6UE8woRq7DJlaWoghAA7EMv3IeY9lnLmEziAPD+Dh9+jbpWJQgXv8JEvt6FfndlkoiMNn1wDBX7QOEuec41Exn5HX2gAD8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=iLPSFq0b; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iLPSFq0b"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718719827;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I4kwzn7nwp0hrFl15C/WJa7gZ49NVjVQcqnka+zFjp8=;
	b=iLPSFq0bXbHdf6gxBJkPdgQXccPeOLVNiiqpVP+/j2NbsFmYSvKMUftOKaaN44ZyNQepU0
	B3Limzx4SU8rhwPQEtJt7uTBLP9tx8kNNvCdp7G1huByA1FSp9V1CXzGGOoeR0fY18mKpy
	uOJlrAkoMQhFBJIeBQaps83tsUPLRUY=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-583-tShpJgwSOwWsSO_QYTW7ag-1; Tue, 18 Jun 2024 10:10:22 -0400
X-MC-Unique: tShpJgwSOwWsSO_QYTW7ag-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1f71d5a85f9so61558925ad.0
        for <patches@lists.linux.dev>; Tue, 18 Jun 2024 07:10:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718719822; x=1719324622;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I4kwzn7nwp0hrFl15C/WJa7gZ49NVjVQcqnka+zFjp8=;
        b=qw6UKw0GsO82vWuXpHCRNu+qRRu5ntMgd6JVrBAVBQfGlHcPboC7TZxaw2rmoBModd
         KHoSEVv4bYHTvWrrLyKojFr2dmk9ivn+inEsXqcKFdJUvfLRq9SeX6iAfibjHYCkRRsv
         j7KfzNnLAcdnHXedYNUtqeZP2J44YIzRDeLhOPaD0s8fqyKVDdPG/uCoNunZNozPWNil
         PFSd06RrSgEVxUE1Fp48BSMJUISCg4YtuWSDqS5momttb4Em7cgEICLHQqPiNOofpS/c
         +BBdpbGAe1UlBeYRGGitObPaSeabmO45aoZ0P9K9WkCCC1QVe8RsmIp8USiaPp2zMORf
         uq/g==
X-Gm-Message-State: AOJu0YzixXSvzblB9R9ZmQuje74HOwB0e8hUrXfVtSTZOKTC2kXDwVtK
	9TuR9f43dRg1M11od9XjDLHhKy53I8lGkjDyA752ui17smeWoAlwbvk1TFhdGqONQt5h8Cgm/LU
	E0/ZItXNR51k7+GlaxgJgBYbPpyg/0LQpwO8GuFQ+fIk3VA25Qj83W6s=
X-Received: by 2002:a17:902:e747:b0:1f7:317f:5434 with SMTP id d9443c01a7336-1f8627e3299mr156584925ad.40.1718719821567;
        Tue, 18 Jun 2024 07:10:21 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFv9qqMlG7VblsZwC7P+NfT7DBt1DHXNsixB82zrwIP85DFtLiWNRSo0cCXjVC8NYr5EAxLTQ==
X-Received: by 2002:a17:902:e747:b0:1f7:317f:5434 with SMTP id d9443c01a7336-1f8627e3299mr156584335ad.40.1718719821007;
        Tue, 18 Jun 2024 07:10:21 -0700 (PDT)
Received: from dell-per750-06-vm-08.rhts.eng.pek2.redhat.com ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855e55c3bsm97927985ad.57.2024.06.18.07.10.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 07:10:20 -0700 (PDT)
Date: Tue, 18 Jun 2024 22:10:13 +0800
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
Subject: Re: [PATCH v2 5/5] fstests: add stress truncation + writeback test
Message-ID: <20240618141013.pue6syikkp5dwj5q@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com>
References: <20240615002935.1033031-1-mcgrof@kernel.org>
 <20240615002935.1033031-6-mcgrof@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20240615002935.1033031-6-mcgrof@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Jun 14, 2024 at 05:29:34PM -0700, Luis Chamberlain wrote:
> Stress test folio splits by using the new debugfs interface to a target
> a new smaller folio order while triggering writeback at the same time.
> 
> This is known to only creates a crash with min order enabled, so for example
> with a 16k block sized XFS test profile, an xarray fix for that is merged
> already. This issue is fixed by kernel commit 2a0774c2886d ("XArray: set the
> marks correctly when splitting an entry").
> 
> If inspecting more closely, you'll want to enable on your kernel boot:
> 
> 	dyndbg='file mm/huge_memory.c +p'
> 
> Since we want to race large folio splits we also augment the full test
> output log $seqres.full with the test specific number of successful
> splits from vmstat thp_split_page and thp_split_page_failed. The larger
> the vmstat thp_split_page the more we stress test this path.
> 
> This test reproduces a really hard to reproduce crash immediately.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---

Good to me,
Reviewed-by: Zorro Lang <zlang@redhat.com>

>  common/rc             |  14 ++++
>  tests/generic/751     | 170 ++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/751.out |   2 +
>  3 files changed, 186 insertions(+)
>  create mode 100755 tests/generic/751
>  create mode 100644 tests/generic/751.out
> 
> diff --git a/common/rc b/common/rc
> index 30beef4e5c02..31ad30276ca6 100644
> --- a/common/rc
> +++ b/common/rc
> @@ -158,6 +158,20 @@ _require_vm_compaction()
>  	    _notrun "Need compaction enabled CONFIG_COMPACTION=y"
>  	fi
>  }
> +
> +# Requires CONFIG_DEBUGFS and truncation knobs
> +_require_split_huge_pages_knob()
> +{
> +       if [ ! -f $DEBUGFS_MNT/split_huge_pages ]; then
> +           _notrun "Needs CONFIG_DEBUGFS and split_huge_pages"
> +       fi
> +}
> +
> +_split_huge_pages_all()
> +{
> +	echo 1 > $DEBUGFS_MNT/split_huge_pages
> +}
> +
>  # Get hugepagesize in bytes
>  _get_hugepagesize()
>  {
> diff --git a/tests/generic/751 b/tests/generic/751
> new file mode 100755
> index 000000000000..ac0ca2f07443
> --- /dev/null
> +++ b/tests/generic/751
> @@ -0,0 +1,170 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2024 Luis Chamberlain. All Rights Reserved.
> +#
> +# FS QA Test No. 751
> +#
> +# stress page cache truncation + writeback
> +#
> +# This aims at trying to reproduce a difficult to reproduce bug found with
> +# min order. The issue was root caused to an xarray bug when we split folios
> +# to another order other than 0. This functionality is used to support min
> +# order. The crash:
> +#
> +# https://gist.github.com/mcgrof/d12f586ec6ebe32b2472b5d634c397df
> +# Crash excerpt is as follows:
> +#
> +# BUG: kernel NULL pointer dereference, address: 0000000000000036
> +# #PF: supervisor read access in kernel mode
> +# #PF: error_code(0x0000) - not-present page
> +# PGD 0 P4D 0
> +# Oops: 0000 [#1] PREEMPT SMP NOPTI
> +# CPU: 7 PID: 2190 Comm: kworker/u38:5 Not tainted 6.9.0-rc5+ #14
> +# Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.3-debian-1.16.3-2 04/01/2014
> +# Workqueue: writeback wb_workfn (flush-7:5)
> +# RIP: 0010:filemap_get_folios_tag+0xa9/0x200
> +# Call Trace:
> +#  <TASK>
> +#   writeback_iter+0x17d/0x310
> +#  write_cache_pages+0x42/0xa0
> +#  iomap_writepages+0x33/0x50
> +#  xfs_vm_writepages+0x63/0x90 [xfs]
> +#  do_writepages+0xcc/0x260
> +#  __writeback_single_inode+0x3d/0x340
> +#  writeback_sb_inodes+0x1ed/0x4b0
> +#  __writeback_inodes_wb+0x4c/0xe0
> +#  wb_writeback+0x267/0x2d0
> +#  wb_workfn+0x2a4/0x440
> +#  process_one_work+0x189/0x3b0
> +#  worker_thread+0x273/0x390
> +#  kthread+0xda/0x110
> +#  ret_from_fork+0x2d/0x50
> +#  ret_from_fork_asm+0x1a/0x30
> +#  </TASK>
> +#
> +# This may also find future truncation bugs in the future, as truncating any
> +# mapped file through the collateral of using echo 1 > split_huge_pages will
> +# always respect the min order. Truncating to a larger order then is excercised
> +# when this test is run against any filesystem LBS profile or an LBS device.
> +#
> +# If you're enabling this and want to check underneath the hood you may want to
> +# enable:
> +#
> +# dyndbg='file mm/huge_memory.c +p'
> +#
> +# This tests aims at increasing the rate of successful truncations so we want
> +# to increase the value of thp_split_page in $seqres.full. Using echo 1 >
> +# split_huge_pages is extremely aggressive, and even accounts for anonymous
> +# memory on a system, however we accept that tradeoff for the efficiency of
> +# doing the work in-kernel for any mapped file too. Our general goal here is to
> +# race with folio truncation + writeback.
> +
> +. ./common/preamble
> +
> +_begin_fstest auto long_rw stress soak smoketest
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +	rm -f $runfile
> +	kill -9 $split_huge_pages_files_pid > /dev/null 2>&1
> +}
> +
> +fio_config=$tmp.fio
> +fio_out=$tmp.fio.out
> +fio_err=$tmp.fio.err
> +
> +# real QA test starts here
> +_supported_fs generic
> +_require_test
> +_require_scratch
> +_require_debugfs
> +_require_split_huge_pages_knob
> +_require_command "$KILLALL_PROG" "killall"
> +_fixed_by_git_commit kernel 2a0774c2886d \
> +	"XArray: set the marks correctly when splitting an entry"
> +
> +proc_vmstat()
> +{
> +	awk -v name="$1" '{if ($1 ~ name) {print($2)}}' /proc/vmstat | head -1
> +}
> +
> +# we need buffered IO to force truncation races with writeback in the
> +# page cache
> +cat >$fio_config <<EOF
> +[force_large_large_folio_parallel_writes]
> +ignore_error=ENOSPC
> +nrfiles=10
> +direct=0
> +bs=4M
> +group_reporting=1
> +filesize=1GiB
> +readwrite=write
> +fallocate=none
> +numjobs=$(nproc)
> +directory=$SCRATCH_MNT
> +runtime=100*${TIME_FACTOR}
> +time_based
> +EOF
> +
> +_require_fio $fio_config
> +
> +echo "Silence is golden"
> +
> +_scratch_mkfs >>$seqres.full 2>&1
> +_scratch_mount >> $seqres.full 2>&1
> +
> +# used to let our loops know when to stop
> +runfile="$tmp.keep.running.loop"
> +touch $runfile
> +
> +# The background ops are out of bounds, the goal is to race with fsstress.
> +
> +# Force folio split if possible, this seems to be screaming for MADV_NOHUGEPAGE
> +# for large folios.
> +while [ -e $runfile ]; do
> +	_split_huge_pages_all >/dev/null 2>&1
> +done &
> +split_huge_pages_files_pid=$!
> +
> +split_count_before=0
> +split_count_failed_before=0
> +
> +if grep -q thp_split_page /proc/vmstat; then
> +	split_count_before=$(proc_vmstat thp_split_page)
> +	split_count_failed_before=$(proc_vmstat thp_split_page_failed)
> +else
> +	echo "no thp_split_page in /proc/vmstat" >> $seqres.full
> +fi
> +
> +# we blast away with large writes to force large folio writes when
> +# possible.
> +echo -e "Running fio with config:\n" >> $seqres.full
> +cat $fio_config >> $seqres.full
> +$FIO_PROG $fio_config --alloc-size=$(( $(nproc) * 8192 )) \
> +	--output=$fio_out 2> $fio_err
> +FIO_ERR=$?
> +
> +rm -f $runfile
> +
> +wait > /dev/null 2>&1
> +
> +if grep -q thp_split_page /proc/vmstat; then
> +	split_count_after=$(proc_vmstat thp_split_page)
> +	split_count_failed_after=$(proc_vmstat thp_split_page_failed)
> +	thp_split_page=$((split_count_after - split_count_before))
> +	thp_split_page_failed=$((split_count_failed_after - split_count_failed_before))
> +
> +	echo "vmstat thp_split_page: $thp_split_page" >> $seqres.full
> +	echo "vmstat thp_split_page_failed: $thp_split_page_failed" >> $seqres.full
> +fi
> +
> +# exitall_on_error=ENOSPC does not work as it should, so we need this eyesore
> +if [[ $FIO_ERR -ne 0 ]] && ! grep -q "No space left on device" $fio_err; then
> +	_fail "fio failed with err: $FIO_ERR"
> +fi
> +
> +status=0
> +exit
> diff --git a/tests/generic/751.out b/tests/generic/751.out
> new file mode 100644
> index 000000000000..6479fa6f1404
> --- /dev/null
> +++ b/tests/generic/751.out
> @@ -0,0 +1,2 @@
> +QA output created by 751
> +Silence is golden
> -- 
> 2.43.0
> 
> 

