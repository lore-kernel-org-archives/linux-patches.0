Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF8F77C
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 10:35:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75F17C433D2;
	Mon, 23 Jan 2023 10:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1674470136;
	bh=cwgjiZMHeWlRTUJMa1Sto/LlD87GW58nOIMtlWblOws=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dVWOVXpxFMYdsKAMVDj2Nt7LFfqN1qd4uABeSArl2kw5YRXNKpzb3MMFZKplSPlqA
	 VpYQVrFyFWqjbj9JT6aTTmO4m+1e8zvJwlCZy0F6d0WaeTDxE7FERRHK5kB1ReeOcz
	 3hQe8Fya2d3/Tj4PuUR2rPC+iOFPigExWkQ366YAdmMZ4DZ8nH7KfNSaMXvMNB5Cvw
	 0w8GBhCPnDPInyOwh3k6zp5B/u6Fqx/cW/rZdM8J2Dq3EuNkCRmkQkO549xb8JOCwb
	 hG+7tqZrLG2vVFBparVGXPU19ICkwlz54vxJz5fjn62Fq6uFbC8+TsRgiY4JkTnuDC
	 MGff9eEy2Jk+g==
Received: from johan by xi.lan with local (Exim 4.94.2)
	(envelope-from <johan@kernel.org>)
	id 1pJuAn-0000oI-65; Mon, 23 Jan 2023 11:35:33 +0100
Date: Mon, 23 Jan 2023 11:35:33 +0100
From: Johan Hovold <johan@kernel.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Vinod Koul <vkoul@kernel.org>, Kishon Vijay Abraham I <kishon@ti.com>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev,
	linux-arm-msm@vger.kernel.org, linux-phy@lists.infradead.org,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>
Subject: Re: [PATCH] phy: qcom-qmp: Introduce Kconfig symbols for discrete
 drivers
Message-ID: <Y85i9aZm7F7poXda@hovoldconsulting.com>
References: <20230114000910.1256462-1-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230114000910.1256462-1-swboyd@chromium.org>

On Fri, Jan 13, 2023 at 04:09:10PM -0800, Stephen Boyd wrote:
> Introduce a config option for each QMP PHY driver now that the QMP PHY
> mega-driver has been split up into different modules. This allows kernel
> configurators to limit the binary size of the kernel by only compiling
> in the QMP PHY driver that they need, or to split the module up into one
> per PHY driver instead of one module for all the QMP PHY drivers.

Nit: The drivers are already built as separate modules even if they can
currently only be enabled together.

> Leave the old config QCOM_QMP in place and make it into a menuconfig so
> that 'make olddefconfig' continues to work. Furthermore, set the default
> of the new Kconfig symbols to be QCOM_QMP so that the transition is
> smooth.

Perhaps this should go eventually.
 
> Cc: Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
> Cc: Johan Hovold <johan+linaro@kernel.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>

Looks good otherwise:

Reviewed-by: Johan Hovold <johan+linaro@kernel.org>

Johan
