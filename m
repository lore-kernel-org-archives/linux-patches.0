Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C231C28A
	for <patches@lists.linux.dev>; Wed,  3 Jan 2024 17:29:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lzNaM5nr"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-a2345aaeb05so1112054766b.0
        for <patches@lists.linux.dev>; Wed, 03 Jan 2024 09:29:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704302996; x=1704907796; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZlwuQ9Xlo8ePc/4r6+pWqnNdOQQ9eRack09kFcT1q/o=;
        b=lzNaM5nrYMwzjyLwGidklcRkuecX51MD/Kq8tcOi7gwFu0UyI4tOaIM7j4Z4SzahFu
         J5Wa1aTMz1EHQQnzGiKtNKw49Nu0xukusn7icZlCqrk36WrkzprNt/lZT422xDrpwEVe
         HCDzjB+8vF/du5nSI9RGVp6eufva1o8B7uxcSsrOskb2786FYvULFDtI8uTSM39CPh6W
         kUEA7o/Zs+RqmKnWsl5PCnCzSspz7bQsswha2PoW0a5HQA7adM9eOIsA/i4DE8+lA8Bj
         gQie3k9FNPIGDcOHce00yuDsGy6bHx/Bwskg/MpCojU6Oo1HNLepvXlpAJAIcf7M11Mp
         jE0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704302996; x=1704907796;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZlwuQ9Xlo8ePc/4r6+pWqnNdOQQ9eRack09kFcT1q/o=;
        b=QGqiDvODy98fabzS9pFwCgAedFpsAZJzCMeeSTNsqodsTGgSnN6JkCtvTc0/iANyaV
         3+Tcg0tyHEql+fACArZjlTIy+6XZO3ksrxzKwUCYnYrOK577T/ZISGL9NDS9RV8wK65M
         4Zwr/nK3VlrpzCcheZbXDlkyyFygJ8nDQwB3suM4zuprUZR5dpULUAqje1YWgltNKhN2
         gkh7IeOQcYpcUGiw3IBHHVFQBw09yPDFAkSkptQzjfAo0QF8s/SmPWcYMFcP/2vxuiwL
         jGXjUYDRCkh7J+/XqSE73kCxLmJV6/+AzPlfBaF9YRCPExrUa3V8frnA165EroyBUW0j
         cQSg==
X-Gm-Message-State: AOJu0YyUKTiy2uWUvV2vhPKnnxKd/Nfi62cZOKPDO4STL/KRBSY5RU3b
	6eVXNarYsgGgfg+Etnwtu6TfvEf54efuQZbgiwHwjTxWQbA=
X-Google-Smtp-Source: AGHT+IG3bKLnWqG5R58BayQvhtQOd759v53bfy9vovK4eX16oj5kC2H2bhu2EZt24Z6VJdzp0DW1Zw==
X-Received: by 2002:a17:906:31d7:b0:a27:aebf:32af with SMTP id f23-20020a17090631d700b00a27aebf32afmr3163012ejf.8.1704302996198;
        Wed, 03 Jan 2024 09:29:56 -0800 (PST)
Received: from [192.168.199.125] (178235179036.dynamic-4-waw-k-1-3-0.vectranet.pl. [178.235.179.36])
        by smtp.gmail.com with ESMTPSA id fv14-20020a170907508e00b00a269f8e8869sm12915828ejc.128.2024.01.03.09.29.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Jan 2024 09:29:55 -0800 (PST)
Message-ID: <c336d05c-4d5e-4591-ae04-114eec801fff@linaro.org>
Date: Wed, 3 Jan 2024 18:29:54 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 29/75] interconnect: qcom: sm8250: Enable sync_state
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Georgi Djakov <djakov@kernel.org>,
 Sasha Levin <sashal@kernel.org>
References: <20240103164842.953224409@linuxfoundation.org>
 <20240103164847.570054712@linuxfoundation.org>
From: Konrad Dybcio <konrad.dybcio@linaro.org>
Autocrypt: addr=konrad.dybcio@linaro.org; keydata=
 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
 izWDgYvmBE8=
In-Reply-To: <20240103164847.570054712@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3.01.2024 17:55, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Konrad Dybcio <konrad.dybcio@linaro.org>
> 
> [ Upstream commit bfc7db1cb94ad664546d70212699f8cc6c539e8c ]
> 
> Add the generic icc sync_state callback to ensure interconnect votes
> are taken into account, instead of being pegged at maximum values.
> 
> Fixes: b95b668eaaa2 ("interconnect: qcom: icc-rpmh: Add BCMs to commit list in pre_aggregate")
> Signed-off-by: Konrad Dybcio <konrad.dybcio@linaro.org>
> Link: https://lore.kernel.org/r/20231130-topic-8250icc_syncstate-v1-1-7ce78ba6e04c@linaro.org
> Signed-off-by: Georgi Djakov <djakov@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
Hi, please drop this as the platform will become unbootable without
some more DT+driver changes.

Konrad
