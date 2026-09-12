Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 421C634A76F
	for <patches@lists.linux.dev>; Sat, 12 Sep 2026 17:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789234393; cv=none; b=tzevulHq0ZpX2G0A132Vi2Rsv9CZvqGMpOOK95GHBIzOfwpDRRgJY3tRZY+LQdn1lyLdDxHv7826fiFw6wdkR7ysBLzmAmVUI3SJl6JQqtYBjnEdbQbcgHVdTdVxcoX/zfp5z5Zg0q7pivdx30mNCexs4kMUatxJl5jTr4s9CkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789234393; c=relaxed/simple;
	bh=EiAEJfMZTtWgNFlG1Kn6MkmrA0T0OKXP3d4n4uNbVVc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CnuZrPd1JHKEKyq4lNR+oLGu9c4Uzb/G+ScTIDIC07TaCtsGsU6zjK8yd7OIr35vGt1xXlCBJWdBF3CwTAGof1qlEU4e0O9wfH+fdMmcO66Y2AWT0A+r5Q/bu4wusfASre2vjs40c+J9e7cxlf7Z4yUQ5yLZ1yRjuS0q2XW/qp0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=oS0UptFX; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="oS0UptFX"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49d097b4939so3244535e9.0
        for <patches@lists.linux.dev>; Sat, 12 Sep 2026 10:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1789234390; x=1789839190; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=B870ygeANjcpypjK7/JSP1iclhPyzN0EU3DaKZEWjNI=;
        b=oS0UptFXkjdcBHSNNj22KjSfZZUW43vYpgGGlVAwIsblcWIXPjPDWFXxCMYOue/+zT
         OO5J89Fmaw7sTBAupXKlG6HR2O0yNYzMBfUe54pcoGE8RWLZeUYsvAgHfOl65Cy0m67x
         sB9gjBTAxMbbq+iGg3cGV7kasOMlsFRTJ3xezuetdREQe2r/WXFB3wrm6VBDJrQPvqOU
         9QK6rdG6Mqo6CbcQ5OXeghjaaCxz0xI9yfn6Ao2srv7GJ+WiV9Xwp9EFXJUQOZbOSnIo
         ApK6/MJG16PuLxlcPp5sqI4UDapS97R/ktYb3Zao0MtYpdGXPPsR8ZMQcnfr4uAzBAVz
         D+PA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789234390; x=1789839190;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B870ygeANjcpypjK7/JSP1iclhPyzN0EU3DaKZEWjNI=;
        b=Hl+qAAD2ZWjUQ0TsCxSdgw804ewzczenN+imybgdj6WAX3HwBNL69eD/Oeat7n0CMu
         XpmogNgL950BESGGT9rKsDHoIeqUKmChKYQfOGFC22RXzjSAKmdREsSWdVuwyKcRiIbM
         ecEwkwSyHRaTvUsTPwbh4Ht35PtuYFajZsT7OwqzGZyDTVQ2UUHjm8SXL028ILEu6gD2
         t5pNa41xMn6eJIZxX/iWNspH75iuvm4UQBa9e4bx5xnJvht+Gam1h9OmJ6vNFxRJq4qR
         pmVvlEQX5yZZ3IBpl/nrC6gRDcMCde6re+WP2HumXTAniP/mQwFCgzhDZLzpvtNbi30C
         XhJw==
X-Gm-Message-State: AFuF++mJ/6L8pRdWbfn+8f9rb30K3yM7+WFl0MbyWsYOglMGczE3qF4s
	uJNTXcJr+E/e1mQ2XvC4Mh6Iy8wqHZNPf4VOlCKW9UJRzaJ5xU1dvcI=
X-Gm-Gg: AYBFou1HW8htMb3xv0pSsKZnjLzfR+msQWEjsfNsFTyvRCVzLyTLPiTKEm5SK2zciNQ
	zI8TFAxJXfCWc3EwpbOAryUcxgprJXvTmStpJNjt3ODeSNqqvg/TS8sTGPzIS7ZI0+HaIYDezmm
	xyQUNVk6OlKSp014aDFboyHuGpysNPut2m8cbK+FSz4RU5EWuofyKzrgveSfqlRVnqKGnhU9szi
	C97HMXxTLiC+G4EtjWkPeu7i6MEV00Ery2mlD0AuAvqBp3Zs1RQJSXFHqyOWuNV53bYuuUD/EaV
	XSsNzjR9yQgCLGZlvzZKeP6y6pCsVKf9DZkGq6dSuAgr5UxsbVt/pMjiK3Sz06t2xnfgIhLizTl
	a7R5FUbSNILxZu8/22yLCsbkIR0zmMpqldJXzIWJehO4brihzdklO6j3NK0gPcD2wyCCRJvMY9I
	OYoMnq6XVyX+WlBZKRER/FtO/b7quDWu+uF9EdfZ805D4kEvfAJqslN38eJ1D10JCJ2Kg3TPWeg
	+H35PcRB71Dna2HiZ0CtvkbnIl1dkzwUmShh/3hrz5xChmdTyEA
X-Received: by 2002:a05:600c:c48f:b0:499:bf0e:95c8 with SMTP id 5b1f17b1804b1-49e619831b6mr112079735e9.1.1789234390460;
        Sat, 12 Sep 2026 10:33:10 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac4da.dip0.t-ipconnect.de. [91.42.196.218])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49d26c1bc5fsm244057125e9.3.2026.09.12.10.33.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Sep 2026 10:33:10 -0700 (PDT)
Message-ID: <ef6ea817-371a-4038-a73d-274fece32f4b@googlemail.com>
Date: Sat, 12 Sep 2026 19:33:09 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 0000/1518] 6.18.52-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260912065623.398859879@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 12.09.2026 um 08:36 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.52 release.
> There are 1518 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and seems to works on my 2-socket Ivy Bridge Xeon E5-2697v2 server.
However, I do see the same strange dmesg warnings that I see in 6.12.110-rc1:

[    2.397237] Driver 'sr' needs updating - please use bus_type methods
...
[   84.031323] Driver 'ses' needs updating - please use bus_type methods

And again, these warning are new in this rc, they did not appear in 6.18.51.


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
