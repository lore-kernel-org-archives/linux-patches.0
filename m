Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 092677B
	for <patches@lists.linux.dev>; Sun, 19 Jun 2022 14:25:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1655648707;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ekXGr6wfwJ630qszmpOLocmLKM/9kKKdXwFEn2AA3iI=;
	b=aPReI/Y2yJvhwQCX6FX9ohDZPPo//i5zL3mVGbTXiQYbMknByrpj+PkL3/Pv2Mi9dcqcvJ
	W+gAGOxUZ63n38uNCdwpn6wXiryawdvW4x7qA8996sUjidH2JK7DrMq0GWA9Q+89oNtJA8
	VWP4CqycuZSF100ySrdLeHiQasd9ni0=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-1Jbb_BnXP2WUoNFw1ItiVQ-1; Sun, 19 Jun 2022 10:25:01 -0400
X-MC-Unique: 1Jbb_BnXP2WUoNFw1ItiVQ-1
Received: by mail-wm1-f72.google.com with SMTP id i188-20020a1c3bc5000000b0039db971c6d9so4192042wma.7
        for <patches@lists.linux.dev>; Sun, 19 Jun 2022 07:25:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=ekXGr6wfwJ630qszmpOLocmLKM/9kKKdXwFEn2AA3iI=;
        b=z6r1UiEJzaBOji3ZlJGEhD7dUTbu0GZHl/3h2nAhd5B4NZtWq7ckmay7lic08bSZLO
         88ao2fzb068SGYtFKf/+D8Th2yLRdrqw61Fb/QmfklmFYbKoNGUCXeLbTY0RmwNBLWRH
         KkEbP+BaO9HBL53C+cmpWgrrumztZb+JGt8Kz+dLTJmkZy62pOuyjhG7sVMAWm96R+b4
         V2uUB021wT6EaYmaIMiOBPl2iREFYBZdJFWOl29CIZr3Pkbs+vLyWTjW76AXPCFg3961
         +PHEBgSrg4zhMEXsZMEjmLat7viyR0vWsJ/RtKDsROeGjnML9DNAH6MAl2bGwoD8IouF
         cGpA==
X-Gm-Message-State: AJIora/oNeUjBLxOnIL273DwDBDN5OtSh4FF3swrx3+gaEpwKTF4ktC7
	Wszzl0Wa1rC/T/a8aZKBjgZv5uIHYTIDjBvNTytwOdM7ClXPENS7Lu5UQT+V5q/BKUfwdVpCizo
	voemlWScKyS4qL9NlZw==
X-Received: by 2002:a05:600c:1e85:b0:39c:8628:ca96 with SMTP id be5-20020a05600c1e8500b0039c8628ca96mr19915323wmb.176.1655648699748;
        Sun, 19 Jun 2022 07:24:59 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1uIO3SYkr/pIF3ZF8J9uPBKw13uX6xp79wy6oYAWXFvDuLb4bdEEiavSPQrTSVcYnfiw1QK2Q==
X-Received: by 2002:a05:600c:1e85:b0:39c:8628:ca96 with SMTP id be5-20020a05600c1e8500b0039c8628ca96mr19915291wmb.176.1655648699439;
        Sun, 19 Jun 2022 07:24:59 -0700 (PDT)
Received: from [192.168.1.129] (205.pool92-176-231.dynamic.orange.es. [92.176.231.205])
        by smtp.gmail.com with ESMTPSA id o1-20020adfeac1000000b0021b8c554196sm1640464wrn.29.2022.06.19.07.24.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Jun 2022 07:24:58 -0700 (PDT)
Message-ID: <d7469398-d872-3cb3-5238-1696e4e9415b@redhat.com>
Date: Sun, 19 Jun 2022 16:24:57 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] drm: hisilicon: depends on MMU
From: Javier Martinez Canillas <javierm@redhat.com>
To: Randy Dunlap <rdunlap@infradead.org>, dri-devel@lists.freedesktop.org
Cc: Xinliang Liu <xinliang.liu@linaro.org>,
 Chen Feng <puck.chen@hisilicon.com>, patches@lists.linux.dev,
 David Airlie <airlied@linux.ie>, Xinwei Kong
 <kong.kongxinwei@hisilicon.com>, Huang Rui <ray.huang@amd.com>,
 John Stultz <jstultz@google.com>, Gerd Hoffmann <kraxel@redhat.com>,
 Thomas Zimmermann <tzimmermann@suse.de>, Tian Tao <tiantao6@hisilicon.com>,
 Christian Koenig <christian.koenig@amd.com>
References: <20220531025557.29593-1-rdunlap@infradead.org>
 <40d294df-de91-3f36-7d70-13cad54ac34f@redhat.com>
In-Reply-To: <40d294df-de91-3f36-7d70-13cad54ac34f@redhat.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=javierm@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/19/22 16:05, Javier Martinez Canillas wrote:
> Hello Randy,
> 
> On 5/31/22 04:55, Randy Dunlap wrote:
>> Prevent a kconfig warning when MMU is not enabled by making
>> DRM_HISI_HIBMC depend on MMU.
>>
>> WARNING: unmet direct dependencies detected for DRM_TTM
>>   Depends on [n]: HAS_IOMEM [=y] && DRM [=m] && MMU [=n]
>>   Selected by [m]:
>>   - DRM_TTM_HELPER [=m] && HAS_IOMEM [=y] && DRM [=m]
>>   - DRM_HISI_HIBMC [=m] && HAS_IOMEM [=y] && DRM [=m] && PCI [=y] && (ARM64 || COMPILE_TEST [=y])
>>
>> Fixes: 4f7f1973b0c8 ("drm/vram: fix Kconfig")

Actually this fixes isn't the correct one AFAICT, it should probably be
either acad3fe650a5 ("drm/hisilicon: Removed the dependency on the mmu")
or a0f25a6bb319 ("drm/hisilicon/hibmc: Allow to be built if COMPILE_TEST
is enabled"). And those two commits should be mentioned in the description.

Maybe we can append the following two paragraphs to your commit message ?

The Kconfig symbol depended on MMU but that was dropped by commit acad3fe650a5
("drm/hisilicon: Removed the dependency on the mmu") because it already had as
a dependency ARM64 that already selects MMU.

But later, commit a0f25a6bb319 ("drm/hisilicon/hibmc: Allow to be built if
COMPILE_TEST is enabled") allowed the driver to be built for non-ARM64 when
the COMPILE_TEST is set but that could lead to unmet direct dependencies and
linking errors.

If you agree with the changes, I can do it before applying. Please let me know.

-- 
Best regards,

Javier Martinez Canillas
Linux Engineering
Red Hat

