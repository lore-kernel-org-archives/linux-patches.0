Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B22D45A2AC
	for <patches@lists.linux.dev>; Wed, 12 Aug 2026 14:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786543295; cv=none; b=HMCa0mrHVwiy7md16lfREJd+rVPwRL06uw0NtvsydzXNkMgmHY1DTjd3+fKCJUefx84KIdjFAqR6L0ZeeTqE0aBO9XVlunv5DmLU/RHh1NYGa3rK2wFpI82F6W8z5WhNTMfk4SyFn31So7aJbTX7CtDVgED/NUshlZFp+TeJAFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786543295; c=relaxed/simple;
	bh=3dCWnOJrLyNJEihuCtBFmI1B0PCLOw2IdTVUvMwqT7Q=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=cukTXo1Yc+k8IB4WBY4f4nF1AqvhZN14fqiXJdAib3s/KBxqrroPwKwZP5rHQdnugZAKsi+uIWBuOOAMaf8oKzKrSs/uofbUiCLtfCIQC/L63ktqZjvRN9Q7/ISba6xP0CNWpuosFASN+XEjbjXfXRgm8BvmICC0GgmxZCoqLSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Bc71RvME; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=jN+/Lwko; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Bc71RvME";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="jN+/Lwko"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67CDcs0k3654843
	for <patches@lists.linux.dev>; Wed, 12 Aug 2026 14:01:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	dt1GET3R6/6Z+iOREfRu34e0pr+BS7qqETIu0IxNuuI=; b=Bc71RvMEFu9tdn8A
	pqqezGXdcWyj7+3GckVytsb8YtDaJEhiUkstVJqQCJVN7dPsPwM5ybEo3vu7ZCNd
	jUtdHlMsW9g2jBAF9d9V6RKC9dZ93BZbMo9Dm7S6kQmkAwXaJ80BuH1jqCkHDh3T
	Jv4OFOTb67xijHDw5Up3DBOVTvpKy23rKyfdRGLiJiYcsXkgK9B+m47w7ulbJm84
	emDfi4zg3kxTAybv4cw4bewoUcUSnuxpSKkCBzF1mbAYjQ7QayYyC+GnuB8ArIOD
	v4kLUKaoHJU6J+eqzaE5rq1k867sMgkVucZd5FMUhmNwGvnY2UYDta+OahCN9gzs
	RNk4rQ==
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g0pmyrwew-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Wed, 12 Aug 2026 14:01:24 +0000 (GMT)
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7e9f6a49e69so1320621a34.0
        for <patches@lists.linux.dev>; Wed, 12 Aug 2026 07:01:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1786543283; x=1787148083; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=dt1GET3R6/6Z+iOREfRu34e0pr+BS7qqETIu0IxNuuI=;
        b=jN+/LwkoIHXo3PZPp7S9GfYeMX5XhTe045b64AMBW0aqa859SZwW5eUIP8BANBGQGT
         w+mfBIzzLD+L67C04R3PW5shAFCS0AFhvF1ZhgVncTvsdagoCutZ8UPeIBY3MhsHR8TH
         NpudsytBPIt1ifjDNyHndw0+K0pn9D1EfPX8BgOoPkSEkxG4JiHM3BAm0fcGY2zzpmyE
         BQGE903DTykWeBP3R+LrMoiwxuCGs1S8UgXXWYKEzovhHCuva+gcWunLx/H2i+yoVlGJ
         +6NqHFkPJYyXCXXDFUlqnEVdN6dbWW3v0RZJvenl9+fFkwyyenblML6bthiT3ocvmSVH
         wsFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786543283; x=1787148083;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :content-language:references:cc:to:from:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=dt1GET3R6/6Z+iOREfRu34e0pr+BS7qqETIu0IxNuuI=;
        b=Czl05K+aAlgSTYZP7iywhzrCIsFx+nd+sEuB5Ycrhy6Xkr4DOZqYpF0O2//9rI0aYQ
         pTaOhIu5iDnjqtAdY3bbUPmyztoUr6H5ZdvU+gypZn3oh3O5z4lQlDsVnWQp1nmEgOPt
         wsTyH9dw0RDdodma/DvdBRszK26mm2AbmKfMKrli2v7i5RrpEvWaj1Q9pKdVe3BHvR0o
         L2U7zfO3vP55Cu1S+/XxsfKzUF529tEd4tka6UUjmEUdrDCy+a+OLjdqifNgFicZ/wRp
         0I+RyZkbREpogkbCDtjCUVKfZAkBRX4x55hVBNUcLihfSWX2TgRUkqqIaX48xYPKD8Nj
         Paeg==
X-Gm-Message-State: AOJu0Yzbvbaxtv2/q17FY+JT+FzHhoXibPNjRh2oRmbV7jb+hrvUaVJn
	uhfieAmP/mb29HnsE6eTN2dA6/mHl1SXA3U3D746rbZF/V/hSD8VtHB2qovugUcz5m6uccCDo8r
	Oi3kabLNxsP2pzOdbsLF+58cSHY8mwBCpRFcC8wnPEJsG9JNbgYdvJPQTWm/SPrRPh+Pd
X-Gm-Gg: AR+sD12z4lIaiK9+vMaxN8L9h6VOIoLnN9I++pAr+doHCpCzHdpwGNwNwdAq6A7B6pM
	aUA4aN2xzdkWuxMXuoXg8sjgkJK7lT17jZSQcCoscyTge6/k5T3DOB7CBNWOBWE7OHkgd7GR+68
	7D2ZEp7MQEp3OQv2POUqGb9Bwu8erfPrhFsZCrhpzQLwYWa/W84aY85fVVWJprLQHlWcRALWqih
	Gn2NzA3EaLhONHEYb8CVuX/ea6sL2viGVNZyN0g4q9DT5L5WJ+RO7PTn04PYt/B68QU/kpR3OsC
	BQv51wCvCgTMwlryushUiUL3hkCD2Cq0AyAQQfKAv11p76Cmyu1nEJk59VHB+2ELE0a/eZK0vFc
	wI96LK93IDwUuewYviktjJT2ueQF8
X-Received: by 2002:a05:6830:2a8e:b0:7e9:cd7a:7c34 with SMTP id 46e09a7af769-7f3b798b150mr5219249a34.10.1786543283266;
        Wed, 12 Aug 2026 07:01:23 -0700 (PDT)
X-Received: by 2002:a05:6830:2a8e:b0:7e9:cd7a:7c34 with SMTP id 46e09a7af769-7f3b798b150mr5219146a34.10.1786543282715;
        Wed, 12 Aug 2026 07:01:22 -0700 (PDT)
Received: from [10.92.216.212] ([202.46.23.19])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f3b3209120sm3282682a34.7.2026.08.12.07.01.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 12 Aug 2026 07:01:22 -0700 (PDT)
Message-ID: <c8324e0d-3688-44ab-b775-82402a7f9c33@oss.qualcomm.com>
Date: Wed, 12 Aug 2026 19:31:16 +0530
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0139/1276] arm64: dts: qcom: sc7180: Add power-domain
 and iface clk for ice node
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
To: Sasha Levin <sashal@kernel.org>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: patches@lists.linux.dev, Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>, vegard.nossum@oracle.com,
        Krzysztof Kozlowski <krzk+dt@kernel.org>, stable@vger.kernel.org
References: <20260721152446.065700225@linuxfoundation.org>
 <20260721152449.211750681@linuxfoundation.org>
 <a0273f34-8596-4b6c-a489-66a4533b6dd1@oracle.com>
 <ab3c3006-bfa0-417b-86f7-95470c73e547@oss.qualcomm.com>
 <20260801101505-6a6d5089afcf@kernel.org>
 <1c1c926d-e0a9-40f7-963b-94677d29ebb3@oss.qualcomm.com>
Content-Language: en-US
Organization: Qualcomm
In-Reply-To: <1c1c926d-e0a9-40f7-963b-94677d29ebb3@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEyMDExNCBTYWx0ZWRfX/y+d6MBUeSzQ
 6hHuma2VZ6RnNc3Q9BZMzTIGXnWZN1p5yLYNv22M8B/blOAgHIIUqCzF7iDArvD3sPlnaaW85xI
 v6mTAiOUh9SaBq8mXBWpSEr45ecR/98=
X-Proofpoint-ORIG-GUID: 4-o38ehjF9Qb2YbPoseLPE8N23HQY8BJ
X-Authority-Analysis: v=2.4 cv=C/fZDwP+ c=1 sm=1 tr=0 ts=6a7c7cb4 cx=c_pps
 a=+3WqYijBVYhDct2f5Fivkw==:117 a=j4ogTh8yFefVWWEFDRgCtg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=yCuQjaVjHFs82LyP-Q8A:9 a=QEXdDO2ut3YA:10
 a=eYe2g0i6gJ5uXG_o6N4q:22
X-Proofpoint-GUID: 4-o38ehjF9Qb2YbPoseLPE8N23HQY8BJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEyMDExNCBTYWx0ZWRfX975560SKvKYn
 hm11R6pB8jsHWH3HUviWvn/bF08LSug9WyA84AMhWPDdhf3xIIFuHOcofkEFYiDNVCv3QZZw/DV
 KDkk+on9gO2BbbM9xLA9b+zpvPl2apFT993j4xEjonmgYkvcvXXl44lBDaGgSqQloS4MwUmo+9V
 SkK3FoOLWNoON/QF5gibKUt8uPg7PhtuGlXX0eG2XM38NATdP0RvUAhqpMpNT9wp4V3jlvTOIhW
 q4JnHO+bi1fMDfn3WOySojVAc6Q/N0Dav9RO3subOFr4Ypz2d/XcKtzaTohU7JXXB1kuopq8Hyd
 LMtyzN/OTrF0FwUiFtXS1HUYBY+7tunHrLCyq4p83vvwsrjRRF1+er8VIFihCutG4d4gUZF+nRp
 wifJmX3QYKDuBmp9xKEDcJ8HitAJHp5A6bg9TGKd5LcQCudVWNKcNJydnjtBGJKPIM2A60j2U2N
 QDBDZhRlIS3RL9z5G3Q==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-12_04,2026-08-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1015 phishscore=0 spamscore=0 malwarescore=0
 adultscore=0 suspectscore=0 lowpriorityscore=0 priorityscore=1501 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608120114

Hi all,

On 02-08-2026 11:40 am, Harshal Dev wrote:
> Hi Sasha, Harshit
> 
> On 01-08-2026 07:50 pm, Sasha Levin wrote:
>> On Fri, Jul 31, 2026 at 12:51:25PM +0530, Harshal Dev wrote:
>>> The 1st can be taken on-top of the four DTS, since describing the clocks
>>> first but enabling them later via the commit is totally fine.
>>
>> Thanks for confirming - and no worries about the delay, enjoy the
>> vacation.
>>
>> 0d5dc5818191 ("soc: qcom: ice: Allow explicit votes on 'iface' clock for ICE")
>> stays queued for 6.12 on that basis. It closes the gap the four DTS commits
>> already shipped in v6.12.97 opened up, and I confirmed it's harmless on the
>> 6.12 nodes that were never converted (sm8550, sa8775p):
>> devm_clk_get_optional_enabled(dev, "iface") just resolves to NULL there, same
>> as mainline.
>>
>>> The 2nd one should be taken to make the DTS patches comply with an updated
>>> binding. [...] However, the patch must be adapted to 6.12 to not make the
>>> power-domain and clock-names mandatory for Eliza and Milos since those
>>> targets arrived in 7.1 kernel. Only the first portion of the patch is
>>> applicable for 6.12.
>>
>> Agreed, and that matches what I see: the allOf/if-then block in e27264daac7d
>> keys on qcom,eliza-inline-crypto-engine and qcom,milos-inline-crypto-engine,
>> and neither compatible exists in the 6.12 binding's enum, so it can't go in
>> verbatim.
>>
>> We don't hand-split upstream commits in the stable queue, though, so
>> could you send the adapted version yourself once you're back? Please
>> post it to stable@vger.kernel.org targeting both 6.12 and 6.18 - 6.18
>> shipped the driver change already and has the same binding gap.
> 
> Sure, I will send an adapted version after validating the binding with it.
> I will be back in office next week and will be able to provide the patch.
>

As promised, adapted patches have been sent to stabe@vger.kernel.org:
https://lore.kernel.org/stable/20260812-adapt-ice-binding-for-6-12-v1-1-ba4374b81a3e@oss.qualcomm.com/
https://lore.kernel.org/stable/20260812-adapt-ice-binding-for-6-18-v1-1-e224dcf77072@oss.qualcomm.com/

Regards,
Harshal 
> Regards,
> Harshal
> 
>>
>> Thanks!
>>
> 

