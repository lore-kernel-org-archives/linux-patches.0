Received: from fout-b5-smtp.messagingengine.com (fout-b5-smtp.messagingengine.com [202.12.124.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C192F617C
	for <patches@lists.linux.dev>; Sat, 12 Sep 2026 19:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241395; cv=none; b=mtbf6L3bHaGAPXrTRHTC4m83PyXUX1j08Em1tKyLr3sr+Uy9Lit+Ib+JzCnc6HghFenUEoGBHAJbB2/aRX/H/jPmBdJ2HKx3mfv3vjKXMpAuDG9DDC+xNkGai2Dasq3nq5lcSA3qKepc4GjHDLarm14DNVf7SfqnY/M9W6mRPUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241395; c=relaxed/simple;
	bh=EyUVCCqAqRXXLj2oqGAfheTyrIFtWDcBYNS9ibEnMoM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b7dUqRko2ykWF4QrlayPO2rHVV2qDjccZ9y/lcAFuVLpfNRYo5eIH0vd7ruYjJxGSKwE0XbUH2qJyevV8OSmMv36lncLFiFW2Yo6DTdR9Stxxub3At0QoNDzP8AxVXALQst5PsXVu4OHrY6HI5Y+4JvB6efEXY79e9JIUREHS7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=s3s9Wnku; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=NDE9WT+T; arc=none smtp.client-ip=202.12.124.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="s3s9Wnku";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="NDE9WT+T"
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailfout.stl.internal (Postfix) with ESMTP id C47911D0006A;
	Sat, 12 Sep 2026 15:29:53 -0400 (EDT)
Received: from phl-frontend-01 ([10.202.2.160])
  by phl-compute-03.internal (MEProxy); Sat, 12 Sep 2026 15:29:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm3; t=1789241393;
	 x=1789327793; bh=mxcq3Kn99CJBig0mxJmLpNg3HH5/LJG4CDy/ADEClj4=; b=
	s3s9Wnkui4MZPwoK9CGms47e1pMs8EdcfzFw8sIZ8CIg67CF4zu1mFOsOJ/5dFRe
	bMYVkILzUrGSyCQaKv8t0LeCKE7HctXJAkjsQp0ulqb0StZhAQf7wR9Ymii+3i35
	redtQ4OvnUMXjng/HwD8XeExLIbs3hcBXhPEW3cbO8VASJXeI27GCWJHgeSTHFlM
	6tuVgYGU9ePWJyrdf3aycSprnATJYJAW1oPXNkel9NPB4vz9uCkk/A2lwGvU0M2l
	icA0Y0L3SCLYfTNQIk5LKi9vee57pGkAta8E1PrnFyqR0b/0h/AABu+2M2Z/YaxV
	hMcz8pcEX0GKjrPiBTobyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1789241393; x=
	1789327793; bh=mxcq3Kn99CJBig0mxJmLpNg3HH5/LJG4CDy/ADEClj4=; b=N
	DE9WT+TCYQ0WbUOmxCAt4SK0qKeDR9csjiRO5O9AH3LodlyqUBbagr+3vYWQgA9F
	0QwfRoN/qQ+zGiSKzYxZ+/ksUbD/TWZHCmHH8TfDvGhYWVqAdpODxfh7xTmzpV7y
	mRVDkgW4yrbyzxCuj1mnmV9CS8rcb5DuyfjzUL0BO+yeZRXMJxDqsV3xxHfHuYFb
	FTB5QKTehJyoapFgIZVHFX8ITydJr/iPcRMs2RLvEOUPCZpQ1QCCQ9Cmxc+/6F54
	X565xvFsczD77sK8yA0vMHkeQkF2w/AQMmVEMZSQwUtue+BhtqDYTDxiE24uG+1y
	AmuHNOFbI9OKe1AnLKjrw==
X-ME-Sender: <xms:Mailaid-9ue2WqpI28xnx0s00pbSAJcmJkdEiHpHJHFdZPPrPXtDWg>
    <xme:MailaoO-9jfF_4e9X2_ds0PUpLqH2-Pyy8sy07FVkG4e605-5KLo34ccIAsrRhn3e
    3vwVDDV0-_ZzKJh1KW-ZAMC3ustdxpwG2I1nOSzTafxVRCJj6XIwg>
X-ME-Received: <xmr:MailalsgwEDJ-_wwI3ZtD-UQYJatYt4MxlSkRlxnhgDX8V4wkTVE7c3WrmhJHpqsNrZa6c0VPVhegU_fd2ij1H3-ATjLj8tw>
X-ME-Proxy-Cause: dmFkZTFrBrxmK0R9FtZkxlJIqrAwY69zXvsvnMBLB/maIYONfIaAAsV9ZF9Jk00NABRnmb
    0baHFs0a9uG5nCYeHXoHbLlns4VE+xiFZbeheu1CCU95x+khkg2hMYgykdzDWPqxfRfxKB
    hQg+D3AF2+0jn+lGMzhfKGdBNWs978RDBfxnFRtQCcF/b02MsXMmpewMtgetmkOJ/xH6WU
    5N0t0/6Ei1C8T88/FXECAjzv+1E0K167Dt+WFWYQEKkNFv9Fb3zNtOxL87F5WE5caUZluQ
    BF8K2cFqRPdBK5b/r4RNBqVn95pZu4gMZOzBFmDtxyGL8HvqygM178HekEWTXQaqGazApR
    LgwuGxEjwb4QaLr/ZxQ7Rudnv8Whq/yGntFeljtPgpgcp9qIJCqTiFYQmcBCgHS+Hh3JJw
    vmCoAxrWHgh5Bx4gj47UdGflXwCXunXbhKe0lwRFa+iJBA1sUjHEAjqUc1trL+8XBMXjND
    2k1jN+LsvN70nsa/jKZcuamQyqUaSxd4KtvgpY9shF/osJeYYH0Uv04+s8Au+8iL74KBwF
    vGy8TfndB2Re3JSnoKAixOfS5h0G0/nSjHzFZq/96CDL+0B4AxTgiN5zWeA2bagtHbcDd8
    wFFgZdh9fQb3w+VYOq+xH3T45pcwkFUfxh3RD/HR4c4RVYqpiP5QtAOqyHeg
X-ME-Proxy: <xmx:MailahBpdx8WCvTr33-y905U8Wqy2y-XkcWKKkSp05tKYnqBi1K1gw>
    <xmx:MailasbwGfDzcF6oDVuUWYcjzssVdIoimW2Oslzut9oXHQ23F21MvQ>
    <xmx:MailasUdckFIIuyh6a31DifyW3zIMST0YUr-7aw5eY8pfsqJzjzkJw>
    <xmx:MailarPacS1NVgrJsvMDax0b3ySOMVKzk9-wPCpj4bjDGQbISMm7Zg>
    <xmx:Mailamii1t8e2kW5VSOehXwaX4RuU4e7ToUquF_bTue6KRtNuufq_l8m>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 12 Sep 2026 15:29:52 -0400 (EDT)
Message-ID: <1640d814-0af9-4c10-b0e8-80b6ffaca2a6@pobox.com>
Date: Sat, 12 Sep 2026 12:29:51 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.2 1226/1815] btrfs: fix a lockdep caused by path
 resolution during device scan
To: Qu Wenruo <wqu@suse.com>, Sasha Levin <sashal@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Christian Borntraeger
 <borntraeger@linux.ibm.com>, Filipe Manana <fdmanana@suse.com>,
 David Sterba <dsterba@suse.com>
References: <20260912065648.999753832@linuxfoundation.org>
 <20260912065717.791396667@linuxfoundation.org>
 <d460ffbb-5db6-4029-b177-9273a8261453@suse.com>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <d460ffbb-5db6-4029-b177-9273a8261453@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/12/26 1:51 AM, Qu Wenruo wrote:
> 
> 
> 在 2026/9/12 16:19, Greg Kroah-Hartman 写道:
>> 7.2-stable review patch.  If anyone has any objections, please let me know.
> 
> Please drop this one.
> 
> There are already users (although the minority of users) who do not use an initramfs to boot, and the device path of rootfs stays as "/dev/root".
> 
> With this patch, there will be no way to update the "/dev/root" name of the rootfs.
> 
> Normally it is just a cosmetic problem, but tools like grub2 will be unable to probe the driver for the rootfs.
> 
> I'd argue we should discourage root btrfs without an initramfs, and grub2 should use device number/libblkid to properly detect rootfs devices, but still there are users complaining.
> 
> There will be a special hot fix for it, but I'd prefer to at least delay this one.
> 
> The deadlock itself is not easy to trigger, it requires block device files created on btrfs, and doing block device scan on that file over btrfs.
> 
> Thanks,
> Qu

I see that the stable-queue now has a revert for this patch queued up
in staging-7.2. That could make sense if this patch had already made
it into a 7.2.y release. However, it hasn't yet, so I think it would
make more sense to either (a) just drop this patch from queue-7.2 or
(b) add the revert to queue-7.2 instead of staging-7.2.

(I guess I'm afraid 7.2.6 might be released with this patch even though
it's already known that it needs to be dropped or reverted. Maybe I'm
overreacting, but I just want to make sure this doesn't fall through
the cracks.)

-- 
-Barry K. Nathan  <barryn@pobox.com>
