Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058563;
	b=kHAoJzizIZI6fav3PJ9cODG8sQOvqHLtXvsHeVMtzuyVW1nBBpOeka8JyHwgHbN+g0Y7
	 SaruBzZjG5dkrMIE7Mqo9EiCYs1cxDVm6b1vQdUapQ84hNbGNXzrZL9ywBKjJ4RegdyYT
	 SzIl06F4ThqrBx18sBYJtW0NNvNtwbNqaJB2TNZ3gVex9sGTdLe1Nk/wC8i4OStgB0bXX
	 P2+yt5qm90fKd7lif6BEsBSFqLnHdxcbozyxPLLgqfteo7uhoGl0CKE8FHUDtnTSCXJUI
	 FASCQQU3AyL9BxGK3omrI10DgvkmXyqAtcUH58OKscWUP2NpYAscQ4Yy3DjfhZQuhHQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058563;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=AKmYgMCE5Gwxj78QU1v/OC/KdP6R4MGCQSDb6SIyFlE=;
	b=PhKaFs/O+rhI8QIjvrdrpcAQByCPL7VE5L5zrEYjbAPBhXzkjMRzwsQvpa/PeshUpJuY
	 A8aZ39mtFahgDcew+cbGKHJuOHa77t8+c1wpf3xmpfmuexeyjdFempDzVpYq+HTDf4na9
	 oqlDxmw6g39ls3E52C0nvTk1vxycLa7IcvaPxOaiFixs9cG5eANNZMHUhobnOMGvHHxNO
	 YMviX69MziIRBv30AGhiSmwttB3AYNlBt7hdxYQ8NF3g5MOmuE7tHILv15Wkcf8Nwexwa
	 rcX7O+MGR2UzxQyFp7icYxc3eeYcF1Rl2REx9Vy+0WjrHEa5+30etDS9RxbTmUW3pPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=MvTgKLMi;
	arc=none smtp.remote-ip=209.85.128.51
Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C462C60A2607
	for <patches@lists.linux.dev>; Thu, 19 Nov 2026 03:22:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C462C60A2607
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=MvTgKLMi
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4a1b07c3c5fso17258975e9.1
        for <patches@lists.linux.dev>; Wed, 18 Nov 2026 19:22:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1795058561; x=1795663361; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=AKmYgMCE5Gwxj78QU1v/OC/KdP6R4MGCQSDb6SIyFlE=;
        b=MvTgKLMi6pW2xpbEMfPebxCQ28Ok54SJjBIUPo9biiyeC7Eu23NjV5vi0n7IloTGwH
         xGwThv3hwD4ttB6MULG2CH81sGcN0F6rAKA+h+OaWtKj79JkQnu/LUgsXvnp28AsSZyc
         oHxkB7uCwe/VrK23YtfWt3zKnubSuwTi63S35fivGbYcRHTXFRYKhBfV9HpMaGNqmWW4
         QUcW6lzVZK8tGGE5A+wF7Z6WusiVN7QYrKqHbEy/9Zha98py8VXpgAEfPdeBimY7rwu5
         1rZWz4geJ/bXghpi5T/1ysm2rjUgBNX9JgpiEboqHMu2fZsW/jmpXCEYangX6lVG4KWi
         9//Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795058561; x=1795663361;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AKmYgMCE5Gwxj78QU1v/OC/KdP6R4MGCQSDb6SIyFlE=;
        b=Nz92b13k/KM1BBrNus5a1Xt/gMJ3Xs/Mqwnk0isy//yum8wI0AU7nyTLnAwZxcn8Uf
         H5A5dI3rqk/xM8DXGlH02KOyhVtTtQjsy0MuBYMyqNiTVjV1yYSu3ESJX2l0cPr872bp
         W9oHmumx9pgC7Q+KVZx0DlsD3vUyahbH2tZ0xKm1n7Zqym5x+UWcplW+dgwrDfV3K2ig
         sWKi9/1S92SmIq5ygx82bnFaY7m3HbllKTLREq0YFHRC/YA53VSUgu0VXqO5jrMI1Lr/
         Ki8oZ7VPxPv6MjcgdrY3SakBrjwE98v4d8GwM1A6+6/YSZgqgnhSIr9kY3JaIiyYLX6B
         nxZA==
X-Gm-Message-State: APuU4Z9UnZ1iDh7rQBMC+0O4cdy6c7O/UAq7/Q6qHop7NNHdvmh/i3Ht
	khOj3EZxrOa7a2THsPvAoJ9uDxXBV7Q8Oc6Tm9mbBgOmG2mRarFzjGA=
X-Gm-Gg: AYBFou0zu/cgGUP1Pk32RfzcYtbUl8FRk8LUlxPqJlPeFQ0Q/UJKG08HLcVBH2Lh52t
	qqgD19IYklmJ7LoaQJSqy42JyVcVk+ApwNdYb55iAWGlPit/hP9RoCQnr5cN17tMF/IB00Vcj94
	aqAN2LqWEFeRM5sJd0IXhmqjlxLglEs9EusO68/e8Vq9fPlXF5nLwlLaEZLab2vJZC4L6XENeAt
	HHtGrn4WTDWD+cB1qXwLhsXp3sO4XRkbLH+l4oA4BjISBLdJRpsiy+jliDFhU/GJ1aFpoY5+4bD
	IOlY5i3TzspOv2jxJdI58WhpRYRUFgkZP5dQfqFZoa7WOfdUHPK9wDzMtnKXbURbj4pAYrqbz+i
	znRjow1k1RM2GcuqJym5wdxHkAqO5uazTh9cYnM+eja30AKozedIgFI533QPKheiLFAQvW+lMAB
	gi6cEtpx7VFWEIrAS5HMQByLofZdAk6giBX4EfKQZzD2k5wH7DKoVXan5OzmnomgBE45SJ5JVoV
	xUWGkogo2wmtVm/wNE9sKBXa9cccFESAWDICVBHb0acL7uPaG1BgCL9c48QKvqzMHZRmha1amEa
	bs3YBsqk/IqWftyX4oIAufwFlqqhsJwXOO7+SZ2c1/Kvy8Mu7UrcTChckUg5QjdBEub+9g2VTJA
	uj3MQLQ==
X-Received: by 2002:a05:600c:348f:b0:4a1:f377:5c68 with SMTP id 5b1f17b1804b1-4bb7da4784bmr85514715e9.34.1795058560948;
        Wed, 18 Nov 2026 19:22:40 -0800 (PST)
Received: from [192.168.1.3] (p5b057d66.dip0.t-ipconnect.de. [91.5.125.102])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb8526cbd0sm5941125e9.0.2026.11.18.19.22.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2026 19:22:40 -0800 (PST)
Message-ID: <eaa1f85b-44e3-4f95-84e9-3500327be809@googlemail.com>
Date: Thu, 19 Nov 2026 04:22:39 +0100
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
Subject: Re: [PATCH 6.18 0000/2151] 6.18.65-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261118150121.603863898@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 18.11.2026 um 15:28 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.65 release.
> There are 2151 patches in this series, all will be posted as a response
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
