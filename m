Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB3C7F1
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 08:03:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1673596990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=11A68i/ujjvlvNOTfu4F5ZXcyPx1UEmLo0fXGnHQZCM=;
	b=fMBJiTWycdwHuq0qkh8vxiwrI8ev5QebDUv6qsJyxf99cc9JQpSwQ/jLD19SrIkNq+oJ4i
	+SRIz3L0EylSeLdzp1TLuKBi9Vh57KNP9BBmdhq9OWIt5zyBndZassuSbtEPEqUsaLBXwt
	Q/UZAvzNV8u86jwqhQxlAfbQg4ceLvc=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-433-qRyYuXdMNbWCicPNCoxy0Q-1; Fri, 13 Jan 2023 03:03:08 -0500
X-MC-Unique: qRyYuXdMNbWCicPNCoxy0Q-1
Received: by mail-wr1-f71.google.com with SMTP id o5-20020adfba05000000b0029064ccbe46so3926678wrg.9
        for <patches@lists.linux.dev>; Fri, 13 Jan 2023 00:03:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=11A68i/ujjvlvNOTfu4F5ZXcyPx1UEmLo0fXGnHQZCM=;
        b=EnG7BjCNDYL8S2yVuy757jglHzmSwdOG1QQqMqUoOtecLYxQL1/q4yBdv8X0IU2UKl
         Az4CIwBHOJqnR2u1kWkTj90G66012FHG0FjG2fh3BfQkJ564IDvAj8IUUxhV7nrjORWr
         m4LwUd6pl4GvJSB2R+zUUUHlDh2cS3jBGypMdszKYs5bkITD28i+l7kAE/HkbD98lgAG
         lnKrRqLN3+JgTdEspIzKuz39QHOoZrNCFiDsbjx8cHWjwwaQrGPJ27X2gxckljl79aGc
         RApLfDaiVGGyMEGXAC7dCdzYe7rd/AqhFNB7lxMAVc9OsnUdJBkD3FtD3w0IZzvlT4vy
         A1rw==
X-Gm-Message-State: AFqh2koJHc9ggAes/WtajD8LP/jkjBE4qTMjcu2zotZrJJQZ2zKML7IZ
	BrC2IT5O1gdI81UP4r1ZwXjKjRnzeBXSVG1UsgnKTJZhIPrVYdx3nnJTgpvohO7ouTVtltoPLYu
	rcOB4j11yDmh1sV1MOA==
X-Received: by 2002:a05:600c:5128:b0:3c6:e62e:2e67 with SMTP id o40-20020a05600c512800b003c6e62e2e67mr58697266wms.2.1673596987598;
        Fri, 13 Jan 2023 00:03:07 -0800 (PST)
X-Google-Smtp-Source: AMrXdXvVwsf1Jjnk65GgTwR1x8Y5bh32fZraLo5RnjXtvxHHUeem4xVwqG2giy3CQPNe9luzSHMqkw==
X-Received: by 2002:a05:600c:5128:b0:3c6:e62e:2e67 with SMTP id o40-20020a05600c512800b003c6e62e2e67mr58697233wms.2.1673596987293;
        Fri, 13 Jan 2023 00:03:07 -0800 (PST)
Received: from ?IPV6:2a01:e0a:c:37e0:38da:a7d9:7cc9:db3e? ([2a01:e0a:c:37e0:38da:a7d9:7cc9:db3e])
        by smtp.gmail.com with ESMTPSA id n7-20020a05600c4f8700b003c6bd12ac27sm27381636wmq.37.2023.01.13.00.03.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Jan 2023 00:03:06 -0800 (PST)
Message-ID: <e54977a6-d767-7ea4-5259-d9735e5a68e9@redhat.com>
Date: Fri, 13 Jan 2023 09:03:05 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2] drm/i915: Fix CFI violations in gt_sysfs
To: Nathan Chancellor <nathan@kernel.org>
Cc: Jani Nikula <jani.nikula@linux.intel.com>,
 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
 Rodrigo Vivi <rodrigo.vivi@intel.com>,
 Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
 Kees Cook <keescook@chromium.org>, Tom Rix <trix@redhat.com>,
 intel-gfx@lists.freedesktop.org, llvm@lists.linux.dev,
 Nick Desaulniers <ndesaulniers@google.com>, patches@lists.linux.dev,
 dri-devel@lists.freedesktop.org, Andrzej Hajda <andrzej.hajda@intel.com>,
 Sami Tolvanen <samitolvanen@google.com>,
 Andi Shyti <andi.shyti@linux.intel.com>
References: <20221013205909.1282545-1-nathan@kernel.org>
 <4dcf830e-62a5-837b-7590-ac5395f84c14@redhat.com>
 <Y8Atycuni0bl8std@dev-arch.thelio-3990X>
From: Jocelyn Falempe <jfalempe@redhat.com>
In-Reply-To: <Y8Atycuni0bl8std@dev-arch.thelio-3990X>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/01/2023 16:56, Nathan Chancellor wrote:
> Hi Jocelyn,
> 
> On Thu, Jan 12, 2023 at 11:08:17AM +0100, Jocelyn Falempe wrote:
>> This patch does also solve a kernel crash when reading
>> /sys/class/drm/card1/gt/gt0/* on a skylake machine:
>> https://bugzilla.redhat.com/show_bug.cgi?id=2154880
> 
> Interesting, I wonder what aspect of this patch fixes this because I am
> not sure that is an intended consequence of this change but that is
> still good to hear!

I wasn't able to find the root cause, but basically the kobj pointer 
given in the sysfs callback, is not the good one on this machine, so it 
either return garbage or crash.
By chance I found this patch, tried it, and it solves the issue.
> 
> For the record, this is commit a8a4f0467d70 ("drm/i915: Fix CFI
> violations in gt_sysfs") in mainline.
> 
>> Do you think it can be backported to stable releases ?
>> Conflicts are trivial on top of v6.0 at least.
> 
> I had a report from another user of this crash affecting them with kCFI
> so it is on my TODO to backport it to 6.1 (6.0 just went EOL) but I am
> currently out of the office until next Wednesday so I won't be able to
> get to it until then (as I would like to test the backport on affected
> hardware). If someone wants to beat me to it, I won't complain ;)

Thanks for taking care of it, I will wait next week then.

> 
> Cheers,
> Nathan
> 

-- 

Jocelyn

