Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCAE01CAA4
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 13:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695042609;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h10nQ6s5QO9q+6L/VOx4oaL4rhI+++b1cmPnkwJcEk0=;
	b=dsknGHXXNiKnSVn3L1mS4TQe+aCsEF8c6JqAyHQIGyOoIvbVSb7Pnu9rvWAcG1NdJX8Ck7
	zpnz61+ysJCuT1MVbUsUCIOsvVI/5SnNiapVL5wqpeBHN5+joewnQ38KpvBULpfg0iQeKE
	rpv7NSJEHdpmSdNR3UD1B2uUvMTPMPw=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-437-xLuJep96MAaMQu9pR40-8Q-1; Mon, 18 Sep 2023 09:10:08 -0400
X-MC-Unique: xLuJep96MAaMQu9pR40-8Q-1
Received: by mail-ed1-f70.google.com with SMTP id 4fb4d7f45d1cf-52a1ce52ad4so7248770a12.0
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 06:10:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695042607; x=1695647407;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=h10nQ6s5QO9q+6L/VOx4oaL4rhI+++b1cmPnkwJcEk0=;
        b=fwCA4P+Ea7jjPoD4W7PbKv4YZ0SjLmOXzTl+4yco3mxWUisnh2vD27rEM4Z7z5bpD3
         7XawLpajI/nmaB0r1UAvLtsT5cmMyQK2RykLpc5EO5wiQWh6fpqc1zFmFuG8HCuMkqb3
         2V3iWOK43cqP5rZZxSpTjdDo7w4xPr3y/7yARd0ixieeeHnPs5hjCh8HgDgpR0b4PkhL
         ELWp8Al5/EWuoYatiuGosjM45DY6GnOlhCeSKwbA+ZW2Kh5BjmWUJVGqi7KXb2CG88na
         U3iy7fj1YdNdqAE4MD5WaU+Km9U8/TEL7dzW8hbfy6cs4YTJ5UJXq8wKpMKHoLn8YBjK
         v3YQ==
X-Gm-Message-State: AOJu0YwJMM5vccw7STSVuaeCn/079dAG3MKodcDwQXfE3gJUCYSo65U5
	Zz8bMUVpFV08GUWOG4umoY/v8FmjaW+owDkQbmJ1mk1P8UZYdT6kFxXNATK8+AZpsjoy7b3y2+E
	69XKqFbz+d3dH4aiTsg==
X-Received: by 2002:aa7:ca57:0:b0:522:d801:7d07 with SMTP id j23-20020aa7ca57000000b00522d8017d07mr12038030edt.10.1695042607024;
        Mon, 18 Sep 2023 06:10:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFrCUzByvaHDuzwz9dA++tpD+CsBMvm5ziYlbHBa9FF8hVi8rWew3VDyoEooCRZavaHtMfrMg==
X-Received: by 2002:aa7:ca57:0:b0:522:d801:7d07 with SMTP id j23-20020aa7ca57000000b00522d8017d07mr12037997edt.10.1695042606697;
        Mon, 18 Sep 2023 06:10:06 -0700 (PDT)
Received: from [10.40.98.142] ([78.108.130.194])
        by smtp.gmail.com with ESMTPSA id v4-20020aa7d644000000b0052567e6586bsm6090836edr.38.2023.09.18.06.10.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 06:10:05 -0700 (PDT)
Message-ID: <a0573057-8b93-f6f8-59eb-e8d30ac7035f@redhat.com>
Date: Mon, 18 Sep 2023 15:10:05 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 2/4] platform/x86: intel_scu_ipc: Check status upon
 timeout in ipc_wait_for_interrupt()
To: =?UTF-8?Q?Ilpo_J=c3=a4rvinen?= <ilpo.jarvinen@linux.intel.com>,
 Stephen Boyd <swboyd@chromium.org>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
 Mark Gross <markgross@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 patches@lists.linux.dev, platform-driver-x86@vger.kernel.org,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
 Prashant Malani <pmalani@chromium.org>
References: <20230913212723.3055315-1-swboyd@chromium.org>
 <20230913212723.3055315-3-swboyd@chromium.org>
 <2bd9b7e2-a558-305b-bfd9-e64c28b6303d@linux.intel.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <2bd9b7e2-a558-305b-bfd9-e64c28b6303d@linux.intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Ilpo,

On 9/15/23 15:49, Ilpo Järvinen wrote:
> On Wed, 13 Sep 2023, Stephen Boyd wrote:
> 
>> It's possible for the completion in ipc_wait_for_interrupt() to timeout,
>> simply because the interrupt was delayed in being processed. A timeout
>> in itself is not an error. This driver should check the status register
>> upon a timeout to ensure that scheduling or interrupt processing delays
>> don't affect the outcome of the IPC return value.
>>
>>  CPU0                                                   SCU
>>  ----                                                   ---
>>  ipc_wait_for_interrupt()
>>   wait_for_completion_timeout(&scu->cmd_complete)
>>   [TIMEOUT]                                             status[IPC_STATUS_BUSY]=0
>>
>> Fix this problem by reading the status bit in all cases, regardless of
>> the timeout. If the completion times out, we'll assume the problem was
>> that the IPC_STATUS_BUSY bit was still set, but if the status bit is
>> cleared in the meantime we know that we hit some scheduling delay and we
>> should just check the error bit.
> 
> Hi,
> 
> I don't understand the intent here. What prevents IPC_STATUS_BUSY from 
> changing right after you've read it in ipc_read_status(scu)? Doesn't that 
> end you exactly into the same situation where the returned value is stale 
> so I cannot see how this fixes anything, at best it just plays around the 
> race window that seems to still be there after this fix?

As I understand it the problem before was that the function would
return -ETIMEDOUT; purely based on wait_for_completion_timeout()
without ever actually checking the BUSY bit:

Old code:

	if (!wait_for_completion_timeout(&scu->cmd_complete, IPC_TIMEOUT))
		return -ETIMEDOUT;

This allows for a scenario where when the IRQ processing got delayed
(on say another core) causing the timeout to trigger,
ipc_wait_for_interrupt() would return -ETIMEDOUT even though
the BUSY flag was already cleared by the SCU.

This patch adds an explicit check for the BUSY flag after
the wait_for_completion(), rather then relying on the
wait_for_completion() return value which implies things
are still busy.

As for "What prevents IPC_STATUS_BUSY from 
changing right after you've read it in ipc_read_status(scu)?"

AFAICT in this code path the bit is only ever supposed to go
from being set (busy) to unset (not busy), not the other
way around since no new commands can be submitted until
this function has completed. So that scenario cannot happen.

Regards,

Hans

