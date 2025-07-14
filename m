Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71EFC246BC5
	for <patches@lists.linux.dev>; Mon, 14 Jul 2025 12:14:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752495293; cv=none; b=BY7NTzrI/J9OGRjpdyDYKD604QSW3LC+YTMXqpRhQGg5efgVB9DCgmMRW2dQQxM7wgw0wriF50mr1+qA52Kabm8rlOWQVYickfh6nzHLL2dALNYO/JhlY2vCjem4XU1tUICBeojNQcF2l2AIZVpM+c69uCmIg+QGQ/E7ZqUzSEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752495293; c=relaxed/simple;
	bh=LNvjq/HhF00mQ3s9sufU+eybecRGCk/V8PHR+axvGYY=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=mfzFvH9Ss+RIi+dNBAfAbx2/7VlQGuV0cZN326ThvkSy5bZOE1VvZh+nKpn58TE/Xj9VAuIQLPGJUINRH/UFvS2K9rVpNx6IvWakJva31kWodf4XWFjhlpmS13utKWkzDk7eiDGWtMsVaULkdkQOe9l6MNIDHpKV+eHY8acXPz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ThsZB4SN; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ThsZB4SN"
Received: from pps.filterd (m0279865.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56E7QfFY008133
	for <patches@lists.linux.dev>; Mon, 14 Jul 2025 12:14:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	aoI5BFClgTcyFuK38F1KY+FhVdU3uKRCX2U3iUvC0Jg=; b=ThsZB4SNBrInD9Wa
	YmyWGrc2zGW9ciktJh7xytNgsEEs9g1akgkAuE6v+vHjbQTGM0sHGQy7V290e7dp
	15BBbMalNS92yhJdQzs84fRq0Vl0SXMXuNnL3RXxDfzWTxWjVBRKMiA10EpbkkFJ
	9XIKUKVVC8n8W7W+TsIILeQx7tt2ULLhBv9vgwxicXaoH8LCBpIJVOJ8u0NkdZ2A
	7sfng5mMUW0G4TS6rGT6gAwnB3+TuCrlNFkSlDdQrQcVmm85sVVmCJ+Bio4YJQC+
	on2aWSNC5m5HCOdSKchJoEPbUxIb8FHfNetrdbYkRLgOko61vPn3LAJ/e/wUJoOB
	ls6Btg==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 47vwghgxs1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Mon, 14 Jul 2025 12:14:50 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-7de3c682919so55940385a.2
        for <patches@lists.linux.dev>; Mon, 14 Jul 2025 05:14:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752495289; x=1753100089;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=aoI5BFClgTcyFuK38F1KY+FhVdU3uKRCX2U3iUvC0Jg=;
        b=cvEOslk/x6soPMOLA5b/MZXbHmq9aOkZ1YEhsgxYp/yfnDbc+uWMz+hJJRl5P3r2wr
         xXX+ohcEoqZFLgy1XqvPg2OX0AnLSFtY9xphafDnXYlS2GFsdacTkfy73T7PeSNxC+Nj
         vB/5TLc88YmtmGnYFdueE2xJgFxd85EJyQkoJh4k3PrRRKiX/730L/IfmTQWb1aWYH4i
         pWdJBI8UbQLQm727gfMFTloUlDtsgMYFx8GYX7SIYZ7mpyvNXHQ+93vfQyvnlP3iaUib
         Jwe9C3MlMLqbP7UjCRVcafCdjaRTfyuAuR71DnFc1SKmilUgCvenhlBiM+zvZPhNHQ81
         UIMg==
X-Forwarded-Encrypted: i=1; AJvYcCU7+FguAg5BguIDia/l04UwiN+tqhftmWrY2+nZ71YHN5XiwyQ6dptDhw7Swa5XLgSTgD+l16eX@lists.linux.dev
X-Gm-Message-State: AOJu0YxpmL1wx7tTCwHZ57U0ytbG7nP9w5Uie318YR09XLSYrc73COm9
	fFlgs+OJGq7YZOCpmqxLQpUm6zbwJ/RbMzm3G8D4Gb56ookADFzLzYBTu3gXcyIn26JAJmtuswo
	XyebpfyTaOUvWEXgWFGCFihqin9sWXyI3Nzb6C1pNZ64NcjJtgn7v2/+A/6q8
X-Gm-Gg: ASbGncvdoT6eu+M9bz3fd2xj9cDYS5IT96KZO1Mj5ngh5XwbjdEh2/XFN+c01BWP+hs
	lyrc1ZyRQClGEJN5Zo52VyweIPoT9cOAvy3WsBfLAYltuLL5A7TM34wnfYsHB1UwJEdy6kNvUyY
	p0x2XDCBiax03b2UuIzadDXXkujIC+xgSMvtcRKvL4ikFSOS8zAe88/FdjziKt4DYZkeUuAI/51
	Xd0mlRLsq4J8Axywmqpxea7/okflA4iDGaXCiWAsYfEOALpwZxKHdlGyCpKN2dxWcRjxNfPIAbA
	AsLAITA/qWoEDCooeQNoQRZ9wcLQTdqDr1ZJjI2txAkpgi3b/1iyCOP9mg5IK6tjvtD/pNu1BAr
	4rKtt3h/w/nyjlD+e1678
X-Received: by 2002:a05:620a:618f:b0:7e3:2d1d:bda5 with SMTP id af79cd13be357-7e32d1dc30fmr94697985a.9.1752495288889;
        Mon, 14 Jul 2025 05:14:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFG5vZyWrc5c1Pue3RENiHkc+kjzDktP9Y1RxdkTc6cDgp35ovMXQ//H2HFsJEBRaNnVMnwSg==
X-Received: by 2002:a05:620a:618f:b0:7e3:2d1d:bda5 with SMTP id af79cd13be357-7e32d1dc30fmr94696585a.9.1752495288322;
        Mon, 14 Jul 2025 05:14:48 -0700 (PDT)
Received: from [192.168.143.225] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae6e8298f85sm824827066b.144.2025.07.14.05.14.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jul 2025 05:14:47 -0700 (PDT)
Message-ID: <45e6873e-adb7-453f-abd6-c7b6620c9b34@oss.qualcomm.com>
Date: Mon, 14 Jul 2025 14:14:44 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] iommu/qcom: Fix pgsize_bitmap
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
To: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
        Joerg Roedel <joro@8bytes.org>, linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org,
        Rob Clark <robin.clark@oss.qualcomm.com>,
        Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>
Cc: Joerg Roedel <joerg.roedel@amd.com>, Kevin Tian <kevin.tian@intel.com>,
        Linux Kernel Functional Testing <lkft@linaro.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nicolin Chen <nicolinc@nvidia.com>, patches@lists.linux.dev,
        Alexey Minnekhanov <alexeymin@postmarketos.org>,
        Luca Weiss <luca@lucaweiss.eu>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        =?UTF-8?Q?Matti_Lehtim=C3=A4ki?= <matti.lehtimaki@gmail.com>
References: <0-v1-65a7964d2545+195-qcom_pgsize_jgg@nvidia.com>
 <6cc5bb7a-344c-45fa-a8cc-cea34493c759@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <6cc5bb7a-344c-45fa-a8cc-cea34493c759@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Authority-Analysis: v=2.4 cv=EbLIQOmC c=1 sm=1 tr=0 ts=6874f4ba cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=pGLkceISAAAA:8
 a=KKAkSRfTAAAA:8 a=Ikd4Dj_1AAAA:8 a=EUspDBNiAAAA:8 a=LZJuRBUwro2lsZWipJkA:9
 a=NqO74GWdXPXpGKcKHaDJD/ajO6k=:19 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-GUID: 3ZXj8CL9_G6GqdeQw3PwMBCXPrgkxqEu
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE0MDA3MSBTYWx0ZWRfX4sl559r8VItm
 Nkmq0Ysv/hFU4yHyH32BjEAA2+yjvr6stYovZhxKYtYeMHOrUpc1jFlfysXGe2XVyE5z/LCvWtb
 5qiya26QckFE3HAbF9+bo42txLb3BdRWEEa+yPlPvckPlW+8eqlQSnLoxdOr24fa+Ny63Rd/CkB
 zjNzJFjdNLRf1z2+nGKM7LBd6JYZ20FepO94L1ZRVaqj9OnGWSvgcxMqr1BfVM8zewWqK/BlNpi
 hJ2kN9drXRjPjxpRHqHr85OajNBWx6YBpi1BGgHh53lrtj5crDZYnfUTBuBEPymYe8uhaO0/oNm
 QfJk4/fpXaINWYPFa2ReE2DXg3+IvUE1XKFUUnjn0r8mHs+HYSVpjbu/SSjkLYZ0Y/KzKuKRRWj
 W3Zp371ezG5dsZThQDKCbqF45eBqxgAGXkPxOsc+Mo7UL3A8PyqY+GMV5N5FL0c8j6ttRiTl
X-Proofpoint-ORIG-GUID: 3ZXj8CL9_G6GqdeQw3PwMBCXPrgkxqEu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-14_01,2025-07-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 lowpriorityscore=0 clxscore=1015 priorityscore=1501
 malwarescore=0 bulkscore=0 mlxscore=0 suspectscore=0 impostorscore=0
 adultscore=0 phishscore=0 mlxlogscore=999 classifier=spam authscore=0
 authtc=n/a authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2505280000 definitions=main-2507140071

On 7/11/25 3:26 PM, Konrad Dybcio wrote:
> On 7/11/25 3:16 PM, Jason Gunthorpe wrote:
>> qcom uses the ARM_32_LPAE_S1 format which uses the ARM long descriptor
>> page table. Eventually arm_32_lpae_alloc_pgtable_s1() will adjust
>> the pgsize_bitmap with:
>>
>> 	cfg->pgsize_bitmap &= (SZ_4K | SZ_2M | SZ_1G);
>>
>> So the current declaration is nonsensical. Fix it to be just SZ_4K which
>> is what it has actually been using so far. Most likely the qcom driver
>> copy and pasted the pgsize_bitmap from something using the ARM_V7S format.
>>
>> Fixes: db64591de4b2 ("iommu/qcom: Remove iommu_ops pgsize_bitmap")
>> Reported-by: Naresh Kamboju <naresh.kamboju@linaro.org>
>> Closes: https://lore.kernel.org/all/CA+G9fYvif6kDDFar5ZK4Dff3XThSrhaZaJundjQYujaJW978yg@mail.gmail.com/
>> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
>> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
>> ---
> 
> The downstream driver from >10y ago for this era of hardware
> suggests (at least some?) users of this driver can issue a magic
> TZ call to switch to (IIUC) ARM_64_LPAE_S1, but there's no
> implementation upstream, so:
> 
> (adding a couple folks interested in the hardware museum to CC to
> bring this to their attention, nothing to act on though)
> 
> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

I never actually added the people I thought about to CC - fixing
that..

Konrad
