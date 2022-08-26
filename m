Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA72428E8
	for <patches@lists.linux.dev>; Fri, 26 Aug 2022 09:04:16 +0000 (UTC)
Received: by mail-lf1-f41.google.com with SMTP id bt10so1198488lfb.1
        for <patches@lists.linux.dev>; Fri, 26 Aug 2022 02:04:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=AjQiG4EgjmYRn7Cg4E7RAYUNnb1Av4V8ZZtkQ1I3e+4=;
        b=hHIeZDnJuAFCgFgfQpFKWOqQxdQGMecO6XOIfthmP2g9jbqB1VY8dkv94z/m3BeXm4
         Tf1N4D+Jbpakj+f5VOnzfWR2VNBljEBk98ZwgYJV8lWVsZB2Y/ycZmqsruALQMjV4u22
         DM8OF4PaoP3NGoKl97AZ5Mkm2Q6ZoP1Klf1BCZw9WbEmyVIEQPMZhKa8k6QEp1HP6BhG
         6juyhvxxLMe3PkzLHn7X8GoOgX2OlA+UzGFznNEpiE5AvaodjNKejZj1sZ11XJFLKiav
         uOUsYcOtzgVxSlKA7Dh3rSXWkfeKmVHDVLyQI2ymJM73+wT9NCyM23ibDBCE50yAZowe
         ctjw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=AjQiG4EgjmYRn7Cg4E7RAYUNnb1Av4V8ZZtkQ1I3e+4=;
        b=uG19aSuU1kKBAY5nzgaFCDni3lIwCtoc2LYHIG8uqWg2wtMmHUZejWjbmP14qxu5mQ
         uvYyN7ZY8yjpKD7XdTDXl9lS3np1fNBhHc3CTqPtrW6ePB7xXcKqxIPXrvSvbJejkjb6
         +e1vCJk86Iyor9clITGARP4JVYw9dOT8DzphQkFGwGcI4+1PWueef3DrHa/6HvzcyBnu
         o9SmY7WE0jMtldb9Uw5UJ7/X6rw+BtUZrZWPWgKhYjcG3U6bSEwDaK6/J/cTQPME76ou
         BrCP8+D6PL6eOeZ6DgmBD306DNvCAZtJcT5dZpvR3oqJ9IcAgfgmrTAYmUNl3C0yVCfU
         H0kA==
X-Gm-Message-State: ACgBeo3Rjv945gF/Nw+aMRHbHdoOSpUdyskMVUhD9yYVkzz7WUqeWG8k
	+X2JA4dqV/Am4fNJKEkj7r9HbvOEjNuadw==
X-Google-Smtp-Source: AA6agR7dh79FCl2FsfmNeeOKbVCCJZcOlRaDjGQ/56qG/mm45vx3UOGF5F3lMLWqud1gracnsstj/g==
X-Received: by 2002:a05:6512:b1c:b0:492:8835:1e4c with SMTP id w28-20020a0565120b1c00b0049288351e4cmr2095766lfu.442.1661504655030;
        Fri, 26 Aug 2022 02:04:15 -0700 (PDT)
Received: from [192.168.1.211] ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id d11-20020a056512368b00b00492e10b1723sm310683lfs.139.2022.08.26.02.04.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 02:04:14 -0700 (PDT)
Message-ID: <bd791d9b-3b64-22ab-723c-86003c25554f@linaro.org>
Date: Fri, 26 Aug 2022 12:04:13 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH v2 3/3] drm/msm/dp: Get rid of
 dp_ctrl_on_stream_phy_test_report()
Content-Language: en-GB
To: Stephen Boyd <swboyd@chromium.org>, Rob Clark <robdclark@gmail.com>,
 Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Sean Paul <sean@poorly.run>, dri-devel@lists.freedesktop.org,
 freedreno@lists.freedesktop.org, Kuogee Hsieh <quic_khsieh@quicinc.com>
References: <20220623002540.871994-1-swboyd@chromium.org>
 <20220623002540.871994-4-swboyd@chromium.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20220623002540.871994-4-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 23/06/2022 03:25, Stephen Boyd wrote:
> This API isn't really more than a couple lines now that we don't store
> the pixel_rate to the struct member. Inline it into the caller.
> 
> Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>

> ---
>   drivers/gpu/drm/msm/dp/dp_ctrl.c | 44 ++++++++++++--------------------
>   1 file changed, 17 insertions(+), 27 deletions(-)
> 

-- 
With best wishes
Dmitry

