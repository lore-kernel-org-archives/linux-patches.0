Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12ED52568
	for <patches@lists.linux.dev>; Tue, 16 May 2023 03:11:36 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-52867360efcso9682249a12.2
        for <patches@lists.linux.dev>; Mon, 15 May 2023 20:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684206695; x=1686798695;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3J82zgcvQQcJJp/2cHTcE2ACq6VvKBeJPxEYaDcJPYM=;
        b=su0UcXg8LMVGZZ5nxnP9RE7kRfFlqXo27PXPaApGSzhrVEpHKovFA6aJlkDyY5y38b
         cREUTwyCx9QM8eQbMM+t27BvdQp/IlillYy4sfMKww8CnxqQ/h2kcYFjOOZ1HjLuw9Bj
         Nb84weP9RlxB8uX/4BHn/wAHRpYeiCuBpE6hSBGKWjqg7p7xgE5dptEJNsAsF3Rq1PQ9
         vZgj9Q41zjvsjQwbP5brbsQHpkr2Jugm1GXtV90RjitmVjww+RLGE+/Un4hb8J1KtqB9
         jt2Bjq9Jeltf8OleNcVcEKhjNcTpJLi86craeJd9lGZzbwqXNrCadTFq+T8x1NrMZiHc
         JSLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684206695; x=1686798695;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3J82zgcvQQcJJp/2cHTcE2ACq6VvKBeJPxEYaDcJPYM=;
        b=bgwo2kwjFoJfwovL2LHZiP9SQ8gSiERPmXIrqYG6MJ3TsA0P8/yJI+koKSxpFb4hS2
         8Gy47Poy4EEDbNJQtzjxg+rslwIyw1iWKRS5IsNip8F6xMfQFvxcn7pFwpYU8pcpRU/l
         KWPEWdGVK5jXhODr5Eda8wgvP2MHaHlZ2TLiHRKtcRezC4Om/dcb9zFzOtHyhn6vKPaH
         mpXn18bb5Cqk8PuZGS+1e399lCIi4QifEEOkHxUkE7aa4wVl4jsHQ5bILA7hCkdsrgnK
         Wn2r+VShRbe/8tyV177MOOouEjMi+LVweRLRGoZl7Yj0iuinKcPS2p/V/PgNvB7zfUMt
         5OBA==
X-Gm-Message-State: AC+VfDwQBDl47uTc3f/xWf12SSj+6u/XnyA8peOft+b7JMH+ercE6haz
	JZDLIqWNfNOjep1WCINWOyQ=
X-Google-Smtp-Source: ACHHUZ5BrlMsNVWYQldfhWMn10p1IfPzfzZIkIuVYJvAAw2Xkyjc0sFdAT1rOvtDMWg6KYOgmMyejQ==
X-Received: by 2002:a05:6a20:8f22:b0:101:962b:8dc5 with SMTP id b34-20020a056a208f2200b00101962b8dc5mr29454668pzk.36.1684206695348;
        Mon, 15 May 2023 20:11:35 -0700 (PDT)
Received: from [192.168.1.105] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id y3-20020a655a03000000b00512fbdd8c47sm1228137pgs.45.2023.05.15.20.11.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 May 2023 20:11:34 -0700 (PDT)
Message-ID: <e6f7f148-4bbe-c3c0-6c1f-1637e9999811@gmail.com>
Date: Mon, 15 May 2023 20:11:33 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.1
Subject: Re: [PATCH 5.4 151/282] serial: 8250: Add missing wakeup event
 reporting
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>
References: <20230515161722.146344674@linuxfoundation.org>
 <20230515161726.751095012@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230515161726.751095012@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 5/15/2023 9:28 AM, Greg Kroah-Hartman wrote:
> From: Florian Fainelli <f.fainelli@gmail.com>
> 
> [ Upstream commit 0ba9e3a13c6adfa99e32b2576d20820ab10ad48a ]
> 
> An 8250 UART configured as a wake-up source would not have reported
> itself through sysfs as being the source of wake-up, correct that.
> 
> Fixes: b3b708fa2780 ("wake up from a serial port")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Link: https://lore.kernel.org/r/20230414170241.2016255-1-f.fainelli@gmail.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/tty/serial/8250/8250_port.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/tty/serial/8250/8250_port.c b/drivers/tty/serial/8250/8250_port.c
> index 907130244e1f5..3d369481d4db1 100644
> --- a/drivers/tty/serial/8250/8250_port.c
> +++ b/drivers/tty/serial/8250/8250_port.c
> @@ -19,6 +19,7 @@
>   #include <linux/moduleparam.h>
>   #include <linux/ioport.h>
>   #include <linux/init.h>
> +#include <linux/irq.h>
>   #include <linux/console.h>
>   #include <linux/sysrq.h>
>   #include <linux/delay.h>
> @@ -1840,6 +1841,7 @@ int serial8250_handle_irq(struct uart_port *port, unsigned int iir)
>   	unsigned char status;
>   	unsigned long flags;
>   	struct uart_8250_port *up = up_to_u8250p(port);
> +	struct tty_port *tport = &port->state->port;

Looks like we need to drop this second declaration since we have the 
same one a few lines above. It did not show in the patch context, but it 
is there and it will cause:

drivers/tty/serial/8250/8250_port.c: In function 'serial8250_handle_irq':
drivers/tty/serial/8250/8250_port.c:1845:19: error: redefinition of 'tport'
   struct tty_port *tport = &port->state->port;
                    ^~~~~
drivers/tty/serial/8250/8250_port.c:1841:19: note: previous definition 
of 'tport' was here
   struct tty_port *tport = &port->state->port;
                    ^~~~~
-- 
Florian
