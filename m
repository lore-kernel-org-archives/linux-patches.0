Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72077A59
	for <patches@lists.linux.dev>; Fri,  6 May 2022 18:42:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1651862525;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IutWs/AAIWN2kdaL06tOXzC11yEkd5/tsS3ZCS9FxNc=;
	b=NC1etv7nkQe5I8JopzI1dHp99lG8XQWc8YtxFqkHJPMFBPHLnkLN/+dgu1CYH72V7pFWTc
	ylEvcdXMJrMMw/uXC1ILC+Zk9i1ENZS356Z1tuBhEOWmMk3Glg2pS5MBi1KObibuKxBOOf
	8b8F9HYlKBq7H2SXQMDGLP9KrFKy8VM=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-269-gJpHY1XqOIGxFUU2eeXaXw-1; Fri, 06 May 2022 14:42:04 -0400
X-MC-Unique: gJpHY1XqOIGxFUU2eeXaXw-1
Received: by mail-ej1-f69.google.com with SMTP id x2-20020a1709065ac200b006d9b316257fso4808251ejs.12
        for <patches@lists.linux.dev>; Fri, 06 May 2022 11:42:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=IutWs/AAIWN2kdaL06tOXzC11yEkd5/tsS3ZCS9FxNc=;
        b=emRlv0SDFofnC4JWtwgVAdjr+aQcTqMtIwZ77BV0bINYwsAqZgmDYYRS79SCWitqfh
         18WbRNs/4UxJwaT5wtf0ToyqiAq/R+cs4O9LosFg8o4dmxvEmQEFx5JqRXNfX5KvBjGM
         LYxRzolE1ioKXog6kTmDdCGWx8hxRUC33kkKSs8MAvoylqrEl1hGrF5dNQUqRKwRu2od
         CwEgkJGwZ/m9SR2jV68cxo8Y/neycSvTVcjGvDKlUbxgz8lQhVUMTqH5wXb2yQNPOu37
         2zPzZEB2CvUaAQAU3EQdfwhq18eoCCH98JTXkpaic66l+/04/Ecp5eh/hnRuGiXeBy4u
         YIYw==
X-Gm-Message-State: AOAM530hMAf2LAuwFpT5jI1YR5mJO70VPON5+f1gylMjHmnmj5B3Z42t
	4udgFlEVhJE/KwBABSWTI6Xk307epjCGrQB2s1WICRfO/BqtplDThHNWWHtgjlsrbxEOAA6DOzS
	VDH7MD1RNw3PX4m3zjA==
X-Received: by 2002:a17:907:9605:b0:6f5:c66:7c13 with SMTP id gb5-20020a170907960500b006f50c667c13mr4098133ejc.66.1651862522983;
        Fri, 06 May 2022 11:42:02 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw++pW+zoYzTYOHGCeDdAFw8juVOYeKHg0KEBZ0ZNL6LniqL5SEZeYX9EZMh6IEZI9oT6xsJg==
X-Received: by 2002:a17:907:9605:b0:6f5:c66:7c13 with SMTP id gb5-20020a170907960500b006f50c667c13mr4098108ejc.66.1651862522821;
        Fri, 06 May 2022 11:42:02 -0700 (PDT)
Received: from [192.168.43.126] ([109.38.131.108])
        by smtp.gmail.com with ESMTPSA id ra48-20020a17090769b000b006f3ef214da0sm2227765ejc.6.2022.05.06.11.42.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 May 2022 11:42:02 -0700 (PDT)
Message-ID: <4fda831b-c132-53cd-cd75-4f46b45219ac@redhat.com>
Date: Fri, 6 May 2022 20:41:59 +0200
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
From: Hans de Goede <hdegoede@redhat.com>
In-Reply-To: <15cca88b82cd46a3a2a98b7cf336a6ed@intel.com>
Authentication-Results: relay.mimecast.com;
	auth=pass smtp.auth=CUSA124A263 smtp.mailfrom=hdegoede@redhat.com
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

On 5/6/22 17:53, Luck, Tony wrote:
>> I'll give it some more time for review for v6 and then pick up v6
>> (or v7 if review leads to more changes).
> 
> Hans,
> 
> Thomas has found one substantive problem, and a few minor things (so far ... he
> still seems to be working through v6). 

Ok.

> So there will be a v7. Likely early next week. Is that OK?

That is fine.

> Do you still take patches after -rc6?

If the patches are send soon (1-2 days) after rc6 I can still take them.

Regards,

Hans

