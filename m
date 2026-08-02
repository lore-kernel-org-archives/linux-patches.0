Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00C227AC4D
	for <patches@lists.linux.dev>; Sun,  2 Aug 2026 06:10:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785651010; cv=none; b=CEcwE6T7THPsl3+4giMtCMRTUtKiBKimsucazheYQkq+VtGV6d/C5crZPlRTsCtuF22GaOmB9vLbqMqpyLbS+unpDZo9CL4iw1Y+6PjGfUM9qLXGkCAE4a1RFA+N3XEx7eLVhb6GTYIwbvhFMZVAmHLlpsczjrKBQYD+C22v0Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785651010; c=relaxed/simple;
	bh=QfJv91um63bPb9ScvxSk86fXm7iANE/MFGInCWz+ucw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FGt/XJVpbyj20VXm6Q7nlj+niXe/ccvgMtkcdzz5hDKaqS90F/eYbCkrL83tFRoqMWWqskb4Vlj6ZWCAIw5I7eCUQ3pNtuJVOukoOI+WEj+ZqJ2qo5JQ/dpkC9kLP2+OqyR9FA9p+R5HbmeNzZvpym9RKBcJW/CAKXOIUFM2Cv8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=ZEAzJidk; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=IGU8/el/; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="ZEAzJidk";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="IGU8/el/"
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6724agpm1883169
	for <patches@lists.linux.dev>; Sun, 2 Aug 2026 06:10:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	XtCJpW6WeDvF8fWWNtxaWZcE4QHG/drgeJPi98d2dgY=; b=ZEAzJidkEGp83wJu
	G9lcBbIotSWD5QusIMVztxcDIaZVhVQOomPv2Rg0tk6ohk0rNXhKDQjR5Ptc/QRU
	CwAj4wtg5ocPRx4GG0fUVkcHGEJq1suBi/nrz1tfgIz8Sw4BERuSYLckynbASrCv
	5GcfaVwvbztBL5fOM8dIOzaXLoVQeBtTqgtwS1BZifFYx74HHyjofmnKdvyKmqqm
	eq8Ag9s2+Tjsn6hFhC/laaR17qDVL2bmkNTkCiQ37LDJXxMkf4sUAsjlzVmHcBsY
	ANl4eqbcA0jYLF5IIFXnG3fBh0mzzdr/fi8rXcLgvkf0KCGyQJU28HVYIslvZLQF
	zqgG4g==
Received: from mail-pj1-f70.google.com (mail-pj1-f70.google.com [209.85.216.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fs8pg2af1-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Sun, 02 Aug 2026 06:10:08 +0000 (GMT)
Received: by mail-pj1-f70.google.com with SMTP id 98e67ed59e1d1-38f5ac7354dso4235426a91.1
        for <patches@lists.linux.dev>; Sat, 01 Aug 2026 23:10:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1785651007; x=1786255807; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=XtCJpW6WeDvF8fWWNtxaWZcE4QHG/drgeJPi98d2dgY=;
        b=IGU8/el/hZlSmaIh+LVs7aJBMlSsJgOWaO64Br93TOQ5zCpdY4S4+xgMqWT/2ym8SM
         pDwMWElYGLZCp9Tq78Wgm46nRdhQCgsUxwGNpAL4Ql4gb4XfS94anTe1O4FGCFUxUnyf
         9RCVz4telrTxKCUVJDXTzePAoz1F5q6CFG/kTfepj7Zp/hMXMZbtE2qwmngqgNiBEHM7
         vw7s3rxsHSyeO+lShO7rcjggyxhfPq6KpMM4wQuWzwQSZaBqdpY1hOHlCcC1Y+KIsYOD
         gmSotRVDCX30PEiWyvqkOifvmIPQKdt7ghwjZc6qxr92OwC0jhgPIlsgla3CqtYf6ZMI
         k75Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785651007; x=1786255807;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=XtCJpW6WeDvF8fWWNtxaWZcE4QHG/drgeJPi98d2dgY=;
        b=bmBYtB3EZ1gHqEUKU03nMNqDigJDAbcOI+GZHJ0N3oi7p+yZczfz4w8MGln9TTD25Z
         6sCyyXniCh7iaZt3YGJQi2NVhl8GASs9VIaCXBtBPzsNSoqOxMzweGXZAZOAkkJhhQ+x
         HiqBIwRAojezdN9YGmFTBw56TDidmQB8feO8c5gJxYPojb527Uj84BtEBQNiH+Ac2RHP
         N+qGqOh4uYxxfFZdGvXy/9eIOpr7wfeqKCp3ZAOYOzv5gx9ZxdKK2W9CzG5+QeS5+Y8I
         AieOBopDx7dQpldvi8bek4uEuTGbwO2yj7YTji9tRHFkLBY6makpbiL0xFrA5lFrsAKT
         nyCw==
X-Gm-Message-State: AOJu0Yz1fVw0shOdybCr9TeulwOFfx40rC4VoDzVHjgEJ2eHmptEc/hD
	ej11q1UpjEY3DTM2YSqwkkHXRw5AhOUKDRzkKAUM+Q1T9dNm3Z5QzXpbvnayYD5rDf6oy0DNKeJ
	/TPVK/dULijTQL1KA57mdrZcGJAxuQGWFMxlrEIYjRp7aV0Pcz6G7Vo7QlL9u
X-Gm-Gg: AR+sD124N+asNnqghleqMqgTak22tslimMBPoFiLRyoImX3rLQKYOSyKa2X0opyl1mS
	Nh1q6RXuf0d8V+cyt/rgOonmsxDTrhy2LCLM/YWqqUJCLyFSxNz196SGNAs/PwXlnO3Nre1UIYd
	PLX559HnuqNu9/UrPApaKDTq1MnSvn9Rqk1fWjsq5NUONL7D1hcx+D99WtTG7wj1R7SgUur/AnI
	dTStdvbIoXeHpGR+P8D3+R0uNv/s/zFesag9rYJI6Wl3oCwuF61u5pr6Q8ChYQj9L7U4eYsmOkS
	4L89N01sWhmiLDIa3vXbk8mPW48NQzMiOgSKamhraXyc1mOwJl19NZqJbWkeLwhJfLhFYUiHJYZ
	i0AneVeG5x1og2Zr9fE6u36MrB1c=
X-Received: by 2002:a17:90b:3912:b0:38e:bbf1:de3f with SMTP id 98e67ed59e1d1-38fbc430fd5mr5724482a91.12.1785651007374;
        Sat, 01 Aug 2026 23:10:07 -0700 (PDT)
X-Received: by 2002:a17:90b:3912:b0:38e:bbf1:de3f with SMTP id 98e67ed59e1d1-38fbc430fd5mr5724448a91.12.1785651006806;
        Sat, 01 Aug 2026 23:10:06 -0700 (PDT)
Received: from [192.168.1.6] ([182.77.67.166])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153ddda5d9sm28617963eec.13.2026.08.01.23.10.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Aug 2026 23:10:06 -0700 (PDT)
Message-ID: <1c1c926d-e0a9-40f7-963b-94677d29ebb3@oss.qualcomm.com>
Date: Sun, 2 Aug 2026 11:40:00 +0530
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0139/1276] arm64: dts: qcom: sc7180: Add power-domain
 and iface clk for ice node
To: Sasha Levin <sashal@kernel.org>,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc: patches@lists.linux.dev, Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
        Kuldeep Singh <kuldeep.singh@oss.qualcomm.com>,
        Bjorn Andersson <andersson@kernel.org>, vegard.nossum@oracle.com,
        Krzysztof Kozlowski <krzk+dt@kernel.org>
References: <20260721152446.065700225@linuxfoundation.org>
 <20260721152449.211750681@linuxfoundation.org>
 <a0273f34-8596-4b6c-a489-66a4533b6dd1@oracle.com>
 <ab3c3006-bfa0-417b-86f7-95470c73e547@oss.qualcomm.com>
 <20260801101505-6a6d5089afcf@kernel.org>
Content-Language: en-US
From: Harshal Dev <harshal.dev@oss.qualcomm.com>
Organization: Qualcomm
In-Reply-To: <20260801101505-6a6d5089afcf@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: v19tu5OJcZ04mHxlkv16qGArRR-P8Kw0
X-Proofpoint-ORIG-GUID: v19tu5OJcZ04mHxlkv16qGArRR-P8Kw0
X-Proofpoint-Spam-Info: AW1haW4tMjYwODAyMDA0NiBTYWx0ZWRfXz8YLI7lnVLvg
 iZ1wqToUPPojNIE+zsJHzpcbmIjoqrcPdElrRUn3hfCw3nXOqd5wZMd+61/yXXWEzmGsQbcRHxR
 GZ0pPQloI3ear1QDsmJsYJPN7+LuNu0=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODAyMDA0NiBTYWx0ZWRfX4RgrMRoFLuJ2
 L10MM/n1olsXaih/BCgm0Q6Gg///dTG1XKdg4T5jR+aYAlUrHH2/Zr9m9Szu/xD4l1VPWlpBpct
 4mRf1kjmkrgdUiBCVpL1K8he1gI5hioN9DFM9ET/DxNgiuT6/WBS1dC6LIaux+gpYemzraE8XIj
 IHJ+/vhgTaMIbQJN7LdttpTy5JgvbTaLO8t92BC/kSpdatK6pvgRZ7A/OiKjiI6Rva0pg9NfMTb
 Yz+29M1qJg40eB56PC7BEJx8amGpiPsXp87jseYhrEGXCoZzqQT4uEVJNnA1DksSwTd481KsCLb
 vRAlaDDzHGL23uC4W1gfb8UHgD/FdFUoN154yUslVwzR16gog49M3UoQ0RR5fb6u+2I9F8vhZ6G
 g3yj1p9xrGyHSut/3KH+9ZHe0n7yOHR7BG5/DWfPlPtlUfdb6+SImPeGjZbxEusTLehzNTcw9qu
 DJ/1erjArBNtWkxE9Rg==
X-Authority-Analysis: v=2.4 cv=U4Oiy+ru c=1 sm=1 tr=0 ts=6a6edf40 cx=c_pps
 a=0uOsjrqzRL749jD1oC5vDA==:117 a=mrmDAJacfjHp5PIfN2e9YA==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=u7WPNUs3qKkmUXheDGA7:22 a=eoimf2acIAo5FJnRuUoq:22
 a=VwQbUJbxAAAA:8 a=sAzOfAp-q0GaX7_v92wA:9 a=QEXdDO2ut3YA:10
 a=mQ_c8vxmzFEMiUWkPHU9:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-02_02,2026-07-30_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 clxscore=1015 lowpriorityscore=0 spamscore=0 priorityscore=1501
 bulkscore=0 malwarescore=0 impostorscore=0 adultscore=0 suspectscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608020046

Hi Sasha, Harshit

On 01-08-2026 07:50 pm, Sasha Levin wrote:
> On Fri, Jul 31, 2026 at 12:51:25PM +0530, Harshal Dev wrote:
>> The 1st can be taken on-top of the four DTS, since describing the clocks
>> first but enabling them later via the commit is totally fine.
> 
> Thanks for confirming - and no worries about the delay, enjoy the
> vacation.
> 
> 0d5dc5818191 ("soc: qcom: ice: Allow explicit votes on 'iface' clock for ICE")
> stays queued for 6.12 on that basis. It closes the gap the four DTS commits
> already shipped in v6.12.97 opened up, and I confirmed it's harmless on the
> 6.12 nodes that were never converted (sm8550, sa8775p):
> devm_clk_get_optional_enabled(dev, "iface") just resolves to NULL there, same
> as mainline.
> 
>> The 2nd one should be taken to make the DTS patches comply with an updated
>> binding. [...] However, the patch must be adapted to 6.12 to not make the
>> power-domain and clock-names mandatory for Eliza and Milos since those
>> targets arrived in 7.1 kernel. Only the first portion of the patch is
>> applicable for 6.12.
> 
> Agreed, and that matches what I see: the allOf/if-then block in e27264daac7d
> keys on qcom,eliza-inline-crypto-engine and qcom,milos-inline-crypto-engine,
> and neither compatible exists in the 6.12 binding's enum, so it can't go in
> verbatim.
> 
> We don't hand-split upstream commits in the stable queue, though, so
> could you send the adapted version yourself once you're back? Please
> post it to stable@vger.kernel.org targeting both 6.12 and 6.18 - 6.18
> shipped the driver change already and has the same binding gap.

Sure, I will send an adapted version after validating the binding with it.
I will be back in office next week and will be able to provide the patch.

Regards,
Harshal

> 
> Thanks!
> 

