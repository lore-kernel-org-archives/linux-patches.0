Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36DCD10E8
	for <patches@lists.linux.dev>; Fri, 29 Apr 2022 00:12:03 +0000 (UTC)
Received: by mail-pl1-f174.google.com with SMTP id b12so5745502plg.4
        for <patches@lists.linux.dev>; Thu, 28 Apr 2022 17:12:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=iuNk9MwvCvbcUppmRdVoXyJvLMt+O/9GswTClaDk/QM=;
        b=nWfkeFVVLQdjCRdfHRtk0H3wnlkeTaDVtdQC75mQJ/tOw2zRRrQwrl/sJAIpipBuPh
         byJp4Evcvz6giHI0Cfq9iLl4hj6N/Dcvll8yOLY2ObcC1IqMgNOrHsr3NmVj1uyZ0SMV
         qyxCkuv6bajjM3ZxmMMvm4WlG1VuhqXLNbWOY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iuNk9MwvCvbcUppmRdVoXyJvLMt+O/9GswTClaDk/QM=;
        b=hqQpWn6DcPB1xGgT6knkTXJs4ROCLjpoBo3WcLgBnnXcS0oDlCyHomCxnYdjXj8CGT
         z8n2NzXhrkv26aTGdMjEGPeL8nMkJ+81kZmujSHyjAzSuGC32k4zcA/xpsavWFph4Av9
         nTGeZ7PMB70BqHo5bIylQ6xK9x3LSXX60Q0+VdEhRDRo9bva9uDw/sXOJWLnkbh5TUst
         Rqk4RNo/mCusk9U/xf1mpEb6GH1KWYqu6cIw8vTptGjzO1htVIgoTssurtmMvuS8f9SK
         VLTQnUT2Gro+KZgiWOXTW/p3o1JisyJK7Qnz4NJOgXW208Pa9n3WxYdv+hBKU1N/5HF+
         1Usg==
X-Gm-Message-State: AOAM532dHdJBAFsm3lqoScvuOsaL+idJFdLdeqiSaGcPNEKxpS5G3I8/
	KDWchZJWFxJWnuuWpi/8DEgr3A==
X-Google-Smtp-Source: ABdhPJzcIuW/yBWAQUiE+LCgHZN1NHWgqzTsexx1tr6RbE8PgNgW0Cskvr5D7aO0nCb9SiDzr4B2gA==
X-Received: by 2002:a17:902:c408:b0:15d:1234:3434 with SMTP id k8-20020a170902c40800b0015d12343434mr23711839plk.67.1651191122732;
        Thu, 28 Apr 2022 17:12:02 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:7d14:5f45:9377:9b6a])
        by smtp.gmail.com with UTF8SMTPSA id q10-20020a056a00088a00b004f7ceff389esm944209pfj.152.2022.04.28.17.12.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 28 Apr 2022 17:12:02 -0700 (PDT)
Date: Thu, 28 Apr 2022 17:12:00 -0700
From: Matthias Kaehlcke <mka@chromium.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Andy Gross <agross@kernel.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org,
	"Joseph S. Barrera III" <joebar@chromium.org>,
	Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2 2/3] arm64: dts: qcom: sc7180-trogdor: Simplify
 spi0/spi6 labeling
Message-ID: <YmstUBkqAdWvMnm7@google.com>
References: <20220427020339.360855-1-swboyd@chromium.org>
 <20220427020339.360855-3-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220427020339.360855-3-swboyd@chromium.org>

On Tue, Apr 26, 2022 at 07:03:38PM -0700, Stephen Boyd wrote:
> We had to do this spi0/spi6 flip-flop on trogdor-r0 because the spi
> buses got swizzled between r0 and r1. The swizzle stopped after r1, but
> we kept this around to support either hardware possibility and to keep
> trogdor-r0 working.
> 
> trogdor-r0 isn't supported upstream, so this swizzle is not doing
> anything besides making a pattern that others tryt  to copy for the EC and
> H1 nodes. Let's remove it and simplify the dts files.
> 
> Cc: "Joseph S. Barrera III" <joebar@chromium.org>
> Cc: Douglas Anderson <dianders@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>

Reviewed-by: Matthias Kaehlcke <mka@chromium.org>
