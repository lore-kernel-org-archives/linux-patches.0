Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D48372877C3
	for <patches@lists.linux.dev>; Thu, 18 Jun 2026 07:10:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781766647; cv=none; b=P21Zwm8JOmTUE5wRs1KbWp8EbUePp/YVQ4Vgml1hxeX9QQVHOFQR7/HU+rPWF3Y4wGj2fVD3UYVwISilEt0kKACrggfSLTOlC72jZcM3V/JKZap05A6o4EFiKi2BCgGhnRwBYO9ikki1tIQj3zXameO8cRK7CHhstB39Wif/CXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781766647; c=relaxed/simple;
	bh=gKhup4n0wRHgtxSw7HhMpMECHuFPTq9UwzgNdCbUPEI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DH/ymBbsuowJhyr4dve1LY1mRoKAPB1978qjUrAbe4dHoRqJIJXX92xATQC6IpeaCINR6ErCC+i5lj2NNfhtVbupqH79VXNH54rXdbX7B+J7oE2tNEykgiJs59PdEKSEgs040qkVhajGYqXtQxYAnpNB0cYT8nZ4nuhEMzcf7x8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=K1XuQA0m; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=PSitc5kU; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="K1XuQA0m";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="PSitc5kU"
Received: from phl-compute-07.internal (phl-compute-07.internal [10.202.2.47])
	by mailfhigh.phl.internal (Postfix) with ESMTP id E949114000A7;
	Thu, 18 Jun 2026 03:10:44 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-07.internal (MEProxy); Thu, 18 Jun 2026 03:10:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1781766644;
	 x=1781853044; bh=ezBmn6Ch2740RXeVdRGO7pmxAKKU8gs22xpfn/R9Rg8=; b=
	K1XuQA0mT2J+SIanNEc8Luvh5t0liq5bY2niZJk8gNKQoki+IY4Qq06q3EeUaDSH
	tA7gp+TA/6lsB3bCuRHxPowvPDOetRLemjl07pi3Bl3OW1KTSBTnZHCKxbxjA02+
	mObaeoTzkmPRyHsVoylNY2eMtkUcyh1evqsPF8QsiNF+NxDxHWIHKaW01aelUnol
	IR9NTf/59n5cIsL3u9i/M5kUgfAzejsJ/9emGImt5kfIVZAV8Ja5jbfQI/dZEy8N
	73qiSASYgS5KerWIJnVSXLkvlKcIFzOjSdIzuH1I+vxw8bJj+wBAJ0BIx7Laanxc
	VbvbIae+CVSoxCnXiQdjAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1781766644; x=
	1781853044; bh=ezBmn6Ch2740RXeVdRGO7pmxAKKU8gs22xpfn/R9Rg8=; b=P
	Sitc5kUBHPeyWadI2pfLLFTX9aAsfq4E5S0ZNK9ZCXkiaIEw0DwuI5ZP8e/NYpkz
	7Hu7wj3sMbeFJQHrDrERnJaYSSOZRNh2xq4Thplk+gBF4G8/HgLXmihos+ee9uJn
	QurT2GcAHgScVHEWyBBRusoocUqcuJM+YLbWC1WYplIs5LgsSQKBjOS2p6TLF91v
	rqPmngA+p12eiAXYrdOxRys63IdWkkUPXZEH7hqD2X41bT1vzy9AvNu8bREnjyiX
	6UZL85T50PfR43lKnOcwmtBXK38cpAVzay9Tf7K8loK0ziNJwkg9a/sASpBkM6se
	hQG1NzlqZ+zWdeVLAFftA==
X-ME-Sender: <xms:9Jkzaqrdvcu0nSgCBSCO7YeN-2p0DG2cd_s4WH73pXPG-TZy91j9HQ>
    <xme:9JkzakhsufVeNY5ebHUkFVamlMqPR0YEIl0SxygQZnacl649k5JKqqtEsGf9wHV20
    PhD0f9eVwbYcuPUX1Ljnwaeu-DofXveNXWl9WWMkgnEh2TirAXx0Q>
X-ME-Received: <xmr:9Jkzaquxr4JVgY5KVObc3RuURbth8bUkAAM581No3MOvi8bDCQGuRv90epyFvd0zA1v3KZKajwPP8iMPtk5LLN3YZs083w8L>
X-ME-Proxy-Cause: dmFkZTFm+WEmxeMx/OknOh0g9ZCjcoOamCqO1MK3LXMh/yklSh+GO/OW/63uJprpFvq7kP
    aaMlAEYIbeCoysaSZ9sk52AEs8+3KO5Pe4cIvj9G4+xi22JxCI/OsKpczLxvVvQDLECLwV
    CPUmZ297xCyZA9mpopsjJuOpfrPKE84SFdoF90BUJ143zJA1LV8w4/u4XXnXDo3+Ie+dva
    9DL3T8zGpt9tS97gjA04YKki7p5UHVQJMZWR7OrlQP9HwRXGO0ZP4lIMS13sIhWz3O7GMX
    qVD9MvNHyb44r5JlhGJ7X6Tz9ErRisWKurAvGYJLkql2wUxFBqzcdEm4J3UgoWD/+4/PEa
    je4Z9iOs3YFsy9fupda839LWSn5siy2Zh1L3PxnfGHNqGiLOQoj4ytvVfH8kjiZPYh/9ky
    2FmjiJWq4nMejcHVRMQ3J8EAa5rKvbg2CdmoC+tGCHAEhj0TM8asL08VKtPP2+Nf0Z58EE
    ZkK0preG/koMKl7kpz0dqjg20O9UXZb5NEKlpijMHMei3vALdPwBNRLUOdtl4w4Ur0vkk0
    1SUU5xA6IEbywxG4aR5Hedd0UiKEAu1jZbDY9jHTpzAPcGT3ht9bFcPLEaRKGX4sF1MnBn
    l7K6B95oG3xILz1pZMlSVGflwrcYLgX61v6gaX3dLwFJznAKip8YTCT1EmTQ
X-ME-Proxy: <xmx:9Jkzat0xheXVBMrzCPJ6elbLI_COAmrHco6fgSl_oP0DTUkKzEKkPQ>
    <xmx:9JkzahyCqn2mAO_AtGuOFQRTJVBIxSEnQ3QnJIFK_c72eUrmHvKDcg>
    <xmx:9JkzaoUkqqwdg1ZQl3PSlXzRxxUcY9082CaqxT4eQTdh4nFNoWC0LA>
    <xmx:9JkzajAsp2sihJmB73uRYQIxSREgYBiPPvqCJF_n5i2x_z7GCJ78jA>
    <xmx:9Jkzar8VcYsSrLtNqHUyT6K-AbL7GCkaYiVesnLI-l9CTQ5uxLqf_w13>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Jun 2026 03:10:42 -0400 (EDT)
Message-ID: <13f3b48a-4158-468f-9afc-943180364ca4@pobox.com>
Date: Thu, 18 Jun 2026 00:10:41 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 6.6 000/452] 6.6.143-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260616145117.796205997@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/16/26 7:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.143 release.
> There are 452 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.143-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On two of my amd64 laptops, a Lenovo ThinkPad T14 Gen 1 and a 2017 13"
Apple MacBook Air, I tested 6.6.142 + stable-queue as of commit
b19bf37c38738ddd7047ec98fafdb87eabceb193
(so with all of the post-rc1 changes as of this writing).

Both of them worked well and I did not observe any regressions.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
