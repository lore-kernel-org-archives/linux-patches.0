Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795228575;
	b=etJZErmVHSBaT1OQb+nC4wLifFLYllluZDXbWaJy2HCAD/fCPBpuJTUZJy0+RQrFn8n9
	 /mneN2vTpb1Qx/GazrVe3LEUV1lDyQrYhVFZDCHPY+SWnpuwVPu1BaDfmd3nKuwyku4WL
	 IgIGFwQW36ab4U6VPAnyxxfy4yEB5v/2TJusgy00qTlBuvG/y7sveKnxuLLqz4esovYhT
	 iK4QJ3aUJUZqMg1rFhzlX9Jjhfmh/1bGmcbPpn9O8fVROl3wg8C/Hqnxla8b05XkLGQUj
	 nnZG4hE+M4Bf/ZbpdQeaQgoaEpXlU2dk0mKp5MzZiW8IGT17CFBeqfy11o4ZEhFzqaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795228575;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=ytKdWC4PKOBa2qHZovVgrsdqwkaFMvswDEZlScEeocU=;
	b=BFXW36mi28uncwtqUPl/N+MFBc6+7GfWOw2D+O5ioC7zHHJjeef/+UZenNobbrDgQe5U
	 6p+hsQspCFRMkGdYGtg5rLztt0z5IHYrnkngSppaQ0IRrTEDJSgqAXRbQGl8t8ft+beEG
	 oWGVnUgj39HohtM0oa5m6MbzJY5Ij7+sy5VVy/VXhLAhoXiwmlYEpJ/v51XrSCFkpSWEY
	 rCZv0b8XICmOHTs/OZCLvG6pLRPqNN6ICCM9AQJ/nQIAD6SntHU83b2UgePfZvWjizgQU
	 y2NRHU5zNOIVgPggL9Am2T+77mhrxQt61AJ4N+hYNnlQ8w08wm6VQuZov5hYji1+QiQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=BdJQ3UIP;
	arc=none smtp.remote-ip=209.85.128.49
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76F6E606A688
	for <patches@lists.linux.dev>; Sat, 21 Nov 2026 02:36:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 76F6E606A688
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=BdJQ3UIP
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4bb70074ab2so15455795e9.0
        for <patches@lists.linux.dev>; Fri, 20 Nov 2026 18:36:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1795228573; x=1795833373; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ytKdWC4PKOBa2qHZovVgrsdqwkaFMvswDEZlScEeocU=;
        b=BdJQ3UIP8BWZ2ze4dZrU4skbsl0ecdfLhpU0KwBguRR3xkDN2J3sxMEsACEdWObf5I
         BEM3Tq/HQTKoH4gifa0pr08mNZ0xXHwxRuCLNH73vRhSt8IAieXTKsFoAwIpa8eUADdK
         pPPoa2zFjd04lVbwlUCPrbGyqHd9i1X6BWwn8fT1jJ+frK8oqK8WnpgMtuil6n8lN/zg
         w3alTlsfKTc9e+UoEGQTHmL+z0On6mGbzhMLF8pDmHNnzbj8TOuNdjVUkDdTFKxvbR8o
         MD0Ex7NViRFoP2vKig3Rb+5M6jiT5tVzlQqa19oxXBZhjSF2krJcEALaga98Hh7ZiVc4
         d56A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795228573; x=1795833373;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ytKdWC4PKOBa2qHZovVgrsdqwkaFMvswDEZlScEeocU=;
        b=CaZ82zYNrb0aZGSjh/hyXCklBcyGdMgoXtyeNSVU+5RweZP7rOQYTo4i1ZBCi7f/Io
         PXaYUaqzKGPmIr/mQ2Po3LeJhdKpCrAiJVkU1EKAu1UJyZjoombNBCrKaxU0aA5iw8qz
         M7EOa8ypJ0GSGBy0YRGibI3ilTQrMoQZNAOCD9m5hw/6RQFgSKnODcBJKBdc4aTIg9ZP
         +2uEqf2BnLy3oZR6GqlmbgWFrvHr13SVpjNo50IBh+BhjDqDxd94pfaIxrK/7hFrIYeh
         BA9IMSPCXw2Cu0Cit4x3++lTetZvA47HIM1/1A0iMck/52nSpf+EvhA56EnXi9JiCEjT
         j7ew==
X-Gm-Message-State: APuU4Z8/oxRBVuY8ePqDlWLNdT9rU7gPpZu1z17ronNd7W5SiKpuwH3i
	Xxxmay+/Lzt6eeyotGJp8nvtJ5YCpjTn2L/7sgj+uD6iVpl3AEHS37E=
X-Gm-Gg: AYBFou2gVtHqKgNmzh+VlVfF8DPCG/ss63TbbfdLXbXLBIQzIK5OFPvPwozm9TddSRY
	632AY6H/ltyvQIRqdKooAFCEOF/xa/nEmCLRu0J0QffTVQ8P7PJop46Qb7I8XIl5qyw2N1z9AGC
	3at0q4XZa7XfBjoo+cL+hyWTEtjRWphlFVUOjPpcOLpCGsPrH8vXLyJSWgf3sCY7SHFLghOuge2
	oyzcbxHosDdou9DibQXV3/ZDBouzoLq4tmxLzhkpoYJuN1HgL/XH19kW0mwo6+khQ5iyBAxuPaV
	FTZkIdNM9GH0J47AJEQ/1pwJmMtlLvz0GUSGo+snBwn32XaXmGiF2fp5OFSy0QBDhogzZ+sF5E9
	CTZ3VFfILxZ9be56ku1rGuxWtch6qgT7v1qhqtBgDJ8Vb+daM4FsNMAGPPwwZ+uhd2CEMSMjuQs
	kcFhOpcM/p6XCif+M0iNpFsSwD4rLpGWixqe2+7RXcI/nlXbd8vldfX9h7DsINrpVH1HBB/xrF5
	BeaSuvpXUtbr5XBIdxdYZvl87PqSse9jX7L9XB2NdT7VzGgAZetfTyCW7N3FSY2X9rXhS1ysV94
	8absQadBeUzj4byv9NFZtT2S/oMWpjhbU5FTTHx23Ly7KmozdsA0Sl76qTaypys1QNHlTpTfQLY
	8R9RBd1d1JsX2X7sDi6d7N6CzAQ==
X-Received: by 2002:a05:600c:4515:b0:4bb:659c:b8db with SMTP id 5b1f17b1804b1-4bb88813b27mr117200775e9.12.1795228572531;
        Fri, 20 Nov 2026 18:36:12 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac65d.dip0.t-ipconnect.de. [91.42.198.93])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb88402ce9sm106722515e9.0.2026.11.20.18.36.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 18:36:12 -0800 (PST)
Message-ID: <ff148281-de3c-4ce1-8d8a-86a9299f73cf@googlemail.com>
Date: Sat, 21 Nov 2026 03:36:11 +0100
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
Subject: Re: [PATCH 6.6 0000/3308] 6.6.163-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261120055324.975889935@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261120055324.975889935@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.11.2026 um 06:57 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.163 release.
> There are 3308 patches in this series, all will be posted as a response
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
