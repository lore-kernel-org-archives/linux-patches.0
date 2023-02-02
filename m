Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6912D8F7D
	for <patches@lists.linux.dev>; Thu,  2 Feb 2023 22:27:09 +0000 (UTC)
Received: by mail-lf1-f49.google.com with SMTP id h24so5172221lfv.6
        for <patches@lists.linux.dev>; Thu, 02 Feb 2023 14:27:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rNl1d9WjdzfG8r6+o/TTbbJlOXijTqxl4wlecMFWfHc=;
        b=W86IfmDtu2J4p+3OYOZAQ2kPhD4TOuckQrtBxpeHkGS4TFNPokFEKLLjCxRVjJzpnT
         /tMtxDN6d3ao0Yr4ZUPI8JgXfGBBZR0Zrlcu3uRRYTTwu2dDMHLktXbmieOoq62CMAMz
         8Rb5vGERLKakT/KMKZHBcOQs8aXITcg3SPmhI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:user-agent:from:references
         :in-reply-to:mime-version:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rNl1d9WjdzfG8r6+o/TTbbJlOXijTqxl4wlecMFWfHc=;
        b=3PvxpFr8TKw/hSND1G+aSdeB6g7ZnEfPdVi8WN1bpyGCjGKpMyWEXfvWArNe0vHt1h
         AWS8D/eFEuPKz0ZJovjl5etOCXmDmIM5YLJViP6+Vf3IRjbunZP97zzDldL7yrzrXS9m
         GniqeRuZSYhdO0QqFkX6M1CYSmUA+bC3iIerEUWPZCPVKMVl4Mg4rtu9rzog/adHLNT/
         ROPmtx9QzBBw0s/tqRg00RoOn/xicLERL1dlXoidTyryL07ykO28P744boSeyWajWDok
         itLqKxmTbpEtkqV7ZGQd7caqG92tA00sci3LlNd6uwPeLpbT+xlhxddgPogQHjDwMXkD
         nxgQ==
X-Gm-Message-State: AO0yUKXhTadGyPrb6TxzWrx5FQpzE7z9dovHmpoCnjHaJOB2X/cuXhSN
	jgSWDRtK08y2Zj1wg3n4UICFX8mW6NImRVoZalY9Dw==
X-Google-Smtp-Source: AK7set8BLWiiUSmP1ZnKxPXJ1C4jOaYXgC8mhhJgjy8MjW3z0hLNlQVz0f5qVXMSJuwF1hP61XhwjGdZrkB7RksH74E=
X-Received: by 2002:ac2:5a19:0:b0:4d8:775b:a58f with SMTP id
 q25-20020ac25a19000000b004d8775ba58fmr1607468lfn.73.1675376827426; Thu, 02
 Feb 2023 14:27:07 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 2 Feb 2023 14:27:06 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <Y81G3X7TSNk57hqc@kroah.com>
References: <20230113204548.578798-1-swboyd@chromium.org> <Y81G3X7TSNk57hqc@kroah.com>
From: Stephen Boyd <swboyd@chromium.org>
User-Agent: alot/0.10
Date: Thu, 2 Feb 2023 14:27:06 -0800
Message-ID: <CAE-0n52WYuDhozGijwJoMOL9PLRQshLCMAJsWvudz4KdS+jN=Q@mail.gmail.com>
Subject: Re: [PATCH 5.15.y v2 0/5] phy: qcom-qmp-combo: Backport some stable fixes
To: Greg KH <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org, 
	patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>, 
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>, Vinod Koul <vkoul@kernel.org>
Content-Type: text/plain; charset="UTF-8"

Quoting Greg KH (2023-01-22 06:23:25)
> On Fri, Jan 13, 2023 at 12:45:43PM -0800, Stephen Boyd wrote:
> > After the qmp phy driver was split it looks like 5.15.y stable kernels
> > aren't getting fixes like commit 7a7d86d14d07 ("phy: qcom-qmp-combo: fix
> > broken power on") which is tagged for stable 5.10. Trogdor boards use
> > the qmp phy on 5.15.y kernels, so I backported the fixes I could find
> > that looked like we may possibly trip over at some point.
> >
> > USB and DP work on my Trogdor.Lazor board with this set.
> >
> > Changes from v1 (https://lore.kernel.org/r/20230113005405.3992011-1-swboyd@chromium.org):
> >  * New patch for memleak on probe deferal to avoid compat issues
> >  * Update "fix broken power on" patch for pcie/ufs phy
> >
> > Johan Hovold (5):
> >   phy: qcom-qmp-combo: disable runtime PM on unbind
> >   phy: qcom-qmp-combo: fix memleak on probe deferral
> >   phy: qcom-qmp-usb: fix memleak on probe deferral
> >   phy: qcom-qmp-combo: fix broken power on
> >   phy: qcom-qmp-combo: fix runtime suspend
> >
> >  drivers/phy/qualcomm/phy-qcom-qmp.c | 97 ++++++++++++++++++-----------
> >  1 file changed, 61 insertions(+), 36 deletions(-)
> >
> > Cc: Johan Hovold <johan+linaro@kernel.org>
> > Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> > Cc: Vinod Koul <vkoul@kernel.org>
> >
> > base-commit: d57287729e229188e7d07ef0117fe927664e08cb
> > --
> > https://chromeos.dev
> >
>
> For obvious reasons, I can't take this series if newer kernel releases
> do not also contain all of these (no would you want me to.)
>
> So can you please also provide a backported series for 6.1.y so that
> these can be considered?

Sure. All of the patches have been applied to 6.1.y except for the last
one, which picks cleanly, c7b98de745cf ("phy: qcom-qmp-combo: fix
runtime suspend"). I can send that over.
