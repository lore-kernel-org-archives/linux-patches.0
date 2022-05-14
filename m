Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022B836D
	for <patches@lists.linux.dev>; Sat, 14 May 2022 02:21:58 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id c9so9590909plh.2
        for <patches@lists.linux.dev>; Fri, 13 May 2022 19:21:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BEK2GyJXSGgwCpo0TYeuD2ysTVshh6GGsRLe/H8ljtA=;
        b=mqvPCwxPwnQH8GgVmGCiu8KSHA7NcLRSwdsCY+9vHR6QRFcxj/dmZ19EEXt9pDKTIw
         YbAWj0mjZp08hD4pRb0LD+bqAJ/0EbuhXHGWfPaGqCfS3qTPtg1nLGDZNq5ww7cL/pTk
         u2yF2cx93XEFiWDGkRkhn6D19M8qtQPmvFqIdd40Za11lMcphSJWi5FGpppSrBAp9o1m
         AH1rhU+louytWBtR1OVEfO3BmpIIsQfNZPOJ+8Rh0ZPE/Nl+zf82Co5pGeSiCkg5IyBI
         FZh8sIIynSjgGPq4pCvSimYMemLrHF3DfJKNrvFXV2OVcEUHhFmKuJZwmopMtk0RrAgI
         ejTA==
X-Gm-Message-State: AOAM532UZmwAb1B2Rz30Pg/QTlq/45J/YB3zbrVp25GRdFV1RovNrTVP
	bUq4TbveGYeY6er7e/sD5Ts=
X-Google-Smtp-Source: ABdhPJwwOBsV80Nno76sWLJXXmOyKh2EJn9Vf+gCeWirOJtkWJSzfSrpXv1oWOHm8YCxqtIavTNbsw==
X-Received: by 2002:a17:90b:1b47:b0:1dc:3c0a:dde3 with SMTP id nv7-20020a17090b1b4700b001dc3c0adde3mr7787881pjb.52.1652494918259;
        Fri, 13 May 2022 19:21:58 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id u12-20020a62d44c000000b0050dc7628159sm2399176pfl.51.2022.05.13.19.21.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 May 2022 19:21:57 -0700 (PDT)
Message-ID: <88a9baff-5654-b5ce-f7ca-a74a832e359a@acm.org>
Date: Fri, 13 May 2022 19:21:56 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH 1/4] workflows/Kconfig: be consistent when enabling
 fstests or blktests
Content-Language: en-US
To: Luis Chamberlain <mcgrof@kernel.org>, linux-fsdevel@vger.kernel.org,
 linux-block@vger.kernel.org
Cc: patches@lists.linux.dev, amir73il@gmail.com, pankydev8@gmail.com,
 tytso@mit.edu, josef@toxicpanda.com, jmeneghi@redhat.com, jake@lwn.net
References: <20220513193831.4136212-1-mcgrof@kernel.org>
 <20220513193831.4136212-2-mcgrof@kernel.org>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220513193831.4136212-2-mcgrof@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/13/22 12:38, Luis Chamberlain wrote:
> We have two kconfig variables which we use to be able to express
> when we are going to enable fstests or blktests, either as a dedicated
> set of tests or when we want to enable testing both fstests and blktests
> in one system. But right now we only select this kconfig variable when
> we are using a dedicated system. This is not an issue as the kconfig
> is a kconfig symbols are bools which are set default to y if either
> the test is dedicated or not.
> 
> But to be pedantic, and clear, let's make sure the tests select the
> respective kconfig for each case as we'd expect to see it. Otherwise
> this can confuse folks reading this.

Is this patch perhaps intended for the kdevops project? If so, please 
add a prefix to make this clear (git format-patch --subject-prefix) when 
sending kdevops patches to Linux kernel mailing lists.

Thanks,

Bart.
