Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B27043D3BC
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 12:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="VPy1aWz2"
Received: from pps.filterd (m0353724.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3B5CTxAS011691;
	Tue, 5 Dec 2023 12:59:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=pp1; bh=oTkHANlYxjRrDeXCYit/DiQRJaRR2NK4A3Lk1cRXeII=;
 b=VPy1aWz2h7j1eE0gRo5pUOETRyElkMlzJTArTesRs0O93js+iiQzio0sEVrT4/ew0u6s
 trNy5iYTytMGVPA0I51GGZgA7C0jz9fGEHmCK2q4twDWC7qyxthhgwQZSUNyxB6h/tW8
 uSRtJj0C3GH1W07sLrzAwVdOsV+Chp694qi2Z6DW4yL39U3LqnnCS1T3/Tsw1NzfNh8m
 EFxES+WygCYc25Hgvyun2re+rmklD31P8Il+z59GTQOvunkAJIZ6DZUwowktwSMpUPQA
 N9lYiCQZft77N+hefUnGHLdtVrQIE0TR9LLplq8wl8QX0Db3YDACNt91os8g3+M6tuyf Tg== 
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3ut3wsrrkb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Dec 2023 12:59:07 +0000
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 3B5AsEK3009911;
	Tue, 5 Dec 2023 12:59:07 GMT
Received: from smtprelay07.fra02v.mail.ibm.com ([9.218.2.229])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 3urh4ke9ej-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Tue, 05 Dec 2023 12:59:07 +0000
Received: from smtpav04.fra02v.mail.ibm.com (smtpav04.fra02v.mail.ibm.com [10.20.54.103])
	by smtprelay07.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 3B5Cx4d014221860
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 5 Dec 2023 12:59:04 GMT
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 622D32004F;
	Tue,  5 Dec 2023 12:59:04 +0000 (GMT)
Received: from smtpav04.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B64A220040;
	Tue,  5 Dec 2023 12:59:03 +0000 (GMT)
Received: from li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com (unknown [9.171.82.153])
	by smtpav04.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Tue,  5 Dec 2023 12:59:03 +0000 (GMT)
Date: Tue, 5 Dec 2023 13:59:02 +0100
From: Alexander Gordeev <agordeev@linux.ibm.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: akpm@linux-foundation.org, hca@linux.ibm.com, gor@linux.ibm.com,
        borntraeger@linux.ibm.com, svens@linux.ibm.com,
        linux-s390@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH 2/2] s390/traps: Only define is_valid_bugaddr() under
 CONFIG_GENERIC_BUG
Message-ID: <ZW8elkUWKlEBezWl@li-008a6a4c-3549-11b2-a85c-c5cc2836eea2.ibm.com>
References: <20231130-s390-missing-prototypes-v1-0-799d3cf07fb7@kernel.org>
 <20231130-s390-missing-prototypes-v1-2-799d3cf07fb7@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231130-s390-missing-prototypes-v1-2-799d3cf07fb7@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: Ckp2e_xzcBMq0ibexAIaB7qlmwHi6IsM
X-Proofpoint-GUID: Ckp2e_xzcBMq0ibexAIaB7qlmwHi6IsM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.997,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-12-05_07,2023-12-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0 lowpriorityscore=0
 spamscore=0 clxscore=1015 mlxlogscore=694 adultscore=0 phishscore=0
 impostorscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311060000 definitions=main-2312050101

On Thu, Nov 30, 2023 at 05:22:33PM -0700, Nathan Chancellor wrote:
> When building with -Wmissing-prototypes without CONFIG_GENERIC_BUG,
> there is a warning about a missing prototype for is_valid_bugaddr():
> 
>   arch/s390/kernel/traps.c:46:5: warning: no previous prototype for 'is_valid_bugaddr' [-Wmissing-prototypes]
>      46 | int is_valid_bugaddr(unsigned long addr)
>         |     ^~~~~~~~~~~~~~~~
> 
> The prototype is only declared with CONFIG_GENERIC_BUG, so only define
> the function under the same condition to clear up the warning, which
> matches other architectures.
> 
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  arch/s390/kernel/traps.c | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/s390/kernel/traps.c b/arch/s390/kernel/traps.c
> index 1d2aa448d103..cc3e3a01dfa5 100644
> --- a/arch/s390/kernel/traps.c
> +++ b/arch/s390/kernel/traps.c
> @@ -43,10 +43,12 @@ static inline void __user *get_trap_ip(struct pt_regs *regs)
>  	return (void __user *) (address - (regs->int_code >> 16));
>  }
>  
> +#ifdef CONFIG_GENERIC_BUG
>  int is_valid_bugaddr(unsigned long addr)
>  {
>  	return 1;
>  }
> +#endif
>  
>  void do_report_trap(struct pt_regs *regs, int si_signo, int si_code, char *str)
>  {

Reviewed-by: Alexander Gordeev <agordeev@linux.ibm.com>
