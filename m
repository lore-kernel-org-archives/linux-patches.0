Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEE97351C13
	for <patches@lists.linux.dev>; Sat,  5 Sep 2026 13:00:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788613240; cv=none; b=fmgm8AR0XJOMfHyU+r8SKcUc9cTl+wKr67AlKADrsbojuJAnE9GqcSScWL6E0QxUIYkI/ncyP/tyG4UV2vSO8vTKEFX6RE/BoXlfS9KvKcuM4EiFZUCGm1lCBvBh7NZciSnzAJyGPLc9jc4hsbpmm+BjnRkmaznwI4iGB9wlrko=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788613240; c=relaxed/simple;
	bh=piNkA5IeEVpUEtbg2koH0Xbsrfj3+pV1PF7K4sR7Lao=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rUFtDlZeFp9T9hVaqdMTPI87wBjmu/Et8Eu7D3PpYeD/fQtjGpfdwSkQLhquLZjGfm7HW9DGnjmFRK8S4s5M1detKeMdNff5slss+tCXjXEb7iqKVgDEy7aWo04YBshBrgl/ZmhezRT26ZEztjv6sbfo9uKLbFfj8m/2Xu/+M44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=vsL36vkh; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=XXoqmbGx; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="vsL36vkh";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="XXoqmbGx"
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfhigh.phl.internal (Postfix) with ESMTP id F1AB2140010C;
	Sat,  5 Sep 2026 09:00:31 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-02.internal (MEProxy); Sat, 05 Sep 2026 09:00:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1788613231;
	 x=1788699631; bh=5nou6lzSYfEkGKDSoJd1XsYeqOeCd86E8osWZ3kf48g=; b=
	vsL36vkhywd225WRi8u9TNDip0UMD/pA2RGBDpk6xI6dMbnqBSYQGWefwCB4RxrW
	d4Yytof6YsNMJxq1AgcXmN+cjUImLIgnTQPcBH4Rob9ePAmJMGIIng7FSYmmhOY6
	W5RjHcOvVf0YX7/8/5f72q6Osc0SBiG56+N2FuZhAVnWoOuqNhYpgd2qNKVqUom0
	lx2jiHkG5cET5Z1KhiKdHwMDP09Idk+Ms0RUlTvjL1/RAn1hzPplRP2hAHy1pd2a
	x0HhraUc8fYEQYmKqSbblRsPOMtdQ1Ut1gxUjXdDf6kcite4nysBZdptMdA7q970
	r6PePW1Y4BoSdrWPvxJzpw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1788613231; x=
	1788699631; bh=5nou6lzSYfEkGKDSoJd1XsYeqOeCd86E8osWZ3kf48g=; b=X
	XoqmbGxk+OHJ8Ge/iBlVyg1WN/oHAr2nJWOxOybIX0grO32F3RDwgxG3xkr+Euw/
	fWNJ7tIGSO8q7hlYZkJF/i8bKKcwlb+Uk+/GNwp1qANb6/0f6Rr1oe+H8ebsZQb1
	bbJOEvWu+2KklYwPeycJnyBzKEiFAE5Keqw3cd5ZYScAdXUOPmWoPrrpIF3wayM7
	bEf/5zQd8yva0jBedKO2Beq5s1AzDwdqxZ03ImFpPj0hf6xgtewn12V4GoKVU2vk
	3+E+WE9RA4XplsyXHGkRp0ZwD3tT9nScEHuy3lcI4+VuCNAgBCJMf5wW9tS0WmBT
	FjQXKLPeQOJJ7L0H+r54A==
X-ME-Sender: <xms:bxKcajcBqKni6BUvbmWeiNnMUyboc3WHUpPcolLgsPJLVoGgyM3r7g>
    <xme:bxKcalE9V9qSXSt2qAoloXKCtYifqmvZ7hsq5aOrP3T_SGWQ8jqN0ad5BDMtlDQhJ
    ciqODj8Iv6GlJ3XKXg1B4Ubw6-G5sp3r52R2fiETRF59d5ozYr_fjyS>
X-ME-Received: <xmr:bxKcaoDI-yV_XX0_EKoQY9FeZ-6XuhT4t8ufeKf3ZahFdWU1Sd0A4PO9fRptNuuSwPj9RT_MyPwZhCJMjXFAWOYspQ-ROWQM>
X-ME-Proxy-Cause: dmFkZTFHBNUARyexREqX7yqYW+m6XfuQj9/6NwtNirZZ7RLcGr/8lR+FHQ13cjW8U+6tW/
    XkQO7SMQPRFfucYYpAoW+LRwe8Q10OcVOaiGxJzanVYimUDj1awAU7WHl51ePOWxayiULE
    M2uo/6NmYPCBPX03VZL52OYgw2HPJDFtvTbZdQLUO0dNXbCfH8Wy0HW2PykjMZX9THB6FT
    eDm3p6tWLs2aegBySa+QKMKl4tyXv06z56loD41QBvRahNyUNsDo048KfTzgx9O+XudCiJ
    E18UoWXId4fp4pj+7zQ/CgrT7kTLFwuIgLJmqjGCchlb6GKkzeeP4IaBZokdLOVLSS0oiS
    HQhY0ohK3UbDiLkK4jHcdvheh6gD61RRFJY0RcsxthHSqBvYr0d7OyxGB2S9gfXmr+x6SL
    ulYJNaxKqJAnXmlukbOUbGlbB+xvdcT+94kmQne436TMRCSbnoYYxioMSC03IwT2gShsvO
    upPh+uPFkXHV87Eyf9SDn7HCqYT+UUrpye7jh7hPYTVlgHd9yuNgd2RxeSA/0MVtjoYYRn
    RNoLGIWFSCf9uXdrkB09ABRa1JZCKtR0+LZvMuhktEJEnWjMz+d+IZPb9HIdq/zIiPOH5O
    EuJgfHnE6+UzFHtv5cWDJtDCdK8+MhmMucZhwQOjl/ykhC3hdLnpmqz8X1wg
X-ME-Proxy: <xmx:bxKcao5Iyov6i_zqSPXpWWHuxK3A0mkdid7bLGRnmvWD-CupOLD5Bg>
    <xmx:bxKcankxpMTrDIFd8nxy11lNzkIFcpjMNPADcIJXvnj3k6jwM4vI7w>
    <xmx:bxKcah5dQ4giiV7xfwGXAZ-AfNOxzdEal5K8MtOvE77h8wMl8CNOfg>
    <xmx:bxKcalW7yW_3kTSwklvqBfNBjy6riTc7S15dVjVGz0H2tCt1pNJ97g>
    <xmx:bxKcajSg2G8vygahumIe3-bnyrM2i67p9kOan6nLaaPHn7H1_ngM0NR_>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 5 Sep 2026 09:00:29 -0400 (EDT)
Message-ID: <69e396ee-d2dd-4da0-b2fc-cad1a8e77ee9@pobox.com>
Date: Sat, 5 Sep 2026 06:00:27 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 000/713] 7.2.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260904045803.810145556@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/3/26 9:49 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.2.4 release.
> There are 713 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 06 Sep 2026 04:56:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.2.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested on 3 amd64 systems (my DIY home NAS, my Lenovo ThinkPad T14 Gen
1, and an Apple MacBook Air 13" 2017). Working well, no regressions
observed.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
