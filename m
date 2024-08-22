Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E0C31CBEA1;
	Thu, 22 Aug 2024 14:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724337281; cv=none; b=L+uyXdhGNwn5OBvnZVyEedjVtczrs7P08UaPaG1pH4RKHph8d8APogcO8TpsEF9HGjzpDMDdI6F0QYWHBStZsDEvYScVapUafmMkMqC9YM+s9i37plRI4EGx8wkem00g7rnbl8r83O0Eaok6T7Sk1SV0mJwIBOwvQeq54Yr7e9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724337281; c=relaxed/simple;
	bh=TijZddx52s7dHM9dVKH3FQOQGg37tHlZWJ7WwnRJDz0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kI3qkp1MF2/oaaX5sf91wbKT9uJ4XzaJG+IdapRE/Reik9T9b6o8/hagcEzDTPSWphDuHoGdnSeKvCYqVu77DpkgtF3bkkemfKrCZwB/wlzVwsZduauK0hv77VeC5ZUFiTvsuRC2Hwl7s69L86lao+RJ0ndEvMj8tv1LHP7ww8A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=o30hDNjI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="o30hDNjI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0B7DC32782;
	Thu, 22 Aug 2024 14:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724337280;
	bh=TijZddx52s7dHM9dVKH3FQOQGg37tHlZWJ7WwnRJDz0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=o30hDNjICLJUBuoyylRk4f1P6fyz268BRyUz/tzs8AmEo2LJqaUdpuwY1/DCTLSbd
	 NExh2Pk6Jj/7Fy54LtoOM3nnYAXw7TEM23JNcbw5jlbwDCeu5Alg4Uiw6Ej9cbN2Ge
	 qpw/+b4X2GNqjD5j7J+0C4cka8NlTnVQKV0VH7oyoZTTqeSDJ9GMaKdcBMbnCGz0oK
	 W4uplrEpYu6xavlLKTKEmzVAaZI8ZmJCz+EmMoBcVEr/EJ1qNVQKziaZzyoACjVglL
	 bpwXXn32E2lf1uZGdH6GNI1LnxnLk/3jwwgvDWTlduFv7KADBpKed2z8LxX6QD+/eP
	 TV0nHHTNpyJWA==
Date: Thu, 22 Aug 2024 22:34:31 +0800
From: Tzung-Bi Shih <tzungbi@kernel.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: chrome-platform@lists.linux.dev, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, devicetree@vger.kernel.org,
	Douglas Anderson <dianders@chromium.org>,
	Pin-yen Lin <treapking@chromium.org>,
	Andrzej Hajda <andrzej.hajda@intel.com>,
	Benson Leung <bleung@chromium.org>,
	Conor Dooley <conor+dt@kernel.org>, Daniel Vetter <daniel@ffwll.ch>,
	David Airlie <airlied@gmail.com>,
	Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
	dri-devel@lists.freedesktop.org,
	Guenter Roeck <groeck@chromium.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Jonas Karlman <jonas@kwiboo.se>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
	Lee Jones <lee@kernel.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Neil Armstrong <neil.armstrong@linaro.org>,
	Prashant Malani <pmalani@chromium.org>,
	Robert Foss <rfoss@kernel.org>, Rob Herring <robh+dt@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Daniel Scally <djrscally@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Ivan Orlov <ivan.orlov0322@gmail.com>, linux-acpi@vger.kernel.org,
	linux-usb@vger.kernel.org,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	"Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: Re: [PATCH v3 13/17] dt-bindings: Move google,cros-ec-typec binding
 to usb
Message-ID: <ZsdMd7Ywa2b-GDT6@tzungbi-laptop>
References: <20240819223834.2049862-1-swboyd@chromium.org>
 <20240819223834.2049862-14-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240819223834.2049862-14-swboyd@chromium.org>

On Mon, Aug 19, 2024 at 03:38:27PM -0700, Stephen Boyd wrote:
> -title: Google Chrome OS EC(Embedded Controller) Type C port driver.
> +title: Google Chrome OS Embedded Controller (EC) USB type-c port driver

Given that it gets chance to modify, how about s/Chrome OS/ChromeOS/?
