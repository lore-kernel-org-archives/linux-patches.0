Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D9A3FAE10
	for <patches@lists.linux.dev>; Wed, 26 Aug 2026 15:55:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787759757; cv=none; b=mOG4jeq9wPTSJBo5Cs79dXwckpy0RbkMnCjZqryCOt1hUaB3UJGj3DI0hyxf5TMi4U0/C9haWerqKQKNU/ipf/qaUKkRnpq2wxrNCzrx0dqeoYkmsYcCAomdyfsTmi/gi8jA+6IjaD+8RXSE1mOacvkntcYJkVGZHqrhRB+YlNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787759757; c=relaxed/simple;
	bh=9oaiX63GtUT1PIJRby/zgJFxpdh3yK9f51Y3hyqry+s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RKOjyM3Bp9VO8onXiI7gCkdUDTHTKXKAPU0VmT6kl0ZsGUgIEqFHdd/ic0SZoZ1/JTG1XPgLept5VRexevvdTSZNTN7OnS2ksQZgRYDdFhbOrePdW5jHio76CynJ+SlEMlwO5Y2+uMPtJuBGDUoeXZU3k4DNFijwp/3av4IUY9k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=c9k2fDv4; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="c9k2fDv4"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c1670dad7a8so185240766b.3
        for <patches@lists.linux.dev>; Wed, 26 Aug 2026 08:55:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1787759754; x=1788364554; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pDADV2/or4TSZWEIXH4l4CffO3MwLk2ZaPPDWt6sblI=;
        b=c9k2fDv4+310TBCrLA+FRJqRZJrBxY2ku+lThB+ivWjAhVBlHc1lMvnP1psu/I0e8y
         CfG0rQEYVGi1tixrApDaCijWlSJTjbQ9BGUsYR+ZV/D0t2njTVImN5DVV1jKBhgREFCK
         y/VnYF1dPXM3fONX0rGTCtkdZv9k3RIUXCx1qbqS3gs8DvN9EZmzq2VU4wFgD2BNVAOk
         BOqTeJ7uaxc9APPhgXYhZNL/iybAsZL3g/vGoHUObhGsF04m/vd1+0a3wgm3bLk4hKx9
         sHjYfI6Amcupbf7FRW9IdhHMbg93EVw932ElvPLdMrxSF8XxGCClqYOlI6vdoUTfIKyd
         mLYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787759754; x=1788364554;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pDADV2/or4TSZWEIXH4l4CffO3MwLk2ZaPPDWt6sblI=;
        b=ejK4E3cImVE/dx7L9BL1l3nKXBovD0diGVDVXjGZrKUOM0m/TRHo/PsB+3RlecVTLR
         +BTEHPi0o07QHX8mTNNZXpt3kJPMOuEHIWy9/tJp1gEdWrDipN4oIgLVJYqqCbXJjNHS
         E9olJwV5b1djc6KMOtLvLlGkwwPQVXzNLLRpgg3HrMQ/CRs0pOzw/bCfZDjjruU3RI3v
         nUfpaWn1J9+h5pLHXU7mSrqZ76+GFNLRjLWwLbH4Id0QSyKWMp+vcbbu6ju8wfG+pqE9
         o5cWNE9zKfaZo7mfsvVps6Taua5Si8Zq1JllZcVQtbkNzVGy7ncr9rD0gCZH9TOSQ3jf
         702w==
X-Gm-Message-State: AFuF++nA3dAsBINbkVvolRnnprfUJ11mhYO00fwSfjh0yBODO8K6Z/AE
	fz1/Xx2uD2WQk6jgVJY24TzU3XOebyBDHsLpnQLLIyE1LchyjUs0/RU=
X-Gm-Gg: AR+sD13WbSN2PyJPy+a19DS4gGMRhOH1jCg0D1fBXpXktvN9muNtxHOhR8MJvF1IU9g
	snFVNjkEnqYDmp486zEoFiVk8se7bpY/t9yOjMA9yRVlDbCDgI6JFEwWzpXnjuizkAHnGMjCeqq
	NaqazoR1sUMg3sMsj9Cy+zfrQvILQeVVv2rnYkkXwiJnAibIUHaRh7fl6BIoihcXQ9Y3waIRuNZ
	IO3DOr3o10NanhAhaQSkSRVDTMONE9dM+1dlZerdgFkjLsqLys8RFGmkymu3cvvrwFwGEBHPTdD
	mVssnBC9/huNBQwxXRuNTXJl5vsL8KOlAU88lXjP/Q+qLdhJsxlgoYfIpISzoE35zq26StkamJn
	lTmaXEZfzKCcJcTqia5Vw32nnKmVIF1bLDEyaxaRv87NGoxAxQe+mMQ5XgniTcJO95nFUsq0ztS
	I/FL/HTlyWPj36PgZk5P+WVJTI5Oq9XMUTZCVc9EzPcjEoSGABsEaH+yuXw1JVx4Ks5lULGWXPb
	VcVqQn/Ve3FeJE6fqSMEvmVfABex0PC3MapDlc=
X-Received: by 2002:a17:906:fd88:b0:c25:437:3dcf with SMTP id a640c23a62f3a-c250c3c07fcmr998270766b.21.1787759753471;
        Wed, 26 Aug 2026 08:55:53 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ace5e.dip0.t-ipconnect.de. [91.42.206.94])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c250a5d62easm572120366b.6.2026.08.26.08.55.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 Aug 2026 08:55:53 -0700 (PDT)
Message-ID: <1e8ce437-3f87-4963-8f36-ed629bb9a984@googlemail.com>
Date: Wed, 26 Aug 2026 17:55:52 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.1 000/101] 7.1.11-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260825132541.986300899@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260825132541.986300899@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 25.08.2026 um 15:24 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.1.11 release.
> There are 101 patches in this series, all will be posted as a response
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
