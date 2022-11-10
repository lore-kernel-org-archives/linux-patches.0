Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB061E9E4
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 21:37:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1668116235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kvsDxKUAqwhEsPuDSPoSE+BmSi+geYyZ/4NKm7RNeR8=;
	b=cydj0tHt2BULEJoegkHQvqA/1EWCMlSWKgJht6jLWOMAx5uzG9FbNujNU0X68hMouwWM06
	ZNM1sCZ9Mor4i7SaFWBee1r1vqhnfhgsbb7Qa3ZIQFysw006+HtFxwNoYg02pTLtisOm33
	M/r502Qe8oZJ5wpEK+HO0Ot/ZUAPW+s=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-134-rO3I7Z-7OVy_9xjmSXkzdw-1; Thu, 10 Nov 2022 16:37:14 -0500
X-MC-Unique: rO3I7Z-7OVy_9xjmSXkzdw-1
Received: by mail-ej1-f69.google.com with SMTP id hq18-20020a1709073f1200b007ade8dd3494so1923747ejc.2
        for <patches@lists.linux.dev>; Thu, 10 Nov 2022 13:37:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kvsDxKUAqwhEsPuDSPoSE+BmSi+geYyZ/4NKm7RNeR8=;
        b=k/k+FdoocNLD5TdyZqX3djaXVPN0Ctv0a1KF+kE6B/cxZsDfx3ix+R66bOn0rJLGba
         aNvc9QbP7SHa0W6fxRkxjiyfzjfFaxDq5fXmavihfpBMhoUByVUfhatbvkCeDcUWytGX
         nbdi1AjtWcORznxM1TrSTUPwSYtRVXuOKLDqGXcOHF/UNCb8FIeYDNBkHfo/2AQ5zmBV
         k3gymLkYeDHzTRk9EkgQ5cP0JSyNb45GTNxeaxYO4YDdlj/51rKos5W7l0d2DUnnpp9V
         z+07tlseisMH420yOx/AKcn/sEkyppd2ArLkybeVJ8qNqhM0v5tWpkBBPqSdE1Bb17N7
         u6Kw==
X-Gm-Message-State: ACrzQf3rrwRi7YC+4wr0ohNaLIqhf21yOF39yxq7XPj89Yx4pQn/+QpJ
	zUNjTWE7lYzFapHlB3h5D3jnKdQFGClNum06r1lf/vq3Bo4pPOt1hh15JijWjZT48TdyaOSzyJ0
	SYtZ/yn7kV3aWUS97Zg==
X-Received: by 2002:a05:6402:d50:b0:463:5d1b:99fb with SMTP id ec16-20020a0564020d5000b004635d1b99fbmr3677160edb.269.1668116233114;
        Thu, 10 Nov 2022 13:37:13 -0800 (PST)
X-Google-Smtp-Source: AMsMyM4ictsTm2dFxSHcggJ8pFAA+iJT5cUeirtyr6bMeG9QGFQLps9RbWdUO2eVkvNjg82Z9F/gpQ==
X-Received: by 2002:a05:6402:d50:b0:463:5d1b:99fb with SMTP id ec16-20020a0564020d5000b004635d1b99fbmr3677138edb.269.1668116232896;
        Thu, 10 Nov 2022 13:37:12 -0800 (PST)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id ky14-20020a170907778e00b0078afe360800sm129717ejc.199.2022.11.10.13.37.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Nov 2022 13:37:12 -0800 (PST)
Message-ID: <c4b0cd93-767c-a778-6a38-0e4d981506d3@redhat.com>
Date: Thu, 10 Nov 2022 22:37:11 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH v2 00/14] IFS multi test image support and misc changes
To: Borislav Petkov <bp@alien8.de>, Jithu Joseph <jithu.joseph@intel.com>
Cc: markgross@kernel.org, tglx@linutronix.de, mingo@redhat.com,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 gregkh@linuxfoundation.org, ashok.raj@intel.com, tony.luck@intel.com,
 linux-kernel@vger.kernel.org, platform-driver-x86@vger.kernel.org,
 patches@lists.linux.dev, ravi.v.shankar@intel.com,
 thiago.macieira@intel.com, athenas.jimenez.gonzalez@intel.com,
 sohil.mehta@intel.com
References: <20221021203413.1220137-1-jithu.joseph@intel.com>
 <20221107225323.2733518-1-jithu.joseph@intel.com> <Y2zLYDmO1fkOmFgw@zn.tnic>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <Y2zLYDmO1fkOmFgw@zn.tnic>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US, nl
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Boris,

On 11/10/22 10:59, Borislav Petkov wrote:
> On Mon, Nov 07, 2022 at 02:53:09PM -0800, Jithu Joseph wrote:
>> Changes in v2
>>  - Rebased ontop of v6.1-rc4
>>  Boris
>>    - Moved exported functions (microcode_sanity_check(),
>>       find_matching_signature ) from microcode/intel.c to cpu/intel.c 
>>       (patch4,6)
>>    - Removed microcode metadata specific code changes to
>>       microcode_sanity_check() (patch6)
>>    - Moved find_meta_data() from common to IFS driver (Patch 8)
> 
> What's the upstreaming plan here - I'm assuming I should take the
> microcode patches through the tip tree?
> 
> Or should I take the whole thing through tip so that there's no
> confusion and having to sync and share branches between trees?

I have just reviewed all the platform/x86/intel/ifs changes
and they all look good to me.

I think it is the best and easiest if you just take the whole
branch.

I don't have any changes pending under drivers/platform/x86/intel/ifs
so there should not be any conflicts.

Regards,

Hans


