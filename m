Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF69515A7
	for <patches@lists.linux.dev>; Thu, 14 Apr 2022 02:30:43 +0000 (UTC)
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-de3ca1efbaso3940329fac.9
        for <patches@lists.linux.dev>; Wed, 13 Apr 2022 19:30:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=7X6E8VDuzQ2F6uzfOyPSrPGa6oXVkDPvWJCmwSR7mdo=;
        b=bo0blbPqgTEVW7RMqPw1KP4Oe7hINNAR2sPuU9TD3hbvp0BU91R9sK8aymt3DNT2Jp
         rRzKFRc9bN6xdz90wo2eRfib4wtO/vJiaUo3cVBDS5vE0YPOM/aATj19OSP2hJRmUG8r
         +sf0T52pDSmqXnBkg0B9xO3lzgCm/6spBgrrYC6Bt0/UrX01eanO/OwXa2S7GqXDB9eg
         AjfeZxHetIo+V684w7eCscmFr05tON/5YOi8/SHSKEOL2O1U99fIidbNOriMptDljSZ4
         jFN5menkSvIy44jD/eAowSrcmDTLW1L0X+6Pe02O0vGmiLNcUZTY0llEqJDByhGUpbCK
         zKVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=7X6E8VDuzQ2F6uzfOyPSrPGa6oXVkDPvWJCmwSR7mdo=;
        b=0Uz2BcDBvm/45pDVt4kzKVY3c+buxBGjyFBVShHPFiy9a8uVg8ydAeQCyLIk8yg9Ez
         2O/O8Gac/IP16uh/3vSGU8ibgxDrZT075WjrCU803jqH/zN6ocR6nhPGI0EdWk7PKZ0b
         3TGvxE+ml1+oSXNpU8cvKceuvITi2Zd/gggrq9PDt84kTQDMmotUokQhfPtDNr/sT7J7
         ZZ8WkQLyewoJ+CdiXgNb8bcQmsdPZmI5fmPvEeHbWKIem4XBjMJO7HNm85Hn/a836KPc
         ot/nNibD815pElG1OiNzit9GN3Kl5nz1+W179B8LxBw3IphbRekGt5mnChHUb5GzWCyx
         yPyw==
X-Gm-Message-State: AOAM530Tjr1+GMpqD+g0P6N7HOcTrep/+AcgXU5y2Z4pH+okhHoTWqV6
	nznblx5tdIiCASlMixyGuYWxkg==
X-Google-Smtp-Source: ABdhPJzUtEe+aXzU9LlPHKE08voE5cBhh6v8HbXuxYfmuSt7QTqtLUQm5R5Mwd3zhNzmSqC17u65TA==
X-Received: by 2002:a05:6870:9604:b0:de:a876:fbba with SMTP id d4-20020a056870960400b000dea876fbbamr670561oaq.239.1649903442911;
        Wed, 13 Apr 2022 19:30:42 -0700 (PDT)
Received: from ripper ([2600:1700:a0:3dc8:205:1bff:fec0:b9b3])
        by smtp.gmail.com with ESMTPSA id d17-20020a056830045100b005e9d02b0be2sm285463otc.58.2022.04.13.19.30.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Apr 2022 19:30:42 -0700 (PDT)
Date: Wed, 13 Apr 2022 19:32:55 -0700
From: Bjorn Andersson <bjorn.andersson@linaro.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Georgi Djakov <djakov@kernel.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, linux-arm-msm@vger.kernel.org,
	linux-pm@vger.kernel.org, Alex Elder <elder@linaro.org>,
	Taniya Das <quic_tdas@quicinc.com>,
	Mike Tipton <quic_mdtipton@quicinc.com>,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Subject: Re: [PATCH 0/2] interconnect: qcom: Remove IP0 resource
Message-ID: <YleH1+V9RCtMGege@ripper>
References: <20220412220033.1273607-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220412220033.1273607-1-swboyd@chromium.org>

On Tue 12 Apr 15:00 PDT 2022, Stephen Boyd wrote:

> These two patches remove the IP0 interconnect used for IPA because
> they're also present in the clk-rpmh driver. I see there are some more
> IP0 usages in the interconnect drivers, but I don't see a corresponding
> IPA clk in clk-rpmh, so I left these out. We can remove all of them if
> desired, but the sc7180 patch is most important to me as it fixes
> boot on my trogdor lazor device.
>  
> Stephen Boyd (2):
>   interconnect: qcom: sc7180: Drop IP0 interconnects
>   interconnect: qcom: sdx55: Drop IP0 interconnects
> 
>  drivers/interconnect/qcom/sc7180.c | 21 ---------------------
>  drivers/interconnect/qcom/sdx55.c  | 21 ---------------------
>  2 files changed, 42 deletions(-)
> 
> Cc: Alex Elder <elder@linaro.org>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Taniya Das <quic_tdas@quicinc.com>
> Cc: Mike Tipton <quic_mdtipton@quicinc.com>
> Cc: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> 

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

> base-commit: 3123109284176b1532874591f7c81f3837bbdc17
> -- 
> https://chromeos.dev
> 
