Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795103015;
	b=nrm0LxOopFrbXNgdN/3jww3G8e94eWjd5x9CI0w09o5ox5Ns4eMLjekGpwfvPJcfmHgb
	 4Ca00AoCwj0xqY1q9voNb5/+VpegMpUTwrNgQnahLyEzGTnK+HqI8PNLi+ZjIj9ZgBGea
	 7tK4UrIoBRnx+KFDc+sDbJJkJszMjAQC3Zk2ZqhwKEHQahzl3RDu+iYYXdS1W0YyJLkSN
	 4K8SP/pM04mcEaHcO6eoInIwdhXXAJ3OYasAa2MwEWxWQphnutgIPviqYJU5eIiTZTzgb
	 vXgIeb/gkbDFetzc/A9siqzwBHggbsAh9xleWoJlLmC/EDT0AbFRbUPW2WCOvywER9g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795103015;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=77kGzCaY5Zn+zy17jl8aBPxR11Z8jaWMp533IDrucQU=;
	b=M51bhL/poJuzJyMLSY7lu0cS8QJ3Z86ntSvNnZ9HgFCrnzojI3O/cALaWMq0MQtyZ8dh
	 51+unterC3PncCdncoXNhglMLAB61Ph1YvCdubWSfHzP0w7c70gTRmrFv5X+Cy0/y3BOA
	 rnLQBvcPsS6ublzBycU+kOukRvRvzV224e2djI1HAr+N/xzTcENX7qc0ex/dpHq1e/Owu
	 N74hceDZgOobSjhFVJOntJkVfz3DpRY3OWLg6XfA6zTgdinHXlFBwqo6IYZ5TFwBpwjZY
	 FVqGSq9yQ6boGGUDXp8vqbm1A4PmAQX5ehEPCukaHkMZ4f33F0umNbpAXn9VbJbRsmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=eEtjUUSP;
	arc=none smtp.remote-ip=209.85.210.48
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E45CB606A32A
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 15:43:33 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E45CB606A32A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=eEtjUUSP
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-8629fc8ad64so1342446a34.1
        for <patches@lists.linux.dev>; Thu, 19 Nov 2026 07:43:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1795103013; x=1795707813; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=77kGzCaY5Zn+zy17jl8aBPxR11Z8jaWMp533IDrucQU=;
        b=eEtjUUSP9KmiSm9xy5ldi9EIiOfFUcduDBGYLndNC7HQrhqJm95CWO2cusBa60o2IG
         uqFFMw1gUPIzV0HXQ/I5aoSDKg/8MUjczn7VhIxbo/y0O3P2GPPxeR/Xv4xlq++rzgqf
         6wRX4hZXqj5xhtYgo4XLwyqvHEOOpAz2BzmfE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795103013; x=1795707813;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=77kGzCaY5Zn+zy17jl8aBPxR11Z8jaWMp533IDrucQU=;
        b=OvidAu6eobOhDEnfCk0vB8e4xQzkPd/yH0JG3c1M1m6W9iwqe2QJ8sW+u0k9ykslPt
         fWjE3KmCmYllA29yCRY7CgHdlalqDtU3kmz8MZntlisYRjG4fGvm4FKpYbTaTSHEDDHu
         ERbyCveI5FiiDHjIXCYF6vNBngYsCzjQZJG9Vr3Nl58+Y76UDwzVKYWJMlzyzlB9iSV8
         sn4NUuTTap8KzFshEGyYARiTc7pIO4MsYfYjAS05ejyM1fjmKVgeu08rsBb04H5FD1Dl
         hngHapJvLmOzRNIIVPJXTlerwJDkf34L+YfaIr5oM/hbSxTLzmos3tdWogvKsTVpxfx0
         JeTQ==
X-Gm-Message-State: APuU4Z/p5p21v2yXeFl/5wRGYRcvPriq+obOX8YWULnnTFsl8NI8wcUu
	RiSjusxJpUtY1enFz9m6futSoHcyM8F4ErRCc0fdUFGIr/ubP53WtAIM6NvKCjuEBjE=
X-Gm-Gg: AYBFou31esXdJsqpskQj2V4FLlT4fMPHp3v5UUCv18bmlHPBCo14T6PETY/pt4e6QSi
	28SGctfL/rFu79TiVpsBJv418I87DqqIeoD0KVBC13vSsIdE4bKnvMdpPAsxnLAyzGu6tVOkj7T
	IdxGPDS4Nl9GGUFd8pgMTvYa3juh9O9ZyeCzvvDa2Ok3m7ktwgWqb9SxCnJb7iKt5vc3AZ07Lst
	SM2OYXAW1seSNT1mAXmEMX2/gCUWJAO53WQeo85kfNIYVij5TAXetFCCW5cu1Jkyb0sKrYYtkoE
	PQ0Ex5gRUHpJebsGApB/5VJnEvafU6geLSMFrtpXWGBFnjDTO7MyDoGEmKIw3CXkdV3h1wA6S5B
	3f4wR22VQ+jrOjtxxgvok80SJ1YlfHykGS214ARnarffH9V+A2E1lUV3TVrFBw/up6SicCjCbKA
	EBQ5TYP4k/Xi82uS8DFx+PGeQZOTDbfXMPwLSG9XpjjXtSBtSNWKyzJo5JE1zHdSxAi6D9HbBEr
	kBKCOM1/OSDWBYxZ+CMS8qC4DeKO8D2RP1n2Zzi0b5Hgv4nUHcDcg5P5r65uhUdS7lDFzXin3Ha
	J/jlu60buI7qKNSZSs+1J+tw/sdSyFdIXOoFCxQ=
X-Received: by 2002:a05:6830:680f:b0:862:c9e8:5776 with SMTP id 46e09a7af769-8631549ef6dmr320170a34.9.1795103012660;
        Thu, 19 Nov 2026 07:43:32 -0800 (PST)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-862f01d4737sm4557635a34.7.2026.11.19.07.43.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Nov 2026 07:43:32 -0800 (PST)
Message-ID: <4b1b2d2a-90f0-4384-8d91-cf843f9459c6@linuxfoundation.org>
Date: Thu, 19 Nov 2026 08:43:29 -0700
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
Subject: Re: [PATCH 6.18 0000/2151] 6.18.65-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/18/26 07:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.65 release.
> There are 2151 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 20 Nov 2026 14:55:45 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.65-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
