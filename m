Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050150;
	b=jfNbOWiefPB3UbtEGYjybZ/SpKjpEGEinWRjz+2s4e9jrSRYoB/BWXetV2VkWA3z5uuc
	 Y3zTJb29faLXXJCOGbzdc+4I2YpvyxL38qp9U6aYB5IceJLzASeuCxo1CFZR/+fDlwka1
	 ia+Ol7xV9aN3mmE52pwIc7HjkiatadgP4Wa1hhzAD4zIodh3W2YlKjdeealn33wbmYiZK
	 y3uNja/XvY+3kTFm5+SS2OIBGMKWdOrWbPfI1IPbEin5hYWD0ebV/T5wm3QzAhgWZhYlO
	 oUiqn2qVy48O6JBScg6w331UjPgRzipyG5/PZT8nt9vgSWfvVONTkUvF5eQqOzcaPKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050150;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=0C8lnJ2RZbzuiNletdGOfX0PhTEr69qDL1g+/y+UTJw=;
	b=ofD6Hxbe04802Eadi1qGpLwXZMSEPmk2tv5JZxYmALy4PG86Om6PHsvtBlzrNEvg7q/a
	 aN2gpDgpGVg0P66qA3+5uFwSAnhFXdbmkVWxA1lhwBJB1Bwpv9Dd91iA2SlObnJvAGwz4
	 XDXHUZTMVt5YmRqfVQSWmzeLCada8iu8owFO373MhjVX3by74014SFhTAFeXvGY7JPHJc
	 aIGsWEzXDGzO3MpDd7UT9wu8qaCvhRKuMy25RgZZ1B5nvhDjZZPB9Am6O0h4RbHfeusSi
	 LrS4Wa86y6cd4AZp8W9n1d5J8/gZuwFU567nYkjM+h5feGPG9As2QwID/yhy2CiU5Gg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=C1O1vl2l;
	arc=none smtp.remote-ip=209.85.160.54
Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A667606A32C
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 01:02:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8A667606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=C1O1vl2l
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-4ad4072943dso648984fac.3
        for <patches@lists.linux.dev>; Wed, 18 Nov 2026 17:02:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1795050147; x=1795654947; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0C8lnJ2RZbzuiNletdGOfX0PhTEr69qDL1g+/y+UTJw=;
        b=C1O1vl2lW6RIIWIGgkhKT+k8MYeoClyRtwTWhSJKIm03KhVWwjK99U0q3CcYhbDdJ2
         HdPYa/hRWvABz7hOhf7F1aBwuyBroaUbU6iV4qcPA+kE4N7z3OvscpuAQAuLomA6LquZ
         +/DVuM9m6WScGK03qizkXX4EJyfEx7GsusXPc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795050147; x=1795654947;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0C8lnJ2RZbzuiNletdGOfX0PhTEr69qDL1g+/y+UTJw=;
        b=He/zwnZVbr1GeN3IhKgBVP8tEo25eZRxwL1Ou1x74EDD44ZpvRhV8fsaiOL0b3yvr0
         cW7Vj7wMw5dXMnw5Tr/sHqKEzlwFr7Gxvo2MS8PHEZN/JJnPaNkoX45sW7lJE3qC7NLx
         FFyg8BYP1cmfZvtQoepvgwFuT5YCRyGyGYRzy4cMoO8wcEMTM9w/a8debrA1kDD+Veb8
         IPmKScU9Z+cuzFLTvml1ZMU6OKFKJYLubg/Q0A7DH/hSJvDX5aUc6Xk7+sztG02AjGbw
         AE8pgdrWeDQNLyyTKLbKoomkScdinoOkxaey9eKsq+b4UX4o6mFsdN1GDYO0ZRBHn3Bf
         7LZQ==
X-Gm-Message-State: APuU4Z/aV/+Ky6Aj3p80jbfDVbzgJvoETmfIMc8tU4f2ZW4dj52JgWpR
	IYU+uefClJ8KISMhUIQ8LeuhaPds9GGkioezTpZIN3DSuE4Zg4P36zlw6h9q3GA/rJU=
X-Gm-Gg: AYBFou23rZ3vpwV9wl04FiN/3W/LYYN9qvbcUkHa+IJikJdwWK5qYB93rMop9bxfUvm
	pZ/yjzUEh9a9TxoPEvcFthNzRIaRGZgSPIZzCv1RUgp+JioWShhFlEGlaoBgqHjla2/N/JZl0QV
	Af2GbNGCiD2bYiZO7oez5THMG7sH3uusmPRxAWOkA2pioZALN/CEM8D+07NvKTmsA830JtWwMNZ
	xBVEBC2M2ZgsZRmpSH/3L26cPFOJaYnXP2RVEgTDo6EiaGeb0m6c6jnc9Ia5WUaGzxqQLgQDF89
	8H/21UBA1i3IbXK6azm4oqii6a+roEQRj0kFjxgJ4zac0AyCMOiY4B2vOfA9eADpRQOPOWkMUKd
	c9ZMBgiJW3c7fWNpp1O+uDYJ/wfvGOmFPMBoI/fwEVcm3YeNdtmaPXFSEY4K14RJz1TFlG5WrqB
	8DDYYHH47HX1Jhs+5IWFOBdPQx/Bj5COZWDQc/ujlQsXqfs5RogsQvC+m5s3ez7S6HzkOg2HbCg
	r+1QgJnSwzz/3xNlkYaYX3auz18iEAfX5a15unzyWSxHJnuF0sKTe9Ka0RYcZSSINnT3HW0Ps+X
	16phG237fBqcN81w/oEThl1Qz77zsy+G+sTLXyc=
X-Received: by 2002:a05:6808:4fc9:b0:567:cac4:f1c3 with SMTP id 5614622812f47-5773c12b74cmr6176202b6e.23.1795050147505;
        Wed, 18 Nov 2026 17:02:27 -0800 (PST)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-5777a8a5b72sm2705076b6e.7.2026.11.18.17.02.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 17:02:26 -0800 (PST)
Message-ID: <2cc4e958-33bc-45f7-bbd9-c6763fa3a8d0@linuxfoundation.org>
Date: Wed, 18 Nov 2026 18:02:21 -0700
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 0000/1848] 5.10.275-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 11/18/26 07:33, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.275 release.
> There are 1848 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Nov 2026 14:55:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.275-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
Build failed on my system.


net/core/filter.c: In function ‘bpf_update_srh_state’:
net/core/filter.c:5867:26: error: implicit declaration of function ‘seg6_get_srh
’ [-Werror=implicit-function-declaration]
  5867 |         srh_state->srh = seg6_get_srh(skb, 0);
       |                          ^~~~~~~~~~~~

I haven't isolated the commit yet.

thanks,
-- Shuah
