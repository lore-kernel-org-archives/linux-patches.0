Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F076341BE
	for <patches@lists.linux.dev>; Thu, 12 Oct 2023 17:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fpr27ayv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30565C433C7;
	Thu, 12 Oct 2023 17:23:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697131436;
	bh=sq90ahtQY7ZosJXu0/rtvnLkfTJqb1yIGEkTVyFwWRU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fpr27ayveMho3YQD+UNn2S9rexf+J686OA1/s/sLKemlXwnR8wvE4KuxAE8XqlK1Y
	 ifVFhcx2/P2YqJidqqVCJXTgZ5khTjBIJx18OxuKnOMuY7uAMSkauUC/lLBuPPtAR9
	 rgwjMesBaxg7lTsPYQbSyI3jy2YV2rPNCWXDhI2Y=
Date: Thu, 12 Oct 2023 19:23:53 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Zheng Wang <zyytlz.wz@163.com>
Cc: stable@vger.kernel.org, hackerzheng666@gmail.com, sashal@kernel.org,
	patches@lists.linux.dev, amergnat@baylibre.com, wenst@chromium.org,
	angelogioacchino.delregno@collabora.com, hverkuil-cisco@xs4all.nl
Subject: Re: [RESEND PATCH v2] media: mtk-jpeg: Fix use after free bug due to
 uncanceled work
Message-ID: <2023101214-trilogy-wildcard-29cb@gregkh>
References: <20231011073204.1069793-1-zyytlz.wz@163.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011073204.1069793-1-zyytlz.wz@163.com>

On Wed, Oct 11, 2023 at 03:32:04PM +0800, Zheng Wang wrote:
> This is a security bug that has been reported to google.
> It affected all platforms on chrome-os. Please apply this
> patch to 4.14 4.19 5.4 5.10 and 5.15.
> 
> [ Upstream commit c677d7ae83141d390d1253abebafa49c962afb52 ]

Did you try to apply this?  The file:

>  drivers/media/platform/mediatek/jpeg/mtk_jpeg_core.c | 1 +

Is not in the kernels you asked for this patch to be applied to.

How did you test this?

confused,

greg k-h
