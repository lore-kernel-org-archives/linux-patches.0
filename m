Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2EA117C6
	for <patches@lists.linux.dev>; Tue,  7 Jun 2022 09:56:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B2CBC34115;
	Tue,  7 Jun 2022 09:56:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1654595791;
	bh=6spgyTbpIii4gmYFhWPeNPPcXX7gAjBVMayOdvFKAN4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gp7ykAPcCpfdf7Z8jBK5QW+wQQmC4l7nqKVgRzepadB/UkhwdPcwwgWINrCoRRVgD
	 T8qUzZQzQJFdtRxGOmEIhsU1MkDenbVEGnMS1GXxzVJ+KJyZrema/ZrXBgpM7feP/s
	 A+X+ZJbWE8WFS1GHtopU4qa/OMnCTT4Hynk8pWyA=
Date: Tue, 7 Jun 2022 11:56:25 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Alex Elder <elder@linaro.org>,
	Georgi Djakov <djakov@kernel.org>
Subject: Re: [PATCH 5.15 0/2] Fix suspend on qcom sc7180 SoCs
Message-ID: <Yp8gycx3v2S6drG4@kroah.com>
References: <20220606235155.2437168-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220606235155.2437168-1-swboyd@chromium.org>

On Mon, Jun 06, 2022 at 04:51:53PM -0700, Stephen Boyd wrote:
> These two patches fix suspend on sc7180 boards, i.e. Trogdor, on 5.15
> stable kernels. Without these two patches the IP0 interconnect is kept
> on forever, and suspend fails because XO shutdown can't be achieved.
> 
> Mike Tipton (1):
>   interconnect: qcom: icc-rpmh: Add BCMs to commit list in pre_aggregate
> 
> Stephen Boyd (1):
>   interconnect: qcom: sc7180: Drop IP0 interconnects
> 
>  drivers/interconnect/qcom/icc-rpmh.c | 10 +++++-----
>  drivers/interconnect/qcom/sc7180.c   | 21 ---------------------
>  drivers/interconnect/qcom/sm8150.c   |  1 -
>  drivers/interconnect/qcom/sm8250.c   |  1 -
>  drivers/interconnect/qcom/sm8350.c   |  1 -
>  5 files changed, 5 insertions(+), 29 deletions(-)
> 
> -- 
> https://chromeos.dev
>

Both now queued up, thanks.

greg k-h
