Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 729601A278
	for <patches@lists.linux.dev>; Wed, 18 Oct 2023 15:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="D2euQsB5"
Received: from pps.filterd (m0353729.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39IElxns008322;
	Wed, 18 Oct 2023 15:03:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=7oLSdPRgwcFlOwiy6F3NSotHHwJLWjG4kQx1b9hMzas=;
 b=D2euQsB5c6wWeXP4s1INvrXQe6Sf0hwS7wOd1k05N2yQQ6mvq/4MGAp9OKCenSxVrGOw
 3XHy8bDuZ7RkGuK7yee6n4+bZOqfHaN/iM/QeOdZhu42hM5azSZeeuHnRb/UAVXbg/DZ
 kWvAH1bTulZVyt94S3KkoCY9ecVqoNwDBFz4h/OE6ynRXqJ8BCWRw7oIGWXqltJoIxjC
 lPoeUBBXrr9HDHzKQOLFjC5TZLWJ1PoihA+iFIbX2tQA8dyk0w2wKvUQ3JC/1aBT9DH1
 hXyDzl+naSo1PSrxMqniMHybkEv1J17yUrkK6gCyA1t+RXY2hitO79LQxDucvmJUlZsr Lg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tthee8d8u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Oct 2023 15:03:33 +0000
Received: from m0353729.ppops.net (m0353729.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39IF0jSt010259;
	Wed, 18 Oct 2023 15:03:33 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tthee8d81-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Oct 2023 15:03:33 +0000
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39IDVXrR027149;
	Wed, 18 Oct 2023 15:03:31 GMT
Received: from smtprelay07.wdc07v.mail.ibm.com ([172.16.1.74])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tr6tkh5k9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 18 Oct 2023 15:03:31 +0000
Received: from smtpav04.wdc07v.mail.ibm.com (smtpav04.wdc07v.mail.ibm.com [10.39.53.231])
	by smtprelay07.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39IF3VXv26280500
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 18 Oct 2023 15:03:31 GMT
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6E1985805E;
	Wed, 18 Oct 2023 15:03:31 +0000 (GMT)
Received: from smtpav04.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 91A5A58050;
	Wed, 18 Oct 2023 15:03:30 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.ibm.com (unknown [9.61.77.189])
	by smtpav04.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 18 Oct 2023 15:03:30 +0000 (GMT)
Message-ID: <c9b7de507e26cb4e5111cdc76998f1dcd3c0957a.camel@linux.ibm.com>
Subject: Re: [PATCH 6.4 041/737] ovl: Always reevaluate the file signature
 for IMA
From: Mimi Zohar <zohar@linux.ibm.com>
To: Raul Rangel <rrangel@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        patches@lists.linux.dev, Eric Snowberg <eric.snowberg@oracle.com>,
        Linus
 Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, Tim Bain <tbain@google.com>,
        Shuhei Takahashi <nya@chromium.org>
Date: Wed, 18 Oct 2023 11:03:30 -0400
In-Reply-To: <CAHQZ30A8R+EDGbrngMOQrXabR=DTHL3Y-1Tv+3RF98VHQ5b68Q@mail.gmail.com>
References: <20230911134650.286315610@linuxfoundation.org>
	 <20230911134651.582204417@linuxfoundation.org>
	 <ZS6xYa_kjRGvdCG6@google.com>
	 <bd5d2f882e47b904802023d5d4d54d8d4755440e.camel@linux.ibm.com>
	 <CAHQZ30A8R+EDGbrngMOQrXabR=DTHL3Y-1Tv+3RF98VHQ5b68Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-22.el8) 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: 5zivTkIJmBl5ahoJXjIF1sxZsOuBXdB4
X-Proofpoint-ORIG-GUID: li92ihY3RrwOVREHXXQlsbeJDxX1qs3f
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-18_13,2023-10-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 clxscore=1015
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999 mlxscore=0
 bulkscore=0 spamscore=0 malwarescore=0 adultscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310180122

On Tue, 2023-10-17 at 17:00 -0600, Raul Rangel wrote:
> On Tue, Oct 17, 2023 at 12:27 PM Mimi Zohar <zohar@linux.ibm.com> wrote:
> >
> > On Tue, 2023-10-17 at 10:08 -0600, Raul E Rangel wrote:
> > > On Mon, Sep 11, 2023 at 03:38:20PM +0200, Greg Kroah-Hartman wrote:
> > > > 6.4-stable review patch.  If anyone has any objections, please let me know.
> > > >
> > > > ------------------
> > > >
> > > > From: Eric Snowberg <eric.snowberg@oracle.com>
> > > >
> > > > [ Upstream commit 18b44bc5a67275641fb26f2c54ba7eef80ac5950 ]
> > > >
> > > > Commit db1d1e8b9867 ("IMA: use vfs_getattr_nosec to get the i_version")
> > > > partially closed an IMA integrity issue when directly modifying a file
> > > > on the lower filesystem.  If the overlay file is first opened by a user
> > > > and later the lower backing file is modified by root, but the extended
> > > > attribute is NOT updated, the signature validation succeeds with the old
> > > > original signature.
> > > >
> > > > Update the super_block s_iflags to SB_I_IMA_UNVERIFIABLE_SIGNATURE to
> > > > force signature reevaluation on every file access until a fine grained
> > > > solution can be found.
> > > >
> > >
> > > Sorry for replying to the 6.4-stable patch, I couldn't find the original
> > > patch in the mailing list.
> > >
> > > We recently upgraded from 6.4.4 to 6.5.3. We have the integrity LSM
> > > enabled, and are using overlayfs. When we try and execute a binary from
> > > the overlayfs filesystem, the integrity LSM hashes the binary and all
> > > its shared objects every single invocation. This causes a serious
> > > performance regression when invoking clang thousands of times while
> > > building a package. We bisected the culprit down to this patch.
> > >
> > > Here are some numbers:
> > >
> > > With this patch + overlayfs:
> > >
> > >       $ time /usr/bin/clang-17 --version > /dev/null
> > >
> > >       real    0m0.628s
> > >       user    0m0.004s
> > >       sys     0m0.624s
> > >       $ time /usr/bin/clang-17 --version > /dev/null
> > >
> > >       real    0m0.597s
> > >       user    0m0.004s
> > >       sys     0m0.593s
> > >
> > > With this patch - overlayfs:
> > >
> > >       $ truncate -s 1G foo.bin
> > >       $ mkfs.ext4 foo.bin
> > >       $ mount foo.bin /foo
> > >       $ cp /usr/bin/clang-17 /foo
> > >       $ time /foo/clang-17 --version > /dev/null
> > >
> > >       real    0m0.040s
> > >       user    0m0.009s
> > >       sys     0m0.031s
> > >       $ time /foo/clang-17 --version > /dev/null
> > >
> > >       real    0m0.036s
> > >       user    0m0.000s
> > >       sys     0m0.037s
> > >
> > > Without this path + overlayfs:
> > >       $ time /usr/bin/clang-17 --version > /dev/null
> > >
> > >       real    0m0.017s
> > >       user    0m0.007s
> > >       sys     0m0.011s
> > >       $ time /usr/bin/clang-17 --version > /dev/null
> > >
> > >       real    0m0.018s
> > >       user    0m0.000s
> > >       sys     0m0.018s
> > >
> > > i.e., we go from ~30ms / invocation to 600ms / invocation. Building
> > > glibc used to take about 3 minutes, but now its taking about 20 minutes.
> > >
> > > Our clang binary is about 100 MiB in size.
> > >
> > > Using `perf` the following sticks out:
> > >       $ perf record -g time /usr/bin/clang-17 --version
> > >       --92.03%--elf_map
> > >             vm_mmap_pgoff
> > >             ima_file_mmap
> > >             process_measurement
> > >             ima_collect_measurement
> > >             |
> > >              --91.95%--ima_calc_file_hash
> > >                     ima_calc_file_hash_tfm
> > >                     |
> > >                     |--82.85%--_sha256_update
> > >                     |     |
> > >                     |      --82.47%--lib_sha256_base_do_update.isra.0
> > >                     |           |
> > >                     |            --82.39%--sha256_transform_rorx
> > >                     |
> > >                      --9.10%--integrity_kernel_read
> > >
> > > The audit.log is also logging every clang invocation as well.
> > >
> > > Was such a large performance regression expected? Can the commit be
> > > reverted until the more fine grained solution mentioned in the commit
> > > message be implemented?
> >
> 
> First off, thanks for the quick reply. And I apologize in advance for
> any naive questions. I'm still learning how the IMA system works.
> 
> > IMA is always based on policy.  Having the "integrity LSM enabled and
> > using overlayfs" will not cause any measurements or signature
> > verifications, unless the files are in policy.
> 
> Good point. The policy we have loaded is very similar to the one we
> get from setting `ima_tcb`on the kernel command line. We just remove
> the uid=0 constraint. i.e.,
> ```
> # SECURITYFS_MAGIC
> dont_measure fsmagic=0x73636673
> # SELINUXFS_MAGIC
> dont_measure fsmagic=0xf97cff8c
> ...

The following are new rules:

> # audit files executed.
> audit func=BPRM_CHECK
> # audit executable libraries mmap'd.
> audit func=FILE_MMAP mask=MAY_EXEC
> # audit loaded kernel modules
> audit func=MODULE_CHECK
> ```
> 
> We don't have any appraisal rules loaded.

Okay.  The appraisal result of the overlay file is being cached and not
cleared on file change of the lower file.

> >
> > The problem is that unless the lower layer file is in policy, file
> > change will not be detected on the overlay filesystem.  Reverting this
> > change will allow access to a modified file without re-verifying its
> > integrity.
> 
> Given our simple policy, I think the lower layer file is included in the
> policy. So if I understand correctly, you are saying that this patch
> was meant to address the case where the lower layer wasn't
> covered by the policy?

Yes

> >
> > Instead of reverting the patch, perhaps allow users to take this risk
> > by defining a Kconfig, since they're aware of their policy rules.
> >
> 
> That sounds good. Or would it make sense to add an option to the
> policy file? i.e., `verifiable fsmagic=0x794c7630

Perhaps instead of introducing a new "action" (measure/dont_measure,
appraise/dont_appraise, audit), it should be more granular at the
policy rule level. 
Something like ignore_cache/dont_ignore_cache, depending on the
default.

Eric, does that make sense?

> FWIW, I also added the following to my policy file:
> ```
> # OVERLAYFS_SUPER_MAGIC
> dont_appraise fsmagic=0x794c7630
> dont_measure fsmagic=0x794c7630
> dont_hash fsmagic=0x794c7630
> ```
> 
> I didn't get any entries in my audit.log, but the hashing was still
> performed. I figured since tmpfs and ramfs were already marked
> as dont_measure, adding overlayfs shouldn't really be any
> different.

If you're using a modified "ima_tcb" there are "measure" action rules
which would cause files to be re-measured.  Look at the IMA measurement
list.

If you're only accessing files via the overlayfs and not the lower
layer, then there wouldn't be any audit records.

Mimi

