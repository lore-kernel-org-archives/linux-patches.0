Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A3638801
	for <patches@lists.linux.dev>; Thu,  6 Apr 2023 15:02:53 +0000 (UTC)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-17ac5ee3f9cso42600774fac.12
        for <patches@lists.linux.dev>; Thu, 06 Apr 2023 08:02:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680793372;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Vp1soVVgJyw7DnWbzvcH5jF90UmIZzV8nwXox1Hq290=;
        b=jd6ClrIKl/CvMdL3Z/5b5Faj8Znsvud3wwh8QoGjAwzlhE5KVGlmAFeplDX3jFiG9U
         MMdvGngs9Go/LwBeOkWLE7IT9lq0OcYEqU+n9sJgTe26YT4mq1DHz/jaZW70yPGZwCFb
         dio8vPjxKlNrndpQ7V2bZHGvnWzJgbSNXMUfPnDw0+UNhL/sApjPKr4qA/MeOnWs/TsB
         VF//X9boR7mHtp3p5LOM4HsyeJ5Lu4kxmScE49QedRchPziQQ7hHiEoiewX5vJ2Ndfwv
         1GAreUUOR231tOiQGaUS0fsHTLOtzKDEnVNavdvZaSIIJfFq7BfCoWT6fKEMvN2eZNW9
         CNaw==
X-Gm-Message-State: AAQBX9cd8Iiudh6NyglEMkNekU7oPxEMWvIG7EfCegLjdF4DJpMCeCnt
	oPAEbh9952Ajk6Eb/PHggQ==
X-Google-Smtp-Source: AKy350bG6JhGJke1pSMmP0FQ4u2Wm3qy4H0yHiRyJP2owCnbwM5OJZWiY+LLo5dEFcfAHuQILcINEg==
X-Received: by 2002:a05:6870:9622:b0:177:9b62:6b87 with SMTP id d34-20020a056870962200b001779b626b87mr5747647oaq.20.1680793372513;
        Thu, 06 Apr 2023 08:02:52 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id e24-20020a05683013d800b006a3842a32b6sm785254otq.42.2023.04.06.08.02.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 08:02:51 -0700 (PDT)
Received: (nullmailer pid 3092563 invoked by uid 1000);
	Thu, 06 Apr 2023 15:02:50 -0000
Date: Thu, 6 Apr 2023 10:02:50 -0500
From: Rob Herring <robh@kernel.org>
To: Stephen Boyd <sboyd@kernel.org>
Cc: kunit-dev@googlegroups.com, Michael Turquette <mturquette@baylibre.com>, linux-kselftest@vger.kernel.org, "Rafael J . Wysocki" <rafael@kernel.org>, Brendan Higgins <brendan.higgins@linux.dev>, linux-kernel@vger.kernel.org, David Gow <davidgow@google.com>, Rob Herring <robh+dt@kernel.org>, Frank Rowand <frowand.list@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-clk@vger.kernel.org, Christian Marangi <ansuelsmth@gmail.com>, patches@lists.linux.dev, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, devicetree@vger.kernel.org, Maxime Ripard <maxime@cerno.tech>
Subject: Re: [PATCH v3 07/11] dt-bindings: kunit: Add fixed rate clk consumer
 test
Message-ID: <168079336912.3092485.14820569065582293049.robh@kernel.org>
References: <20230327222159.3509818-1-sboyd@kernel.org>
 <20230327222159.3509818-8-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327222159.3509818-8-sboyd@kernel.org>


On Mon, 27 Mar 2023 15:21:55 -0700, Stephen Boyd wrote:
> Describe a binding for a device that consumes a fixed rate clk in DT so
> that a KUnit test can get the clk registered by of_fixed_clk_setup() and
> test that it is setup properly.
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> Cc: Brendan Higgins <brendan.higgins@linux.dev>
> Cc: David Gow <davidgow@google.com>
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---
>  .../bindings/test/test,clk-fixed-rate.yaml    | 35 +++++++++++++++++++
>  1 file changed, 35 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/test/test,clk-fixed-rate.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>

