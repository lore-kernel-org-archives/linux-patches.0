Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D31C1FC0
	for <patches@lists.linux.dev>; Mon,  9 May 2022 18:12:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1652119924;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=PDz7CXT91tsteQlydOBrXVm/Nk7FX3udXe6Lvda4gk0=;
	b=AyhvVZdSsLr4NuaYtkqT8YrfxkGUiP32KjGzyzHonlofTXElXIkr89uTKZ/Jpdbo82kVWQ
	+beoip5uypF0f2zRdycQ+V+kKI3+qbxwVMnqCq12iimAz0oLADl6X8J9KB9X6Z5qDi5PPs
	fyw79ULiTP4TpdBdm01bsAEOvlD6Jdo=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-58-xtKANDniPXuOoNZ6W_ve4w-1; Mon, 09 May 2022 14:12:03 -0400
X-MC-Unique: xtKANDniPXuOoNZ6W_ve4w-1
Received: by mail-ed1-f71.google.com with SMTP id t25-20020a508d59000000b00425d86c2987so8762722edt.21
        for <patches@lists.linux.dev>; Mon, 09 May 2022 11:12:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PDz7CXT91tsteQlydOBrXVm/Nk7FX3udXe6Lvda4gk0=;
        b=bXA7vMpgr9jGyg87lY50FCtkoGiph42Z3BGs8bPxYH8hVXljXXB3xBkHv9MmVWzFvZ
         0bugYgGvl/ifqQhcdW7Hh0i8ngrdVPCLbyS7L+1w5DENKmUZE6kp1VGZP/ecz/1GQFJJ
         kVD7AbCjO+ePSQAURX3uDr9Z5znkUImVDNwyJafls4CUU5CyNNtpC7QlOJvaCf5buBKX
         Djz1NRqPJrubSbwAvvb1PTMphZ1XJNzkg7kZRc8KkJetjUY9gtSKzrjrZvzDdcxSNuM9
         hZ9r9gl6ZEzBGzp+BIn0OzNLoi2B/BdqWo3NFoDXhXSEavftU5raIG3iyjgyI/Ffx1Mf
         EOww==
X-Gm-Message-State: AOAM53093QeaJyGzJXH0xsO+T7TRC+5kT67SXUejaVMToTuc6h3b8LB4
	mDEAE0t6C+4+9IIqmFYb1BE+zSjZnZ/4wU/zF6nUVWcGTdjGVX+7/EBJ1Z3446AA9M18WQkWsN2
	isMRabYmN5m1ti2AhFQ==
X-Received: by 2002:a05:6402:4310:b0:427:f6e9:76b3 with SMTP id m16-20020a056402431000b00427f6e976b3mr18716526edc.324.1652119922158;
        Mon, 09 May 2022 11:12:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzIhCnxEwAwh0UWoKYWIuKMyOPRZ6yYLPhg/iJNa7BitKx5xVaUTemiyrsOpCwXdv0OiUndPg==
X-Received: by 2002:a05:6402:4310:b0:427:f6e9:76b3 with SMTP id m16-20020a056402431000b00427f6e976b3mr18716516edc.324.1652119922018;
        Mon, 09 May 2022 11:12:02 -0700 (PDT)
Received: from ?IPV6:2001:1c00:c1e:bf00:d69d:5353:dba5:ee81? (2001-1c00-0c1e-bf00-d69d-5353-dba5-ee81.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:d69d:5353:dba5:ee81])
        by smtp.gmail.com with ESMTPSA id p26-20020a056402045a00b0042617ba6388sm6586819edw.18.2022.05.09.11.12.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 11:12:01 -0700 (PDT)
Message-ID: <e8cfdd18-6c18-16c8-c4cc-89d50ba3ac92@redhat.com>
Date: Mon, 9 May 2022 20:12:00 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH v5 00/10] Introduce In Field Scan driver
To: "Luck, Tony" <tony.luck@intel.com>, Borislav Petkov <bp@alien8.de>
Cc: "markgross@kernel.org" <markgross@kernel.org>,
 "tglx@linutronix.de" <tglx@linutronix.de>,
 "mingo@redhat.com" <mingo@redhat.com>,
 "dave.hansen@linux.intel.com" <dave.hansen@linux.intel.com>,
 "x86@kernel.org" <x86@kernel.org>, "hpa@zytor.com" <hpa@zytor.com>,
 "corbet@lwn.net" <corbet@lwn.net>,
 "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
 "andriy.shevchenko@linux.intel.com" <andriy.shevchenko@linux.intel.com>,
 "Joseph, Jithu" <jithu.joseph@intel.com>, "Raj, Ashok"
 <ashok.raj@intel.com>, "rostedt@goodmis.org" <rostedt@goodmis.org>,
 "Williams, Dan J" <dan.j.williams@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
 "platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
 "patches@lists.linux.dev" <patches@lists.linux.dev>,
 "Shankar, Ravi V" <ravi.v.shankar@intel.com>
References: <20220422200219.2843823-1-tony.luck@intel.com>
 <20220428153849.295779-1-tony.luck@intel.com>
 <13054c5c-ed48-b7a2-a800-25b9b1b1ab0d@redhat.com> <YnFK+gXFx0jQB1dz@zn.tnic>
 <b18234d7-a1f4-d5a4-e59b-f5439c38c2d0@redhat.com>
 <15cca88b82cd46a3a2a98b7cf336a6ed@intel.com>
 <4fda831b-c132-53cd-cd75-4f46b45219ac@redhat.com>
 <05b3c44c62a944f793b66b2e8e8c0cfe@intel.com>
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <05b3c44c62a944f793b66b2e8e8c0cfe@intel.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=hdegoede@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 5/9/22 19:05, Luck, Tony wrote:
>>> Do you still take patches after -rc6?
>>
>> If the patches are send soon (1-2 days) after rc6 I can still take them.
> 
> Hans,
> 
> V7 was posted Friday. It survived my weekend testing, and another round of tglx scrutiny (ending with
> his "Reviewed-by" on the latter parts of the series.
> 
> Let me know if there is anything else you need to get them applied.

From my side everything looks good. I plan to merge this
into my review-hans (*) branch coming Wednesday.

Regards,

Hans



*) And then from there move it to for-next once the build bots
have had a chance to play with it


