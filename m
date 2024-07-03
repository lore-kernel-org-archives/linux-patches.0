Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4233A4502F
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 07:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719992238; cv=none; b=Q7h9hHScjg1nDYG0BHIACx+0VgkgOSepsD6Hc9oeq8PB4JyiyWi6pXTM1gmL9kzOd4T2TjK1lKZaxlZnbIrw3XemygFMNFcBdp22pArAlpX+3ZMAvnGvJnjnmintsU+9VDtR3CkfWDbW5sfKTFOIZ+7GjHJSSbj7Bokd9dyr2h0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719992238; c=relaxed/simple;
	bh=3/2xUJWJqL2AVXcUeDubHF554/b8IyfHiqe+6Tj6uik=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=mLuiieOHnDUuLPesK+LmSN8g95hgLxUwXfoP0ow64xI4SjRSGSJkQooJODkk4o5el8hOE6GF1R+wGOCVF3Z2IlTwCbSZdj9iByjdj/HsNIX5J8SPtOiFt1kEVy4981ojBi/Z6ksldtM+t5YcR3TcShRykrU1nTC0BC64frdb2Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JBg4v+Wp; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JBg4v+Wp"
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-58bac81f39bso2040556a12.2
        for <patches@lists.linux.dev>; Wed, 03 Jul 2024 00:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719992235; x=1720597035; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=lMl4iRO1YuDlX2Ud//wZYwgLTyyIvMk1jNwwBPa+My8=;
        b=JBg4v+Wp8uqsjVKs5mTd+grYdNQ9UBW2zVTqBjK78/kBFqWvMsoKDVK2/DADguCZdT
         nHj9aeJYj14SYLpn1gMP2js/un97jEvVWk7Oes1RTjSvi03zaTiL7BC0ULj5V45+rmYJ
         6bZLi26CbffJQ178bNf0BWN5MYvshkgXVaDRttG8dUB/siO5HFXv6/nV+wta0j02Zrfq
         LHFyIs6lf/COFgqX7IkRUiO8UketPxwXOILEXu+KFXlF41Ke8lavklGdKWHhUiWnsqND
         Y7OIxPbU0Xcf6tb0/PXFa56R8Xl1r8T46fubuWTIDX1sMdKTr7zNkNCwUG5fhBY0tfxO
         1DaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719992235; x=1720597035;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lMl4iRO1YuDlX2Ud//wZYwgLTyyIvMk1jNwwBPa+My8=;
        b=jIREwGi8sBp4+2No9vp/MQYIHBdtGpYxFsFj4FIHT4vV0YE19D/C1P7RYbLZ8qJk9k
         DjBM/Rps4IsQ5yKobJpcnY5J1ySJTJq45xU5F9XEkUWLz7FPNiZIUQrFat60CUrm2K8P
         pSGRMmZ7THVnA21iXw9MdZrV7plKSvJhCDLHcFkB7wQTyosg2cdweyVvpnaak8mE/nQY
         tGytEY8yY+8JfrhL/cOBgbD6tXpG5H2myguDlarsIS+E5PY/9XU+ItEkQXisxZLhUzHg
         MdkATQG8AFhsELhtMPzzEIRCUxp2PuX6UvV7sqVH/kV/GmfQuzGbQNxS4+KJskHVDyKo
         EC+Q==
X-Forwarded-Encrypted: i=1; AJvYcCUSmzYBH0XY94QmeTukeIosvOXV8f/15izbx1UsILQF4qV2spCMGzwNsyKDzgKgLVgRtRXkS+TRywSPQ/6GrJbxD3hz4yiN2A==
X-Gm-Message-State: AOJu0YwWQHdfWJrHRAPWs6IKsO+mEdR2i+lvhXw4eGf2VIuU8qIrkI0J
	KXp9Nyop5H7EC69xjyE9xL3YifI5IFmtGYu6XkI+0THedltJZkARY1V0gg==
X-Google-Smtp-Source: AGHT+IH/ddLtxXmfcBR5QwiJFprQt4iRv2LQvAMdxb/ujTTIzlNpb3AJXn7VGlt51cO3XxyBPG+oBA==
X-Received: by 2002:a05:6402:440a:b0:57c:b7c3:99f1 with SMTP id 4fb4d7f45d1cf-5879f59a549mr7443851a12.11.1719992235377;
        Wed, 03 Jul 2024 00:37:15 -0700 (PDT)
Received: from eichest-laptop (31-10-206-125.static.upc.ch. [31.10.206.125])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5861324f036sm6661701a12.34.2024.07.03.00.37.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jul 2024 00:37:14 -0700 (PDT)
Date: Wed, 3 Jul 2024 09:37:13 +0200
From: Stefan Eichenberger <eichest@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Stefan Eichenberger <stefan.eichenberger@toradex.com>,
	francesco.dolcini@toradex.com
Subject: Re: [PATCH 6.1 091/128] serial: imx: set receiver level before
 starting uart
Message-ID: <ZoT_qUw9BGuZ0Alm@eichest-laptop>
References: <20240702170226.231899085@linuxfoundation.org>
 <20240702170229.664632784@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240702170229.664632784@linuxfoundation.org>

Hi Greg,

On Tue, Jul 02, 2024 at 07:04:52PM +0200, Greg Kroah-Hartman wrote:
> 6.1-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Stefan Eichenberger <stefan.eichenberger@toradex.com>
> 
> commit a81dbd0463eca317eee44985a66aa6cc2ce5c101 upstream.
> 
> Set the receiver level to something > 0 before calling imx_uart_start_rx
> in rs485_config. This is necessary to avoid an interrupt storm that
> might prevent the system from booting. This was seen on an i.MX7 device
> when the rs485-rts-active-low property was active in the device tree.
> 
> Fixes: 6d215f83e5fc ("serial: imx: warn user when using unsupported configuration")
> Cc: stable <stable@kernel.org>
> Signed-off-by: Stefan Eichenberger <stefan.eichenberger@toradex.com>
> Link: https://lore.kernel.org/r/20240621153829.183780-1-eichest@gmail.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  drivers/tty/serial/imx.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> --- a/drivers/tty/serial/imx.c
> +++ b/drivers/tty/serial/imx.c
> @@ -1978,8 +1978,10 @@ static int imx_uart_rs485_config(struct
>  
>  	/* Make sure Rx is enabled in case Tx is active with Rx disabled */
>  	if (!(rs485conf->flags & SER_RS485_ENABLED) ||
> -	    rs485conf->flags & SER_RS485_RX_DURING_TX)
> +	    rs485conf->flags & SER_RS485_RX_DURING_TX) {
> +		imx_uart_setup_ufcr(sport, TXTL_DEFAULT, RXTL_DEFAULT);
>  		imx_uart_start_rx(port);
> +	}
>  
>  	return 0;
>  }

Unfortunately, I introduced a regression with this patch. The problem
was detected by our automated tests when running a loopback test with
SDMA enabled. Please do not apply this  patch to any stable branch. I
could provide a fix for mainline on top of this change, or would you
prefer to revert it for now?

Sorry for the inconvenience,
Stefan
