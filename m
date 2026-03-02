Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C67731A6816
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 21:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772488723; cv=none; b=Z1cn5/HnFPZH3rakurLogYHwH/0NsvjGFGkHN+UMiAtnr1lvf70V9Srf3mMwzFKVyruptDJujHrk4LKixKIWmy9uBPHTL9cFqeonnXEvBIa0DUroOL8/jeLDL/XWZ3aK+Ngb9XYFcvGEjZzA+Lcw4k0I8MP4Ji2kgkWVybofBEs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772488723; c=relaxed/simple;
	bh=CzRhtzAd4wU4VveBi/RJwRJWeNd6LX+/wDJfvIcFaHk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MqqDtPs5/fWe14yo5QbZFyZX29CFrXH+x2ZXdFS3rQhNhqH3c9HEQ2Kofj/6R7k+dYDv0vx6U3EuusF55jKciApA5A42k9BFk8ignMka+zh7ICK3kv61V5Z57Jj2dXCz/HoRRuyg/JeMV6fhYSCMGQtJXW3WEBYVMgPNH6+eU7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=R+Z91e/R; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="R+Z91e/R"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-48372efa020so43130755e9.2
        for <patches@lists.linux.dev>; Mon, 02 Mar 2026 13:58:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1772488720; x=1773093520; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dNalNLjzL3C4qV4uaBCLeqrBYe/xVSNW5g5EuTk6psY=;
        b=R+Z91e/R+XGWPUZfk2tWhXqUOi7uFKmFghkKwUh6Usy3cDYLDzEfggUHgPjR8W9eKE
         CRw6euSlShIXUM/dIzEoEJzN815XbT+FsIP8weKDx16MSUdi0feI1C1sUMgW9UB7GIdW
         kWhj7NNjXfP3OH3Pk5HmSlm6XlWJ1dn/WlWBlpzCbttEuTyPfvV4b9cQQJx/1sJ9/2XI
         SMJEKUyqewgfEVYQnnjEe8ScdcjXLgSm28qriIULNMQxlusislOlH6BHSkIIhk6C/7bm
         9q/wAwHZVNzK8I7RkEAPpF1J77qRCUTxNsG62P0eomQgFu3M26fFMEO7HiMyKUmxCtPL
         gahg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772488720; x=1773093520;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dNalNLjzL3C4qV4uaBCLeqrBYe/xVSNW5g5EuTk6psY=;
        b=dVM5ZmBWwKLirv1FLNzu51MGotfTy1+6tkVjV9li9sic4vbCk+unKH/Ta8gDs3YQ3s
         42N5rA8RV1fz1apcgyFPeWECO9lxeNszGqjvXe0Aq7khCfwEnghDrzfpVuHt1BmJMM0w
         a2ctBtcHknTNeidBO9k4LNqE2qeF4SAASFvV5GY1MsM/QTU1k8FrDCmit8RT9/pLbSz5
         j48v8UgN8Sl9bvhusHkVTR/g/FZRh8TiEmGaRdBXINhmHmBQXfIseeujcrfwAKsweknU
         IcU/0I77/EZEmBfzheF9i9LtS2fzSG7atoLJ9WTG6Mrc8aMsqwYs/2pGk1jUZWwpHSc2
         t3sg==
X-Forwarded-Encrypted: i=1; AJvYcCWp0Q+Ecg3pcre6puwwuet5tv2x9Ek26CSVyCbjkTJg3Gu9n/GtN6rmmJG12m0Qwlg61+VUgq0p@lists.linux.dev
X-Gm-Message-State: AOJu0Yw7Zzn5O1PQFKeZvMcx1bsopaoDw/pCByU0x4qLaRRn/xqiE9oX
	HwEQNsWyMBRYCtS5yzv4xGUam1bl3rSbXM7n6OPb0qWEzNtjti+KVL8=
X-Gm-Gg: ATEYQzwC8rebBngBjfIoPHnca4QKMnMBe/0vZYJizeMMLOnn/RBajo+VAwoAMoJWUZ/
	81vwp6EUM+1/TXJeKmxIvoHojJsJaaDoMVM8nFZ9YKhqCa8b1nsgyUbDkOpgHHSnl414KZdBmze
	j4XvK42HCVE6SNhqqE1jtjy/gkWrRWswOT81Atc7J869s1YeoKERm5HLVp56H2REDL3jRVVBoHy
	5YBPV8Phu1JPX1YD2IyEntqqvKx7AfrjsdxB1HISR9H5sa8IlNU0RQ14QzJvHsBVukbUA0yE8zK
	4elqOVeIFkEhlJLN7dRMVy7q6UpUqi0ilJB649wpXF3RsGGChiz1s5h0U6PjceMrI0ImKiaKayg
	lIMof6Y1NL01J5Et3jdSR9r6YxZasufjBBk768xhxl1ll8oxhn9T2UEpyMn0qss8BAbSE/o9d85
	CG+HuFt2avCYdqMP3Xqc6vAJg3n8I84as4mKq5/EjsTJUPxbkhmlbP29iSFerJjiL/yz/T1EOrS
	nWgdaxf21lo
X-Received: by 2002:a05:600c:1c22:b0:483:b2a8:33ff with SMTP id 5b1f17b1804b1-483c9bb1d21mr260809065e9.4.1772488720068;
        Mon, 02 Mar 2026 13:58:40 -0800 (PST)
Received: from [192.168.1.3] (p5b2b433d.dip0.t-ipconnect.de. [91.43.67.61])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-485125e845fsm4942785e9.1.2026.03.02.13.58.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 13:58:39 -0800 (PST)
Message-ID: <923892c0-8b6b-4e5a-a3ee-4b8cdb5a9674@googlemail.com>
Date: Mon, 2 Mar 2026 22:58:38 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/684] 6.6.128-rc2 review
Content-Language: de-DE
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260302160934.2521545-1-sashal@kernel.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260302160934.2521545-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.03.2026 um 17:09 schrieb Sasha Levin:
> 
> This is the start of the stable review cycle for the 6.6.128 release.
> There are 684 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found. I 
didn't observe any issues with poweroff on this machine (it has an onboard ASpeed AST2300 VGA chip).

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
