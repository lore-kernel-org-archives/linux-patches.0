Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD28C66C5
	for <patches@lists.linux.dev>; Wed, 23 Mar 2022 18:49:51 +0000 (UTC)
Received: by mail-ot1-f46.google.com with SMTP id a7-20020a9d5c87000000b005ad1467cb59so1697243oti.5
        for <patches@lists.linux.dev>; Wed, 23 Mar 2022 11:49:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I1jRfgCA6HYKNBHH0oOGdmPolkRMIm0BBTXMi4QIsc4=;
        b=ttZiAbKWw89L395ONIWfKHeW+7vxZqP9CEYreaWvyifTgva4FFhM80v3fDyIUWJG2D
         s6McT83SIIsMdSc6uS3XYUCC7uDcIg8Sc7rVixWJVe0EDkv+M1Kly7xncvUpcJTAz/Wy
         Jt9/xjiVXN4eo4MJ7uL9ED6Gxj8/wEtOViJBmD4+9ZAr1tce8u+Ug8gFoqwZhgknjnGu
         pEE1cReoL8jZ36Xqrk3h8j8/z1bFSLJE91ghkebsYBWhGzwTXvT1Rt97qWcXThND8SBG
         /YX43kRzwv0RrzHzpeM5JmKcU2ch2W7fPiwJ6DME/dhf4bBMNxb5OF+p+D8wrkOy7tcX
         EPEg==
X-Gm-Message-State: AOAM532fTdPACZLBXi2CYaxDOmRAyDDM38YZqTF1kptx+MaK0weoLnsF
	LLiel516podHbVF5UzqcgA==
X-Google-Smtp-Source: ABdhPJxp8gog6x73KsM+b7yt7SY+QyD+8XRmcuCcMS1qTfi2jOJ5tYrIKCRupqLiV8jN4uGY1z3FHA==
X-Received: by 2002:a9d:2051:0:b0:5b2:20d1:b38c with SMTP id n75-20020a9d2051000000b005b220d1b38cmr630472ota.167.1648061390928;
        Wed, 23 Mar 2022 11:49:50 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id gk6-20020a0568703c0600b000de4880b357sm293918oab.50.2022.03.23.11.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 11:49:50 -0700 (PDT)
Received: (nullmailer pid 245037 invoked by uid 1000);
	Wed, 23 Mar 2022 18:49:49 -0000
Date: Wed, 23 Mar 2022 13:49:49 -0500
From: Rob Herring <robh@kernel.org>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Rob Herring <robh+dt@kernel.org>, patches@lists.linux.dev, linux-kernel@vger.kernel.org, Krzysztof Kozlowski <krzk+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH -next v2] dt-bindings: kbuild: Make DT_SCHEMA_LINT a
 recursive variable
Message-ID: <YjtrzaOLaA8dJbak@robh.at.kernel.org>
References: <20220315202542.2071351-1-nathan@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220315202542.2071351-1-nathan@kernel.org>

On Tue, 15 Mar 2022 13:25:43 -0700, Nathan Chancellor wrote:
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
> 
> v1 -> v2: https://lore.kernel.org/r/20220315202032.538911-1-nathan@kernel.org/
> 
> * Fix stray "i" in commit title (I promise I know how to use vim...),
>   sorry for the mistake and extra patch.
> 
>  Documentation/devicetree/bindings/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Dropped v1 and applied this one, thanks!
