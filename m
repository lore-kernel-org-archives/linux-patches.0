Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA10E637
	for <patches@lists.linux.dev>; Mon, 23 May 2022 13:45:33 +0000 (UTC)
Received: by mail-qv1-f48.google.com with SMTP id y20so12067325qvx.3
        for <patches@lists.linux.dev>; Mon, 23 May 2022 06:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=fXXuOXxpYqAa8ZcL4iQ7Zr/0+vXNmpz1OjtE6mlyRoA=;
        b=2FYHK8Xr8KL+RJmbK4hGu7IWiSs0Im5AZ8BEgjzCBWMhM/xyoNfWrtHN9Gjz4RogAn
         J9IeWd2Xt+y4sq3Bc2hVj7ERoW3YbK2TejxICpbtdfz/by7nAPr83bma4PxocdzzjZdf
         SjH4nOzoA0Kp7VX82t3rMQsDmqrdXeJg0CpISNe6UFm7dHX7USWZrQkVpixVqW54GMIV
         +X/aRzFjIDtKnBLBA+fh74MeZTm4kLDqI30frQXaI4Pq6PbtpDVkEiWvqV6G5X+493Xc
         jCShrDVu79TOpMP/tu2CFPc0Hb8uf5S4UKhQ9wiiMskO+Xik46gFff4XRW964onmxIen
         dyVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=fXXuOXxpYqAa8ZcL4iQ7Zr/0+vXNmpz1OjtE6mlyRoA=;
        b=vQdtHaoHG3nlxozbf6vwGsy20tKuiMVt5JaBJ0/EdGQD3pkO+gSMmtbHjj2gvbaG4k
         kZAmzapxP94mkLhWThZPi4zx/qLFJhsaDVa3nNhYiachNHnpHAXDIhdMkI+rWGU0Tgwf
         oHj5w5ugqv3YhiThpQKJfKCD/nPdFuh+QcyXkM4vSy1IEwHTE2d5idH0wbVJd7ZQXP1h
         kgF7rxvfT4HocKbiLcG1vFh7FrU5tWC3uiEnVQKuIbQkO7dK3yJPVElYBDUWltLAUbV9
         jYydYqKDwdpuwjPQuxlWmtLQQQ29YQiDcRaYpjZy6kndET7ClxquaGIZ0aWMuKOwhTSu
         qrGw==
X-Gm-Message-State: AOAM530aO52ZHqpWAUah3iF8AxKn5V3A8PO3HRCthi+nJaqm2wrW6Wkt
	Xlwo9eutME8jWCYD9bv4uKzRuw==
X-Google-Smtp-Source: ABdhPJy9KbQYqYcUYxEaBJ+1DpKGdb0pGacMRGgVYJXOymh0fdyUVC8WUcqRnj1UQTFSwFwuT+5j7g==
X-Received: by 2002:ad4:5c41:0:b0:462:199a:1f45 with SMTP id a1-20020ad45c41000000b00462199a1f45mr9969474qva.31.1653313532702;
        Mon, 23 May 2022 06:45:32 -0700 (PDT)
Received: from localhost (cpe-98-15-154-102.hvc.res.rr.com. [98.15.154.102])
        by smtp.gmail.com with ESMTPSA id i1-20020a37b801000000b006a03cbb1323sm4410299qkf.65.2022.05.23.06.45.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 06:45:32 -0700 (PDT)
Date: Mon, 23 May 2022 09:45:31 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-mm@kvack.org, patches@lists.linux.dev,
	Minchan Kim <minchan@kernel.org>, Nitin Gupta <ngupta@vflare.org>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] zram: fix Kconfig dependency warning
Message-ID: <YouP++kk8TztpN7/@cmpxchg.org>
References: <20220522204027.22964-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220522204027.22964-1-rdunlap@infradead.org>

On Sun, May 22, 2022 at 01:40:27PM -0700, Randy Dunlap wrote:
> ZSMALLOC depends on MMU so ZRAM should also depend on MMU
> since 'select' does not follow any dependency chains.
> 
> Fixes this Kconfig warning:
> 
> WARNING: unmet direct dependencies detected for ZSMALLOC
>   Depends on [n]: MMU [=n]
>   Selected by [y]:
>   - ZRAM [=y] && BLK_DEV [=y] && BLOCK [=y] && SYSFS [=y] && (CRYPTO_LZO [=y] || CRYPTO_ZSTD [=m] || CRYPTO_LZ4 [=m] || CRYPTO_LZ4HC [=n] || CRYPTO_842 [=n])
> 
> Fixes: b3fbd58fcbb10 ("mm: Kconfig: simplify zswap configuration")
> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
> Cc: Johannes Weiner <hannes@cmpxchg.org>
> Cc: Minchan Kim <minchan@kernel.org>
> Cc: Nitin Gupta <ngupta@vflare.org>
> Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: Jens Axboe <axboe@kernel.dk>
> Cc: linux-block@vger.kernel.org
> Cc: Andrew Morton <akpm@linux-foundation.org>

Acked-by: Johannes Weiner <hannes@cmpxchg.org>

Thanks Randy!
