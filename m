Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795318774;
	b=mSEdStDjDNJcYFZrxm7jXU1vyYQdTqm0gJqzAeERd6ElqqZer4BSsN5HE4QM8JEY7SkP
	 76bwQm+wKuhN/JZv3fCpvaTTtb+uvAt+uATkiyzoO0uYTAdjmV+VKFvN9VlBT4oLbTjXu
	 7QWnM53h8XkGYNm/mP+L9mcg9r5g7dgdePopxMGUClUw2auK7kHJf05SFPVPT52Hnz3n6
	 JuKRCQQeLpy8V/jdcOtOOwA7J0TxYbNGGI4QMf1mTAlAl5ueD0qkizq3QQpTlUSHNSqTl
	 gWEF4WvGCM4hglLN/hu13F2D5LI/81ew4LCpVjXUyaFkECzSY5T7KHsv4gB7uCKTmUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795318774;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=occo9dmY9azL7oPYwH1MqRhtp5Aj4CF/oE6zq/Au7GE=;
	b=THx/CQKr0bIBoGLFb6w8Z5BkWFgM2fgMlM18M2+kooY45NXi+EytGDuXwq1MNgdgEE6i
	 7lCt0K29i4yS51TDIHnTb1te8eetx2CQjcFIVoZ4AZxporwgOGwvf1YrN0Bq3x2E4MiyD
	 P0UhiQF5CnlabUXHolNHukYBEZQqGyoUtzvJXr+D9siPwL9RoIQY81ZONrOYbzaE1Gvzv
	 6ggtp1FMoOKp7+x1teTktcROup4ibdWK5HJnszFzpoDQTogUwjWsJfAHt/qzxaZU9MzfA
	 tpG60DDxwX9Fx+fp2eghxBRU8kVox0BkZyKaTyHZbYXruis+vEj3e7W20nCO8Wyzfcg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q5BPggL8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC57606A32A;
	Sun, 22 Nov 2026 03:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Q5BPggL8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D8D1F000CA;
	Sun, 22 Nov 2026 03:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795318773;
	bh=occo9dmY9azL7oPYwH1MqRhtp5Aj4CF/oE6zq/Au7GE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q5BPggL8KC2Ur5S19ZHL0hk/V3udBJy/5sIVB40zVot73ammCPTFQdQuURuXOHWNR
	 Puvp49gX09JcLNwj9NjztC3c5E60I884p/7h4yfmYw+rUow0At/qXqWL1vWJWGF0EN
	 PJ5dU3/hTPet0GOfUzzQX6MoOtjijcCyjrIEtay9QiOgoXWaX0biArsuPBqTn2VjTp
	 pM6u6AzcywagZ0JzTJ5ZsOEQMSisctH6JgeUNcBfLUMxGZs5IZGXhvEVC+dvBTkYwJ
	 c8krQvk8qKf10aKYc+/sFVu6qcmbDQtMEZ2BzFyYVd0DtJty8xrbxf3eTsX8USprzP
	 X6z5HtUEZy4gg==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	torvalds@linux-foundation.org,
	akpm@linux-foundation.org,
	linux@roeck-us.net,
	shuah@kernel.org,
	patches@kernelci.org,
	lkft-triage@lists.linaro.org,
	pavel@nabladev.com,
	jonathanh@nvidia.com,
	f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com,
	rwarsow@gmx.de,
	conor@kernel.org,
	hargar@microsoft.com,
	broonie@kernel.org,
	achill@achill.org,
	sr@sladewatkins.com,
	James Morris <jmorris@namei.org>
Subject: Re: [PATCH 7.3 0000/2642] 7.3.6-rc2 review
Date: Sat, 21 Nov 2026 22:38:59 -0500
Message-ID: <2026-11-21-2-daily-reply-0016@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <5154b570-ea6e-ef21-f0e9-cc54fc6bfc25@namei.org>
References: <5154b570-ea6e-ef21-f0e9-cc54fc6bfc25@namei.org>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> It does not have the three that add the new compatibles:
>
>   73329198cdc2 ("dt-bindings: timer: thead,c900-aclint-mtimer: Add
> SpacemiT K3")
>   c9bae665035f ("dt-bindings: interrupt-controller:
> thead,c900-aclint-mswi: Add SpacemiT K3")
>   08257b5b3d38 ("dt-bindings: interrupt-controller:
> thead,c900-aclint-sswi: Add SpacemiT K3")

Queued the three for 7.3, together with b424b3b0ab92 ("irqchip/aclint-sswi:
Add support for SpacemiT K3"), thanks.

-- 
Thanks,
Sasha
