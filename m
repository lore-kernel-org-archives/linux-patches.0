Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905B4253F32;
	Wed, 30 Apr 2025 15:36:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746027386; cv=none; b=LzgU+POAf7f/ao3VMs8O9Eoz7SA48mFifxPBHCdOvpGv1vygVoV98YMf0TIxArzc7ZbecTcO2mSULk5CM0M4vkgGxYaAfdEJY61n9fEVNyWC2GhutZjlhTCuxNjxV2fVI9HHMaBPPk4cSNmX6Kg9bwhDBWU8KXqEbepcsvc15xE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746027386; c=relaxed/simple;
	bh=yvJWhklhiQg5zgFbWfOmpnwhPXhHn+YJ/mE8QDyAjk0=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=hsyl5VQW+mOhmgn8BVVXdWF8ZcZyGrUZE6O5Xf1JO6KKhfADhvon8Cb9J/fV06tS8GvAFIyqDck9Pil4g80xGi2NFOPLANfIj/w8IhqY93IqBZRvpqt3vbckviXtfAhewBA4Y5WQf6SPfvP+GJnMjIjFXYXr4BpNmRSWbpeZ9rk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=QQ+kxOb8; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="QQ+kxOb8"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53UAepr2010941;
	Wed, 30 Apr 2025 15:36:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=JtNXDB
	zssud0Fnzs7wmWQTMeiApbkLrMgOegYCZ8s2c=; b=QQ+kxOb808eDUnSFpNLm4Q
	WbF7nWbhNhW7VN7yV5wkUYrMx5vNDq2e2lBcuC40BwFCMFlodH8BGVBKi7JF9v4N
	i2eF7pEl9xeth1tPGGjiRH/NucT/VOZvXMs89irNGtfATrZ0ZTjEo0zAEwodfS2R
	P8gF0jlgebit2KICEhE5hCnswJms1u/4Gtmxw0PBGxagVbvFbW/Jhvr+KhXt+lh2
	FiT8UWjYlcegYtPVRpvI9FB7N6U0vGOyLabOAlspcYctv+Ogb7bFm5SfT0jn+hH8
	Zqn7vBme3jULaB03o8I3gQTTCCYn2UQEG9yD99Y2/HemcGoyXGGaTS86C/rSwXQQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46bjas1dt8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Apr 2025 15:36:19 +0000 (GMT)
Received: from m0356516.ppops.net (m0356516.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 53UFUMaj010440;
	Wed, 30 Apr 2025 15:36:19 GMT
Received: from ppma23.wdc07v.mail.ibm.com (5d.69.3da9.ip4.static.sl-reverse.com [169.61.105.93])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46bjas1dt2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Apr 2025 15:36:19 +0000 (GMT)
Received: from pps.filterd (ppma23.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma23.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 53UD0QPH001880;
	Wed, 30 Apr 2025 15:36:16 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma23.wdc07v.mail.ibm.com (PPS) with ESMTPS id 469bamrckj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Apr 2025 15:36:16 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 53UFaFOs31261400
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Apr 2025 15:36:15 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 0F9B958056;
	Wed, 30 Apr 2025 15:36:15 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id C27F558054;
	Wed, 30 Apr 2025 15:36:13 +0000 (GMT)
Received: from [9.111.36.251] (unknown [9.111.36.251])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 30 Apr 2025 15:36:13 +0000 (GMT)
Message-ID: <fd60973b1901ad1604e163e4bb3bd188879288fa.camel@linux.ibm.com>
Subject: Re: [PATCH 6.1 039/167] s390/pci: Support mmap() of PCI resources
 except for ISM devices
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Bjorn Helgaas <bhelgaas@google.com>,
        Sasha
 Levin	 <sashal@kernel.org>
Date: Wed, 30 Apr 2025 17:36:12 +0200
In-Reply-To: <20250429161053.337884386@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
	 <20250429161053.337884386@linuxfoundation.org>
Autocrypt: addr=schnelle@linux.ibm.com; prefer-encrypt=mutual;
 keydata=mQINBGHm3M8BEAC+MIQkfoPIAKdjjk84OSQ8erd2OICj98+GdhMQpIjHXn/RJdCZLa58k
 /ay5x0xIHkWzx1JJOm4Lki7WEzRbYDexQEJP0xUia0U+4Yg7PJL4Dg/W4Ho28dRBROoJjgJSLSHwc
 3/1pjpNlSaX/qg3ZM8+/EiSGc7uEPklLYu3gRGxcWV/944HdUyLcnjrZwCn2+gg9ncVJjsimS0ro/
 2wU2RPE4ju6NMBn5Go26sAj1owdYQQv9t0d71CmZS9Bh+2+cLjC7HvyTHKFxVGOznUL+j1a45VrVS
 XQ+nhTVjvgvXR84z10bOvLiwxJZ/00pwNi7uCdSYnZFLQ4S/JGMs4lhOiCGJhJ/9FR7JVw/1t1G9a
 UlqVp23AXwzbcoV2fxyE/CsVpHcyOWGDahGLcH7QeitN6cjltf9ymw2spBzpRnfFn80nVxgSYVG1d
 w75ksBAuQ/3e+oTQk4GAa2ShoNVsvR9GYn7rnsDN5pVILDhdPO3J2PGIXa5ipQnvwb3EHvPXyzakY
 tK50fBUPKk3XnkRwRYEbbPEB7YT+ccF/HioCryqDPWUivXF8qf6Jw5T1mhwukUV1i+QyJzJxGPh19
 /N2/GK7/yS5wrt0Lwxzevc5g+jX8RyjzywOZGHTVu9KIQiG8Pqx33UxZvykjaqTMjo7kaAdGEkrHZ
 dVHqoPZwhCsgQARAQABtChOaWtsYXMgU2NobmVsbGUgPHNjaG5lbGxlQGxpbnV4LmlibS5jb20+iQ
 JXBBMBCABBAhsBBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAAhkBFiEEnbAAstJ1IDCl9y3cr+Q/Fej
 CYJAFAmesutgFCQenEYkACgkQr+Q/FejCYJDIzA//W5h3t+anRaztihE8ID1c6ifS7lNUtXr0wEKx
 Qm6EpDQKqFNP+n3R4A5w4gFqKv2JpYQ6UJAAlaXIRTeT/9XdqxQlHlA20QWI7yrJmoYaF74ZI9s/C
 8aAxEzQZ64NjHrmrZ/N9q8JCTlyhk5ZEV1Py12I2UH7moLFgBFZsPlPWAjK2NO/ns5UJREAJ04pR9
 XQFSBm55gsqkPp028cdoFUD+IajGtW7jMIsx/AZfYMZAd30LfmSIpaPAi9EzgxWz5habO1ZM2++9e
 W6tSJ7KHO0ZkWkwLKicrqpPvA928eNPxYtjkLB2XipdVltw5ydH9SLq0Oftsc4+wDR8TqhmaUi8qD
 Fa2I/0NGwIF8hjwSZXtgJQqOTdQA5/6voIPheQIi0NBfUr0MwboUIVZp7Nm3w0QF9SSyTISrYJH6X
 qLp17NwnGQ9KJSlDYCMCBJ+JGVmlcMqzosnLli6JszAcRmZ1+sd/f/k47Fxy1i6o14z9Aexhq/UgI
 5InZ4NUYhf5pWflV41KNupkS281NhBEpChoukw25iZk0AsrukpJ74x69MJQQO+/7PpMXFkt0Pexds
 XQrtsXYxLDQk8mgjlgsvWl0xlk7k7rddN1+O/alcv0yBOdvlruirtnxDhbjBqYNl8PCbfVwJZnyQ4
 SAX2S9XiGeNtWfZ5s2qGReyAcd2nBna0KU5pa2xhcyBTY2huZWxsZSA8bmlrbGFzLnNjaG5lbGxlQ
 GlibS5jb20+iQJUBBMBCAA+AhsBBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAFiEEnbAAstJ1IDCl9y
 3cr+Q/FejCYJAFAmesuuEFCQenEYkACgkQr+Q/FejCYJCosA/9GCtbN8lLQkW71n/CHR58BAA5ct1
 KRYiZNPnNNAiAzjvSb0ezuRVt9H0bk/tnj6pPj0zdyU2bUj9Ok3lgocWhsF2WieWbG4dox5/L1K28
 qRf3p+vdPfu7fKkA1yLE5GXffYG3OJnqR7OZmxTnoutj81u/tXO95JBuCSJn5oc5xMQvUUFzLQSbh
 prIWxcnzQa8AHJ+7nAbSiIft/+64EyEhFqncksmzI5jiJ5edABiriV7bcNkK2d8KviUPWKQzVlQ3p
 LjRJcJJHUAFzsZlrsgsXyZLztAM7HpIA44yo+AVVmcOlmgPMUy+A9n+0GTAf9W3y36JYjTS+ZcfHU
 KP+y1TRGRzPrFgDKWXtsl1N7sR4tRXrEuNhbsCJJMvcFgHsfni/f4pilabXO1c5Pf8fiXndCz04V8
 ngKuz0aG4EdLQGwZ2MFnZdyf3QbG3vjvx7XDlrdzH0wUgExhd2fHQ2EegnNS4gNHjq82uLPU0hfcr
 obuI1D74nV0BPDtr7PKd2ryb3JgjUHKRKwok6IvlF2ZHMMXDxYoEvWlDpM1Y7g81NcKoY0BQ3ClXi
 a7vCaqAAuyD0zeFVGcWkfvxYKGqpj8qaI/mA8G5iRMTWUUUROy7rKJp/y2ioINrCul4NUJUujfx4k
 7wFU11/YNAzRhQG4MwoO5e+VY66XnAd+XPyBIlvy0K05pa2xhcyBTY2huZWxsZSA8bmlrbGFzLnNj
 aG5lbGxlQGdtYWlsLmNvbT6JAlQEEwEIAD4CGwEFCwkIBwIGFQoJCAsCBBYCAwECHgECF4AWIQSds
 ACy0nUgMKX3Ldyv5D8V6MJgkAUCZ6y64QUJB6cRiQAKCRCv5D8V6MJgkEr/D/9iaYSYYwlmTJELv+
 +EjsIxXtneKYpjXEgNnPwpKEXNIpuU/9dcVDcJ10MfvWBPi3sFbIzO9ETIRyZSgrjQxCGSIhlbom4
 D8jVzTA698tl9id0FJKAi6T0AnBF7CxyqofPUzAEMSj9ynEJI/Qu8pHWkVp97FdJcbsho6HNMthBl
 +Qgj9l7/Gm1UW3ZPvGYgU75uB/mkaYtEv0vYrSZ+7fC2Sr/O5SM2SrNk+uInnkMBahVzCHcoAI+6O
 Enbag+hHIeFbqVuUJquziiB/J4Z2yT/3Ps/xrWAvDvDgdAEr7Kn697LLMRWBhGbdsxdHZ4ReAhc8M
 8DOcSWX7UwjzUYq7pFFil1KPhIkHctpHj2Wvdnt+u1F9fN4e3C6lckUGfTVd7faZ2uDoCCkJAgpWR
 10V1Q1Cgl09VVaoi6LcGFPnLZfmPrGYiDhM4gyDDQJvTmkB+eMEH8u8V1X30nCFP2dVvOpevmV5Uk
 onTsTwIuiAkoTNW4+lRCFfJskuTOQqz1F8xVae8KaLrUt2524anQ9x0fauJkl3XdsVcNt2wYTAQ/V
 nKUNgSuQozzfXLf+cOEbV+FBso/1qtXNdmAuHe76ptwjEfBhfg8L+9gMUthoCR94V0y2+GEzR5nlD
 5kfu8ivV/gZvij+Xq3KijIxnOF6pd0QzliKadaFNgGw4FoUeZo0rQhTmlrbGFzIFNjaG5lbGxlIDx
 uaWtzQGtlcm5lbC5vcmc+iQJUBBMBCAA+AhsBBQsJCAcCBhUKCQgLAgQWAgMBAh4BAheAFiEEnbAA
 stJ1IDCl9y3cr+Q/FejCYJAFAmesuuEFCQenEYkACgkQr+Q/FejCYJC6yxAAiQQ5NAbWYKpkxxjP/
 AajXheMUW8EtK7EMJEKxyemj40laEs0wz9owu8ZDfQl4SPqjjtcRzUW6vE6JvfEiyCLd8gUFXIDMS
 l2hzuNot3sEMlER9kyVIvemtV9r8Sw1NHvvCjxOMReBmrtg9ooeboFL6rUqbXHW+yb4GK+1z7dy+Q
 9DMlkOmwHFDzqvsP7eGJN0xD8MGJmf0L5LkR9LBc+jR78L+2ZpKA6P4jL53rL8zO2mtNQkoUO+4J6
 0YTknHtZrqX3SitKEmXE2Is0Efz8JaDRW41M43cE9b+VJnNXYCKFzjiqt/rnqrhLIYuoWCNzSJ49W
 vt4hxfqh/v2OUcQCIzuzcvHvASmt049ZyGmLvEz/+7vF/Y2080nOuzE2lcxXF1Qr0gAuI+wGoN4gG
 lSQz9pBrxISX9jQyt3ztXHmH7EHr1B5oPus3l/zkc2Ajf5bQ0SE7XMlo7Pl0Xa1mi6BX6I98CuvPK
 SA1sQPmo+1dQYCWmdQ+OIovHP9Nx8NP1RB2eELP5MoEW9eBXoiVQTsS6g6OD3rH7xIRxRmuu42Z5e
 0EtzF51BjzRPWrKSq/mXIbl5nVW/wD+nJ7U7elW9BoJQVky03G0DhEF6fMJs08DGG3XoKw/CpGtMe
 2V1z/FRotP5Fkf5VD3IQGtkxSnO/awtxjlhytigylgrZ4wDpSE=
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
X-Proofpoint-GUID: FuNX2K1yo4Q6sqxwBod_nJCKBSdmLxjd
X-Proofpoint-ORIG-GUID: pG-05CqXy5Br8yYQ7oJETa4mOCyTBAmK
X-Authority-Analysis: v=2.4 cv=LKNmQIW9 c=1 sm=1 tr=0 ts=68124373 cx=c_pps a=3Bg1Hr4SwmMryq2xdFQyZA==:117 a=3Bg1Hr4SwmMryq2xdFQyZA==:17 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=VwQbUJbxAAAA:8 a=VnNF1IyMAAAA:8 a=1XWaLZrsAAAA:8 a=uRncMJLuRcV0XrlLTekA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDMwMDExMSBTYWx0ZWRfX9I1fSjKEBgqP r6p3nLRFdAIrl8FQzs2Ut7tGeRiHTxpl/9ifHHvCWvsrk24SUFdtuIsae/i76D4fMQNqQeMKvAi 2Cjq1smkGnBJxBrtwc7G6XE+O7chQJBUYKgBtUxG4XkcGbGbw6bLUq3UiPgxpvhlKSgcBd21mpg
 KhApfG3qUwhUQjE7IkBkdliMQO/wRdcuVPsFXwgwVtOdLq9Lz5XQc++OedsLwWLXpU5y26UX3jC KMYn4aXq2phdalUMTV306Ff6BYxQorvrixWasVdUAdoJ2TysmK92npCLIkf2wPrskgnyOcWZcIm x4l18Jf4OpeRMm6HVRPNmaNLIvx7YIC6IRGjWbYs0N/dMFlXKm3Apu8WW3zJ8UV20py6/Dsmo8j
 6BQZWhUyXaNmWYuAvwKbRSTEGeWmWHzlba8M8mEcuf5SdhjejYSuV5P6zH1GpR+U6mOK/UDU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-30_04,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 priorityscore=1501 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0
 impostorscore=0 adultscore=0 bulkscore=0 mlxlogscore=999 clxscore=1015
 phishscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504300111

On Tue, 2025-04-29 at 18:42 +0200, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: Niklas Schnelle <schnelle@linux.ibm.com>
>=20
> [ Upstream commit aa9f168d55dc47c0de564f7dfe0e90467c9fee71 ]
>=20
> So far s390 does not allow mmap() of PCI resources to user-space via the
> usual mechanisms, though it does use it for RDMA. For the PCI sysfs
> resource files and /proc/bus/pci it defines neither HAVE_PCI_MMAP nor
> ARCH_GENERIC_PCI_MMAP_RESOURCE. For vfio-pci s390 previously relied on
> disabled VFIO_PCI_MMAP and now relies on setting pdev->non_mappable_bars
> for all devices.
>=20
> This is partly because access to mapped PCI resources from user-space
> requires special PCI load/store memory-I/O (MIO) instructions, or the
> special MMIO syscalls when these are not available. Still, such access is
> possible and useful not just for RDMA, in fact not being able to mmap() P=
CI
> resources has previously caused extra work when testing devices.
>=20
> One thing that doesn't work with PCI resources mapped to user-space thoug=
h
> is the s390 specific virtual ISM device. Not only because the BAR size of
> 256 TiB prevents mapping the whole BAR but also because access requires u=
se
> of the legacy PCI instructions which are not accessible to user-space on
> systems with the newer MIO PCI instructions.
>=20
> Now with the pdev->non_mappable_bars flag ISM can be excluded from mappin=
g
> its resources while making this functionality available for all other PCI
> devices. To this end introduce a minimal implementation of PCI_QUIRKS and
> use that to set pdev->non_mappable_bars for ISM devices only. Then also s=
et
> ARCH_GENERIC_PCI_MMAP_RESOURCE to take advantage of the generic
> implementation of pci_mmap_resource_range() enabling only the newer sysfs
> mmap() interface. This follows the recommendation in
> Documentation/PCI/sysfs-pci.rst.
>=20
> Link: https://lore.kernel.org/r/20250226-vfio_pci_mmap-v7-3-c5c0f1d26efd@=
linux.ibm.com
> Signed-off-by: Niklas Schnelle <schnelle@linux.ibm.com>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  arch/s390/Kconfig           |  4 +---
>  arch/s390/include/asm/pci.h |  3 +++
>  arch/s390/pci/Makefile      |  2 +-
>  arch/s390/pci/pci_fixup.c   | 23 +++++++++++++++++++++++
>  drivers/s390/net/ism_drv.c  |  1 -
>  include/linux/pci_ids.h     |  1 +
>  6 files changed, 29 insertions(+), 5 deletions(-)
>  create mode 100644 arch/s390/pci/pci_fixup.c
>=20
> diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
> index de575af02ffea..50a4a878bae6d 100644
> --- a/arch/s390/Kconfig
> +++ b/arch/s390/Kconfig
> @@ -38,9 +38,6 @@ config AUDIT_ARCH
>  config NO_IOPORT_MAP
>  	def_bool y
> =20
> -config PCI_QUIRKS
> -	def_bool n
> -
>  config ARCH_SUPPORTS_UPROBES
>  	def_bool y
> =20
> @@ -213,6 +210,7 @@ config S390
>  	select PCI_DOMAINS		if PCI
>  	select PCI_MSI			if PCI
>  	select PCI_MSI_ARCH_FALLBACKS	if PCI_MSI
> +	select PCI_QUIRKS		if PCI
>  	select SPARSE_IRQ
>  	select SWIOTLB
>  	select SYSCTL_EXCEPTION_TRACE
> diff --git a/arch/s390/include/asm/pci.h b/arch/s390/include/asm/pci.h
> index 108e732d7b140..a4e9a6ecbd437 100644
> --- a/arch/s390/include/asm/pci.h
> +++ b/arch/s390/include/asm/pci.h
> @@ -11,6 +11,9 @@
>  #include <asm/pci_insn.h>
>  #include <asm/sclp.h>
> =20
> +#define ARCH_GENERIC_PCI_MMAP_RESOURCE	1
> +#define arch_can_pci_mmap_wc()		1
> +
>  #define PCIBIOS_MIN_IO		0x1000
>  #define PCIBIOS_MIN_MEM		0x10000000
> =20
> diff --git a/arch/s390/pci/Makefile b/arch/s390/pci/Makefile
> index eeef68901a15c..2f8dd3f688391 100644
> --- a/arch/s390/pci/Makefile
> +++ b/arch/s390/pci/Makefile
> @@ -5,5 +5,5 @@
> =20
>  obj-$(CONFIG_PCI)	+=3D pci.o pci_irq.o pci_dma.o pci_clp.o pci_sysfs.o \
>  			   pci_event.o pci_debug.o pci_insn.o pci_mmio.o \
> -			   pci_bus.o pci_kvm_hook.o pci_report.o
> +			   pci_bus.o pci_kvm_hook.o pci_report.o pci_fixup.o
>  obj-$(CONFIG_PCI_IOV)	+=3D pci_iov.o
> diff --git a/arch/s390/pci/pci_fixup.c b/arch/s390/pci/pci_fixup.c
> new file mode 100644
> index 0000000000000..35688b6450983
> --- /dev/null
> +++ b/arch/s390/pci/pci_fixup.c
> @@ -0,0 +1,23 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Exceptions for specific devices,
> + *
> + * Copyright IBM Corp. 2025
> + *
> + * Author(s):
> + *   Niklas Schnelle <schnelle@linux.ibm.com>
> + */
> +#include <linux/pci.h>
> +
> +static void zpci_ism_bar_no_mmap(struct pci_dev *pdev)
> +{
> +	/*
> +	 * ISM's BAR is special. Drivers written for ISM know
> +	 * how to handle this but others need to be aware of their
> +	 * special nature e.g. to prevent attempts to mmap() it.
> +	 */
> +	pdev->non_mappable_bars =3D 1;
> +}

As already noted by others and for other versions the above will cause
a build error without also pulling in commit 888bd8322dfc ("s390/pci:
Introduce pdev->non_mappable_bars and replace VFIO_PCI_MMAP")

> +DECLARE_PCI_FIXUP_EARLY(PCI_VENDOR_ID_IBM,
> +			PCI_DEVICE_ID_IBM_ISM,
> +			zpci_ism_bar_no_mmap);
>=20
--- snip ---

