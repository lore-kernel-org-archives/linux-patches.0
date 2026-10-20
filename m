Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792519741;
	b=SYczwz/LG23uNkHpiV+fVScAH8UJAD0MI5wFQYrtELUUk48NaVUXptIvbNfcLLroS4nK
	 +MeiNJlHQ8ZbulHfqvlW6552OuJHBrPvmc37hqlPm1e7nmoiB1h3sJGpIBUXZQxBShjIy
	 wgEreBVZ+3Wi9MhDvwuVioQqTM+9zgTn80Gfrt4LUCEGfHrErqLmfl2AiB/8yK+5RRASR
	 cIK5ogIjefOOSyFbVmhSlKky4Wlrq1JnucshuLIh9EMoFqb8BeQYk5dEJTnSn3FLXpexx
	 MnIJlC4vrS7mQf1VnJbbbyOmYNvegDZFzSfsqRnQkTfAghnQuM2JhNuzWo8hsPFoQVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792519741;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=x3B/JDR+cURsrWXLjVWxo7FtstCSf95jnpcyvW1ZTJk=;
	b=BccnlZcKvTx0hiiDdDDLPFFxTU0pZW2MSqKgSuqBVdn5USRfvXGubEWDQ/kk7ScuII0n
	 D715RNFnMDzpo9lh7WJ8nwCilrahBDsixSgMc+IpQFcBmJIqGok4LaS4th4dMX/5UrJq6
	 lSF/e2VQdZLvmfla9cIFE02oFi81cTmWLHjxON9od+BndSZJWUoZY94gQB03A6XHE6B2t
	 kVlWo7d8UYiN0DXO0c4rfm998wxHLSC/qZYge7soP6gvpJnuaGTFOgv2lDItxuLPrHNnM
	 jBWOyjQ5Ildz8P2qZoZcGlL70rmOC+Gzg4eTn3m/akEpWTT/KV1nEHqK4PWIF+dOLsA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20251104 header.b=dqHzML2S;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 432D860A2605
	for <patches@lists.linux.dev>; Tue, 20 Oct 2026 18:09:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 432D860A2605
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20251104 header.b=dqHzML2S
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4a1e3098ee2so30681375e9.3
        for <patches@lists.linux.dev>; Tue, 20 Oct 2026 11:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1792519739; x=1793124539; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=x3B/JDR+cURsrWXLjVWxo7FtstCSf95jnpcyvW1ZTJk=;
        b=dqHzML2SgEl5UIs9UnhLXZb3ENaKED8RvSNGVCCBaIo/ViixK0/U9Q45cQzVDLiLuE
         Cy0RYpAkkjZro1WA3uBfAeWAF/KdORLloqQi7+ZaGeCgKjIfE4vJfN8hhNm/09OIUqAI
         3sQEAZALL0pCYWwrOrzqAxYZ9LcNcPioFqfvw6VYP6nK7oxGmdEFJd4r08qKX9rir4V5
         60n7mWWGztpeu/php2aSQfMv8nlI95EFay76LmwQfaN32LEDGhOZq4e/Yy9dH78V8A2A
         GkAl0p551n3jAKviMt5jNzb759vEDsuhDFxnCFV1owHn6GsUM8VInOeGkH5P6o6gf4wl
         g2dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792519739; x=1793124539;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=x3B/JDR+cURsrWXLjVWxo7FtstCSf95jnpcyvW1ZTJk=;
        b=ZSGR/OxfX/DO/FAk/lPnonOi9qnuIjWoz/ICa4PrXVlZSCt3EhEAxnhTfBapaBAXHA
         YIPuzh3E4oiWrDZ+8ZvtiCsN75MdNEi1G5ImdjdnX0KaaywbIiQzKnCowberOkFW7YCB
         M83RrdAVP41oxVJUF98WoBk8AdvYuOhg+4zyvUHPU48GhQ/xIEBJuhR7JMxj6p2Iu+Df
         AvQpefUSw4JO2ZjsGgPNlxnuZDoocKR9qUc0JLjUdV3vv6tA74dn/X49W35BJH9FSMs9
         EMO+CvuTAXJbMN7W4qmLVYRr+JWquOVoSPkdxXz+mmlSaYpt3f8pf5DKD0wFeULTvVUv
         waLA==
X-Gm-Message-State: AFq9FYJKLSI45VnuBCYf/PUT3MoelNCh1Gu3mqDKo3mmZegZtz0QTzyR
	OlP0ckKEibvTL+nsQJmGEKDDmcwPZ8Z+zg8xNIi61Y5o9c6KJYfWoek=
X-Gm-Gg: AYBFou0UGBFotHgdqq4cJc538lkRlP+fwMaAqTvxQITf+e4LhVmE8fN11ncQ1nLcCfJ
	fmlOfoKWIK2CIl8WSEVjDVQUcgo+TUsC/5pZXF30l/QkNw+3DZEqV6uU7uAT+omH2npax2ZLBJi
	QX45Wd83Rv2qplwODbdbTgaHMjJ0LhoyQhV1AvNghOQ3BdALN+BJIyRqBrz9JOlixMcpqzTNv+D
	j1YFlFr6In2jmiiV7g34blyjs7q5RKgAoD3loKWf2Or8Py+v2BaGmQ0di1ULIokNmdpuOpkZxel
	e0BkmTFEzWOdc9tOzJj9ypzN88rueY+Zc41v6MZdPgIwRS6Klj3+R3nAhNNT4Ipt6JavvSJuYQj
	U2179E7lSulGf/cc4jFvNCZAtDSMgwTa6tfCPydgFBNq+mCOHOdDSfL62YYFPxvdurHi2yMEYCc
	5pNC2Xr9cW1wbChDOlYLrpLtVWeCf88l7Ps217RDJrZNJXiEu+Jf5NUqHti5pKP3vs5bkBfKnqV
	7ovb4Xvikupu2wLGdzjt7fe9nV/B3E6ZjQzJV2jBnqiHplkbxHQXiv+7t3LZA==
X-Received: by 2002:a05:600c:3554:b0:4a0:2488:71cc with SMTP id 5b1f17b1804b1-4a1d76234a3mr246372675e9.32.1792519739356;
        Tue, 20 Oct 2026 11:08:59 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ace83.dip0.t-ipconnect.de. [91.42.206.131])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a1fb698cebsm23338615e9.1.2026.10.20.11.08.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Oct 2026 11:08:58 -0700 (PDT)
Message-ID: <bdb59552-51ae-447b-a3d8-c03d860eb8fd@googlemail.com>
Date: Tue, 20 Oct 2026 20:08:58 +0200
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
Subject: Re: [PATCH 6.6 0000/1651] 6.6.160-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261020075535.084584701@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261020075535.084584701@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.10.2026 um 09:57 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.160 release.
> There are 1651 patches in this series, all will be posted as a response
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
