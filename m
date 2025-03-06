Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A27A29CE1
	for <patches@lists.linux.dev>; Thu,  6 Mar 2025 02:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741226635; cv=none; b=PNE8NA9ar62xaabZQoVvb6yDDuzxGMhk+h4nGSEydM3KGQbv4vDkkAqXPwJxLrZJm9GhuA+y2WNMo28Kd63uLdLIxFSGUedXZ07tjwkEmK1YK08a1Cf8xy0kqkrLCBFpWehZlPQE9HK7q5uCeKiClXVMI0JyYzY9etorP8RQ4IA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741226635; c=relaxed/simple;
	bh=MkJLPuKgr5v6ZlaUCOUYuEQCioPiSj2i/qCAETlW8O4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jMlENG0RrNiivqr6Obj2hGzwc+2O8T7wqi5GDPt44vxoBzTDl78mmxAdTHf6bCI33362z5AXGhs62el04lOTKbJUZUtkfYOL3TvB6kGROy8bzrwEFI6dcYqmIg0psr8dZCDth53KLOYknRg1YH9TOB8N0NxjLsqAhzXIsJ0ai/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ZFqAFKKF; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ZFqAFKKF"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-390f69f8083so138313f8f.0
        for <patches@lists.linux.dev>; Wed, 05 Mar 2025 18:03:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1741226632; x=1741831432; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Nr9fREGmxvfw4nIR4+MArOFiCvtJoUCsQdfY9QI8DmA=;
        b=ZFqAFKKFOxDPf+wav8SvyWlTWBOzxYrHV4ZlOKEm8n09GTlPfCT2OiKkgczYyvLuY0
         FM22JqwmWo6m2E1r+BeHBh6n/XdClU3fwQKz3ytPwFPi9viP42Yrxs80Hx+l+oGTlqSQ
         J3kfUyxx/JC6o10K0uuAWax5HxbPkvGxHj/35SN3aNITJWQtwM7gvV3uXme5W2zIwRqs
         3Jp1B/GKLotVg71qRihrUrF3FAkXJ/UvR9KLnSH5F0pVgd3tyBkoS3cfJS8+WLcVyFiW
         GencCwwQn1yi+bxxvPdyMtINAAJHhn7pNpjyvP/7k1RMC/9llDl8rANHCCBFl9w1HzHQ
         XubQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741226632; x=1741831432;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Nr9fREGmxvfw4nIR4+MArOFiCvtJoUCsQdfY9QI8DmA=;
        b=WLZxr2fBWhffWH13eagAMQTksVyuY0aJT9Di3DxGB3+RUAnfQJIANcnf/GL38xoTnL
         /c+kSW21Vn7QmXmB2yPojse2a3Licjk40A9PM7KyBSR1JoMfK+2u99iOtiTWKf9OQZsX
         NvCglKxKwqnpAqaNQXPBZYJimlZPL4/lrCBHXlXP5+Vf/gQxF5CAWUfsFLD/9BafpBQ0
         IDBRbhi+hnZ3BaM9dH0xbHNmSWrdYbLhlkVvt8MO42TOGl7PvnFQ9zcoBaBdC/pLhY4N
         wVcRPsGRfYCWDzlj/H3aWG157bCp4GDyDFwMuIzvymSM3Kw/TnaC9SWHGYPPW5647bDY
         tbVA==
X-Gm-Message-State: AOJu0YxqOnRBpQgy6fZX02gSg6b23lB+q9tZhMKqfnWh1tMKcK6s4rIv
	vznafDT7EWxqD087DhWIm1cTyLFpSfshZatXJqHJqk5Ei2H8YrUnZRVHrN8=
X-Gm-Gg: ASbGnctFJjAO29xWqb+ZGgj7iVb1JCLfVce6+iUdx5qN2PlEQnMsBQ0n7EicPTNAIKL
	vXuRaOmKyeGZBaxA0hiN8mIG+6coMRkJTIUF8luJXb3hWH4Zm2GFoHC+iQF5G7mu/xLo/E83gcn
	PBpmba3ivjs2oQH1Dp8qM7skDr0Z1f2U6ED61luS3T6NZ33u3WEww+fFSwfsf0fLPsgTTVXPZH3
	Fi8iHP/tCu8jsflcdc2AHyyMcVZBbVxUaHRdJDgjHgO+osTjG77AxCrj/g5JkI6PRcnSOpjr9iI
	DJlUVpjcCVrm9gAgvk/0C5xC5einxHtvfPQehJGkYyhR1aBp/4tasaxY4CZKtAX4XtMbw9R4Mn2
	TioT3j61p1t8xSnN1sAni
X-Google-Smtp-Source: AGHT+IGbL0ip0ayYFjdvtIKKzyBlCaBFpdHKVaMkM82Xlk2fjOfxl6v7fFLBx7EcQsk2xxYlEfEsng==
X-Received: by 2002:a5d:6d06:0:b0:38d:badf:9df5 with SMTP id ffacd0b85a97d-3911f736c29mr3759522f8f.17.1741226631494;
        Wed, 05 Mar 2025 18:03:51 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4217.dip0.t-ipconnect.de. [91.43.66.23])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3912c01ebddsm341988f8f.60.2025.03.05.18.03.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Mar 2025 18:03:49 -0800 (PST)
Message-ID: <aa98cd93-840c-4a32-a2e8-f9d4248e3a69@googlemail.com>
Date: Thu, 6 Mar 2025 03:03:48 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/142] 6.6.81-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250305174500.327985489@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250305174500.327985489@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 05.03.2025 um 18:46 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.81 release.
> There are 142 patches in this series, all will be posted as a response
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
