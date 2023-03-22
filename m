Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87869476
	for <patches@lists.linux.dev>; Wed, 22 Mar 2023 18:11:54 +0000 (UTC)
Received: by mail-wm1-f45.google.com with SMTP id o32so5691764wms.1
        for <patches@lists.linux.dev>; Wed, 22 Mar 2023 11:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679508713;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wH9gz+uMM82vCmnLttArcGg6W9CwxF2l6yihMvMNQwM=;
        b=YiGAJ1zflo1QS4PsNbTOmua7Q+uSsVMaUMSruW1QNVW1ikgt8HoUCgM8TgXWoAjSBz
         FkL//ytmdorCrCfmGGMAkpehPWjmBppCxEWT4THazv+EkThGuiQLkkfkTjUfO39bwgcf
         8XrRTiLW5IIf40t70D9LqOdJhc8+H+WHtZQILMZQuUYIS+6mQMVIeqKlGvbxr5Zh6+f1
         7wTM69agtP8cuJPg5e3wlINEU5elWzpPHiemwicZ7mX5BHPLlHfwh5i0OQlVmRuPZTiS
         xbyAj3+1k7ehqU6HQfCtxs1NA2pckKqidsjJgVbkOcG4M+/d2Xa9+ZuIuNRVLp1KvdGu
         T/Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679508713;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wH9gz+uMM82vCmnLttArcGg6W9CwxF2l6yihMvMNQwM=;
        b=HdPqosC5EvogpIV3VFJsvYzaeDRJrnTsxBD0Rq3kLGnhwDccGgvDRxpbNmChuwGTM0
         w2uEu7SochbVyIvcSyfEgyXKC6QCiJeohdmA/PKem8jLWWhavzC1WOkljD3H3IL0ZuTn
         qMr0KgclYObSKtfSraGIAWdT4AdQdqZnpoaPqbB9CTCxwry6RO/1cwDem3f0zz+3IAB1
         1lnUoRRk9jugKAuecOSNcY+6WruDpsUtEAEum4G9dtys+B3YJUQxbNmogN0DCRrt2zfZ
         fGaZfAnEiuGjdqFM+2gOlYWNqfmddmClJN6HDyNCgKhtXBk+JoA3v7SEL18vyPHzhLWE
         RKxg==
X-Gm-Message-State: AO0yUKWGhuLet6f4hNeViLtOKjZLKaz1b9J2EvEpnnLSDLZbdhE2pQ+Y
	GFNkRJSTSCkg/C9kHF9n7Rc=
X-Google-Smtp-Source: AK7set+GDmjksRoXYfoH2H1YV/xncp5rkqdyO6qld78vYYrfz0Lza0R/8Wk31rvQzQmWq2hAM4OjkA==
X-Received: by 2002:a1c:f709:0:b0:3ed:c763:2765 with SMTP id v9-20020a1cf709000000b003edc7632765mr354755wmh.7.1679508712828;
        Wed, 22 Mar 2023 11:11:52 -0700 (PDT)
Received: from [192.168.0.210] (cpc154979-craw9-2-0-cust193.16-3.cable.virginm.net. [80.193.200.194])
        by smtp.googlemail.com with ESMTPSA id f9-20020a05600c154900b003ede03e4369sm12070729wmg.33.2023.03.22.11.11.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Mar 2023 11:11:51 -0700 (PDT)
Message-ID: <bf1c475c-b98c-7381-33c0-602c2ab6349a@gmail.com>
Date: Wed, 22 Mar 2023 18:11:50 +0000
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH v3] stress-module: stress finit_module() and
 delete_module()
To: Luis Chamberlain <mcgrof@kernel.org>, patches@lists.linux.dev,
 linux-modules@vger.kernel.org, linux-kernel@vger.kernel.org,
 pmladek@suse.com, david@redhat.com, petr.pavlu@suse.com, prarit@redhat.com
Cc: christophe.leroy@csgroup.eu, song@kernel.org, dave@stgolabs.net,
 a.manzanares@samsung.com, fan.ni@samsung.com, vincent.fu@samsung.com
References: <20230322032350.3439056-1-mcgrof@kernel.org>
 <ZBtDSh6f+rWqFLtC@bombadil.infradead.org>
Content-Language: en-US
From: "Colin King (gmail)" <colin.i.king@gmail.com>
In-Reply-To: <ZBtDSh6f+rWqFLtC@bombadil.infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 22/03/2023 18:04, Luis Chamberlain wrote:
> On Tue, Mar 21, 2023 at 08:23:50PM -0700, Luis Chamberlain wrote:
>> Example uses:
>>
>> sudo ./stress-ng --module 1 --module-name xfs
>> sudo ./stress-ng --module 1 --module-name xfs --module-sharedfd
> 
> The use case with --module 8192 was causing some errors from
> stress-ng having unexpected bail out messages before ramp up.
> 
>> diff --git a/stress-module.c b/stress-module.c
>> new file mode 100644
>> index 00000000..cee581bd
>> --- /dev/null
>> +++ b/stress-module.c
>> +			//snprintf(module_path, strlen(module_path), "%s/%s/%s",
>> +			snprintf(module_path, PATH_MAX*2, "%s/%s/%s",
>> +				 dirname_default_prefix,
>> +				 u.release, module);
>> +			ret = 0;
> 
> I forgot to remove this stray comment.

No worries, I can fix that up when I apply the patch.

> 
>> +	/*
>> +	 * We're not stressing the modules.dep --> module path lookup,
>> +	 * just the finit_module() calls and so only do the lookup once.
>> +	 */
>> +	if (args->instance != 0) {
>> +		if (!module_path_found)
>> +			return EXIT_SUCCESS;
>> +	}
> 
> So here was the reason for the complaints, Although changing this to
> return just EXIT_NO_RESOURCE cures the warning, I don't think the
> non instance 0 workers are doing anything then. Is that right Colin?

I'll have a look at that when I test this out later tonight.

> 
>    Luis

