Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com [209.85.167.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26AC58F7D
	for <patches@lists.linux.dev>; Thu,  2 Feb 2023 21:49:49 +0000 (UTC)
Received: by mail-lf1-f42.google.com with SMTP id f34so5014833lfv.10
        for <patches@lists.linux.dev>; Thu, 02 Feb 2023 13:49:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KDgDu4Pg6Xihc/t0MuyIpqIzGcYpSCTohlnE5v2ocN4=;
        b=E1GIRojfvxs42+81MLxR/crCAkmGa0m7dglBBaSPcKfBcrb70wqCF4vLE0F5FRVIcz
         YxqXb0Z8Esm5uf3ctMLJVPXZFter8aeyB90SEQT1Y0dxU1Eic2jaxjmERcPwB+tyIVMU
         DtgPX32JZJxL2eaOEVtlLcpeqwueU9dKrXMoE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KDgDu4Pg6Xihc/t0MuyIpqIzGcYpSCTohlnE5v2ocN4=;
        b=Vl9Xc/r11DFPlELknWhoMzZxE5vwyEybPA/TU4/Gpsm45J98Qz9gdI6s/FCFQut8++
         Pcso9EvxECvOzMv7W9UV8tqGq9TWZUT1RoKWjHefDW568qER1zvtPxH5s1NmYCGYSmT+
         JbUexfPt5tRl6UdImotQi/JwiEdWX1nw5LvOuTfUEgym0jtpHNvEkrkzpP8f4nktw2Fi
         Vs6FnhhwTeJ8jN5UevwAve43GVLp0htzRKw3YVlNlK1XajAjDTlGhtOS2BQN9lIx0LIr
         HrGziV2IBbsTpo2eNeY+NZFDHNbrIV9DG7GIXdfQFpD4BXp28eAg+3E0fb5fO1vL0zqt
         YgoA==
X-Gm-Message-State: AO0yUKWtc0IE39oDH0dc3bHyQ0lqoX4gvqpRGLwPq4mHzC3pLOgdIS8n
	Gh5zuL40HwbifYUneKlqmHPVHPJxieBGdRh47vpRuw==
X-Google-Smtp-Source: AK7set8tw6glWzk+9yeJqW1TWOCmFoiQcVBfgfEBkbXcPo7ThefbfwmGxv6nVfCiz4o5sPmEjXJ7Pl4PU3COKQNMYv8=
X-Received: by 2002:a19:7005:0:b0:4d8:7552:2c19 with SMTP id
 h5-20020a197005000000b004d875522c19mr1166727lfc.34.1675374587154; Thu, 02 Feb
 2023 13:49:47 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 2 Feb 2023 13:49:46 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Y85l4aQmEW0iOHHa@hovoldconsulting.com>
References: <20230113204548.578798-1-swboyd@chromium.org> <20230113204548.578798-6-swboyd@chromium.org>
 <Y85l4aQmEW0iOHHa@hovoldconsulting.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Thu, 2 Feb 2023 13:49:46 -0800
Message-ID: <CAE-0n52ky-ugoOe4yWZNNsma=HSp1MbTT+A=Bu9+R_=jBeTNoA@mail.gmail.com>
Subject: Re: [PATCH 5.15.y v2 5/5] phy: qcom-qmp-combo: fix runtime suspend
To: Johan Hovold <johan@kernel.org>
Cc: stable@vger.kernel.org, Johan Hovold <johan+linaro@kernel.org>, 
	linux-kernel@vger.kernel.org, patches@lists.linux.dev, 
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, Vinod Koul <vkoul@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Johan Hovold (2023-01-23 02:48:01)
> On Fri, Jan 13, 2023 at 12:45:48PM -0800, Stephen Boyd wrote:
> > diff --git a/drivers/phy/qualcomm/phy-qcom-qmp.c b/drivers/phy/qualcomm/phy-qcom-qmp.c
> > index b8646eaf1767..64a42e28e99f 100644
> > --- a/drivers/phy/qualcomm/phy-qcom-qmp.c
> > +++ b/drivers/phy/qualcomm/phy-qcom-qmp.c
> > @@ -4985,15 +4985,11 @@ static void qcom_qmp_phy_disable_autonomous_mode(struct qmp_phy *qphy)
> >  static int __maybe_unused qcom_qmp_phy_runtime_suspend(struct device *dev)
> >  {
> >       struct qcom_qmp *qmp = dev_get_drvdata(dev);
> > -     struct qmp_phy *qphy = qmp->phys[0];
> > +     struct qmp_phy *qphy = qmp->usb_phy;
> >       const struct qmp_phy_cfg *cfg = qphy->cfg;
> >
> >       dev_vdbg(dev, "Suspending QMP phy, mode:%d\n", qphy->mode);
> >
> > -     /* Supported only for USB3 PHY and luckily USB3 is the first phy */
> > -     if (cfg->type != PHY_TYPE_USB3)
> > -             return 0;
>
> This is still not correct as this code would now be executed also for
> PCIe and UFS PHYs, which wasn't the case before.

Ah right. So weirdly, the conditional should be kept.
