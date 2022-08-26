Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C2B228E8
	for <patches@lists.linux.dev>; Fri, 26 Aug 2022 09:03:44 +0000 (UTC)
Received: by mail-lf1-f53.google.com with SMTP id m5so1190360lfj.4
        for <patches@lists.linux.dev>; Fri, 26 Aug 2022 02:03:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=6wjKp5duJTgVfzr1UXrwjF1SALPZrTw3gPVi12ZjH/g=;
        b=qzAMa2OWyy36WWaZwRfSzNNZqXwBIqn7RW1geIbwXoLZbxJ20jcuOQ43Pd0nkn9fOb
         RCX57WrBDnQ1/MtpmUvixjAeiITsndFGd8381UD2uc3E6UxNP3vSDTBAYHb9EL9STfjL
         bQM576O9O5ND/BnhZhbDaGupllZa2HTbhftLmuVrfydgxE2jGwtgn8usWEKJ0lYMa62L
         p7/uf3nFQIr5eKPGwd7y30DFVGzuy+sscnKJj+SIw9j8vfs5ozq/P+aGco/UTxF+cZFr
         mIw65hXoJ151Vp4g47rISWYFjKN3M0eJZgDW8k1Prs2N903GaB8QMDwiDlsZGR+XB4x8
         32wQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=6wjKp5duJTgVfzr1UXrwjF1SALPZrTw3gPVi12ZjH/g=;
        b=wTriT7TmtCJALCxYBNUwBzuGNOeFvn4hPifPKj4LjG+vfn1DHS+6zuZwFTKUanPJhd
         Jn+T7O4LBADIuDXZtyObhuhSzbpqZjfLTe1HnY+6YAjBhNchWQawjUNPEutAuzLZgp18
         EEZGRf+/wDKkuhbNnEZnHYqR4MQFlBr6oTChh9LkhQOAhyJHRda9Is2tfRxmr/Zqa8Ue
         PJ5bQjYDWyjkgQM617sIZ0GihAFkUdHe2zRcdvj0ghB9SSYAVYJPweAJYqD92LU0byXS
         lN8mdkaLAac+b0v6PMCVT4pXvuZMddzYGpKXTe5eMlZqgfGUegGp4FbC54PO27c78xl9
         wrrg==
X-Gm-Message-State: ACgBeo2CS0XA16gpgASI+NZDVTqKduAnaScP5wmgM7DrVtRq+r5RWh3F
	G5Zz8B+NksNFJD+SaOcAZNBv2w==
X-Google-Smtp-Source: AA6agR4CyEq8JY4VnBVKnVhOwimuVLC9QM98RVtC/yFTvCc2rvMTc7BcK1xzXFH+y17DGL5I65x8Kw==
X-Received: by 2002:a05:6512:1087:b0:492:e36c:d6c6 with SMTP id j7-20020a056512108700b00492e36cd6c6mr2094268lfg.502.1661504622340;
        Fri, 26 Aug 2022 02:03:42 -0700 (PDT)
Received: from [192.168.1.211] ([37.153.55.125])
        by smtp.gmail.com with ESMTPSA id o4-20020ac24e84000000b00492de54940asm318699lfr.82.2022.08.26.02.03.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Aug 2022 02:03:41 -0700 (PDT)
Message-ID: <c49749ed-5fce-6d91-b114-e4e0daf64042@linaro.org>
Date: Fri, 26 Aug 2022 12:03:34 +0300
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.2
Subject: Re: [PATCH v2 2/3] drm/msm/dp: Remove pixel_rate from struct dp_ctrl
Content-Language: en-GB
To: Stephen Boyd <swboyd@chromium.org>, Rob Clark <robdclark@gmail.com>,
 Abhinav Kumar <quic_abhinavk@quicinc.com>
Cc: linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Sean Paul <sean@poorly.run>, dri-devel@lists.freedesktop.org,
 freedreno@lists.freedesktop.org, Kuogee Hsieh <quic_khsieh@quicinc.com>
References: <20220623002540.871994-1-swboyd@chromium.org>
 <20220623002540.871994-3-swboyd@chromium.org>
From: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
In-Reply-To: <20220623002540.871994-3-swboyd@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 23/06/2022 03:25, Stephen Boyd wrote:
> This struct member is stored to in the function that calls the function
> which uses it. That's possible with a function argument instead of
> storing to a struct member. Pass the pixel_rate as an argument instead
> to simplify the code. Note that dp_ctrl_link_maintenance() was storing
> the pixel_rate but never using it so we just remove the assignment from
> there.
> 
> Cc: Kuogee Hsieh <quic_khsieh@quicinc.com>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>

Reviewed-by: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>


> ---
> 
> dp_ctrl_on_link() almost doesn't even use the pixel_clk either. It just
> prints the value. I kept it around because maybe it is useful? But if
> not, then we can remove even more code.

Feel free to submit a patch and check if anybody (Kuogee? Abhinav?) 
complains.

-- 
With best wishes
Dmitry

