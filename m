Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6F12D3729
	for <patches@lists.linux.dev>; Fri, 11 Jul 2025 13:26:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752240374; cv=none; b=CjxQmQPm+NnneJgHnS5IX9pZQ7cedd0d1rmrRFtzwDDMYdMhFHopfsITfwF5SMb2sSZjB2+Ox9I8Xv2/R8/VxtdcXdMDzGSFslmG1jE/F06h+8CHX+fkXvcNYVwAiQb3vAW2fKJoYioUzFndkcaOAR6SGSxZmF1tOf8+ZztZxII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752240374; c=relaxed/simple;
	bh=/F/ks41z9nZTtma9p86o1h0OmQ9w274etVH339V26rc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YHjXQcZKfiYNnomCXGsZ+0zomfR+sOBLSva8IOBr1HtUPaM0J6yr+i8aGWBH3M99NbQXaFpIlcSqU/73JE3sbi6hU0ZgBugaW9vTSN+XaRot+H1TnoM0/coOwIjk9vVQ72KwRHz1vDiOQa6OWu7E5+qHzlQAWBUojEKq0OvYPbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=V1QdnfhA; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="V1QdnfhA"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56BBGFGr001260
	for <patches@lists.linux.dev>; Fri, 11 Jul 2025 13:26:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	hVS97d7MJNsARObM2+ftRjP75nOmFiQEKsv7hh3XWUw=; b=V1QdnfhA44Cnyk8Y
	oiW9MnIiYE5juU9bHra1u9W53iKnCh1n/4bVHvCl4GFB1d6c19FpkesKKXWSi3Rq
	6YuToKYwvn4dR2WceBhbyEO5gu4N+zl8Mudgs8iSIKLub4J3amFDwi9rULNz9ALB
	RupkJ7Ux3KDJ+WDbmfua93FxJTxYiZCmNImjTvlgLflwN9H6ocuB2xtY1VKclnAE
	djIGakjV55DDrrKbg4WpzxrUEQXi7OZSQiqOpeVtPOpxBPavJELY7CESzOINZfsx
	Y9igsqQ/Ba3+KTgRgzbLYFrnrtEkGMj8Ypo6BaFgguVmdCAUrBcuK8eO2uk4P0r+
	29QkwA==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 47pucnc543-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Fri, 11 Jul 2025 13:26:10 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7e0003c5851so9139785a.3
        for <patches@lists.linux.dev>; Fri, 11 Jul 2025 06:26:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752240370; x=1752845170;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hVS97d7MJNsARObM2+ftRjP75nOmFiQEKsv7hh3XWUw=;
        b=IGdgH/QWSUUsDkSlg6NEgaOAFSF+UmosKCw3SB3FDnKqJLrX7UgZGLBPwJ1ovbYXrU
         EJxVCY9d7aIRDj0XhPfXZVLHXmlQ7LiUE2yqUA3pmOwTSOfL83Ava1D8XWC/oooTnBet
         1t+fdaVaYlhdwMKllB9czlbsBIdyKT1hdXxAWzpSXN6XIMNSnQLPpUr4rmTSCfQa/HAr
         193BX4wx7AvHP6hIj2rfNlrBGRoxUEKGj2jBi+DZqx1MmP9qv8VGY4hV1Vry9efCnJON
         O0P/uj7AwSwIFmqplrSxw+vzeNBrBXLIQpfThVIp3Q8Dp49NlTvS9amn6JyMPlrILugs
         eWsw==
X-Forwarded-Encrypted: i=1; AJvYcCVuEx3nNox/yD9Wwx/khQNQAOjgec+Bv+q8qu5YcPQcMjarlGUTGlmvm/42mxS8IZjoMZmrAs3A@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7jBu+wlGMbRG9IfKveZ6m1iB/2ZRHdoriAd7FSruSS83sBUaK
	MMqadt0ZWpy43hWS2aHBmmkVkAFfMFzlaWTWcCtTFH545259Hd8y6gcmZBCY6oqbamkoPPHRpQf
	gzsdKm+qzBPkb0qs+TyY+qIt2ReNWsltmnbcfGncQcp9AS1oI611mhxWq4xvg
X-Gm-Gg: ASbGncuLAGGJ90jAUfnIKil/tzgHn1hgVh49xpukZCrGhw65Ljs4hVxYTYbemD3dIRv
	w/kIGVUlNHZHdl+k1mnMV9hF6JiEhTRe7fcFVvyDv8t1NSLVUrgxS6CeNQfK9QFlvZmPK1rdXnN
	pjFpfEWwUvmm2cFtRwch7k99mu1GHaT6kUHunOKXOliZ4/0XP4nAK1sjSzur6yE2AwYiA/geZEY
	zPZYXEUy7igPdnCJymVQ6oVP+VO8Z+g2B/SQT/7A4BEw5j+Vs3pcRxRnF/QBPJTqUFJ+DHBG49V
	myVaAX9v2OmlFdHemY8fK2jY8OPTH7pcHXHogV7CuLf0zNX85eql/1GPRdqIXJSnykxEtY3/Jg+
	T+YQMPZYC/kSjcbPR/mGw
X-Received: by 2002:a05:620a:458c:b0:7d4:5d37:4169 with SMTP id af79cd13be357-7ddec64be74mr189854885a.15.1752240369633;
        Fri, 11 Jul 2025 06:26:09 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGrnu8dcEhZSYwibX0MN3BjvYt7cX3AvTEFAod/2sdxyQmMhviAkK4/cJknuEH/hjlqf6Oc7w==
X-Received: by 2002:a05:620a:458c:b0:7d4:5d37:4169 with SMTP id af79cd13be357-7ddec64be74mr189852285a.15.1752240369024;
        Fri, 11 Jul 2025 06:26:09 -0700 (PDT)
Received: from [192.168.143.225] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e826462bsm299427066b.104.2025.07.11.06.26.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 11 Jul 2025 06:26:08 -0700 (PDT)
Message-ID: <6cc5bb7a-344c-45fa-a8cc-cea34493c759@oss.qualcomm.com>
Date: Fri, 11 Jul 2025 15:26:05 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommu/qcom: Fix pgsize_bitmap
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org,
        Rob Clark <robin.clark@oss.qualcomm.com>,
        Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Kevin Tian <kevin.tian@intel.com>,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev
References: <0-v1-65a7964d2545+195-qcom_pgsize_jgg@nvidia.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <0-v1-65a7964d2545+195-qcom_pgsize_jgg@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=GdQXnRXL c=1 sm=1 tr=0 ts=687110f2 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=KKAkSRfTAAAA:8 a=Ikd4Dj_1AAAA:8 a=EUspDBNiAAAA:8 a=bnN0queyXqPnPK5F75AA:9
 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: 3pFuScweDWwMLV3TqspXB-p5xGlI5iFA
X-Proofpoint-ORIG-GUID: 3pFuScweDWwMLV3TqspXB-p5xGlI5iFA
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzExMDA5NSBTYWx0ZWRfX20PBXr7ykt0c
 8kXMb0kb66+aTLUWdNH2/1kl1s1i+atdLUxrG1EAHUDtcRECFWOuLXEIFcDGJIt+JOnHqDfdstT
 ToozsVyUfknPvuKToUd+xAjbph6hAPd0QXJu8mwmfJWw5yW/oUtnVElNaAQ/KlSEeo0uI2ufqmb
 xBvGrQUDkF9ExiNqzEkzkqjrPrtcBqZ6ZODAfGQ0LBtAXLvLIhwZyPzWoM/1a0FRMExs3Jc2zqW
 mmBYBt99X+cGoHAgRqerMuW6IPW7pz5Oei0DDiu5b9LuZ/sLCS2d6VOD8NXDI/+VYCcJ4tmWyJ1
 fus3Hia0RCK9YI/BGis/LBGkLdsbOyZKSoBWeP0K5WMA6kdpaOX93ewrY/LwJvNA++1La0qvFXl
 iFpzHw4sd+0YKyhfF06eKGoQB9PFNUX1sk3AvXFwkjjgzXTGKEn73mto55cra0wtZDktQvyf
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-11_03,2025-07-09_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 phishscore=0 adultscore=0 bulkscore=0 clxscore=1015
 spamscore=0 suspectscore=0 mlxlogscore=982 priorityscore=1501 impostorscore=0
 malwarescore=0 mlxscore=0 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2505280000
 definitions=main-2507110095

On 7/11/25 3:16 PM, Jason Gunthorpe wrote:
> qcom uses the ARM_32_LPAE_S1 format which uses the ARM long descriptor
> page table. Eventually arm_32_lpae_alloc_pgtable_s1() will adjust
> the pgsize_bitmap with:
> 
> 	cfg->pgsize_bitmap &= (SZ_4K | SZ_2M | SZ_1G);
> 
> So the current declaration is nonsensical. Fix it to be just SZ_4K which
> is what it has actually been using so far. Most likely the qcom driver
> copy and pasted the pgsize_bitmap from something using the ARM_V7S format.
> 
> Fixes: db64591de4b2 ("iommu/qcom: Remove iommu_ops pgsize_bitmap")
> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
> Closes: https://lore.kernel.org/all/CA+G9fYvif6kDDFar5ZK4Dff3XThSrhaZaJundjQYujaJW978yg@mail.gmail.com/
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---

The downstream driver from >10y ago for this era of hardware
suggests (at least some?) users of this driver can issue a magic
TZ call to switch to (IIUC) ARM_64_LPAE_S1, but there's no
implementation upstream, so:

(adding a couple folks interested in the hardware museum to CC to
bring this to their attention, nothing to act on though)

Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad
