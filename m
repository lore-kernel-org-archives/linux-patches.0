Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F13A6FDA
	for <patches@lists.linux.dev>; Thu, 28 Dec 2023 09:08:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FZHV48O8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1703754481;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4dvIT8jGXG+RMMytEd2ps7+QjIyG5dcVpLq72q/MxXU=;
	b=FZHV48O8omS8Q8zy/TiBnr35etjkK0ikVdToiOPYCtrTmkM7hvrTxbkzlampniPzmxCYip
	CqjTvFu4cBbJXClVaHs9hoVkzEt50XnwNW9AFiVRcDsPNkcatniMH+qlUst08oJPM6oCpl
	k8CxkNiwZI8QOzGfD6HbnnhAEqKO7EI=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-318-nJpDHGrdMHySQJx6pxdmng-1; Thu, 28 Dec 2023 04:07:59 -0500
X-MC-Unique: nJpDHGrdMHySQJx6pxdmng-1
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-555a14c0251so85198a12.3
        for <patches@lists.linux.dev>; Thu, 28 Dec 2023 01:07:59 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703754478; x=1704359278;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4dvIT8jGXG+RMMytEd2ps7+QjIyG5dcVpLq72q/MxXU=;
        b=dDxHKVN5IIxbmHCH0B3avu9QwFazAm28MR9x98k9QIJNV/AM1ZRQbQH0+2VXe2A3qU
         onYFhxgJSlYJZWIwyWgW+MQmYHH403CFVO0im4NlsITiHA5yWJAkYflKGMCapOc0Tjq9
         FfRdJw41rTDrp6fF0Tbgw5MCjxqbXawgKDXzRmVxLM9m3PscsY708sKMESVT8wPsZE+O
         i89VRsFMulCGh3yWx1r0o5VwDnv9OXu0/o+MN2NqZdnQpVlT7Hvc4h6pMi/9rxlyO1N1
         CEhYF+vin9jItdFNvF4FY3sB51jVGwRzRe4NHm6/nDa+e9odK3LjZFMOEQiYjRIUfum1
         CHIA==
X-Gm-Message-State: AOJu0Yx5VOUydMmX63qxFQkieB1rkaxCwRlYoyviEwBXC4dA/gQffXPu
	yoxF58tgpLnlp0EfSKg6I8hXOr2jSxb6LVJwNH8WObYIk7CPNzNJXqaQHK2h3HxA8Bpsf3y9RFU
	Le1s2emJdkEZS0fv2Neesi4gxaA==
X-Received: by 2002:a50:aadc:0:b0:54c:4837:93e9 with SMTP id r28-20020a50aadc000000b0054c483793e9mr6669899edc.48.1703754478433;
        Thu, 28 Dec 2023 01:07:58 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGz1E0wObea0BXX5EKeZRCy+Xu44cqa4YVVGqTaXAZMLM5AuKdKRUr/PdvArl18ROG2qHlq+g==
X-Received: by 2002:a50:aadc:0:b0:54c:4837:93e9 with SMTP id r28-20020a50aadc000000b0054c483793e9mr6669894edc.48.1703754478147;
        Thu, 28 Dec 2023 01:07:58 -0800 (PST)
Received: from ?IPV6:2001:1c00:c32:7800:5bfa:a036:83f0:f9ec? (2001-1c00-0c32-7800-5bfa-a036-83f0-f9ec.cable.dynamic.v6.ziggo.nl. [2001:1c00:c32:7800:5bfa:a036:83f0:f9ec])
        by smtp.gmail.com with ESMTPSA id ck8-20020a0564021c0800b0055515b40464sm3248814edb.81.2023.12.28.01.07.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Dec 2023 01:07:57 -0800 (PST)
Message-ID: <1e88b853-7d72-4e4a-8a91-70d945024a96@redhat.com>
Date: Thu, 28 Dec 2023 10:07:56 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] platform/x86/intel/pmc: Fix recent instances of
 -Wmissing-prototypes
To: Nathan Chancellor <nathan@kernel.org>, irenic.rajneesh@gmail.com,
 david.e.box@intel.com, ilpo.jarvinen@linux.intel.com,
 rajvi.jingar@linux.intel.com
Cc: platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
 Stephen Rothwell <sfr@canb.auug.org.au>
References: <20231222-intel-pmc-missing-prototypes-v1-0-3f0d47377d4c@kernel.org>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20231222-intel-pmc-missing-prototypes-v1-0-3f0d47377d4c@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US, nl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 12/22/23 19:27, Nathan Chancellor wrote:
> As reported by Stephen at [1], there are a few instances of
> -Wmissing-prototypes, which break the build with CONFIG_WERROR=y. This
> series marks these functions as static because they are not used outside
> of these translation units.
> 
> Feel free to squash these into the original changes if the branch is not
> set in stone.
> 
> [1]: https://lore.kernel.org/all/20231222135412.6bd796cc@canb.auug.org.au/

Thank you for your patch-series, I've squashed the patches into
the original commits in my review-hans branch:
https://git.kernel.org/pub/scm/linux/kernel/git/pdx86/platform-drivers-x86.git/log/?h=review-hans

Note it will show up in my review-hans branch once I've pushed my
local branch there, which might take a while.

Once I've run some tests on this branch the patches there will be
pushed to the platform-drivers-x86/for-next branch and eventually
will be included in the pdx86 pull-request to Linus for the next
merge-window.

Regards,

Hans



> ---
> Nathan Chancellor (2):
>       platform/x86/intel/pmc: Mark arl_d3_fixup() and arl_resume() as static
>       platform/x86/intel/pmc: Mark lnl_d3_fixup() and lnl_resume() as static
> 
>  drivers/platform/x86/intel/pmc/arl.c | 4 ++--
>  drivers/platform/x86/intel/pmc/lnl.c | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)
> ---
> base-commit: 119652b855e6c96676406ee9a7f535f4db4e8eff
> change-id: 20231222-intel-pmc-missing-prototypes-8fb5014b16b8
> 
> Best regards,

