Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C29CC8801
	for <patches@lists.linux.dev>; Thu,  6 Apr 2023 15:03:11 +0000 (UTC)
Received: by mail-ot1-f49.google.com with SMTP id 6-20020a9d0106000000b006a177038dfeso11672791otu.7
        for <patches@lists.linux.dev>; Thu, 06 Apr 2023 08:03:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680793391;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wYgmHMtE4Z7gXY8fARqNrSklFArQd85DUjhl84S7U8k=;
        b=mxEx0LJgRDnJ7JAB3rGvTjdcw3dlRfTUSIvQXsyZ4ySjLsCcp02/YCdT+IWhnpV7+O
         JseWnRUo1iC8ZlXAo+rulxZkxmBXijAYuaRDBIsktem5cGvl9WINysp6DqmTC1pJSHEN
         Vi0gU/YPVNjQLDl/bdpHdabD8zW8mg3dpaHDtabN7YgwW8O1e5tAaqgsaNCegH4869CY
         zQbDdFCyfENxechcNUsFrTu7x9Q/5FedXhKES+F000dokibjmLq6OEXpQ0qGGflFbUBi
         z+nZTYJeIYkMnrWnNc5Ldy2PzaEzhX0VnanE/qp8kNE8hZM8PnPByDTs38FDWaWPqZPf
         duzw==
X-Gm-Message-State: AAQBX9f1yYk/yMHX25WnIPbPmJbAytbPdcAG6bghcI6Z/BqioabmjlfI
	Aho7wnIkA9w89Pe4PWepQA==
X-Google-Smtp-Source: AKy350bZD4DjQUO7AVGHEVenQnfIMLuXNlrLc4gknaEfA4cOh4RhwrUIHpdfd4pE2Dh1CZs3PVEqRQ==
X-Received: by 2002:a05:6830:1390:b0:697:bfe5:93a0 with SMTP id d16-20020a056830139000b00697bfe593a0mr3732206otq.10.1680793390855;
        Thu, 06 Apr 2023 08:03:10 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id c2-20020a9d75c2000000b006a154373578sm765278otl.39.2023.04.06.08.03.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Apr 2023 08:03:10 -0700 (PDT)
Received: (nullmailer pid 3093825 invoked by uid 1000);
	Thu, 06 Apr 2023 15:03:09 -0000
Date: Thu, 6 Apr 2023 10:03:09 -0500
From: Rob Herring <robh@kernel.org>
To: Stephen Boyd <sboyd@kernel.org>
Cc: Brendan Higgins <brendan.higgins@linux.dev>, devicetree@vger.kernel.org, Frank Rowand <frowand.list@gmail.com>, Christian Marangi <ansuelsmth@gmail.com>, Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>, kunit-dev@googlegroups.com, Maxime Ripard <maxime@cerno.tech>, "Rafael J . Wysocki" <rafael@kernel.org>, David Gow <davidgow@google.com>, Michael Turquette <mturquette@baylibre.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org, patches@lists.linux.dev, Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH v3 10/11] dt-bindings: clk: Add KUnit clk_parent_data test
Message-ID: <168079338907.3093774.3664348677242434161.robh@kernel.org>
References: <20230327222159.3509818-1-sboyd@kernel.org>
 <20230327222159.3509818-11-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327222159.3509818-11-sboyd@kernel.org>


On Mon, 27 Mar 2023 15:21:58 -0700, Stephen Boyd wrote:
> Describe a binding for a device that provides and consumes clks in DT so
> that a KUnit test can register clks based on the device node and test
> clk_hw_register() with clk_parent_data.
> 
> Cc: Rob Herring <robh+dt@kernel.org>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> Cc: Brendan Higgins <brendan.higgins@linux.dev>
> Cc: David Gow <davidgow@google.com>
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>
> ---
>  .../bindings/clock/test,clk-parent-data.yaml  | 47 +++++++++++++++++++
>  1 file changed, 47 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/clock/test,clk-parent-data.yaml
> 

Reviewed-by: Rob Herring <robh@kernel.org>

