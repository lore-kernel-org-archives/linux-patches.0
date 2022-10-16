Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8A7E800
	for <patches@lists.linux.dev>; Sun, 16 Oct 2022 10:49:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461A4C433D6;
	Sun, 16 Oct 2022 10:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1665917371;
	bh=H7gM9TLHxVIJ3T3+SR0Qi2B1qrGZ+otdQuICAByme8w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=W9hOjA8ouIWA0LdJ0j9N2JSDicjNq4OoixwmVyLP1raxzDI/pVh3eI5Z0ch9uz1iM
	 19jVE5VWhUKs9W+2zepmwpdM9i28+AD6D+iaFK9JUqERVaxKU6qfzSlIGoIVBc09t9
	 QGc0VtvESqSLL9K1K1Tl2IDkgkU11GjGSLtg1S3g=
Date: Sun, 16 Oct 2022 12:50:17 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: stable@vger.kernel.org, Sibi Sankar <sibis@codeaurora.org>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	Alex Elder <elder@linaro.org>, Evan Green <evgreen@chromium.org>,
	Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH 5.10] arm64: dts: qcom: sc7180-trogdor: Fixup modem
 memory region
Message-ID: <Y0vh6Q0U99bnUCbc@kroah.com>
References: <20221014215302.3905135-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014215302.3905135-1-swboyd@chromium.org>

On Fri, Oct 14, 2022 at 02:53:02PM -0700, Stephen Boyd wrote:
> From: Sibi Sankar <sibis@codeaurora.org>
> 
> commit ef9a5d188d663753e73a3c8e8910ceab8e9305c4 upstream.
> 
> The modem firmware memory requirements vary between 32M/140M on
> no-lte/lte skus respectively, so fixup the modem memory region
> to reflect the requirements.
> 
> Reviewed-by: Evan Green <evgreen@chromium.org>
> Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
> Link: https://lore.kernel.org/r/1602786476-27833-1-git-send-email-sibis@codeaurora.org
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
> 
> This fixes boot of the modem on trogdor boards with the DTS from 5.10.y
> stable tree. Without this patch I run into memory assignment errors and
> then the modem fails to boot.

You forgot to sign off on this patch you forwarded on for stable
inclusion :(

Please fix up and resend if you wish to see it applied.

thanks,

greg k-h
