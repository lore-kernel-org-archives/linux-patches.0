Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47B20154C12
	for <patches@lists.linux.dev>; Sat,  8 Feb 2025 03:40:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738986035; cv=none; b=BsVkHIGENqhvzWjujaHSIQZ/B9fz6jSQfsQDmRMtvQKBRqgXa1skcgYQg2pcGatWFKL7mZehfWexfhwU3B18tpdhfoLSYwA72UmX1nZwHbqo5zJNNwhKLtTIaFfKV7q+1lrowXWjeCztKBh8Baw2hPV8nCqSGUYE6WiQmTyqlck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738986035; c=relaxed/simple;
	bh=N9kaOwokRwr4iyVgwSq5BDPO0g+y+cdxPnlkd1dmLy8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PNQkURR/xX3KTGfUDs7pzL8tYBFZFuRK91VkiwJaF6YebtXy8+4MyODWYI5TQFGXzplilXFs3NDfWM0Fh6jLy4nFyjj2n6zvCDGvI5EtQbkUq7/b2P6L4WdCDepPMQtzf3uvz6w+QCC46pMjNr8hT9Me1mylnmD2FRkSkAd4faA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=k/Iv8wcC; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="k/Iv8wcC"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-4363dc916ceso22767785e9.0
        for <patches@lists.linux.dev>; Fri, 07 Feb 2025 19:40:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1738986031; x=1739590831; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=q/MoU3id3BrwdX1UH0ylVsZ7NUAgFe+E3+3PemD+rI0=;
        b=k/Iv8wcCiFnNEAnWuPeayC9rObk19LabOxsfK49EtVhCEBqW4qXW0IMnWOPVt+rZgM
         C25JqPQ9LHFMlI2HrCHIVJafzoCf1HjeBn1M++H1T7SMOrnpkNv2W4GwBtr7VhN+KbMZ
         WZ7KXnjYPGi5gRADXFDcwqb4X9lCo9x34+50xChZ+B3ydkxD5dLjmEYWlM+lhhPiYASl
         ry1UNjdp66oAmC35LqeAYbTmOhDgJdhe+wPhF9I/FjXov1JeWvChyin4KGw76q/WXSVz
         JhmdKk1yiNU9+RY7PcUN16fep1IpSfh/wlm7qWXDQRau842CEjopEIFBWQB7LsT2p2cU
         toQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738986031; x=1739590831;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=q/MoU3id3BrwdX1UH0ylVsZ7NUAgFe+E3+3PemD+rI0=;
        b=BHe6ICw3f6lMRNyDjbcKvsporcpy1JV1VdoVdI9ylpuDqUz8pHVXrJHG+XlI0AxXSH
         FUF+7p3ULcTplMp9c8Atls/fX3FpiA/3dLItJ1K+YbcrRrE9bSxkbLbmDsScZ/aLfMwZ
         3f6icEy2tEnWt46qnK8bsEoi6JHWgnGWJHzwSt8E4ZI8mChihhdDhO0UPTs0aCtKKW/W
         HQQLobunhZcJDlwwokW8WrVEYmclpiBM9Xu2GOUAccfEqR82+vSo9Tlvbjxb5O9n6Zxr
         73XTcXE1KQbQ8QND0ysu38yQLqkztXATX4oevwxupA3c3ccNwPVWuxh/xlFit1qA8bl6
         qSsQ==
X-Gm-Message-State: AOJu0YyS+/yyWzomPYeDTOKYscKOjwyPwIxjgbGgvcO1CQotlMGT+B4f
	Ry20EsTFSyuqQKWCfnc3P2lOd+83vCH0/w0SVWHM1TDERh783nc=
X-Gm-Gg: ASbGnctFSefZsueoXys9HIMX1SEySwip6cc3nnMmWSrVhOyB+Uxk7KtgYEJ04hDS+nQ
	v9hQ7W1Eft+i+/OFS6oRSRMr6blgZPkL2nbTJuSMtE3T0kURl6m0bMxYRAtG+mbGfIikxE2XUyS
	pcj2O5F/jhmq2iRTEUv3rh7ACdWnUa/5P7u/N+uPKeWrn4+jKTbXW0dVDtrbMK3pGaAB9OiPWHV
	01izVTcO83g1/eucc1wZdOXEbZkoAmJhNxgPCBtZD2VSm7uhgKRPPoqvC4i/32W5CuPWRQVjIms
	QiwTNFk8+9lCplE6/fBveRkFmyibjOsbF8cXibMwkuJH6Np7v1vHUJDWqWnFQI0pAq4n
X-Google-Smtp-Source: AGHT+IFcoWeDsRNdVkwNAsdBuFf9X9aBBZeb+1xqBEK8L6mmiiRZTdSH+s+jTYA4mu5Yzzw+6E/37Q==
X-Received: by 2002:a7b:c342:0:b0:42c:baf1:4c7 with SMTP id 5b1f17b1804b1-43912d150bbmr72193195e9.4.1738986031443;
        Fri, 07 Feb 2025 19:40:31 -0800 (PST)
Received: from [192.168.1.3] (p5b0574a7.dip0.t-ipconnect.de. [91.5.116.167])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4391dcae8f0sm71285495e9.20.2025.02.07.19.40.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Feb 2025 19:40:30 -0800 (PST)
Message-ID: <390d6183-6d30-4e68-ba32-a6cb99ba4083@googlemail.com>
Date: Sat, 8 Feb 2025 04:40:29 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.13 000/619] 6.13.2-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250206160718.019272260@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250206160718.019272260@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 06.02.2025 um 17:11 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.13.2 release.
> There are 619 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
