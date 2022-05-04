Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2499D2583
	for <patches@lists.linux.dev>; Wed,  4 May 2022 15:04:01 +0000 (UTC)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-e93bbb54f9so1420898fac.12
        for <patches@lists.linux.dev>; Wed, 04 May 2022 08:04:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sn1FprFMfZ401oZdnKMfgZTW8Bn5vjqnty4V/SEXSyw=;
        b=UlhezH+ZtXpm+y6nJMbRjWz7zHUMJoLzYr1cnRsue9l2Gb+mv9rEDjaZeXgEq8OZph
         XSdNoJ3HDHzBgTVMTnnJcqfXG+Vp3zpzlOT7b2VfTXDePCUddC0jxthVH6rZJla7WZs0
         tNHEhsaj/muANuoLj51lq1ykh3cTMSdB98vT4CR1IvvB0UikBrz1Ketv73XuiSvMfiwT
         ie5EJytihJJAlCc8qNYQWznmp1DgdZ68xiTJNJdiWi5s3d2Cpp+Sta53In02csLAtoPX
         TJChgTE2ncjGTHOPE+rlW4NBQGzb9bQxInd6digV7KHFQTp3KywBxxitBGh+cyY3Ps4r
         YBCA==
X-Gm-Message-State: AOAM530VQ8iu/3IwXjj93UOZfpPDZ+pkk0+v2phTe84N1YFmeS6y7ITb
	k4d1apbRoaT55ccDVpgz+Q==
X-Google-Smtp-Source: ABdhPJyeqN7a3WcUXtGg2ql4GhTZFEERXuwzOgpadB9FFz4RoHjJ2DvW2NTpiEz1s2KkYbL9qDwYhA==
X-Received: by 2002:a05:6870:6324:b0:e9:16de:4053 with SMTP id s36-20020a056870632400b000e916de4053mr4070223oao.164.1651676640211;
        Wed, 04 May 2022 08:04:00 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id a15-20020a056808128f00b003264a325ecdsm897053oiw.5.2022.05.04.08.03.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 May 2022 08:03:59 -0700 (PDT)
Received: (nullmailer pid 1708315 invoked by uid 1000);
	Wed, 04 May 2022 15:03:59 -0000
Date: Wed, 4 May 2022 10:03:59 -0500
From: Rob Herring <robh@kernel.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: linux-iio@vger.kernel.org, Krzysztof Kozlowski <krzk+dt@kernel.org>, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, Gwendal Grignou <gwendal@chromium.org>, Jonathan Cameron <jic23@kernel.org>, Rob Herring <robh+dt@kernel.org>, patches@lists.linux.dev
Subject: Re: [PATCH v2 1/2] dt-bindings: iio: sx9324: Add CS idle/sleep mode
Message-ID: <YnKV32XmMLW6bJAT@robh.at.kernel.org>
References: <20220503193937.3794477-1-swboyd@chromium.org>
 <20220503193937.3794477-2-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220503193937.3794477-2-swboyd@chromium.org>

On Tue, 03 May 2022 12:39:36 -0700, Stephen Boyd wrote:
> We need to configure the sleep and idle mode of the CS pins for this
> device. Add a DT property to do this so pins are in a proper state
> during sleep (either hi-z, grounded, or pulled up to vdd).
> 
> Reviewed-by: Gwendal Grignou <gwendal@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  .../bindings/iio/proximity/semtech,sx9324.yaml           | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
