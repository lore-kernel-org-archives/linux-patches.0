Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1BAA38F95E
	for <patches@lists.linux.dev>; Tue,  9 Jun 2026 04:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780980630; cv=none; b=qc3Zg3GApu1edCjN9PElVQjmeY/hl9+axr4SI42HdBrb67oBXkwvxsAhERwFOE4QcZtVQ753/dR2QmAajSWa4nz42LD7+06cg8RdHZXyzuWRom4dq/MzMwcBP2CCGX0TVmtlrn5Hhpwx1GmO5N5K3x5HlgASL9PdC6W6DTGOipc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780980630; c=relaxed/simple;
	bh=VsGvokajNLEtIRfvYG8Z5EIicxWUJSH2V1uEv3ED6Sk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AjjczIcuSer2wqFct5AMzUW2Er0qGaX+47j4wBh0MKMY4U5AYtEX+07249h2FVxVVeNfsCioA+/FlcZwgLa3F5bvBn7EScJvOZGVb9Ib9uYd81DAcKhPA8UWNCZ+/O85M9Rmt/NqO1m7RBI82yRzp/pBfnEU/yQXoA3OJGgu1Gk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=SsQ6VpqY; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=FmM/QeP2; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="SsQ6VpqY";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="FmM/QeP2"
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 126D41400138;
	Tue,  9 Jun 2026 00:50:28 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-10.internal (MEProxy); Tue, 09 Jun 2026 00:50:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1780980628;
	 x=1781067028; bh=U6fVgw3xUpv4dv/u/VdsCELL4Im5kQGrsuGuzZxwVrQ=; b=
	SsQ6VpqY0vTof/iQCB1BqPH+OqirjqqLMkBTSHtwxqiROIAgYUFDRzTa3HyZ/hrB
	9tMsRv8mgklQgok5ML8uHg6iSSg3Hjrcjk0lo7uj+AkzmmK3tykDlB+2uQ5F8hLp
	LVdawFhFqAJcoBbLEt+ul4R/xkHv/kBP3nVNhhRu66CSvWxR1U8rRCPvpX7K/acW
	B530G7iCKnz6veHHz3+yV2BDS66hor16USWdl40rZLCd4uv8bR9xeDrz3Jhtxo+L
	PjDrZRzHndhpseTE3rm3J1U0HvAJLEAIhQ6kcNKv692m/CQWv3dZSkaDVceV1A42
	TcFrTg9ks1A9QKnGakwpDA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1780980628; x=
	1781067028; bh=U6fVgw3xUpv4dv/u/VdsCELL4Im5kQGrsuGuzZxwVrQ=; b=F
	mM/QeP2GHeILwSfZ9ab7VB5FrWG7EoWCmxhXtduE44L9mWisKiSaFRrosLCPvfFx
	t9u/fARXhJh3wuAcJXZfkb1mAxL6Sy7XPr+t6f/zJTm7l9xsd5LUVgs4rVaRTYw0
	lNwAGphUyKItXLIiFVbkLt3VwaAyfMiZPtv2QjPivd5H1yYLfdYfyk8X4GNVtv1Y
	R2dhm0tPnCGQwCB6fkODZqKDQa18cq7GtWUDLgHacIJKYhqoD1ponRL9aztFuLXf
	noKBOIM7U99YitKPvorY1grs48p4HV/xSHToE4Nb+pRz0MxH7YtsCxBCMjgiEYxy
	hyH1MNr0k4UyvC63WnxeA==
X-ME-Sender: <xms:kpsnasw_z0L_Zixwws_qyeto7JlYTthustNebLLGfOBjjr-Yjev-BQ>
    <xme:kpsnasLAojnFbHS0Xk1_LTTqYEYJo5C6SampDCTiDNImDCZ8ALHO542_c_1DOUnfN
    jntMrt7UNBSmEfKcze137mmUBxQxeu5WQmIKJTU-iioJfamdImSqus>
X-ME-Received: <xmr:kpsnap1FZrvD0CrMll_yxVBrntmVbu7o6qaZff2Tz2Nuqkz6GaPJrs5Z7nAnlCCiXAh7nbjn219r7BcTaF4_FnXRrsy4gs-c>
X-ME-Proxy-Cause: dmFkZTEUa6kpnN4hu3f4G1FiTkMQTLpjB0AxApvBSlohHYSlR8SbAWjM4YSMJCH7CJedQt
    TFa9hWswJRBhKMUBwYBxrd4ZElhJOAwKe6c6J64t+eHtNSyoplbDlSISkgh4Id4L6ZmgVz
    CzzPKV/flqxGCtFVemMk+zOtyIdyh/fGGEBMWPYJyzZqymdcpsnSOcUq2F+4XWJh8Rurzr
    nuLvpNNbdCJpRLMTBPbVNSoFe77Y4uNRRiN7WNlaogns4uei2H9iiHZXhFBROnkBSen1iZ
    DweaBtfoYsIDG1Jk/bo+PmiFjt9n/vH/BcmDQ+Xc2tQ5qmRecZFGTarZ7CoBC1JMqhIXB5
    uoO/EFLL4Ph/9KvadYE/JmhhqIalEP0RtPTPqr4aYoosYe/+8oPZNNrsmm283UOYMqgq3G
    0grVEhaFNF38cVN/oQzvLEdb7ILAAPC2kJH41PzRUrP7o+oxZfAA/r7PzUifPiy5UUDl0F
    SlV7eQYZua5M2r6UwY9NOGPVNdHwTxeOdmvbt1GzlkV9Uekn4TbkyVB8f86y7JllZHKnfx
    GTA9VEZBdaukcxh1XeZgN7QuaFRMYU23+4AaC5LzQN6izUpB3Z7+CuGWq09DPUU5n2CJeO
    tI3RppNC9wd7Q9E6l6HjeyFp0Pl3otJ/fMa+0RIW9FV1lmFHd1tX9tXxbNpA
X-ME-Proxy: <xmx:kpsnauebRVPT5yJ0rEUqrRnQyvVDoZSsqbVnoI4Tjul6DHIOfaW3fg>
    <xmx:kpsnal6kFIWKT6n5ENFDF3RBBTR80-SZ_d08jAfll8IuFo5Lz3cbtg>
    <xmx:kpsnap8GegBZ_MJw25bkBZqbeRirMVG6rSgy5ZLmoghsXT21RE6J0A>
    <xmx:kpsnakLNRdzb2f-crsLsn-n7Kt0jI7ejQIpfCFRhni76BVibWw9VKQ>
    <xmx:lJsnagG3R7lIz3xmyoWqXwZbfMYPhTDxbUwtbAHZfj3XqfRKobz98OUR>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 9 Jun 2026 00:50:24 -0400 (EDT)
Message-ID: <20b62545-afba-403f-9721-91b5eb72ecd4@pobox.com>
Date: Mon, 8 Jun 2026 21:50:22 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 7.0 000/332] 7.0.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260607095728.031258202@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/7/26 2:56 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.12 release.
> There are 332 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Jun 2026 09:56:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.12-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On 3 amd64 systems, I tested 7.0.11 + stable-queue as of commit
bebad396ebf699e9e385a5564919d88014b7e3b2
("drop 4 patches based on RC review feedback"). So, more recent than
7.0.12-rc1 but, compared to stable-queue as of this writing, missing
tools-ynl-add-scope-qualifier-for-definitions.patch.

The resulting kernel worked well and I did not observe any regressions.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
