Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1247D33C2
	for <patches@lists.linux.dev>; Thu, 12 May 2022 15:15:34 +0000 (UTC)
Received: by mail-io1-f49.google.com with SMTP id z18so5670080iob.5
        for <patches@lists.linux.dev>; Thu, 12 May 2022 08:15:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dAccpwSlABENXdFG9sL3n5Vq8ZaFU7f/P797lgrtYLc=;
        b=S6/2IQdesgT7HD9HzOnm2VtvcaZChiNAeweXM9MRnpGSoeJxyqrG2uyzxTE9VF35kn
         CfwoG+pozkRvmrdRIPmld7pzyRISLl08j+Ed53rzAPycM0ZquKI4kg9zbUv+BnU1iXWv
         KerHH4ulMvljguFLUk3jrUUS5Wio2AYd5pZ20oHoLh0HgZscdXc5NaKmMoXOxpV2TJR8
         D1yP9hYsk8xDqU3YtnEntDCWjQ7Yfdex9shx5IE0xqKV3hv4CVftPCUA+Lj7ScUe9aXk
         aVV8kfkOx1e/XocEY9ZL7yCEVvNU1W7YjzXpqFSXJh1j7bt3T1qjMS+HrgWTYtj54mHC
         8Blg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dAccpwSlABENXdFG9sL3n5Vq8ZaFU7f/P797lgrtYLc=;
        b=KP+0oSDabJ8wY372Jql2FW8OG52TtM+xg0+6VxvSkB/6oteT65pdIroD7kqJSk4EGG
         oK6a8lCHCddBCNHsb4WzDNFq4L4tYJQMxLYe7qKvrgs0lpq3UEfXS9JdsVfd1SO8wA7+
         xZqq2Ln0F5KJuKX2we+MeRQm/SbnvofQi5LV5z6Knvnb4m6Nlp9SZzOpGNDOZeA45dM5
         BlSsZBZH08pZT+ZzMlxGrQf9QG5G4bSjfj3amvcFu64TpN4Ijpax5RADT+BSIsHHTqhO
         quOh4lmKUKnPZrqAkiQvbPCogRKKRIm+90bmf28AJa4h9IS03Sw5QJgA27x/ELGwZKGK
         UVSQ==
X-Gm-Message-State: AOAM530qUK7ZsYB1+ZflvftjmClr+qXMTuqj9qn0zawmIqqFthW2MYD9
	IZHZi+/DnbRcVlXw+uzhTWENJg==
X-Google-Smtp-Source: ABdhPJxwIeyEF1HtBBqviDCiriuSC5OHYCqL7VMDLuu3vGIGNw93U8fo5359mgxNfCVPk7MMDEIgfw==
X-Received: by 2002:a02:900d:0:b0:32a:ec66:4fa7 with SMTP id w13-20020a02900d000000b0032aec664fa7mr217333jaf.271.1652368532653;
        Thu, 12 May 2022 08:15:32 -0700 (PDT)
Received: from [172.22.22.4] (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.googlemail.com with ESMTPSA id h3-20020a022b03000000b0032b3a781766sm1452036jaa.42.2022.05.12.08.15.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 May 2022 08:15:32 -0700 (PDT)
Message-ID: <4e14f1d5-2abc-8c30-d54d-7e542ca4eccf@linaro.org>
Date: Thu, 12 May 2022 10:15:31 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [PATCH] clk: qcom: rpmh: Set wake/sleep state for BCM clks
Content-Language: en-US
To: Stephen Boyd <swboyd@chromium.org>,
 Bjorn Andersson <bjorn.andersson@linaro.org>
Cc: Michael Turquette <mturquette@baylibre.com>,
 Stephen Boyd <sboyd@kernel.org>, linux-kernel@vger.kernel.org,
 linux-clk@vger.kernel.org, linux-arm-msm@vger.kernel.org,
 patches@lists.linux.dev, Taniya Das <quic_tdas@quicinc.com>
References: <20220412194505.614002-1-swboyd@chromium.org>
 <YnKvoh+h07at8b65@builder.lan>
 <CAE-0n517iAS9KSdunMX18LpqDrQ4ac-yRCZq82j-XdExaGjCXA@mail.gmail.com>
 <CAE-0n53eXiz74iCHHQaC-eDFkuui9Y1xXvuqd2g0UnrwbYhZTg@mail.gmail.com>
From: Alex Elder <elder@linaro.org>
In-Reply-To: <CAE-0n53eXiz74iCHHQaC-eDFkuui9Y1xXvuqd2g0UnrwbYhZTg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/11/22 5:04 PM, Stephen Boyd wrote:
>>> Will you take this in fixes, or do you want me to pick it for 5.19?
>>>
>> I'm waiting for Taniya to reply. For all I know this has no effect
>> because there's some sort of copy/paste from one state to another. Until
>> then it doesn't seem like we should do anything.
> Taniya told me that if there's no sleep or wake state set then active
> state remains even when the subsystem is in sleep. Not exactly
> copy/paste but at least it is consistent. We need a comment here so this
> doesn't come up again.

If I understand what you're saying here, your original patch is not
necessary, but there should be a comment in the code that explains
why that is the case.  Is that right?  And am I right to assume you
will be sending out a patch with such a comment?

					-Alex
