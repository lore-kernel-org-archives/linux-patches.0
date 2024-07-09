Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAB5152E1D
	for <patches@lists.linux.dev>; Tue,  9 Jul 2024 21:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720560920; cv=none; b=L/ZBGOPlPTYXsJz2AQ0wlk/WNPcA5k7SL4VItmQ9zGI9qk8kVf6venW6PzAbhsIJz2MaPu+Em3PEDKfSjDnt5x+Y0/4teCtobFSRho6KIiBCEz1az2YEXqyeZpDhtC2qjhzes72az6pQR0JJqXX3+6HduThFrQloqe17K6bZrrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720560920; c=relaxed/simple;
	bh=ZetbC7TE4JO9QBtAGo9CeTU1BeEzOd/4ss6yzko0CUQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JxpA8rtHs839LL6VCr8CjXJsE7CszkEIumUqywagG2qQacm34Uy/HV1DLeqzMw1d3B6HLjpJq7pshB8iYJx1fGQ3BOmqBI6pgxBANofgWCRhDPO1HrTGPYLnvkn16ZtAVRu4eWOr+Dsg5O/Ish9qnNhm1bQTFIUvNTcl6ne5vQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=lxUKNk5s; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="lxUKNk5s"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4266fcb311cso9918775e9.1
        for <patches@lists.linux.dev>; Tue, 09 Jul 2024 14:35:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1720560917; x=1721165717; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3M5Fvu/U+spfWTBwhlOd4QQV8BmMooOznPRXHtmfW+s=;
        b=lxUKNk5sM8vjCYLQR2qXqk3IIeaLg52+GrDWmsD5Bu8+o/+ZlM5ByLwzxPXYkCPef7
         0Bk9x564YVanqFBvit+dLg6VqR7wrvGRvD2woFdwLq4Ix+pbzHdJcAgVlZHbUpXTHvZ/
         OcSVGIjOznL5EsS6DhDWrn6miwhyqrAO8npE96bwlDLSb4IYIwm2yRkHBi2aIKDyb5DH
         5mQDeV/ffKeHdZU1lLPM3eJvKOUCBt6+HwE4wIDI6pzDt62BLuNDBIBMAM6kgBcMh9PD
         9toFmWhLPTtWXZrOvgCZUQRO4ioG7i5r1vCqfGTmbYMdJUiGkqZFeflb6X5t4Ma90r6T
         YABg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720560917; x=1721165717;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3M5Fvu/U+spfWTBwhlOd4QQV8BmMooOznPRXHtmfW+s=;
        b=H9krvbmWkzKMoP7O4TKustC50fy9fSMNLKKd5C1hflWf2D3IrmTZfgG9YjO7wiDFPX
         dCzfAw5aua4HHwY5BwdRLR1MzJ/cpAQxgCPuReSYxBF7+Q0a/YfYJuUqFEsAQaBLlRFE
         r+j61Kudw+9in9I4787ynU0exkxsIAqwi6R3glY+0ktDFRwb+pLCu2VvwcHOjyVbBeNu
         /zL8vAGzTcTo21Di4o2WsxdihFtBwyvyVoy/pT21j2A3E643VDqz2XEriDgcBECVNd8A
         kHDbryZ8OWAj3b+5QV1AQNJeay+pKwxiAc1AGytzcmBbBAJ0GXTuOB/ei7gC7yRO6jmz
         asiw==
X-Gm-Message-State: AOJu0Yxfu0MlUV/kf5MxCVFu+IgIlyDh/YP4bNoVhR7sb5iVrt/jKHqP
	tFWVWGb5EmH5GIVYAzir00MF6OHMlBM198Ixo3IBtH/OvoKH6U4=
X-Google-Smtp-Source: AGHT+IG1hi5P+S1pSgVCL9mWAifazaPt5ItydrKvszdcF+cs4/YQ4T1bNJv67r/1jRKKNpKhwuhk/w==
X-Received: by 2002:a7b:ca4b:0:b0:426:6c7a:3a61 with SMTP id 5b1f17b1804b1-426707cf194mr22888825e9.3.1720560916890;
        Tue, 09 Jul 2024 14:35:16 -0700 (PDT)
Received: from [192.168.1.3] (p5b0577f1.dip0.t-ipconnect.de. [91.5.119.241])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4264a1d165bsm223537125e9.4.2024.07.09.14.35.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Jul 2024 14:35:16 -0700 (PDT)
Message-ID: <07de625c-c504-4e12-830e-1f68e923aacc@googlemail.com>
Date: Tue, 9 Jul 2024 23:35:14 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/139] 6.6.39-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240709110658.146853929@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 09.07.2024 um 13:08 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.39 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found. It ran for an hour now, and I built 6.9.9-rc1 
with it, which I will boot-test next.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>

Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
