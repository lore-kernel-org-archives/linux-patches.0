Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.176
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793224649;
	b=fG22KK9jzSUxj1VHFM5ZzVMNKA+5xE1hFhui6bRCHK6bqpKt2AD6BiHkmwFxJgv+Zc1D
	 EcCDNbenLDZSMqPlJPerp+yfAAlumrJnu5GAb+eJB0pVzjaijcE8uWIWprdzdNh4WfCQ6
	 uvg7Qav1FDhtWG0kwsV7aXBb00F+d9L4JIuzYW7lLAEOW3SnBVM1tjDtKlgVU5v2+7bPW
	 OodrRqllTLe60vVX2J7mab3aV4Lnts2zkURPIhO460ivOJV6lSzfni4Yb1ENKhRoY7yQx
	 MefTgl2jZIGPWZYi6HbMKQ3IBHKkLHmzXZ2RjxBxTnR2+DmUhmIfkgTTWipkrA5UVPg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793224649;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=Nmob0PGZGbhgpel5Pzhl/DhX+5a07M/6tXtKDShuMAY=;
	b=12ticVO1LfP3Sej3GA2DeScPwpdK/f3KdE8ygh9hy0HbawB248S78yzCRxT9BgW5ewtM
	 qtdNgQeRNfVN6tB0nDnE83r1ms4eUE8664GjKOnLGS9QJXnUjW5V4uEb8jSBTckhNCJ6E
	 8ft1ZKUTIcqs55NiwSbPROMKuQNLTzBUgK6Bz3QeXXgRdgdpdsB14DV+9fwycxjmu8BHv
	 dz51PqzUr9H82N5VQEaMB23mwo4JTONNlWrkOgXzEgJfr9z7alIU6v9RdgrBc8teds18B
	 Bho7S8kxMwLbS4P2vPh0GIOIZOgZ2OqzS1PsHqmpvpVguFmF74tNTnX7bHZWHCaoW9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mWvTachx;
	arc=none smtp.remote-ip=209.85.160.176
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E91C606A31F
	for <patches@lists.linux.dev>; Wed, 28 Oct 2026 21:57:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E91C606A31F
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mWvTachx
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-53397554beaso19130041cf.3
        for <patches@lists.linux.dev>; Wed, 28 Oct 2026 14:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793224648; x=1793829448; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Nmob0PGZGbhgpel5Pzhl/DhX+5a07M/6tXtKDShuMAY=;
        b=mWvTachxjyfKsU7NAQVIJchQvWMYxApmKRz/wq0XbvoLdhrbPJckL9OhLJYfi8tXzd
         Q1vcWumDlgDmyeLEpdGdduOWKW+OlBhhPZ+OCiN3eCzvJNlpSpyUrAFs5C4OMgXhpYUG
         aVsvmytCclZpz1jO3IQu25FS+IQGCVJgbTzP5FoiZSlNqV4SmdOvNy/RwNhJhGcUr/hO
         zOgUPDD/p+9n38aZLL0rwDHHzhO/QYlsWV54VOl6DZD+N120myI03wyBOblcIyIyHt6t
         +0wG3jSyb8jV4eMShMTghPSLdYY+Jmnp9f0M/U15SAsQ3440lRFh0QfQukk4npE6b//b
         LjNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793224648; x=1793829448;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Nmob0PGZGbhgpel5Pzhl/DhX+5a07M/6tXtKDShuMAY=;
        b=QoOb8Di3BrUukElLHDn/9XoymRu8g1Nh3ANGrODGB+d68o8VnuxPeZNAc63wOviShW
         G5PlTvn89AQ4G1C3Pd0O+ieHL5BXs2eXsSYs+gFlzP4UyXZ4+WHj4sdPGCGRg/Jms1vp
         ZspNEDSjiqa62DyLcUTTYuEAMmVNoxDjDVC5KVhh71H8e9zyKnqNCwGgvqnSFCrc2ueZ
         GsbO/08RQwdwt2z5xn+l6woSgha1LHcsG+6zez1DtcaE04IDETf/DyOlXEBIoJVE9Cfj
         KTmGiO0jOynL4ej9B8WXueTp8H0QzYeRs9469VzLaZPID3d3/7rl3ubD+pCK9fq2Mz/T
         kHPg==
X-Gm-Message-State: AFq9FYKuQZWkhnIMwBgohp8RXeKaFr4u8kHS2lxdOK1n5NHwNQwJz9sO
	trig8JEtOTluNaSDTNPgdrJ9ycY8V0uFgfVw97pCUzQnZnHL+cKxWYIW
X-Gm-Gg: AYBFou041dlGnMfzm/VySeFScEx0r4VZ741kfULMTYIwNRN+InIBvusxVAe0BbfOsPp
	JTPGnQA8rmNvRcNV+69BQ+JBBm5AcaedeVE3fVFCGCzzFKpzRSiF0R1qAuxc5VGOLupY93byGOJ
	TM4KDDyi+GIeqkZnNuc3SNCCZmhik/Dsf8cwjqYHBNfx7b04zPnXt/JmTCwNPStB/k/tg/0bkFu
	AD7J+9onKWPZ1NjAnGGisrFfD139tzxMp+EeBeUaWPBHtHjpa0X+BT2fWZOgBSOBN7z79wpq5QT
	ovIvl8AB9JxWFKP933T9rYsAt7lLtd+uDiQL8fdQ46BVVelp73CXK5s/rCAbD1zx0eHXVz9g44U
	tRXEDch6EBZecpjCo8i18x04WhtSyqpFctXGLmxW+fHNk54sCG21nyA4aMGFoeiUESLIHjp4E8Q
	f2TK2ucSAKKnZA4Ckv53z1KaczGTxr49BuS5EOjIxmqXFpo66O8g8AwGUqebp6XsZl+P4YuswcV
	uH3IWxRnFXlW2cHvqJ4Of9cHtN5QUBZN3KFLzYrOON7K/XSReYETLvKnWKlFXZvyl6d1t4B1K0x
	uX34fP4TJM2dEEREQsIU5c/VQQ2o0soCxn8vk7c3+kI1qX6diIbNcpdQehnSH4srHC1QzK8RJxo
	jpQ==
X-Received: by 2002:ac8:5a54:0:b0:536:35e1:b5 with SMTP id d75a77b69052e-53fc8fac376mr65585691cf.1.1793224647994;
        Wed, 28 Oct 2026 14:57:27 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91c6c4e7565sm69904596d6.15.2026.10.28.14.57.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 14:57:27 -0700 (PDT)
Message-ID: <3a7c5852-820b-4991-a14e-c74b8ce76db7@gmail.com>
Date: Wed, 28 Oct 2026 14:57:24 -0700
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
Subject: Re: [PATCH 6.6 000/168] 6.6.161-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261028165943.089486480@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/26 09:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.161 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.161-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
