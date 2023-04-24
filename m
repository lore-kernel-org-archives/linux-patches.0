Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFF4A7C
	for <patches@lists.linux.dev>; Mon, 24 Apr 2023 08:26:33 +0000 (UTC)
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-3f1950f569eso17399165e9.2
        for <patches@lists.linux.dev>; Mon, 24 Apr 2023 01:26:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linbit-com.20221208.gappssmtp.com; s=20221208; t=1682324792; x=1684916792;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3pxlWKD7dnb+hgIonOTuPgqaiGVvQd+hXe0K6IdPi2M=;
        b=BCLvweSQah01sJW9SBAyC5wgM9gcCgmoD6eVt1pixm6TIMPKSMsfDJ/G6pQ7WifY+a
         jCWSatlOFJoGBGRyqNjpnC83+YZxWwidqcfJV7qrZVFpoOQQ5qGdcpNUfD/1uI304Bsr
         n5t0aKbFfDOlYu2sfU/KiJsKG+tbC5Q3pej1LUOiQjmwv12srCYdM4fwvJqfC1vIGgHG
         i7xM2mHs1udxBgFRdzJGUIySnuCvM4rCCc4KxRtFlArnjXACALMboZpw/c8XanndS9Ts
         WTUnWIGWHkbm7Rk6Wg/mlO7SJDa+qk0PwimjElI9r8oOeFo6sLYUJveYcdOozE2aiQA6
         piSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682324792; x=1684916792;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3pxlWKD7dnb+hgIonOTuPgqaiGVvQd+hXe0K6IdPi2M=;
        b=Z8zWU7UJCTl6MEbBtXHngbIN2ULBdKKsJt+OSRReI7/++51NmyUx/jdXJ4k/70qBfK
         mgfHv/QoFGHf0a4vwKPvi+c9RPnhMKnfzOkqNopLP7pChtK84A2DFAXuAaU5un/MPGNX
         dayqUKNgEhGv3rloKkynI4snzho9T7FllxUaN9rZ31f+FYBiaLOTGuk0JOwxVcEgOdQQ
         NooRNNtS+zWcMgAYMqHRcgkiC6QzI/xvmDVZQdjVFpcR+jTINoZcZh4y40U+gwXoksL2
         fTzErVqWKkW3Q8rzfCjrYB44tv6Xm4jg21S1OOgJW9Hrkndc3TWYsA8MIc/u64ublCxU
         ziwg==
X-Gm-Message-State: AAQBX9fQ57gNG1DJbegHrwxI1UmJa39gs9JB3R34yNZFLOkdgvNIXlW9
	jYjq3g+q3IcvZUqfIK3mICg/Ow==
X-Google-Smtp-Source: AKy350byXoD5GzDBK8BfQEyK98TvcOHuQxalfYGEuCyUBUv+0C+wGb7Sf32jhfdSzffUY8tfHfxXdw==
X-Received: by 2002:a05:600c:259:b0:3f1:662a:93d0 with SMTP id 25-20020a05600c025900b003f1662a93d0mr7829493wmj.15.1682324791970;
        Mon, 24 Apr 2023 01:26:31 -0700 (PDT)
Received: from [192.168.178.55] (h082218028181.host.wavenet.at. [82.218.28.181])
        by smtp.gmail.com with ESMTPSA id l20-20020a05600c16d400b003f19bca8f03sm4904838wmn.43.2023.04.24.01.26.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Apr 2023 01:26:31 -0700 (PDT)
Message-ID: <42c89d18-b68f-a7d0-921a-6f45b54da356@linbit.com>
Date: Mon, 24 Apr 2023 10:26:30 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.1
Subject: Re: [PATCH 2/5] drbd: use PAGE_SECTORS_SHIFT and PAGE_SECTORS
To: Luis Chamberlain <mcgrof@kernel.org>, axboe@kernel.dk, agk@redhat.com,
 snitzer@kernel.org, philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 hch@infradead.org, djwong@kernel.org, minchan@kernel.org,
 senozhatsky@chromium.org
Cc: patches@lists.linux.dev, linux-block@vger.kernel.org, linux-mm@kvack.org,
 linux-xfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 dm-devel@redhat.com, drbd-dev@lists.linbit.com,
 linux-kernel@vger.kernel.org, willy@infradead.org, hare@suse.de,
 p.raghav@samsung.com, da.gomez@samsung.com, kbusch@kernel.org
References: <20230421195807.2804512-1-mcgrof@kernel.org>
 <20230421195807.2804512-3-mcgrof@kernel.org>
Content-Language: en-US
From: =?UTF-8?Q?Christoph_B=c3=b6hmwalder?= <christoph.boehmwalder@linbit.com>
In-Reply-To: <20230421195807.2804512-3-mcgrof@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Am 21.04.23 um 21:58 schrieb Luis Chamberlain:
> Replace common constants with generic versions.
> This produces no functional changes.
> 
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/block/drbd/drbd_bitmap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
> index 6ac8c54b44c7..b556e6634f13 100644
> --- a/drivers/block/drbd/drbd_bitmap.c
> +++ b/drivers/block/drbd/drbd_bitmap.c
> @@ -1000,7 +1000,7 @@ static void bm_page_io_async(struct drbd_bm_aio_ctx *ctx, int page_nr) __must_ho
>  	unsigned int len;
>  
>  	first_bm_sect = device->ldev->md.md_offset + device->ldev->md.bm_offset;
> -	on_disk_sector = first_bm_sect + (((sector_t)page_nr) << (PAGE_SHIFT-SECTOR_SHIFT));
> +	on_disk_sector = first_bm_sect + (((sector_t)page_nr) << PAGE_SECTORS_SHIFT);
>  
>  	/* this might happen with very small
>  	 * flexible external meta data device,
> @@ -1008,7 +1008,7 @@ static void bm_page_io_async(struct drbd_bm_aio_ctx *ctx, int page_nr) __must_ho
>  	last_bm_sect = drbd_md_last_bitmap_sector(device->ldev);
>  	if (first_bm_sect <= on_disk_sector && last_bm_sect >= on_disk_sector) {
>  		sector_t len_sect = last_bm_sect - on_disk_sector + 1;
> -		if (len_sect < PAGE_SIZE/SECTOR_SIZE)
> +		if (len_sect < PAGE_SECTORS)
>  			len = (unsigned int)len_sect*SECTOR_SIZE;
>  		else
>  			len = PAGE_SIZE;

Acked-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>

-- 
Christoph Böhmwalder
LINBIT | Keeping the Digital World Running
DRBD HA —  Disaster Recovery — Software defined Storage
