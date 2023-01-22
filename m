Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87072115
	for <patches@lists.linux.dev>; Sun, 22 Jan 2023 14:23:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 368C6C433D2;
	Sun, 22 Jan 2023 14:23:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1674397407;
	bh=Qf25wTJ+EJ8usb7D3ZpuO5rbutf7nRD4cjHfe+7+Wlg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GQwY7PYqSXJvr1pCF6M08rLLbmfXo0bEtSWwMbvwOPl3ju09/k5w86otIfbqQtCOB
	 Hvv/i1ZhC8++tm9m4YZWKH9dfp1OJQ+nS+HcHWyWgN4ZoVJcBFF5+6V4CoLr27C8Iw
	 7rY34sBRFJSkHoeiKfYGjWezZ57PZVrXQznxbXmY=
Date: Sun, 22 Jan 2023 15:23:25 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Johan Hovold <johan+linaro@kernel.org>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Vinod Koul <vkoul@kernel.org>
Subject: Re: [PATCH 5.15.y v2 0/5] phy: qcom-qmp-combo: Backport some stable
 fixes
Message-ID: <Y81G3X7TSNk57hqc@kroah.com>
References: <20230113204548.578798-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230113204548.578798-1-swboyd@chromium.org>

On Fri, Jan 13, 2023 at 12:45:43PM -0800, Stephen Boyd wrote:
> After the qmp phy driver was split it looks like 5.15.y stable kernels
> aren't getting fixes like commit 7a7d86d14d07 ("phy: qcom-qmp-combo: fix
> broken power on") which is tagged for stable 5.10. Trogdor boards use
> the qmp phy on 5.15.y kernels, so I backported the fixes I could find
> that looked like we may possibly trip over at some point.
> 
> USB and DP work on my Trogdor.Lazor board with this set.
> 
> Changes from v1 (https://lore.kernel.org/r/20230113005405.3992011-1-swboyd@chromium.org):
>  * New patch for memleak on probe deferal to avoid compat issues
>  * Update "fix broken power on" patch for pcie/ufs phy
> 
> Johan Hovold (5):
>   phy: qcom-qmp-combo: disable runtime PM on unbind
>   phy: qcom-qmp-combo: fix memleak on probe deferral
>   phy: qcom-qmp-usb: fix memleak on probe deferral
>   phy: qcom-qmp-combo: fix broken power on
>   phy: qcom-qmp-combo: fix runtime suspend
> 
>  drivers/phy/qualcomm/phy-qcom-qmp.c | 97 ++++++++++++++++++-----------
>  1 file changed, 61 insertions(+), 36 deletions(-)
> 
> Cc: Johan Hovold <johan+linaro@kernel.org>
> Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Cc: Vinod Koul <vkoul@kernel.org>
> 
> base-commit: d57287729e229188e7d07ef0117fe927664e08cb
> -- 
> https://chromeos.dev
> 

For obvious reasons, I can't take this series if newer kernel releases
do not also contain all of these (no would you want me to.)

So can you please also provide a backported series for 6.1.y so that
these can be considered?

thanks,

greg k-h
