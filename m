Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.47
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793866222;
	b=CzzXmyWu9/941JrtqNfy8lkp/2SoklVALfdL84bK90Tn08U1XrBASnmOqFbK3WCpt6Tj
	 Pr3YmcqPEsmOlpIuucccdJpnXXU1MhF4UdTuG82+u5vMufnGq3VNWrn8qLhhFSENBRDtD
	 WRDR4Td0zpfQ88xlWPmbUle3kmWVMTJTnx5N5cZEp8pqln0I9tMpBwjfmSe71fPdPsdBI
	 hDpfXZOtN/hXiByF7rS9D0iV28y7tiFiihLm0lMpPWX2ea1Sz9WWBS8k4mo/GcmwpAjcx
	 wWQUa/eqb1L5WbY2uuLtYKYB6mXDuGJJL05VLxtDyGfHD3+j1WTfbMLUCSA+7IysKkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793866222;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=eBh969nVxZFFTO6fmYWdYNz93+AyKv5QmTP2TTDmML4=;
	b=TLIVZuiPpYghYTaKrQUKJCsFRjeyGHJi1Zb74OuAOGkpmyUqxfmZ0sFKWyiicNhUR/Bc
	 mFaJc5kqLjcxp7eRNY/abD6eCGhYYP4PnZd04JAcTew+buZ/XJZepqwMQxrz+A5exxprA
	 HAuasBxqVW4uRQsRjnjWvhxFDAdKOzPOOT8OJWslEIKRFgTwSc7FQaMxrLheBXH+GhN0m
	 Y97oZXokS8y/t2VJfYx9FKJ0etiD4KfXT+4JcJd1Tig4tv9dZXefLOon2c2h8Nj0wc/CW
	 1YvTe6fvoLa7WNTDfpTfUCQzhLgShaCg2ne7ycCoFW64XYsutQGZ7R14zXw3tKeih1A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=UUqrAz7r;
	arc=none smtp.remote-ip=209.85.128.47
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A6DF606A32E
	for <patches@lists.linux.dev>; Thu,  5 Nov 2026 08:10:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A6DF606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=UUqrAz7r
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a20bde60a0so13642585e9.3
        for <patches@lists.linux.dev>; Thu, 05 Nov 2026 00:10:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1793866220; x=1794471020; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eBh969nVxZFFTO6fmYWdYNz93+AyKv5QmTP2TTDmML4=;
        b=UUqrAz7rGB1Px1rpL0FCiQ8hToBnvIksNTxllmy7a2Dbflbg7ZVyLSNghOEapA6Led
         rKIswhlFlw2ix2bI0oK1A/HQUPvG60p5mGv21wfY/tTHa/7ke15s/POH0HLwO0Gq5LMP
         xgFEU3PC6bdDN1xa09G1JiGdpOnbr2smZj2eUjq+U3BmL0R9uMUc2I8Yj9txMpaJ1EkC
         BB6W+CrQzTKHgESYbACZWYUKYgVZ6hRH8153ksyGdDClYNzYxOAOGi5griaNz5R9hBY5
         HtWQ4E5oKj18dyOEO1bDJOn4FM/LLCn1HqK+JphGiQabmXlXdBICEn1wX4Vty74YOug8
         iL7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793866220; x=1794471020;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eBh969nVxZFFTO6fmYWdYNz93+AyKv5QmTP2TTDmML4=;
        b=fqgbKTjq6DrfdhMitz5+3g/MRv84SH04D8pPM+I2awYWPDvl0dN5iAJZ+EcPm11Qek
         aolL7ZYL15K0YUNavvA6uLwb4/rIGvn3cX/D2B+d82XNk6tEDxRK8lAzrHQ0luYAVUr1
         KwEJiHIR7IPtWXxFdelsVWGEdJ09SJ47TO9aahxb+hi6YwfRZBYBHDu0KvQyGegO2vQo
         EbZSBmAuPNd/HLXPJEMo3oLdvAkpzUPSaVl/VUIHKtJgUJT5BXX8RArToGooqQ0ztiEY
         QsoBBtFfyOvSBSXjWvcBksLFhEeD90a52qIx/8yxdW3XiBAnYhGB5Ur5tZh914IudXVi
         7aJw==
X-Gm-Message-State: APuU4Z/8Ggu/JLTxJ3WlE72+eUiAKH7WP6ckceMI/Ul+DwITPdb6yzML
	4gjOAPRvVT7jQzEbvr8B5Chh7sDMLBL+b7RwkuYgTrKr85JuhyOQMnk=
X-Gm-Gg: AYBFou2bnuNsrmKGbdY+ueA5xHVws+7fq/dJs32y2AORzHaUNNPLmzEVLV+icmNbMJX
	2L3t8791hG7MHkyrWGge2rjoDaYUYW0YxxtAoPEKkYT6mqCca1jLlBMSGRG8zrL5ecgK4GnKxs7
	DxQ9Ldcjhzz7QdMTBft5mOfkPQGKhNTwCcKEDJKDKajNrkNl5chS/B6/BTv0MSExqhUK4uRQP3k
	T3eIB+QyFskA3rdCLxXML2Hq0oaZsV1NkjQ5zag4smE3h/fByu7JxjIRF6KWT97SWNHB9OaeEST
	jIHL+YQwnMgQwzlgk6lAmSUBJr7tgVUz1NT+4oj4JCUvCLVdzmj7aYd93FUQ70RNv9EFJ0cb1OQ
	XvdyQrkTRQ6Yep0HlzQsqGnmj5u8eOc255CC+/Ap0dYPWBhdiznuZZJlTAs0mOVgtXymFNMZqJw
	wZFaJ/dLS0zg0eOtWyhVf9IU9SMnQtr9mFok7JtsA3VXzGRqMaZ+aTTEWUFUTtCfGBsUeDUeEwF
	YLLfWi5XYIHmtQ2LWbRIJfLNcdq9iEFtEHfTjQLPkwfq5g/4jDqpa+L+Vyc8YKUhR6MlwHJ0NsO
	EZ/tCiUsH6kGNAAH0x38HLUSilzv2hNdhtCmqAL2Q+D1m/xposaEBIIz5Banryx+urVX4jUQnzp
	iNnM=
X-Received: by 2002:a05:600c:4585:b0:4a7:8fe8:130c with SMTP id 5b1f17b1804b1-4ac1889d5a1mr393620925e9.28.1793866219820;
        Thu, 05 Nov 2026 00:10:19 -0800 (PST)
Received: from [192.168.1.3] (p5b2b4618.dip0.t-ipconnect.de. [91.43.70.24])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4b572bba207sm43172805e9.10.2026.11.05.00.10.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2026 00:10:19 -0800 (PST)
Message-ID: <2d666e39-816a-4f38-960b-3e537189219b@googlemail.com>
Date: Thu, 5 Nov 2026 09:10:18 +0100
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
Subject: Re: [PATCH 7.3 000/547] 7.3.2-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261104211038.406938024@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 04.11.2026 um 22:03 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.3.2 release.
> There are 547 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or regressions found.

On my machine, I don't see the issue Ronald Warsow reported.

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
