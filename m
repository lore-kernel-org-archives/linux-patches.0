Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.219.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795204197;
	b=FvPTr90evf4uxCNc8tZe6bkyKQgyO7kdTwbYDznnMNOPwX9NVhs0ODn1ImzDWJNwawFq
	 lTkBupPpx3HOIDFQFV/MdL3WeTqRbr07EZ+j6NLCKq3vPw0Oxw93v9U5uyzKCzrI8/VKT
	 UVWjN5c3mdbwNtB9GP6zMHi6eiJUUUV4foZ1HI114cfFnnJlyx4WI6xnkEhxB0Bi8ZBGb
	 3qS+EtIZFXLUaLGj5UBkkyqyMxDAfMZuTw8nHT6V6bINy/OvwtjDHsJ3wLqF+XX2Lgn35
	 D744A6P+owDj0B4XaiV4XUiPOLxK3xVQmci0Vqndt4/O9nlNxtjAnJm0KRhb8rxnc4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795204197;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=qmrspoDYekLGdhjXLm1nbvWqmbjAVLQNUEcJXmCtCSg=;
	b=XnHZ59akunL853NI2VqOqd2ZDQKwH1adNmZzZybFY3ntee7wr+4VqleEbjfbzHw7i24/
	 1xbu95GNR+ST8atC0Sg1UTFPc3S1czfM10Cw+ivfmHLy5xSLOS2YnwG4fR3wuKQnpemgt
	 OPFele2Yhh0p9v01ew3DFMY6JLN8uJyEApxY7Mha2oxPysqbeD1Iy77xDPWLHA0jnOMS8
	 Hppj6Xxfqwf+r5OQsB5ERr9/ATq1WroPYDUEyFpK9oy9rDq1ZQ3l4RmkAMkGq2xt9pr7V
	 dul+EL0+1HoRxVF5DeZYV03uAyxsU0KAbdTZUpMe0GxUduG+3tgicfEFXY9UuM4/i5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="I/VAPut+";
	arc=none smtp.remote-ip=209.85.219.42
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50173606A6F3
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 19:49:47 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 50173606A6F3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=I/VAPut+
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-92134c4592dso11994226d6.0
        for <patches@lists.linux.dev>; Fri, 20 Nov 2026 11:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795204186; x=1795808986; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qmrspoDYekLGdhjXLm1nbvWqmbjAVLQNUEcJXmCtCSg=;
        b=I/VAPut+oAZXaMQAp6R7ig//MnWOMSaUkSPcze0ctL5YCKxEqmktzsxcIRPeD31qN+
         7Z2DuvI0g2LF4LHmLgO47iVg+1e+lR7xh9MdOpP2EAdKu1KlvGYZPUz+5tKb+O/lvbKw
         c/go7KqKGfhFIWlPxUhkiWogcqcL97xJLBVA14swxwqEdgIeCfFvBzRh0DM9myvtRldH
         qP7vXF/PpKlma/hvM2BybDXj+UftZG0nzhxW4EQgeumeUWsfXfWPdYwx/Y+BP9k4hSjs
         W0NG9twKmMpQ9mNQctQuwykCrX5WwX09bK2qLt0vXKIkfPynDBNUhb9RVqtC6kaXYr4f
         +nlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795204186; x=1795808986;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qmrspoDYekLGdhjXLm1nbvWqmbjAVLQNUEcJXmCtCSg=;
        b=Hyqy9n8fANkmDNy+2vkgWZfyiXFfMr/EietIS0G2pxyAah5rC12oSQcoZzBcSRWHif
         rujpALWUThCMqWkCozO7EKRgtYSQIFjYtrtn4KAUkyU5wpyu5L6LyBy7SCd6DTYUQIef
         ROyoLaB85vCAb/tgSHUVZ4k47AFyVeG4AbCpd0P4I4QvVf0lwxmtVp/25pMvH/xpFHrm
         oAFK83Wvn/P44mcuJypOba6XlXGzvaLKU5HiWMNe6WZBuOPr10Rn2jYHGkP8j0E1huUW
         zQ6FkWtzVDauN82I06zRd63orRk2+8WA9a3uygsxLbqiri1VCo6bNNdi9n9m6YmxzevS
         VPbg==
X-Gm-Message-State: APuU4Z+2eSXe/0pLgqa9Nf5e9sN2X0/cQzkPyokyJoE0fke3ya1FRcqz
	eMSiAwWO0exyslHyN3HUgFNSomkOf4qdukaGWvRoNk4etRrbPRoXiQN8
X-Gm-Gg: AZFdTZe1zqJ73mnyxUExbst3umwOTbE1zCJizN1zM9Mh3upDdF0nqOpBKG03ia75ZsE
	azXdjJpJeBFIikGPMyaVHKk2kjMR5jOfQe29iwCjav9/9nCX0OYQjnLgW2GUi3tJ/N2zVhJ3dA0
	mGXf0x1r7mxcXQj31PTAo0pURy3wJHMIz+kceT5QEXglchZH8av1j1B4fQhx2wcG0t6Y1kAo/wS
	EQVVHFjYNoM/eyX/uuAp8Uv7/JOEypDyO/mt0a6XA7HULVmT/6yF8UmPwhvCKeciCOgB5PWEO0R
	Krb1orrlYG54BNjigA8QDqRcqvxwCUXgoKmWUReiAF4Fd5qxoEOJeKbApRGV4tIhhhTDGyI7Z1g
	zCeMhg9APupjW2EjCOSzBYyCWRu/Nv/J7n6fpMcysgu+Hck9ont3h9Y5c7ZaPZStKPNxNFcptTw
	HfWRdgqIXZ2H1Lb4UrKQJEn5sTFfy/VleigxL+k2r69WR4s4XBjFe57dhpvoc1eb4Ku/u2pHGGj
	1C2nxH2PWUF1HtFQ7dBcpcj/BvZfvbRI+IRsqiC3EjsX7QuSnLy8iEJr3jPK9XkCfOWS7mPNngr
	Hb6rqfXWji9sgYX1EYWxmY1YZarQ9SnwzBKQR9b0XBdZMOllG1MOxlDX9A==
X-Received: by 2002:a05:6214:5c81:b0:921:10b4:48cf with SMTP id 6a1803df08f44-92134ab9b6dmr64832756d6.46.1795204186213;
        Fri, 20 Nov 2026 11:49:46 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-921349b081csm33351676d6.7.2026.11.20.11.49.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 11:49:45 -0800 (PST)
Message-ID: <16b5699a-69c8-4d57-ac71-e61b50846415@gmail.com>
Date: Fri, 20 Nov 2026 11:49:42 -0800
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
Subject: Re: [PATCH 5.10 0000/1811] 5.10.275-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261120054906.397973290@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261120054906.397973290@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/26 21:56, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.275 release.
> There are 1811 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.275-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian
