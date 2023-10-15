Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 993DAC8EA
	for <patches@lists.linux.dev>; Sun, 15 Oct 2023 17:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JLGpzlXS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 781ABC433C7;
	Sun, 15 Oct 2023 17:48:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697392120;
	bh=e7pYUIwoY9i67vYNaeVnPKr11BmBB0CqKXeTA68t9zU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=JLGpzlXS72JBStrwk+tH5fqYDTq1MX28BXyPbWtXmfCo0PqCFaKfNQ0ZGUFzs3ecs
	 STco/qdrEoo3uNU7Wy9BfjhgoA8CFr2HxUAZu9up9Ng8fDFuPPxVMhuCnSjoVGDhce
	 WRV0uhSDHtwGRgbwszsGZvWdH0FVzpW/FekrDqm8=
Date: Sun, 15 Oct 2023 19:48:37 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Zheng Wang <zyytlz.wz@163.com>
Cc: stable@vger.kernel.org, hackerzheng666@gmail.com, sashal@kernel.org,
	patches@lists.linux.dev, amergnat@baylibre.com, wenst@chromium.org,
	angelogioacchino.delregno@collabora.com, hverkuil-cisco@xs4all.nl
Subject: Re: [PATCH] media: mtk-jpeg: Fix use after free bug due to
 uncanceled  work
Message-ID: <2023101528-scuba-walmart-fe3f@gregkh>
References: <20231015144747.729031-1-zyytlz.wz@163.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231015144747.729031-1-zyytlz.wz@163.com>

On Sun, Oct 15, 2023 at 10:47:47PM +0800, Zheng Wang wrote:
> This is a security bug that has been reported to google.
> It affected all platforms on chrome-os. Please apply this
> patch to 5.10.

Both now queued up, thanks.

greg k-h
