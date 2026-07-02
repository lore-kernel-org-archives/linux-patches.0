Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772FE3C9890
	for <patches@lists.linux.dev>; Thu,  2 Jul 2026 23:05:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783033507; cv=none; b=ISYUWfcKEVvbBG2bKPj6xo/hAZxZd2Uk6P7UgGyH85Cgk0GIFkLg7TJS4zkkt+R1CSYEVuyCNq4keY98HiVbZFGFe2y8mh1Zks92wmK149USakirg8lkJB1ZrnI5YFunoF1iSimLYL3GPQTJfHcqPJc7Nb9gkLYcN70meYRwjVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783033507; c=relaxed/simple;
	bh=Vlg9pG4iIZCLQ0P/0sDPdGAueJcnWGVsb9802mY1wUY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=afYlnGIj+xlb6Sx7fXop6NxOuwv7MOaauAztVm8veRPKyUwAGsvHa4hbTlO/rs22etTQH1XWbQcCluqeVjDP70O4hbySiEymZTjkgUN9qW9Pfjn5vodNFJ3iaXBfq/oMmfV/o0IbwvGD+3UJCKQhs8CxVf4JWAgqvtgy0PLK9hE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=atV8wHx8; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="atV8wHx8"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4938d5f86f3so9016415e9.1
        for <patches@lists.linux.dev>; Thu, 02 Jul 2026 16:05:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1783033505; x=1783638305; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UIn0YGtCcLnHRn9ikjvXBO7UGFstU2JEsQO0VjhImf0=;
        b=atV8wHx8uV0LiuWbqJXSt5j99zJVVqsWFJpBzDSqVD2jno1iDSAtXuHMr47+cjk7iu
         EC792fO2fnMERgmjkrVprwaOiNLlHGbqlQ/uHxM0e0OeVn7/cG4d+rAnhRlhzERoxHv7
         potaqKb4GnKbQV0qyDv0NALQI7asC2DPSziEvfgKRSa3V/VbAKQ89pNE64MTvuFCrwQQ
         bJBAR8aR3GFdgThScwOK9bmi9T+dlGfPIb618cCuN5lQysrGlZfPMeuli5rJIKxLlCCs
         985r2/xP2xTaCyLG2t6p42nHSqDQj24qg69L35yKmyRBgPpMFzedU4IxKRmWE2w94hEd
         ermg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783033505; x=1783638305;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UIn0YGtCcLnHRn9ikjvXBO7UGFstU2JEsQO0VjhImf0=;
        b=pvGQz4Aex3thITsf7UnI0f2cp3tJZipDxkW363CJp236HhGOHBv/JKxi0B9OiPdufZ
         A0umOlP5TuwFx727E48FqKNlpjn+wAl+ve+tJme9UnITobEqdoTLMig6tu5yxpSQqi+a
         RELt1ZAEjcK2ASrO6Ge7ATDp0n+zK7b15UdZE59Cygyqg8OAncmFT8owJwIZHDrndoeo
         F5LLaoPn6DYCESoEjbr7d7hIBX+Js+wVh4ByLs4VUZjmKnlxB35bnJS7co5FLFdQUbnH
         +BuZozJ+eARI/Z7ReoYK1QRT8L9igYd+B1QaAXGurXnQz90wSEaQKEVAA5hk2YkhaqG1
         99Ag==
X-Gm-Message-State: AOJu0Yyr/pNgAUMSza//EaUDvw4hn4I+oOy14omI/Wt7QWBGqurnp+IJ
	YdRd4uD8PSChMZDWOeBSlQktYPHPlBtspkKYrg9zGVFmJ9ClbXW/+Kg=
X-Gm-Gg: AfdE7cn1aDUcvoVMK5w8hk6/CoYGjLmFC/BeQVC6nm2PS/X4RWf0Blod7+W8ySckQYP
	Gd8v7VQ2j7r6NP75AATaP5d6gJVvijdHAJoZ7bs3/0cOCdgASDfzTXuI5prKsrT/xdqmgQtLN49
	LN+Gs2AkaVIyPoD9zb58fUdj+OA5xEK/tM54r+/Ip62p+/TF5/Q0X58rktCEjkPgiiM4yAOXONr
	BfPwVJ9xPk7TD5pxlT/Dedzswri3/5VReT4rNcIVGvsQBds/Dhg5I2y7IuX7SKWEyvjelRPc4UR
	LLMdEvi5K/oaTQYMZYmvIttKdZH19o6y7ocNIKdQz+MyM/vzdll2/KPTOj/OUEq+31yVP6TT7Fq
	2GBCsyrqRV1SmSinSmjGrryJD7AUMuNJJP4YxbZbL3UsOn2UYZny4wYvzDbhr4WEiGhUqqg8E/G
	TBW9HUSkrPFUGKgy1FXVTGMRM+bC0pYI1Fw63aeqRito0qbd/A5LkMFXV/wFNaA+I=
X-Received: by 2002:a05:600c:5492:b0:48f:e230:29f5 with SMTP id 5b1f17b1804b1-493c9b694a8mr23737225e9.16.1783033504570;
        Thu, 02 Jul 2026 16:05:04 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac307.dip0.t-ipconnect.de. [91.42.195.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493c63b6f28sm87092595e9.9.2026.07.02.16.05.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2026 16:05:04 -0700 (PDT)
Message-ID: <e7885894-2a1d-4246-aa80-8806b6c69c1b@googlemail.com>
Date: Fri, 3 Jul 2026 01:05:03 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/108] 6.18.38-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260702155112.110058792@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.07.2026 um 18:19 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.38 release.
> There are 108 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

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
