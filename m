Received: from fhigh-b3-smtp.messagingengine.com (fhigh-b3-smtp.messagingengine.com [202.12.124.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E23743D9530
	for <patches@lists.linux.dev>; Sun, 20 Sep 2026 06:29:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789885775; cv=none; b=R6yWzA7rpEL4tg9B6uPfVE7FlDlKavC85roOdf+tK6AvRu58bYcTXvm0GkJ04NK+46QTHWW8VIcf0M/3xMc0gXHOMOXgbycfvZ8B2Y3eRHKZaYTFvJEG6FeRf5/NtlOJyVdQiJuQ04BpUYddw4pVzdQJnE1w7U/VZ92rhMHYUAE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789885775; c=relaxed/simple;
	bh=W76e+7EX3tEsBrKfO/e/LQfBiCbKnuXXgIGSkI6o12E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Byafcp3fYtFrARrOabQnZPxDWjS2sI0e1l5MpnxtDsXEnw1Krs9UjiuAr2cJ48s2uA7xnFnZIiG8PKYrwVQfp8xSxaLyAXo0F86XMTqMpUoRkAVxOm4kxqlA2OzKNm3q4cdJ62Tx8Ya/o1FzGjfGI5ExxJ3oa/4sY0Fh36tCxjI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=gQqCmPNu; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=xdbjhOiE; arc=none smtp.client-ip=202.12.124.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="gQqCmPNu";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="xdbjhOiE"
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 8C4D37A00F2;
	Sun, 20 Sep 2026 02:29:31 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-01.internal (MEProxy); Sun, 20 Sep 2026 02:29:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1789885771;
	 x=1789972171; bh=u/1AobQDxsOOeQ8CVIydz3iBjGREabXEcBqTvuHArY4=; b=
	gQqCmPNuJrNTwhFhNQmK53C8gEcM71aXvC4zBDzZiLBnBlZvr+8hQ78SxGtBb6Eg
	GJslEFS5gcPUC878UFqgjaeBFLA55s+u5Kd4K5WIog8J66GFXvIQJVR+9oFAmpMS
	9Xu4MI599Et3NFQpLcU2C9arcrJEUcmkuK3qAzRXAtGb3fCcQpbtLbpvMNw4cjjB
	+MgCMo4AYEVqPzyIt79W7rciIxPAj1x4i8h7zjp4bzs1Z8lwDMUmsua8plLtb+D1
	W9oIdx+Zyh/cS2VP52ZNEB28XnQB+Lb6AWvb+x+WZwg/RyOIPay2zGKIV4Mt7CiV
	+N+CulrkDMkKR6e8lQcBEA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789885771; x=
	1789972171; bh=u/1AobQDxsOOeQ8CVIydz3iBjGREabXEcBqTvuHArY4=; b=x
	dbjhOiEw2s6z0/+KgsOjlKo3ppbcWTnH3NVvJ+WX8G0tL/sBssBGYYoNHSTy2FoG
	Oj324ElUtMf+SrfGKJUn+CVJN93ReLdz3qHfwPX+YFa7oAWPZ26IBmW9rolrnqNr
	lHxukRyfJ6bctfFYpl52G0p0erNA2FTFEER7N8TLQM3dLbduLjhQ6sFxgYZoYtyH
	RNRmVg75H7XKM10TbEqC5dTSPxTRuIZs6LhdFlt7AspCnS1aDlhZ/tng8tKtUpuD
	dMX70YU0B9sIX3cwjZcV+33mh6OpbZpOMn8YCPQh1DhrdAcrbhDrRQeuBlVwnCCI
	UJIarWu1c8z1RvB4tosQg==
X-ME-Sender: <xms:Sn2vauQZ_5NYVxHHdpJkJqRW_i3yuHN-u9O0hmKNcQAUSAQVWNA10g>
    <xme:Sn2vavWEIpHXoDs7wBNdxErpfU3hDe198KPymZulWf8Du_2vAObJR0Y10R3lYpkWP
    PG-UYCXBKLvSZrtyYnPIduRLCo007dyX035PWiroOvmGEbn-3cOgwIc>
X-ME-Received: <xmr:Sn2var1W_aREQmlQN0pnswOsD5tTYjIC77E_k4Z2W-YyKghui2BHwhEp4PicSxlMXmBIcCU07rCvVkfUgHrFklLrLpzjpTzG>
X-ME-Proxy-Cause: dmFkZTGgIvpqL9t+gp5xDPXxzxWSHsiwzzyDnioTKnE0u8JfVZ4TR21yewFpouGj7ocC13
    h6jUSBQ7fxSaCf1T3Ysyec8a6/HIIaGxiGd03ierST4b9yqkGOyUIpBujFlDSVAezFL6p1
    DR51Vq0HgWrLEjl/4uFgskLyv8BIrGoGBz4duXrRI2A/6AmpavL5tyDF22tjkuoXQBt7Le
    pTfyGsgVVgD35rlJiRbpUZQAvbE3PO8c9jg2prl2/40oTxa+JNprMaPwmV6RdWgtJxl4rM
    PxYtYvhiiaGNn0+wzjxACP7LJ4QZJP9sbX52Pgyl6jMVBn692jbyvlGcygS0910jTpWoAP
    V4DlZtp0GYvXbndoxtE8egveYip3u2ZTP5IxfjCY0iIwsiTdViu4lG+89Yji1V8r7ie7lD
    UqTfr91fPQpOD3p9zIXz6nkNT+bnU65FBfU8+a/p66YA1Btlu3XTfQBCS2jr1pQ4vlKRix
    v/uOp/bcD8JOOr9Ou0Rv+yIY6JX+5F9Cy8x5lq3xLpQizUxw3rKIGWoyz+vnAQhly3eLbK
    UVaLwV5IdA8/ibmPPgjT9eFvrY9AirULcshhS1Ywkpz7ahLdzIZQkvuIO/eUtWbsLh965Y
    kcaSsQ4UM8oiVg4k6j2KS4hiF8i5vniQSzXUq2dD9gppnoo6gjqMQBnpsjgQ
X-ME-Proxy: <xmx:Sn2vau-vWLoBIAFPT1mrCokLn9MFpQQnZwL3rv-aTTjp6aizFDMr1w>
    <xmx:Sn2vapezU9AK4Wy4g40TdQsMq7aN4Wx6ZpWXS76ZW6g3VrrSeV8zUg>
    <xmx:Sn2vai7x03RA7YbEUL5KQB8Hg_aYSUGPElNj2bVsCpHPVtCt4JeZtw>
    <xmx:Sn2vatNdnf9_mW-ajLdYVHbKbLzRAP98e6O9K_jSvvKDcOyR3VbP4A>
    <xmx:S32vahGMv3_GaQbyH0Hei3NhRQK1OnBZ-he3vi6eMKe3favocg6NPakQ>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 20 Sep 2026 02:29:27 -0400 (EDT)
Message-ID: <98538a44-63c3-455e-96f3-00124a825f9f@pobox.com>
Date: Sat, 19 Sep 2026 23:29:26 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 0000/1102] 6.12.111-rc1 review
To: Sasha Levin <sashal@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 Kuniyuki Iwashima <kuniyu@google.com>, Eric Dumazet <edumazet@google.com>
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260917151539.408551884@linuxfoundation.org>
 <be8641ad-ed0c-4e6e-a915-0874076159d3@pobox.com>
 <49dc2e4f-7a94-430c-8b02-6f3d422222f3@pobox.com>
 <ce4ba85b47cf4c2e8f7def41@kernel.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <ce4ba85b47cf4c2e8f7def41@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/19/26 10:07 AM, Sasha Levin wrote:
> On Sat, Sep 19, 2026 at 03:54:25AM -0700, Barry K. Nathan wrote:
>>> [   98.363843] RTNL: assertion failed at net/ipv6/mcast.c (1014)
>>> [   98.363896] WARNING: CPU: 6 PID: 961 at net/ipv6/mcast.c:1014 __ipv6_dev_mc_dec+0x17b/0x190 [ipv6]
> 
>> I bisected it to this patch:
>> ipv6-mcast-don-t-hold-rtnl-for-ipv6_drop_membership-.patch.
> 
> Your bisect is right, and thanks for chasing it all the way down --
> the splat is real and the patch you landed on is the trigger.
> 
> I've dropped the ipv6 mcast RTNL conversion patches from the 6.12, 6.6
> and 5.15 queues.
> 
>> If I take 6.12.110, apply the current stable-queue (as of commit
>> 01b20bb84b994fdcda64fd07a66ba84c85d0168f), then revert the
>> following patches:
>>
>> ipv6-mcast-don-t-hold-rtnl-for-ipv6_drop_membership-.patch
>> ipv6-mcast-don-t-hold-rtnl-for-mcast_-socket-options.patch
>> ipv6-mcast-use-copy-on-write-rcu-updates-in-ip6_mc_s.patch
>>
>> then the resulting kernel no longer shows these warnings at all.
> 
> The root cause is a prerequisite we never picked up, rather than anything wrong
> with the patches themselves. Upstream commit e01b193e0b50a ("ipv6: mcast: Use
> in6_dev_get() in ipv6_dev_mc_dec().") is the commit in that series which
> deletes the now-stale ASSERT_RTNL() from __ipv6_dev_mc_dec(), and it was never
> backported to 6.12.y, 6.6.y or 5.15.y. So we took the patches that stop holding
> RTNL across the setsockopt paths while the assertion they were meant to retire
> was still sitting there -- hence net/ipv6/mcast.c:1014 firing on every
> IPV6_DROP_MEMBERSHIP. The queued patches are byte-identical cherry-picks of the
> upstream commits; this is a series-ordering gap on our side, not a botched
> backport.
> 
> 7.2 and 6.18 carry the whole series, including e01b193e0b50a, so they
> are not affected and keep their copies.
> 
> One difference from your experiment: I removed four patches rather than the
> three you reverted. The extra one is 1767bb2d47b7 ("ipv6: mcast: Don't hold
> RTNL for IPV6_ADD_MEMBERSHIP and MCAST_JOIN_GROUP."), which is a pure refactor
> of the join path and was only ever queued as a dependency of the others. It is
> harmless on its own so consistent with you not needing to revert it, but with
> the rest gone there is no reason to keep it, and dropping it keeps the series
> intact for a clean requeue.
> 
> The plan is to requeue the complete ordered set, e01b193e0b50a included,
> once this RC is out.

Thanks for taking care of this!

I have now retested with 6.12.110 + stable-queue as of commit
afa3d2e7536e9034a4917d4b6e228a99d5bd7aa6 on my ThinkPad T14 Gen 1. I can
no longer reproduce this kernel warning (as expected with the patches
being dropped for now), and it's working well, and I have not observed
any other regressions.

Tested-by: Barry K. Nathan <barryn@pobox.com>

-- 
-Barry K. Nathan  <barryn@pobox.com>
