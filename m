Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91258225D7
	for <patches@lists.linux.dev>; Wed,  8 Jan 2025 03:58:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736308702; cv=none; b=je+s58Btl6gDVYD3OioxL7p7AxBFhRAc8Dwi0x7zU/GdUIQopu0IFV5HkZEhBcOybBFFkHUZgvEy6+Sx5k2j/SVSeDnRYghz3Qxx5wH7JSFuOWLfLiQsooSgZ0U2VNFo8eUNKWinO3t8yqdj7sOzL+HFY1EgfM/zyNQZzvd7wII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736308702; c=relaxed/simple;
	bh=zNGpVWpLu9Qvd2Wn/x54cG2h3cDfMLeqXE5y1RN712w=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tBsDgfR9nOivseZQwyvFjO1vIXfLB8ktgZq5XECLi+512g/vcMTIyucBMzoOlmEcfe6tGQ3iMcrmKmzW3TV78iCSV2KFDvoXiivYChDMiDAiLngGUpImWEWLw5gpo41g/9N2EPMSOP8K+lbMVU4fVEJImzcP3yIzWIoH9h/DX20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Ka2TCq1j; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Ka2TCq1j"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2156e078563so209313945ad.2
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 19:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1736308700; x=1736913500; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=kcBrl6keYH+0kZEwvvhNEQ1sIGNcdbWuJh+Y5ZXPHk8=;
        b=Ka2TCq1jGpNSGgYxchUrq21LNHocRmHPdkda/lMbO+lYybTXEcyvMyU2D3qSm55KnH
         jN0wwGof08lBJkqD5DzfUhbO0n4v7ij6nhMYiDH9lrToqSrK9RnwfEnyyIVmLex9hu7Q
         1r6y0he2dlXqOQLCy6yBTWpGIiarEF6VsKV1w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736308700; x=1736913500;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kcBrl6keYH+0kZEwvvhNEQ1sIGNcdbWuJh+Y5ZXPHk8=;
        b=faJK2Sn/Ah4vh5WmG62kO63zqihKlH+/iSgTGvHdiO43jooMnW8mk5v6JVxJ/5cG/c
         UEhNByT3Iul56jf/W6jojJxGejQGqxy2yGRYY2rQTmGQEO7T73Tpfxk2U+t1itAh0VGR
         3Ru4oCsTg+yul5QFoIEWhfrWTzZjFbYYFA3HEg53ANrAnoqxt9wN6220M5X0+doO6S/k
         urKaOihxkjfmRMX3S1QhUNmSHDWSe9FcaTfbONhQhcpDJB2E5yKAA/hI9V3VsFDYJ9qU
         Y25aDYjfwFDxxFXBGQUZ09Vkh3aWFrPqiB3JfT2p2a+YsIEFFoPashDDDfNMF9hodK1W
         R83A==
X-Forwarded-Encrypted: i=1; AJvYcCWbrTxhhH9EJhQ3SdTCexgNKCElzgDj/WqIWNUFav2PqUEXIdbb3ygx3JxIqgD95IUokjNH9LIr@lists.linux.dev
X-Gm-Message-State: AOJu0YyOLk6iY5BHF3Kcnx01pZBZ0GancLeQo9Np4rt9Hx3ulWeuNHou
	n6wAhweDKPWZbxIU8W9CpvNDJPEzScUbN6sXrhdJn8nB086i4qE6ZJp5HNTIOLBEZgv5pQq4d2s
	=
X-Gm-Gg: ASbGnctpUf1JXWs/xdKWPP7NUVCXeVkX7nMcztSB3bip2RjmJyaLe6LKrz5HfT50k3K
	/+HSYk5JXQt8acYkqQiJr7EM8yuUKxgDUzxz9h8LMe1wR5VXTk03qpQlhVTYA4kHraS+bdFQGDs
	yCAVKmzY98zAqi3uJOA/RYfXzbm7Q/1lQnExBddwslsh49ebyP54fiAcCTYHShZFAkFfrG/2Gha
	dvob1oWChZFdMLYkcMycuvf5xAGDypISXiMrzuxrSYafhfn+T4rp2yc+UIp
X-Google-Smtp-Source: AGHT+IFRI8VkNI5WzMBkrf+NdV1dwwPsWeNqtxBjhBmLN1x0Izyt9QoJfA3EZ0ajsULkV25Jflag2A==
X-Received: by 2002:a17:903:2b08:b0:216:70b6:8723 with SMTP id d9443c01a7336-21a83fb5af8mr24176405ad.44.1736308699936;
        Tue, 07 Jan 2025 19:58:19 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:57ef:1197:3074:36c2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc962dc0sm319522885ad.32.2025.01.07.19.58.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 19:58:19 -0800 (PST)
Date: Wed, 8 Jan 2025 12:58:15 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Kairui Song <kasong@tencent.com>, Desheng Wu <deshengwu@tencent.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.6 086/116] zram: fix uninitialized ZRAM not releasing
 backing device
Message-ID: <tsalwprwgp2b4uarbrjzik6m4hg5kbezjthdqxp3foxuu2vyws@vtvw7sl5fp6w>
References: <20241223155359.534468176@linuxfoundation.org>
 <20241223155402.907380237@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241223155402.907380237@linuxfoundation.org>

On (24/12/23 16:59), Greg Kroah-Hartman wrote:
> 6.6-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Kairui Song <kasong@tencent.com>
> 
> commit 74363ec674cb172d8856de25776c8f3103f05e2f upstream.
> 
> Setting backing device is done before ZRAM initialization.  If we set the
> backing device, then remove the ZRAM module without initializing the
> device, the backing device reference will be leaked and the device will be
> hold forever.
> 
> Fix this by always reset the ZRAM fully on rmmod or reset store.
> 
> Link: https://lkml.kernel.org/r/20241209165717.94215-3-ryncsn@gmail.com
> Fixes: 013bf95a83ec ("zram: add interface to specif backing device")
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Reported-by: Desheng Wu <deshengwu@tencent.com>
> Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Can we please drop this patch?
