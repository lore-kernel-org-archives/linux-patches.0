Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4511A7048;
	Thu, 15 Aug 2024 14:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723733466; cv=none; b=X9D2evDMatyPl6KITf7AOP91AwlkgISaaTaN5lXHGzqrd8Kf2yS3501ZYLzQtWdyCQlzRU2pwzkfD4lli+CJOQTNKpmwP195KaUcZmAGZoU86a4bZkXOdJCm1HZ5Jz0Qzp0z0DOB/G+AjkM/vhsFe4i/iZ4XlliWhmd2hm5aoCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723733466; c=relaxed/simple;
	bh=BlPaZhldIsp7N0Q7B093mw+fvVgyB0UDrUMgpBv3CQw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TA0cy998/u8zP+4moh1+SxqKGddWf++HUugKXX70UpkkegroP0NFDJfglUdAVjkhC/kB5XxhiK0eFEyAVasc75nQOTR4mBz1+iGkambxNNewK/GyzRVsmG0vMBo9YuygEc25vntIYJ8PqSXlsiKBouZmEBOdfflg6emWl3Euk7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F25CFC4AF0D;
	Thu, 15 Aug 2024 14:51:04 +0000 (UTC)
Message-ID: <ad064a06-2037-4289-8087-d5a525872c26@xs4all.nl>
Date: Thu, 15 Aug 2024 16:51:03 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 085/484] media: dvb-usb: Fix unexpected infinite loop
 in dvb_usb_read_remote_control()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Zheng Yejian <zhengyejian1@huawei.com>, Sasha Levin <sashal@kernel.org>,
 Mauro Carvalho Chehab <mchehab@kernel.org>
References: <20240815131941.255804951@linuxfoundation.org>
 <20240815131944.570292721@linuxfoundation.org>
 <Zr4MX0elvdkuHZ8j@gofer.mess.org>
 <2024081526-amusement-saddlebag-c622@gregkh>
Content-Language: en-US, nl
From: Hans Verkuil <hverkuil-cisco@xs4all.nl>
In-Reply-To: <2024081526-amusement-saddlebag-c622@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 15/08/2024 16:20, Greg Kroah-Hartman wrote:
> On Thu, Aug 15, 2024 at 03:10:39PM +0100, Sean Young wrote:
>> On Thu, Aug 15, 2024 at 03:19:03PM +0200, Greg Kroah-Hartman wrote:
>>> 5.15-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Zheng Yejian <zhengyejian1@huawei.com>
>>>
>>> [ Upstream commit 2052138b7da52ad5ccaf74f736d00f39a1c9198c ]
>>>
>>> Infinite log printing occurs during fuzz test:
>>>
>>>   rc rc1: DViCO FusionHDTV DVB-T USB (LGZ201) as ...
>>>   ...
>>>   dvb-usb: schedule remote query interval to 100 msecs.
>>>   dvb-usb: DViCO FusionHDTV DVB-T USB (LGZ201) successfully initialized ...
>>>   dvb-usb: bulk message failed: -22 (1/0)
>>>   dvb-usb: bulk message failed: -22 (1/0)
>>>   dvb-usb: bulk message failed: -22 (1/0)
>>>   ...
>>>   dvb-usb: bulk message failed: -22 (1/0)
>>>
>>> Looking into the codes, there is a loop in dvb_usb_read_remote_control(),
>>> that is in rc_core_dvb_usb_remote_init() create a work that will call
>>> dvb_usb_read_remote_control(), and this work will reschedule itself at
>>> 'rc_interval' intervals to recursively call dvb_usb_read_remote_control(),
>>> see following code snippet:
>>
>> This commit causes problems and has been reverted upstream.
>>
>> https://git.linuxtv.org/media_stage.git/commit/?h=fixes&id=0c84bde4f37ba27d50e4c70ecacd33fe4a57030d
>>
>> Please don't apply.
> 
> When will that land in Linus's tree?  Currently this commit is already
> in released 6.1, 6.6, and 6.10 kernels :(

I asked Mauro to make a PR asap. Hopefully for the next rc.

Regards,

	Hans

> 
> thanks,
> 
> greg k-h

