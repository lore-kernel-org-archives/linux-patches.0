Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB4C2F24
	for <patches@lists.linux.dev>; Fri, 21 Apr 2023 22:36:18 +0000 (UTC)
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-24b276ee13bso493062a91.1
        for <patches@lists.linux.dev>; Fri, 21 Apr 2023 15:36:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1682116578; x=1684708578;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=15RShbsbHafAtkHP7bE1KcywW8eNaWBCC5WwysBd87o=;
        b=X268rOQmAauSwpFpkoX8A+VMI3nbTHDxHe03vObHL12UvaNQ9OZDDghjH9vFasft+g
         PYxDZ2ddlEnrBvSZCCswbGQjuj0a4dR+kh2mJ0z22UZa2NwQu3fbel/NVm1GcQyaY2D+
         O50k+TmBf4HHRjAIC8Ls3kC3p1dwuD7vfBIye6nZ4HPWbaqWdHXW444BirS8nDiLAtUU
         iCsGJUjimDoRzGfcImcCPFqeDTmyul4Bzysh1Fcv0SrV/e/frNSAMaHCrzc2xVjC/QHk
         wid15bGQMFWU0GREAmCPjVoJuZjI3Ed7vrEJlHnKEii0hoXezMgBGw0KFsqu2RUatHhR
         JkiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682116578; x=1684708578;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=15RShbsbHafAtkHP7bE1KcywW8eNaWBCC5WwysBd87o=;
        b=ffi7L4tlmEBWnJDvarOur6BKY50D/Xl2K614tWv0uv55MnLticwCM4LRA1g+xPhlJC
         kGWUFwVSLixy55aYlyH5U6jU7hwwA3XXqBbvLTc1S4IS+rd0y9u4vyYerxRbKUM1F/Gr
         iADsAp3pAo6DMEUfKswabBHHJRxmsRaMiUD99Jb8N9fkV15nSFIWSFJLpNsv1h12cwBn
         Jtdf0bvBLI85KHF9lXE9wuiEAusblSILIL8PZqPb96wBsponugM6LB2sgVxkL+vjK4WN
         F9xkehlfyjPIUGO3hN0bK3jORrCOT+Ly+14ssK5uz0ewRpSJnQ5KQRiZBJwaB3p5AbW2
         hx5Q==
X-Gm-Message-State: AAQBX9eJIW2YQt9V3p0WU3TjIMB/oJbpv0r1ZOJNzcZnqAP5QoIDVF/U
	pmg3Wfw/pJrCQ7vFAtyrRLdv+A==
X-Google-Smtp-Source: AKy350Y1d3Fo78/V0SBbMlTnA/KEzF4Q+15jV06Q1VNcWOt1KOIozBpCp75pUHwmvH01uVtRJ4USXg==
X-Received: by 2002:a17:90a:195d:b0:247:446f:7d05 with SMTP id 29-20020a17090a195d00b00247446f7d05mr6076988pjh.0.1682116578148;
        Fri, 21 Apr 2023 15:36:18 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id il7-20020a17090b164700b00247150f2091sm5021149pjb.8.2023.04.21.15.36.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Apr 2023 15:36:17 -0700 (PDT)
Message-ID: <e032f210-f8cc-6441-2481-3c5341f8e72f@kernel.dk>
Date: Fri, 21 Apr 2023 16:36:13 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 3/5] iomap: simplify iomap_init() with PAGE_SECTORS
To: Luis Chamberlain <mcgrof@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, agk@redhat.com, snitzer@kernel.org,
 philipp.reisner@linbit.com, lars.ellenberg@linbit.com,
 christoph.boehmwalder@linbit.com, hch@infradead.org, djwong@kernel.org,
 minchan@kernel.org, senozhatsky@chromium.org, patches@lists.linux.dev,
 linux-block@vger.kernel.org, linux-mm@kvack.org, linux-xfs@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, dm-devel@redhat.com,
 drbd-dev@lists.linbit.com, linux-kernel@vger.kernel.org, hare@suse.de,
 p.raghav@samsung.com, da.gomez@samsung.com, kbusch@kernel.org
References: <20230421195807.2804512-1-mcgrof@kernel.org>
 <20230421195807.2804512-4-mcgrof@kernel.org>
 <ZELuiBNNHTk4EdxH@casper.infradead.org>
 <ZEMH9h/cd9Cp1t+X@bombadil.infradead.org>
 <47688c1d-9cf1-3e08-1f1d-a051b25d010e@kernel.dk>
 <ZEMOeb9Bt60jxV+d@bombadil.infradead.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZEMOeb9Bt60jxV+d@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/21/23 4:30?PM, Luis Chamberlain wrote:
> On Fri, Apr 21, 2023 at 04:24:57PM -0600, Jens Axboe wrote:
>> On 4/21/23 4:02?PM, Luis Chamberlain wrote:
>>> On Fri, Apr 21, 2023 at 09:14:00PM +0100, Matthew Wilcox wrote:
>>>> On Fri, Apr 21, 2023 at 12:58:05PM -0700, Luis Chamberlain wrote:
>>>>> Just use the PAGE_SECTORS generic define. This produces no functional
>>>>> changes. While at it use left shift to simplify this even further.
>>>>
>>>> How is FOO << 2 simpler than FOO * 4?
>>>>
>>>>> -	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
>>>>> +	return bioset_init(&iomap_ioend_bioset, PAGE_SECTORS << 2,
>>>
>>> We could just do:
>>>
>>>
>>> -	return bioset_init(&iomap_ioend_bioset, 4 * (PAGE_SIZE / SECTOR_SIZE),
>>> +	return bioset_init(&iomap_ioend_bioset, 4 * PAGE_SECTORS,
>>>
>>> The shift just seemed optimal if we're just going to change it.
>>
>> It's going to generate the same code, but the multiplication is arguably
>> easier to read (or harder to misread).
> 
> Then let's stick with the 4 * PAGE_SECTORS. Let me know if you need another
> patch.

Just send out a v2 at some point, you've also got a number of cases
where there are superfluous parenthesis, at least in patch 4, and Willy
pointed one out in an earlier patch too. Didn't check the last one.

This will be 6.5 anyway I think, I already sent out the changes for the
6.4 merge window.

-- 
Jens Axboe

