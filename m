Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C30F1EEA31
	for <patches@lists.linux.dev>; Sat,  7 Jun 2025 20:20:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749327607; cv=none; b=syfufOEi41fVAhnWSl1Xj9WSDix/YBzN7A45pudTooZOIeIDbRYJlCxMO7nQfQE0M9Rx7g8rsqt3x52NFfCAagm34CQRwWLIFMFis4AOXr+I74OvFpNkXuljGwwDSw77r3K2AjVkPiAk6IGKL3oPHyrRllUKSvnVB/Q68mpW0m0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749327607; c=relaxed/simple;
	bh=j67PlnEfqbvwkbFIcNp7D2Hb21IvSpJVcC0OXzmk+lQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XoeQplqwQ4fCIcAIICZ2CtL91RZq7RjKn97H4n2hlYl0cHk0hOUbuSFI+lOabO/S7KEXXI3QFw6wxeLvxxabwzKw7VEJ6MNMpTEU4j1yr5TIV5fuHiRuAv4G26tMBMziPgajztfrIJNOtabqUbw8HLXogmvE8XmWSTaGIao7zYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LaDomQf8; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LaDomQf8"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-234fcadde3eso37781205ad.0
        for <patches@lists.linux.dev>; Sat, 07 Jun 2025 13:20:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1749327606; x=1749932406; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=1JCuA/KJ1/RmFLQaJiC7CE/5YPs/dtb6ADPS+mr7YTo=;
        b=LaDomQf8UCWkB9C6u9CeVY2kjHMdHp2D/wDx04wmWiREG51qGkHaU6Q00Z2xKDXxoe
         xJG9oYCdNrj+dzyVCfKRoAO37XpKb59t4f2CuZL9iBVYyrFVYTO9yc4Fy2ZcuFwX+cPs
         40wnp/2FtYQ78QcrYNfRF6xD5I6hIqK0SEEMscJjO+oQSp/hzLf7kCaDNeAi1KWXJwjx
         Di3GSp50grddjhJ1Ya3pNBvRJEZsEIOPn+ZmL1aA4aVUCNJ5dQUMU8P+yO1vapyGQPNP
         J7Z8mZ0XDXORCY/PPHiabsxXZMFihQQ3VPWXMy6qcBIxK3cYZ5LPl2Oxw1Ymtbuw9KY1
         R/Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749327606; x=1749932406;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1JCuA/KJ1/RmFLQaJiC7CE/5YPs/dtb6ADPS+mr7YTo=;
        b=jIHO0Pr2dSEcFqoGh4dizDeU6APUvuIk/xKOo2Q0awi0ojM/emQ6fDvPJXvnJ7rM3Y
         OmhtGpLHgasAoXGmOGddsN8tEtG8+nWBxrRBLudZrJREnKxWSDiwtb3VgZadIGDiiGTP
         GEF/mlAg7Tsjf6g9HhgjqEBTHh6IfefmUg9eIKpHaE9fwfnIPec8fuW7EWWruHyZuA5/
         ECtg1MK+1m+RIMkQe0CFpp2PtGkWQVzCOuJivYIZddyGTeXjDf3JfsWCger8Kszu2iJH
         oPyFgYZYnCDv1Ze/35GkZg81sfFiepM1hX0TKbs1vJ+ogzhpa/e1A08ykkL8E9W+q8pY
         SQEw==
X-Gm-Message-State: AOJu0Yz00DAsdkSTGJ/z5Ugv2XX9d99PGIbzt45x4lI2mmEe9HpQZnMV
	H1X6Q/MhnXVUoiCYo3Zs6qXLBsMFE9ZcpP26aQECMPAGNonSwtWLut0B
X-Gm-Gg: ASbGncvi3UZIJPg8cfnVrw8UdKAb3//bOxCs2Af3ltRfdGqLOIZM5fIr/TBmQb7WoJp
	CH2y3SLBxyAgR3c/MZCxUEtggmRwH9u8h/UA76wHrcw8BQAwTxa/4M15BOYww7Iiqsl/g5mJZxD
	GWwUGDaQtcHYZoHFBmE4L3E9NVq01NTko/SGOKZkvXnzHUyhON99kUB7EvpMxQh4lQEdcH+T+nk
	MCPoUZgbvkPWeVEVka1NqH7U9MMm/UpgVfZFQ0ZkMJtf9i8seXXi7pj1/BmvH+tmeKg9d1JQj0s
	MqcvjOHgBnDAXvg072K1fe5+m+KFh9PFr6anNqp2xrwcLV9MWNPj2uksZwrt1K90EOEg0vNv1wU
	QKQ+vceZNzJle9SvzUErH/cVjj3tqEbNPtL5ak3w=
X-Google-Smtp-Source: AGHT+IGD4clp9fPtWjceXrKZpN/02Voy2xyMYrequhlApMSZn1dDDHAu/V8zk7Y5YGUSPCpSdUjScw==
X-Received: by 2002:a17:902:f545:b0:235:129a:175f with SMTP id d9443c01a7336-23601dbfe92mr113590005ad.34.1749327605732;
        Sat, 07 Jun 2025 13:20:05 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-23603078007sm30644365ad.44.2025.06.07.13.19.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 07 Jun 2025 13:20:05 -0700 (PDT)
Message-ID: <f0ef7d23-29e6-4478-a7e1-0421ef7456d2@gmail.com>
Date: Sat, 7 Jun 2025 13:19:55 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 00/34] 6.15.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250607100719.711372213@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250607100719.711372213@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/7/2025 3:07 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 09 Jun 2025 10:07:05 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h


On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

