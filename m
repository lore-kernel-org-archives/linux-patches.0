Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1843B39CCFD
	for <patches@lists.linux.dev>; Mon, 21 Sep 2026 09:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789983445; cv=none; b=XsoVSIuz7e1wXGKvSAP/3Jc64EMF6GdVgM1zSh2jG7FWA/VCP6PG44e4CdVycpwZVJlQmAianMYuxlwUrR7QzrFsnMJGShdx71/teojyvWQNNwMVhRj3lZYyIH/Go81IEqLVVjfgKda3CdpeTjwkRe2uAtQ+SVWZsRenDus7kGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789983445; c=relaxed/simple;
	bh=9QHUVdaZzK3zrT28M0Ibcx7qsEa1FTGQyIxXNBbPGMU=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=akhS6Fqda5WPnsD1rH9xQG3oI6B0jqTzerb0iQO3sFzdoFUzf7RbxOynJH/QkmNIs8WlEKXw10XzA83xXWPMOQyxUIkQINCZj85n+fui3GlBS+5THDQNJKnEDwzZ2HXPTjCKeJ7W76YU8g7xhJVsNF05xQpRn2/jv0d9O+sgGY8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=b7kJxAmc; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=e++PGlaE; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="b7kJxAmc";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="e++PGlaE"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68L7FZbL958228
	for <patches@lists.linux.dev>; Mon, 21 Sep 2026 09:37:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	8uI9/fWCr9BWQafylmcrF08x1jWqCPZOKku91jDtxmI=; b=b7kJxAmc+KE9pU1p
	d9vJQPjR2TQWl03UCJWxRR2UG0csKCwPDyoF4anJsPiPKEjS+rE1FnvVhP78Mt2q
	gJPmb4/oVckzGXjav+CzogBn2nlNeS1oxvaCzXWUL/+OsLrvg4KpYzqgpMR7D/2B
	OAeX97wV0ZijJFIYqaNoavcafCPKHxUV+ejMSocLmQBFfwonJp0EzoOBA3eBUoXc
	UHt5AOWbtZDB5/BNMGM93mN9dXBmLrxh4bBJQhDsc+Lsi0fr/9HUmHbX1AC3d/Hu
	WsWIo2hTaugay1qERW6PBGznCsD7m1aESCJxkamIdxh0E0gyIuWz9r4e0N+Cr0Pz
	4I8V7w==
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com [209.85.222.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gu01d0jqq-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Mon, 21 Sep 2026 09:37:22 +0000 (GMT)
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-930a312222dso74200885a.2
        for <patches@lists.linux.dev>; Mon, 21 Sep 2026 02:37:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789983442; x=1790588242; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=8uI9/fWCr9BWQafylmcrF08x1jWqCPZOKku91jDtxmI=;
        b=e++PGlaEZu35ZjbAkOBTb0FEbh4x6D/Xk/vyCdxTqPark/i8KUVkkfvbpEIbjIPKuh
         551w8icYQngyhjP2jBESoF62aQJWNL5utqxCdFAhAXVRg3qbWsEpWLzJ5hMP4TjCGRcA
         KRKJNms05TTtYij8jMle29WwTOBhRLS4gGv70nB+YkzfgKEl4Y6H0Qd8nRBssNGatvQ2
         U2s0BSeVSf0u4EtDQzv2/9CC4dDxnQzpXwMP6YXT09qUD8PT5ws5g5G6LG4MCAvrmi4j
         IOlB1GQicXzPy666TIrIxp+LMPuiKRC0nQzKIKNfQDN6KcaUVJ6wQ7xbsio/BOc7LL57
         iQhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789983442; x=1790588242;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8uI9/fWCr9BWQafylmcrF08x1jWqCPZOKku91jDtxmI=;
        b=RubnxnpvB1LxltllaPkwcwRQq6L4iLzsQm+phtlHNlbSYFx0BhS5Sa0fd9T2kHm2C+
         fgTVDYudCAXbq0G7huEAjamPlqIlsamo4nesa+Jj1IDzCzx180pkro6VkwZOpK4DmpRI
         9P645ZQIHdFKrOelgHqIwTRCwSiKjOv7UoW8h22jL/CWpNec5UEBE2naUaol6vyr5fb1
         mc2Cpu3FlQD9lrXvmsr+BZQUHfCirhKkFqzFNAUQalp54YmQ93JDYrHM59CUZnvUVoQ3
         +kWumlTDm9NMNLsGdrBg+0D8iPnr6uw9pdNIYnMHQiBnTsiiccJ/qAUKGAkC2skoD7MV
         z8dQ==
X-Gm-Message-State: AFuF++k2yB9F+OPItWL9Wd7PP6aZr0oawyVi1jtHYE5lTCSur5HLUo1a
	8y6Xf2Y88RJ61mtnE6XUQESJQ0mmoK80XyVY0RAwcMNFhF088VaLKX6Dzg3neXpGebJeErw0xxh
	OhS6ReSrYGvTUwmA5Gl1RiYenc8feXqGxP+JgJdLjXHBAvBQt5remb8np5wdy
X-Gm-Gg: AYBFou3Iv2gmJ7BfJk1xrW0LB2hFXB/vhixpJKnOJ9MVLRlv8GhW8DiOvPGEkKZrsJI
	dr419VxyJekJa9gPbXVS+OydfMjKqVENJBf2uX9KeQBEOmQw2nhAT0tL+8S8ZaSVkBS/7wcuzPX
	Yf80exbr+gO/OP79WS0wVAmYhUIspaIYpm8SYoZeRkQpj/bai36HgIKvcgZD8fDVbNlA61NScIl
	UBIMoRP+N4/HAdAZw2i4CkxD06YRQOJLP/JzU93l2UvPaBe1G/JU4Eijsim4pYlBm1AalWlgQQ3
	uRwFZNwPQzg6XyBTeYdlIHYxmRvVcRh/g3ZWxw1TflEeEoZC066NU0FDzYJG/e0z4jvLZnuY627
	e6QnRSE0E6aqZWzt/XuXoWw==
X-Received: by 2002:a05:6214:2406:b0:912:408c:d75 with SMTP id 6a1803df08f44-9129c75e186mr109835826d6.1.1789983441958;
        Mon, 21 Sep 2026 02:37:21 -0700 (PDT)
X-Received: by 2002:a05:6214:2406:b0:912:408c:d75 with SMTP id 6a1803df08f44-9129c75e186mr109835406d6.1.1789983441563;
        Mon, 21 Sep 2026 02:37:21 -0700 (PDT)
Received: from [192.168.202.12] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aa67e35d64sm4066246a12.30.2026.09.21.02.37.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 02:37:19 -0700 (PDT)
Message-ID: <c32f67e6-c4d6-450d-8a7d-3057ce3a94d8@oss.qualcomm.com>
Date: Mon, 21 Sep 2026 11:37:17 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0766/1376] arm64: dts: qcom: sc8180x: Fix the PCIe
 iommu-map entries
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
To: Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev,
        Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
References: <cc43fb43-b6cd-4d60-b077-5fdf7918cf8a@oracle.com>
 <daily-reply-20260916-0006-re-qcom-pcie-iommu-map@kernel.org>
 <848e13a2-e80c-42cf-845c-0c04a4547975@oss.qualcomm.com>
Content-Language: en-US
In-Reply-To: <848e13a2-e80c-42cf-845c-0c04a4547975@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-ORIG-GUID: cTMTWCJ5IAQB9oBTKIONRJtAr1IGT_EF
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDEzNiBTYWx0ZWRfX4UGwS/Dl1tju
 uF/b2OFq8FGte5ECwiAmwXp8Ixth8HBSxeeA/kpD22c14ooKNZStIV+SL21lnJJgJylo21/fmQU
 CTE4yoFu1ySLHlsvn/iPCSWulxVAz6Y=
X-Proofpoint-GUID: cTMTWCJ5IAQB9oBTKIONRJtAr1IGT_EF
X-Authority-Analysis: v=2.4 cv=Ht7jiETS c=1 sm=1 tr=0 ts=6ab0fad2 cx=c_pps
 a=qKBjSQ1v91RyAK45QCPf5w==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22
 a=lNoLSsqp7PxrA7xlTPEA:9 a=QEXdDO2ut3YA:10 a=NFOGd7dJGGMPyQGDc5-O:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDEzNiBTYWx0ZWRfX7QLnQuk8dTyx
 NN7epwJ9aYWS5m0VIs3boypE5BoWOkuCVE/k3+w5r0V2mXhprYLjztM6VdA9uHEALZzQEmS4xiF
 Il9WsOwAXXjURltwFl35bqaHtOa37opI7tHUsJadQvbGKLFE1KFbyRzG0yhgEi2/cbP7Uqf9gdU
 PkJBCibtXHvd0DexV08RjdqHKydM661xariw2FdyCz73Rp0lLEh/2LT1UGqtlSpKrf/GfVhEvQ1
 TEqESAYVlpO5qiEVTePO7CE/sRgUQfpnENvEZyAqMz74M3RaYEPXUQ4Dkc/e93PbX+L5WmK+PwW
 TUVaqyLSWqV97O9zxgjYHPGyNICRV559HRromkgxxZPMu5+Geop7LgZ+rO9HFjaqBMV30W80MUo
 bQkCYGlptgv1+HPskjV25aammiBxJVp3xIzk9CBsNN981Vqi6ktydfYGWSiQWu+VdDcVtsvBAqW
 jTBZXVrlC1883u/e5mQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 spamscore=0 adultscore=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609210136

On 9/21/26 11:36 AM, Konrad Dybcio wrote:
> On 9/16/26 9:27 PM, Sasha Levin wrote:
>>> Upstream has the variable-cell parser and its API preparation series,
>>> including ccb2fd725d411265df8f7ce12a66c226b16014e6. That broad series is
>>> absent here.
>>
>> Agreed, and Konrad asked for the whole family to come out of every tree that
>> lacks ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps").
>>
>> Reverted across 6.18, 6.12, 6.6 and 6.1, 35 commits in total. 7.2 has the
>> parser, so it keeps them. The msi-map siblings stay as they are.
> 
> I think the updated msi-maps parsing would be broken without that
> commit too, no?

For clarity "the updated msi-maps parsing" - "the parsing of the
updated msi-map which contains the amount of cells that the iommu
node provides, rather than an always-assumed 1"

Konrad
