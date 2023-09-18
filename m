Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5051CAA4
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 13:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695042951;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=34rQIte300nczPmzdZIQ1NSonzmNPTyp0RtMBm5cR0Y=;
	b=Ku2JhV4nMQhbLs1DFa0vUhavbe3KHCeuZWCkIYkq9cdxc4aTR2/4dy9RY6uNs5xXCnHz+g
	3QRjfBvdZB/Sx/uOwXT8nN/y0Wf2Tq784p/LI2+7pqcDr5K515Qqk9tFPGqtmj7Kw/NM9m
	hffEMufydzlqp9lmmbVUo0F6OieYnR8=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-453-PS5lxsc5MPCN9Ob_9bZ4vQ-1; Mon, 18 Sep 2023 09:15:50 -0400
X-MC-Unique: PS5lxsc5MPCN9Ob_9bZ4vQ-1
Received: by mail-ej1-f71.google.com with SMTP id a640c23a62f3a-9ae0601d689so80458466b.0
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 06:15:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695042949; x=1695647749;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=34rQIte300nczPmzdZIQ1NSonzmNPTyp0RtMBm5cR0Y=;
        b=b9/Jj5nSxYjPIb+96iir5p6cQvV71qll9zO4iGMyVHRthZ6ipYGO/S26Cp9FLcp3Ai
         v6mICndyY/jgabFjL8nKHaMzalmVshnXJP6LyGzQ921kbURuv+8gkTGNr4kUPYzN6bBj
         Z8aA5BE1lZlunPrFBryScA9BNSjr/tolQLYGZtrvns8i36tU9YVL2ZJtyY7nq2Rdi4yh
         mg1fpfdIP6U7IdMXAkl6RsR67RZHnTF27wdlhAfXLOKjbn6qNOw4QuWh2CLmpxjkBv4i
         QTCeGzsffRRSePuJzflIKtmo/mMG8NLINias2B+NnCrzq+cOYk4XCA5JXRBGiTQHYQgU
         G82g==
X-Gm-Message-State: AOJu0YyUK/LRwR+WMKIzGFjyTA0NgwG/V8qg/VBgOERh8pxSNX/8uFwJ
	T4+UfFPyph0iUBmq7TliKh2s4xshE85uHZg1X3p7yRTaT2GP02BVn0bBxGPaGjuotSqVZENGe8O
	jQWsfAwiqHMAKxCC4nQ==
X-Received: by 2002:a17:906:11e:b0:9a9:f042:dec0 with SMTP id 30-20020a170906011e00b009a9f042dec0mr8788679eje.38.1695042948962;
        Mon, 18 Sep 2023 06:15:48 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFPRndgc3ZfM7OHhQ220xzzsbF85k8TbGlrnVPHutsbogvIjs7mfg2ynOLLFRsRtA/PNsyMnA==
X-Received: by 2002:a17:906:11e:b0:9a9:f042:dec0 with SMTP id 30-20020a170906011e00b009a9f042dec0mr8788664eje.38.1695042948698;
        Mon, 18 Sep 2023 06:15:48 -0700 (PDT)
Received: from [10.40.98.142] ([78.108.130.194])
        by smtp.gmail.com with ESMTPSA id cw17-20020a170906c79100b009a1a5a7ebacsm6386554ejb.201.2023.09.18.06.15.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 06:15:48 -0700 (PDT)
Message-ID: <25f3c9e1-0b67-5a83-e69b-9a7e0225c267@redhat.com>
Date: Mon, 18 Sep 2023 15:15:47 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v4 0/4] platform/x86: intel_scu_ipc: Timeout fixes
To: Stephen Boyd <swboyd@chromium.org>,
 Mika Westerberg <mika.westerberg@linux.intel.com>,
 Mark Gross <markgross@kernel.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 platform-driver-x86@vger.kernel.org,
 Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
 Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
 Prashant Malani <pmalani@chromium.org>
References: <20230913212723.3055315-1-swboyd@chromium.org>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20230913212723.3055315-1-swboyd@chromium.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 9/13/23 23:27, Stephen Boyd wrote:
> I recently looked at some crash reports on ChromeOS devices that call
> into this intel_scu_ipc driver. They were hitting timeouts, and it
> certainly looks possible for those timeouts to be triggering because of
> scheduling issues. Once things started going south, the timeouts kept
> coming. Maybe that's because the other side got seriously confused? I
> don't know.
> 
> I added some sleeps to these paths to trigger the timeout behavior to
> make sure the code works. Simply sleeping for a long time in busy_loop()
> hits the timeout, which could happen if the system is scheduling lots of
> other things at the time.
> 
> I couldn't really test the last patch because forcing a timeout or
> returning immediately wasn't fast enough to trigger the second
> transaction to run into the first one being processed.

Thank you for your patch, I've applied this patch to my fixes
branch:
https://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.git/log/?h=fixes

Note it will show up in my fixes branch once I've pushed my
local branch there, which might take a while.

I will include this patch in my next fixes pull-req to Linus
for the current kernel development cycle.

Regards,

Hans




> Changes from v3 (https://lore.kernel.org/r/20230911193937.302552-1-swboyd@chromium.org):
>  * Use readx_poll_timeout() to shorten a line
> 
> Changes from v2 (https://lore.kernel.org/r/20230906180944.2197111-1-swboyd@chromium.org):
>  * Use read_poll_timeout() helper in patch #1 (again)
>  * New patch #3 to fix bug pointed out by Andy
>  * Consolidate more code into busy check in patch #4
> 
> Changes from v1 (https://lore.kernel.org/r/20230831011405.3246849-1-swboyd@chromium.org):
>  * Don't use read_poll_timeout() helper in patch 1, just add code
>  * Rewrite patch 2 to be simpler
>  * Make intel_scu_ipc_busy() return -EBUSY when busy
>  * Downgrade dev_err() to dev_dbg() in intel_scu_ipc_busy()
> 
> Stephen Boyd (4):
>   platform/x86: intel_scu_ipc: Check status after timeout in busy_loop()
>   platform/x86: intel_scu_ipc: Check status upon timeout in
>     ipc_wait_for_interrupt()
>   platform/x86: intel_scu_ipc: Don't override scu in
>     intel_scu_ipc_dev_simple_command()
>   platform/x86: intel_scu_ipc: Fail IPC send if still busy
> 
>  drivers/platform/x86/intel_scu_ipc.c | 66 +++++++++++++++++-----------
>  1 file changed, 40 insertions(+), 26 deletions(-)
> 
> Cc: Prashant Malani <pmalani@chromium.org>
> 
> base-commit: 2dde18cd1d8fac735875f2e4987f11817cc0bc2c

