Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07D1566C5
	for <patches@lists.linux.dev>; Wed, 23 Mar 2022 18:48:11 +0000 (UTC)
Received: by mail-oi1-f176.google.com with SMTP id s207so2545655oie.11
        for <patches@lists.linux.dev>; Wed, 23 Mar 2022 11:48:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=56J3GohQxdWaUNz7jQ2eEsIABoOTuL958gy1PE8F0ck=;
        b=JPpnD0+GSUqv1uvUM423ilev+C9zte4JcJLAAYTlSqb0iyZ6p4PNRdmEYO1hG2p7R/
         LPlHh3mpPwIfEgvmM18epX544N+6j8MVgwyuZ38BoZ7dNmxSoNoZQU7Ymy+y3BKBhyjg
         SaXMJDer/RAYgl1nOCf/2RyVotzuDRP1+XbW/HT0e891gntXs9Fd2ny2AqmxTm31fIfP
         naBLKiBS1Yni5V/0vY+erMis25qLHqR5wUcFl8jlfcbumyivOylfeNmRAGdUMVxVo9DT
         3CWEJRREA49N02QAhGRB6+9cu+JLFM9MYSY81zYu37PMUxJFOTEVcx/ncpK//KhRxEgx
         13eg==
X-Gm-Message-State: AOAM530NgiR+l6gz5yv3X8CHnlhNRlxRVa4O6IxKKvSFSyRY41YtFoat
	mlSPBJ9af+S5wCbftbbYCyVo8R6u9g==
X-Google-Smtp-Source: ABdhPJyFLHubkitJIKDgjYHSdLjgwJ/cuVQanHqprHw4EB6GVqxlaV8Sxw0nJfSrmHho34tIgDeGWw==
X-Received: by 2002:aca:ebd1:0:b0:2ec:91e4:f423 with SMTP id j200-20020acaebd1000000b002ec91e4f423mr804158oih.1.1648061291132;
        Wed, 23 Mar 2022 11:48:11 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id q9-20020a4ae649000000b00320d35fc91dsm348675oot.24.2022.03.23.11.48.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 11:48:10 -0700 (PDT)
Received: (nullmailer pid 242466 invoked by uid 1000);
	Wed, 23 Mar 2022 18:48:09 -0000
Date: Wed, 23 Mar 2022 13:48:09 -0500
From: Rob Herring <robh@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: patches@lists.linux.dev, Krzysztof Kozlowski <krzk+dt@kernel.org>, Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] dt-bindings:i kbuild: Make DT_SCHEMA_LINT a
 recursive variable
Message-ID: <YjtraaYJFuNG30xW@robh.at.kernel.org>
References: <20220315202032.538911-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315202032.538911-1-nathan@kernel.org>

On Tue, 15 Mar 2022 13:20:32 -0700, Nathan Chancellor wrote:
> A recent change added a warning when yamllint is not installed, as it is
> needed for 'make dt_binding_check'. However, it also changed
> DT_SCHEMA_LINT to be a simple make variable, which is evaluated when a
> Makefile is evaluated. This causes a warning when running 'make clean',
> as Documentation/devicetree/bindings/Makefile has a "clean-files"
> variable:
> 
>   $ make -s clean
>   which: no yamllint in (...)
>   warning: python package 'yamllint' not installed, skipping
> 
> Make DT_SCHEMA_LINT a recursive variable so it is evaluated only when it
> is used. The warning still triggers when 'make dt_binding_check' is run.
> 
> Fixes: b3e664a7f449 ("dt-bindings: kbuild: Print a warning if yamllint is not found")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  Documentation/devicetree/bindings/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Applied, thanks!
