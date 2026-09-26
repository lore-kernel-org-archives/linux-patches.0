Received: from mail-vs2-f38.google.com (mail-vs2-f38.google.com [74.125.227.38])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 517A022FE0E
	for <patches@lists.linux.dev>; Sat, 26 Sep 2026 23:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.38
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790464801; cv=none; b=r1+DpqwKHNjOxAld6GpFbCvUIC91OCGrat7SEu8nM/7w/u3Ujl/Wo0yQj0HIvfLxuyxlhjxJGNJ4OHycSwy0S1ahATvXWyxuQ/je5LZ4FoXETXAyDYecLYKGItqR/4MOp/Di/VngY8shdS4oVEiE36AMDJiPwQlJzjlzQlIVPeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790464801; c=relaxed/simple;
	bh=x+lyFU8fw2NYtSeu1jk9/sJSW85cbGjiEFqzRVsY3s0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j2MV0TYy/alKxRfuQHfxS3I4H7hNwrKTTrjPNNKk2p7lhsfubfbL/wX7Ek4q88JRG31LRgBIodZD7XAsPKTiWGWZajZJTHY4pBWapRUKu5oWY96nUb7h4FmakEMgJJ0TiGOVx2wISKo1Fxy3795sJFKlW0oZ5dR4hcd7Pur6FZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=lGijhT3v; arc=none smtp.client-ip=74.125.227.38
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="lGijhT3v"
Received: by mail-vs2-f38.google.com with SMTP id 71dfb90a1353d-5cdb9cb7feeso330323e0c.2
        for <patches@lists.linux.dev>; Sat, 26 Sep 2026 16:20:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790464799; x=1791069599; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e8rVZ31dhnVvTYNLVTgnVU1B4iKZs/qhV9xXBXWsikI=;
        b=lGijhT3vdNfztYGI1brZV6FqbHBMrhmnMWPVkmqrZ5x0hUqWUwpl8hz+B/zHEWfREG
         0IHl9iDJYBI95iLfjXWr9UnmQobXvFyv7zEI2wpODfWa5UtWW0KnYGpkC0gHH/uXmBwh
         o/4SFxJ9gpsm/Nz74p/lgkZh9pRjbuBT7HLS/DcEEPJ5a9ps4oi2e3Aq+TaG3ft58Q52
         Uxwk5Mz02rNF4j/SqXBZDttOPvjjI5MzzCIE3Ca185HkVGEL5PItR9893BuYtN4/lRfV
         TkIMVDzvX9na4MVUwG90cV9a0ruVi8Gi/NPwxSU4noCr8ysaR5JkHypBLbyBOnFxaZ+S
         oPHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790464799; x=1791069599;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e8rVZ31dhnVvTYNLVTgnVU1B4iKZs/qhV9xXBXWsikI=;
        b=vuxKBg6XspLvZQHrU01Pv8Oq6ZDhk3YoBo51reLpa19tot3nSqFfeMDJaPT+gxI0fU
         9aO45b+R0jSgvSFZXNLZNKxz0ygEgm9zmGDCdpgjcr8CtnEv4+zaU4h4ZVe1qZxmHQ/E
         BcwrXabeq0xWdfzICDNV6zEBV9F5aPmLEpRIMEmvnVItdlDPvuz1LNdm/bfbd06eYCM0
         FdE36nZImvTbSYZTNj2aYaW2hlCSZ72XRH0gBdj4SI/vFtJWaGyWH47Afvxw+z3cyaTy
         5C+rKnHRowgEm0cGnIZgxq4GL/fCdV2QpdqZdC1taKZcQYATD8W5pHfwDctNgLdcKZ4K
         4Iiw==
X-Gm-Message-State: AFq9FYKVred7pU/M/rYNVzPKABWgy3nvR4IogGyquxKBFc8shabPdRL2
	qYnTQnzYJav6i7RnGU7e5mAkiIC2CiED7WA/emA7SIytl0tRcyBAV4Jl
X-Gm-Gg: AYBFou35Ul8urivMHvVIbcmBNHm5fJB7En9II3XIg+fcY3eMFCaB0X3TIUzKRr2tUS4
	v9AlIHZV6sEbcqOoYQPzB7qsRIPxq1Kp2Z++Y/GTRkfFpfyZT7uKs9mU6WUMeKu0wKt1qTBrQpc
	DVx3XXhljTYOOIIGALjrjjEYNUQrldcvs1jcK9ejaMTU5PL13KZ9Qb1MHyMGRqh+1d0Ko32SYEF
	ifR9/X7p+8R81gVZsirdZ98ivXgBzVwkSrgdm1E1fuZu2xfgA6pqbWu/bc3tTPOfi+fHcETYQo/
	HqAUD4fJehQKhpt18/Mk2M+5+eh5DSNG6FbiE9D70BsjWhEoiR/mTlEfKlHoGeSdOmLadNHoQrP
	YEoGkI8UUL2M3rXemO6X6oiwIqMKr5SgJdLbQovQxHlYNThRLc3rVZP09QicUS6bwqPTenXx0h7
	bTwPxkK2wIkPxNpzwG6Bs+xQ+1qeYUI2pwOeuCWvTrs0l1gGrphcL8cCyWxTX+qg0/FIjwYgiKl
	cmjbEZYmXM0OW6CkjoB4UcPHXh8+JiAFU3TqFmNezlsRA==
X-Received: by 2002:a05:6122:1c0d:b0:5c9:c60e:3a42 with SMTP id 71dfb90a1353d-5cb0bf4f842mr3983859e0c.20.1790464799140;
        Sat, 26 Sep 2026 16:19:59 -0700 (PDT)
Received: from [192.168.1.2] (host179.190-30-68.telecom.net.ar. [190.30.68.179])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-5cde5a70282sm3358365e0c.10.2026.09.26.16.19.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 26 Sep 2026 16:19:58 -0700 (PDT)
Message-ID: <5ed0ee13-9502-42f1-94b7-a99607ca2bea@gmail.com>
Date: Sat, 26 Sep 2026 20:19:55 -0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 303/398] Input: synaptics - disable InterTouch on
 ThinkPad T440p (board id 2722)
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, =?UTF-8?Q?Rapha=C3=ABl_Larocque?=
 <rlarocque@disroot.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>,
 linux-input@vger.kernel.org
References: <20260923140643.441954610@linuxfoundation.org>
 <20260923140651.274430576@linuxfoundation.org>
Content-Language: en-US
From: Daniel Salmun <salmundani@gmail.com>
In-Reply-To: <20260923140651.274430576@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/23/26 11:06, Greg Kroah-Hartman wrote:
> 6.18-stable review patch.  If anyone has any objections, please let
> me know.
> 
> ------------------
> 
> From: Raphaël Larocque <rlarocque@disroot.org>
> 
> commit 26eb3d92c7a4d7adb1ae1740ca6e8e100b11d1ec upstream.
> 
> The Lenovo ThinkPad T440p (PNP ID LEN0036, board id 2722) has a
> Synaptics touchpad whose SMBus companion is not ready at boot and
> takes roughly 200 seconds to appear.
[...]
> Disable SMBus InterTouch for board id 2722 so the touchpad and
> TrackPoint work immediately via PS/2 from boot.

I have a concern about this one. Board id 2722 isn't specific to the
T440p. My ThinkPad L440 has the same Synaptics board id, and this patch
would move it from SMBus/RMI4 to PS/2. I have never hit the issue this
commit fixes, and I haven't seen it reported on other potentially
affected models either.

I sent a patch [1] that limits the quirk to the T440p. Previous
attempts to move these touchpads to PS/2 were rejected [2], as
explained in that patch's commit message.

Could this be dropped from the stable queue until it's sorted out
upstream?

[1] https://lore.kernel.org/all/20260925230039.236786-1-
salmundani@gmail.com/
[2] https://lore.kernel.org/linux-
input/65C23A49-5A55-4CF4-9AFD-2DA504DAABF5@duggan.us/
