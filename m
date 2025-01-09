Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C7321B1AA
	for <patches@lists.linux.dev>; Thu,  9 Jan 2025 14:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736431841; cv=none; b=hKfD3NQHbV/nCkcSsr+28bf68aGzcvMi54u+YjU1gaRhu/zpa2vBoRkkDuTgLOY1K2FwGH1TMn+MpxCm93dgwlK57QqCZGr2Ag5lnRoZ6rsQ1bbqlnvXCREk+SZIqNuqn4HOkVZTmfA8LIgcbHWWPaOUpBPEcVVAFuxossSFdlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736431841; c=relaxed/simple;
	bh=tL4x+yYbNB+p3FgA43CyqfoD9sA+muhBq8RhGGyWNlA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=k2g7ohMjHiLgdfEawbx1L/UIW3at8jQdKefCnYIAveDRZ+CMvFQM/WPCUKnWvaMS9hGrkO8GOZn6QMAPo5EHyHkh3Z7V3pbySyzoBnX/WlHiZRsUq2rsP8qscVw6RcFxI+iMvc1oiD9U/k+mKP3Vg4jOYoItCYtThJijXen2zwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=lIiF7u1V; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="lIiF7u1V"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5097GkqV019105
	for <patches@lists.linux.dev>; Thu, 9 Jan 2025 14:10:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7vGWjZNCdFvL36McoU0W2QcK/hOkA5Ais5061RagWtE=; b=lIiF7u1V2FSvKkU0
	3fd8ghf3u1EJtjHeJN5QJQ6OPnuWPOcSj8Hc4ndmLwqUDKVoeweHUG1PmfiELfzE
	ahZZhoHXyb55xWqpKxdAvd479kT/eCs4NwsEMv2Nkc6WEqoX9OM5kxsibcIncOlt
	PRsAcXk5ps2wSjxGC9n0R1x0j44pLLS/wfLnqnNTT0s6ewjy/zxW84xNjun5HyB+
	Q+ryNu7Qfh9twdHKrFUA7exP8T8r/tKQbON0V2uiD30KATiX8mdvcc8M5IfEuae+
	T/HHhHMtqGkI2eXTBLy0i0G2DsiXTUPmOkBlF/SGxSXxe3wpI8nCwIc66KVUZeYQ
	0+8OHw==
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com [209.85.219.70])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4429x50y7u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <patches@lists.linux.dev>; Thu, 09 Jan 2025 14:10:38 +0000 (GMT)
Received: by mail-qv1-f70.google.com with SMTP id 6a1803df08f44-6d8f77bf546so2726356d6.0
        for <patches@lists.linux.dev>; Thu, 09 Jan 2025 06:10:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736431837; x=1737036637;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7vGWjZNCdFvL36McoU0W2QcK/hOkA5Ais5061RagWtE=;
        b=lw6MEjxzpVq/36NFpLacqtJpoWD02nYURF987H31W7x2TGko4cJe++my5KHBTG+hlg
         Uog4VrPho5HfjbhfVeTTTgMjlQbkG4QokpxvzPyxDEgUqeS14wFxED8akSgk1h8aTm7W
         zKelClszB9tR2KyYhU9/BKZUpTBIjAasvv6wP4S8mwPn5JUDaR8q6NsjRaPhD2XtmrYZ
         Jt5xOvUc0JEuINSMqgDY3fEIofht5lxVHtwwGf0ImmYRKG/gTrsBTeVgynMgZLBHMhZ1
         N3YwQ816xVTJANNcDu5Nclgpe3p1lN3EwnHRLjGuRHtrGDnaPXnpnB4NLuEzqRbvLj+H
         qXEg==
X-Forwarded-Encrypted: i=1; AJvYcCVtt+wB3BE3VIlBxjNNrzneg0NPl563yUm5LPEkGXxW1PDPJbcCAPcT/y1rdbCIt/ExKmSCJa3s@lists.linux.dev
X-Gm-Message-State: AOJu0YwPpWSzbmAl2Wq53OJxK+/gOtS1PrjZGM2Ivoiyvo1XJ5m1K6lY
	MkjUyUsSVYJJ3uX7PHjMshAkwibFum2CD/DZxHe/TdfoeJtp4RGWLshlyqAS4NAMpSjMF2ziDmm
	gxKhbYMAePQLrDX3PKn/RJLXvBwvCmW2+73yfTdjIaznA6AuOMrl3yr4k
X-Gm-Gg: ASbGncvU/C3e5wa1Qax/prFslaz/TzjDZWX7JHtnT+thfmFrNOf/118MEcHCf6VeicW
	MRj0lvxai/5xr/iOgUwmtb/uPfu8Jn0g/8F8iVonLnq//a578/bRRNB/Q9QL8kv9Vi7o3Qzth80
	6NGm7LZuyGC8xj9zCdKhmgxIwQ10qJibGJCcYBwfb51Kx1fHQk3oxyAb8ItgMq5ifgdAy2CkzaV
	AjK4FYrR81qrUrUrjQqOVQHumVsl9ns0mw9JKDXjlVeGTYskSNDAttVGEDtMf45dEVtG0TfCJo0
	jv8ZnwGGECb88ykJ1d1JJVml920o+jSIeaY=
X-Received: by 2002:ac8:5a41:0:b0:461:6599:b9a with SMTP id d75a77b69052e-46c710f2d4bmr38848601cf.11.1736431836781;
        Thu, 09 Jan 2025 06:10:36 -0800 (PST)
X-Google-Smtp-Source: AGHT+IEFtSSjy/k+utoRRUalpZi8LGiYgqSWxQBdYI15No64ZwJPcp37eUotTcMZvjExAoP66Eh9XQ==
X-Received: by 2002:ac8:5a41:0:b0:461:6599:b9a with SMTP id d75a77b69052e-46c710f2d4bmr38848421cf.11.1736431836376;
        Thu, 09 Jan 2025 06:10:36 -0800 (PST)
Received: from [192.168.65.90] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ab2c9564873sm75035466b.111.2025.01.09.06.10.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jan 2025 06:10:35 -0800 (PST)
Message-ID: <0ab00013-0265-4336-bc30-f49492e96424@oss.qualcomm.com>
Date: Thu, 9 Jan 2025 15:10:33 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 6/6] arm64: dts: qcom: sc7180: Add SoC specific
 compatible to soc node
To: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>
Cc: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>, linux-kernel@vger.kernel.org,
        patches@lists.linux.dev, devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh@kernel.org>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Arnd Bergmann <arnd@arndb.de>,
        Conor Dooley <conor+dt@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>
References: <20250108012846.3275443-1-swboyd@chromium.org>
 <20250108012846.3275443-7-swboyd@chromium.org>
 <n3fn5mnrrinrgrvadqgymv3cx355qpx5kk27nlrz2emoxfmjyt@ymwpfxf7lv4r>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <n3fn5mnrrinrgrvadqgymv3cx355qpx5kk27nlrz2emoxfmjyt@ymwpfxf7lv4r>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: ouNNbRNKWBUEBiUGqEMt6n5it-qW-2PP
X-Proofpoint-ORIG-GUID: ouNNbRNKWBUEBiUGqEMt6n5it-qW-2PP
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-06_09,2024-09-06_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 phishscore=0 impostorscore=0
 bulkscore=0 mlxlogscore=999 clxscore=1015 priorityscore=1501
 lowpriorityscore=0 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.19.0-2411120000 definitions=main-2501090113

On 8.01.2025 2:02 PM, Dmitry Baryshkov wrote:
> On Tue, Jan 07, 2025 at 05:28:43PM -0800, Stephen Boyd wrote:
>> Allow an SoC driver to probe for these devices. Add the SoC specific
>> compatible to the soc node. Leave the original simple-bus compatible in
>> place so that everything keeps working.
>>
>> Cc: Rob Herring <robh@kernel.org>
>> Cc: Bjorn Andersson <andersson@kernel.org>
>> Cc: Konrad Dybcio <konradybcio@kernel.org>
>> Cc: <linux-arm-msm@vger.kernel.org>
>> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
>> ---
>>  arch/arm64/boot/dts/qcom/sc7180.dtsi | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
>> index 76fe314d2ad5..257890a193e6 100644
>> --- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
>> +++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
>> @@ -782,7 +782,7 @@ soc: soc@0 {
>>  		#size-cells = <2>;
>>  		ranges = <0 0 0 0 0x10 0>;
>>  		dma-ranges = <0 0 0 0 0x10 0>;
>> -		compatible = "simple-bus";
>> +		compatible = "qcom,soc-sc7180", "simple-bus";
> 
> If the new driver requires this compatible, it will break compatibility
> with older DT files (and it should be avoided).

IIUC the intent here is to provide backwards compatibility through checking
for sth like IS_SOCPM_MANAGED(), sorta like HAS_ACPI_COMPANION(). In that
case, power sequencing would be done by the socpm driver, whereas if it
doesn't hold, the resources would be toggled by the device driver

Konrad
