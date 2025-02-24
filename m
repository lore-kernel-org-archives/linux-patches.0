Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1221726AFB
	for <patches@lists.linux.dev>; Mon, 24 Feb 2025 20:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740427907; cv=none; b=uFjtlZP7FBPCRv0CVIL0WYID38hO/oib8eduYK00253Nx2R8E3x0sQG6cROTf6L5XPloyRyyXfufhsDnOFPeGO5FOwb4QTyV8W61LzkmbJ5LQrNGp7QyGj1nu5vSTltrFlmy17tthz6avlNwXLrAG7xfJHACWqPIpeUQcuJ3f3U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740427907; c=relaxed/simple;
	bh=6pjgEv5jtnNy5Tr5N+52m2Y75Q2sQRHkBtqg7KUsQ/k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J2ij2JN5/d4IylCpitWifdwmPHKW9/Meh1WtoqHtHRNjNYn5yapz6efC6h77kosIvt7/gSIvIfvahPFYLl4JfRRVL51o5x9aEUpRWLFEJ0a6IggAdq2AWPBjml13XjgniFwPfVZcEydU60oOZ3B1o5EwIfBpMIWlw1gWPAwVO+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=gP55kB+i; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="gP55kB+i"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-38f29a1a93bso3852500f8f.1
        for <patches@lists.linux.dev>; Mon, 24 Feb 2025 12:11:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1740427904; x=1741032704; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=l3FMH/6OT6haPXkk0Coaw8uEZuFy4LmsF2gw0IKEy6A=;
        b=gP55kB+iCbZo9Skte0uVWwrcpg6nXQ7xo2TOYQTrOgEzdRVt0l1iqousa5TAu8wk4D
         5QPKWdsk7C0lVZcaWz7VmUNbsN7JEg2tnESrSEfXRvq29Ay+cJz4o+G+boxCKpW3PpXY
         T3VAYxilzquYjhLj9P1QxiliI6SoiY9e5NxdhUNaYomfuaMQdk+k0Ki6+0Aqpfgb9bC/
         DMkB7vhN7decPDXe4MNKE7d7iHNvyhE/zmM78ydKpvC8s0sDQvqozAaTXBF9QRhqDzZT
         bu/M3Wr8/bZwFaFybqdtGvU4MQkY47ViToDmAN8cB8XrJc7X2zHqb+MaaE5lRCYf0yub
         HSEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740427904; x=1741032704;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=l3FMH/6OT6haPXkk0Coaw8uEZuFy4LmsF2gw0IKEy6A=;
        b=n7Aa3VuOETeq7L1c8KLqQH1wX0PQfEPNnOEN50Y+fZimqJkWy+MKNdW64U85x+Hsdr
         0AJKqJ/yZfJXZzm3HPtftDdQH4axjVTcmjWpvpYcNnq2npnMgKWdN2Iohgqx2CoUdV8n
         2qnfb5SDDa+Bd3KgOwDoRNkIFpb7rZuSktH7CtUlx1pjCUIw5Pncpd7piwQxGWyyVtTE
         yN46RMr7nAK7PWfwfGri0opcEjFr4FjTucGh9jeiW8cCXDJwuP3C7fNPqQIjTBSQBhB+
         wcnbL2qRM4xRUQ0ZGQLLR6h2OoeglJAitgm1bY7OdzSXyvcbVAwLwTqoIwi7g9Xf/sV8
         dmww==
X-Gm-Message-State: AOJu0YwZOLpqkAWtySz51HrlWX/qRgqz6fEtwFn/rM4o8GgjU59VWrIp
	g8TEcKOZofdFqRuzbsG1F5SrQpTe+eS1aOfysE00x8AiL+1LMdE=
X-Gm-Gg: ASbGncu34M4PFE6BRnSmGx0S81D0BwRTyBnwPzZOA8zJZOMY0vP1lF43eSTOaifSqzV
	LeabJVTbjYvUCjdjuMdyhoJ8OLJ0Von+o9X7WOe66dY87i91NYqAstChlkcusHXr2Fc6Qk27D2N
	RWLoVSy3CIImshS3X8DP3Ac9KZ5Oo90vw2jkBGoSE5pXQEwLFUd5WYjR7L1vGCAuCcBjUa8re3I
	iresafaJknTqxSi8zGlKJmyPPsuZedFHK0F2LfscueMg/LKP2Ks+jfSAsFdSqRemk9kCpW+XD4k
	Pk3wdOOB19YgEnIt4JmnfmRGZJkg7brhKfCFRhf5I76xOU1a3bUuEtfIF1FToZlTj9a/TPRT+T4
	RPhE=
X-Google-Smtp-Source: AGHT+IHe8KpE28HGQKeYbj27ThBdPxfw/s6E0w3UGQhbS7t5bxK9YxgsSAbelbkmQWV5CiXmPKw8iA==
X-Received: by 2002:a5d:6daa:0:b0:38f:5481:1160 with SMTP id ffacd0b85a97d-38f6e95c313mr11347706f8f.15.1740427904212;
        Mon, 24 Feb 2025 12:11:44 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4180.dip0.t-ipconnect.de. [91.43.65.128])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-390cd882602sm14859f8f.41.2025.02.24.12.11.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2025 12:11:43 -0800 (PST)
Message-ID: <dec6835f-c708-4286-8746-594916362156@googlemail.com>
Date: Mon, 24 Feb 2025 21:11:41 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/154] 6.12.17-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250224142607.058226288@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250224142607.058226288@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 24.02.2025 um 15:33 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.17 release.
> There are 154 patches in this series, all will be posted as a response
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
