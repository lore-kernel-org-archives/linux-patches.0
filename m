Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCF933ADB9
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 13:30:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762867819; cv=none; b=ta6142NBK2I//qcgkLjg49fitAmQpB//iXThcl8vcfFWpgLV/EGRii08LzUaPNhN8R5G6KmCFzvMNvhHvYuIR2XSfgj2jgzkXeP8V7p3yl6QUX2xN1OIEk14ZoFyQfBijIGARcODHLSsdYfEFN8yEY3cTdmYetmgFD7a4eBx03M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762867819; c=relaxed/simple;
	bh=qDZL6MdNd/KZflfycs2sNvxaMjuSrNaIyMnm/7WrZ8c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O8cOo+GWgunwVp3s0d3yrO463A+QYJJ6O1zzywMhZJFjT84UM4ScrdtdBmeV3bB8rLqTo607Kz/+W5FNM8WPI03JV9d+cKb2c6E0Qs0VkCY5YBPMUBDRiZLGECjeatiJ0yMVN5eWFQCvP6mC666ZiTRb0XPhgxZNSvgtj9hI81o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com; spf=pass smtp.mailfrom=sladewatkins.com; dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b=EIYcbDZY; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sladewatkins.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sladewatkins.com header.i=@sladewatkins.com header.b="EIYcbDZY"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-4336f8e97c3so33095025ab.3
        for <patches@lists.linux.dev>; Tue, 11 Nov 2025 05:30:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.com; s=google; t=1762867817; x=1763472617; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4YO/KwJ4FC8gmOpZBF6DOQfsCk0MQT6p2iYft282HbI=;
        b=EIYcbDZYSDX+iWFV3Wqmn/EDiLEF5SiCSZaqjXwg+gn7V0Gqhn3PxxLrGvkRbWVurr
         NnkFJPlxtSaj2xLVaEAUIaB8RHnOV/02S2D5ERJ8EpX4DDBidkQtG2vw1WHfzcxV+llM
         i9X1ZmqtjMLqwp42LrjwYzgLk0Zgp1XdjYmX7uXq4Xm9sv+kYZe/4T0SB73l9wZgjhNk
         7wfXy/29FhpA4Cb5nJNkpFV6Oqc0Mh0363W3rg+C76TPCPzGzzbfW9+D3DCIBS1txjrN
         jhcE+BKszNNOR3pQOf6BJroWqgtrRBVVwi7vLEN/jRbaTXpquzPS9teMXyxPLSaMBt0a
         fyDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762867817; x=1763472617;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4YO/KwJ4FC8gmOpZBF6DOQfsCk0MQT6p2iYft282HbI=;
        b=pSxTezZtrwfWsae7gg+AvnLwgbRpkXY5XMCT+4J1AD66I44IQK9i5WAqxBV/3uf6BS
         2pcyrmbPn3nAOqfQdmQpKKJuAyERXJRYdv3RU6k1wrWnunbraZzYZP1Zw7PBrs74myXb
         I0rAaO4GUqKo0apPu1uCp7TFyx51QYNH8CgKzqjPy+wP9GH/riY90DP+FLM++qDcEz7H
         hqMRVlonrYJY7BLyiaL2pz/U8ZpwotnRWsEEfw0B9z/I/VTXl/0mUTLRnsBxMwGqL8/k
         PrWlRxbZz/qho+++2h6/tDkcdO6FQpPS/5YLtfRNVHmReLlj/5WxCTYtkklsKeVWa9OC
         KCZw==
X-Gm-Message-State: AOJu0YzWngptiQhWQwmLmNMVoTxnp17r8tsAyApTYuB9q7g+gN4Z4GTh
	BF5dzAfChDz7BDpNJ4u4MNiccDRLotNi4KwqfG+nEZXeciFZ1mRlKY7LW8TDStDyK/U=
X-Gm-Gg: ASbGncuH45XXZo2nLXhetjLxhQlLU4Mq/Gvv7nFJ8VHwa/iYsn2SPtR7kqIuQ5CKbC4
	nqF3Jm/J0DNpM4H1HnMmvxEv1LqUgfS49L8Uupqe0qp86Y/85ZhvDkRMXq9uBiIOulTQUb/sIR3
	a1uFv3DxphtFzFs11X43P2GvthO3rfkNqvRKBKTP6PpbWaFGGhM2kCJSdO9EvGQXm5jGiL6aRBU
	53fkozkZtfhAJ5iHQyAFRkwgb2AAcx/HLRAYHz+vW+XP7rR9UQGtqkTbBu9XnOy+vmM7ZwhkRib
	5lEdZndSijlyIuETO1L4SKGD36kVf1ZLVCs2CLzJBLDX6o39bOUEQJh14RRk90mzk8q2Nygy2WS
	CCfc3kLw0edwkn3VQXl1J2FvyPwVkVX8YqT6JloJouqpo6xI5/tkX6puj+lY4dkGRBwifQr1fuG
	GYBiDzzQiLomfpbPZEzeKFw2FFmg==
X-Google-Smtp-Source: AGHT+IGW7t5Sia4TYMC2RP3zk+pxpMo/Yir0L3mxaMYdOdYqoFxgBtNrF98A/H3TNDJQ3xWRjsTrXA==
X-Received: by 2002:a05:6e02:12e7:b0:434:720d:1c2a with SMTP id e9e14a558f8ab-434720d1e3cmr5300985ab.20.1762867816968;
        Tue, 11 Nov 2025 05:30:16 -0800 (PST)
Received: from [192.168.5.95] ([174.97.1.113])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-5b746923a66sm6246780173.35.2025.11.11.05.30.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 05:30:16 -0800 (PST)
Message-ID: <f6bd6612-b0ea-46ee-8807-bce12c040b5f@sladewatkins.com>
Date: Tue, 11 Nov 2025 08:30:15 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/562] 6.12.58-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251111012348.571643096@linuxfoundation.org>
Content-Language: en-US
From: Slade Watkins <sr@sladewatkins.com>
In-Reply-To: <20251111012348.571643096@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/10/2025 8:24 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.58 release.
> There are 562 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 13 Nov 2025 01:22:51 +0000.
> Anything received after that time might be too late.

6.12.58-rc2 built and run on x86_64 test system with no errors or 
regressions:

Tested-by: Slade Watkins <sr@sladewatkins.com>

Thanks,
Slade
