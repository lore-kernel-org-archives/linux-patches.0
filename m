Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BECB8155A52
	for <patches@lists.linux.dev>; Mon, 28 Oct 2024 19:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730143261; cv=none; b=fXyqFo2bnC5AEd1U3iZgiiy+P7g+pQmgqZn4W7DMTbb8U/zpC3HYTGBjzxlI9KzReahpiVVIAetduZc00hryLljQBgjPrn6qTstcA5vCVpHTjE8IiWLblykM+lCHKq20C9xLAprpA7I+R8J6012ZySPMwinfT5q5D4YCDz2VgoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730143261; c=relaxed/simple;
	bh=F981mQfK+GakF4x7z8yIC7+kOIceY26cwCoUqATTl8I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RyyfNb7qRD+9pQP+1UA0B5Hhqjn9ut8AVYTZ+xIFpyXYUUeq3fMMtKmAJ3srwjInZRdmexllE+luQqWG9yCbLuj26W/nRV+nai/SywjFX/7quwOtmphRNWKTUgMttUL/tPgH8yR+HMYs265n0WZ2MIlD+ZCPAT0fgfMTjrVOCEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=l0sTDleG; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="l0sTDleG"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4314b316495so43238495e9.2
        for <patches@lists.linux.dev>; Mon, 28 Oct 2024 12:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1730143258; x=1730748058; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nmyfLhJgqZpTB9dOyWQs56gLuQycztkSBu1M1yDh9Ag=;
        b=l0sTDleGT2XddW4pkg0llwpzs2F1kXc+T72W8eIByYjiFqChD4lwC1ImViN1xdS2jc
         nIzIzXEMd5Fg5cZ1RoAeBhp1bSpiKtq4LHdlRHAfYZUWRsDv2qlstUnzqS3Mgp28gDua
         wz+ag0mbLA8lAcLwEnl4Mp8iQXo/oUAXDja8I9zqsq9yY0LTW9fE2UPvkaou9uRhzQdS
         mG2ahgZkQ6tgsIaRpn46BNfunNnl4M03qRrWtxr3pVjaxOCe6zUlkUrWfEUP7Vcp1hQ7
         u94PYbpQNjcUZuK3SGZW19tdLS2IE4i/eJ4bsO1rB79NbqqUre7nCAZwKdbYzHJyTYdV
         7E4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730143258; x=1730748058;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nmyfLhJgqZpTB9dOyWQs56gLuQycztkSBu1M1yDh9Ag=;
        b=DZgy5O8wTgp8wF9ZNgjnP86nI4xNnYFhXhbj1FtnwHhFBFjEX00jTCqnPyvsADaqZv
         ia5A7e6RGt5Pib83ukMIeOlLsYccuImJ4OeWJOu3oTfAiR2WyQJrFe9gBqsWR7CTO3Nv
         3E9tGr6V4BmzjbpafxdoHLTbKNVB/OgzaoTIYHv+692wlRhbQOiECzp+w8knMyLbNvjf
         bICXpJfiWuG/wNZGBDM0pMRAgROLMUtwGp5xQtLVR5SCxKLpJX+qvcdLlF2MyL8qg5l1
         kG8cjtQ6jQiLpQ90BtCuYRoeuWELoXuzBJ7PjHO0a4PdCFRdUnoiA9RQ2af5PWeE0PNL
         NBeQ==
X-Gm-Message-State: AOJu0Yx8dDoj2Q55AtjsRJpPKskbinVAGbb2ot8hZ5KDXtz15+gA9kuF
	3N3uNtc+ZvTsrJ7LbXQtZSCc1vIszq8s11GzsNpXxYHcO9FV5XA=
X-Google-Smtp-Source: AGHT+IHdJPH8eCW/evibf4e02yyUQeiLZFkHgIBy7hWOQsM3sVPbez5w+tlVulpQhfUSmgb2F6Wm7g==
X-Received: by 2002:a05:600c:1d15:b0:431:4a83:2d80 with SMTP id 5b1f17b1804b1-4319ab94761mr79671595e9.0.1730143257909;
        Mon, 28 Oct 2024 12:20:57 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ace6d.dip0.t-ipconnect.de. [91.42.206.109])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38058b8c394sm10322778f8f.90.2024.10.28.12.20.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Oct 2024 12:20:57 -0700 (PDT)
Message-ID: <7d6ae25f-0ad4-47a4-a155-e3efc6d9ee1a@googlemail.com>
Date: Mon, 28 Oct 2024 20:20:56 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/208] 6.6.59-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20241028062306.649733554@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 28.10.2024 um 07:23 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.59 release.
> There are 208 patches in this series, all will be posted as a response
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
