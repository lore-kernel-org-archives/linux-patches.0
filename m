Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5919D34A77D
	for <patches@lists.linux.dev>; Fri,  1 May 2026 21:41:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777671681; cv=none; b=OL2RorbN3eqX+84QVRzCuJOylPOK2CeNHut1ZUgRbzHX++tRQsJ/gAh/L69NgN049nXyA2rxZ2/Haw2zmEFY+l2TapS5UyqavUiVwLEHw0IzVhGGunEW8Abs5MF3HYq9f3ehNb0Tl6r7Oe+G9b8v4hhLuy1p2DOoy9nlDLCMP3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777671681; c=relaxed/simple;
	bh=+vB/YwdAdoeKwiXl4jbl7V7CVjoY4NMLQprs0wgjpxE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=hcs+dDLO4odQ0CtCfueujz/mfMbSQsc0WVtYDBTiODKnTRfM2KHV17R3BxeDVYy5/jJzFyMOzNN4MdEtqfAqEkFbVkJZN9cZbxTENZgsJmc/xIcCHME2cpMsNknsxcsRmrKdCG5Q4rmfi/UuKBaA3wYrDEDsGCM+ANUiw2s9OHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=nC9q4Gn1; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="nC9q4Gn1"
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-42321c8b8f5so1947815fac.1
        for <patches@lists.linux.dev>; Fri, 01 May 2026 14:41:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777671678; x=1778276478; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=laADkq3ZgEa+dMBziPQTVc8lPu6Hgm7fwgwLZ1xwHyI=;
        b=nC9q4Gn1YeoQsBiDk53QffygXPI4RYUiyZy/p7R8WroJcuTQMlzDyGVmzkq4ob7CKV
         gpaQg1KivfvhfDMPFHthRw/90uEMs51+Gv1FcXwtHJqZuhxHyKDgnabcWoGeNswmDmdm
         1RgWSjqDwllDOMaeBqB9e73bASQ///KbqZLEJA6tZCsUGZe9X28YOk97vpWN9EFCgs0B
         bj4W1B9dOHP/1xIDnV+IPXz2TCfq15SjndDolUFMPY97qX4SSpmwTiQ6/Q4zjTpO3Jrk
         T/L8dipDyGleJtQN9r83E1kEMltRE4Hj0U4Ex+g6rWiKf8rWQ51IyrLxpjnXn+1+Q4cq
         5QEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777671678; x=1778276478;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=laADkq3ZgEa+dMBziPQTVc8lPu6Hgm7fwgwLZ1xwHyI=;
        b=cKEy1MFjgFR2Nw6BpG3/fkEpUHfRD0RvStt3JylEBQlwb6o0s/eoBPD8hdW2EIl3OI
         VvTF+PJOZ2/Enm/uxMS876Z1qG/0MMakbu5sspk7sCjg+jtlhvGUp6hpdY1LTN+JDDll
         aEnCSFsqpn4FocNmlIczOuLG6hQWjjzld/oQkp6zGjJHqBDzRtY3NLBrJcWVzpustvLV
         dcPwU9VMEvNwKcvR4boxCXj0u7W2rsDwpIh88+sQfiCS/D05K0ggIqCAYjzbncPmlwCi
         VOIqWXxgKfg9NW+AEuaYXiiD/hT7tII17V+CKXFb16T3lflsO+2WKDHzjLC4Qdn3pzGe
         R8UA==
X-Forwarded-Encrypted: i=1; AFNElJ+kjzqQ+wZTWSrkCORvlCPp1fPacwDvjSNaV2k0ecHEAB7ec2ciGSG+dYuIuINjU4EGj3rjASrb@lists.linux.dev
X-Gm-Message-State: AOJu0YxU8I0OmVVUGieDTCwMNIFkMBhwIOPzPZc1lHlsPs18CRI0uCO0
	4nRdROE0gviwC+JUkVJwQzyvuGGxM66o0/rsgECWbv1x+eUeKPFwV1qivIrE/Q0cwag=
X-Gm-Gg: AeBDievejYHlaulM4Y97lDcfkmZWXaFjkUBB7iAIZQZKayL2CNak/0rMYYJ9WyW+G5t
	A+Wc5yvZPD380MZW02d/EjKJ1J3ApuRNerR5dQTOzzP94lp+ToD0bu50GpTyOx+bRLHAD9Grok0
	ZG7DFdT98sWc4BB8BicGMyxEDdnykqN67fSlYvgNzEjmj7kK7e6MmgrbsmkhAM3uLL+WBgzZIof
	DRXWji+pTmhSGnUnrOWH/WDfzcmSiR//sDkCStoHsSr5rfOSXAk2DjxxQaKvwVd7RvGtEcW9N1t
	VxjV4aeODfdPLlLYqgFVeKe+MkeVmPmzbXrjVUntEUDSc73Bk9vy5bqxVPpCviwuitI1sI8G1TU
	tpERQePlmK8Z1lYH/WSCFsbjsR5UwDE7HM9zWBKjmCuM2Qju7M7GThOjx40TtqVvgQEoPn57rRj
	A/gj/+MRu9SH9DL3lSRtyAoMq19GzoiHyK7N0SlAxBssuoUCga/bd2hl+N8l112MB8RgeeK9ZBp
	grnCNHwkuQGqE4ys5ya6UiagRQ2Kg4=
X-Received: by 2002:a05:6870:d363:b0:42f:ee6c:35f7 with SMTP id 586e51a60fabf-4343891732bmr3543231fac.1.1777671678374;
        Fri, 01 May 2026 14:41:18 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4345452237bsm3606010fac.0.2026.05.01.14.41.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2026 14:41:17 -0700 (PDT)
Message-ID: <a4146404-9b0d-4ff1-a4b1-07d883ab3237@kernel.dk>
Date: Fri, 1 May 2026 15:41:16 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 491/491] io_uring/poll: correctly handle
 io_poll_add() return value on update
From: Jens Axboe <axboe@kernel.dk>
To: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: Ben Hutchings <ben@decadent.org.uk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev,
 syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com,
 lvc-project@linuxtesting.org
References: <20260501111233-b371eac52cd006bfddfbd9e5-pchelkin@ispras>
 <58103791-4c19-441c-9d4f-7ae5f9c6151a@kernel.dk>
Content-Language: en-US
In-Reply-To: <58103791-4c19-441c-9d4f-7ae5f9c6151a@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/1/26 3:33 PM, Jens Axboe wrote:
> This should all be handled in the fixup patch - yes this one ended up
> being broken, but that's why there's the followup fix.
> 
> Now this is all pretty broken because some patches ended up in 5.15 and
> some in 5.10 and honestly I've almost lost track at this point. Sasha
> spotted some that were dropped in some broken commit from Greg. For
> 5.15, the two attached are what I recently asked for to be added. 5.10
> should ALWAYS get the exact same patches as 5.15, because of the whole
> sale backport that was done years ago. I always ask for that explicitly
> in the emails. But looks like that wasn't always done...
> 
> 5.10 doesn't look like it ever got what is sha
> 349ef5d2e7bfb292e7000e6041a984ab56eccf28 in 5.15-stable, hence the fixup
> can be merged with queueing that backport.

That did get included for 5.10.253 - what's needed is the fixup that was
added to the 5.15 queue as well. Which I think got reverted with a bunch
of other stuff by mistake? At least it was sent in / reminded about
earlier as well.

-- 
Jens Axboe
