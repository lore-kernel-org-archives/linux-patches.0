Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.174
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795219020;
	b=qUkUjgJ049/waiGW4CwFpXXwBXY395hj4CtCs2etw3IU/d57b12NPb4fygPtQ5X/eOUA
	 4iGJsfOLwiYdodNLSf2FREMSp5qUjAsqpTG6BHhq4P3tMoEALrm+mjI+ymDxpfFiUScDW
	 O7hz3g5dBSI+fGb/ETb85lYvJ56Gt9amnzfjUnJe6OP54m8WSzdAVT03I8TN/0wk1H1G8
	 lM415GvKK41ttPZJI1pFPTgF6YfsJ2kdj9eD28zOfYv0fb9yy4M56VQWuydg4rwaLRkRm
	 FGi+/dR9PipvOeagGpBP0NXiAPfmg+A0VHuB6TMiF2HVwMKkANJVME6ulqZ+RFcsDrA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795219020;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=kVgYuwZfK6/XOH25sVcw/XaxSILhNtXWSKbZSzmcIJo=;
	b=Rpb/ok7gj7jQPHo7URN5HBTBE8u0O8vwcmLhcqS3nhftstWURzcQTzUK+tly5VBlD1k9
	 USU40otGN2ej5civdEU8kh/6tY/t7CwWbI7FHnA76/xme1BUaYOt7aKCLTdsrXK/m/vms
	 t2RKYz2FjndIoBZ2T3ltm5t3PVzhAhXwa4j0LXSz9jqOF6GvRatEHkTv3pJr7WkUSKGMj
	 VLIFITYpABw/tU7YYmlGvxNYc+RylNfXrkQawNw1GhIkHn4nGdtU5eh6KgtB1a9k5Qb32
	 6mDGnMErr3XybSlX8/5RDkHjZocpP852ZFr7ITPA2L9MGJi8XZJpPJlR8eqqRjMzvvQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zYeXi+m7;
	arc=none smtp.remote-ip=209.85.160.174
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3982606A6BD
	for <patches@lists.linux.dev>; Fri, 20 Nov 2026 23:56:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D3982606A6BD
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=zYeXi+m7
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-55d3563e50eso10068361cf.0
        for <patches@lists.linux.dev>; Fri, 20 Nov 2026 15:56:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795219017; x=1795823817; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kVgYuwZfK6/XOH25sVcw/XaxSILhNtXWSKbZSzmcIJo=;
        b=zYeXi+m7TFJVDo9adl2Ua2xFVsm/yzqHLGMVOxEjgaD2GCBCNee1CkfXSZv68lFhND
         N/6VtFeI42FrV4Trj2YJCiLxPlAKVUZt0PDNfrCpSpMKEtHDkOMUrH0WcKem+jDGj8fD
         zDptZNRvSkoqX+wUltWFYqiSdtPB3XA177eMOOF/z6z07YuY552eAte26Cu0nQeEFzNV
         vYAaCVcufji1itqO9xJ0Irc7/dcprqDhUWeyciSsLCWFKEaIUeMmZQ1wG7EhL32Ax4+D
         EULr/LSBFbCERycoPgPZrrRb4cfiG8KpCx5v1WvN2HruRN6fFT3hNBEKycg9Ju3By/hl
         LogQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795219017; x=1795823817;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kVgYuwZfK6/XOH25sVcw/XaxSILhNtXWSKbZSzmcIJo=;
        b=n9odqJr3t+wg8nGONAFgMx7+nE32bvU0Dp4fsM1WMWH8N1aYZR2UJUMD3ORQYG3oSj
         5Ini80ryvmxMadfj6ZWLCzvK2eQq/4S6vChwLe0jLOt1kiErMB4WIvkJMnOw8B5tJD+K
         tbuzq1DnP9lzx8naVEcl0nU76vt8ByyLvhCDFGK5LbBUJvw3+4UF2pMOP43lyxMpfzCe
         YYHYMzx0trw3mu2wp5iJxxsgRXygjpaqq23O2yCbkzBW4RtqtavLJRd1dJwCIbKEzX3/
         b4cMtrCZzZ3IMwmDLSHgi8AAAuGxOgK8aY/PR2IvWSedsQv91av8rmjbQcHFg/+v6euH
         EPXw==
X-Gm-Message-State: APuU4Z9AjLai9ZidafjFdwhrYtBOb/G5QFdMedwCLzyLiA4PZprhF0E/
	1dWvJgVHJk0sgFRQ8DokAZTVWcVZ/qbyyWas1aJYWaPteYltZH33qQ/B
X-Gm-Gg: AYBFou2h48iKprxNlRoKxpzfSy/w/NVZ3mxXiYRqqZRLCn8vMrnd68X4zdCpM+Nr9Wg
	CVypRuE42p+4wyzB4giwKK8RpIHvStAlSYAGcUjAHRncft08sv4Cs+3su/XWhrEOu2k3y17xlG8
	WuI8DX+UXTzJcjSPdQhgzsjZvDncxEgdPnFVN1pHAs8QyEP9yETO1nDyFzsFrayNS2P7NsP/ti/
	w0uA5tG31oUwcbEKw+mYfltZNxQ8evqOXk3adlBu4Wck2bIvgHVXbupngIuB9gnBvaHhqbESFue
	jKf/6n/NfX53oh5JkFxg494hV0mmFu4naw8mjuK61cL1DDj6In69nAsYvtGr1FSbFu3TWcG/cme
	AG1mQiaTKz5i/9KjfRy0fAIEuRvmF4tRls4XX1MUtu5BwmUrtXvpPXT2JpZ6JwZ+cWcwfWtP4H2
	H6YhMt4w5x2zWcVNwMrzh34/Z0rh1OPfw6oOlvTw2ykL90qwVLDXNQ48Bn5n5ilo/y6BWTx5tP2
	fYMqFOpUSk1YJ6MkVDNWFEolLHOpuEsMCMCl2phcK/hyUkJUWImw3Ds/Y9viNjYttCAaJJmEcSk
	HbYNHBf8YiDUmPAN8ONS2f7+Y8gKdI/dsQGXnt3v7XQC+Npcn6ITlUwy+JnM0N+xanQxiXP85sR
	W3v0=
X-Received: by 2002:a05:622a:5590:b0:536:3a49:f76 with SMTP id d75a77b69052e-55d76a1f01dmr81789071cf.27.1795219016833;
        Fri, 20 Nov 2026 15:56:56 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-92134a16754sm39125006d6.39.2026.11.20.15.56.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 15:56:56 -0800 (PST)
Message-ID: <e3d03f4c-0c66-46d1-8fbe-554642eebe34@gmail.com>
Date: Fri, 20 Nov 2026 15:56:53 -0800
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
Subject: Re: [PATCH 7.3 0000/2642] 7.3.6-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20261120055248.913352689@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20261120055248.913352689@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/19/26 21:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.3.6 release.
> There are 2642 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 22 Nov 2026 05:44:39 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.3.6-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.3.y
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
