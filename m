Received: from mx0a-001b2d01.pphosted.com (mx0a-001b2d01.pphosted.com [148.163.156.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B707207A0B
	for <patches@lists.linux.dev>; Wed,  5 Nov 2025 03:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.163.156.1
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762314672; cv=none; b=m8/L1xiG3xRG7dRDQwv2WEeXTPcO3ofTydOx/+egV5ofcqxZvfzJVe1xJoSOONWb6At5nTEzDPy6t5u/LjGw2mc1k7+DQLYNONKKRHAQwg7qCJqrLRMBqZwk3Vvr6uw9+J/6n5tZexFIIerbowXdZFZuQGsZlIbuONz24Ey3RfM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762314672; c=relaxed/simple;
	bh=J6fLkmQ842y9OTkNtL8ToSCNNFRchUDmpb7uRAYqYU0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ibnj0r33lCu9diHGs5t174qQqmmuLV6M67/9oLNFSYp2DNKTxrd2Qjdvbl8HSj9hg6aGxYk/NHADwGBbmIpUD6kkmXqtF2nF6i5ujmWYjD8AcrK5W0PRqu0S6j6fCIjoGMY82Uxj6RFcvQBQJRg8q56vuKTBQwucCoWM5bmYIXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com; spf=pass smtp.mailfrom=linux.ibm.com; dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b=T4dFGKpe; arc=none smtp.client-ip=148.163.156.1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.ibm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ibm.com header.i=@ibm.com header.b="T4dFGKpe"
Received: from pps.filterd (m0356517.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A4KWFaU006421;
	Wed, 5 Nov 2025 03:50:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ibm.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pp1; bh=8qrzGh
	wEpQyn2ArhPh8Ntq7G0BXphFX7U+G79Ez9yUc=; b=T4dFGKpewmXnq/MRppWBvG
	Dz1TRARw9z+ifR+Y7pHUc35E41JyTnDqA6EOkeSsnDNdJG1nd5xfAR7NQrcEfMBk
	/A2cLWRG5p4AG73sLQgnk/wSWPED0tfOST3lwF9JqkHe9umISo2kritYqxTSN81i
	sWKFMzPKtc/oJ2unKVh1EfLGbGRY6a4HxLr+X9kYSdzOGrung+ln6XyUIkoICRuC
	r7pYSMUXuM02Ad1gLdOGI1zYMPh3F5sdS8YUbuTLKF1I71genUjMcaufdMclAJaj
	pthUTgff3dr01bSpUPqNK1SvAMfiDSFPyTiubXsnAheb/vxeDoTH/YCv+p06aghQ
	==
Received: from pps.reinject (localhost [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59xby7pu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Nov 2025 03:50:48 +0000 (GMT)
Received: from m0356517.ppops.net (m0356517.ppops.net [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.0.8) with ESMTP id 5A53knZN007212;
	Wed, 5 Nov 2025 03:50:47 GMT
Received: from ppma13.dal12v.mail.ibm.com (dd.9e.1632.ip4.static.sl-reverse.com [50.22.158.221])
	by mx0a-001b2d01.pphosted.com (PPS) with ESMTPS id 4a59xby7pr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Nov 2025 03:50:47 +0000 (GMT)
Received: from pps.filterd (ppma13.dal12v.mail.ibm.com [127.0.0.1])
	by ppma13.dal12v.mail.ibm.com (8.18.1.2/8.18.1.2) with ESMTP id 5A4N5UQn021558;
	Wed, 5 Nov 2025 03:50:46 GMT
Received: from smtprelay02.dal12v.mail.ibm.com ([172.16.1.4])
	by ppma13.dal12v.mail.ibm.com (PPS) with ESMTPS id 4a5xrjp37g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Wed, 05 Nov 2025 03:50:46 +0000
Received: from smtpav06.wdc07v.mail.ibm.com (smtpav06.wdc07v.mail.ibm.com [10.39.53.233])
	by smtprelay02.dal12v.mail.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id 5A53ojEF27853532
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 5 Nov 2025 03:50:46 GMT
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id D91AD5804E;
	Wed,  5 Nov 2025 03:50:45 +0000 (GMT)
Received: from smtpav06.wdc07v.mail.ibm.com (unknown [127.0.0.1])
	by IMSVA (Postfix) with ESMTP id A67955803F;
	Wed,  5 Nov 2025 03:50:41 +0000 (GMT)
Received: from [9.43.111.253] (unknown [9.43.111.253])
	by smtpav06.wdc07v.mail.ibm.com (Postfix) with ESMTP;
	Wed,  5 Nov 2025 03:50:41 +0000 (GMT)
Message-ID: <6f52c355-c29d-4788-8dab-1e1ad5e4de04@linux.ibm.com>
Date: Wed, 5 Nov 2025 09:20:39 +0530
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] Fixes for pmac32_defconfig after fb.h removal from
 backlight.h
To: Christophe Leroy <christophe.leroy@csgroup.eu>,
        Nathan Chancellor <nathan@kernel.org>, Lee Jones <lee@kernel.org>,
        Thomas Zimmermann <tzimmermann@suse.de>,
        Daniel Thompson <danielt@kernel.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>,
        Nicholas Piggin
 <npiggin@gmail.com>,
        Simona Vetter <simona.vetter@ffwll.ch>, linuxppc-dev@lists.ozlabs.org,
        patches@lists.linux.dev, Thierry Reding <treding@nvidia.com>
References: <20250925-ppc-fixes-for-backlight-fb-h-removal-v1-0-d256858d86a6@kernel.org>
 <70a965d7-9839-4973-a306-4da4f1089bfc@csgroup.eu>
Content-Language: en-US
From: Madhavan Srinivasan <maddy@linux.ibm.com>
In-Reply-To: <70a965d7-9839-4973-a306-4da4f1089bfc@csgroup.eu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-GCONF: 00
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTAxMDAyMSBTYWx0ZWRfX6yWMntHcJlla
 k5JtFRpRRGT2izzgKOHTjy8B37/em4nPrXrrHt5x8xbjIHmQFCWdIhEs2V2Q0ZkUyWinGjFurjG
 F28mf7ig0vmK9r2VpxO1NEeWQ2224oonwjfgBgge41NOpIj8m8GRk6IIy9tnWbrZCmNgc2xV1q2
 iwUvT2HeejQoEeaUfWzHUlSF7+b6ilNSE1dJF6dgQiA6eXZ3ugXmFISO9rEt5MECo3UInqNpyJm
 8Ei8mu1bFIc1hbGiKYTv5454uteLKlhvQ6Wt4zb4bXHWATtxZUyjIDCXMaj0gDFeE7y0UwTB9n/
 rYD7KLu3jxBQeqzF1Nj5p+suUgnvDZkSHMiQqXRUQv3RP08c+KsmOaMLI7I/BwWHxcN8ocCcKKx
 Yb1HrZiEnqv3mvDeg8K7hod2nn44pg==
X-Proofpoint-GUID: KHFDrnlGsMN7N-ytlNuA2w6CHWHwoGZI
X-Authority-Analysis: v=2.4 cv=OdCVzxTY c=1 sm=1 tr=0 ts=690ac998 cx=c_pps
 a=AfN7/Ok6k8XGzOShvHwTGQ==:117 a=AfN7/Ok6k8XGzOShvHwTGQ==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=voM4FWlXAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=lzAno4yBQp4m_lSgxmwA:9
 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10 a=IC2XNlieTeVoXbcui8wp:22
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: 7oUFY4i6YNclZkfcuIoVKmNnsJlFZcot
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-05_02,2025-11-03_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 adultscore=0 spamscore=0 suspectscore=0 impostorscore=0
 lowpriorityscore=0 priorityscore=1501 clxscore=1011 phishscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2510240000 definitions=main-2511010021



On 11/4/25 4:59 PM, Christophe Leroy wrote:
> Hi All,
> 
> Le 26/09/2025 à 01:46, Nathan Chancellor a écrit :
>> Commit 9f218f9bb9d2 ("backlight: Do not include <linux/fb.h> in header
>> file") exposed some necessary includes that were missing from a few
>> powerpc drivers, breaking the build. This series resolves them.
>>
>> This should go via the backlight tree, which includes 9f218f9bb9d2, but
>> I have included the PowerPC folks for visibility.
> 
> What is the status of this fixing series ? I see a couple of similar redundant patchs (see below) roaming around, which make me wonder if this series has been properly processed in the backlight tree.
> 

Yes, i will pull this as part of the powerpc tree.

Maddy
(sorry for the delay)


> https://patchwork.ozlabs.org/project/linuxppc-dev/cover/20251029150940.2523328-1-thierry.reding@gmail.com/
> https://patchwork.ozlabs.org/project/linuxppc-dev/cover/20251027140646.227025-1-tzimmermann@suse.de/
> 
> Christophe
> 
>>
>> ---
>> Nathan Chancellor (2):
>>        powerpc/powermac: Include linux/of.h in backlight.c
>>        macintosh/via-pmu-backlight: Include linux/of.h and uapi/linux/fb.h
>>
>>   arch/powerpc/platforms/powermac/backlight.c | 1 +
>>   drivers/macintosh/via-pmu-backlight.c       | 2 ++
>>   2 files changed, 3 insertions(+)
>> ---
>> base-commit: 9f218f9bb9d274b9d5d48a4c95e1b199141fc1f2
>> change-id: 20250925-ppc-fixes-for-backlight-fb-h-removal-2b6a87cced02
>>
>> Best regards,
>> -- 
>> Nathan Chancellor <nathan@kernel.org>
>>
> 

