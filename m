Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F92A1841
	for <patches@lists.linux.dev>; Tue, 23 May 2023 01:02:26 +0000 (UTC)
Received: from cwcc.thunk.org (pool-173-48-120-46.bstnma.fios.verizon.net [173.48.120.46])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 34N0wVrm004304
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 22 May 2023 20:58:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1684803515; bh=ymmSexEkCD0tfWO58p9Lq+Z1QefxVwW0r/fcykmyXek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=H6gAtjsQgMcmk5aJVQgnBL1f+4JZW6DpUL1rUsQDkrAdNIVeAfcrzUN58ULgYU9tn
	 h08rXJwLOsL3vIx4+1pew7qVUvsIWPzAaeKbosdSaUcaBKidY1OcamN6bGvIzijurp
	 dKTitmCa4ASwTyoBTimLoPPtafgVLlFDe2+y1Uy3au/xEseaPerlPI/1hPdb1qdJZW
	 O+/M/Upy2msYQ+LHvEPK8rheF8zVbJV1CaMj7G54cpEHVgL7ExzOp8imVsq5L2/YNn
	 xzJU5QsCk2/SbYoMJlyfFhaGozlJSb2N98LHueRHOKs9MfH0tjnM4aQGrIWDIkyHIn
	 INrBvKm62N/eA==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
	id C2BCC15C052B; Mon, 22 May 2023 20:58:31 -0400 (EDT)
Date: Mon, 22 May 2023 20:58:31 -0400
From: "Theodore Ts'o" <tytso@mit.edu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/292] 6.1.30-rc1 review
Message-ID: <20230523005831.GE230989@mit.edu>
References: <20230522190405.880733338@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>

On Mon, May 22, 2023 at 08:05:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.30 release.
> There are 292 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Tested-by: Theodore Ts'o <tytso@mit.edu>

No regressions found for ext4.

				- Ted

TESTRUNID: ltm-20230522173053
KERNEL:    kernel 6.1.30-rc1-xfstests-00293-ge00a3d96f756 #26 SMP PREEMPT_DYNAMIC Mon May 22 17:25:13 EDT 2023 x86_64
CMDLINE:   full --kernel gs://gce-xfstests/kernel.deb
CPUS:      2
MEM:       7680

ext4/4k: 530 tests, 32 skipped, 4755 seconds
ext4/1k: 526 tests, 1 failures, 45 skipped, 5810 seconds
  Flaky: generic/475: 80% (4/5)
ext4/ext3: 522 tests, 1 failures, 121 skipped, 4805 seconds
  Failures: generic/347
ext4/encrypt: 508 tests, 3 failures, 139 skipped, 2729 seconds
  Failures: generic/681 generic/682 generic/691
ext4/nojournal: 525 tests, 3 failures, 100 skipped, 4619 seconds
  Failures: ext4/301 ext4/304 generic/455
ext4/ext3conv: 527 tests, 3 failures, 33 skipped, 4535 seconds
  Failures: generic/347
  Flaky: generic/475: 40% (2/5)   generic/645: 20% (1/5)
ext4/adv: 527 tests, 4 failures, 40 skipped, 4432 seconds
  Failures: generic/477
  Flaky: generic/455: 60% (3/5)   generic/475: 80% (4/5)   
    generic/482: 40% (2/5)
ext4/dioread_nolock: 528 tests, 1 failures, 32 skipped, 5437 seconds
  Flaky: generic/475: 20% (1/5)
ext4/data_journal: 526 tests, 3 failures, 100 skipped, 4571 seconds
  Failures: generic/231 generic/347 generic/455
ext4/bigalloc_4k: 502 tests, 1 failures, 37 skipped, 4430 seconds
  Flaky: generic/077: 20% (1/5)
ext4/bigalloc_1k: 502 tests, 1 failures, 55 skipped, 5167 seconds
  Failures: shared/298
ext4/dax: 517 tests, 135 skipped, 2763 seconds
Totals: 6324 tests, 869 skipped, 83 failures, 0 errors, 53773s

FSTESTIMG: gce-xfstests/xfstests-amd64-202303031351
FSTESTPRJ: gce-xfstests
FSTESTVER: blktests 676d42c (Thu, 2 Mar 2023 15:25:44 +0900)
FSTESTVER: fio  fio-3.31 (Tue, 9 Aug 2022 14:41:25 -0600)
FSTESTVER: fsverity v1.5-6-g5d6f7c4 (Mon, 30 Jan 2023 23:22:45 -0800)
FSTESTVER: ima-evm-utils v1.3.2 (Wed, 28 Oct 2020 13:18:08 -0400)
FSTESTVER: nvme-cli v1.16 (Thu, 11 Nov 2021 13:09:06 -0800)
FSTESTVER: quota  v4.05-53-gd90b7d5 (Tue, 6 Dec 2022 12:59:03 +0100)
FSTESTVER: util-linux v2.38.1 (Thu, 4 Aug 2022 11:06:21 +0200)
FSTESTVER: xfsprogs v6.1.1 (Fri, 13 Jan 2023 19:06:37 +0100)
FSTESTVER: xfstests-bld 2e60cef3 (Thu, 23 Feb 2023 15:02:58 -0500)
FSTESTVER: xfstests v2023.02.26-8-g821ef4889 (Thu, 2 Mar 2023 10:23:51 -0500)
FSTESTVER: zz_build-distro bullseye
FSTESTSET: -g auto
FSTESTOPT: aex
