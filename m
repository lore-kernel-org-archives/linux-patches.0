Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 691D664C;
	Mon, 18 Apr 2022 03:26:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC29DC385A4;
	Mon, 18 Apr 2022 03:26:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1650252391;
	bh=7VisAQYT0TzWPffMkMB/kVe4K1ubWTvxLSBrs0/+ROY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cXVkw523LDbp3mJYn6LWdh79yMXv1Zb2dhfUM1ardW33A+TTV8qLZA0v8nSnbZeNJ
	 watw1LKxYVaFX+WOaqc0R6TrMnmkwYCidhED+LD9UdiYdlNtC78575BVfU7CysxHOk
	 2ivmI9zXW7NqUzdut6hRWc3D6ob22zLieUEycZBEXAg+frxfpJNWYdJAacTuZYVSYB
	 I7/U1IneA79UU+ejBcrL60U3GOAL+WROqc0cj5ZKJIRJueCvW3StXS+MC4xt49ES2/
	 zGza6Ufzn5XewW+DzvcKBYo+aZJ00ze1Xsbg21KUS6QatDmq8qVoPtDwVglM8vgADA
	 6lEL2p5SXFoOQ==
Date: Mon, 18 Apr 2022 11:26:27 +0800
From: Tzung-Bi Shih <tzungbi@kernel.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Benson Leung <bleung@chromium.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Lee Jones <lee.jones@linaro.org>,
	Daisuke Nojiri <dnojiri@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	chrome-platform@lists.linux.dev
Subject: Re: [PATCH 3/3] power: supply: PCHG: Use cros_ec_pchg_port_count()
Message-ID: <YlzaYye4xOZDb11A@google.com>
References: <20220415003253.1973106-1-swboyd@chromium.org>
 <20220415003253.1973106-4-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220415003253.1973106-4-swboyd@chromium.org>

On Thu, Apr 14, 2022 at 05:32:53PM -0700, Stephen Boyd wrote:
> Use the common function cros_ec_pchg_port_count() now that we only
> register this device when there are a non-zero number of peripheral
> charger ports.
> 
> Cc: Lee Jones <lee.jones@linaro.org>
> Cc: Daisuke Nojiri <dnojiri@chromium.org>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: <chrome-platform@lists.linux.dev>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>

Share the same comment with the 1st patch in the series,
Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
