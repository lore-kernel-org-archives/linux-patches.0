Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 471F88476
	for <patches@lists.linux.dev>; Thu,  6 Apr 2023 15:02:29 +0000 (UTC)
Received: by mail-ot1-f41.google.com with SMTP id w15-20020a056830410f00b006a386a0568dso5557902ott.4
        for <patches@lists.linux.dev>; Thu, 06 Apr 2023 08:02:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680793348; x=1683385348;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nXauuPv7V6nw+K9y9u87hFBrUqj41ptimlsFpxUoa10=;
        b=B3Es8DZgjEwYKF8VMyJP6IoGiva1iJQFEOZOKAYMJsmxSMnhRuwh535oYj7b9UBdaf
         IxlgAB12U0w4D62swmTSuMn1aZF+zzZdEvwO89kAzKnuB0XRr67ihXci/BRH+esPnZDw
         yeXrfB+81nZTF3hjroLrhKx8pO/1sO1hvMJAUq9kh47CGrQtWyCqe/i3ifMTx4N1KTxe
         Upc5W+kBn2Eni/g4kQboOi7yHHjThrRgPRSc9vFTKdXCdhVgulw6Uxze481HJfGemRFW
         2OUhqsB+CtsV/XOJ3xltFltmO2wtT7Zl4huUnvpMTYfQroi2jfzmHuM6WYePuKMWz7Vt
         IbAQ==
X-Gm-Message-State: AAQBX9fyYXhhxgNEp0s0SZZsF2c9Ipzj8oSXf42fWzbTqSpHoIq06Cdz
	gpW2W7uJsIT09Rru6khDMdZsrioHzg==
X-Google-Smtp-Source: AKy350aqLbkPGLuk0tZbMl6/7gxaMb4Wnliyi44lmNq2flfn3WT1JRPb2J8aVsK5oJaoCreTyhBzjQ==
X-Received: by 2002:a9d:6d08:0:b0:69b:c852:4ab8 with SMTP id o8-20020a9d6d08000000b0069bc8524ab8mr3229642otp.7.1680793348236;
        Thu, 06 Apr 2023 08:02:28 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id j16-20020a9d7690000000b006a2ce5f3641sm782361otl.8.2023.04.06.08.02.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 08:02:27 -0700 (PDT)
Received: (nullmailer pid 3090444 invoked by uid 1000);
	Thu, 06 Apr 2023 15:02:26 -0000
Date: Thu, 6 Apr 2023 10:02:26 -0500
From: Rob Herring <robh@kernel.org>
To: Stephen Boyd <sboyd@kernel.org>
Cc: Christian Marangi <ansuelsmth@gmail.com>, devicetree@vger.kernel.org, linux-kselftest@vger.kernel.org, Frank Rowand <frowand.list@gmail.com>, Maxime Ripard <maxime@cerno.tech>, David Gow <davidgow@google.com>, linux-kernel@vger.kernel.org, "Rafael J . Wysocki" <rafael@kernel.org>, kunit-dev@googlegroups.com, patches@lists.linux.dev, Michael Turquette <mturquette@baylibre.com>, Rob Herring <robh+dt@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Brendan Higgins <brendan.higgins@linux.dev>, linux-clk@vger.kernel.org, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Subject: Re: [PATCH v3 04/11] dt-bindings: test: Add KUnit empty node binding
Message-ID: <168079334653.3090275.1222113248015102076.robh@kernel.org>
References: <20230327222159.3509818-1-sboyd@kernel.org>
 <20230327222159.3509818-5-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327222159.3509818-5-sboyd@kernel.org>


On Mon, 27 Mar 2023 15:21:52 -0700, Stephen Boyd wrote:
> Describe a binding for an empty device node used by KUnit tests to
> confirm overlays load properly.
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> Cc: Brendan Higgins <brendan.higgins@linux.dev>
> Cc: David Gow <davidgow@google.com>
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---
>  .../devicetree/bindings/test/test,empty.yaml  | 30 +++++++++++++++++++
>  1 file changed, 30 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/test/test,empty.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>

