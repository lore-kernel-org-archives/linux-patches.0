Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29ADF2EA173
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 08:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755075513; cv=none; b=m4U9uv9o8zyMJFV1SdheAqZzVQZSTug6BR+Vz97KVliQi8hRzF2N+jyPaKqS6iQh5IGatB4pNuSxBYr7MEifG6Ps+nSqo9BYohh+Oprc8gyIomBG9GZA31d9dt9Bv6lQVqR+MryQmS24aWit+FrNYolaJtlRWMWAKBU9YADFe5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755075513; c=relaxed/simple;
	bh=KFH70lzhiR89VhPRQXx3QT4OTk9AP0m70WRFqN+C+Pc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tI2hpMJenFkH4uYwZYw5uYxAcIwGBikE4OoaS8Tvjsx0tgG6U2m+MpvyyfUTN/U4L7DBCNecKOaqzxeeIJUXl67715+frdoqp9SO/VqlSrP+pPoiH1bECsWrQhOUoPaYekj+btv2odJtqkCQuWF9o8SkDq08Wqi34aPEFBR3Suc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=TO2VOhK6; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="TO2VOhK6"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57D6mTSJ004023
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 08:58:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	Sa/V4HmJ/mojf/pkiXD0zKrycdfGklDYHNguSD/Vzzg=; b=TO2VOhK6ObyyDeV9
	/qeQW0mwLxTp43cztp2zfmRlXyeK26aCEA05iDXS6q7/V4MLNom+ZwCTNMQ5o5sY
	4xFWmfnQJ/Rxli+o35YhbSgkUej/lTrWUGB0wYHDIX9Shtprs5r1tZqTGgkqJkMd
	LdIBXL+A3L8A+aUFKzioegw4St1VMrOWu06IkxOqWwoKrxG3sEMnWnwB1urO08VJ
	0aJPia+/DGHSREEVz+xqkMaB26TrPxeIibt9Gex/fPKY99xrgvwnpmxi7i015DkL
	rBpV+M5mV5MEyvMXVtGV00JPb6SjR1e5YoIUyyl8tgtlOPE9KnMhzV4nKokCFJPX
	7kY3Og==
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com [209.85.219.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 48fm3vp2ve-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 08:58:30 +0000 (GMT)
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-707641946ecso15310696d6.1
        for <patches@lists.linux.dev>; Wed, 13 Aug 2025 01:58:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755075510; x=1755680310;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Sa/V4HmJ/mojf/pkiXD0zKrycdfGklDYHNguSD/Vzzg=;
        b=bOQcvbnhOMqmbSPeJMxusrRHI5A5gfnA0yeIq+BHMBEM5xsWSkaaG9jHeDVDEDsbrC
         p3K9HRW/7ASFb9GHKVOULt9ielVTr+OthsOL2hDr4OucGJm895ib+kpVKbw4Sg5yVlfA
         Xq+Q9eBmFJ+V0yQYBT0mgFnt2DVgIPFQVrBf4s+ASQLX8h761XsHM58jp9+RnPeobawV
         R4u2vMEK2TV+1jJsQvtmYUTFJ1oQvDsVEV65tsQ08lC5X4UnAKxlOwqtY15cAqqwx7J4
         GLT/q5K4YvMNFcQ/2/Oj/pQECM7RKHyz5SACt2OvdcMuBrG3YxWzkQyIQ+3VmYWnJVSN
         f+Sg==
X-Gm-Message-State: AOJu0YzlMiw6LTQuDoaAPHOXDEpg7l/iloEu6Rjl6JIGaFobFmwSB7ew
	z+pexjeBfZpRVciMi6xP+YuUcv6XtHVQMRbXgw9Z4pea5tukBeWUBMGU/hDjB6HtrJ65n2Sd8vY
	RmU3MUwSFhpooH3OHmkkb4F+EYRmyPFFyGPbMldAfWEOCSs/0fr3IUkZx41NQ
X-Gm-Gg: ASbGncuDWReR1L1tQdUgm3IMDXMSTLZYzDVJMI6N58/BhHCNIsUvdfZcAL39FiOkhn/
	c3uoO9hjpAQO+A/XBESdG0LSDtgmTbt3iYGmkioqnatJjtAsbdxLnkDT8VKEVgIT8neDQKlrx/o
	MnTWfcX+6Mb8Kbyxkmvlt1aKH/iS8QDUb+rfOizN3/AAtwDDGIH6ZTvHmc2YTKV+madDQ8n/KXi
	oxuUPxfxcZ6Kj/rHSYIYydB3qBTCvWOSIB4H/W6UaMFadWVNrVUkFPz5iPqxhEeCL0Ya88jFb78
	/LY7X0AHGRSsYImujRm0Ds6Fs9ZTlAzk/JwcRZahNES+fK9WL0I3Y+taVhkNYTiS2B0dcacoj9L
	pkHj7JkDrx4I2JAtyMA==
X-Received: by 2002:ad4:5e8c:0:b0:709:8842:56f5 with SMTP id 6a1803df08f44-709e8948605mr13256566d6.3.1755075509953;
        Wed, 13 Aug 2025 01:58:29 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH4/ZJ4FepcsW1+Fc5JSLSVX/yrM4rVpDi6H+cxZm1/8vcdkwAGy3+ceg+vkS8lGYt6QvYAtw==
X-Received: by 2002:ad4:5e8c:0:b0:709:8842:56f5 with SMTP id 6a1803df08f44-709e8948605mr13256386d6.3.1755075509455;
        Wed, 13 Aug 2025 01:58:29 -0700 (PDT)
Received: from [192.168.43.16] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-617b11bdc49sm10821531a12.7.2025.08.13.01.58.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Aug 2025 01:58:29 -0700 (PDT)
Message-ID: <7faaa006-1162-4fe3-b27c-f507c0df792c@oss.qualcomm.com>
Date: Wed, 13 Aug 2025 10:58:27 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 121/627] interconnect: qcom: qcs615: Drop IP0
 interconnects
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Georgi Djakov <djakov@kernel.org>, Sasha Levin <sashal@kernel.org>
References: <20250812173419.303046420@linuxfoundation.org>
 <20250812173423.926141939@linuxfoundation.org>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250812173423.926141939@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODExMDEwNyBTYWx0ZWRfX0ozTIQcLgP/0
 u9lJGcm0/HOpSGyzq/dT2HGizSZKWuTb6qLYf7gv9tNEEB+IwZYDoasPeDZZ95o9w3vhIE8pKP6
 ew5uLiOcXoGt86RV3sYl04LhB03wIBP+NYcxmd5rO/22VBxEQOjsMnBz33MncKoGHSebXgQNUpl
 3LRRVWShhHBs/1dGIDw5SiLiH6vSTyE6Rc7snJo0dlGl9oVBRWFfHpkCF0k8uJ2B5NQ49DRemP+
 Fy6DsE4Gjgpo5jaNDu47mqj1iHHfw7+i9TVsCLkTBzclTQY9jnqnPJejEnh0F66zbC/Kgmv5/t8
 Vf/Zbdxub9rNmg3KhRca5fMVXpePZPq5MFOYAGoMdC5HfqVJ6Q2BIM2WeamQ6lNeWg+5/N5oLwK
 8QGfgS+k
X-Proofpoint-GUID: obQtqZFP50aO7d8llJnaDPK1mW2VmDRd
X-Authority-Analysis: v=2.4 cv=A+1sP7WG c=1 sm=1 tr=0 ts=689c53b6 cx=c_pps
 a=UgVkIMxJMSkC9lv97toC5g==:117 a=FpWmc02/iXfjRdCD7H54yg==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=EUspDBNiAAAA:8
 a=Lh6LkGG3E_lky4PZl18A:9 a=QEXdDO2ut3YA:10 a=1HOtulTD9v-eNWfpl4qZ:22
X-Proofpoint-ORIG-GUID: obQtqZFP50aO7d8llJnaDPK1mW2VmDRd
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-12_08,2025-08-11_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 suspectscore=0 priorityscore=1501 malwarescore=0 spamscore=0
 phishscore=0 clxscore=1015 adultscore=0 bulkscore=0 classifier=typeunknown
 authscore=0 authtc= authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508110107

On 8/12/25 7:26 PM, Greg Kroah-Hartman wrote:
> 6.16-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> 
> [ Upstream commit cbabc73e85be9e706a5051c9416de4a8d391cf57 ]
> 
> In the same spirit as e.g. Commit b136d257ee0b ("interconnect: qcom:
> sc8280xp: Drop IP0 interconnects"), drop the resources that should be
> taken care of through the clk-rpmh driver.
> 
> Fixes: 77d79677b04b ("interconnect: qcom: add QCS615 interconnect provider driver")
> Signed-off-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
> Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
> Link: https://lore.kernel.org/r/20250627-topic-qcs615_icc_ipa-v1-2-dc47596cde69@oss.qualcomm.com
> Signed-off-by: Georgi Djakov <djakov@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---

<copypasta for another stable queue>

Please drop, this has cross-dependencies and even if we applied
all of them, the series had no visible impact

Konrad

