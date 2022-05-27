Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294DF1FA4
	for <patches@lists.linux.dev>; Fri, 27 May 2022 14:23:34 +0000 (UTC)
Received: by mail-io1-f53.google.com with SMTP id s23so4748828iog.13
        for <patches@lists.linux.dev>; Fri, 27 May 2022 07:23:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=Dl3neGbWJuUPrZD+P8vdryuz/5nRnjOm3eWjq/e3Vh0=;
        b=QuTQClfDaEKtCFxDZXxpBx113hn5JCwCa5KmeRzf9H2LW2g5b55dqf0JqQSQOAUdRA
         K1SzvBsYWjiyXF1Pt7RU7D23D1b95EWbOYk4yZK/yyye6WlgOUEgbEVk6g8z7uU7x+E5
         tb6lzYUMH3mrDhuNykUMDq2L5dbQECyvaqoD0nFW3zGzpGlivGJzl6o2MXhtitZo9MNm
         olGL6qMxKPApuN5SzBidAvn0HYmuOvFLaCmoiHtUp+5QpUsW+bsYwJqTA/SlIvMYCTOx
         HFDr/XxJBKLBit1JLlIS9M1OmtqOGJI8K/a6/oV2ddrQE0CeTU9jQPjW/+CGvN6u3W1Q
         ziMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=Dl3neGbWJuUPrZD+P8vdryuz/5nRnjOm3eWjq/e3Vh0=;
        b=n12Y2O3mODoKHmy2WU8/Z2qoHxnTljv2oqS8/PLwNABPhuRLulOzMe8F1gCbpI2u8L
         31WHBTt8cEOcNdJR/W6K1q9CgtffoN9FI4LxL7otYMIjZZadxUTb23mpd6Obp9exNEO1
         Kptmr5Or+eQsi1sl1JNMMHTkjDW7IoWjbpSUAs1PhTzogw+IKpWXbKLRbtKvVSA/9PPJ
         8rBqvrkzdnB6i1vE2/bDHDxTjzG0uP72Ju86Vdd2YEHrq+LBdhjc8xpjgGrC3Nz48IS/
         UkFiM3LKnt70qkvr6E6mSpHN56n6pAadE445CygxJ8MuyoXeV8fPmIpkqrC03u1+fxqA
         YaIg==
X-Gm-Message-State: AOAM531cd43lxwrhH8jW+zPUwjySJ8B4gzJl2vFlIw8eB1S/aF18nx4S
	t1WbyR4l+3SSSyEtk08mNueG3g==
X-Google-Smtp-Source: ABdhPJwGWdrEGfIXWmlj206LeA00IrZgWciBCp2zZTxFCqvThu44vgP0eYq8ge4I4+TmZf/KvykkiA==
X-Received: by 2002:a5d:8619:0:b0:668:4b3d:baf0 with SMTP id f25-20020a5d8619000000b006684b3dbaf0mr1883558iol.185.1653661413138;
        Fri, 27 May 2022 07:23:33 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id d17-20020a0566022bf100b00657b5623333sm1248877ioy.3.2022.05.27.07.23.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 May 2022 07:23:32 -0700 (PDT)
Message-ID: <d9e3bb1d-b9e6-5047-04be-01e69394d9cf@linaro.org>
Date: Fri, 27 May 2022 09:23:31 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH] clk: qcom: rpmh: Add note about sleep/wake state for BCMs
Content-Language: en-US
From: Alex Elder <elder@linaro.org>
To: Stephen Boyd <swboyd@chromium.org>,
 Michael Turquette <mturquette@baylibre.com>, Stephen Boyd
 <sboyd@kernel.org>, Bjorn Andersson <bjorn.andersson@linaro.org>,
 Taniya Das <quic_tdas@quicinc.com>
Cc: linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
 patches@lists.linux.dev, linux-arm-msm@vger.kernel.org
References: <20220517190949.2922197-1-swboyd@chromium.org>
 <cb32f8c6-8a4a-cc3d-4154-a4377a238628@linaro.org>
In-Reply-To: <cb32f8c6-8a4a-cc3d-4154-a4377a238628@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/17/22 2:16 PM, Alex Elder wrote:
> On 5/17/22 2:09 PM, Stephen Boyd wrote:
>> The sleep/wake state doesn't need to be set here because of specific
>> RPMh behavior that carries over the active state when sleep/wake state
>> hasn't been modified. Add a note to the code so we aren't tempted to set
>> the sleep/wake states.
>>
>> Cc: Alex Elder <elder@linaro.org>
>> Cc: Taniya Das <quic_tdas@quicinc.com>
>> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> 
> Looks good to me.  Thanks Stephen.
> 
> Reviewed-by: Alex Elder <elder@linaro.org>

Taniya, do you have anything to say about this patch?  -Alex

> 
>> ---
>>
>> This superseedes a previous patch[1] I sent that tried to fix this.
>>
>>   drivers/clk/qcom/clk-rpmh.c | 5 +++++
>>   1 file changed, 5 insertions(+)
>>
>> diff --git a/drivers/clk/qcom/clk-rpmh.c b/drivers/clk/qcom/clk-rpmh.c
>> index aed907982344..c07cab6905cb 100644
>> --- a/drivers/clk/qcom/clk-rpmh.c
>> +++ b/drivers/clk/qcom/clk-rpmh.c
>> @@ -274,6 +274,11 @@ static int clk_rpmh_bcm_send_cmd(struct clk_rpmh 
>> *c, bool enable)
>>           cmd.addr = c->res_addr;
>>           cmd.data = BCM_TCS_CMD(1, enable, 0, cmd_state);
>> +        /*
>> +         * Send only an active only state request. RPMh continues to
>> +         * use the active state when we're in sleep/wake state as long
>> +         * as the sleep/wake state has never been set.
>> +         */
>>           ret = clk_rpmh_send(c, RPMH_ACTIVE_ONLY_STATE, &cmd, enable);
>>           if (ret) {
>>               dev_err(c->dev, "set active state of %s failed: (%d)\n",
>>
>> base-commit: 42226c989789d8da4af1de0c31070c96726d990c
> 

