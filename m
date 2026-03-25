Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2911F3D88F1
	for <patches@lists.linux.dev>; Wed, 25 Mar 2026 13:12:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774444358; cv=none; b=UDPY3m8hDgFbKRfE0L4a9RQFrbXgORuZOzVqMtEn7nqlrRAsfqQmEIKTxMuz/fFMzuJd2BoOWoVkHbhAfiGhbT27Z43EquyOHCPJBHZx4crFd/gt1LGHxV5t0REo0nx2CooRSRHMnJuTykvr7FIJM9Ez+IymLx5fxvf1KbVUPeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774444358; c=relaxed/simple;
	bh=eL+Mj5TpPx8TwOlgoQWHtmqINkeGKGXM8RP7EJh/g2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eVPovpBmUErGpFANIE0hKCj7/s0AxcaCJaaBD2ie8885RsyvTtvWE2kA9UvaP8p3ie1EyVDi1o4topSbS2gZ4Y3WNV+u1ZgUzWnRAPvLrCWCnsnz6WQZ+p/Vcz2kplI6jgMbwLsoVcH8n7aKGGVnh9fmfKYCn+GlhGbQe8Pe7A8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=X/AwX8nn; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="X/AwX8nn"
Received: from macsyma.thunk.org (172-245-102-52-host.colocrossing.com [172.245.102.52] (may be forged))
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 62PDBBkJ027158
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 25 Mar 2026 09:11:13 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1774444282; bh=7mIseyiI5gVhbpQ41lVFH4BsOHFD/Ed2Wjszawlx41U=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=X/AwX8nn6SKbJnMK+k7rXxgO12DhT2DL7TTl4++hsHi561WhkSAyDNay1WT/29avh
	 Yd4meozyCIsnAMFQvXQaQtNQK77UsCQSH71XkbezhTXLTf9lo92WhU4StpEDurlIPC
	 xcBLtea2m63G+vZEQVF0BMp5cl/TGstcCW5NqECIvk87Tn5w55oWqvDJoVT5muGC7y
	 O+LbaaH2JlZ3issraJPOv+IVapjeTCSBxuV62u9iTusCZR0aTr3+7JQsoNv/7zqO+t
	 kPP4sIwtCqKcn1ZQmexZLk64QK7Sz0u4DCVP88zC84KzRETbAq2gD2QadPtlViPSIT
	 AsiuY7y6RQL7A==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id CF20F5F3D27A; Wed, 25 Mar 2026 08:11:10 -0500 (CDT)
Date: Wed, 25 Mar 2026 08:11:10 -0500
From: "Theodore Tso" <tytso@mit.edu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Brown <broonie@kernel.org>, Jan Kara <jack@suse.cz>,
        Francesco Dolcini <francesco@dolcini.it>,
        Brian Foster <bfoster@redhat.com>,
        Yongjian Sun <sunyongjian1@huawei.com>,
        Matthew Wilcox <willy@infradead.org>, Gou Hao <gouhao@uniontech.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Zhang Yi <yi.zhang@huawei.com>,
        Baokun Li <libaokun1@huawei.com>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, achill@achill.org,
        sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/481] 6.1.167-rc1 review
Message-ID: <20260325131110.GC2107@macsyma.local>
References: <20260323134525.256603107@linuxfoundation.org>
 <20260324073447.GA5062@francesco-nb>
 <mhqesgj3u7dr33zit6iwjhykw2zpuallru4qvoloyyqzdqgvki@bpwwmihh357r>
 <d8080343-20cd-4a4a-b726-b9e3c6a5c5eb@sirena.org.uk>
 <20260325035931.GC61656@mac.lan>
 <2026032535-casino-cable-e039@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026032535-casino-cable-e039@gregkh>

On Wed, Mar 25, 2026 at 10:49:43AM +0100, Greg Kroah-Hartman wrote:
> > I don't have time to investigate further, but Greg, if you could drop
> > these three patches, that should address this issue.
> 
> All now dropped, thanks!

Thanks!  Just as another heads up, I decided to run a full regression
test suite on 6.1.167-rc1 with those three reverts, and there ar still
some crashes with generic/051 and ext4/039:

ext4/4k: 711 tests, 1 errors, 83 skipped, 4645 seconds
  Errors: generic/051
ext4/1k: 636 tests, 7 failures, 1 errors, 78 skipped, 5612 seconds
  Errors: ext4/039
ext4/encrypt: 679 tests, 1 errors, 215 skipped, 3343 seconds
  Errors: generic/051
ext4/ext3conv: 706 tests, 1 errors, 85 skipped, 5282 seconds
  Errors: generic/051
ext4/adv: 713 tests, 13 failures, 1 errors, 91 skipped, 4944 seconds
  Errors: generic/051
ext4/dioread_nolock: 711 tests, 1 failures, 1 errors, 83 skipped, 5518 seconds
  Errors: generic/051
ext4/data_journal: 635 tests, 6 failures, 1 errors, 151 skipped, 4105 seconds
  Errors: ext4/039
ext4/bigalloc_4k: 604 tests, 1 errors, 79 skipped, 4876 seconds
  Errors: ext4/039
ext4/bigalloc_1k: 682 tests, 6 failures, 1 errors, 106 skipped, 5454 seconds
  Errors: generic/051
ext4/dax: 705 tests, 10 failures, 1 errors, 207 skipped, 3249 seconds
  Errors: generic/051

I'll start trying to bisect this as I have time today.  Are you going
to put out another rc and restart the 48 hour testing clock?

       	   	      	  	      - Ted

P.S.  A sample crash:

   BUG: unable to handle page fault for address: ffffffffffffffec
   #PF: supervisor read access in kernel mode
   #PF: error_code(0x0000) - not-present page
   PGD 300d067 P4D 300d067 PUD 300f067 PMD 0 
   Oops: 0000 [#1] PREEMPT SMP NOPTI
   CPU: 1 PID: 326494 Comm: fsstress Not tainted 6.1.167-rc1-xfstests-00485-gb12a69d9770b #50
   Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 02/12/2026
   RIP: 0010:ext4_ext_map_blocks+0x190/0xa50
   Code: 48 89 ef 48 8d 54 24 60 e8 9d 71 ff ff 85 c0 41 89 c3 89 44 24 28 0f 84 51 02 00 00 48 8b 44 24 30 48 85 c0 0f 84 72 04 00 00 <44> 0f b7 78 08 48 89 1c 24 49 89 c5 31 db 49 89 c6 49 8b 7d 28 48
   RSP: 0018:ffffd16f045b7968 EFLAGS: 00010286
   RAX: ffffffffffffffe4 RBX: ffffd16f045b7ac8 RCX: 00000000000005ea
   RDX: ffffffff9b2407d0 RSI: 0000000000000000 RDI: ffff8e671ae1c410
   RBP: ffff8e66f8b72688 R08: ffffffff9b4a7024 R09: 0000000000000000
   R10: 0000000000000000 R11: ffff8e676f1e2ff0 R12: 0000000000000001
   R13: 00000000000f6422 R14: ffff8e66c244c000 R15: ffff8e66c0fd3080
   FS:  00007f67932c6740(0000) GS:ffff8e6799500000(0000) knlGS:0000000000000000
   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
   CR2: ffffffffffffffec CR3: 000000013d210000 CR4: 0000000000350ee0
   Call Trace:
    <TASK>
    ext4_map_blocks+0x237/0x690
    ext4_iomap_begin+0x2af/0x320
    iomap_iter+0xb1/0x130
    __iomap_dio_rw+0x21e/0x650
    ? aio_fsync_work+0xf0/0xf0
    iomap_dio_rw+0xe/0x30
    ext4_dio_write_iter+0x612/0x6f0
    ? filename_lookup+0xde/0x1a0
    ? mntput_no_expire+0x4e/0x260
    aio_write+0x159/0x2a0
    ? fget+0x7a/0xa0
    ? io_submit_one+0xef/0x3b0
    io_submit_one+0xef/0x3b0
    __x64_sys_io_submit+0xac/0x1d0
    do_syscall_64+0x35/0x80
    entry_SYSCALL_64_after_hwframe+0x6e/0xd8
   RIP: 0033:0x7f67933d7779
   Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 67 76 0d 00 f7 d8 64 89 01 48
   RSP: 002b:00007fff8d7191f8 EFLAGS: 00000246 ORIG_RAX: 00000000000000d1
   RAX: ffffffffffffffda RBX: 00007f67932c66c8 RCX: 00007f67933d7779
   RDX: 00007fff8d719248 RSI: 0000000000000001 RDI: 00007f67934c6000
   RBP: 00007f67934c6000 R08: 0000000000000001 R09: 0000000000007c38
   R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000001
   R13: 0000000000000019 R14: 00007fff8d719248 R15: 0000000000019000
    </TASK>
   CR2: ffffffffffffffec
   ---[ end trace 0000000000000000 ]---


