Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E6D91BD9D0
	for <patches@lists.linux.dev>; Fri, 29 May 2026 10:20:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780050009; cv=none; b=o3gSDhHtlSdekTMVIcf7vKTe7WuzV5+1S44Hzr4ShHQobKE1UZjWqXhVhyzVU9nFCPz6moPR29dqSpGuZ9eXhqpi66b+vN3T7qNJuz9CXkrWfAnxv/qgR11ZDJvrIG1cqXjHmyNv+0JPoZCzWcblDAcLlkxyUzNhnig55BWagYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780050009; c=relaxed/simple;
	bh=5GkvrOEVrrgj4xkZo2YTg97BZwgNf6jIcim4o42INkE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JEMs0355F75wn3xRM2VwjGNw1xdIP5PcmsoCURE/k6fLgpesGmHkOtrRm+i+5LjQufvhsLomgu57fMoT36cbT2iwKk1yHsPJesJdMjkWfcJkzxErUGP6FIWy+nLKGG9UVzblUjM0yFUj3tQLStI2+WvGY51yeiy266K/YBwhEO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=d9WFWxBR; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="d9WFWxBR"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4903d730b1fso69822225e9.2
        for <patches@lists.linux.dev>; Fri, 29 May 2026 03:20:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1780050007; x=1780654807; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gy1s+h/9sykmj9i9LJ1q2CWHRar8R4Mwrtm99ecVF4E=;
        b=d9WFWxBRZwMb377pFSPrnVfXQsqZAnmY30cosxeU9ZQPc0F4lwqUna9ACzxkkPjK+B
         31RoPXfJd9HhXbMaVhp5eTvgBQ5nfeOOc1XRM+TFMgAJgJBgVBj/sYh5XRWFopOX0JPE
         jp0Wq6tn1n7+qEFU7hCRbE8l45JVKCBrEd6HhZ6k3nchbF1534XsrvpjZ+3H2Xj8W1mR
         bC5qtS8fOlxOhTfXVLboHRGk80vUFnB5rYfLkaLp47EDRXsTRPvYZR7a/bkkC6XoUDb+
         mTtY0oXYDjQ0A6rd2TSlgvVZzkL8kXjSSjKLVVLXVi2/sD1eC9ZcQCHdYaYpKy4Vecoz
         hw5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780050007; x=1780654807;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gy1s+h/9sykmj9i9LJ1q2CWHRar8R4Mwrtm99ecVF4E=;
        b=g4FdEQBnzjNAFprtbLmIhVGrBQHDmj+zbUOo8HArhjUlKC0t/R1H1QywAdGcM70apW
         vsU6SKgx7jBOzyi3dM9gXtYvVxH526j1YBcQtcxTcb+xPscFOk+pkveGHjGerGqu2gtJ
         jePVl/z2xTNu79I3EOJxfmjFgwCtUVkYs1cSrZ5P1sFHeMMHdS76wGM6gEM46In9p0uL
         9prg/bLTSRTRTsLvJYuFCJVfOnsKXbGvGpc3DFplZ579l/mCTa6n0qo5uyFQWOV/5WHr
         em13sUv38MCtVF+VQOKJCS2QbCbFuObkYfD0M0mC1mbW5PjPXW+kpeUFEhwJ5Ya2RBOk
         lnpw==
X-Gm-Message-State: AOJu0YxGUq6luP1En9PQE7boSqCKJIiZ9glx18FkwIVPid7S6CWo4d6w
	8TMyPzINPm1C7EdIejVYYmDdQSaCrIt4dOzle9xkJqC0jULTxPltIOA=
X-Gm-Gg: Acq92OHuprjex6e2YXIJfjYHxZiufQw4HEFBswMzAca2nQzenH/adGcwWrJCZcZ01/H
	vvn+U+TER/eeg+H4ZcXJfc+IbBqLdrIhULUF+bKj73YsytA80IdDOMWrHXoBXF0Wmj3Op82Z/td
	qqpg7AFP5oGMkOPFdiL3dNIIX7esO2sn4ODF6acEigzfDKHBX3GpAWIFiNH6Rgk6OrPAO16mPsT
	0KC3QVhUH/SawNsBmreTg9T01Cmg0i29ZrGS1I1j/G43EBseZ1bOOQTHv+B3ZEJgl9U6FNp+w9A
	QJngJN4eYeKqT7VoID+J9NRYVFWqd/0fU1sNVgK7Pqg292jAOtRn3J6kV12bg8vsEK/6hdMxbI3
	6RKUGNmNsncV3uzS85uMuRckJ3aFAaMzXTFk2u6q6DPSpv7lPY7bxyI8wqQKhe2CGl+DXPt3AT3
	cyGddcwQSCZEzvJtI0EV2oRc25Ef8SPUMmGEBgoPqEOKwYrt8RCh9bdcpaB/pMOiXl2XxEe7/di
	MgL8abP/FH8UQ==
X-Received: by 2002:a05:600c:1605:b0:490:50c5:8153 with SMTP id 5b1f17b1804b1-4909c0915a7mr27933515e9.2.1780050006496;
        Fri, 29 May 2026 03:20:06 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4ac5.dip0.t-ipconnect.de. [91.43.74.197])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909ca6575csm57437315e9.4.2026.05.29.03.20.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 May 2026 03:20:06 -0700 (PDT)
Message-ID: <8e0b1caf-0fda-485a-9d06-529ba18ea79f@googlemail.com>
Date: Fri, 29 May 2026 12:20:04 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/186] 6.6.142-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260528194928.941004471@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260528194928.941004471@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 28.05.2026 um 21:48 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.142 release.
> There are 186 patches in this series, all will be posted as a response
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
