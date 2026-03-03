Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C214C37C92F
	for <patches@lists.linux.dev>; Tue,  3 Mar 2026 19:48:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772567303; cv=none; b=svjtiumHsQoX5ltj030aRN0N8w3JIQtJS0UaeAvW+qmCs4UjQoqsejXjnSdmNmze04vw4m27v1h/MY16FP7cnUKuu6pVqu59KB81Qhl2IYKBeyVaLUpW/Mve3uOIq5ekSJimdqhueOHVfGn2+E0g6rCc7YasW2yN1o+KVj8j83k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772567303; c=relaxed/simple;
	bh=+kS1tojwy5YTkToST9q4TaJiuiAS4cNfh2tQs+GWMjU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FkEYmUllf3or/jejlUaS8Jr23AkMTgGnphqV0HBQJbxgoGHF+AYLQgp3tfJb/UFKGe1oA4aeimzlYezBzsKPk4/sEjfB9en3890/LY9yXAoo0wfhdLQy9Fvoef7Ji6gdcY+T0E3h/NirWB+K8poPvXeDzAj4u9nSlvgk3eSiF5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g/qeoUOf; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g/qeoUOf"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7d4c4b494fcso3817274a34.3
        for <patches@lists.linux.dev>; Tue, 03 Mar 2026 11:48:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1772567301; x=1773172101; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=b07Vclzg3TIWwnrPPGwmBhx/Iqioy6Bog2ICdVToJUg=;
        b=g/qeoUOfhljZMxU0qDrrDA5eBTO3iI0P7yNakwE4XZDiHJSRE68Sb56KWUpwhv4xbF
         mmfqopL1Q96WiwLPhEKcvJ8KgcY18ZmxkdkpD+upz9NtdSRZ/90BRN45pVhwrGXZkphM
         ICIhdDi4a1RV3LvpwkFiwqBy8jhWtukp52j4U=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772567301; x=1773172101;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=b07Vclzg3TIWwnrPPGwmBhx/Iqioy6Bog2ICdVToJUg=;
        b=PJJoGMjKGaA7ynXQDUhjsQgpDCTAqlfKXFKXiZgypBeq1pjbeLy0VEK1X7RM6arsWR
         V0zmbVPLuWQ7sbL/m608OjE998oPDf5oGWM2gPY4kgSoxsaHtyzGjMtsExQopccgNyVW
         Za0ib4bzwmo5HhlrP8NS7aQs0/Nlw7mBhfEb6diVWKoIS2j8ngQT2j1QdAOSu174VbDP
         40OdAP1hvvC/ngNSy09DxEXb+YfyFXZKi3OWxN/OZ3ifJUbLdsSZMsgA1kME9Dkzg+mo
         WI1OFdvUhf98iqEAbB1Po58EN8cU56QYZkSQI1ezoEIX1MyWxhsu6GBZovdFSK23OUke
         Hozg==
X-Forwarded-Encrypted: i=1; AJvYcCVf/yjdML6Lfr2rDIQ4x4Qgn+pq37Sk6mx3NSWOzJf7fG7UywWiA2SeHjetWsWE0Zh3+x4/kgty@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+O77sCmDUGWLHSXJOVITXKbfLgn8t1HTffEaRD28Yv2bUKmTe
	rtVFakEZcDvMK/Alr4rpiOn9amWSTU5ntQQrXbKMtsvq/roqrvB1t8Zaj1TXw0p/NNE=
X-Gm-Gg: ATEYQzyp8OcJ61a0a6BIhVFGIPS6yp5uFDA7slKzadb90De6+CxFyrRTVQYmMKAPzrn
	gdFzCwelpivgrxjzey9vggk7/d+mNGCE7DLYHbUht8G/WQSlY9h3HRuCfRkZwJgNYzHZDZUW3Az
	BN7kyRYD11E8mA1+E3hChNJ7sA7tvFPUKIweXuyg7avxq/6lbHd5WTzhYS1RndA/hz9mkvxyUu2
	7iyjsKAflcQKv4lTe0Ug1iA2625M6X2hbw88rEoU72sgcRSIH7vWjgJHC9AJHVmo9ZTJSX4DK09
	aw4EZbZArPO6ztmzO9gYAzImpmrJnVP6GVP0mEx25vs5/aDM+w5QWE8qdUXT58jZrw9+vTwgwnW
	/t+JbvRyKu5HlblHf3tEai1xsJgtvMVEm/jaB+/RgF4E0X49CPdPClF7ragsf7WfMhuU/53y0y2
	2EGtWS96F8Q3o/RLa400ejxKjOqgfqrPocdK0=
X-Received: by 2002:a05:6830:3881:b0:7c9:5959:8de with SMTP id 46e09a7af769-7d591b21cf7mr12648060a34.9.1772567300764;
        Tue, 03 Mar 2026 11:48:20 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d586226d14sm13867933a34.0.2026.03.03.11.48.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 Mar 2026 11:48:20 -0800 (PST)
Message-ID: <a4b92e9a-d3a3-4e31-92da-248035b051eb@linuxfoundation.org>
Date: Tue, 3 Mar 2026 12:48:19 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/164] 5.15.202-rc1 review
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260228181458.1600528-1-sashal@kernel.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260228181458.1600528-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/28/26 11:14, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.15.202 release.
> There are 164 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon Mar  2 06:14:56 PM UTC 2026.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
>          https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/patch/?id=linux-5.15.y&id2=v5.15.201
> or in the git tree and branch at:
>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> Thanks,
> Sasha
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
