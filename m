Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9922314A6B
	for <patches@lists.linux.dev>; Fri,  1 May 2026 21:23:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777670618; cv=none; b=KhCJHcB5Rv2l3kTHszia2W9IsmkcVE5D7G10d0bCVIjKx/iPZqHXQsfZ+2jLq8AF+nwBcyepZvVHePTdjvx9nw8piR9w0uGOvCg46j9DULcWPxDeh/Fpp+OTEbMqPnfN1G+bgDGGeW3KO9mn1ViHpqw3xT3yLH2pMHp8gQDvY58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777670618; c=relaxed/simple;
	bh=MgTVqLPxCJQPdt66ehbgtEHxmumVG1Y1HmC9LFQlnZE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=j4T4GozWKG1+ahKEI7QAarrM9qCg77I008+tqFVmxRpUqZ62xzAL1jWhIwi96cYjrvC9bi++jF7R0fon4MHiiHXn9lqpv62o81oGpa/QWv2NDf/TeWoM4zpJSHdKXCJ2pTtu87w+x1PLCUAcwXzbRrHbJLank9LehlSariFbwZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=bjnORKgY; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="bjnORKgY"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-464bba3a9easo1270764b6e.0
        for <patches@lists.linux.dev>; Fri, 01 May 2026 14:23:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777670616; x=1778275416; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ilfsX95hfqRZhGvVYVhyOiHry5JNrhME4LdqlZnPG9M=;
        b=bjnORKgYz3Ttycc5at07zmNU7zHtvL0jgGcEzDYfOUs3eIAttmTPyyl3+87BnKemOY
         1b3lmog2I7eemI043IThoHwPBZG1S8ch81Wr1Wd/WnVObbEMScOixVUJ4sewiUZfDNJa
         SCCiCXU8JVS+tp+AEUikYPeTQCNtdq8+F2NJdgIr4vjp2DsEWB0jJmVe7YDhQ9N6lMbS
         rVaJD+mgGDV0MKhcVdN0AjnqrfelQr3p21UBivF4v35F/dH0PEgGYspLjzzPQ4clYZLi
         oZv4yt5xXJgnURdHpeY6qTyoPuDIZvAewWVf6CiVsB6sn6LI43LnzwLi3EDrbBaf1+Yx
         4qfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777670616; x=1778275416;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ilfsX95hfqRZhGvVYVhyOiHry5JNrhME4LdqlZnPG9M=;
        b=idqqv9qQAYmSHWQgdliqA0nu+fYiKZhynY3eDinrYQ1Gl+0Dv89ciaeWCSSZc1SlvB
         Rubc5f0A7sKYGu69vh/oT0u/MynU76NKWYB7UWeb8JCpTm1z1iSIdRaDKeT/8kNKfEoB
         jbkUTIaNxb7Hz7p+fQnQE+Wdm7n9lCyrgmFcMTeU6r1q/hPAmEzkyQWb1zuU4dxUF33g
         4DOS7JtxG5ZAD9hiEZ0YzAdOn9IeECrGvOP2MiwUuy5A3UXMMyCZzTxIsXiUzYIJ9bHE
         NAc9iS8U5cNu1qlHvcrWtIdi2YQxkNk0bms/rfaTuQ7drORzCnjc6YWkVcZdiErjHiS/
         D/8Q==
X-Forwarded-Encrypted: i=1; AFNElJ9sdlSCWmIMYCzprEVZx/4Iknx71wKVw0Q+KGnPRHDcnYr5170yFoV6ji973wnbBxfvfkoAD3Uz@lists.linux.dev
X-Gm-Message-State: AOJu0YyYoH7SElve1buaR4hc2sOiTaxHiRUOQGGX9UgBiD/Yu578YJbH
	20W8sx3IYdWuFOayRosyqodmIlzMoon96q8MIfLYGmE3Dx3lnYkwl+qllvRIp3l5HWo=
X-Gm-Gg: AeBDiev3D4dBJ8OB8fSBTKtsRqRXU3iNizU/KJ+fW7NwGWFZMpyIl21P/zQBVDZrIND
	Aqgxpwv2fLkU6dR+pJfNi0aHaYZsuHXU4It7hbqeyU27Olzt3+0piOqdE/DUTyM9EeIu2/Ax9tg
	xX7UkKQBiLGUPfdoGDEfm+c1okRJMg3a+54NaSHFSmcn9h0QF7GDJyj16Oi4GvHclcT9GEGUhej
	Vg+EHkdzGe6eBI5pg/hccYmOzp/rMhZTarAPsYzu8k8+lF0IpnsT8WXZkEdZeVQDetsnnBv3MCj
	vxNtUMafhB+Fs/5Vye7a12mbcZeya3ljD4excFJbhvfDlWrLceqkPdDiU7jE1m9lRP3qqrLvYd8
	kuPpTdHnDArCNbyDszt3F99kGCKJa4BjFrBUv5HW4Rurbni5CQbpcCwd75umz8S0bG2q5y7KUnN
	u81P8OxJQxoBm1WDMmtUcjhdTPC2BLqgOZf3MXajgQKT19jbJKDGjsel8nmRtAOmv1o3SkJL6Vf
	sb2vUk6uy6HNeDPhAOs
X-Received: by 2002:a05:6808:2391:b0:47a:421:c342 with SMTP id 5614622812f47-47c8924a440mr666735b6e.31.1777670615817;
        Fri, 01 May 2026 14:23:35 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43454d35e5bsm3588214fac.15.2026.05.01.14.23.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 May 2026 14:23:34 -0700 (PDT)
Message-ID: <6eb47d20-ed49-45f6-90f1-41c15fa99896@kernel.dk>
Date: Fri, 1 May 2026 15:23:33 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 491/491] io_uring/poll: correctly handle
 io_poll_add() return value on update
To: Sasha Levin <sashal@kernel.org>
Cc: Ben Hutchings <ben@decadent.org.uk>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev,
 syzbot+641eec6b7af1f62f2b99@syzkaller.appspotmail.com,
 lvc-project@linuxtesting.org, Fedor Pchelkin <pchelkin@ispras.ru>
References: <20260413155819.042779211@linuxfoundation.org>
 <20260501111233-b371eac52cd006bfddfbd9e5-pchelkin@ispras>
 <20260501200000.item005-revert@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260501200000.item005-revert@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/1/26 3:11 PM, Sasha Levin wrote:
> On Fri, 01 May 2026 11:54:18 +0300, Fedor Pchelkin wrote:
>> The Fixes: tag of upstream 84230ad2d2afb points to 97b388d70b53
>> ("io_uring: handle completions in the core", v5.19), which is NOT
>> present in 5.10 or 5.15. Additionally, in 5.10/5.15 'preq->result'
>> is unsigned so the 'if (preq->result < 0)' check is a no-op, and
>> __io_poll_add() already completes the request when it returns
>> non-zero, leading to a potential double-completion.
>>
>> I would suggest to revert the patch from these trees because there
>> appears to be no real bug to fix.
> 
> Agreed. I've reverted both the original backport and the followup
> "fix backport" commit on 5.10 and 5.15.

Please hold off, I have fully tested these. It's quite possible they are
wonky in certain ways, but they currently fix a livelock as well that
you can hit on 5.10/15 which is arguably worse. Double claim + complete
should be handled by the poll grab side, I'm _assuming_ more cosmetic
than anything else.

Please refrain from dropping patches until they have been confirmed by
someone that actually knows the code. I've been busy today and haven't
had time to look into this one just yet. You're just making more work
for me by dropping this you have little insight into.

-- 
Jens Axboe
