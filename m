Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 053125F470;
	Thu,  1 Feb 2024 14:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706799420; cv=none; b=LuGKVrrGwblai98CBd+ITeNI/A623LaIdHXDFFo4OfnyarggTzHANdUe4IuvRA1hdTBsCvJC+NiysytXK/TjfC5t7EigNCeYszNzPrKzFIQbMFmSuB1fPokRsvu//aFa4b+092K4UtMsh6YiWye0j9H10cuMsfcDyl9QOySKsZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706799420; c=relaxed/simple;
	bh=CaSotTQtZ5ozZfcAG4oJoZ1J7EEJkM5AAbIB9wkqbQ0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:Content-Type:
	 Content-Disposition:In-Reply-To:MIME-Version; b=JASrVs05Dyxr4EoksP3gRmSMuiusDKzajmL6k5EpiP+Z+s3XdllbtDTB8JkuMVbBpdNAGBBskJLPVMagWIH5ff0wr4aX3FZJWNEYb0OO/iAO6iVJqQRDi/yyx9q3+stF+ACQrzIaNxlPvlI102WTMcigFbJPSjkmdulAi2z7NY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=kYkLMXsY; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="kYkLMXsY"
Received: from pps.filterd (m0353723.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 411DbtPw015939;
	Thu, 1 Feb 2024 14:56:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=date : from : to : cc :
 subject : message-id : references : content-type : in-reply-to :
 mime-version; s=pp1; bh=g8OYxdlzV2huCmFXMtD3CVpkeVuBkFHmLcR3IGc+A6w=;
 b=kYkLMXsYcB7O5QWFlhSuk2jdSdXOUa0djF9mPWotSWwuQCP/jy7WHUmsKHpgHAX0F1nX
 DnbcnyUvce8L3B186EKtJpW1oDTvv6+OnhaoTG7HM4nS2Lm+luPJcJzg2M1b/7Mq1aQi
 h8BTBh99RPdzyEJm/x6mIal+n7GQGr4yLV2rs+YBOQ+t32xzBDLoMLXxT5arM8nw9kir
 SSrvA+WmV2Z/eY8Kls4uQchqdyjyZbaf/fW28fR1ER1//9jCJRahs0UXd3doH1sHBCx/
 GTlV2i/2JsS806fkdpGj+/VTzRw4ALQAHuLbWeB9iVXNeTfLuG5dNVMMbRhwOt2WzmKB Cw== 
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w0cbmah15-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 14:56:55 +0000
Received: from m0353723.ppops.net (m0353723.ppops.net [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 411EIY21006343;
	Thu, 1 Feb 2024 14:56:55 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 3w0cbmagwj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 14:56:54 +0000
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.17.1.19/8.17.1.19) with ESMTP id 411C1vw4017712;
	Thu, 1 Feb 2024 14:56:47 GMT
Received: from smtprelay01.fra02v.mail.ibm.com ([9.218.2.227])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 3vwcj04y21-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 01 Feb 2024 14:56:47 +0000
Received: from smtpav06.fra02v.mail.ibm.com (smtpav06.fra02v.mail.ibm.com [10.20.54.105])
	by smtprelay01.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 411Eui6G9110112
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 1 Feb 2024 14:56:44 GMT
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 4CF8120049;
	Thu,  1 Feb 2024 14:56:44 +0000 (GMT)
Received: from smtpav06.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1D38D20040;
	Thu,  1 Feb 2024 14:56:44 +0000 (GMT)
Received: from osiris (unknown [9.152.212.60])
	by smtpav06.fra02v.mail.ibm.com (Postfix) with ESMTPS;
	Thu,  1 Feb 2024 14:56:44 +0000 (GMT)
Date: Thu, 1 Feb 2024 15:56:41 +0100
From: Heiko Carstens <hca@linux.ibm.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
        svens@linux.ibm.com, ndesaulniers@google.com, morbo@google.com,
        justinstitt@google.com, linux-s390@vger.kernel.org,
        llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] s390: vDSO: Drop '-fPIC' from LDFLAGS
Message-ID: <20240201145641.6306-B-hca@linux.ibm.com>
References: <20240130-s390-vdso-drop-fpic-from-ldflags-v1-1-094ad104fc55@kernel.org>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240130-s390-vdso-drop-fpic-from-ldflags-v1-1-094ad104fc55@kernel.org>
X-TM-AS-GCONF: 00
X-Proofpoint-ORIG-GUID: JgClveuNjKfH-p9xrdS5lZnCQ04OA8y4
X-Proofpoint-GUID: 1baswst15a3OfxG9HL0-iu4ArqovshOg
X-Proofpoint-UnRewURL: 0 URL was un-rewritten
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-01_02,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 mlxlogscore=890
 suspectscore=0 priorityscore=1501 impostorscore=0 mlxscore=0
 lowpriorityscore=0 spamscore=0 bulkscore=0 phishscore=0 malwarescore=0
 clxscore=1011 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402010118

On Tue, Jan 30, 2024 at 08:14:28PM -0700, Nathan Chancellor wrote:
> '-fPIC' as an option to the linker does not do what it seems like it
> should. With ld.bfd, it is treated as '-f PIC', which does not make
> sense based on the meaning of '-f':
> 
>   -f SHLIB, --auxiliary SHLIB Auxiliary filter for shared object symbol table
> 
> When building with ld.lld (currently under review in a GitHub pull
> request), it just errors out because '-f' means nothing and neither does
> '-fPIC':
> 
>   ld.lld: error: unknown argument '-fPIC'
> 
> '-fPIC' was blindly copied from CFLAGS when the vDSO stopped being
> linked with '$(CC)', it should not be needed. Remove it to clear up the
> build failure with ld.lld.
> 
> Fixes: 2b2a25845d53 ("s390/vdso: Use $(LD) instead of $(CC) to link vDSO")
> Link: https://github.com/llvm/llvm-project/pull/75643
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Applied.

> Hi all,
> 
> The LLVM folks are working on SystemZ support in ld.lld and this issue
> came up from my initial testing. There are also some other issues that I
> have come across in testing that I note in the GitHub pull request
> linked above. If they seem like kernel issues, any expertise or help
> would be greatly appreciated towards getting this working.

This is great news! Please feel free to involve us at any time.
We will do our best to help if possible.
