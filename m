Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EBE82F23
	for <patches@lists.linux.dev>; Wed, 13 Apr 2022 21:02:03 +0000 (UTC)
Received: by mail-io1-f43.google.com with SMTP id 125so3295893iov.10
        for <patches@lists.linux.dev>; Wed, 13 Apr 2022 14:02:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=/qUIJWUYp0OgGPrDZUu+q7DE+3dlNWkqw9Br15Nf3Qo=;
        b=OFkr8OF7baDSWlxCIRyQaETk6E21TEaTMW5FVY+5KHmdECRnIAsakMkZ/xCkZXz4ac
         PdZqm6T77fdP7wYKyifi5RY9/SKqzc9ibPhBZrX838SKGG22M6CycSrHR9Ju/Op7WzvQ
         QwZNjVRy6QjsZ59/TF2V3TjHUZ7PfedKp5pDfUZDzX9qKsYuyjQkbbgQP79z5ZV1tFdO
         vTpckEpdgg4UwHcW2gktfOivWYC86kxRnF50FdeNeCrMtNsqb/kDTmVJh3bh8F+mnam9
         tSxzUURicv6wWp9KxpmEx71w2UA03ns+iN3HUGcsuiXiK0xbt9C7+tasx/OuDNLNR19x
         1lOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=/qUIJWUYp0OgGPrDZUu+q7DE+3dlNWkqw9Br15Nf3Qo=;
        b=baob5R1R661kBbksWwKCPEosMOyRavHNwCJSkfjOv1hMhFuHngpiuGR9G8HnU1W5Lg
         uqKFQ7SIA1X9tpZcSNhMYFES8bcDyH3zjo519gpzNvqH3EuopeyYjca3Wzyfp0/pRjqM
         EIhfrJFED51vexTljHJF1PBdN/2qxLLSBgxp5lp6Wj4TUcXSuBO7auhJB59jsLytSWGS
         shPA+WIGKC2QfaZgqvCUTU3ZEH/68OV31AIKkd5KshSLdtpb+VbyzmnG2h29qVd5E9vn
         YUq0Am5whzODgI8JkSMrwWgbddSJQxY1Payun0pY69r4LqvmaNZvLZRYye/SQMNWQMxK
         231Q==
X-Gm-Message-State: AOAM533sepddpMYkdPKvxCeSp0yUKr57QX2UU4wzzi46ugxNNLkLpzfS
	eYk6mcb3+2ZGTZM5gd2You1lNA==
X-Google-Smtp-Source: ABdhPJxBqzKWs5v+J9djfCdod9R40p3p0DgaokqZxmyWAB6vqPwMBob/hkA2/LTw8bOWzbrl4sSpQQ==
X-Received: by 2002:a05:6638:25c2:b0:326:223d:4494 with SMTP id u2-20020a05663825c200b00326223d4494mr9784815jat.162.1649883722145;
        Wed, 13 Apr 2022 14:02:02 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id i5-20020a6bf405000000b00645be60c31csm21576iog.23.2022.04.13.14.02.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Apr 2022 14:02:01 -0700 (PDT)
Message-ID: <d80ece40-fdd7-f304-3989-47ae152d5ac9@linaro.org>
Date: Wed, 13 Apr 2022 16:02:00 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 1/2] interconnect: qcom: sc7180: Drop IP0 interconnects
Content-Language: en-US
To: Doug Anderson <dianders@chromium.org>, Stephen Boyd <swboyd@chromium.org>
Cc: Georgi Djakov <djakov@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
 patches@lists.linux.dev, linux-arm-msm <linux-arm-msm@vger.kernel.org>,
 Linux PM <linux-pm@vger.kernel.org>,
 Bjorn Andersson <bjorn.andersson@linaro.org>,
 Taniya Das <quic_tdas@quicinc.com>, Mike Tipton <quic_mdtipton@quicinc.com>
References: <20220412220033.1273607-1-swboyd@chromium.org>
 <20220412220033.1273607-2-swboyd@chromium.org>
 <CAD=FV=UFbOhs0ggxDbVwKM_8x=ELT85zFd-Wk6dJ_M+Awz+Pxw@mail.gmail.com>
From: Alex Elder <elder@linaro.org>
In-Reply-To: <CAD=FV=UFbOhs0ggxDbVwKM_8x=ELT85zFd-Wk6dJ_M+Awz+Pxw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/13/22 3:55 PM, Doug Anderson wrote:
> Hi,
> 
> On Tue, Apr 12, 2022 at 4:20 PM Stephen Boyd <swboyd@chromium.org> wrote:
>>
>> @@ -519,8 +500,6 @@ static const struct of_device_id qnoc_of_match[] = {
>>            .data = &sc7180_dc_noc},
>>          { .compatible = "qcom,sc7180-gem-noc",
>>            .data = &sc7180_gem_noc},
>> -       { .compatible = "qcom,sc7180-ipa-virt",
>> -         .data = &sc7180_ipa_virt},
>>          { .compatible = "qcom,sc7180-mc-virt",
>>            .data = &sc7180_mc_virt},
>>          { .compatible = "qcom,sc7180-mmss-noc",
> 
> I have no objection to ${SUBJECT} change landing and based on all your
> research and Alex's review/testing I think it's good to go.
> 
> However, now that you're removed the driver that cared about
> "qcom,sc7180-ipa-virt", should we also be removing it from the
> `bindings/interconnect/qcom,rpmh.yaml` file and the `sc7180.dtsi`
> file? I think that removing it from _either_ the driver (like your
> patch here does) _or_ the sc7180.dtsi file would fix the bug, right?
> ...and then removing it from the yaml would just be cleanup...

That's a good point, I hadn't thought about that but you're right.

I think we were too pleased about identifying the problem and
proving it could happen (and cause a crash), so we didn't think
hard enough about this other piece.

Stephen, I think you should re-spin the series and add the
proper change to the binding.  You can keep the tags I gave
before.

I've got a note to follow up with similar changes to other
platforms where the interconnect driver includes resource "IP0"
and will plan to do what Doug suggests there too.

					-Alex

> -Doug

