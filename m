Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6B47489866
	for <patches@lists.linux.dev>; Fri, 21 Aug 2026 11:44:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787312672; cv=none; b=Aqac3MzUwJLjmug9Ze5lzFoyzAFtqU//qHb84nI3j63gDCp0ssc7y5Nr03A7tu930jQkS++4J7CmxXRwbMe4Hjwkv+Da7j20ENs6nJCqwQGp7rURqViDieIw99WZf9KmSszcmWhJk1/3A3UNs5R+rUGDmF4gfauAxqpGkDos0IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787312672; c=relaxed/simple;
	bh=LmDPFx1UL4AROAAMd322NCliYydVlmAMUsKtVspDbvw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LETEH+Dz2fUkFIzsqvzdm78e2w4tVZyQ3p/P9SFkROn/JjAHrf+jIsQ6tRZitFUe3880H7nXSDgKpm8U37vAxgUkxSd4+UgGJCKcsUEylRv0Wzh0VpjvSGyMb4UqasAVi76gFxe+8TIpIxSEAL7mvJzk7/6IHHGapZ3QtSm3StA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=riYYAUxx; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="riYYAUxx"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-69c108fee7fso1706643a12.3
        for <patches@lists.linux.dev>; Fri, 21 Aug 2026 04:44:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1787312669; x=1787917469; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=cEr5jaJTXZMLUGmJfVMOczKqi9W46Dxw+6JK717Muy4=;
        b=riYYAUxxyhs4FCRKX+QfOwFgP14r62jDbPoCGSeOavXvanXK6kOlckocIXW9a0aVzN
         osrlfgH6CPqWauMmbWRnvUsYdZogqAfe/Afsdcdi6I92oZZULN4kZSW0HAgMV+7Rcifo
         QPANy4/GezNVISJrPqVd/uBnVq6lwTYYAd090PNi9Cb0jMX3Tk8iHzYPN3MLVna8uaev
         dzIFEABFeWZrnPxOODFFUH8Q+BBNmaalRXHF4I7FRcsS/0gD5sqYaYCQqW97H4GzmU3X
         Uo1TJeNbVyzQwUEgImB3nSrrWifmxVHdyPgIpOhwCNPV0mYIbB8tsqCB0w05ewGmWSYk
         qtzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787312669; x=1787917469;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=cEr5jaJTXZMLUGmJfVMOczKqi9W46Dxw+6JK717Muy4=;
        b=aYSSsNcjaeF3c+lRIBXG3bUY7LqcEwxWIP7G+1LISM2sSrDKelx9qI29P39IFH5SzW
         63u6zplgGpNgwq++GUEF6Dtw7LWgejX7SESmci660QWNZgVFiyble/YDp+l64LCLrLA9
         41v6mEXLnxd2rRrquHVxW2ngem1F2ZvKoXQ1xoR79IqPZIgzqmFF9hvGvDUQDeuJ5H2+
         Vbf+qXqzYcADCShkGEzZrpfu5HVig1sJQAy7z0/5jrY2TiMwTWsZViag2JR8dalBWKiT
         zCOGp3YTf89n7EsWvHHtUhhrOeTJpACFbLXAOUDOTevf/Pamhh/zE0GOHUiF7AgPr1wP
         NHmg==
X-Gm-Message-State: AFuF++k7fz+4ZPbHQkPskOUhPK1dE+swvXtvBx3mq1f7WbCAKkvpxoWB
	lA5F6U3OYdDx6rRaYKmYYINgOuWvPq59g/0D0oZWZpKY6dCtYb6xcYg=
X-Gm-Gg: AR+sD13G2fvTr9R9vKefs7qF3dPIkirY3s07/luZuefoGbknL5kb+reRRUfd57xYJkb
	iqJyrUy/1tNU5yw/6CRsvJ4xuPYLYFBe3ciUh+nEbhQcO8uDomxLJgIMSaK8iplH/AKlWjwiIA/
	+T0F9idAU/1T+/gPbdJUW23a6gnuVOjWNygLfKzxppwTKu88vgupnyc02Mol2/VTGAsL+su3eNI
	d6p8vMdcx1mon/DigG4G5JkIOMhfuiaYCN4flRhrN04iVOgnr2Hgxuziy9G5jC1wawZeeKJp5Gi
	tbArvodRH3CHMs206N767uw4CneTbsFBKE1aMw9WMMETKju2wcPAQ5FzE+dSyMSd1hVOEZaKuDf
	156jYr5cRNSIesilV6qKp2Bx3mqFvoB7QEI4josm6+fzDIqiPnQh+ozM6D/CGoCvesrY9GFjPcS
	XuEoDKl5nUpTq8fc0jGRgA3bMdRfWftOTd1/npNArqe+EC3ceYHBpgVbfSk85oO2mKZeObhcrQo
	hKzXJlBZVSTeEtUfzsw2vg9IiXOROBuV93Gc9MqPQ==
X-Received: by 2002:a05:6402:eaa:b0:698:6620:d988 with SMTP id 4fb4d7f45d1cf-6a42f28e8e8mr6183687a12.15.1787312668724;
        Fri, 21 Aug 2026 04:44:28 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac6d4.dip0.t-ipconnect.de. [91.42.198.212])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a3ff170601sm5960585a12.25.2026.08.21.04.44.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Aug 2026 04:44:28 -0700 (PDT)
Message-ID: <91cd689c-b9d1-40e9-bf8f-e2c12941d8f5@googlemail.com>
Date: Fri, 21 Aug 2026 13:44:27 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/166] 6.6.153-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260820145211.194104353@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260820145211.194104353@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.08.2026 um 16:54 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.153 release.
> There are 166 patches in this series, all will be posted as a response
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
