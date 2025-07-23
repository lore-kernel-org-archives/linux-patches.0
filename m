Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9878C277804
	for <patches@lists.linux.dev>; Wed, 23 Jul 2025 07:32:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753255930; cv=none; b=nx8v4mSYCNSE7rPeh/KaGk9W2uVfKzN1/LpZTT1klOJdddsR2Lenoty7CdKwYcnIxvNHDNzjB5BIinosCf8PB5RmNBgVnIcxJih/gHEW723LrVTEZ2gwVkZcsiS/6lP76Q97fIVwXV6zOhLuAjmnIcL7lZpdMtbcp4l6+K9S6Rc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753255930; c=relaxed/simple;
	bh=53FRn1dg5nX7qRA6SkVZVVkyE6GAjP4N8MbpH3Gndlw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uc54QUQGqZ2LNTtxHBjYUxeA2aCNpdLZB5WFxsq4NAXOcvVDlMNx3OmwWTQRIC5L3PppmoOVlP6FX4iMn4jW9raXi9/FqvjBTj03LM3bIIRbnkfs6rNHEQafgIwbjZ9fxgNhfIztSy1oEFHr74QOEkVrL+IaioTxJN+gwBhp5uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ieluH9r/; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ieluH9r/"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-3a4fb9c2436so3595915f8f.1
        for <patches@lists.linux.dev>; Wed, 23 Jul 2025 00:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1753255927; x=1753860727; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z/P0pFS6WBNNgY7NAWkRahkU88sfun4LTwe81ga9tlc=;
        b=ieluH9r/Zc0eFAmYY1GaqTUKFMB8HHHq04pWJHSof9QK0edHeQ6OeltzjfO7MRi/dU
         qTKYFfj/zboqStaZ7bpKdKXJp2SoILdUKH69ZY+zorcqWwEwAjrMpzWz2gRH+awyb5lM
         irvOiByIynApVAYx9jPiM4DEYcOloByIzO/TcY6f8/TO3NEBkGtz1TBf0T3ovUK1HHbW
         X0iUb9HXyMKT480PxztrcAkFPeuZCruz36efxGyBJrMz0JdPAEGsSLbKQn9yUCOGSH54
         lQhFxP9Kne6V2XnI9cluZ9mMHDd9fEeVq5iCspP9AVcQp1xueuDp5qYe0ezfGeButP+u
         7yaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753255927; x=1753860727;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z/P0pFS6WBNNgY7NAWkRahkU88sfun4LTwe81ga9tlc=;
        b=Mq/nprPMccoARfootREIQ9BffKuKR9uDQpZTYzfLNhaz4pjFackYyBUfXyXVXaGwNi
         12GWG5TN8SymxtX2F3jZC8aSzuklTDWTXo2ghgQ42NI2gBd71jrYQxQeuhMMvYl94hbu
         4vIR7I+L+/8W66g2Rzt6L43sTaWFi5xD83z++nlN4/77+rbph90TIw7lsa+ttETt7vN5
         ni2PXEgetC3n0v9VdDSsZEd/UG6J0hSw7kRbh30U1Q2TWdGnz7oU3vaYJHEBpQ4s3H0a
         zYCoYLwwA57jEeV913lDPsEk7XeyDEjbfe7aeeo4ePMx9XJGVeSpEdcPzw3JWttb3BW2
         2W8Q==
X-Gm-Message-State: AOJu0YxTh/IkMTHJ22uTNcPB3waUAnfiYr8M8yv4XJTBMhxUsu4KMIal
	+0UgUDGlTqdAB3i1t/sI3c8zL67K0r/nH/ZdPrzSD91zNXZDo+v48Nc=
X-Gm-Gg: ASbGncv9nnRnCjDvRyu/g49Pi/iBRdBcTmaY21DthbIdbiz6r9xsAoZlNJM9HRHtGIA
	NqxOYmlr7ErdInOOOvVasgs3a9dJRnYnrb2cWygbB923K6Da5/98UwJf1VZz/N+leg0OMuVLyY4
	CzD0WqFWfmFHfXhz3zPy1LXqLc+HODIACMgTJlHabIE4Q3+BnaVobYUI+p+B5ESBiVzUAMKXYmQ
	1X9mxu2Q1AJp8AIrsnv9dBPuWJlwDv1xZJxdjxi/h0/NK8+47EbvGrFI4W06/JUeUkB9VAFwZSe
	SntSMVrU2FV3IsN5wdS32gC4m8+c2sMrUEQS3KWBjTvXwaTvv7SJMhXoBD/up2VQa9aIc8A59bb
	0B9OZFeX89UWNznRjXetPUUS/aCgbRjHvJm8s6BZC01YPR8EK4tjbys1X4oDboogLbZtsZaFOAU
	AL3Iqx0FOE1Ns=
X-Google-Smtp-Source: AGHT+IFlJDf15up2Xv/cRTUYlYOXXf1nRIW3wifWm4bDqNWuGTxkTGB+WrYc1h56uOBrzbnlnF5L/g==
X-Received: by 2002:a05:6000:26cd:b0:3b6:c88:7b74 with SMTP id ffacd0b85a97d-3b768f2e446mr1325854f8f.59.1753255926559;
        Wed, 23 Jul 2025 00:32:06 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac7d3.dip0.t-ipconnect.de. [91.42.199.211])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3b61ca4d7efsm15569792f8f.67.2025.07.23.00.32.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jul 2025 00:32:05 -0700 (PDT)
Message-ID: <7984be98-e376-42a3-83f1-e2d572757491@googlemail.com>
Date: Wed, 23 Jul 2025 09:32:04 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/158] 6.12.40-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250722134340.596340262@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 22.07.2025 um 15:43 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.40 release.
> There are 158 patches in this series, all will be posted as a response
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
