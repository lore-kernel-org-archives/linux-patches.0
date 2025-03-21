Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CFA31C69D
	for <patches@lists.linux.dev>; Fri, 21 Mar 2025 00:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742516221; cv=none; b=fVC5FUOGAAou1EPUmUPITh4CLzhX1owQNWmVna7nojhmOyzAPp+AdLov7TmVSC/AbRv72aKyug3NZyqi9KTOsU77ld6Wy0VMIxcEYql84W/yFksnxNWHd2/iF6vwIDLgur6nBxbwO6tDe2CaAl/JYPDbIOZIA9h6GyoZp5wHO/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742516221; c=relaxed/simple;
	bh=y+qdshOX5j1BpmV0Hx0ab/wbb51DKY+JGD27gPvrACc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AT7Tera/hBSuBkP7l5RV4uEu0RzrVJOrS1eGvKcDgpUK1nX+aJeTzfpIP6liH2LKUUdcxcjtWm761VGJ5/NfAXV51LWJRhOED8qy518lnqEF3R8szEUsdB+XU4Tt09Yq++U2kFFcXC00Qg1imPVClEuL6jrC4KtgE9YqdYYYY2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=KzzOneaI; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="KzzOneaI"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43d0618746bso9772515e9.2
        for <patches@lists.linux.dev>; Thu, 20 Mar 2025 17:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1742516217; x=1743121017; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ea7fmlpLthKk3IRbgavzcICTl/i2DXUodnrEmgLAX10=;
        b=KzzOneaILA+PQDa7rm8RqU8vEDip4dZah7g5Kbx1rCWQE6MxDl+6XGO5OCb3eoRO/d
         RZTATsfX6a2UzWxMm/s4EekzqA8aNNhUD5P4Ek4soWm2+/8OtMDsSCH+/z45aXDpuS2Z
         GQFPDJa+z/Xf/5ewQiteZr5wFvMgSUuU+DBiuLlNueKk56CXbEd++0HFe93Nio60tgOm
         isIBcKigksWx042b8glEkFMwdWDC7Vihk5y0VjRMLN2omlrWzdHgVg+cO0L0or0ZQg00
         XKdMdQ9T5WGZr0CdQhYZOQGPAbFsMgCTX3oNlbxhu3dy+NHCr0r6OXhkTDd/MBu73uqQ
         hHJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742516217; x=1743121017;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ea7fmlpLthKk3IRbgavzcICTl/i2DXUodnrEmgLAX10=;
        b=VcjIkQJfde/1ARQBkJPCRiKSi3T6lgDxxq5Z/Ctplk6vOgw1/0bztIIFY89fwL1f/g
         0DgKgwgbsPtCafipylgdAqSO4Q7sdCebhPxiBz9K0IAZCRG8ySO6Nw580cFfUAUv9N0N
         wteC+TgjPcWRVlmDAQKm+VrjNsd3s+uVICDjBlmWEliruKM1hKbi1GyN+tQi+0TnySLf
         1KgHq9/atjrHtEum9qu0F9D1sMlQD0ChnGz6HfvYBliOjViEKkyeL7OBkAts2si6hU5P
         TdtZmHK3JRsokJ/1Z1N4LR9GBAlG23efBlhkXkBr/b5yAT3aWNUfaiY8IHfGVcfLMA5Z
         vhSw==
X-Gm-Message-State: AOJu0YzWKCByoT3Ej0AH8YnuqSWlVrnWg9JIIBYo4YrQnlFD/+N4cVMs
	du2QXo9q62VgVIRGtWLhnbGP2BnBpt6PPY2VJTnm1kh9MBqTTWQ=
X-Gm-Gg: ASbGncvFtXybEfd29nQ/2un1PcShBTGjHmRWy0EMScupXEFhGLQc/LhAi54icTo8MRF
	FDJ/c6kSOLbbwk728N0IiXgny2igIXbCrm9MfOpDNqX24YJV8tEBkwQriJuFThuqWzks+n9dzMP
	eG0As3/W4zIs9mPwgJiP3u6wEWrgq0ORw5Z5v+hbrAzrk4AcGRvNWi38UYqdgOQA2VUuCYe8jSQ
	Hgr3b+gHlazTD5GfIWP8mgtd+6hteXhhtwOgeIHVO14Od70dStxu324CwIzIdgnFCPguTY8lKt6
	nwS1s+LQx3dZuYeRi5uGw/g1rwzvhn+dv2CZPfMwd4zMrlp2RsGP2ZuE+1WkBv8TVf3J5FBHe5x
	IzpCs0RMxjsd02hHJCcJIzw==
X-Google-Smtp-Source: AGHT+IE6XqCI9XD8s8So7VfR6KjKaItLJSu4VvrcXVucSsSZaIhiQpsQfdzwyZ8DuTkowqhribL1TQ==
X-Received: by 2002:a7b:c049:0:b0:43c:eeee:b70a with SMTP id 5b1f17b1804b1-43d5100a2camr6274405e9.22.1742516216338;
        Thu, 20 Mar 2025 17:16:56 -0700 (PDT)
Received: from [192.168.1.3] (p5b0579be.dip0.t-ipconnect.de. [91.5.121.190])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-43d4fd9e96bsm11575305e9.25.2025.03.20.17.16.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 20 Mar 2025 17:16:55 -0700 (PDT)
Message-ID: <2d5e684f-13fc-42d5-a54c-063c59610624@googlemail.com>
Date: Fri, 21 Mar 2025 01:16:54 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.13 000/241] 6.13.8-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250319143027.685727358@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250319143027.685727358@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 19.03.2025 um 15:27 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.13.8 release.
> There are 241 patches in this series, all will be posted as a response
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
