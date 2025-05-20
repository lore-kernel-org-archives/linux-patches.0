Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F355419F137
	for <patches@lists.linux.dev>; Tue, 20 May 2025 15:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747754540; cv=none; b=IoKhPeqCWDnGycGctSvQeMNoyYKW0HHx1Za6YlEmup8oyJAxSOaxPkUqAiVsPup5rbGV6dHEHau7kuqZFwJMpBw1/1vgNM+fAfmxqVOpSfVSrr97V4BUP67tuUq7xEH9II0p/uE4gzwCIpjETk9uqQHNq6A4utx3pGvFA+kvpx4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747754540; c=relaxed/simple;
	bh=drUTSEyk+wweBp8MzrvZkkg+cv1majfZDXRkJhg6S4A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ynlth4EI2udCiXwgbny4hhc6EL66Vv+7mOi3AtVyvItQxly7MGOn49fK09VYWoDWl4OLnZTRfJ6O8Z8cANKQv0/gyVBqxw2C7jMfGceeiroaXcdUCFgbTJQz1VDETW1c3dMuQHuE9v2xOSyz4fQvRsoQah1okN2efNXZMlCbv1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=G2m/04fl; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="G2m/04fl"
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-85db3475637so213543039f.1
        for <patches@lists.linux.dev>; Tue, 20 May 2025 08:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1747754538; x=1748359338; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=28A77Cb9dd2oxcpPba2mZ0UcBg1frToBP1w7OoG6wpU=;
        b=G2m/04flvQxoZbSqXTTdGlRDhQ+0E432L69OV551TScTKYF5Y8yG24j0/ieLxgOdHm
         V1pZlGyoDwe2Or7Jgqa2IX18tkwr5cwANVWJu7RoYe6FLRdqCxBbp1BwUoMY6e9oo4aE
         zbODJkW1ioAuxNRxlsHCreSiCrXNGYAM1b8NuTco9fbRKoxVkh9CNdGEIV4p9gees8F/
         wBo9MUE3PZ0oFbHJKrxL59goLDyzXuzHk5ewZsFe12b9r3eLjk2jhEXQntVmXXDI17m3
         MK9RbKfORgZ9r1WVvYpmvoImWc2somYhWhB+OGJG7NLGJRwajWzGQlVuQU3sk6FlfeL+
         asrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747754538; x=1748359338;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=28A77Cb9dd2oxcpPba2mZ0UcBg1frToBP1w7OoG6wpU=;
        b=TbMnfL8rfGcJeE9ToEv5dhOjiAgBfhKD/4WnUUFX/pxTtyzfrUyfcazF8WscDWmIrT
         0C4n1TWeWkL3U3pkZkdKACHJ7udzCfAm8f4RlWWLjh6kE/Le1uNN+KUnyBomnetWmz2x
         Cor6q4mdrturyv6zgBaJmeT/QoPb7Vfizshzdcr+zffuInXnP4+GS/+KQFY+yMWZFzFP
         1zAeJhQr4tr73hb1d48jbS5GZpGab6W2m8kygYYUpAzfz4+ZUbgoSl914im4yDfEjd4z
         BrXzoEiYP6ykDhrnIZVxY3Y42Auo2oHP3fM97BmgUM+4Vlr349mckYouDwC4CHmxVwIN
         V/RQ==
X-Forwarded-Encrypted: i=1; AJvYcCVq4AQIkMt/Ww8sgCnr0dp4dY6nutnN9KB69i12c8N9FS+MKGphVwHxCMmM3fm5qWiPyXsLwEDa@lists.linux.dev
X-Gm-Message-State: AOJu0YzomP2iQfOTMxFsg6vOn3MpUEvZgOm8ysQhAO7HzpOzdyhPZdNd
	lQWTq6dotqgkhRSCHVvIMNfOPsfnGQu5bN+Sg+/aKiliP8c351qcoQe6xSNfZ9+8BhE=
X-Gm-Gg: ASbGncsx2v7px08mSwzE1ra7DRMfMyZeaLpuxMbHznAXbHkHPnz1KUfdpCybpZAjFVK
	plT4ODTCM2x9Yj1a8oHlPT5m1YQIaZ5kHDa/3ChAYKxpNWgqlWFVHDllGA1cH/GrF9qHtgfJt9w
	M/rK65AB1lYrMR3EGtnLOVWDh0Qs8ChPOK878Ynv6rGKkDkP7dQgBGGW4SvKBxQwYCAR6npiOSp
	x4yTb+vfoIDrGBLl2QcsI1FrSni7c5V0iOvoqsInL5DvEfFG0TrpC+37qa1HWXtPrGGaMjxLj9q
	CqeA2q/Ukv39Tn6axMbOqTsgGJPWJG01cX0TQjUHfUcvPK9eQWfa+Q3gjQ==
X-Google-Smtp-Source: AGHT+IHybOxTZR7F/QJc0USNLXLQ5L6fwe2BKiXGfcHIJgPUA62KTSuwtc5Hgl89SiSjuXmhZG6uFw==
X-Received: by 2002:a6b:750d:0:b0:86a:441:25ca with SMTP id ca18e2360f4ac-86a175262a9mr2041757139f.6.1747754537676;
        Tue, 20 May 2025 08:22:17 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc38a5b2sm2282150173.9.2025.05.20.08.22.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 08:22:17 -0700 (PDT)
Message-ID: <e05dbb79-9769-4825-aa33-1ed82e9bff69@kernel.dk>
Date: Tue, 20 May 2025 09:22:16 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.14 162/197] loop: Add sanity check for read/write_iter
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Justin Forbes <jmforbes@linuxtx.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 syzbot+6af973a3b8dfd2faefdc@syzkaller.appspotmail.com,
 Lizhi Xu <lizhi.xu@windriver.com>, Christoph Hellwig <hch@lst.de>,
 Sasha Levin <sashal@kernel.org>
References: <20250512172044.326436266@linuxfoundation.org>
 <20250512172050.980575013@linuxfoundation.org>
 <CAFxkdAq+5ur__TPi6ZW9uoOBv037hgn1d_9906cBeXWE=X3Sgw@mail.gmail.com>
 <2025052059-unsteady-octagon-9321@gregkh>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2025052059-unsteady-octagon-9321@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 5/19/25 10:56 PM, Greg Kroah-Hartman wrote:
> On Mon, May 19, 2025 at 06:19:26PM -0600, Justin Forbes wrote:
>> On Mon, May 12, 2025 at 11:51 AM Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>>
>>> 6.14-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Lizhi Xu <lizhi.xu@windriver.com>
>>>
>>> [ Upstream commit f5c84eff634ba003326aa034c414e2a9dcb7c6a7 ]
>>>
>>> Some file systems do not support read_iter/write_iter, such as selinuxfs
>>> in this issue.
>>> So before calling them, first confirm that the interface is supported and
>>> then call it.
>>>
>>> It is releavant in that vfs_iter_read/write have the check, and removal
>>> of their used caused szybot to be able to hit this issue.
>>>
>>> Fixes: f2fed441c69b ("loop: stop using vfs_iter__{read,write} for buffered I/O")
>>> Reported-by: syzbot+6af973a3b8dfd2faefdc@syzkaller.appspotmail.com
>>> Closes: https://syzkaller.appspot.com/bug?extid=6af973a3b8dfd2faefdc
>>> Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
>>> Reviewed-by: Christoph Hellwig <hch@lst.de>
>>> Link: https://lore.kernel.org/r/20250428143626.3318717-1-lizhi.xu@windriver.com
>>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>>> ---
>>>  drivers/block/loop.c | 23 +++++++++++++++++++++++
>>>  1 file changed, 23 insertions(+)
>>
>> We have had an issue failing to set up loop devices with CI and Linus'
>> tree since rc6, and once this patch hit stable it proved to be the
>> culprit.  If I revert this patch, things work as they should. The
>> problem we are seeing is "
>>
>> More information can be found in:
>> https://github.com/coreos/fedora-coreos-tracker/issues/1948
>> and
>> https://openqa.fedoraproject.org/tests/3438220#step/_boot_to_anaconda/5
> 
> Sorry to hear that, please work with the developers to get this resolved
> in Linus's tree and then we will be glad to apply the needed fix from
> there.

Should be sorted and land before 6.15:

https://git.kernel.dk/cgit/linux/commit/?h=block-6.15&id=355341e4359b2d5edf0ed5e117f7e9e7a0a5dac0

-- 
Jens Axboe

