Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 017B444C506
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 08:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789546309; cv=none; b=hOIFimh7eOAnNFuvQt25lWEX7ZERj/OBdVot54Hst1M/fujAYteJsCMDJQag8UGcnWLPPRWesvFutcOrAKRUFL96oMayxKXmTRAB6g38V+aEsY4YDIcUpt3lIsM+klvfTbypev82FXTrjDbJxLlxtXPbmSod0298V37k/dag5pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789546309; c=relaxed/simple;
	bh=0s75eyo128mLOVCAI49BPJzYb9KlJ/X6EQ4npup68RE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IK6lwOlEl4wCrQaG2xeZXjmX0kVZ4b0Byzr+V1vVCrD8C5WQlVqMGSCsxex6QLFKyMqhs0+Uq7YCFF8U3aB+N1or1scodG6MPZzwTd82yruoa0qxTO3evAdmfD9IYS8ytMwpe/mlgTPQFIrvmNbZrm13+qvZdblRxDcHpNr2Na0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=HXh0hA7r; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=hXdv8OIM; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="HXh0hA7r";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="hXdv8OIM"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68G68qGP1955923
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 08:11:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Qpm1Y3oPylT9mPyiaTSpCsYjZSngMuRFhlOFNhAdSd4=; b=HXh0hA7r22EdB51x
	HBzQmHfdilLBR2bUySnZ4aUG73RqGL0Xnhr62ieqyhMnGOdXNfyrs+vXdJ4vCDjM
	kEX0gQs8qNfEtJkEd18zIKDUYmm7YBqPMB87ufJihPeJi6Gb9/QSF0gGYVyy6N9j
	UQJDoWEhR1O2fCh1ZF3oCkdGhH9FaD2XzCA56liEN/O5fXZaMDfAxyAnlX+ABOHM
	W3kSSJ/dMLZrRpQsLJprlCgxOpkQuYNCGa1r0GogSK/ncIbvLQLVGtohFYsLU2p9
	CH18Q3oiqPgqst4MFbOHCMgLX0z6t3mqJwWciPPQEMYSIOmvcJwMjAZ87uHQI0/A
	ovpQ4Q==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gqdywa78m-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 08:11:35 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-9392788b3f8so98227085a.2
        for <patches@lists.linux.dev>; Wed, 16 Sep 2026 01:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789546294; x=1790151094; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Qpm1Y3oPylT9mPyiaTSpCsYjZSngMuRFhlOFNhAdSd4=;
        b=hXdv8OIMsOlIooGHOKaNrFiYC20NYKvZ6rYsrQmXbkDIiLAwXC85id4FyjiF+E2uSd
         hMlloLVzR2cV8vKNW7Q7PQ9kBXZBu8st6Jty7Cs1fk7+KZB1AALkQO3DwdeHyvl9TaD1
         F12oRXv03SWSQzFmoM0PXgbiQajGxnz9+dgsCZg3wfySTVgZVNTWB+j42VbThRvl4gaU
         658/eYy7z2CVbB7ejnrtjyEzrMwDY0JjJ3BaTmn+pi15qYdCRYcGMmL/7bfz/nNy0YDQ
         ksnyaCxV7hi7hyfG/iLb/ROyMh/fn5NRb5yDVJFlySOaymAPhLwKrFivz3QssmoERX5B
         AHrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789546294; x=1790151094;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Qpm1Y3oPylT9mPyiaTSpCsYjZSngMuRFhlOFNhAdSd4=;
        b=v3yuGz6lZuY8N19L6kpRBk0HVpBcs3QR81EnsVGnDpriD0JpjmyCDguhthC+ayLoDB
         C8yv048w1Zi84t/kd1VW1y4Opd9UhchA8UEjkSz8XsqGnBCoikrA2FiwoB7cGvmWNr6n
         sPypzqZ4CKCY+CcPAa8OFQQvI70cSnOSKz3ffgSojjcHuojib0PjvVJPjzYd6QgBtuCr
         pcoP6SrmvZXbxqP4bClOhqKL8xOA9crb7hyiabkJt0RFWuumwZBI78Wj5/LH/L9l/qEs
         ClT3LWhq9MzAjCk1nDQ/1/YL6EI+CEchPTK/4/lRtM8JZQtAvKhuHbfOkeozQjNODEpT
         ASbg==
X-Gm-Message-State: AFuF++nIDG7go+8ixxwJRIuDbV3mNYTviIkW5dxIf22K87fd+/UUmmTb
	t1uVgXeielj1HKxpD042Qist0dZ8rTPKgQP2jWk54P8Pa9ml/cVlUCEIqp1ShkEl7EHWzFxIog0
	QD4WHTRUoIAiCz5FJIOzriUO0WluLyXyGjcBUb6h9LxqXT14WVl0eccrF6yrj
X-Gm-Gg: AYBFou2cDKILJZlu1EBcp2fhfoaE8Cguj3wo6fEMLJdEzrHiojSVnH5BdKhLapWK86s
	OvzKZT8IHBpXmI6X0VbP6zd1+4cvjiGIfdPsEz6x+PDEDdj1/6UiT2IUzqSz4hqJj/DdFLOi92K
	EITj2dSJoENnhbIe9KnSPVA2ttjTDQvxWH5+LZQkRhYyec7APirXp/hI6osKPv7Kq1NGLeJ9B8/
	bdjdVdVCWERWTb/GHcMk5LdiomqL5JlDG0XNUmzVix55tN5s8QMoPFsTpSVM5R3IBpOaiP/TSFF
	UsJ8x/RJTvK9UPXTJVkUZmEYpOT0ddpd06Q79e4c0Ix768LKCYcPvQlolW87nIMWCe0uPuf2Ouv
	TdwqI7ozyIAtwlZ13FeJbOg==
X-Received: by 2002:a05:620a:3727:b0:939:c6ab:e3f3 with SMTP id af79cd13be357-93bb78876e4mr210986285a.3.1789546294471;
        Wed, 16 Sep 2026 01:11:34 -0700 (PDT)
X-Received: by 2002:a05:620a:3727:b0:939:c6ab:e3f3 with SMTP id af79cd13be357-93bb78876e4mr210982885a.3.1789546293875;
        Wed, 16 Sep 2026 01:11:33 -0700 (PDT)
Received: from [192.168.202.12] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aa1d25e331sm1067522a12.17.2026.09.16.01.11.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2026 01:11:33 -0700 (PDT)
Message-ID: <911484ca-b1cc-4ab0-9fb9-2360ec33fb65@oss.qualcomm.com>
Date: Wed, 16 Sep 2026 10:11:31 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0766/1376] arm64: dts: qcom: sc8180x: Fix the PCIe
 iommu-map entries
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065624.612877788@linuxfoundation.org>
 <cc43fb43-b6cd-4d60-b077-5fdf7918cf8a@oracle.com>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <cc43fb43-b6cd-4d60-b077-5fdf7918cf8a@oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Proofpoint-GUID: YRcWEUc-O9XOVHmWg_FeXd-Hb0Ttf_Cf
X-Authority-Analysis: v=2.4 cv=aJ1lOr9m c=1 sm=1 tr=0 ts=6aaa4f37 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=yOCtJkima9RkubShWh1s:22
 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8 a=Pn9D9zQKb93tNRXYLLgA:9 a=3ZKOabzyN94A:10
 a=QEXdDO2ut3YA:10 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE2MDEwNSBTYWx0ZWRfX4ey+YmRHGIr3
 LmMPDWVwMMowDmxFYWiWyd9TSrhRWEo0DFp6wxeRR3/lg43YOzBMKqO5ZL3LY5ex015b8Ts91z5
 i0ut8FABOlMh7nQ64xZg0MzUGYMPJBB99mjTRADkbFJp7Tf0fnui9TT/a4UccxFZVj/4GN5nzeA
 kfc2KiSqIzpmQiB60nfTxbUYYuWl2vo8Z9ScN51CJ1TB0OIX4lLjSozJMU0Y8Vcaay5xgHEMou/
 DPf+SjoPpb8Pdn8VjAeqOmHfEZbxCSiuN9SMH2/FfWxqyQTfr/2iUZegm32MlGwuXimXzva8qBB
 rF45MFHShL/gW2Y/ozU9smBeKB+2KX0CpaN6EPfjYZinEkjRDWB0CXB82oawC8QWOzH8j0okdBc
 ZtFjwNz79pfhAEdDSBZQXO7RhQxVwC/KJLfjRG5ZtLZSCr5d7OVk1kYOaDfCNAn8JK4dBqj8oWq
 aY75nppqNvxDVyxgdtw==
X-Proofpoint-ORIG-GUID: YRcWEUc-O9XOVHmWg_FeXd-Hb0Ttf_Cf
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE2MDEwNSBTYWx0ZWRfX39R71NGny4Tc
 D3g4R9YcuvasH8bnob7+8iMYOvfJyv6/g4YkGBjlMgYBUALa+NkiU4S3zgGL5yzPSbg1eKH3V/U
 bdzyonYtd+GtOQPTbLBesDg8ZYBqDvo=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-15_05,2026-09-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 adultscore=0 impostorscore=0 phishscore=0 suspectscore=0 bulkscore=0
 malwarescore=0 clxscore=1011 priorityscore=1501 spamscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609160105

On 9/16/26 9:45 AM, Harshit Mogalapalli wrote:
> 
> 
> On 12/09/26 12:23 pm, Greg Kroah-Hartman wrote:
>> 6.12-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
>>
>> [ Upstream commit a4548204821a56c23cd711cfad2a637ca055ff47 ]
>>
>> The IOMMU provider apps_smmu uses '#iommu-cells = <2>', but the PCIe
>> iommu-map entries specify only one cell for the SID, omitting the SID
>> mask. This went unnoticed until the OF core started warning with commit
>> ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps"):
>>
>>    iommu-map has 1-cell entries targeting 2-cell #iommu-cells, treating as 1-cell output
>>
>> So fix the entries to match the provider's '#iommu-cells' property.
>>
>> Fixes: d20b6c84f56a ("arm64: dts: qcom: sc8180x: Add PCIe instances")
>> Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
>> Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
>> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
>> Link: https://lore.kernel.org/r/20260730-iommu-map-fix-v1-4-83405d37ba41@oss.qualcomm.com
>> Signed-off-by: Bjorn Andersson <andersson@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> 
> Hi Greg/Sasha,
> 
> I ran an AI-assisted backport review, and I have verified the report. It
> looks valid to me.
> 
> The corrected SC8180x properties contain two five-cell iommu-map
> entries, but 6.12's of_map_id() accepts only fixed four-cell entries.
> Each 40-byte property fails the 16-byte divisibility check and returns
> EINVAL before any requester-ID mapping. The PCI setup path can continue
> without the intended IOMMU configuration.
> 
> Upstream has the variable-cell parser and its API preparation series,
> including ccb2fd725d411265df8f7ce12a66c226b16014e6. That broad series is
> absent here.
> 
> Maybe we should this isolated DTS patch. Thoughts?

Yes, all changes of this kind (conveniently similarly named and IIRC
they all got merged in one go) should be dropped from the trees that
don't have the parser change

Konrad
