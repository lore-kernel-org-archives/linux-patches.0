Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C642C1A4;
	Mon, 19 Feb 2024 11:33:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708342388; cv=none; b=f4ZFTLakQ+pmiM5pSN9T8IXhAZi6QqYca8RTWN6xuTWyanu+tJmUotXDsNALVXiDBmHMoWTJ1t+iGQJp4gNChIgiAv+Klco79KbP2B5KqBP9c0ckFXoQPdR9DPmHCtk7O80F/b33FUEZe+vCCRov4pi4imcKnGcKZLLG3QaJ0Ys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708342388; c=relaxed/simple;
	bh=q3OgKGBLQH4CQA76SPhj2hYdHhoqYqbM4orJsKCy2Us=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=KMBMnTu2SQ2hRxH305iflBk3nZnqoSf0//UZpxZ4g/HTQFq1nEqW4mGgR5DgPr2ijr0IhxGYAcYGBK53rttiOkEyPLnYbiIfJ0/H8ySyiEk34DUB5ge7pX74wWm+tEg8zxZs6Yebev9RuadHcTqOE1JHZgmB1v5ZxDrhIMHIFv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=PFhL5/6r; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="PFhL5/6r"
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41JBVYnm002703;
	Mon, 19 Feb 2024 11:32:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=QOIGiJXS0kCrUb52vZWGle+vts6LdtHclvXKlEopLSE=;
 b=PFhL5/6rnQLZh2Ny5ZS4zTTdWfoTdmwCYJP75W7dc9FWNaZgL3J5MjKlQl/L+gvoXA+p
 jiYVUnCVoO9TlQQUdRAb26W+5LvPHbTuTCSzFJqkaRda+1bBgPcJme0Yf9j8XthvAJ9o
 cG8QTANTVbav0tdybC5S2ll9QfOH3DL9hpPJOXqBgmdW/ZfsbY6xGN0CNDqLwSmFypxv
 uvqVFc96T5GFdWOese67X3SEmTHJCJs3CEi/4MJKEMj/xwqbzP/5qc0TVZI2JbzOLaWU
 qmdJ/AXL7zsyVMg6zzoh/uv6xYZRcEwL4aD/L+sdXsTlNTj0uKg6mzeE92RiwVVBD2d+ JQ== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wc25f669q-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 Feb 2024 11:32:59 +0000
Received: from m0353724.ppops.net (m0353724.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41JBWEAW005841;
	Mon, 19 Feb 2024 11:32:58 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wc25f669j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 Feb 2024 11:32:58 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 41J9fuCh031153;
	Mon, 19 Feb 2024 11:32:58 GMT
Received: from smtprelay05.fra02v.mail.ibm.com ([9.218.2.225])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3wb9bkgf30-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 19 Feb 2024 11:32:57 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay05.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 41JBWoKZ2097888
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 19 Feb 2024 11:32:52 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 3F19720076;
	Mon, 19 Feb 2024 11:32:50 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A65572008A;
	Mon, 19 Feb 2024 11:32:49 +0000 (GMT)
Received: from osiris (unknown [9.171.27.39])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Mon, 19 Feb 2024 11:32:49 +0000 (GMT)
Date: Mon, 19 Feb 2024 12:32:48 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, morbo@google.com, justinstitt@google.com,
        linux-s390@vger.kernel.org, llvm@lists.linux.dev,
        patches@lists.linux.dev, Ulrich Weigand <ulrich.weigand@de.ibm.com>
Subject: Re: [PATCH] s390/boot: Add 'alloc' to info.bin .vmlinux.info section
 flags
Message-ID: <20240219113248.16287-C-hca@linux.ibm.com>
References: <20240216-s390-fix-boot-with-llvm-objcopy-v1-1-0ac623daf42b@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240216-s390-fix-boot-with-llvm-objcopy-v1-1-0ac623daf42b@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-GUID: t57RWNUPYBZq92Vfzf1KOcDHFMh7n2kQ
X-Proofpoint-ORIG-GUID: 2lkby0vVw_We-XKwWx8vfnYKZPLz8cHu
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-19_08,2024-02-16_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 malwarescore=0 bulkscore=0 adultscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 spamscore=0 clxscore=1015 priorityscore=1501 mlxscore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402190087

On Fri, Feb 16, 2024 at 12:55:53PM -0700, Nathan Chancellor wrote:
> When attempting to boot a kernel compiled with OBJCOPY=llvm-objcopy,
> there is a crash right at boot:
> 
>   Out of memory allocating 6d7800 bytes 8 aligned in range 0:20000000
>   Reserved memory ranges:
>   0000000000000000 a394c3c30d90cdaf DECOMPRESSOR
>   Usable online memory ranges (info source: sclp read info [3]):
>   0000000000000000 0000000020000000
>   Usable online memory total: 20000000 Reserved: a394c3c30d90cdaf Free: 0
>   Call Trace:
>   (sp:0000000000033e90 [<0000000000012fbc>] physmem_alloc_top_down+0x5c/0x104)
>    sp:0000000000033f00 [<0000000000011d56>] startup_kernel+0x3a6/0x77c
>    sp:0000000000033f60 [<00000000000100f4>] startup_normal+0xd4/0xd4
> 
> GNU objcopy does not have any issues. Looking at differences between the
> object files in each build reveals info.bin does not get properly
> populated with llvm-objcopy, which results in an empty .vmlinux.info
> section.
...
> Closes: https://github.com/ClangBuiltLinux/linux/issues/1996
> Link: https://github.com/llvm/llvm-project/commit/3c02cb7492fc78fb678264cebf57ff88e478e14f
> Suggested-by: Ulrich Weigand <ulrich.weigand@de.ibm.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Thanks a lot, applied!

However when building the kernel with "LLVM=1" I can see
something else which looks like an llvm-objdump bug to me:

$make LLVM=1 bzImage
...
  SECTCMP .boot.data
llvm-objdump: warning: section '.boot.data' mentioned in a -j/--section option, but not found in any input file

This works without warning with GNU objcopy, and actually the output
is also different:

$ objdump -v
GNU objdump (GNU Binutils for Ubuntu) 2.41

$ objdump -t -j .boot.data arch/s390/boot/vmlinux

arch/s390/boot/vmlinux:     file format elf64-s390

SYMBOL TABLE:
0000000000020000 l     O .boot.data     0000000000003000 sclp_info_sccb
00000000000240e0 l     O .boot.data     0000000000000001 sclp_info_sccb_valid
0000000000023010 g     O .boot.data     0000000000000008 ident_map_size
0000000000023018 g     O .boot.data     00000000000010c8 physmem_info
00000000000250e2 g       .boot.data     0000000000000000 __boot_data_end
0000000000020000 g       .boot.data     0000000000000000 __boot_data_start
00000000000240e2 g     O .boot.data     0000000000001000 early_command_line
0000000000023008 g     O .boot.data     0000000000000008 early_ipl_comp_list_size
0000000000023000 g     O .boot.data     0000000000000008 early_ipl_comp_list_addr

While with llvm-copy:

$ llvm-objdump --version
LLVM (http://llvm.org/):
  LLVM version 19.0.0git

$ llvm-objdump -t -j .boot.data arch/s390/boot/vmlinux

arch/s390/boot/vmlinux: file format elf64-s390

SYMBOL TABLE:
0000000000000200 l       .head.text     0000000000000000 ipl_start
0000000000010020 l       .head.text     00000000000000d4 startup_normal
00000000000101b0 l       .head.text     00000000000000b2 startup_kdump
0000000000010280 l       .head.text     000000000000005a startup_pgm_check_handler
000000000001025c l       .head.text     0000000000000000 startup_kdump_relocated
0000000000000000 l    df *ABS*  0000000000000000 als.c
000000000001e040 l     O .rodata        0000000000000018 als
000000000001f6f0 l     O .data  0000000000000050 print_missing_facilities.als_str
0000000000011800 l     F .text  00000000000000e2 print_machine_type
...
0000000000020000 l     O .boot.data     0000000000003000 sclp_info_sccb
00000000000240e0 l     O .boot.data     0000000000000001 sclp_info_sccb_valid
... and so on (everything is dumped)
llvm-objdump: warning: section '.boot.data' mentioned in a -j/--section option, but not found in any input file

So somehow llvmdump's "-j/--section" option doesn not seem to work.
