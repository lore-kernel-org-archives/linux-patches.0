Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2446422ACDC
	for <patches@lists.linux.dev>; Tue,  8 Apr 2025 18:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744137011; cv=none; b=AJWK/r6NlCxXhObknckF0t+KjgaoKTyYQFndJXfqQA2nKW05GTJ0xLlReYYHjZREuHbCzt7FuVRthNA6jUxvwZYYxFf/CyIMq/zgpN+LSEqbfGeHqWUmGkiaoBmsBv2dMUYVW3D+P4eKHCMSeu2eTSuNF33heH3SuRxRduTJmvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744137011; c=relaxed/simple;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BfZzQGWF2hymETAD90u6O1B4D9Ug5ZnAz7l7F8a7peCBNo//KRVeoMDDR0M2DtBedcLy0dJWCdJdQB+++6Ka05V/EpUeXWKZqbe7+EqLj6yJ5u7Wpb/U71j94tMDwcUhyV7QLsQCg9tVQj9Ghu7qzVz3oD+ZVlo55XFZDwLNYO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=inUK64hQ; arc=none smtp.client-ip=212.227.15.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="inUK64hQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1744136977; x=1744741777; i=rwarsow@gmx.de;
	bh=HtuFhXI63urBA3dRKYyXQ6GHreCYVeNttV6YM+zDLlM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=inUK64hQV6HkN/kDU3G5FxtNbI7gp1MMDMhvgzq7ygGe8RxMbJJC9gTwsx357JVI
	 vYfsHMtRO8UPclzQ2UNkK+MQKvl0MFkrQNJ39qlMV8FJrmgnlo3iEss8vIh0r36XZ
	 Y1lci5keNcXty421+tipGcm7J+DYHU9Wjh1YciIuNuZBzp4ZJLkQzVz1lhPeuzKLz
	 5H/Nq6FwCwo4hqeSNE8usFrHznBm2HnTQyklLeM1l0jGC0dR+ytQo8nkJOH0MlfVF
	 fPtnk1NurEIrjtCP+p+DLxvqecqB6KCymyfV7n7XJ5ue8bEoJn+FVCAT+zUApsndS
	 IhvCVZb1jCMmBMaOUQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.33.88]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MK3Rs-1tmCDv1OCE-00RrTC; Tue, 08
 Apr 2025 20:29:37 +0200
Message-ID: <985aa948-5f3c-4c06-8c96-5f382578f409@gmx.de>
Date: Tue, 8 Apr 2025 20:29:35 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 000/731] 6.14.2-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250408154144.815882523@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20250408154144.815882523@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:ktH0YbfbJENydWsqHGG74iFQU3+HEAd9iZoNxVC+4mYQsWVjaau
 WJmWxkr+TKuZnp0V+IgjqCUmow+3fYmmgzCXBcd4/Yn5i9akzIYxFRlJy5Evtd7mx3IwY+T
 ANWilG2pJU+2/h3TwFxw8XjofWhhSOVSmAO8wU99J8TAUJd68Ya5kAAX7fYtGPPMy5nX5rD
 uI1Db0LoXAGD7UojFSUzg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:/t7vKCRv9tA=;S7haPercSpKNHEyHGYNrtXNozci
 cGY7sTkynyNVEHBySODjRJXd+vWPqYB5b8iKcn9F6i7x3uyQgmI3ZQEuC6z4S1SSNjodTdGZK
 a8EuX8YDvb08TFdT2OufaMh7ErrOU+j5UQqXb6lfSAc0MzyPruA9GjDOOC06y41PUd3yOYjxI
 N/lKS21iYgF41VV0uvV9IpXUXUtLmEoMppUl/9EGlfID4NOBGtez45AlOWjMcehvc9Rj88Ock
 Mc6g3GGiVjXDulARkMx3QavizpkRWZJW4edgGz9ZtDV+YaoHbbuKdX6RsO4vZblAbfQH0Ulwj
 bbfTpy6t4XgQrQJQOKuqubMw9GVccn/men5/dXfrza7OtfnrkM6Tc4wjXA7BERjFP87Kn8st+
 AgAkYo0kM1V5YtKBI+MkFvqwJjhqekw8+S3gWubl2eEa2YsGemRWZluCN+H+ZolCWg2qshjU1
 eqXgE4tKhYDkR30FXanaeWy5y3WZwOHBEiQxZ+asDvnBXf2TWj1OVVO/DQy6HppUlCfGRxq17
 Zq94a7e/oXEY5u392PRb20Trh+IR49Zg5hGLFslQ9cbsiML7OWpw6KjPiQxSu0ykj1lqN6e2C
 mwADuOwixm+j2xSC7izGlvu0WkzaJBlpxF4/qtNnKgElEHN6Yf7v9V8kSpFWf9l4fyEyAR/4l
 lNaKBSCHi9tEgQIiZas7+psZzqRp8Mo9k8mQDVFH2UVOHj5ztW8DnY4vvXYJJCLePN5YIXoV5
 iP/zV5CbFAe/3KX5AKlQjwGIw8VAqJYeZ68z0W3uZ2XVwmk/+gFyyuEf40lnVk84zrc3X18sz
 nklQ33SoL75qKwvPN1AvGokRCLVVAUjeQlxzImSG673T5KSpbp8QUm3cRcPUMOsxpmm0jX49G
 KFKZstHmYMUaX/ZpxfEATvxANlkonJq7UEzgYCREdliSLp0p+4F7dk9KDrGjzHT6nc6nrbpVT
 BJLu8HLah14jOUE5e+Dy0/Vu/p2kq6nJqh33QWQR5HI3YlkmVlrwWt5bO9J4H0l99MI3C8vze
 552I8kmbm1Bjxb/Py1y+VkOGsQXxwqAicx6dBHKpZezBinPMK7eEgYGJLCs+IHbRQkcmmbRFw
 giSvbtBFDWIz5bgYW/3IUKSgKwced4TvGjXOKZ5oCNOMdib8QHakoQkCIVssgPmA9Dx8mlRCg
 0N8Fmr1a2S7V0n8uhJtL+08Qcc8X8h0/RG80W8ptVTTyMU05wBUhe/+BdAeyRfmcaAfg9DuFK
 ETKRCgoLuHbuR4zdJQA+p1zx+ua2U+Nr+n+PUS1qTu8Y6l34cgYdGNYPOQqiikaQyU80BVU02
 lKTEmQ3YYMt4JIUpH4yI3GrKGvU1CIY3GILzyJhULFB1xXxxYwvMAVYgbqGu2MGtZsbH6ZUO/
 5TPwkkX7Up9hpHZAsLoc58NNGYVpSRnXUMCDLL17Q83itTjA3dFfbkKVv9eMBNsCWsQy1iG4T
 WWTmF4qcR1ETy38HgdcFl1q3EEt4=

Hi Greg

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

