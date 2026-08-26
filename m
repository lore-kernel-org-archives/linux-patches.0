Received: from fout-a4-smtp.messagingengine.com (fout-a4-smtp.messagingengine.com [103.168.172.147])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B27C37C91B
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 07:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.147
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787730028; cv=none; b=KbwkRhh3VyiPKFWwbMz1zY7WMWrXfT40elF6O4fj28jK64R6rlYAsF4SVtp3pwmytDL4jxRMpvOABoL5c//sTAcKqfzZrOFsWL93EULEMz41DgttB65gHbyYQaUTFp/iZr+uEwi8R5eNgP+GPPIN68S1hj407RhVUnx2thjTHdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787730028; c=relaxed/simple;
	bh=0Y6lNv8yRFyMDVkcYhzbm7/wej0rCZSI/G3m6TdkiSA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fILHQeKuicRzzXM9vTjmrKGw2Ma+/lH2UoEBK/NhAw8P1cjmCOTsgSBg+koadnFubhYc4BP4H/Mmq9k8nxMiR3mYKRh+1865ZQrqWOM8vDWcOKCzO5Mv4PNW9by4ieQcnDyGZqhzBWYlcuh8dDoqVYehwcBtTRHSfjqpKxGmwDs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=z20Bdz3F; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=SYDLBsc1; arc=none smtp.client-ip=103.168.172.147
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="z20Bdz3F";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="SYDLBsc1"
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.phl.internal (Postfix) with ESMTP id 26050EC0268;
	Wed, 26 Aug 2026 03:40:26 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-05.internal (MEProxy); Wed, 26 Aug 2026 03:40:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1787730026;
	 x=1787816426; bh=gYkF66y1VH6D7L2hqhmPSsK7H+m6yzKGWs8wQakL/nk=; b=
	z20Bdz3FB1rkJ1h/h4pjQbTf2Jtt3eJAARL9F7I3wFj7HmcmRKGwJi7mGXQ1Tibm
	Zqi7d6nvm2haXkCY6NWfMIWvz+nD37LcZfo64Mute4ppAVYSSURc4w9ooje1N3QZ
	8WgNquxSTtTpKQgEqUCTNGXZ9qe26himY73gXVox/7G1SdB790E6ZyXEeW0tUyVv
	cgiC351SPr9EGlAsmaEvaTEw+PAP5DlWfO7zfXdPr3rFTLoer5uViEGNKn5CVzYv
	iFUL+Li5YsFN4GgMHUI6Fp1v50w0mBddg6hVRfdjCKWgt0sB0681PlvcG8noLXKq
	EOCoxP36uKm2dGdKArVQdg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1787730026; x=
	1787816426; bh=gYkF66y1VH6D7L2hqhmPSsK7H+m6yzKGWs8wQakL/nk=; b=S
	YDLBsc1Tqt0zmkOY+DaRXGJ4euvOFu2pXXzhkhb9wKsYlPidaM1mmUFyf6IE2GpT
	In0M0VyEHqkXI7rFfJ5AsIbXKomZVhqIOzPCzQ0Dp3Gp9B8kG9TvKjXuyZdJ1+/v
	Dk9PAWDT/3KbyX81SVdqYwO6KK0eeAnx0RUmEhZDmQrg1VvFV1gynXYExe1026tW
	TYvfTqJhc6ljnKwRV082U62o1qnCyuDVV8VOOhEaf9W23CepSsV9U8ElXInuorqA
	PxZ3z4Twxc+DLPWpc/c5dUz+Bg9oWHRmwFH7eNJMdyjibdN9YetWW+MLGLkChz90
	9+CShdNsvuX5rlX40U81w==
X-ME-Sender: <xms:aJiOanyTz8OxbDP_STyniKEwJF2IUqFx39qayKUGaD4wd7_SklhKxw>
    <xme:aJiOarKCNjjNU7I3-ndioU2vTYlCM_bhKMiqmB-SVcInyuXl0qddBttRlDKsqGjeT
    GnYdmEkpQlyrReC9YSYXaSQlH_7Qe2Svb13hZZGDFKM8QtRbQX2xQ>
X-ME-Received: <xmr:aJiOas14zcm6M11RW3t-tKje6oeUvs21DvriT8fdZvV5ycq5hcpTLspk1RO_RnYaiRGssptXFue-kVQFq1HQ_VXi_oF1-n1F>
X-ME-Proxy-Cause: dmFkZTGX/FU9CHFN+FvmpI6bOASM2ulWc3CTGkJmmkw+3Sfbnzro5rlnWSRb+khW/Y8vdR
    tVR4MWralH43SnDoRs87R4nSqYTMMbYYoiDZNTOIvnJR6P+tesEOK1EHD/68at5mEkdt5j
    46jy9mcEiVK7v4UXoQcDnMb9alL4eV7IOA0KQTgC+k4rVGJvOp+QQBeKapCpvOmum5rehb
    9MS5bAgk8DzmVF58/JpgeKbAoS1WYMSw6IwFtTACa6woZ/CxWBqZnmYYRUBLdf5hf3r7rK
    S+N8nQd0VwPpwBJ6CxCY4VLG9pUE+PiCrHFomJI4ZUl0mfzI/yZeH3uqyVJz8TcbWSNrYs
    p2ucG6tPwNyQflH4CSHBj/1WaBsQfGk7Qf4g5aaXQkMqnGmchT6HQ/XGYL3LJAmRso+1k4
    WauKLHWoGy8LlPleXxHENguwX/hwYb127KKW2k11PvXgQshXO3ENUWZOQ8v76GkUGa1UuY
    PmxVKh3WARW8x0Gbr4d5PH+T6G8z4f4JtY+q10BtQsJtfnzSD7UBjVX/u0SL0+tUxqSmgS
    jjUacuIS9ibD5SXcjmuqJkeZNkgM+7toptfyFZZGg+esrrlDvGRkPNurG2am8AyhUy3i/u
    kOtYUMm8r8PKHnHAbhYI4JvWKLbgpDZcOFo0MKjhYRmA5I5gKgkxR45zFriw
X-ME-Proxy: <xmx:aJiOaleHc_00nk4QoX-dn9nJqphf2q4PtftPIZ8gxGuoICb2BRFoJA>
    <xmx:aZiOag6DaGetf1QlbIHTMt4PMXxyhqpY5xw7Kt2GV-OGBZ3lgacQwA>
    <xmx:aZiOao_3gaKo1y-SUYAyWkDQOnv81ZLstMzPzYwbvkbzbhTHt7z8Rw>
    <xmx:aZiOanIDXznxwm1CBaHOsOaM02DH1RAhzDDT1SB-Y0KyktG5ktGQZQ>
    <xmx:apiOaim8QZJlg01VC1hyX2lfYC3EO_YuO1fzt5DSophOtP2WG-DZYfBk>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 26 Aug 2026 03:40:22 -0400 (EDT)
Message-ID: <dcfa003d-0f44-4e8c-8bf2-654794d69fc4@pobox.com>
Date: Wed, 26 Aug 2026 00:40:21 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/76] 5.15.218-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260825132541.568214149@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260825132541.568214149@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/25/26 6:25 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.218 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 27 Aug 2026 13:25:02 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.218-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on an amd64 laptop (Lenovo ThinkPad T14 Gen 1). Working well,
no regressions observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
