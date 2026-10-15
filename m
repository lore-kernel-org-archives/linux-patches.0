Received: from mx0b-001b2d01.pphosted.com (mx0b-001b2d01.pphosted.com [148.163.158.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 801BD12F585
	for <patches@lists.linux.dev>; Thu, 15 Oct 2026 13:39:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.158.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792071547; cv=none; b=EgUsmkb9VJah6EMKlofXdzX3/n5dWdjOaOgQ9K08jIHqEIFtBrnNzD9S6+VWigFpay4trEQ+XOAw2rYTEXn9BS/S2EvDY/Ov0FpnCSGj7N4NwHkXSm/YrId/HJpvdWQCCrbn2SmkUdtaocigNLiigwaZtYXPCM0O4OvAp5SkpMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792071547; c=relaxed/simple;
	bh=RGLH9xzgwOQdod4btgNi8VDDcBxWaz0A/Rx5utyerMg=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=WGb0zFKaH6cM1Z2o6QlMlOkUEAg19ePeZvKDkriFL5qgUBklK/bM4IyVS35DIQKrHagajP0sTd/WJbTjyWh8cauOUtx7AbSnY2vxl7dZfX5hS3Pc1Ly08bwuYzF7knhvngV/pHHMu/GXLyc28mcsjr0Rr34qy4yASGCVEhMMODw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=nIuap2K+; arc=none smtp.client-ip=148.163.158.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="nIuap2K+"
Received: from pps.filterd (m0356516.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 69F9kaDq438271;
	Thu, 15 Oct 2026 13:38:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=ywN+IF
	IXkCejfRc/TW28GZDdXVwwfXVMFww0M1Yrccs=; b=nIuap2K+nHwJynRueElp0D
	7UngBzKqSXsibGHxMcjkk6gUOrYNWFyTLCctQlVe0Aa5H1GpQg/jjQsaG2u+6HHt
	jbzqSotVbjXTlJ4Z0XBl8V1G4Rzirb6NGJbRtvkGp7gFOzcMMSl3Z9LF1429L3f5
	XM1qrFEyxy45IlDlkMjg1+1oS5FBjtdEPskhtNSaxDKl/etWUhCyHu9l7ArxgNQn
	qsrYI0E3Dinm9T0Qf6Tv7ryDAf6NXEHe2uQwFNIa6l+Rt7h5WAfeoD9pKzrMWcAK
	Qw+7I/1vLecITq18FoI657TIqi4+Q5+81/Fc3JSR2tXCJExkMTzBhBhHdbyy94Gg
	==
Received: from ppma12.dal12v.mail.ibm.com (dc.9e.1632.ip4.static.sl-reverse.com [50.22.158.220])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4h7dwj9pce-1
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 15 Oct 2026 13:38:58 +0000 (GMT)
Received: from pps.filterd (ppma12.dal12v.mail.ibm.com [127.0.0.1])
	by ppma12.dal12v.mail.ibm.com (8.18.1.11/8.18.1.11) with ESMTP id 69F9nuDV1929703;
	Thu, 15 Oct 2026 13:38:57 GMT
Received: from smtprelay04.fra02v.mail.ibm.com ([9.218.2.228])
	by ppma12.dal12v.mail.ibm.com (PPS) with ESMTPS id 4h9pb3sxsu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Thu, 15 Oct 2026 13:38:57 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (smtpav03.fra02v.mail.ibm.com [10.20.54.102])
	by smtprelay04.fra02v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 69FDctSA17170940
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Oct 2026 13:38:56 GMT
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D1F482004F;
	Thu, 15 Oct 2026 13:38:55 +0000 (GMT)
Received: from smtpav03.fra02v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id B01942004E;
	Thu, 15 Oct 2026 13:38:55 +0000 (GMT)
Received: from [9.224.92.241] (unknown [9.224.92.241])
	by smtpav03.fra02v.mail.ibm.com (Postfix) with ESMTP;
	Thu, 15 Oct 2026 13:38:55 +0000 (GMT)
Message-ID: <9e9f4036dd0056e73c051fad27b469838df72bba.camel@linux.ibm.com>
Subject: Re: [PATCH 6.12 112/497] PCI: Accept AtomicOps already enabled by
 the hypervisor
From: Gerd Bayer <gbayer@linux.ibm.com>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Nikola Prica
	 <nikola.prica@amd.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc: patches@lists.linux.dev,
        Christian =?ISO-8859-1?Q?K=F6nig?=
	 <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>, Gerd Bayer
	 <gbayer@linux.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Date: Thu, 15 Oct 2026 15:38:55 +0200
In-Reply-To: <55fe666e-77e9-45eb-9a9f-0d5a22abbfd6@oracle.com>
References: <20261013112907.864180619@linuxfoundation.org>
	 <20261013112910.548997665@linuxfoundation.org>
	 <55fe666e-77e9-45eb-9a9f-0d5a22abbfd6@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-2.fc44) 
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-TM-AS-GCONF: 00
X-Proofpoint-Reinject: loops=2 maxloops=12
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYxMDE1MDA1MiBTYWx0ZWRfX2Bnq5bT0LTJh
 ZYFxZSgDYIH8FUHXdR6V5gCpWmOjiTxcslUV1E7QGrApiPtTwC7W1zqRAjPy7zewLUdJ83CU4ja
 pwETJ1YoFJfaaZnFa8tn2aZ77uu3xpH4v2df6db0GzFrgzdus1XqIxnN+CMns6/Y1RYI+rfem0V
 6S6PKi4MGaec8ks64mXcomq06JlcEVvxBJqDa1mJLICdI4KX6yvNueTErZc6RyNSKzgMzsqVU30
 2/YWI/rYlJEFV7kgi1nNXJVWH38WsXO3jz4gTDLMYwe68vO2WbxVd10mcL9UFFkDqyiOYVJAC1y
 S5XcdoSG8+KnbMI2y11STnn+fq3mrFTYg2X7cDRCRAZeyF96qhjOmmO62R1W/7itC7yafLixgYh
 NpjNNwhbsGNb0/elwgOfbZMILXXSuErR4gDbJZiVteMucUgKLYTZaTSA2Ropb00Jayp/R3xjMZv
 zN8Wwnl/Ikf7Fhbp4CQ==
X-Proofpoint-GUID: hXUNTMvka--9JYUgSjGWVN4108_Ore1E
X-Proofpoint-ORIG-GUID: r-BMZHIV3kKFa4qj2pNOihksogGuCmp_
X-Proofpoint-Spam-Info: AW1haW4tMjYxMDE1MDA1MiBTYWx0ZWRfX0e0KtpTsDnex
 78Vre0X12AkK+HIi3PeEQJTAOh8Jq4RciYlzuUZKxjjyOwfqbLeWTkQJCFIdmUkZ35GMgTxRN7x
 EZ9AeCIuv3loqfiHabxQofZv3NWyDBc=
X-Authority-Analysis: v=2.4 cv=btHZl0ai c=1 sm=1 tr=0 ts=6ad0d772 cx=c_pps
 a=bLidbwmWQ0KltjZqbj+ezA==:117 a=bLidbwmWQ0KltjZqbj+ezA==:17
 a=IkcTkHD0fZMA:10 a=660iZSQnnn4A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=RnoormkPH1_aCDwRdu11:22 a=Y2IxJ9c9Rs8Kov3niI8_:22 a=VwQbUJbxAAAA:8
 a=VnNF1IyMAAAA:8 a=zd2uoN0lAAAA:8 a=pBuhbAI_25inmM8MoK0A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-10-14_01,2026-10-14_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 malwarescore=0 phishscore=0 impostorscore=0 adultscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1011 spamscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2610080000
 definitions=main-2610150052

On Thu, 2026-10-15 at 02:35 +0530, Harshit Mogalapalli wrote:
> Hi Greg/Sasha,
>=20
> On 13/10/26 5:04 pm, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me =
know.
> >=20
> > ------------------
> >=20
> > From: Nikola Prica <nikola.prica@amd.com>
> >=20
> > [ Upstream commit 40cce45b921f7930886bcba43069edc579725457 ]
> >=20

  [ snip ]


Hi Harshit,

> An AI-assisted backport review highlighted a missing device-type
> restriction in original 6.12.113-rc1 patch 112, e57cb3788563. I
> confirmed the difference by checking upstream against the 6.12.y tip
> f4ffa8dc360b. It remains in rc2 at 4a8beb0f1e36 (replacement
> 4f0ed08a1994), in drivers/pci/pci.c:pci_enable_atomic_ops_to_root().
>=20
> Downstream accepts RCiEP requesters (whitespace normalized):
>=20
>      switch (pci_pcie_type(dev)) {
>      case PCI_EXP_TYPE_ENDPOINT:
>      case PCI_EXP_TYPE_LEG_END:
>      case PCI_EXP_TYPE_RC_END:
>          break;
>=20
> Upstream 40cce45b921f and current 0fcb05b72344 reject that type:
>=20
>      switch (pci_pcie_type(dev)) {
>      case PCI_EXP_TYPE_ENDPOINT:
>      case PCI_EXP_TYPE_LEG_END:
>          break;
>      default:
>          return -EINVAL;
>      }
>=20
> The new no-Root-Port branch returns success when Requester Enable is
> set. An RCiEP can now reach that return downstream, whereas the parent
> rejected it. Callers can consequently advertise atomic support for a
> requester type upstream excludes. The restriction comes from
> 03ec922f0025 ("PCI: Do not enable AtomicOps by RCiEPs"), which precedes
> the upstream patch and has no equivalent at either endpoint.
>=20
> So we need to backport this prereq before this patch I think.
>=20
> Thanks,
> Harshit

the topic of excluding RCiEPs was discussed for the upstream patch
here:
https://lore.kernel.org/linux-pci/20260326164002.GA1325368@bhelgaas/
At that time the conclusion was (in my simplified words): The logic in
pci_enable_atomic_ops_to_root() cannot determine if AtomicOps are to be
enabled or disabled for RCiEPs. So I made that decision explicit with
commit 03ec922f0025 ("PCI: Do not enable AtomicOps by RCiEPs").

Now Nikola's commit 40cce45b921f ("PCI: Accept AtomicOps already
enabled by the hypervisor") provides an override (allowing a hypervisor
to provide the "quirk" that Bjorn talked about in the email thread).
And I agree, depending on wheter commit 03ec922f0025 ("PCI: Do not
enable AtomicOps by RCiEPs") is present, this override/quirk applies to
RCiEPs or not.

I see two options now:
1. Pick commit 03ec922f0025 ("PCI: Do not enable AtomicOps by RCiEPs")
   for stable, too - so the behavior of the two is consistent.
2. Revert commit 03ec922f0025 ("PCI: Do not enable AtomicOps by
   RCiEPs") upstream - to allow RCiEPs benefit from the override, too.

Or maybe a combination of both?

At least in the discussion about RCiEPs
https://lore.kernel.org/linux-pci/20260330-fix_pciatops-v7-1-f601818417e8@l=
inux.ibm.com/
pci_enable_atomic_ops_to_root() did not appear to have any uses in
drivers for RCiEPs.

Thanks,
Gerd
