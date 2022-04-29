Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 459D0ECA
	for <patches@lists.linux.dev>; Fri, 29 Apr 2022 00:06:45 +0000 (UTC)
Received: by mail-pf1-f182.google.com with SMTP id g8so3150993pfh.5
        for <patches@lists.linux.dev>; Thu, 28 Apr 2022 17:06:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HpV1ixPM2861kaxt/14eSMI/MvjDy1lHv4NPX3qirHg=;
        b=dBxiAOMlhDdXnkDqXxja8EyRt46K/yuShuxCEotxkqsZIN0izZzzQhLNPDyjv8vWOc
         xehVVwH9L3o+WkO5OxjRBImFCWTbRaRxhuWIyuTn3RjWX9QgfG0bHdiPkj4S1PatMPTS
         keEHoWPVYt/hl5oYi89OeLCtPc5ctae/zWa4o=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HpV1ixPM2861kaxt/14eSMI/MvjDy1lHv4NPX3qirHg=;
        b=EnG4tmsi864SMc3ljzjjaL+icwfOoFBvbepWYsQzu3jL2V/TPgiu/zh+v1zqMq8rr4
         b8/ICgNj0U+WETEaLLBAy/rKum1chLy51oP1Ra2mpY9TIudt40yS7HacS3Ze2ih1at4z
         hrcFeZnUJCKjb/me4OTpfhARMcD7NNHTNGPtbxSm2up7jgGeN0wmpAIgWBNWHOD/jqgU
         Qjo7l6AkjfzWnvflROGtfEnQX9POqK9kBdjE9I2vXolh07UEjl12LeXanvMYSKG1302N
         pUhXTJ/+FdYX4z5yoOGvfYVkKFq7JFDBYsYAMLhoNMm/WrXsaLf/8Q36h3pIYmkZbKd2
         a0Bw==
X-Gm-Message-State: AOAM532vEwkE/D9H5tqwXAWebEyzd+UhB6n7BaHCxSULwZgNeAh3QOk3
	Sl0xSOvNlZKXP1LnazFfeDLMmw==
X-Google-Smtp-Source: ABdhPJyJyas/ZSpCB0U1vjVYqGWRrlEWh5HDYPMVm2KJ3Fv4/6HRmCPq/XV4joXVJj4FOucxbgl0pQ==
X-Received: by 2002:a63:115:0:b0:3ab:1c6c:c26b with SMTP id 21-20020a630115000000b003ab1c6cc26bmr21758559pgb.448.1651190804795;
        Thu, 28 Apr 2022 17:06:44 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:7d14:5f45:9377:9b6a])
        by smtp.gmail.com with UTF8SMTPSA id mn12-20020a17090b188c00b001cd4989ff64sm7719889pjb.43.2022.04.28.17.06.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 17:06:44 -0700 (PDT)
Date: Thu, 28 Apr 2022 17:06:43 -0700
From: Matthias Kaehlcke <mka@chromium.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	"Joseph S. Barrera III" <joebar@chromium.org>,
	Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2 1/3] arm64: dts: qcom: sc7180-trogdor: Simplify
 trackpad enabling
Message-ID: <YmssE8eX4FPpFduY@google.com>
References: <20220427020339.360855-1-swboyd@chromium.org>
 <20220427020339.360855-2-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220427020339.360855-2-swboyd@chromium.org>

On Tue, Apr 26, 2022 at 07:03:37PM -0700, Stephen Boyd wrote:
> Trogdor boards with a detachable keyboard don't have a trackpad over
> i2c. Instead the trackpad is on the detachable keyboard base. Let's move
> the enabling of the trackpad i2c bus out of the base sc7180-trogdor.dtsi
> file so that each trogdor board that is detachable, of which there are
> many, doesn't have to disable the trackpad bus.

Makes sense.

Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
