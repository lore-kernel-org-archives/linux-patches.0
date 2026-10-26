Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792980160;
	b=asSKgrrkULQZ03mjjIWrUQ0JfhTuo3lmt2sakn5brmaRagFFeRvTj7A+nFmDUdeBZM7E
	 4JzNW0O5fj19RBHtFjFBuN2QquaxS+8GH0PWL1xqkUtkAseM8CRWXvcDfDYicSS0E3ezU
	 TLM72xz16g9N1SAKHlxOiR+Bdohqr6OE6K1JLT++hq8TANrObZSzQI0jgFhf1eum3TEDC
	 yaIiMTdilYTlfg81e8U3tmpDLovOcDRIuIN/8oJzCWmDuuETlQfBePgn84Bfdw2KrMh5n
	 JRBaT+oYrRmD8CsQdpduscw2bkvNhLV2m7tONP58/cDbmLOwybbT1N4h1wQ2hLBMgWA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792980160;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=CWTowxTtC6NKjiOQzv6EFS12o6onMf9gLtVaBHmOg1A=;
	b=jVYX7SpM3XdZpFtwXZTpwSYaYQNJsRhB+pKoXtVkARbBSyi6HWfxB8bFaKtRGvEWqLio
	 jeRc7RKAAMJyQiMFKS3mDjCyz/7uMjPIb4xdHkESdneesGcip+L/Z+wA1fIUsE/geOHXG
	 EaCPkQzfY731gGar+plGVYLroMyPsnMUck0ap+gfm8tkWiSychtQvC9fYHqNjBNuf3F//
	 ptXLcIbGlN9ydGv9jxaSnLVQr4ZGQTINafg8rpsykUrwLQxd8igErEysOL3SgQpWmIlAY
	 2KmtDzO11bW5VWmWoAgGJcY+v9RoPvByxhVBhscVNJjOxgVGHIrGkl2+QO+qu2UAT9A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20251104 header.b=V7VigVpH;
	arc=none smtp.remote-ip=209.85.128.43
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBE10606A328
	for <patches@lists.linux.dev>; Mon, 26 Oct 2026 02:02:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBE10606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20251104 header.b=V7VigVpH
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-4a2069b9710so23487365e9.2
        for <patches@lists.linux.dev>; Sun, 25 Oct 2026 19:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1792980158; x=1793584958; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=CWTowxTtC6NKjiOQzv6EFS12o6onMf9gLtVaBHmOg1A=;
        b=V7VigVpHB9MA1+i8egzPBZ9mPFEIOhpY4YvWTn1Omk/T/06JByh/gy3b7kFbc4e61p
         gw9VkQ2s9HITMCK2il1ovWS+9rkPL2A0AzsK2DZZw8GGuUeKA2AFPJuqyneiz+AniarF
         L7l2VOKlEKSseYJc8HxcRbn7sGrOvDO7briNmm8HHfGyeRjivL7pNJvv47JjR7r9MS6w
         +3Vwb2+LHHaQ7aQwcz1h7BhpwyAUsEnj1nHdkBM0/MoG1sP7xzmJ0fUDe2lm7ECWPAKb
         qLiD5U21Xu4LP8pTBK2GNbwyOfKcdsWRIFrcx683vtT4Efa6LfeDSAPzkyQ3XAXrLmoj
         eFug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792980158; x=1793584958;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CWTowxTtC6NKjiOQzv6EFS12o6onMf9gLtVaBHmOg1A=;
        b=Pn9NqB8KxtmF9br5RbH9fPn+g79AjMifsHy+MV2UbDA63gWvahl4QxKygI/bkyCVQl
         fcJk1x5iMg0neZFAw7e5avR8J+/nxX4cQzq6H5nHe6W79rrFuVc8LCKkwXUxTtpADD3d
         PuMU9Xujorg4TuC9bD8NC0soYyPCImrAD7q0+JfoUWfsvyfbCY9x5rZv51846qa6FbbL
         17FJaD1dBN2WJX6JigsjcjTY6Owfw2rUn5nlG97zkxJ8Yrz9BgrY6ucxkIH1rJRdUtN0
         UEwGLI3pvv0gSvX3BTMLkFOScKSnmO1kS2hoCRfMCkFcKWV+56awXBH+fLEqD66hxPoe
         zcTw==
X-Gm-Message-State: AFq9FYJdKD2cL1CgEa9cEerFyZSrDlbcZWw2cp1es9dfQ5QvOzIgEaCd
	VQ5K37fBrUSubELzMdlk//4AE0voUgXQhujrackHeEQDmeusxAQ3aNg=
X-Gm-Gg: AYBFou100qHVJSqiH+qcNBEThfDHzwgtnuuGkUqM298jAmQ6/9BDCvZb0Xrd/o/DqBz
	AzTUUxg/+/aklcuFtwzSxeB+/KQAGdN1aDmxGhP4hR0R3azrSyfGxrU5kDiWS6IEyt995mX8yrj
	hG5PPYxJwfunfWJ9sHaZl0g2cnpdGGigZePCPfNZpTzff/d4ZyqmvW/Fbluwhh61rYDCT0+s3tZ
	dE/cbLuFOLF55n6HCF7u4vCVV2pu3YRz4ewbFm4UVXlu5SLn6+PJ0HB+dvq8h+mEu3mS6MnRrs5
	UdFl3yPw6Chw0r+XW3V9laped+7bApmBl788JN5/DguWwGiCEiv2Kn2fiale6RH84HgTgZelvW3
	K0hUg3hOYtU/HR/a2UHH2zb4XpmkIKLw4nTzIZCF7lxiVNG1G4yhlogotrbmOUA0TJcVkmGaav2
	cH6yyzUPd9BaYbUVfCIFWe/nFZ+kthGu3wNeZ83oCTVyq4X+zVEJ+joiyvtJ8/rctSJBF0aODKK
	PU6FTx/xHT3he+AImwBsVwGacWNCj5hfr4QX4ZbthkjlEPv9m+V9wji/inlpXFVrH4Ul/A4fTrZ
	mDcWIQrU0RBJ3vc9qLOxpQYEBGFPQhY=
X-Received: by 2002:a05:600c:83c7:b0:4a1:e92b:ae4a with SMTP id 5b1f17b1804b1-4a35aca5824mr91169215e9.21.1792980157627;
        Sun, 25 Oct 2026 19:02:37 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4af3.dip0.t-ipconnect.de. [91.43.74.243])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a35a04ad39sm424543705e9.1.2026.10.25.19.02.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 25 Oct 2026 19:02:37 -0700 (PDT)
Message-ID: <fa9cc4e2-c9d3-4981-9701-302a8d0f4d8e@googlemail.com>
Date: Mon, 26 Oct 2026 03:02:35 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.2 000/231] 7.2.13-rc3 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261025125805.309934791@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261025125805.309934791@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 25.10.2026 um 13:58 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.2.13 release.
> There are 231 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or regressions found.

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
