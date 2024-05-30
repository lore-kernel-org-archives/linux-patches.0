Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B345155336;
	Thu, 30 May 2024 06:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717050128; cv=none; b=qnakHcMbxxOmI6PuhvG8P19PM9nM92XuF0gbU4a2W1MvilLTxVTuo1k9nOXqJI2c5iWYFd9E3Zc0HrpGm9jxDygjtJjpJRnJ2TRzZtvcXh5WVgqBd8AUgKjEylXShvC5+lIvTXYBDpMqH6tZm4kFu6iiH8LJDsFrhJ6/mvQ11Sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717050128; c=relaxed/simple;
	bh=l9+XfNU1PImZakE7pZoE0Rp+a8gf1C0ee0ya5BBnFx8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=S9CSuUtifBy/oPWdPk5Dw06TLdRP4UoaTWD2RWsbT82b4luukrYBhxXaTG8bSIJKnjEVI4xFtKql9y74yacJgCDMKiwq4NeDDCO0fJ7y55e56IJ2X59x/tyy6CCgQ0ll++dyN3Bokq753O150i8gX4rwz5r2FUzvjSS3Wbn+I8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-42108856c33so3608525e9.1;
        Wed, 29 May 2024 23:22:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717050125; x=1717654925;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9abOIANtUFAdiRrEhSy3lHHZlzhzRD52Y0DRlShRTQs=;
        b=I73dlGjQLnZigFXb+rNj8zz42+zCVpJE3mgHxHPvhvbrijjA9ojSr4jvAOH5qjfuyw
         7hD0PfoCY0ILFCtvEqx4O1qAIKgIGBVXG5bVWvIDHjnglN30xYwbfeGOp8P/nHYLINqK
         4R49C9jTMXt+nZ8QoV/sn7ML+3iyY+kvxNkSMreF0PxJyCPjtpjzeBv0D41D4ZRmCvcZ
         Ergt6PsPwKtokMlx069TDUoogRMk6Ll054stQ465bt46HzaWvLpAt7fiZpecJEA3E/TP
         k8Os0P3a1sk9WIlWLS0J87KGVNt0aHSKgIhZzeeP2BALzB6lZ+TmEdo1OoYRRDxKOrGv
         zVsw==
X-Forwarded-Encrypted: i=1; AJvYcCW6EpU5nY519vLCBgDOSr92qDbNlSyCYWZC8pGXmpPIrA1qPIg4TVwv3qsV9R0Q37aVgqmefSDNKDEjDnUtWa/tpuUJ8lI8MvQ81cAgaHlbRa723eiDuiUN11JiZ6ejydVmPcKbPBXBFN6otyh9xf3UC9s=
X-Gm-Message-State: AOJu0YwWhfsEqbRuful1sugfXAK/GBMj1olb2fPPBpV8JUNxLdRX2lF4
	U9eW3qxpRwl1ZTu90B0zq7k55n+uetVta9HgBEaHQvDg2zWijKbaXWeW8A==
X-Google-Smtp-Source: AGHT+IGs5JBtoA7uXaeGL1MNMQclVfCH2sNp/kA2U36B22flaurOU4tPIhja6hXqTQr+1dIlg2fQJg==
X-Received: by 2002:a05:600c:4fc3:b0:41a:56b7:eb37 with SMTP id 5b1f17b1804b1-4212810404cmr5712365e9.20.1717050125214;
        Wed, 29 May 2024 23:22:05 -0700 (PDT)
Received: from ?IPV6:2a0b:e7c0:0:107::aaaa:69? ([2a0b:e7c0:0:107::aaaa:69])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42127084ca2sm14202265e9.41.2024.05.29.23.22.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 May 2024 23:22:04 -0700 (PDT)
Message-ID: <d7c19866-6883-4f98-b178-a5ccf8726895@kernel.org>
Date: Thu, 30 May 2024 08:22:03 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] tty: mxser: Remove __counted_by from mxser_board.ports[]
To: Nathan Chancellor <nathan@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>,
 "Gustavo A. R. Silva" <gustavoars@kernel.org>,
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>,
 linux-serial@vger.kernel.org, imx@lists.linux.dev,
 linux-arm-kernel@lists.infradead.org, linux-hardening@vger.kernel.org,
 llvm@lists.linux.dev, patches@lists.linux.dev, stable@vger.kernel.org
References: <20240529-drop-counted-by-ports-mxser-board-v1-1-0ab217f4da6d@kernel.org>
Content-Language: en-US
From: Jiri Slaby <jirislaby@kernel.org>
Autocrypt: addr=jirislaby@kernel.org; keydata=
 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
In-Reply-To: <20240529-drop-counted-by-ports-mxser-board-v1-1-0ab217f4da6d@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 29. 05. 24, 23:29, Nathan Chancellor wrote:
> Work for __counted_by on generic pointers in structures (not just
> flexible array members) has started landing in Clang 19 (current tip of
> tree). During the development of this feature, a restriction was added
> to __counted_by to prevent the flexible array member's element type from
> including a flexible array member itself such as:
> 
>    struct foo {
>      int count;
>      char buf[];
>    };
> 
>    struct bar {
>      int count;
>      struct foo data[] __counted_by(count);
>    };
> 
> because the size of data cannot be calculated with the standard array
> size formula:
> 
>    sizeof(struct foo) * count
> 
> This restriction was downgraded to a warning but due to CONFIG_WERROR,
> it can still break the build. The application of __counted_by on the
> ports member of 'struct mxser_board' triggers this restriction,
> resulting in:
> 
>    drivers/tty/mxser.c:291:2: error: 'counted_by' should not be applied to an array with element of unknown size because 'struct mxser_port' is a struct type with a flexible array member.

Huh -- what am I missing:

struct mxser_port {
         struct tty_port port;
         struct mxser_board *board;

         unsigned long ioaddr;
         unsigned long opmode_ioaddr;

         u8 rx_high_water;
         u8 rx_low_water;
         int type;               /* UART type */

         u8 x_char;              /* xon/xoff character */
         u8 IER;                 /* Interrupt Enable Register */
         u8 MCR;                 /* Modem control register */
         u8 FCR;                 /* FIFO control register */

         struct async_icount icount;
         unsigned int timeout;

         u8 read_status_mask;
         u8 ignore_status_mask;
         u8 xmit_fifo_size;

         spinlock_t slock;
};

?

>  This will be an error in a future compiler version [-Werror,-Wbounds-safety-counted-by-elt-type-unknown-size]
>      291 |         struct mxser_port ports[] __counted_by(nports);
>          |         ^~~~~~~~~~~~~~~~~~~~~~~~~
>    1 error generated.
> 
> Remove this use of __counted_by to fix the warning/error. However,
> rather than remove it altogether, leave it commented, as it may be
> possible to support this in future compiler releases.

This looks like a compiler bug/deficiency.

What does gcc say BTW?

> Cc: stable@vger.kernel.org
> Closes: https://github.com/ClangBuiltLinux/linux/issues/2026
> Fixes: f34907ecca71 ("mxser: Annotate struct mxser_board with __counted_by")

I would not say "Fixes" here. It only works around a broken compiler.

> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>   drivers/tty/mxser.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/tty/mxser.c b/drivers/tty/mxser.c
> index 458bb1280ebf..5b97e420a95f 100644
> --- a/drivers/tty/mxser.c
> +++ b/drivers/tty/mxser.c
> @@ -288,7 +288,7 @@ struct mxser_board {
>   	enum mxser_must_hwid must_hwid;
>   	speed_t max_baud;
>   
> -	struct mxser_port ports[] __counted_by(nports);
> +	struct mxser_port ports[] /* __counted_by(nports) */;
>   };
>   
>   static DECLARE_BITMAP(mxser_boards, MXSER_BOARDS);

thanks,
-- 
js
suse labs

