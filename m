Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C19A31C7013
	for <patches@lists.linux.dev>; Wed, 19 Feb 2025 09:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739958864; cv=none; b=PCaTuuTF0lzY8jI2syJEv0fZXq6gbMCPk0w5bjRy0Cak/991IMwPJOFZcSeAhwAvJymBI10xMFmRejlDaTua4lKCBGwr24i9OQW2F+MfKkqR71oLAygM85pf4o0Plg2pbD+1EBCzQhDu1DzsVWVRlRhwRnyBFdtvF8zrWM/beEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739958864; c=relaxed/simple;
	bh=FfvqskgKTPSFoGOkrm9Aj6YyyR2dEeyLXz1vwGuyTu8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XyE5I8Z3cQHR+uQSqJAmlMGVln8JcVOQe0oiq4+VLs86WbtIPOY47VAQaKo8DWzn6k0rhi71BBW4+37SV1NmYUzR6KaXGUzHgSKin4xBm68WXSl3z8Bs50GTDcJMxa6Srgdyf0jw0X4/ZNXXQkPr/6G+spJJ6bvD3Pkwesfn7no=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gfMoe0R6; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gfMoe0R6"
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-abb90f68f8cso627930166b.3
        for <patches@lists.linux.dev>; Wed, 19 Feb 2025 01:54:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1739958861; x=1740563661; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UzWk2OL1SOHfTidLq0uZH1erG+Z4ao2Q35XKqTe/yeQ=;
        b=gfMoe0R6Vpq3xNfhm/OXD7bsxtxdNng+sEAmkzQycij+vHs06rYIt21Q5j3ZDoXLgB
         D9d75PgIhYhQyn90mmarfX4JqpSF6OwzKDAAvghydt1PaIOYTGPpwaXcxQOyvT7EgRUG
         BoW4AYfjQdyjUqrXcp1afWJdnLj9tX63aKKkseZHMg4px8MYRSngrCrLNTQ2jZ1Rz6Ix
         0ijrQlPGGvGgQbkdOP747/8k2Cq3kO0ktXwDn6G7gyTJwdpThVK/7C9FWfaShPhdR55o
         RoID8aqpXpmRhwf6C2bYvwj4LWAPonZ/qcM1f9edwaeCjGyZ4uMvES2KuQryOkD2CfXT
         a37g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739958861; x=1740563661;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UzWk2OL1SOHfTidLq0uZH1erG+Z4ao2Q35XKqTe/yeQ=;
        b=ujOw+l3I5FCEs8kudQSdSDNEnGsE9kY/mTeg26QW5V4pLObYj0mQZpMAqEMM026Dja
         E/WGFvioAeT8wf/Z2+7WhFhRzueObXMYym+x23/jtGUBDHClIMNWVg1mcQEq3s5+xrW+
         myQ+rNk3e991tbS4+Q/iYThUL/K7wy7oH+epsIshVGl7GF7sWrQdZNowuPsTVru19kPZ
         +wmoN8sfSp1fvS2g+0l/LM1Q0MqBoBNKij113JX3aI1F9Z6x1XHrul3zOCG2Gm+bbZ1c
         fo1UCyLEGgyHVEccv5POx5kN52RhnNvW1WHBSGK1QPN+/1i4JO3lp/H4vZl2AqHpamXO
         Fgdg==
X-Forwarded-Encrypted: i=1; AJvYcCWDnzyxMQBdGaDt3pLLI0qxeuex1co//IEovJ24CMnuUUEe3pzCRdg/rS5Bxa8lBTRpmByoCtJQ@lists.linux.dev
X-Gm-Message-State: AOJu0YzHGoeH2Nrn9rSXywQnKPLIK1LfVHSVBqSNdSmFEj105Hj2ffwI
	h/9tX3SH3i/AHceSfBBpP8tmlISKHE/YeCciWsf0mBsgZUNaQTVR
X-Gm-Gg: ASbGncvVx1TGdLlIhdM3QC3FS09M5saB0hD+n2CW+6sqciWBCe1b0aLMxvj+NqtcU9y
	fHEc1Fnpde1Yr5YDGIhYIxDaY2+TN20mTjc/yu2lMQ34DRKMTztuLQ1VEXTaQ9Xs0dtbil+yNcN
	1erDe8JL/SDFrpDtez3foDsBcfOeecv1XIj4JmoLyHa+2SK3Ym7ce7wke45Qph9qH6VH6SVIKuC
	gSkkQYxOZpdja+mU1gY4gsy6++OOfq4jpKq9dTmBkcmjdM6iRZMMytxf2DdU/fvBHvZ5ZBCDRRE
	hVDxnvJWi8kjI0S93qyhyVXhm5PVGU4o4wkx9ISuaStVszRI+Tji49SERg==
X-Google-Smtp-Source: AGHT+IFUXdifchAYRC2XVoOKv+l1G2LwyFmvENSZSxzDWHXbNHiK06f8CYAM43WM0AmfoIIoJt2Nzg==
X-Received: by 2002:a17:906:395b:b0:abb:b12b:e103 with SMTP id a640c23a62f3a-abbb12be1fbmr762017166b.34.1739958860993;
        Wed, 19 Feb 2025 01:54:20 -0800 (PST)
Received: from [192.168.0.9] (pc-201-96-67-156-static.strong-pc.com. [156.67.96.201])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-aba5337673dsm1226050966b.89.2025.02.19.01.54.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2025 01:54:20 -0800 (PST)
Message-ID: <7083ab36-715e-47b8-be46-591b5fedf8a7@gmail.com>
Date: Wed, 19 Feb 2025 10:54:19 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 116/274] drm/amdgpu/gfx9: manually control gfxoff for
 CS on RV
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Lijo Lazar <lijo.lazar@amd.com>,
 Sergey Kovalenko <seryoga.engineering@gmail.com>,
 Alex Deucher <alexander.deucher@amd.com>
References: <20250219082609.533585153@linuxfoundation.org>
 <20250219082614.161530240@linuxfoundation.org>
 <96738386-9155-4eea-b91d-8590ef3b4562@gmail.com>
 <2025021944-imaginary-demote-31d1@gregkh>
Content-Language: en-US, pl-PL
From: =?UTF-8?B?QsWCYcW8ZWogU3pjenlnaWXFgg==?= <mumei6102@gmail.com>
In-Reply-To: <2025021944-imaginary-demote-31d1@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

It builds because in 6.13 and older this function has 'void *' argument 
which is casted to 'amdgpu_device *'.

On 2/19/25 10:08, Greg Kroah-Hartman wrote:
> On Wed, Feb 19, 2025 at 09:59:05AM +0100, Błażej Szczygieł wrote:
>> This patch has to be changed for 6.13 - "gfx_v9_0_set_powergating_state" has
>> 'amdgpu_device' argument instead of 'amdgpu_ip_block' argument there.
> 
> Why does it build then?
> 
> Anyway, can you send a working version?  I'll go drop this from the
> queues for now.
> 
> thanks,
> 
> greg k-h

