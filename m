Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A5C946EC9D
	for <patches@lists.linux.dev>; Mon, 21 Sep 2026 09:36:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789983389; cv=none; b=qx3cT9kCyT04V7rYS6U7EvEcXRrtcVlaJJh7+Zyy5VWkddn64KuuwhzG8uDTBPZ+t/Yw5ZXNgvLBDoareyeGJsFoDtVONaV1QW+TOaJrE+PA0LDqmykqB7GO/iu/Eyz1uxeAyeel0sE2O8Ur0+NATemWh5MVCiIy+pAEY+eWNVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789983389; c=relaxed/simple;
	bh=GluV7HK5SQgSmRO4is6PpP6MTVEpkepOvyKtPfeMqwQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Pw/mlXBPq26HnYkl8xhYdZigGnfM6TTA6ZZLR6NAsEHH3n7ZP5OdOGHDol6TjDsJ9zKOjWFu9ntYkGGvtvciQyhbrNPMaVw7q1cVdrdRKZbRvQr6AwhtRWWNafqG4m4k1Ykan5NQzoDbe0KhbKK5GZbU+a+jrgjRO5M0Ws/cilw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=SVqAQ9a2; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=J1u1ewEw; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="SVqAQ9a2";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="J1u1ewEw"
Received: from pps.filterd (m0279873.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68L7AUuB468487
	for <patches@lists.linux.dev>; Mon, 21 Sep 2026 09:36:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	MjWi0f5HBUqKoCamo39fIuPiQh9wgKyBlAdXtwkyekY=; b=SVqAQ9a2ywFk47E/
	fli1WmAaCtS7rb/0Not2n24hYbW6vR7IkuDvCAPCtASm/sL2e0OMz+dWSKqTUTX7
	dwoMVMgx/aD0x1ThGHzekE6tdIlBtT4lIgAJCb/HYfvcxK0j23tXqdrzsCeGhRJp
	yK31h+lu8LtRPUwk5BQc49iI2jQi75589EtK1NB+eq6ph5aVPapOOdQOJRHHbGK2
	+iCXiJ9MIqvFhqHinaj8mETeMbbsgS6DE32rED9H+28N5j3KecvTguRfnKSFir7+
	X3vOYR/lmJqBQ+bslra9rRu6otej98Z6dPwQGexOGS2wxjULHe7SAtj45Qi3m2h+
	HRIumg==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gtq8b9yet-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Mon, 21 Sep 2026 09:36:26 +0000 (GMT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-93821883e26so126740285a.2
        for <patches@lists.linux.dev>; Mon, 21 Sep 2026 02:36:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789983386; x=1790588186; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MjWi0f5HBUqKoCamo39fIuPiQh9wgKyBlAdXtwkyekY=;
        b=J1u1ewEwrkSYQZ6Cd5IZ8FDFm/S+2rNBfykdoqXB8gJBdgQ4KcpoAciGzWkJlJe/WC
         w4/Mm9Cg5pL6VUO+UNXV+S2ECtuqrkfWDtmtsy84LrXaFx3g/YBsagtSl8TQKH2cMFQu
         aDGOZC8Xv0bu3Hj0PILU/TWaxAj97b4eFlOJkJmyjG2jQiY5KCzZXm0ioGoUQTs76uqD
         wIvNQcRv0LzMRt67hMs6BCcZ29yCIrTfOY6sPUvnqT+44CvXUccPQTL+vnKVLuVRDVVk
         3quel/QwldG8artpAaFUD0CPOXM0YPLQQHq3t+dNuHqBMfApB4ZaUToNJUEX/YsJTa9M
         nuXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789983386; x=1790588186;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=MjWi0f5HBUqKoCamo39fIuPiQh9wgKyBlAdXtwkyekY=;
        b=uGyyv/ZDREGK+Mf8hJSHDzSiDhHeqmcfxdpkBCNlDc0LaprmUoD1+YE85/enZko9oS
         H3W4ok+Ss/ZHlAgra6SdO5wzaobiXF3I9fcCguWiyEMM0iytD7qU6y1+5gCRInUso/hC
         zrtJL7Grlnl0SkPh8NZL8qK7lPz07X4MEIshWbX/jVTMxBDChSbI4V6q2yirSkQWOqKq
         9xh1yS3d5g4x7kZFloL7Ppn3qBUmKI7EQpPeekdOkeeagb6AeHkh1bKV07wT/IA3E/IJ
         PmprlkNriveJ1gk3XcP+BzA674Ry8v9IUx9aNilDYtPyGuWSGBBFYv5EVriuDBgvgKm5
         9/tQ==
X-Gm-Message-State: AFuF++lSrCxww1d8kv6ADMMZtNpKoedjcJ6ZdHxESZBeKajBgXRaYXLh
	iVrvgs58pPzUX5JoLcHLQv/ED6G3BEVK3LtVU5Epwzngu+/mNIkytTAec3vxBvHYwci8VhSa7Gi
	5BDpk+vX3ekF+WT6Kzz7H/9ts+erR0wPl+MsBqho5PHOpKMwrvRLVdf3jPrCjs3TBEtOy
X-Gm-Gg: AYBFou1Wt+ZdLAqZUKLLQv2s25VEBzbt7e6a+I/uyi0UNBCkOuVmYyLv0m3UL7nSgIm
	SX/zZCePiW3PWMXypwXuBXl0A5Oh8ZjhrTSVMKWIMbYBj2Q0L9pOgphtVn5MeDMJ26t5OZdQT9q
	22+3h2EdTt+aSwTAhslvJQRl9AsLxcsC4bRSaZtRJ3Rs54M3CwSRWZrk1R408U/5s2M/JICONDb
	lzV68l5lyqJmJ5avTbMagu0NImS39gGJx6otosLVlT+lSaFDh1ySKIMIz+pNzJsXxZ5QrNjFL06
	/1yDBSLOW0m+MBHeAmRHDXV11Bdu17jDqlwy9fdprLpAqqOXuLqRQ9//RxfUpSOnhhAIcNY4zP7
	U8J+TBUbdlIniBDs/gPFuGA==
X-Received: by 2002:a05:620a:4592:b0:939:e9a3:3105 with SMTP id af79cd13be357-93bf58b5b11mr930986785a.6.1789983385860;
        Mon, 21 Sep 2026 02:36:25 -0700 (PDT)
X-Received: by 2002:a05:620a:4592:b0:939:e9a3:3105 with SMTP id af79cd13be357-93bf58b5b11mr930985185a.6.1789983385494;
        Mon, 21 Sep 2026 02:36:25 -0700 (PDT)
Received: from [192.168.202.12] ([178.235.128.140])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aa67c71c59sm3980947a12.1.2026.09.21.02.36.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 02:36:24 -0700 (PDT)
Message-ID: <848e13a2-e80c-42cf-845c-0c04a4547975@oss.qualcomm.com>
Date: Mon, 21 Sep 2026 11:36:22 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0766/1376] arm64: dts: qcom: sc8180x: Fix the PCIe
 iommu-map entries
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
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <daily-reply-20260916-0006-re-qcom-pcie-iommu-map@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDEzNiBTYWx0ZWRfX3QRlyFF4i5t4
 MVo9fxLLo61sOfKw9MyDzmyet3ayZhZ3OVRrrvJ/Vbx+pzu2qcNAZDc+s+ZOs/tkJYg4nyjEvW3
 HvMj22ONpv0mpSRVVNURlP8DemfGYllFNTVHOTBHwxQHA52sRJcvFR7Mwx7QYqCAJ3uhFe+owQn
 WfodfjAsTqmxxMM0rrKppg+hJ+dy1b8a4hw9F610Q0cJFhwBbO1JaPzgmWZsApIVEwu79VzHUUq
 nIfQso6DN/EiajGQsgUBnuCl+RiwlG4h9T82naNc6CSxfBJShqinipa/DVZjKgZCwarb49qx2E+
 UEStG/iSBYrtiq0oUwYWSdi5vd0UF+7as9BZQ+PTBb/UcPJUDitckM3v2EGDVCzpRgBMFmmli64
 TouaWvHlM+6ErG5yOFZ9XrBXbL/1VdWP9fPCcQMOoSnCgooW5d55/LjinENIxfd2EHEmmkCb5Qa
 bAeTOoaa2k9agg02ivA==
X-Proofpoint-GUID: oR6Ww-DBtM7_TZ3rLsR9R6OG8jqP3La1
X-Authority-Analysis: v=2.4 cv=T/8Z3PKQ c=1 sm=1 tr=0 ts=6ab0fa9a cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=PRfkaYvzSr8QmIIGAkY2Sg==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=rJkE3RaqiGZ5pbrm-msn:22
 a=FNc6Hk1cw1V3EZpLb8AA:9 a=QEXdDO2ut3YA:10 a=PEH46H7Ffwr30OY-TuGO:22
X-Proofpoint-ORIG-GUID: oR6Ww-DBtM7_TZ3rLsR9R6OG8jqP3La1
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDEzNiBTYWx0ZWRfX2iEJNqUtlvK3
 SCloTn0CoQGffY1MBx8jms2IHQo85avtsMR27oQ+N7sTFOrRRbSbZ8NfuUaAF17OK7nSzY7+euR
 pprUswnwiz51FIko2Tc7qFIzH+bOi+c=
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 priorityscore=1501 phishscore=0 spamscore=0 adultscore=0
 clxscore=1015 malwarescore=0 lowpriorityscore=0 suspectscore=0
 impostorscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2609040000
 definitions=main-2609210136

On 9/16/26 9:27 PM, Sasha Levin wrote:
>> Upstream has the variable-cell parser and its API preparation series,
>> including ccb2fd725d411265df8f7ce12a66c226b16014e6. That broad series is
>> absent here.
> 
> Agreed, and Konrad asked for the whole family to come out of every tree that
> lacks ccb2fd725d41 ("of: Respect #{iommu,msi}-cells in maps").
> 
> Reverted across 6.18, 6.12, 6.6 and 6.1, 35 commits in total. 7.2 has the
> parser, so it keeps them. The msi-map siblings stay as they are.

I think the updated msi-maps parsing would be broken without that
commit too, no?

Konrad
