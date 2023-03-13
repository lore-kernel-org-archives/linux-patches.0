Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C1228F2
	for <patches@lists.linux.dev>; Mon, 13 Mar 2023 15:03:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1678719794;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=pZ49mGv28iBaz7X24970hd41Ch6EkiVMx/J+Ek7710U=;
	b=EDe2jfdIG3Jt3QZA/UM7HRJ7sf1IN74RSnEuGR7/KwJyf2fpMj3MrBjr3SL8NvK1Wi/XzA
	6JIGRw7esRVGgmuKnWsnTIBcHZAWI0VCZK/oqqzufUbDjR6RfbemgLo/TzRFc+cWfm7TJz
	/UPKIrlPUVaCjN22cy3aZFlQkSa+SNQ=
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com
 [209.85.208.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-385-s6CFiiZ_P-6lmFaKB6BMdw-1; Mon, 13 Mar 2023 11:03:10 -0400
X-MC-Unique: s6CFiiZ_P-6lmFaKB6BMdw-1
Received: by mail-ed1-f70.google.com with SMTP id v11-20020a056402348b00b004ce34232666so17264709edc.3
        for <patches@lists.linux.dev>; Mon, 13 Mar 2023 08:03:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678719789;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pZ49mGv28iBaz7X24970hd41Ch6EkiVMx/J+Ek7710U=;
        b=3fphC0KJDC2SmRib6H/t71NHwjsCH0uXXxpHzWYF0zO8OwqquJyt+5ABDMKt8vJ5J5
         VaUpT4lW/yvwIAaFev16doxZsYiE9njOKzuccJePrpbumukdFsFqFAFZMLAiuXfffRyG
         S/G9nDJ2y7vDUVwLXS6Z3rD6DmIKWatyOcl/dDgpNB+9gIx9sJpBITB4P24eSMoRuNbx
         xT2pisMl13tnU8GnWQbvIHzYGPA4RcUheW80YlNvS+VLw8Eei4n9JWhbCWCtXo+AKCI1
         URM0zvUYpZcP6vdkEFCgIo5MLiWgHZBLErGkYYpWOLkMawwBB4bbLAYLwoSkoT6cR2Ur
         epLg==
X-Gm-Message-State: AO0yUKWyE+1jDVUrxxBdB2w9S2C0LBTVHrb/J4mRLXWvMmz1QYA2BWMe
	2wCR4esjLxvZl16oyMIZrUk3aYkQlVnPWUskc1FSCFFCxaTjYYl7s7H5uWgR7xwdM23D7b688SZ
	FvMP5Wlez6SSXHG59iA==
X-Received: by 2002:a17:907:e8d:b0:8af:5752:691f with SMTP id ho13-20020a1709070e8d00b008af5752691fmr42132557ejc.76.1678719789481;
        Mon, 13 Mar 2023 08:03:09 -0700 (PDT)
X-Google-Smtp-Source: AK7set9DZQ94D+TsWkTFR06KObrdN3jzxn91sJ+YsKqm39NbPokTmU4hc+TAPRkNZv5Irs3O4mIJsg==
X-Received: by 2002:a17:907:e8d:b0:8af:5752:691f with SMTP id ho13-20020a1709070e8d00b008af5752691fmr42132536ejc.76.1678719789224;
        Mon, 13 Mar 2023 08:03:09 -0700 (PDT)
Received: from [10.40.98.142] ([78.108.130.194])
        by smtp.gmail.com with ESMTPSA id b21-20020a17090630d500b008cafeec917dsm3524898ejb.101.2023.03.13.08.03.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 08:03:08 -0700 (PDT)
Message-ID: <3a91a794-b56e-eb21-58da-5abc8edbbc37@redhat.com>
Date: Mon, 13 Mar 2023 16:03:08 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v3 3/8] x86/include/asm/msr-index.h: Add IFS Array test
 bits
To: Jithu Joseph <jithu.joseph@intel.com>, markgross@kernel.org
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, x86@kernel.org, hpa@zytor.com,
 gregkh@linuxfoundation.org, rostedt@goodmis.org, ashok.raj@intel.com,
 tony.luck@intel.com, linux-kernel@vger.kernel.org,
 platform-driver-x86@vger.kernel.org, patches@lists.linux.dev,
 ravi.v.shankar@intel.com, thiago.macieira@intel.com,
 athenas.jimenez.gonzalez@intel.com, sohil.mehta@intel.com
References: <20230214234426.344960-1-jithu.joseph@intel.com>
 <20230301015942.462799-1-jithu.joseph@intel.com>
 <20230301015942.462799-4-jithu.joseph@intel.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <20230301015942.462799-4-jithu.joseph@intel.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 3/1/23 02:59, Jithu Joseph wrote:
> Define MSR bitfields for enumerating support for Array BIST test.
> 
> Signed-off-by: Jithu Joseph <jithu.joseph@intel.com>
> Reviewed-by: Tony Luck <tony.luck@intel.com>
> ---
>  arch/x86/include/asm/msr-index.h | 2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/arch/x86/include/asm/msr-index.h b/arch/x86/include/asm/msr-index.h
> index d3fe82c5d6b6..ad8997773ad3 100644
> --- a/arch/x86/include/asm/msr-index.h
> +++ b/arch/x86/include/asm/msr-index.h
> @@ -197,6 +197,8 @@
>  
>  /* Abbreviated from Intel SDM name IA32_INTEGRITY_CAPABILITIES */
>  #define MSR_INTEGRITY_CAPS			0x000002d9
> +#define MSR_INTEGRITY_CAPS_ARRAY_BIST_BIT      2
> +#define MSR_INTEGRITY_CAPS_ARRAY_BIST          BIT(MSR_INTEGRITY_CAPS_ARRAY_BIST_BIT)
>  #define MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT	4
>  #define MSR_INTEGRITY_CAPS_PERIODIC_BIST	BIT(MSR_INTEGRITY_CAPS_PERIODIC_BIST_BIT)
>  


Thanks, patch looks good to me:

Reviewed-by: Hans de Goede <hdegoede@redhat.com>

Regards,

Hans

