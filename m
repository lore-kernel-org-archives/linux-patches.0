Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A9D820AF8E;
	Wed, 26 Feb 2025 15:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740585245; cv=none; b=mmyOL9vFdmAE90jxSh/ywZVL8Wdqgxr2TZDWGLbULW1mXJH4HW2k+TijB/3C6SSHjDMFgxXbsWbewKcUHda8SDKAYci73n3IUsrOfKZax9/7Si8cigiPcGvEhxde4IN6tno3SjccBGDc76a8p6t/mOJr4Y+S8WaVR5sFVhoTpXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740585245; c=relaxed/simple;
	bh=IHPkSRz8POGRAPI3+TsZtf+aSugk/+coyipS7hZDYFU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jARmyNxrBMKlk2r2i8jFyHoMB/kW0x3Yfau+iuOhXrcJYuRckZMlPsmlIMToBX7LWJ+JDfuw61QtLuU7qelOcA40kyjjN+2msW5JNJpDnAd6Pwi43JCSAx9xFZyJGXHhuqW01H+JX4Dl4geXj1zFmJyWmhrqJhxmO20HrvfZNeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ebRrTCn0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ebRrTCn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D0CC4CED6;
	Wed, 26 Feb 2025 15:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1740585244;
	bh=IHPkSRz8POGRAPI3+TsZtf+aSugk/+coyipS7hZDYFU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ebRrTCn0FtzefQG7EREqZV+fhlEodGXj9wNSk+4qoYb6UP5dS/y/P1v0gQ54I/juH
	 zbvnuRNk8SaufOg5oUcragcZLJVgJaMahtSZT7gJn5vfkeFGrLhauR0Y1aHAiSE8In
	 BbZcumY7bidvd8HoKmA7/0fbzPUOHtjdw3GhQ3JiYNsQEuLCR9m9b60KkHhaVYzil7
	 kPgWEfJVI0vYEVLsfN+dAVflnpE5u5C0CFWEgdP5qaW2sg5ftTCG4LnzgXCZxjsJ7K
	 SqF5eeujjSSpT+IfMlJTmyw9IRBi0SU5wimHcZASFDIJWXeFWQSJ5OzHiCQeuXdf3J
	 8Y76xMSVlGm2w==
Date: Wed, 26 Feb 2025 09:54:02 -0600
From: "Rob Herring (Arm)" <robh@kernel.org>
To: Stephen Boyd <swboyd@chromium.org>
Cc: linux-arm-msm@vger.kernel.org, patches@lists.linux.dev,
	Benson Leung <bleung@chromium.org>, chrome-platform@lists.linux.dev,
	Bjorn Andersson <andersson@kernel.org>,
	Krzysztof Kozlowski <krzk+dt@kernel.org>,
	linux-kernel@vger.kernel.org, Pin-yen Lin <treapking@chromium.org>,
	Conor Dooley <conor+dt@kernel.org>,
	Konrad Dybcio <konradybcio@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v5 1/2] dt-bindings: usb: Add binding for ChromeOS Pogo
 pin keyboard connector
Message-ID: <174058524070.2499032.1136545857184253798.robh@kernel.org>
References: <20250225223038.879614-1-swboyd@chromium.org>
 <20250225223038.879614-2-swboyd@chromium.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250225223038.879614-2-swboyd@chromium.org>


On Tue, 25 Feb 2025 14:30:36 -0800, Stephen Boyd wrote:
> Describe the set of pins used to connect the detachable keyboard on
> detachable ChromeOS devices. The set of pins is called the "pogo pins".
> It's basically USB 2.0 with an extra pin for base detection. We expect
> to find a keyboard on the other side of this connector with a specific
> vid/pid, so describe that as a child device at the port of the usb
> device connected upstream.
> 
> Cc: Rob Herring <robh@kernel.org>
> Cc: Krzysztof Kozlowski <krzk+dt@kernel.org>
> Cc: Conor Dooley <conor+dt@kernel.org>
> Cc: Benson Leung <bleung@chromium.org>
> Cc: <devicetree@vger.kernel.org>
> Cc: <chrome-platform@lists.linux.dev>
> Cc: Pin-yen Lin <treapking@chromium.org>
> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> ---
>  .../usb/google,usb-pogo-keyboard.yaml         | 68 +++++++++++++++++++
>  1 file changed, 68 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/usb/google,usb-pogo-keyboard.yaml
> 

Reviewed-by: Rob Herring (Arm) <robh@kernel.org>

