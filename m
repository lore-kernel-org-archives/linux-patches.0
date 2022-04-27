Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2277A7F5
	for <patches@lists.linux.dev>; Wed, 27 Apr 2022 12:00:42 +0000 (UTC)
Received: by mail-io1-f45.google.com with SMTP id r12so2781364iod.6
        for <patches@lists.linux.dev>; Wed, 27 Apr 2022 05:00:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=uJp/JJSUdb5NG5iiGsZl36cc7WFEDeSvyBjzpbN59fc=;
        b=pmbPlEZDx0Wa9r9JN+tD5CuDKD14R/8J9c6EkZ0VoS3UVOlpi8PU4yZWHeHDzYXwQP
         lu5Oeo0cgEvSWvF4CIf+SaIhr5PmXoBAiL+S/GskpU3/VuQUYQoJcKIJXUeqYiNRg48N
         ZBzdhO/0WJG2nzeczJ/OY/KN1yOjflEj6kjBingEyQ9TfcjofdrVMs8x9F+xLi4bSobW
         xP/OveuMO1nXKsbpqj0U/gW9YO3u9+Q+J6uOHTOevV0EcyuJa/UV/jjcu2bsmt3ET4qp
         u6LBjr0E9vP+9IlU9nZh8JSdtKGVY0zlclhSkZak5v+iVXsLDWCXZHpCgu9MozWElzfs
         fcrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=uJp/JJSUdb5NG5iiGsZl36cc7WFEDeSvyBjzpbN59fc=;
        b=lEWm8Zrps4lonZQxx6erYaXp2xFWf4tznGzXIZkANoOrHj51FeeoiO+Qh8ZHoAm6KK
         zEJ7ut2r5/NzyVD8/UqSTwOerMzBQ5uw20VmVKsbo9K7sBg6IW3N6j4mAB54vwmlLZF9
         HTEAGzbnCw4vCQbcKIj0UZ4HLNvkk818xbn4AheCctp09ytWU1ooFXgqv4+9B1GSOMsW
         bkt/bTIkqq9U2XecgxndPHtMTlkBh2zs7YnAEl/fRh4NUTfzvj4kXArh4vDDIRzjbVEu
         wLmJ4sFSDn5WAeQjDCf/vDiI+qjzJEHOheoNL8Is6Zbwg9Kdx3qeAx9f836k1KAvsSY3
         67hA==
X-Gm-Message-State: AOAM531d65nBiKTvoABO1l5x3RQVYkX3y1mh/qyuLQ6aABuuhBY0Q6lu
	RbcX2oWrL4A9JjRFnXiUGrnY7g==
X-Google-Smtp-Source: ABdhPJwHjLeJJbdChzVJJlSrkomutEYhL9W3fsstsQXOFjen2Z2xkypvoqQp0vtxVifOD6udrTFa+g==
X-Received: by 2002:a05:6602:1683:b0:64f:ba36:d3cf with SMTP id s3-20020a056602168300b0064fba36d3cfmr11272481iow.144.1651060842050;
        Wed, 27 Apr 2022 05:00:42 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id q12-20020a056e02106c00b002cd81ae0a76sm7835790ilj.82.2022.04.27.05.00.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 05:00:41 -0700 (PDT)
Message-ID: <fb1f9a17-9b27-b0ac-124d-66644851e204@linaro.org>
Date: Wed, 27 Apr 2022 07:00:40 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] interconnect: Restore sync state by ignoring ipa-virt in
 provider count
Content-Language: en-US
To: Stephen Boyd <swboyd@chromium.org>, Georgi Djakov <djakov@kernel.org>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 linux-pm@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 Bjorn Andersson <bjorn.andersson@linaro.org>,
 Doug Anderson <dianders@chromium.org>, Taniya Das <quic_tdas@quicinc.com>,
 Mike Tipton <quic_mdtipton@quicinc.com>
References: <20220427013226.341209-1-swboyd@chromium.org>
From: Alex Elder <elder@linaro.org>
In-Reply-To: <20220427013226.341209-1-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/26/22 8:32 PM, Stephen Boyd wrote:
> Ignore compatible strings for the IPA virt drivers that were removed in
> commits 2fb251c26560 ("interconnect: qcom: sdx55: Drop IP0
> interconnects") and 2f3724930eb4 ("interconnect: qcom: sc7180: Drop IP0
> interconnects") so that the sync state logic can kick in again.
> Otherwise all the interconnects in the system will stay pegged at max
> speeds because 'providers_count' is always going to be one larger than
> the number of drivers that will ever probe on sc7180 or sdx55. This
> fixes suspend on sc7180 and sdx55 devices when you don't have a
> devicetree patch to remove the ipa-virt compatible node.
> 
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Doug Anderson <dianders@chromium.org>
> Cc: Alex Elder <elder@linaro.org>
> Cc: Taniya Das <quic_tdas@quicinc.com>
> Cc: Mike Tipton <quic_mdtipton@quicinc.com>
> Fixes: 2fb251c26560 ("interconnect: qcom: sdx55: Drop IP0 interconnects")
> Fixes: 2f3724930eb4 ("interconnect: qcom: sc7180: Drop IP0 interconnects")
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>

So of_count_icc_providers() counts the number of
interconnect providers defined in the DTB, regardless
of whether anything in the code supports it.

This seems to be a more general problem, but I
suppose in practice it's not likely to occur.

I think your solution looks fine, but I'm interested
in what Georgi has to say.

Reviewed-by: Alex Elder <elder@linaro.org>


> ---
>   drivers/interconnect/core.c | 8 +++++++-
>   1 file changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/interconnect/core.c b/drivers/interconnect/core.c
> index 9050ca1f4285..c52915a58b22 100644
> --- a/drivers/interconnect/core.c
> +++ b/drivers/interconnect/core.c
> @@ -1087,9 +1087,15 @@ static int of_count_icc_providers(struct device_node *np)
>   {
>   	struct device_node *child;
>   	int count = 0;
> +	const struct of_device_id ignore_list[] = {
> +		{ .compatible = "qcom,sc7180-ipa-virt" },
> +		{ .compatible = "qcom,sdx55-ipa-virt" },
> +		{}
> +	};
>   
>   	for_each_available_child_of_node(np, child) {
> -		if (of_property_read_bool(child, "#interconnect-cells"))
> +		if (of_property_read_bool(child, "#interconnect-cells") &&
> +		    likely(!of_match_node(ignore_list, child)))
>   			count++;
>   		count += of_count_icc_providers(child);
>   	}
> 
> base-commit: 2fb251c265608636fc961b7d38e1a03937e57371

