Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6669B3C6AB;
	Wed, 21 Feb 2024 09:16:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708506986; cv=none; b=dj1Z2s3c0LQWxci2jHXBmJafXIt8B+mGE9857bkWIwQcmcGl+iBwsPbasrjiiW0ZasX9Lg+KNslvAV8SYLEuLieIm3lGlI+rjeJcoS2W8h8iXQ6Yvg7N1K09NMF5qEH4Bv93Cb8ydP5K8h05SB/Vp3lGyu6QzVyKHW7X5oStCHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708506986; c=relaxed/simple;
	bh=oTE4Ln4kYMfpmBPnks4Wfek2SuDUC2rvJeqBR67tew0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=szIIFvdZYLQXNlYdyGcZApCMPdIhROLIWO28OAiByF7J/fEKq2YF/Neal34EMgtoSICkgFLmfw67Qx1VxjL4MtFbd2mn6+DPPAN8D7qxVDIYOkomkoOlVkmTfEeZPdvQjasVxkDRPYxkkLdkl7RZtPtpAfSBE7dTHjuBjBOCVdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=Y+nWMqb0; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="Y+nWMqb0"
Received: from pps.filterd (m0353725.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41L910hO028490;
	Wed, 21 Feb 2024 09:16:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=+p5jWd5LnOJpV2l/GmH93lXMehuKHQA1ll7wcjtLdTo=;
 b=Y+nWMqb0aqsWOjOUBl+pgj8hwJbr/uKJCHD8qPLO52zBkW4q0z2xJvzfnlhhiyrswh+V
 2FinBoOHOUvmWB25VRxuQ6cd2KdRNzOdNhjYqX97e5ih9RvG/hqhK0aXENCxMzUs2yOs
 qidfYp1p5TF1QZsxIPQMe/mpayjfRT1qJx3GcosjUnuday0psG3B2Ce693QBi0b4UGDC
 WSMeOJv2JuemzGjXxIFiHglyihRqxmQNnPHo/XFe8aXKnThvb/tpJCwMLX3l5O4ghVZ/
 KwrKT+xPdwiuLIQebO4WSFoNyZ9soxIDZZ8S6qfjmESzCPdwQBYOxkP/5nd9hoGuDG7S jw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wdcy2tagf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Feb 2024 09:16:20 +0000
Received: from m0353725.ppops.net (m0353725.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41L9DxSZ001065;
	Wed, 21 Feb 2024 09:16:20 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3wdcy2taga-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Feb 2024 09:16:20 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 41L7l3GP013522;
	Wed, 21 Feb 2024 09:16:19 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3wb7h0eawe-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 21 Feb 2024 09:16:19 +0000
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 41L9GD2j66060652
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 Feb 2024 09:16:15 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 9B72D20040;
	Wed, 21 Feb 2024 09:16:13 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6F56D2004D;
	Wed, 21 Feb 2024 09:16:13 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Wed, 21 Feb 2024 09:16:13 +0000 (GMT)
Date: Wed, 21 Feb 2024 10:16:12 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, morbo@google.com, justinstitt@google.com,
        linux-s390@vger.kernel.org, llvm@lists.linux.dev,
        patches@lists.linux.dev
Subject: Re: [PATCH] s390/boot: Workaround current 'llvm-objdump -t -j ...'
 behavior
Message-ID: <20240221091612.7561-A-hca@linux.ibm.com>
References: <20240220-s390-work-around-llvm-objdump-t-j-v1-1-47bb0366a831@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240220-s390-work-around-llvm-objdump-t-j-v1-1-47bb0366a831@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: -VWjRl9whk2FYe6flG8AeHVnD9fVEb8E
X-Proofpoint-GUID: jnI5j-Cgq_ahPR6YFhyiFynHM2ZcDG7C
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-20_06,2024-02-20_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 clxscore=1015 mlxscore=0
 priorityscore=1501 lowpriorityscore=0 mlxlogscore=999 suspectscore=0
 spamscore=0 phishscore=0 malwarescore=0 bulkscore=0 impostorscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402210071

Hi Nathan,

On Tue, Feb 20, 2024 at 01:44:48PM -0700, Nathan Chancellor wrote:
> When building with OBJDUMP=llvm-objdump, there are a series of warnings
> from the section comparisons that arch/s390/boot/Makefile performs
> between vmlinux and arch/s390/boot/vmlinux:
...
> It may be possible to change llvm-objdump's behavior to match GNU
> objdump's behavior but the difficulty of that task has not yet been
> explored. The combination of '$(OBJDUMP) -t -j' is not common in the
> kernel tree on a whole, so workaround this tool difference by grepping
> for the sections in the full symbol table output in a similar manner to
> the sed invocation. This results in no visible change for GNU objdump
> users while fixing the warnings for OBJDUMP=llvm-objdump, further
> enabling use of LLVM=1 for ARCH=s390 with versions of LLVM that have
> support for s390 in ld.lld and llvm-objcopy.
> 
> Reported-by: Heiko Carstens <hca@linux.ibm.com>
> Closes: https://lore.kernel.org/20240219113248.16287-C-hca@linux.ibm.com/
> Link: https://github.com/ClangBuiltLinux/linux/issues/859
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
> s390 llvm-objcopy support may be backported to LLVM 18.1.0 in time for
> the final release.
> 
> https://github.com/llvm/llvm-project/pull/82324
> 
> s390 ld.lld has already made it into release/18.x:
> 
> https://github.com/llvm/llvm-project/commit/0a44c3792a6ff799df5f100670d7e19d1bc49f03
> 
> If the objcopy change makes 18.1.0 final, features + this change should
> build cleanly with LLVM 18.1.0+ using LLVM=1 :)
> ---
>  arch/s390/boot/Makefile | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

This seems to work like expected (also verified with a couple of scenarios
where things are supposed to break).

So compiling the kernel with LLVM=1 finally works on s390!

Patch applied - Thanks a lot!
