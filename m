Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46DD3224B05
	for <patches@lists.linux.dev>; Mon,  2 Jun 2025 17:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748885147; cv=none; b=iMLTd2zbGcdt+1LED6XBgMxDnZ2JDEQJjHAEX5BkfxxpBgiSYAFwh7TpqmUhzpjfpDcDp29UvChkw0XFsRcLymcHkVWq8bV/WpJ4FdCvPQwoKUo0OXrATea4H0gj+yhBUo4FRrTn7EvAbCkOgiYENz8TI9oAAyFX+w3pTKnr9AQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748885147; c=relaxed/simple;
	bh=YfXGAwKO9Hp9sS3kUPLXOoBb62icCKPXTFupZoW5qiA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d2yFFDuURKgnkTbQXoUGaCNcBptvg4DbO7UQsrJARsmtsIPjYpNis9Q5Q78NC+5uEU0JNxYcR3Xve0rR4Bvb+sfkTZlfST1gU9IoqeC2Q80+qK7wuaCZsTxB+kEP19hHfwftsakbUKbkeCeIU7G5BeecYCSy3D62FH/JgMjWwJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Lym1X/li; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Lym1X/li"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3a36efcadb8so4101578f8f.0
        for <patches@lists.linux.dev>; Mon, 02 Jun 2025 10:25:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1748885144; x=1749489944; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=1S+RpxvxyphSVE8B8fHLWbnA8TTbuz2RmjgMW6z0rDE=;
        b=Lym1X/lic/uRfcRIfebd/goFfy3ck+PobjXrltmWowBAD3QnW1ZGJqpgv+GU+WnDlv
         CzzgKt9UX/bIekkbKIwpBBi5AvK+sQOoQ6w8dz6AkWeGWSJCzS5xiYR2BXS8OTE9PuBW
         0yeN1Ab54K+JTMTOkgv59ZEjkFSQBZSuwTJ0Too0BJcx2XyB+/22xFX8PhD6/5DkA946
         9RNLVYU+yQw4qkSyB6zmRAGJuWGF8Fh6hRL7S/vTOvErOZlYllWpraTeotcYz04mkVHq
         ejOf7uV/xvoScdH3Eg2ey4TBc/BTtywEOtT0pGwgpFiCyvBXNI5XtgLtO4x5s1jE1Or4
         Pr1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748885144; x=1749489944;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1S+RpxvxyphSVE8B8fHLWbnA8TTbuz2RmjgMW6z0rDE=;
        b=ANXirAqS6yMzevDViIi7ou58BIJD59KpUN9mdyOIrw/+2/vD3XUh5MfMovG710P315
         wrPQZGzlyz0ltnclldUG3Sn/jo3+Ri5SZKs8AjSgRK5xLlIdwdlXarVg61yBgGXZDeT1
         zJ5zvsg75fZByxnLaJ0XN9TESd1KYx9re7T2PSelojV/yZsShODNCSdKKamTVncgBoz6
         Ka+P24si8RbVEwzrYTTBGRCCDaNgld9dyyKh5ykRaeUt98vCa3wWpxYPHy/MkUvT2rth
         mPS7NwMXjoNIUM1PK2AZw3zjcwC5bl314LZtHoJo+0EYjQgioZYsMH/TdqcAHwODo1H6
         t58w==
X-Gm-Message-State: AOJu0YzYfT/mRRg+V8msJ5QNAMtskXFBVrwo+UrfTPlw/zK0oQS1f0we
	6DfZklgFRas5d6M7odcM9W9tSkhGGFsddhT8mIBe87slKCY46TkfBPE=
X-Gm-Gg: ASbGncvfAiBxur6uiM02mKjF4Zd6R/ZMz/4aSllLGwPE79A8bAxp3xt0m0+BI79xFJg
	HUM/xyLndU2tJ1gzUnH7nY0clVj3EexA+nM3xheiWgWghJz0gdeU/HRP1+zrvuXirtUTja66Ern
	UvyxRq3Joy5QlW2R3JvH4GSPv58xWwNKgFxQLHZMKIFUCIwKNSxBotJWQWIQiFONo67iiV+IQBF
	RpzM+xkIhNnWvYPaCt0nbucXuOzZOakmhAEEC+2f/HCFOaMypYrgkWlRGdUhSFaOffoyH+DO0nB
	Wnc6U1lUFqIsPm1SEq/d7nHpg/mYS4ebkoWDWbgv6Se56Pc0LpsZWn560EZO8O1QvatRerGGYxD
	pckDhlnzG/Arnv99dP0cm0RndPew=
X-Google-Smtp-Source: AGHT+IEik8+s+HEIkjVI2p4vsVV/U7psFNK5HwtqnPw+czPQPwWPwcWIW7xERKd82VU4BHsRIw1WQg==
X-Received: by 2002:a05:6000:2c0d:b0:3a3:7115:5e7a with SMTP id ffacd0b85a97d-3a4f7a9d5e8mr10728344f8f.42.1748885144432;
        Mon, 02 Jun 2025 10:25:44 -0700 (PDT)
Received: from [192.168.1.3] (p5b057d53.dip0.t-ipconnect.de. [91.5.125.83])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a4efe5b89dsm15756966f8f.19.2025.06.02.10.25.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jun 2025 10:25:43 -0700 (PDT)
Message-ID: <5d3aa166-c713-44b8-8552-0992b2febb85@googlemail.com>
Date: Mon, 2 Jun 2025 19:25:42 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/444] 6.6.93-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250602134340.906731340@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.06.2025 um 15:41 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.93 release.
> There are 444 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

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
