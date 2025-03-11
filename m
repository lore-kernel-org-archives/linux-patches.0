Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CA92641FB
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 22:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741732848; cv=none; b=tmxivNuK/NyjxTd8BspUqohs3VztQ2KagVhtFukDnG5A7FxUG0ZFIR5sMGgPR6ogr1RiqH6ty+FQB7B+IEFBTmdJq58t4Gdz7Wpdq7pnlmmkPAZscH19AKn8p3dcqFtqxpO7Gte19pZsthqBEIlbo57RvQPFSND7aFgso+EeNWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741732848; c=relaxed/simple;
	bh=T4AmMPVFHy4fO3oFe7eoF2Y1+Qwo3p8w3QJ+kd/k+ps=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=i5WLhn4rQZDgCs1KTYYy1U3r9p/xH0YIEDQ0Kyo15/IiNOb/5uN2ZyLFOg9K1Ou/hWBz+3UxGBdU7Ani0qYFCidAh0sa/iu04bdXAW0gkFfPg0akrd7d+k0zD8dHTs2sBBS7/Ff4UaDTN4ljinfk0ojxUt21IiKzO5f34hVtVVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=WtwhGwTC; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="WtwhGwTC"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-43948021a45so51582785e9.1
        for <patches@lists.linux.dev>; Tue, 11 Mar 2025 15:40:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1741732845; x=1742337645; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CEGPWOgVfNQ1ZfxDumHE60ajETskqInTxO4liQoGmRQ=;
        b=WtwhGwTC6zI38RL1DhEe22tXX3V55A83kjIlHbdqbMCjVZpux/SjIjKG9cEAsQdZsz
         raaOm+bJPjM6CkCejmV9LEYVGM2VW7faUyPlxsV7K96vs080Y9Pq6u8EdPDPvrckBycG
         pnzEcxm69+FBB8Gydcnz0Wust5Ojx+WYXa1fvrMQUSaD4TmFavUs5rhak67usfUEHVnK
         GgfSTV6nIB/gIRvQsMksK+8jRmmlvhypwMyvwzoW5x2VBpSrg2+zXqTsTQQFqbotftUt
         Jgu/IXVqCf81r2/SVXSv3QvSNtmkEq1Ff3N+YcPkxYta3K85L+uxuYf041DGYG/lJCdx
         Ab8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741732845; x=1742337645;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CEGPWOgVfNQ1ZfxDumHE60ajETskqInTxO4liQoGmRQ=;
        b=rCX7dxoaalvG9KDz5I8o+5s51zkDUoU55LCsdAbcxlC1SnNhBjGHyKQDMvZrmh1mgL
         s/J037kFCvixY8cogGNkNtd13kinzE5WBQqcQ7Sp8KSKLtjvG1b9Ti62+sNVB1SV2q+z
         H4muoyALsewS3qI2Xow/pqJJvVHTJlmTaxWClDTq3+SaCZBSVos+NhpAlcjc+oNCC5vI
         X4lk2tp06pLJqFROlveYF4bQp83c8ItLXrMmrlbj4OLuzK6Dt4jybdJq+SOFTWGlRi1c
         8vXXds2FsiO/q7tdN6Zi3627EoMPdCGZilXCo/HGKysLQ3mncEzeHNBtJreqtffCWA+r
         UFtA==
X-Gm-Message-State: AOJu0YySYmwWg9E3IxlgyJ59FO4cl7xrS42WAS8HmwfX4Tp6EPvhNaDy
	XtEq8+c+1RQ5h1EYS1wyPfMBAE9S+OCYVSBQuhb97WklO96uKuE=
X-Gm-Gg: ASbGncvCIf+9Adi9aP5BVxKnkyN4Hhsg/OXJmeS1MrKYWtivxdjkH17dWukS6Nlz4NT
	7M8cDoiHKzSWNbd/YLgJkg6DEvzz49nlwRPZ5dNHfMl3djBdczSPOPegLTuJbIM4zwRU2wBylO6
	L5KelcwbCZ+2teaM3+eBd1Zv6MIkXESx40HgbfgPB9O8te0nLpeqlgIqulBSzVQYBCABo4AbBJ/
	wb6qph7yDoTTsjEpf28UHznggKB96e74Nvisbri412KTAMKFzWKVbKpF1+fXdIBMO0jS6ItOA/s
	aYYvwNxJJIcYM5n/oiic6anDd8ESSdimn5rNuMmhTw3Ia1L+Txcl/gI8IcPUczicLaLReSVOFAo
	mQA89bfrSH0cBGqobr7QPZw==
X-Google-Smtp-Source: AGHT+IHK+c/sNBHna7qu4NW4kaABpYfBEx6OtVltunM93j3NtyT0tJyYUqcf5XxgCowA7M74GN4J7w==
X-Received: by 2002:a05:600c:1f92:b0:43c:e5c2:394 with SMTP id 5b1f17b1804b1-43ce5c2054emr139387295e9.0.1741732845302;
        Tue, 11 Mar 2025 15:40:45 -0700 (PDT)
Received: from [192.168.1.3] (p5b05767c.dip0.t-ipconnect.de. [91.5.118.124])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912bfdfdb9sm19168697f8f.27.2025.03.11.15.40.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Mar 2025 15:40:43 -0700 (PDT)
Message-ID: <77f74bb1-89a3-4982-a937-78b990deceab@googlemail.com>
Date: Tue, 11 Mar 2025 23:40:41 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/144] 6.6.83-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250311135648.989667520@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250311135648.989667520@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 11.03.2025 um 15:02 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.83 release.
> There are 144 patches in this series, all will be posted as a response
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
