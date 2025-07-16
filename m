Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38BA019E97A
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 16:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752682765; cv=none; b=rnWUkhhZa4wXU2pRsD3G0WvwXt/iijxE3NUy+lvUwo6fDW7v9radlldzKNmASSEPCP/xVvTLeDicqX46HvUF8xqzlwNxUAdT27bmbWTrSKqmVwSFu2prhJoEVJduFN1MN6YpBpHxOFy4NQmx5SqZwxzIKyMmoGupKl/7us/OMw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752682765; c=relaxed/simple;
	bh=8L4LG7VxNQXVKV54uJhPhTHvc9J9quvcGW5uC03hr1c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tXvBHFOHFjHYhgxnV3R5cdGuV3eUwKBPhAPTDVmRV6BsPMga6gm39JONNM624lxoBOmgioyPY7sahy01Jum2Pplrqu/BYCluv5smYcKjUGmRR1z2cot9xBP6QDbcvYJKrZ0wdGeCpingrsMdqHQW+5zrHRC4aC3BfHU8r5Jy6gU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=EimZ3HeC; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="EimZ3HeC"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-455e6fb8057so163215e9.3
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 09:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1752682762; x=1753287562; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s4dkzLjjbhNvGJlyZbi1BiZarcYWuRg5LWjzLiHJJbs=;
        b=EimZ3HeCc5XLBDMzR8fFb8fs9TCtH0ch5o6uSE3RGvEN5iNA0CwAExU+cTGb2iGley
         3wPx/ls9IXtQYWR2kanmm1DBbImaKj0y4jPJiwOV2u/wnxJTgExFdgeD2Wi8QHYzERzn
         jocQTHUkf4ClTCCO+uUwCIKMF/uNLu6VGU+ZaDJXqJ6rccGM0uvzsWKWYwI/QmJ7J3dN
         cHd8ZunrbLgxt8GQh1iQcq8dDfe6eoYtKa/sOaFgQ+qWlJOiCGil+jR0+YOA6FU8aLt0
         P7k3XcVIEftejkdxogEIqKVGY92XzbRQ+q7TWKfAh832rNuNvO9B2KQ8CeECqagCg4aj
         sl9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752682762; x=1753287562;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=s4dkzLjjbhNvGJlyZbi1BiZarcYWuRg5LWjzLiHJJbs=;
        b=O4wfMcr6NBRZ4h0tWqvu8p4mKwwAVKIShr/gORRZNNu8peeyWihLCu5SaE7KsBjOXm
         VnNmrtvFXagZWy8X6jpXJWW8/sUynKe91aTyYs5pA9ai3OsH0ouqqBFTsCSuGU1kX1yW
         Z2bn2erZn0+Ju6mhBFkBQ4qDWY4zjV6MTWR95ZSjEkQi7Oh0XfRbcIbRkf030JTB1Hpu
         SxWJ0mOeycJnRq4Qd0cgsIfU7D+KtDHwLpxmsHEtWmtvyd3jI1z74bKi7i/vH0F2Fhlh
         Mk08nH00LXFx/uzaf41Klhzf7RAA3BNCdL858pJ75kTFcwmGp2atTMczBEKcM61QFdas
         PjKg==
X-Gm-Message-State: AOJu0YzBFky8E0xMyW9Um40v0yvFb8AG4uBRNeRdyJLsBWlC9lBtkoVs
	SFREEdBGf31aO6p1dR9eekWYOuMI3axZhBu9nylKP/mDgoszilA+Vvw=
X-Gm-Gg: ASbGnctdrO1jTTU5tA51P+bN4u62P3q2ZmogbQU2or0J+NUDfZJe4vwqeGW9rVy8DrQ
	mfz2dXeLWIoiSQQFwXOzl4WYaYSDVPQNJJANylpr83EEskpcs4JYzN8VswFiRuIJ0bO4WjRtXTf
	c5Fnpg5veT0JhzUZT5gkpdjzOvWYC/cwbpQ7L0FpuIQHNgjg7hlpvV72SknRECKWzDvHvSaqjmQ
	/mLyBK03UGknQKPbVSGwyOJKpBANRtavCgKLQm9cTV1/R8ZOg79k0FTxeDvSnkbSKobp8ZUwNyt
	n6/eYEyRqViDIm53cRC1d//5tWpGwjqSHb7ZIvUI+Isx41mDeM7lGOTEvzst0sjgtx6Dw15E4Wp
	72w3ZmHiaEpZ92EXQf89bSreyPGDHGyIlMlVy5bQIBoildyr65JpaOJA6TIuCEaTbrjYqDPzJXU
	jB
X-Google-Smtp-Source: AGHT+IFjsCW/j+z9V+0qi3pXWCj1korkJ9Tpgx1scJIAt2ZMhEJkziqtQAOuMKyegU35oRlN7oHuGA==
X-Received: by 2002:a05:600c:a00c:b0:455:de98:c504 with SMTP id 5b1f17b1804b1-4562e2bd5a8mr42946605e9.0.1752682762431;
        Wed, 16 Jul 2025 09:19:22 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac571.dip0.t-ipconnect.de. [91.42.197.113])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4562e7f2e57sm25590115e9.6.2025.07.16.09.19.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 09:19:21 -0700 (PDT)
Message-ID: <f188e72b-231d-4523-a804-92fbf539886a@googlemail.com>
Date: Wed, 16 Jul 2025 18:19:20 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/165] 6.12.39-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250715163544.327647627@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250715163544.327647627@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 15.07.2025 um 18:37 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.39 release.
> There are 165 patches in this series, all will be posted as a response
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
