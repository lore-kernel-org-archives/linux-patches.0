Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090476FD7
	for <patches@lists.linux.dev>; Fri, 21 Apr 2023 22:25:00 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-1a7111e0696so5461765ad.1
        for <patches@lists.linux.dev>; Fri, 21 Apr 2023 15:25:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682115900; x=1684707900;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wtOk22wHsRTIJLakW5pQsLDvU50er+NeXN7SxTWy9qk=;
        b=oerIEMuVGMo3tf7ainFnGShOU4ymhQn2JIZkQ5ZB4LQezPNmDezHZ74CsaeAZJQpD6
         fBOri4QsdRMaGb2stkX1WSwEZwfrNh9aQZWqyNJoXurA5LawSG0y1G2Xv1oUcyhDfcMp
         9sbYCkZuE9eli+qnK9IsSiSsdVJHCJSw/W3sMGWPje4NFX463I+v+t7Es1rrOVfCvCrD
         U9gO5mnakr3a3I+Qu1a4NVVPqGjSfvWoKTJthz4c4dgYea4zYEHowFeYEbZOiF95SR+K
         Jq4c5WzqI8i0UVXC3OJDP1Rl9oKvaB8DuqRz1pK4f1u8wkRZdFtR2Oi36akQy0CVWjt4
         77tA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682115900; x=1684707900;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wtOk22wHsRTIJLakW5pQsLDvU50er+NeXN7SxTWy9qk=;
        b=G2R1OYBfbL7NoZUiorMsHT1OtqZ3FJ9/lZ9Qve5Vr2+05qq5830VcJef4WkGgBqOmo
         2zYE7ZtSewjgcgCWFK2BseSbS3oMg/QjRgAI0r8KXoK4tkwN05sdo8gy54HJU0lJN8jE
         7VMMFN3ODRBf9Yd1EnHmzomf2UB3wUfZ8jTZkbapBnLIrXh0rTmULOUTs1+l3jASbVCj
         ZgdpbUshBI75UBj1QxmoCRKcMN/6BqU3NBRoavpGik8d4c/7BzFD4dZ4MhDHBP5gO4Dn
         RBxBuii1X7fgfboYybNW9xCRqX0BPFPXVSQD8YAumN9mOdrZQDME8H0k1vH3kSvCBV0D
         umRg==
X-Gm-Message-State: AAQBX9ei7OdHpojs0aLetmqANfLmGduxOq+G+qtLKsJsQAOhnfMBoUaG
	JJBPU6FK1jgg4fiEaOO1+WKvFQ==
X-Google-Smtp-Source: AKy350ab5zsgqMFX9gmLPlFbJI6JNwFXd5UcuHSryHmhAdUudcIDmmGg6bERrDL3LQkvBwimuDuVEg==
X-Received: by 2002:a17:902:c94f:b0:1a2:1a52:14b3 with SMTP id i15-20020a170902c94f00b001a21a5214b3mr7699856pla.4.1682115900155;
        Fri, 21 Apr 2023 15:25:00 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id jn15-20020a170903050f00b001a945e7147asm1657335plb.231.2023.04.21.15.24.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 15:24:59 -0700 (PDT)
Message-ID: <47688c1d-9cf1-3e08-1f1d-a051b25d010e@kernel.dk>
Date: Fri, 21 Apr 2023 16:24:57 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 3/5] iomap: simplify iomap_init() with PAGE_SECTORS
Content-Language: en-US
To: Luis Chamberlain <mcgrof@kernel.org>, Matthew Wilcox <willy@infradead.org>
Cc: agk@redhat.com, snitzer@kernel.org, philipp.reisner@linbit.com,
 lars.ellenberg@linbit.com, christoph.boehmwalder@linbit.com,
 hch@infradead.org, djwong@kernel.org, minchan@kernel.org,
 senozhatsky@chromium.org, patches@lists.linux.dev,
 linux-block@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
 drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org, hare@suse.de,
 p.raghav@samsung.com, da.gomez@samsung.com, kbusch@kernel.org
References: <20230421195807.2804512-1-mcgrof@kernel.org>
 <20230421195807.2804512-4-mcgrof@kernel.org>
 <ZELuiBNNHTk4EdxH@casper.infradead.org>
 <ZEMH9h/cd9Cp1t+X@bombadil.infradead.org>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZEMH9h/cd9Cp1t+X@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 4/21/23 4:02 PM, Luis Chamberlain wrote:
> On Fri, Apr 21, 2023 at 09:14:00PM +0100, Matthew Wilcox wrote:
>> On Fri, Apr 21, 2023 at 12:58:05PM -0700, Luis Chamberlain wrote:
>>> Just use the PAGE_SECTORS generic define. This produces no functional
>>> changes. While at it use left shift to simplify this even further.
>>
>> How is FOO << 2 simpler than FOO * 4?
>>
>>> -	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
>>> +	return bioset_init(&iomap_ioend_bioset, PAGE_SECTORS << 2,
> 
> We could just do:
> 
> 
> -	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
> +	return bioset_init(&iomap_ioend_bioset, 4 * PAGE_SECTORS,
> 
> The shift just seemed optimal if we're just going to change it.

It's going to generate the same code, but the multiplication is arguably
easier to read (or harder to misread).

-- 
Jens Axboe


