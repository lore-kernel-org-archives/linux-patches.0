Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA3E08476
	for <patches@lists.linux.dev>; Thu,  6 Apr 2023 15:02:08 +0000 (UTC)
Received: by mail-oo1-f46.google.com with SMTP id bp9-20020a056820198900b005414beaa075so1738199oob.8
        for <patches@lists.linux.dev>; Thu, 06 Apr 2023 08:02:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680793328;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NVc8/bAGJqj+ppUY3Ons5mpq5/CyGKqwzdFXHMLxuyo=;
        b=UAeShxkA6HXa8EAti/r7r/Jmhos5OlbWYUl8E40KtTllMCENoFR2axIEPQsUYqUKe/
         9zZy7+QWwArFxN8V8XU4DqT8PLojJc0JOyCtoinKS7pfK/odD3Gphw/X4wQZcrj/yZRF
         YJqsuPLpOf8y/geedEkTwJD4dLALkfFJeYytsvyu9Aqkk+k2w2FOui9PmpN7KlzHxLuc
         4/bF/64smPARzfLxyfPAP0MuvcHpMSY97m5i8b+ThKsjsTCnM2vc8SUmK9Wxq5k2KvBe
         GWJfToNd4eBHNO8R/rrDkrXT7BSEo0wkYgVnk9OhnH1KgOvyZ7lb7xbZggQZEOJ/6YVo
         e/rQ==
X-Gm-Message-State: AAQBX9ee5INyQRcjtIiHO9PqlM7hQTGVuVyd/9sHouiBZ8LujYXfWuZL
	LzR1yjUMl1jOjoTiOlQXTg==
X-Google-Smtp-Source: AKy350ZBMA2PTTWOcnXOd/S8JXrZnrxTW1zQsidLB6EMMvuKXbyfz4smDokkbjPwFshOcl4aAb2ILQ==
X-Received: by 2002:a4a:378d:0:b0:525:58f7:cbef with SMTP id r135-20020a4a378d000000b0052558f7cbefmr5175366oor.2.1680793327711;
        Thu, 06 Apr 2023 08:02:07 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id w127-20020a4a5d85000000b00525398a1144sm638742ooa.32.2023.04.06.08.02.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 08:02:05 -0700 (PDT)
Received: (nullmailer pid 3087657 invoked by uid 1000);
	Thu, 06 Apr 2023 15:02:04 -0000
Date: Thu, 6 Apr 2023 10:02:04 -0500
From: Rob Herring <robh@kernel.org>
To: Stephen Boyd <sboyd@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Brendan Higgins <brendan.higgins@linux.dev>, linux-clk@vger.kernel.org, kunit-dev@googlegroups.com, linux-kselftest@vger.kernel.org, Frank Rowand <frowand.list@gmail.com>, Christian Marangi <ansuelsmth@gmail.com>, Rob Herring <robh+dt@kernel.org>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, linux-kernel@vger.kernel.org, "Rafael J . Wysocki" <rafael@kernel.org>, Michael Turquette <mturquette@baylibre.com>, patches@lists.linux.dev, devicetree@vger.kernel.org, David Gow <davidgow@google.com>, Maxime Ripard <maxime@cerno.tech>
Subject: Re: [PATCH v3 03/11] dt-bindings: vendor-prefixes: Add "test" vendor
 for KUnit and friends
Message-ID: <168079332398.3087560.7781936436725334890.robh@kernel.org>
References: <20230327222159.3509818-1-sboyd@kernel.org>
 <20230327222159.3509818-4-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327222159.3509818-4-sboyd@kernel.org>


On Mon, 27 Mar 2023 15:21:51 -0700, Stephen Boyd wrote:
> Add the vendor prefix "test" to reserve a vendor prefix for bindings
> that are purely for testing device tree code. This allows test code to
> write bindings that can be checked by the schema validator.
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---
>  Documentation/devicetree/bindings/vendor-prefixes.yaml | 2 ++
>  1 file changed, 2 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>

