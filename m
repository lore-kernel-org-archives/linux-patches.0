Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3201321ABC6;
	Wed, 30 Apr 2025 15:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746027236; cv=none; b=Wh2RRoizDGARCOUZINI1u3F2fBHGzctgZ3uWfHswXB/pLJNfrZ/v6bxjCXl/6EbAA0I04nrK9SCqXd2kIxgS9Avxpzcv6RWZS1UvnZFNLVKTEKuOYdl5LNoY1NfiL+Ba1CIKBSfmTY/9E95SsEKfOXMEFJK0e0AKuuRTbucgBu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746027236; c=relaxed/simple;
	bh=8YqhwQ56qWWKSZbcPxlFRP1HJoZQdqfrBv3dl/MkcHg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=uGErY9LqoArvnU4Lg31L0EdfLX2RQh7XTNFCQ8pdpFdQWIzopUuQvIkhStHjfued8HC11+UyqDY1KrdC13h7J055hsa3hQBmH4XZdJGjPOceq/3VExhJAfBv489Gzo7/VKmD7P4orsXSAd5gumlawlbK20TxCqVTsNeYkwCRAVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=jd+LnT8J; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="jd+LnT8J"
Received: from pps.filterd (m0360083.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53UA4D5w006400;
	Wed, 30 Apr 2025 15:33:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=NUvm9H
	VviMbXOTRxu29ZZVxO6TjfFLwh95KyRi8FbSU=; b=jd+LnT8JWqWYQ8jCFqPPFB
	YmNEIzmL63znwB7Bq/6rWA5ddjv1nz7cmIL07tO2j5ZKXgWXaFUYpJW/Q8EgmBr4
	E16nNwf94/XLfouTxrq7f/2JRsTWwmolWgEahbJI4fToI/+6cVVIuQVgQfbRUya8
	JU4X6yjtujifxDr7eRCpjC5WIU2hTjw5BJAzrtsUaprSgQoKd0BjShFQlgo8yuo4
	ucnBS0rbxvkWkPzMps3IOXmFIKr8ti15xjzcw4ZjlIhc5dP4sOna4c+HxZT05DPP
	oVq6TtJI/TmWTqMvO/iR5gf48ErjikbwLzWnagLFSZRDxxG3/IPl9E5pFVO26NfQ
	==
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46bhsjsk3m-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Apr 2025 15:33:51 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 53UCsUJ4001791;
	Wed, 30 Apr 2025 15:33:50 GMT
Received: from smtprelay05.wdc07v.mail.ibm.com ([172.16.1.72])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 469bamrcb2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Apr 2025 15:33:50 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay05.wdc07v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 53UFXmD731785690
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Apr 2025 15:33:49 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id E210E58055;
	Wed, 30 Apr 2025 15:33:48 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 7787858066;
	Wed, 30 Apr 2025 15:33:47 +0000 (GMT)
Received: from [9.111.36.251] (unknown [9.111.36.251])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 30 Apr 2025 15:33:47 +0000 (GMT)
Message-ID: <b2609f9018e9a9897233ee71be19ac64d6408e07.camel@linux.ibm.com>
Subject: Re: [PATCH 6.1 038/167] s390/pci: Report PCI error recovery results
 via SCLP
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Halil Pasic <pasic@linux.ibm.com>,
        Alexander
 Gordeev <agordeev@linux.ibm.com>,
        Sasha Levin <sashal@kernel.org>
Date: Wed, 30 Apr 2025 17:33:46 +0200
In-Reply-To: <20250429161053.295203006@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
	 <20250429161053.295203006@linuxfoundation.org>
Autocrypt: addr=schnelle@linux.ibm.com; prefer-encrypt=mutual;
 keydata=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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.54.3 (3.54.3-1.fc41) 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Authority-Analysis: v=2.4 cv=dcuA3WXe c=1 sm=1 tr=0 ts=681242df cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=VnNF1IyMAAAA:8 a=VwQbUJbxAAAA:8 a=dHsNYD73hYLi79cDiOUA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: 96K3M3-MIYyzdAgezgqg22xNEtEnYdGR
X-Proofpoint-ORIG-GUID: 96K3M3-MIYyzdAgezgqg22xNEtEnYdGR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDMwMDEwNyBTYWx0ZWRfX40x0unhBVw1o NYmU31JjkNDXlI4OwMtgv6lBfa/QIUBTFDk3f2qZaJbxGLHa2r+L76FV0Lqbp3RdnhjK0ikRPUV Or2NxE7As/6fOSEKmdjVgD2fwx1RBPqML1eqFdkkfaGuQRYokFnd5xw1XZYACzJbf1yWNT+b8fU
 ty0NHqvnDqhNsrd9mWkt09LZrPe8uYYy5H1gtF4/MrEsZJwhzpNkfMwmpnvp7fozdMgXqRktxSp s4tYsJZ1jW5KqBD0epfAIMiQ/EZWVxeFGskYlbvoFLwfIw9q1eALmkZnpNQTzfPQW0oV5N1fyjS 1D5OJ5snjI2sRCDrigDsuF/bsfPQOYzeo0A/LKrpoCB4HrCNWU5Ix/rhY3GvrbmC7gDljSIAXFL
 wkFR63WHMhzMH2RAGlVw7nNdPRI1ba/wFfNxr4Frqj0t9t331OKBMFGSkCzYk4L0Q4gNKerq
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-30_04,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 suspectscore=0
 spamscore=0 impostorscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 priorityscore=1501 lowpriorityscore=0
 clxscore=1015 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504300107

On Tue, 2025-04-29 at 18:42 +0200, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Niklas Schnelle <schnelle@linux.ibm.com>
>=20
> [ Upstream commit 4ec6054e7321dc24ebccaa08b3af0d590f5666e6 ]
>=20
> Add a mechanism with which the status of PCI error recovery runs
> is reported to the platform. Together with the status supply additional
> information that may aid in problem determination.
>=20
> Reviewed-by: Halil Pasic <pasic@linux.ibm.com>
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> Signed-off-by: Alexander Gordeev <agordeev@linux.ibm.com>
> Stable-dep-of: aa9f168d55dc ("s390/pci: Support mmap() of PCI resources e=
xcept for ISM devices")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/s390/include/asm/sclp.h |  33 +++++++++++
>  arch/s390/pci/Makefile       |   2 +-
>  arch/s390/pci/pci_event.c    |  21 +++++--
>  arch/s390/pci/pci_report.c   | 111 +++++++++++++++++++++++++++++++++++
>  arch/s390/pci/pci_report.h   |  16 +++++
>  drivers/s390/char/sclp.h     |  14 -----
>  drivers/s390/char/sclp_pci.c |  19 ------
>  7 files changed, 178 insertions(+), 38 deletions(-)
>  create mode 100644 arch/s390/pci/pci_report.c
>  create mode 100644 arch/s390/pci/pci_report.h
>=20
> diff --git a/arch/s390/include/asm/sclp.h b/arch/s390/include/asm/sclp.h
> index 9d4c7f71e070f..e64dac00e7bf7 100644
> --- a/arch/s390/include/asm/sclp.h
> +++ b/arch/s390/include/asm/sclp.h
>=20
--- snip ---
> diff --git a/arch/s390/pci/pci_report.c b/arch/s390/pci/pci_report.c
> new file mode 100644
> index 0000000000000..2754c9c161f5b
> --- /dev/null
> +++ b/arch/s390/pci/pci_report.c
> @@ -0,0 +1,111 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright IBM Corp. 2024
> + *
> + * Author(s):
> + *   Niklas Schnelle <schnelle@linux.ibm.com>
> + *
> + */
> +
> +#define KMSG_COMPONENT "zpci"
> +#define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
> +
> +#include <linux/kernel.h>
> +#include <linux/sprintf.h>
>=20

This seems to cause a compile error due to missing linux/sprintf.h,
not sure if that is a good target for a backport? I also don't remember
running into this during my backports for the enterprise distributions
so maybe they have that backported.

Also, this was pulled in as a dependency for commit aa9f168d55dc
("s390/pci: Support mmap() of PCI resources except for ISM devices")
but I'm not sure why that would depend on this? The only thing I can
think of is the Makefile change to add pci_fixup.c also having
pci_report.c in it.

For context I did backports for this for RHEL 10.0, and RHEL 9.6 and it
was also backported for Ubuntu 25.04 and SLES 16 SP 0. That was for a
larger series of improving debug information gathering though not as
dependencies. There I included the following upstream commits:

897614f90f7c ("s390/debug: Pass in and enforce output buffer size for forma=
t handlers")
4c41a48f5f3e ("s390/pci: Add pci_msg debug view to PCI report")
dc18c81a57e7 ("s390/debug: Add a reverse mode for debug_dump()")
5f952dae48d0 ("s390/debug: Add debug_dump() to write debug view to a string=
 buffer")
460c52a57f83 ("s390/debug: Split private data alloc/free out of file operat=
ions")
7832b3047d10 ("s390/debug: Simplify and document debug_next_entry() logic")
4ec6054e7321 ("s390/pci: Report PCI error recovery results via SCLP")


Not sure what the stable policy is on such stuff and if staying in sync
with the above mentioned distributions for s390 is=C2=A0desirable and/or
worth the effort.

Thanks,
Niklas


