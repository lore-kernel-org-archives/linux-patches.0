Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 979B11D5CE0
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 18:18:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760725120; cv=none; b=lJyth12zNDNt/ywjze5gCGouVeXaZeA+is4eAVU73jX5Xnhaz5jLuAkxy1zYAqVPlP5OkbTnPLXDHqGMJPB0GJ/XRq3XT0a5v/VrwaE/9PSy8nyXS17Ny8+eiSrEaWuwG3sk0814/Cd/vmHnQN+wHseafwOFWSRF3zSiCyO5AlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760725120; c=relaxed/simple;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i3BPKwko0VrNyZ7w5bCBu3rk1dn5ffH8R1tubCzf6KfotBvltmtoftFbPyTeLQ6W0DJZ1V11RPullvBKxxTmxXknUGgGC9wu9sdNoYyKokmKBfyTw8HBLY1yvCZ7X7qCw6vef2ymd0rO625QgrdNQXmprgwrWE4It6hpzh5U/kI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b=FIJPRht8; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=rwarsow@gmx.de header.b="FIJPRht8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1760725115; x=1761329915; i=rwarsow@gmx.de;
	bh=W5ID3OY7yfWGGgbtnZevjVWj3uINdDq2sxdewYF9kdo=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=FIJPRht8faBx6OBhehHRZKKLHAuwqAcyNCTtbIQW+edRTbojdOiuZbujrzQ0uL60
	 Nsfd1WCTA6UenKwFdckPm5fzT54YsOLE245fIP+rX8n9GrUzpOyiuI6sh1HkWmI11
	 b62FgZN+TGsELcEF75RCfO7vTEKpP/nOtNS8EFYAoy5UOdm7wjbeU1/vIE2tzynVa
	 vZlm1G6Hopndb39FbPXpLUTtXz3DJx4ygndCNui8rj3VGelVQJ52PAdnMDJMH3SkF
	 cjPr82CBQGTVaizZVaa5h/vi4lY5Gi7DCF42pQT4L8jbySvCtXikJ4vgHfJEzDtJl
	 jEJUCoXLgnLM4aNMtg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.200.20] ([46.142.32.240]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1N7R1J-1u9Nfa07rB-00rSa3; Fri, 17
 Oct 2025 20:18:35 +0200
Message-ID: <b6564164-d964-455b-94f9-cfdd5a229004@gmx.de>
Date: Fri, 17 Oct 2025 20:18:33 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.17 000/371] 6.17.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251017145201.780251198@linuxfoundation.org>
From: Ronald Warsow <rwarsow@gmx.de>
Content-Language: de-DE, en-US
In-Reply-To: <20251017145201.780251198@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:3kOseK8ejNlmnedigWD9Tm/iv+9OumXB6uQAlBGWx/trCGB4nfZ
 cxRroJM9p3ELw4J3ovAY4nniCrXUMDEiavJf3oB/VMv0FRCqq+NdqgGk9C68xFz0EAjoOEX
 lbeEXgWft18ziNLjYzhapkapySgp/UvLBytbWOoDIFlNsp8gCVq7+9aC6iK3El++GdN/oF/
 1NKJfpnah3xNFcyYEmN/g==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:gljDbobtkT8=;Wa+1gCiEDk9IOVtU8E7PyeUH0rr
 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
 pTvspZIyLOo+B8livOY0yTw==

Hi

no regressions here on x86_64 (RKL, Intel 11th Gen. CPU)

Thanks

Tested-by: Ronald Warsow <rwarsow@gmx.de>

