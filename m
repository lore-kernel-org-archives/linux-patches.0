Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB6D134CF
	for <patches@lists.linux.dev>; Tue, 22 Aug 2023 11:00:10 +0000 (UTC)
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-3fee600dce6so27804385e9.1
        for <patches@lists.linux.dev>; Tue, 22 Aug 2023 04:00:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692702008; x=1693306808;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IoWFVqMsL83JIn/vxFgprKnAuUfFVup8ln942QNlmLA=;
        b=Z8UV6iW1itfzHm8+/As9TAjIYBcIWN2z0QLgAmaJ/2mblgU1+o+H6n1gqtruyT30xg
         GcPIjwJg72BACxxjpHRePL/hKl41unY26KQfzPIa6pull1358sSYvAh21o/MURQQsN6y
         DfgOWPluEM/MqPlhQuJ3T9s0c+XpT/UhO5uNnzRGuxX4uiS6AVK4O3WRtPCHgmXV+Lki
         ojWJJZftutfK9Km6HzytEuVGs8qn/cBZ+0UVxGIBXmN4gTM+DzsNMbpXC37tNWCah/Ux
         hUjnfRXs//2HmE+XKqlSzmA8h4ir9qMEUjDIvT03+l/5ZQPEWKoOpQ1kulZ84QsucFgm
         ON3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692702008; x=1693306808;
        h=content-transfer-encoding:content-language:in-reply-to:mime-version
         :user-agent:date:message-id:from:references:cc:to:subject
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IoWFVqMsL83JIn/vxFgprKnAuUfFVup8ln942QNlmLA=;
        b=diGa9QEUqR538ZW3ThgQ5hSARJHVeP98+h8K4wGSnzCxKL1sZqBckthRvtkLNN/qsV
         fp2ah28+F4bNJt9NG0WHYB5znWQegpkV4oKzkIeB5GLVPQzvpV732tnGlT8S9JFh3T26
         hnKoR0W9ETnylYTAK5PaTeAL/1cOPg+Tc3r0E6NcKKnhFdUJCkCB091VKBuuvUoBw6Wl
         UQPgKqIpNpYEQLi+GRugw72YiraHM+mVbhWu2IpyW5nR/twito/ijR1xkyLeJfZFRtOY
         wO2KQ0YC/7tAtZ/QoVz89sp+cCdVvzjjJzk1RsRa6oyjD3JFPC01rcWJtcssWn4bgC/Y
         5YXg==
X-Gm-Message-State: AOJu0Yz1s9Ut/KZuFfeyaipF16WbxHZHYk6ThP3Boqf5BTszd31m9fm9
	7ksAF2+S+PzeIRnhUDITz44=
X-Google-Smtp-Source: AGHT+IFKdURGW7iWzIEDzfIwQ7oabQT/1r1bpkExBM3su0btaR+BUUsSjhTaK472wB9hVlcXk7mbow==
X-Received: by 2002:a5d:6308:0:b0:313:e953:65d0 with SMTP id i8-20020a5d6308000000b00313e95365d0mr7168497wru.28.1692702008305;
        Tue, 22 Aug 2023 04:00:08 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id n16-20020adfe790000000b003188358e08esm15432136wrm.42.2023.08.22.04.00.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Aug 2023 04:00:07 -0700 (PDT)
Subject: Re: [PATCH 6.4 173/234] sfc: add fallback action-set-lists for TC
 offload
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
 Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>,
 Simon Horman <simon.horman@corigine.com>, Jakub Kicinski <kuba@kernel.org>,
 Sasha Levin <sashal@kernel.org>
References: <20230821194128.754601642@linuxfoundation.org>
 <20230821194136.483562509@linuxfoundation.org>
From: Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <18ed9173-46f3-b1c5-1a35-fe6aa1da5407@gmail.com>
Date: Tue, 22 Aug 2023 12:00:06 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20230821194136.483562509@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit

On 21/08/2023 20:42, Greg Kroah-Hartman wrote:
> From: Edward Cree <ecree.xilinx@gmail.com>
> 
> [ Upstream commit e16ca7fb9ffb0d51ddf01e450a1043ea65b5be3f ]
> 
> When offloading a TC encap action, the action information for the
>  hardware might not be "ready": if there's currently no neighbour entry
>  available for the destination address, we can't construct the Ethernet
>  header to prepend to the packet.  In this case, we still offload the
>  flow rule, but with its action-set-list ID pointing at a "fallback"
>  action which simply delivers the packet to its default destination (as
>  though no flow rule had matched), thus allowing software TC to handle
>  it.  Later, when we receive a neighbouring update that allows us to
>  construct the encap header, the rule will become "ready" and we will
>  update its action-set-list ID in hardware to point at the actual
>  offloaded actions.
> This patch sets up these fallback ASLs, but does not yet use them.
> 
> Reviewed-by: Pieter Jansen van Vuuren <pieter.jansen-van-vuuren@amd.com>
> Signed-off-by: Edward Cree <ecree.xilinx@gmail.com>
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Stable-dep-of: fa165e194997 ("sfc: don't unregister flow_indr if it was never registered")

I don't think this is actually needed by that commit; it's textually
 part of the context but not semantically important to it.
Why can't you do the same thing you did for 6.1?
-ed

> Signed-off-by: Sasha Levin <sashal@kernel.org>
