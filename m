Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0E543DEA1
	for <patches@lists.linux.dev>; Wed, 16 Sep 2026 08:50:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789548629; cv=none; b=Hm8cgyRNgTTmBe7SGuan5qXZTi4Ap6/TfJb0Lpk89pdqTQp3f52nyoMDm+kDPgqLhr886qZNc41HXb2BacF7loYbs/LsiTt022syeMypRQCfEao6IkgmrZ/h1L/odFnLcMJO067Zl3i4YVkl7IaYevRPmRst1pRHag8xmOqi8gU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789548629; c=relaxed/simple;
	bh=bhNqzYUB67CDLydWk7DJufqn0VBLTm9sCu8zZ6F7efQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EvGsyi44dQeB6/vyfNW1RTXoLU4BHaf67644nNIh0vdzUfz0ISH6ewj8G4aMNCfblpXUQe9E5EVGVmcOsFhRSuj3lIVXVkihQgOaAuVsD6CtR6RkB1B1INEi9BSPck/nkSnszPgYK9x4km//0idificKpNmIwDVk27+NMpa5Aks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=m6x/cgv1; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="m6x/cgv1"
Received: by mail-pj2-f13.google.com with SMTP id d9443c01a7336-2d8fb334ddcso6180525ad.0
        for <patches@lists.linux.dev>; Wed, 16 Sep 2026 01:50:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789548628; x=1790153428; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qEBFuOgg/iQedOKn6ikEzWpyGC34lIR+JCs7VMvN41U=;
        b=m6x/cgv1BuEAjc4ax2pOWhH6QVf7Qs4VT7w9ZlaAlzX1A0vUVbxkt/ZcmMy+TbQOcJ
         4vnIlhxTanNmuE6xkMnViuxU/74TlxX0H5Pm9tys4Ts8BCJQGUJhaK/HZNXAeSvZRzvZ
         Boz7rRz9ZCIQZ/ZxdnphhIxTKXltk4kergOirVS0T6KNFlsEsXVej5QQ235pOxkShBK/
         bEuRnk3sHtAsbHBI5lxnfB8vrl0Eufk8T+AdJEH+zVqbhUifBJhjouIKJPMLm2vEEviH
         Oqa4LmLruBbQanItidkwfBhEkCt8XHS7EFCCMXcA35DFTRFJFyRtl4qk/t6u4ldHYfal
         8roQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789548628; x=1790153428;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=qEBFuOgg/iQedOKn6ikEzWpyGC34lIR+JCs7VMvN41U=;
        b=up+4TqlubvJoFEqi2TygHMnIbplQr6VzQ0MKaLCvNfWWwGB/z4/UxyvbTdvbRwatlF
         iwMcS249xOE6sT/iMLdEv7pg/Aza/A3oikmaNi1x8q26gPxZui7E2+2JDIRJk0LXM+Ag
         3HLIv8uZdLY2ECZwWThlr9WJ/NrQcc3XSy5AirfmCWrh4hMCI67M4J1Wt0GJAt6NYPUz
         N+vjyplVRnJ7agkUAMjfwFb5NePwd0ggjyH/VJK9hJJL973lr1xpeNJM1wgRt+4wiKRe
         PWMZEAJKmU62s/gX8nSwOUuRcKRwrAOUNgQveSb3oO2qpb1mw7euHCVdBX8wCo+erfiz
         ynqQ==
X-Gm-Message-State: AFuF++kGPppLZACXT2B4oSVxPOFyf0A8+MFqMfndw/tfyPSAtM/PyOkt
	mr1ggtv5rO+gorrZ5jt4bN2F1Vo9ncQIZ/NrhNaP2AkZm6gSCPxEkzBA
X-Gm-Gg: AYBFou0QcmEB5IAynSMWOggqyFeo4ZuTmLUGTOKMyDk2ZhXrCoLZyfsOEa0Ge45HM/d
	ZDX/XvK6nSqWWyvZlEnnKCMJphkYP9nRRAmvvvlvkiIhNjv/hQ8xA2GiaFy8zQvYUA7kleBcYu0
	rRMhmFqmmawZ2ccqy79PMk2bGCm23MwvCD8rXUU8IzAxgyYYCotE0cj2QLKea+UQK5XmBabq6GA
	T8/TphdE+tmgkXZCAIDu5eud28zLwqKFIBRdAKiJvULdWN7D5SoTPbLR/M1pmgLqWXzTRHZKLdM
	n/vt13eYG2vunHriupj2vmWBDDZRI4PYzxmJegzekdTuLBGdPAi7I+njtC/5ccBdfckCqxydOrg
	sNRZdLZpsRzQpk7ui7c3m1ZiwN2znPTBw6tIUK7yC7GeDz90Irw61WtSXTq+mlK7Mbd6eYfbd+V
	iOOWgJItYZka4NLhiIONZO9OjM1EozcY4wnn5odtMI+ZBaq5+Tkm2Byos2CU/yXwUwCdMhdPe1Q
	pM5gnIItwSFqTHHM6oN5zxvTxa3neD/yVdEMuVEsuTWzvDA
X-Received: by 2002:a17:902:d4cb:b0:2dd:88b4:6920 with SMTP id d9443c01a7336-2dd8e784c69mr37336785ad.22.1789548627506;
        Wed, 16 Sep 2026 01:50:27 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-33bfb05e604sm4650873eec.12.2026.09.16.01.50.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2026 01:50:26 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <68500ad8-35da-479c-9b37-a5214add1c2c@roeck-us.net>
Date: Wed, 16 Sep 2026 01:50:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 1160/1376] hwmon: (emc1403) Rely on subsystem locking
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>,
 Vegard Nossum <vegard.nossum@oracle.com>
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065633.406209587@linuxfoundation.org>
 <9e6e50aa-4ddb-408e-b138-c829af813bcb@oracle.com>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <9e6e50aa-4ddb-408e-b138-c829af813bcb@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/16/26 01:38, Harshit Mogalapalli wrote:
> 
> 
> On 12/09/26 12:29 pm, Greg Kroah-Hartman wrote:
>> 6.12-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Guenter Roeck <linux@roeck-us.net>
>>
>> [ Upstream commit 61e9b50ffa2390a2927051d335b2ba04b8f791ce ]
>>
>> Attribute access is now serialized in the hardware monitoring core,
>> so locking in the driver code is no longer necessary. Drop it.
>>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> Stable-dep-of: 75f2c0b36907 ("hwmon: (emc1403) Drop hysteresis for low limit temperature")
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Hi Greg/Sasha,
> 
> I ran an AI-assisted backport review, and I have verified the report. It
> looks valid to me.
> 
> Upstream hwmon core after 3ad2a7b9b15d:
> 
>      struct mutex lock;
>      guard(mutex)(&hwdev->lock);
>      ret = hattr->ops->read(dev, hattr->type, hattr->attr,
>                             hattr->index, &val);
> 
> Downstream 6.12.y hwmon core:
> 
>      ret = hattr->ops->read(dev, hattr->type, hattr->attr,
>                             hattr->index, &val);
> 
> The downstream core invokes the complete callback without its own lock.
> 
> The patch removes the EMC1403 mutex on the premise that hwmon core
> serializes callbacks. This 6.12 hwmon core has no such mutex and invokes
> read and write operations unlocked. Regmap locking covers only each
> individual transfer, not the driver's multi-read or multi-write
> transactions, so concurrent callbacks can interleave threshold and
> temperature operations.
> 
> I think 6.12.y misses 3ad2a7b9b15d5072139a20be84adb36776eb6c9b, "hwmon:
> Serialize accesses in hwmon core".
> 
Guess I didn't pay close enough attention. Neither this patch nor similar patches
nor 3ad2a7b9b15d507 were bug fixes and should not be / have been backported,
not even as prerequisites of other patches.

I think we are at a point where the automatic backports are way too aggressive.
Greg, please stop autoselecting hwmon and watchdog patches for backports, and
only pick patches with explicit Cc: stable going forward.

Thanks,
Guenter

