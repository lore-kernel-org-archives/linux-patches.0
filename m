Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACF1223D2B1
	for <patches@lists.linux.dev>; Sat, 10 Jan 2026 01:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768010167; cv=none; b=u0M36i6tejDKpPluQeEBPdYlOLvMDG5PJZUM5eeYoeUmIYf0bpSHPJseooIgmljK4djqrqjcXoWo1QJZa3Ck4/drku1Wge4X/bGiC5sePRJkd94EcsshRFtEKrPajBqXTO0X/BPHbmzfChoUe80U4FOBEZwxe9U4EDU5AppF+Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768010167; c=relaxed/simple;
	bh=nQy2cuwmypa+b69obujZ0+wRP1b7i0hIN4QzgRWn5CY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ENFEvAXXq8nFd+tOhuYjgH1lpehQ5AoJUrBNvZmVE69POGAAL/pAoqe8oEVuTmElmyO8hhGw+TMH7uMmuYX4+f5uLkcKakHoz2Y9tGm6ROnSUayi1QpFRkP9Mm93CbZiStynfScz5vrTbO+W2/doatiwbgiDpH4/Es/Fn/68zWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=j3i49c5k; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="j3i49c5k"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47795f6f5c0so29731645e9.1
        for <patches@lists.linux.dev>; Fri, 09 Jan 2026 17:56:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1768010164; x=1768614964; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Wr3TSbzzQ3sO/2vj/aJxD6AFf1BYqAOWr76MuklWpsk=;
        b=j3i49c5k+0Fu9l680CKewfqpF8vKQmQA4wAIrYMIZeMElUIwYyq9ycPvuAvrVbN8ys
         cfk8pIXHSu1Ou8lPo2V9NC1hta3Lg/2rVoeKBNGpbNX4AeO6gcrgNqPaTMMWj1xhyQzV
         AwEonLaWMFeBrNwSdbScoQqJIXdc6HcehkrpP6Whs6mXVSEH5XKnH1Lze3J5YPUDBNAw
         oMCYziVicAYIXXZHIlBD/v/fr1iMPEciRvUSYVovMSrJ3vJaEhVtotZzhv/aM/RWNoSi
         pMCguOu64hhe5TjCW6QZIO6M/CrhYBTidtDwLbR//zkJ3jB+TGT135caXEPM06d7040v
         x+GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768010164; x=1768614964;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Wr3TSbzzQ3sO/2vj/aJxD6AFf1BYqAOWr76MuklWpsk=;
        b=KacrDwBoPJvNehT3DHoWFfYuROBl/BXykcjsvMi/cRBTwL0khYwNl3232vPlO3p4FE
         0SmLyGSwssqKk4fUh0iOM19PHfyKiYAxgqdZV9bczK2vVyt6fk30wJW+KOqO7u8dAUeS
         IVccglTc9TwLgQueD43H4DFENv2071g8BnpNu9jvJ2+LgA4QEVThDeXmbLl6IMWpVg21
         ZMbKdD4Lmhc52qA7wUfe0CtbDAIyH9BafmjYUY/Ysk03ffpnWACkzX/7ZwNyhJSykJzm
         /DSU3lW5cfalrtkS5qbkP4gGOjkFtgp2xHLZ4omV9cIn6nxI3DACe/HMRw5atQEmY8gP
         /lVw==
X-Gm-Message-State: AOJu0YyiS5f7kc4wiasnnfHc+l9+tET2nPy6h8PQVe3B+8sH0ZSBA6Ax
	Wb1p+gBuYwj+22hDbB+FFjJOZ7YX9LcgxwLM+fe2ahLXk/MS2aGN+dI=
X-Gm-Gg: AY/fxX5+ns/cIFAZrYeEMFmeHojjimf2PJaFeRYhk0NuhzUufbdSZWR+fegQcBniOTL
	J0O8NW60xJGdPqHD05BW93U2jMUhew2TGjCPNtsen0xZ2v5WZYlhNcUg8REl9h0WSSQY05ALJQB
	bSdzRkM9DlJfjmQZZwd4+oDCXXHq716OERJAziaksc1w/uK5Y6DZx0xIWespApwRl+6ckSuL+MK
	Ca02o+24BiLGhN4N1bmPEpJ1UOhsQp6iWGmusddHraHSEJnbMkaYGDq9184c648IRQbFC4CUPvC
	PihnlNgaio7P95KVcF9PKSERVhRoFylnVK2N5+j4pvxBPwr5Doulo2NOiVqr3++9AKLKDl+5P+L
	gOmZOyKIkieNXc3m8m+Hm6uCauBwJoDBEdX+AoTZcWOF7oxrFetFluSRIsjz+HvP4zzpAIluwae
	IwFMkQywHJOma/douZ4glpLsNd1z/reJIzS96R36SVF7ygRGPTRa++8waenOhwYlc=
X-Google-Smtp-Source: AGHT+IFgVzn6Ppzfyhfkj8hZOeoP9vd0MUZOe0iCaPDfN8YaVgfHlZgTh1+eXXKLW1MIhVDp0golNA==
X-Received: by 2002:a05:600c:4f53:b0:46e:506b:20c5 with SMTP id 5b1f17b1804b1-47d84b5b496mr115330625e9.26.1768010163897;
        Fri, 09 Jan 2026 17:56:03 -0800 (PST)
Received: from [192.168.1.3] (p5b0579b0.dip0.t-ipconnect.de. [91.5.121.176])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d8662ffaasm74461685e9.6.2026.01.09.17.56.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Jan 2026 17:56:03 -0800 (PST)
Message-ID: <42a730e0-42c2-4ec8-9953-bfe55b18085b@googlemail.com>
Date: Sat, 10 Jan 2026 02:56:02 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 0/5] 6.18.5-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260109111950.344681501@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260109111950.344681501@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 09.01.2026 um 12:44 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.5 release.
> There are 5 patches in this series, all will be posted as a response
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
