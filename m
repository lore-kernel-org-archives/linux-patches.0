Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E1C3E5EF2
	for <patches@lists.linux.dev>; Wed, 18 Mar 2026 16:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773850147; cv=none; b=bzNNHN3gopffcXzFCFbrSqf12+hW0LnNnSJHPrkTRo0d0fLeNucGvJo6LqX5/jMmWF+qWpjvN4DHiB6TGB5hxkolLhspD2YQr1DUAGZqMkc/rn6X+jvm4jxx1uumt5llaDp2udl/Yd49T0je206YqRfnQJKCBips41w1/VV6Ojo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773850147; c=relaxed/simple;
	bh=/N+HEmmGQ9Y8SRoaz/nCRv885xmedvQjf6E1V2h0t5Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TpxasZAzm2huuMXl+mp4035tpyKNGNq/sIflmflRbcAh8/eWmcCBL8UwaPsX5UFnh5yNMRCVxlmh4DSWEyCRY70Gc+dVDPBZkMj+FrkOwqg0rzSKF9BvpVx8RA4s4OvIbhSvwIOD7GECzQCITmQ6z9ro2G0e77eglar8KH1qO20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Wiu1EiR8; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Wiu1EiR8"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-48541edecf9so177995e9.1
        for <patches@lists.linux.dev>; Wed, 18 Mar 2026 09:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1773850140; x=1774454940; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hbR2ZzJNU+JH65EVsLNt09FXk29aaNppPBnJd/tU8sM=;
        b=Wiu1EiR8AFTnfVO1MzRWKzBcosOTCEVaNYzg2voQpme9dlXOwUKL+S5TUBxf6AHrY+
         YEWnt/RHljIcEpBlCN/qglosZIX2O9D5fGV4kkcnHEe6kwbRFPc4le02hxcLvx02W1+B
         kBdshrRjYEjC5z7Ai+d3vTEyo9B+vFsfdHBjqVgj4ZZwkcScmcN8BPjhrRkSUm4GJDDl
         oQWRwfKsxf+kgqorK0F5odzLbv4akkqn7rSnkBGoSUKUrt+fWFYlbHkRtXQw6VfbIOQv
         Dgl1HENREJbJo9io0jhkvf4W1CzQx6UFTyS+k2ry4gTWrHri7LBIWrTv1cGaifuA9EbP
         doZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773850140; x=1774454940;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hbR2ZzJNU+JH65EVsLNt09FXk29aaNppPBnJd/tU8sM=;
        b=Ee5bJA2b5OtoK/ulEY51mO/CEWK858N6INy/TJkRU8eIckOhXby6R8kkHtOKFMspN7
         BMoP+SsRk0Iz6IwdletjmGAt6KBfDPU1s0e6SSstSz43Us9aH7vaF3SKUmrqhvGz72wU
         +l30rVD0rsPD7buGEJubTOmBfKiNmU3fvc60YUQp+bg/cQz7xMSBf+mKtsIIdP9n63xm
         VOh1dr67+o6CpNdwUgYnA5KOZPQdvwMcqol2VugEQo7bbo0Rln3C2wqGpWZbe6KLR4Uh
         NjqOBBs15CBvx9FIbnuQTgc0LjQNgTo5o9Op5dTqkf4C500AHMKJevJXgk9n9u/13HBb
         8hlA==
X-Gm-Message-State: AOJu0YxGcN+FbkZ7VrrPS3nFsFUtiGCmAvRDaEjOsiBr18ZXsXknGYrt
	2ClUQPrD+jrLEKSy7L1zLGnu2pAo1PQJ2tg7QqT5qt7B+LCqPhGasCE=
X-Gm-Gg: ATEYQzzxMXBR5OtCgR8oNvUkBM28kC/wictBWyzL1V+36CV9WxLMaiGjYAqnPrCMvPx
	myv3KNBBcIL0UiD4zlN9TK23r5D+3DlqEvnDI5Ey/QqtcFZFdxqGvJNzIwv0IQwYYL63YJF/E41
	ZP8WR8BdEdtv+pMu4ieuB1Q84NLqzzlHhp+79722ZMCHtPF8GF85F4BrQQ+Agp4gh3P7WqmLQ14
	8nH2Fa4H7XuhqpmA4Yl4q6BLn0Tkq2/DTqdmVKLSkfm83J2qw/S5G3qu2TrFnJ9W+Y4u5Giw7NL
	fJOLG7+TjPPkUyzawq3t5URHYRTQN4A0GvYWYX3RNNkTYWRBhb2P+UMwRkb+lhwzw8W0Ws1FUpE
	lUGpZJ2ytR9v0kojev/U/CB32el29cRyvMewrZYW172csDBIZsT6cBrOETFTWW9s6WCHjtixw+n
	c9veYNTzsmLub9+kMvwdz6SkXey2PW1FkN/mTZA6sbgi2oxOx8RcOyAvj8OBVq4ar2ik6JA+fKo
	jI=
X-Received: by 2002:a05:600c:4ed4:b0:485:3c2d:d02b with SMTP id 5b1f17b1804b1-486f4444050mr68947905e9.22.1773850139665;
        Wed, 18 Mar 2026 09:08:59 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ace2a.dip0.t-ipconnect.de. [91.42.206.42])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-486f8c53153sm514625e9.13.2026.03.18.09.08.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Mar 2026 09:08:59 -0700 (PDT)
Message-ID: <525a66a6-2dd9-4092-8ac0-c6d569ae4e83@googlemail.com>
Date: Wed, 18 Mar 2026 17:08:58 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/335] 6.18.19-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260318122621.714862892@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260318122621.714862892@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 18.03.2026 um 13:27 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.19 release.
> There are 335 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

RC2 now builds without error, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities 
or regressions found.

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
