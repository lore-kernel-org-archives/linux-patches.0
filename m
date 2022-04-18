Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B05F664C;
	Mon, 18 Apr 2022 03:23:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AF0C385A4;
	Mon, 18 Apr 2022 03:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1650252211;
	bh=FdV0BbbkJT2rE9g8AmJful8pYq6qPpf0N6gWli0rXVw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=keo2VlSV0vn+iBnJt2gOGe+pMclPf4TSrg0jKCdF4yjOZ/7ZHLghlzfHMOJ1P9JqB
	 MqJyGq+RUhTrOWiHBLSrscGeorGKl0Ohif9PqOHXK7ZPXti5LLy127EaivWehuWKag
	 E3Fw2td/Bx78EkjMXBoWFafxjefJ8pfhDv5qiFf4730h9BXq8Uhf1dFn1l+nDSf5M9
	 IZ5KrwnfYSOvJvZ0ebJnQavcxVK74Gz4Go3dFbIlPgEUcIe53k+E8nwceaxzlmXA67
	 UY+vNovVnbcLWc4yWJKzN8+7fJM2Ly1jUD/lq6L1vwce1dG8SM9ILksZz4gxXRkIgx
	 fXH5/1RykWigw==
Date: Mon, 18 Apr 2022 11:23:27 +0800
From: Tzung-Bi Shih <tzungbi@kernel.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Benson Leung <bleung@chromium.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Lee Jones <lee.jones@linaro.org>,
	Daisuke Nojiri <dnojiri@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	chrome-platform@lists.linux.dev
Subject: Re: [PATCH 1/3] platform/chrome: cros_ec_proto: Add peripheral
 charger count API
Message-ID: <YlzZr/UElg690/ru@google.com>
References: <20220415003253.1973106-1-swboyd@chromium.org>
 <20220415003253.1973106-2-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415003253.1973106-2-swboyd@chromium.org>

On Thu, Apr 14, 2022 at 05:32:51PM -0700, Stephen Boyd wrote:
> Add a peripheral charger count API similar to the one implemented in the
> ChromeOS PCHG driver so we can use it to decide whether or not to
> register the PCHG device in the cros_ec MFD driver.
> 
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Daisuke Nojiri <dnojiri@chromium.org>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: <chrome-platform@lists.linux.dev>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>

With a minor comment about the naming,
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>

> diff --git a/include/linux/platform_data/cros_ec_proto.h b/include/linux/platform_data/cros_ec_proto.h
> index df3c78c92ca2..8f5781bc2d7a 100644
> --- a/include/linux/platform_data/cros_ec_proto.h
> +++ b/include/linux/platform_data/cros_ec_proto.h
> @@ -230,6 +230,7 @@ u32 cros_ec_get_host_event(struct cros_ec_device *ec_dev);
>  bool cros_ec_check_features(struct cros_ec_dev *ec, int feature);
>  
>  int cros_ec_get_sensor_count(struct cros_ec_dev *ec);
> +unsigned int cros_ec_pchg_port_count(struct cros_ec_dev *ec);

I wonder if "cros_ec_get_pchg_port_count" would be a better name for the API.
