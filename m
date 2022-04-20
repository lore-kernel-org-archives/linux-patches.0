Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731FD10ED
	for <patches@lists.linux.dev>; Wed, 20 Apr 2022 02:54:14 +0000 (UTC)
Received: by mail-ot1-f47.google.com with SMTP id r14-20020a9d750e000000b00605446d683eso252391otk.10
        for <patches@lists.linux.dev>; Tue, 19 Apr 2022 19:54:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IHAzVnuzxuYJX7ZkepRm9BZc+S59p4HkHNttGn59HI4=;
        b=TTpsWITDGO8DJDNJxeNi3uPnZIZsEi7KOyE47yCr6VLUa14Zr/w+V1mBYLvdY7qH2G
         snjCUL9iNcZQE2b/3/u+ez02PRD4EPz54kz1VGYjVwhnOBkFsBF/zkpZxbHLtbEbwZwM
         P3ZbdGOCZdxxj4o9tNatcIwoGBJU39aVkflY+EzWxaKJsdGMd9zz7tZ6bvsNpKqThITd
         k/BBZFlV4cxJpwSIPse0WC2acMv1kXV3kTvj4nSdO89cka6ntSWfVksv1icoDBpY1XYX
         UsILoa0eFvZwKrf6pD4JNoqapYvQ5VHuJRVivcYiBuPRBrukVFLSV6UEt+EB/2vVUkp3
         Tx6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IHAzVnuzxuYJX7ZkepRm9BZc+S59p4HkHNttGn59HI4=;
        b=X1XcSDPzqgSSALlX/zCIk0nPPGa627H61FAuGiB6xM82LWQtwGKl4shWHIo1Wnxurt
         K+V+z6kausfz9nJviwLrgNqm5izETnevFeqZ8BcaJ6qnKZykPRpQTnBGY2deC2CVTkv/
         SeofmLkSpAGDrQxl/M4Ix3Rzr/3CzqBVyMmXwslhOSX+OOwTA84lxBd6Ze+Bqe77au42
         5d0m4p7ZLlliany5ByZ3ouTEj9Gx1X+18FyBeUaXLviicg+9zM3KOY8KmmZOlD90L/TB
         8NPxspunHCvJeCblpXrYwH5qv4U1N44pU3t1WiP5aE5PrANk0RqE8To5IYSsHBzkqX89
         XEbg==
X-Gm-Message-State: AOAM531Qcth591j+UlS0/weUVAZmTF8r+Il/L65yglxx4qfv4dTHiMLT
	H5H70k8cz7lbsexmd/6gdMtLZg==
X-Google-Smtp-Source: ABdhPJwLIrIaD2Ik9Pers9+71R5BMbjnqv2e7ktsi8J2VHGUQ2C8DVItqcC/6zEs/lSLqwJxF7ub1g==
X-Received: by 2002:a9d:3624:0:b0:5e9:5778:d0c6 with SMTP id w33-20020a9d3624000000b005e95778d0c6mr7017809otb.367.1650423253580;
        Tue, 19 Apr 2022 19:54:13 -0700 (PDT)
Received: from ripper ([2600:1700:a0:3dc8:205:1bff:fec0:b9b3])
        by smtp.gmail.com with ESMTPSA id c9-20020a4a8ec9000000b0032438ba79b0sm6140956ool.0.2022.04.19.19.54.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Apr 2022 19:54:13 -0700 (PDT)
Date: Tue, 19 Apr 2022 19:56:18 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org, linux-pm@vger.kernel.org,
	Doug Anderson <dianders@chromium.org>,
	Alex Elder <elder@linaro.org>, Taniya Das <quic_tdas@quicinc.com>,
	Mike Tipton <quic_mdtipton@quicinc.com>,
	Georgi Djakov <djakov@kernel.org>
Subject: Re: [PATCH 3/2] arm64: dts: qcom: sc7180: Remove ipa interconnect
 node
Message-ID: <Yl92UkRwlQsd71mr@ripper>
References: <20220412220033.1273607-1-swboyd@chromium.org>
 <20220415005828.1980055-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415005828.1980055-1-swboyd@chromium.org>

On Thu 14 Apr 17:58 PDT 2022, Stephen Boyd wrote:

> This device node is unused now that we've removed the driver that
> consumed it in the kernel. Drop the unused node to save some space.
> 

I'm expecting that merging patch 3 and 4 will work, but cause sync_state
to not happen until the driver changes are merged.

Can you confirm my expectation? And perhaps confirm that it's fine for
Georgi to pick the driver changes independently of the dts changes...

Regards,
Bjorn

> Cc: Alex Elder <elder@linaro.org>
> Cc: Taniya Das <quic_tdas@quicinc.com>
> Cc: Mike Tipton <quic_mdtipton@quicinc.com>
> Cc: Georgi Djakov <djakov@kernel.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  arch/arm64/boot/dts/qcom/sc7180.dtsi | 7 -------
>  1 file changed, 7 deletions(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sc7180.dtsi b/arch/arm64/boot/dts/qcom/sc7180.dtsi
> index e1c46b80f14a..1ff96ef30e3f 100644
> --- a/arch/arm64/boot/dts/qcom/sc7180.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sc7180.dtsi
> @@ -1421,13 +1421,6 @@ mmss_noc: interconnect@1740000 {
>  			qcom,bcm-voters = <&apps_bcm_voter>;
>  		};
>  
> -		ipa_virt: interconnect@1e00000 {
> -			compatible = "qcom,sc7180-ipa-virt";
> -			reg = <0 0x01e00000 0 0x1000>;
> -			#interconnect-cells = <2>;
> -			qcom,bcm-voters = <&apps_bcm_voter>;
> -		};
> -
>  		ipa: ipa@1e40000 {
>  			compatible = "qcom,sc7180-ipa";
>  
> -- 
> https://chromeos.dev
> 
