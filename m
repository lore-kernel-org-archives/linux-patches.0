Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C319B78F44;
	Wed, 30 Apr 2025 07:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745999172; cv=none; b=SxM2O/YGt6QIfLt8cl4kPCrfy7q5N/NY2AF2dv/wY1Jn202uzMSdJyUxbdMYTUn0m4TBMWBnNjhLYgoTNCCkwY+nU9UN+XQhRDThmqoygJ7iKuqjuUmCZnhzt/uaajkvN4vT3wvLKA1KiNdCp187XEWy5lqxWmTlVjsGmkuLoT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745999172; c=relaxed/simple;
	bh=7cwf72QGDOirBTn6Lz+9C9b2vd1NylOT8m2eoNWX9HA=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=GMjb1EK9WYhTw+UppCGsEm4U9UUUfRkouORfdE7assqeD+60ajcc2Fmtmc6MmcHWzbFXerP+bt1lzxn5Nf/HICCG3XBTFBLY9OKJMccLWDP10Xq6VFgR3tL7wXefRU2BYTp2GkYfqj7wEum1vSuMEm+mLQYXF1F3S/6et7JPUk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=aCuI5+r0; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="aCuI5+r0"
Received: from pps.filterd (m0360072.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53TLgS4K024548;
	Wed, 30 Apr 2025 07:46:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=bMS/Se
	yC9taTHReXks7I596dylFq513KjXq+cMAxnpQ=; b=aCuI5+r0LBgw6R43qVPuWV
	l5RuYQ6aSwGTT27rgLbqDKxdW8HCseNSQl2xqdBEBb44PmjTqYFUnigtNmKWfWiI
	Bc+VOZuDaoVBvc5DgKRZXASLyy5ijJLyFIXUdWbDpvnJ9OjmIrGzQaFbN8P6T2F0
	v4mIqWAj1vpEAGNvXXrvVjAgX615s74zGgYg6zNdV+e6Df9bImtHIXpoe11fwZod
	Q0cuOL5qgN2ZCxI/zwxXnZ6gJW4CV5hwaMajP+x+g3E8S70lIhLmsJJlxd3tiduU
	w4pndCueMcbD50Vf6uebAa05ZEvujm3F9TML16l54ITfAnpXBk9aDL/Nwf1iVOlQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46b6ww9r5y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Apr 2025 07:46:05 +0000 (GMT)
Received: from m0360072.ppops.net (m0360072.ppops.net [127.0.0.1])
	by pps.reinject (8.18.0.8/8.18.0.8) with ESMTP id 53U7aRQB028764;
	Wed, 30 Apr 2025 07:46:04 GMT
Received: from ppma22.wdc07v.mail.ibm.com (5c.69.3da9.ip4.static.sl-reverse.com [169.61.105.92])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 46b6ww9r5u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Apr 2025 07:46:04 +0000 (GMT)
Received: from pps.filterd (ppma22.wdc07v.mail.ibm.com [127.0.0.1])
	by ppma22.wdc07v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 53U7bJJr016122;
	Wed, 30 Apr 2025 07:46:04 GMT
Received: from smtprelay03.dal12v.mail.ibm.com ([172.16.1.5])
	by ppma22.wdc07v.mail.ibm.com (PPS) with ESMTPS id 469a70f1k1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 30 Apr 2025 07:46:04 +0000
Received: from smtpav02.wdc07v.mail.ibm.com (smtpav02.wdc07v.mail.ibm.com [10.39.53.229])
	by smtprelay03.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 53U7k3ia28377770
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 30 Apr 2025 07:46:03 GMT
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 1D2855809B;
	Wed, 30 Apr 2025 07:46:03 +0000 (GMT)
Received: from smtpav02.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id 6FE1D5809A;
	Wed, 30 Apr 2025 07:46:01 +0000 (GMT)
Received: from [9.111.36.251] (unknown [9.111.36.251])
	by smtpav02.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed, 30 Apr 2025 07:46:01 +0000 (GMT)
Message-ID: <80d4af6a714848783611447711d6d9fa304bbe05.camel@linux.ibm.com>
Subject: Re: [PATCH 6.14 019/311] s390/pci: Support mmap() of PCI resources
 except for ISM devices
From: Niklas Schnelle <schnelle@linux.ibm.com>
To: Jiri Slaby <jirislaby@kernel.org>,
        Greg Kroah-Hartman
	 <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, Bjorn Helgaas <bhelgaas@google.com>,
        Sasha
 Levin	 <sashal@kernel.org>
Date: Wed, 30 Apr 2025 09:46:00 +0200
In-Reply-To: <c8aba766-7245-486b-a826-a4af74072bed@kernel.org>
References: <20250429161121.011111832@linuxfoundation.org>
	 <20250429161121.820299536@linuxfoundation.org>
	 <c8aba766-7245-486b-a826-a4af74072bed@kernel.org>
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
X-Proofpoint-ORIG-GUID: eGbAXPXs0ZCox4isOBG_mfPBZFpsGitJ
X-Proofpoint-GUID: LSc67zl_oC9kFpCuMRdHuB41HyLu3LVu
X-Authority-Analysis: v=2.4 cv=GOIIEvNK c=1 sm=1 tr=0 ts=6811d53d cx=c_pps a=5BHTudwdYE3Te8bg5FgnPg==:117 a=5BHTudwdYE3Te8bg5FgnPg==:17 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=VnNF1IyMAAAA:8 a=eMtlsBTQQaIDEZVBHX8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDMwMDA1MiBTYWx0ZWRfX1tiQORqBQ0PZ Imw++BeCP3dxSwjLiNXGcZG75Nr3guGhC4LqkwaEDXnGH5hNKrzI5pDoGNLk9i51l342fleJf2T EIh5uJAl69BS6zld+g+USxclIykMSdLLxI2hjFQvJ2to+mpHkmC+NEMedqd/fVmU2RUv4+6vqJ0
 tNDsbLmfc0AyrJeVVLrbqXb5CrU+77v3prkF2DZhcEg8jcSFNemmuSYUKfvI/QTopc/OkmEln5l iKsW83pJYD5XHp4VtLe3zy+j/hAloOsoRG6c6yRh6xovdqP6BFjmBZbjl5jtQ4f287RS+gQxh3M LfZwLtyvWrvDXSnPqmY3zur2TbVnVpWeaxFV79QOpbB9L7Rad2xrtsZmFmVrQ8fez4AXgo9w39f
 zLX6da5yIn/wkRW40JBjZCrfXbrUroQERMoGHaqvDZzPMK9hwISDWW5IT205MZHOVQF9Gsmp
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-30_02,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 lowpriorityscore=0
 clxscore=1011 impostorscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 adultscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=905
 spamscore=0 classifier=spam authscore=0 authtc=n/a authcc= route=outbound
 adjust=0 reason=mlx scancount=1 engine=8.19.0-2504070000
 definitions=main-2504300052

On Wed, 2025-04-30 at 09:41 +0200, Jiri Slaby wrote:
> On 29. 04. 25, 18:37, Greg Kroah-Hartman wrote:
> > 6.14-stable review patch.  If anyone has any objections, please let me =
know.
> >=20
> > ------------------
> >=20
> > From: Niklas Schnelle <schnelle@linux.ibm.com>
> >=20
> > [ Upstream commit aa9f168d55dc47c0de564f7dfe0e90467c9fee71 ]
> ...
> > +static void zpci_ism_bar_no_mmap(struct pci_dev *pdev)
> > +{
> > +	/*
> > +	 * ISM's BAR is special. Drivers written for ISM know
> > +	 * how to handle this but others need to be aware of their
> > +	 * special nature e.g. to prevent attempts to mmap() it.
> > +	 */
> > +	pdev->non_mappable_bars =3D 1;
>=20
> I see:
> arch/s390/pci/pci_fixup.c: In function 'zpci_ism_bar_no_mmap':
> arch/s390/pci/pci_fixup.c:19:13: error: 'struct pci_dev' has no member=
=20
> named 'non_mappable_bars'
>     19 |         pdev->non_mappable_bars =3D 1;
>        |             ^~
>=20
>=20
>=20
>=20
>=20
> The above needs at least:
> commit 888bd8322dfc325dc5ad99184baba4e1fd91082d
> Author: Niklas Schnelle <schnelle@linux.ibm.com>
> Date:   Wed Feb 26 13:07:46 2025 +0100
>=20
>      s390/pci: Introduce pdev->non_mappable_bars and replace VFIO_PCI_MMA=
P
>=20
> thanks,

Yes, as this didn't originally have a Cc stable / Fixes tag this
prerequisite doesn't seem to have been pulled in correctly. Besides the
cited commit 888bd8322dfc ("s390/pci: Introduce pdev->non_mappable_bars
and replace VFIO_PCI_MMAP") this also needs commit 41a0926e82f4
("s390/pci: Fix s390_mmio_read/write syscall page fault handling") for
correct operation.

Thanks,
Niklas
