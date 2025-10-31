Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEBCB6FC5
	for <patches@lists.linux.dev>; Fri, 31 Oct 2025 15:15:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761923761; cv=none; b=ngv4tBEYfN0+Klk2Or8rK9CXRdCgkO389aD0h9ukueImHMWqz5UJd4Ow7NXfjAeYgG5PnieG4SF3i1QhVS0CadaClNrg+uAm0F/bYH+7GcFBMnty1Bk01V58Zm9FDYXaGg0wSUFA45rcMlA84eLKA5YgFcsR3qBnVYnuDTXSodw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761923761; c=relaxed/simple;
	bh=eUAb/mo9BVisGAU17xCmrbjXymc9wy6A1ns8iz/biXo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bxu5Db0fNvcQG+4NP58FqILVBXW8zIefQ+eqm0l41BzgoyoGvUF5MMz9F/b98VvSBAvQlgU0gHGRxqSaiMO9H17Rb9RBUzys/wRdjh9hl0znfgwRXIXxpE96wCKwcFtx0T8Nw5iDaxMLBed6kZtaEnrYe62hDu73e1ibsVrFPIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=IgYbKIeP; arc=none smtp.client-ip=209.85.218.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="IgYbKIeP"
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-b70406feed3so460460566b.3
        for <patches@lists.linux.dev>; Fri, 31 Oct 2025 08:15:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1761923758; x=1762528558; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Eg+6eCwAbvkcpEZ+k/S4nMUzhai7WXLq+sSlmm2fOvI=;
        b=IgYbKIePr9BhaqQPDzKxpT0H4Ain6s+gM4uz7bEgKB8ABln9FpHZGK7inv3jGytsaT
         OLnSMl5kyqSAUki90l2Y/9BBMY5TTWg7minSlLTysJjftmyT8RHfBpeE0lVUiqONrVgW
         Be6XeZA/WJNdzRb6SgM1kHCtGKOBM8KqKDTX809jLChVA2nhdnEiAtg5ZYX9sT21lcw4
         9cp953KPM6J48mkWM5deuaUFRpz59o3zIuP2NorcH2yjcnyeNVC2PP60YWTAG/YPIJTZ
         2yL3gfOrd5EkSndZnF5oS3DH1Mm+BVeoaqm00IQrTLQDzQIvvgboDdbBkgzdnGkfPvkR
         x03Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761923758; x=1762528558;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Eg+6eCwAbvkcpEZ+k/S4nMUzhai7WXLq+sSlmm2fOvI=;
        b=YcL7URHCiiqZEm0YRptHm4QPyZ9dYxSzaTZUsB4mpgKtNBXJDBewb6X9YYdTcg5Coc
         /9NeW9F/ArsdGkMGoBgigpYFLSbzijMnlK6gs6ByRz5GXBYk+n6EFhNq+JJeJLLttaeu
         gPQLloCJl+CHJ3e/s/NtnThEx9a3kKioDl6XSXI+teiECkoUB7YgE2qgwerBEEIUmYEL
         Tu8emK/QSPuKeRd55R/g+BCGFOQ8uMZ1VJfbwzfflc+GR7Ko/MSJGWc3G+ET6bfy5Bql
         lqrc0Z1u0O3/Yjg7+mGvIysMdJCss8TfRIUN91qRnWcLSVTRl1T39EQWU8y0OezQntBQ
         EcWw==
X-Gm-Message-State: AOJu0Yz7PQDEpf2EhPSdw76RRjn/VXnfy8WWTZv9LZ7mcxyROGkuSYcf
	qWk7BVgj6+gvGFxBjqUSLsPmUUAWZ4FNzv+n6OmlakHpWQrXX1SvT80=
X-Gm-Gg: ASbGncvzTp23zkvWzHbxrCsIOrkqZnUEj4cQa7HAZEvPDwE686jasAl1wCwuNdjqD1N
	GnuP89JO47R7Ms7sJqUtRQft9g9eeGxX4HVO1iAIyR0CfAd+13DP2+KBAy4yXIV3ItojtebQe5M
	Dj89kXDKekOVb07HvPzOS9bvXNX5O2J7EOGYnT/1qOPQLMyd4yyqyEh4QnpRD0DpcvH9kcO+y6F
	vYMVBp2FcBqaqqC5683+NY0z9/0/pfcWv0TH9JxRRDLdr3szKJa31fcUb9MqtF3LmfPdCFMSHSV
	PnhzZeUTtkdGvVi80Q3dR4U+VZ4G0dvZToOM27PgoczWVQUrIf7WUQSllJjww0eh9QCLl0p4AcZ
	/Hdbn4Q0jqNzEBs9AsFRcUrGMigbxFN13RqOWFLeXVx+ilNAdqhDATdyEJKyZUhBp8mNrhSShff
	h4KDF25/n9mgb6HogQnWO06ePBdzeNDzTo+kDzvMbnhHXaR/L/zjJ6ROnQ+5Vm+jUfubI3yUWJH
	wI=
X-Google-Smtp-Source: AGHT+IGPWGMLVJL/jMtX6sIhhugNOjUcreKSa+uyd/bBl6uvEtvgd2LMiAjRe4eEUZQRMBEjqeEVJA==
X-Received: by 2002:a17:907:728c:b0:b46:abad:430e with SMTP id a640c23a62f3a-b70704b5147mr429242966b.37.1761923757598;
        Fri, 31 Oct 2025 08:15:57 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac3bb.dip0.t-ipconnect.de. [91.42.195.187])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7077c9dc34sm195390566b.55.2025.10.31.08.15.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Oct 2025 08:15:56 -0700 (PDT)
Message-ID: <a72857ff-f7e5-4be7-bfca-ebfac30c37fb@googlemail.com>
Date: Fri, 31 Oct 2025 16:15:55 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 00/32] 6.6.116-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251031140042.387255981@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251031140042.387255981@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 31.10.2025 um 15:00 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.116 release.
> There are 32 patches in this series, all will be posted as a response
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
