Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C65D22B8A7;
	Wed, 16 Apr 2025 06:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744785886; cv=none; b=TjyuOFLPgwrOoPOnrxA5Q2MfG1usO3kQrpeqP2DHf+5F1CROU38x3GgiPbTdmj2UQOucIQlm4fQ2NNWg+myAkgI4GMrRkc6EDdpdHmUwpDynNl+/m7O/aIGI7Wp3gzOdS7y0Cz2763YvHSQccNc+dbO7lt8U50D2QkJOsL01JFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744785886; c=relaxed/simple;
	bh=2QgoyFyBkjBvqoD5Ifrm8aom6MPxlvdHD2O2OdNVf5A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZBmEOzQyHCYp/CfwWSANkLhLhsHCeKs5a6CWwPmx6xABcpAcfTtIeDrqEua4fybUpuMpAE14I5x1e+IRaapd7ynYCcfhf/f0uYthIWAepzYQuxojnrc0N56setvW+Xo9DhUuBXI4wWTwHYtjpxdKfSAEoEQ306BOL6fonCpoEas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c7ZNcOTp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c7ZNcOTp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F385C4CEEC;
	Wed, 16 Apr 2025 06:44:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1744785885;
	bh=2QgoyFyBkjBvqoD5Ifrm8aom6MPxlvdHD2O2OdNVf5A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=c7ZNcOTp7R3go8mn78KMrvaVogeKux4vLdyiw4L3sxQoHnh3yifq/CzI4fZbJQVpX
	 9qrg/WnDlg4P5mpnwqHPpspe7AaFwKFVWN1GPII0dlpK1pJisKrVdvvlvqbmS47Xv1
	 HU8huy1m4HhrujT21i2CtK9UjL7NTM2Jgjss82UsaBMxvm0ikJa6JvKnhz0jusJoPL
	 8WgQ1JTslXWgexdZ+WuSGt87uZlNMnwUOyVY5m8HCnZ24DnXhM3/+u6tPx0cSxc2Th
	 bQYy1K1z9bIxpIGxJbX4cnj4MDTaySwuSe75cT2wGmvESNBzEP4hcE+fFOIiiv8Nw4
	 SIKyYE4PZfJmg==
Date: Wed, 16 Apr 2025 07:44:38 +0100
From: Lee Jones <lee@kernel.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: Tzung-Bi Shih <tzungbi@kernel.org>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Bjorn Andersson <andersson@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>, devicetree@vger.kernel.org,
	Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	Rob Herring <robh@kernel.org>, linux-arm-msm@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	Conor Dooley <conor+dt@kernel.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
	Benson Leung <bleung@chromium.org>,
	Guenter Roeck <groeck@chromium.org>,
	chrome-platform@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	Abhishek Pandit-Subedi <abhishekpandit@chromium.org>,
	=?utf-8?Q?=C5=81ukasz?= Bartosik <ukaszb@chromium.org>,
	Jameson Thies <jthies@google.com>,
	Andrei Kuchynski <akuchynski@chromium.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: Re: [PATCH 4/7] dt-bindings: Move google,cros-ec-typec binding to usb
Message-ID: <20250416064438.GE372032@google.com>
References: <20250416000208.3568635-1-swboyd@chromium.org>
 <20250416000208.3568635-5-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250416000208.3568635-5-swboyd@chromium.org>

On Tue, 15 Apr 2025, Stephen Boyd wrote:

> This binding is about USB type-c control. Move the binding to the usb
> directory as it's a better home than chrome.
> 
> Reviewed-by: Rob Herring (Arm) <robh@kernel.org>
> Cc: Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
> Cc: Conor Dooley <conor+dt@kernel.org>
> Cc: Lee Jones <lee@kernel.org>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: Guenter Roeck <groeck@chromium.org>
> Cc: Tzung-Bi Shih <tzungbi@kernel.org>
> Cc: <devicetree@vger.kernel.org>
> Cc: <chrome-platform@lists.linux.dev>
> Cc: Pin-yen Lin <treapking@chromium.org>
> Cc: Abhishek Pandit-Subedi <abhishekpandit@chromium.org>
> Cc: Łukasz Bartosik <ukaszb@chromium.org>
> Cc: Jameson Thies <jthies@google.com>
> Cc: Andrei Kuchynski <akuchynski@chromium.org>
> Suggested-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  .../devicetree/bindings/mfd/google,cros-ec.yaml      |  2 +-

Acked-by: Lee Jones <lee@kernel.org>

>  .../{chrome => usb}/google,cros-ec-typec.yaml        | 12 ++++++------
>  2 files changed, 7 insertions(+), 7 deletions(-)
>  rename Documentation/devicetree/bindings/{chrome => usb}/google,cros-ec-typec.yaml (72%)

-- 
Lee Jones [李琼斯]
