Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0F343AEF4E
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 17:58:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774288721; cv=none; b=p3PYdbtF2M029fvLx44WsvQ1exy06R7m0yPiFaF1FCTDGUwm4y3Dtxelz7fnMSaD6StiDZvd/JaSYJcxksMVrDQB/gSR+SjakOLGfdVd2dIFNZugFx2aZIvknfmxCMIxTapHD6uNhE5EUhJVGEqKj0BpmOEbF5pTCC2wXR6xpow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774288721; c=relaxed/simple;
	bh=JoIGIbJWlZ3JqaUmsBKT4AsxRLSJwIJ08kbl2ygi6V8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X7zNRChs4aRLnB86oT/dtXrzBUXVN1vy3m0fU+jdrpGo9USeiZlQJNr2ATsAe/o4P7dxV4BuFiyiarY5tP/YV4DmCWVj6rg3p1NlX9W4k17g7ci3wnavBHkEbkNbv1L44w31fAmiEq+i/Dq3gtkYYL/lKb+FVc8krFLOTXlNC8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=IuRO+r8V; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="IuRO+r8V"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-487012ce896so2400555e9.0
        for <patches@lists.linux.dev>; Mon, 23 Mar 2026 10:58:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1774288719; x=1774893519; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NF4TYajtTbEevb0sTKIPHFXOcUrsMVnj5VjH10bWuJ4=;
        b=IuRO+r8V35Ar2hX/GqbI3yeNciuwTEI+xiq5hjCmhT9vdXhz42GLK5s88s2Up8fOyC
         AO72+EFN5kcSPI5u6wsbfwReU0NHYpBC0x3f1nIz4V2mX9dSdHOJrIujVu8IgnkUCs+Z
         TOW9Sl42hVWEef2dNx76gsPMoG9wc/5ANqUtaeMlKmiClsHljWi7rWsFQi+yjLou8x6W
         /oWFjd4JfvKjOe91+3tSRdHD6pmuETVciB4/t3tWwvAmsVpbalrjOvsNV0iEi7JW4JAp
         F+Ie8Ke9dmimeSIy09KRHdhFnUS5wt2kxBYgiZLmxXctld0m+rqhrdF/GTfKRnrBZ1kE
         I8Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774288719; x=1774893519;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NF4TYajtTbEevb0sTKIPHFXOcUrsMVnj5VjH10bWuJ4=;
        b=Dm9GmByy+N0NMUG6DT6Qx8b0W3AwhMXGVGPYZCw4XqcKs6X4QDOjS8Q1BGCAxh0At3
         5MfwDce0BVy8BqSrtHrNc2iyKMsq4lP+YAwn67ily4Ol607nTmiWoaG9YWZUo/Wc/S30
         cn8a8vJ8AGINhSq/knEEp+s2Ba9lTAjV662n/wRgZucN3XhvOAKbnsOpA15TGIcRuHp6
         mu8saU8jh8m5+LrJH24zAWURqYO3O44KdYEbGTfUDcSrct1D1/Gvf3i/UOAl6eEYFwR5
         LxZxLjWwQq5qMERPJDuxEKUV6FIPXMIVYgM6Su+BSgbDZP2A6W4bhL+cUqVcfaDrHk6i
         rhfA==
X-Gm-Message-State: AOJu0YzfousOLxTloK3XAVn2L8nScVojsmayjsWbYzVG0VBaHxlZsrlh
	jqGeHRp98Q6Emes57gqA0vvrvDkntUq8UHGlWlqgpucQy3xmjOcuCQA=
X-Gm-Gg: ATEYQzwg3s6NJEDf6I1Hq7UXf4bfmf2bHqZ32Ii49jW2GjYJkf3fWV87C2/7dRZaf6U
	EOMh53rUerYd5bfnKIacps1nAz2pR+knrfVrvHoIR8XSyx/4Iw/l9QIL3wyucc3v+o3Tu1vJQxr
	EnO8Lu2ek7r/wxvhowGrGcFMrvjni/qCtdIRSReGioyZsxuQCMJvfm8zUxT4cG3p04fee2h4A7n
	L5h/ydX9Pf3I9A4hRZFkUhC+PR/NjjKtFOwKjj/iFV3iOrXSA1YNIA7l+rPlvSp9WORrFbIh3r5
	/u+ngmdnFrCn0ZepB6k1Dd5F619APKp/d+GFcLfJwM++xaek2T6XBcm3Aa24t+c3dFk+AxNYIft
	X4vdjuw/60K5D/5koV+nBKqjmw0YghSl/gTW34jM0fGTm2xZAUh7GJ8ou7P0a9wkfm8gOFbX25n
	fIFRPWQHGVejnbsKm5008daxIo2jHCQkuKTO8PwT7JGxVrCz5S4TxYXzM2o0oPsnWDSVzgiSaj/
	w==
X-Received: by 2002:a05:600c:5248:b0:485:3a27:a961 with SMTP id 5b1f17b1804b1-486feb5d845mr196954565e9.0.1774288718737;
        Mon, 23 Mar 2026 10:58:38 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b444d.dip0.t-ipconnect.de. [91.43.68.77])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48705135631sm220474025e9.15.2026.03.23.10.58.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 10:58:38 -0700 (PDT)
Message-ID: <d080ccf9-6417-4144-b14b-646bec74fe1e@googlemail.com>
Date: Mon, 23 Mar 2026 18:58:37 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/460] 6.12.78-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260323134526.647552166@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 23.03.2026 um 14:39 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.78 release.
> There are 460 patches in this series, all will be posted as a response
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
