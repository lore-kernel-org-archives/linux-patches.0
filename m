Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 245A32D798
	for <patches@lists.linux.dev>; Tue, 17 Oct 2023 18:28:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="UPx0slwy"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39HI9Zb7017555;
	Tue, 17 Oct 2023 18:27:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=message-id : subject :
 from : to : cc : date : in-reply-to : references : content-type :
 mime-version : content-transfer-encoding; s=pp1;
 bh=ThQ7y/bkDC5CrP0Ooa7t06OEqktz1YwCfTETviDhH8c=;
 b=UPx0slwy9K+XVQ2GlC1umuoEcPVmzFhis6eBVkYckdZSWcaTifiVKgrstb10PgVOqI/a
 gssiyylQCJ1b5RxiN0XgQ/423tas+oNY/0gTl1pJUL/mb7nJG+CtXtd9RmcmfwKZlupw
 oLDYV9VFNb4UyH6AAE/ceB0R4DYG2q1ujCvqjAW1wFcx800usFxIOnVbN69mxpxlatZ0
 mk9eBnL9JWRZ4EcPVA/X4S3DQwqFO3oFWyf9pV5xXCx9JXIV1KIpqPQEoMXGVLCi6cJF
 PIdPBtRoyeGAWshoMHyomfSDQ19/v09EolQMTOiSzMryweWIuGuK2so1D5/5pPICNbX3 Wg== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tsya30r98-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Oct 2023 18:27:51 +0000
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 39HIB4HN022819;
	Tue, 17 Oct 2023 18:27:51 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3tsya30r8x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Oct 2023 18:27:51 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 39HGSxsS012949;
	Tue, 17 Oct 2023 18:27:50 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3tr5pyb27s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 17 Oct 2023 18:27:50 +0000
Received: from smtpav03.wdc07v.mail.ibm.com (smtpav03.wdc07v.mail.ibm.com [10.39.53.230])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 39HIRneX4981328
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 17 Oct 2023 18:27:49 GMT
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4FAD258054;
	Tue, 17 Oct 2023 18:27:49 +0000 (GMT)
Received: from smtpav03.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 5BEE75805A;
	Tue, 17 Oct 2023 18:27:48 +0000 (GMT)
Received: from li-f45666cc-3089-11b2-a85c-c57d1a57929f.watson.ibm.com (unknown [9.31.99.90])
	by smtpav03.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Tue, 17 Oct 2023 18:27:48 +0000 (GMT)
Message-ID: <bd5d2f882e47b904802023d5d4d54d8d4755440e.camel@linux.ibm.com>
Subject: Re: [PATCH 6.4 041/737] ovl: Always reevaluate the file signature
 for IMA
From: Mimi Zohar <zohar@linux.ibm.com>
To: Raul E Rangel <rrangel@chromium.org>,
        Greg Kroah-Hartman
	 <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
        Eric Snowberg
 <eric.snowberg@oracle.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, Tim Bain <tbain@google.com>,
        Shuhei
 Takahashi <nya@chromium.org>
Date: Tue, 17 Oct 2023 14:27:47 -0400
In-Reply-To: <ZS6xYa_kjRGvdCG6@google.com>
References: <20230911134650.286315610@linuxfoundation.org>
	 <20230911134651.582204417@linuxfoundation.org>
	 <ZS6xYa_kjRGvdCG6@google.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.28.5 (3.28.5-22.el8) 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: ejrKfiRXY4HNOWvPe80IvpMHE_CaED7R
X-Proofpoint-ORIG-GUID: OJGjl-coWaES9jMBFaC2VkkAvSO89ffj
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-17_03,2023-10-17_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 suspectscore=0 mlxscore=0
 malwarescore=0 priorityscore=1501 phishscore=0 spamscore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=788 bulkscore=0 impostorscore=0
 clxscore=1011 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2309180000 definitions=main-2310170155

On Tue, 2023-10-17 at 10:08 -0600, Raul E Rangel wrote:
> On Mon, Sep 11, 2023 at 03:38:20PM +0200, Greg Kroah-Hartman wrote:
> > 6.4-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Eric Snowberg <eric.snowberg@oracle.com>
> > 
> > [ Upstream commit 18b44bc5a67275641fb26f2c54ba7eef80ac5950 ]
> > 
> > Commit db1d1e8b9867 ("IMA: use vfs_getattr_nosec to get the i_version")
> > partially closed an IMA integrity issue when directly modifying a file
> > on the lower filesystem.  If the overlay file is first opened by a user
> > and later the lower backing file is modified by root, but the extended
> > attribute is NOT updated, the signature validation succeeds with the old
> > original signature.
> > 
> > Update the super_block s_iflags to SB_I_IMA_UNVERIFIABLE_SIGNATURE to
> > force signature reevaluation on every file access until a fine grained
> > solution can be found.
> > 
> 
> Sorry for replying to the 6.4-stable patch, I couldn't find the original
> patch in the mailing list.
> 
> We recently upgraded from 6.4.4 to 6.5.3. We have the integrity LSM
> enabled, and are using overlayfs. When we try and execute a binary from
> the overlayfs filesystem, the integrity LSM hashes the binary and all
> its shared objects every single invocation. This causes a serious
> performance regression when invoking clang thousands of times while
> building a package. We bisected the culprit down to this patch.
> 
> Here are some numbers:
> 
> With this patch + overlayfs:
> 
> 	$ time /usr/bin/clang-17 --version > /dev/null 
> 
> 	real	0m0.628s
> 	user	0m0.004s
> 	sys	0m0.624s
> 	$ time /usr/bin/clang-17 --version > /dev/null
> 
> 	real	0m0.597s
> 	user	0m0.004s
> 	sys	0m0.593s
> 
> With this patch - overlayfs:
> 
> 	$ truncate -s 1G foo.bin
> 	$ mkfs.ext4 foo.bin
> 	$ mount foo.bin /foo
> 	$ cp /usr/bin/clang-17 /foo
> 	$ time /foo/clang-17 --version > /dev/null
> 
> 	real	0m0.040s
> 	user	0m0.009s
> 	sys	0m0.031s
> 	$ time /foo/clang-17 --version > /dev/null
> 
> 	real	0m0.036s
> 	user	0m0.000s
> 	sys	0m0.037s
> 
> Without this path + overlayfs:
> 	$ time /usr/bin/clang-17 --version > /dev/null
> 
> 	real	0m0.017s
> 	user	0m0.007s
> 	sys	0m0.011s
> 	$ time /usr/bin/clang-17 --version > /dev/null
> 
> 	real	0m0.018s
> 	user	0m0.000s
> 	sys	0m0.018s
> 
> i.e., we go from ~30ms / invocation to 600ms / invocation. Building
> glibc used to take about 3 minutes, but now its taking about 20 minutes.
> 
> Our clang binary is about 100 MiB in size.
> 
> Using `perf` the following sticks out:
> 	$ perf record -g time /usr/bin/clang-17 --version
> 	--92.03%--elf_map
> 	      vm_mmap_pgoff
> 	      ima_file_mmap
> 	      process_measurement
> 	      ima_collect_measurement
> 	      |
> 	       --91.95%--ima_calc_file_hash
> 	              ima_calc_file_hash_tfm
> 	              |
> 	              |--82.85%--_sha256_update
> 	              |     |
> 	              |      --82.47%--lib_sha256_base_do_update.isra.0
> 	              |           |
> 	              |            --82.39%--sha256_transform_rorx
> 	              |
> 	               --9.10%--integrity_kernel_read
> 
> The audit.log is also logging every clang invocation as well.
> 
> Was such a large performance regression expected? Can the commit be
> reverted until the more fine grained solution mentioned in the commit
> message be implemented?

IMA is always based on policy.  Having the "integrity LSM enabled and
using overlayfs" will not cause any measurements or signature
verifications, unless the files are in policy.

The problem is that unless the lower layer file is in policy, file
change will not be detected on the overlay filesystem.  Reverting this
change will allow access to a modified file without re-verifying its
integrity.

Instead of reverting the patch, perhaps allow users to take this risk
by defining a Kconfig, since they're aware of their policy rules.

-- 
thanks,

Mimi

