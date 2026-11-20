Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795140552;
	b=P/W+MIAuw0bnGo0f9mTpTCStQ/wZIPxKsouQY9KESC+VIxZWJEa1ARQK8RWFH+Neb77M
	 hCY22gUPb+QEuLk3D6wN9IKPavJC8MYAbS3epxiHJzpKBk0+Ms6DfePrz0NfC3HNcosu/
	 fEAvVFeIsHV8NBTKAAvHmwOxo/LtDwguPCLzwrxqHulDs+O2shAz4Sd23wiaaiSVVOU20
	 d1zpoa8QuL9QypIFHDYUO/77yVW6ZM8dbTjjs6ucpolnMTHFSNVBRluk6K+aFB3nibhNL
	 Ea6uvvE/8gb65SCL3x9xTgG84+1oocEBoyzsUFvVjGfAHmdDiawWIrUXAIGz7XBjZgQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795140552;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=7KSTUTWKR6z0mtuzR0Dqh7groM7u3B48btiIzfsMnh8=;
	b=HWYlBXUIwvz8sU43EVPZ+RrPoAynZUhA0QHoBAm6AbP01zhWR533PrfGko+72cqx9Pcl
	 BFfOs1QKHDP3wDkayo7k5JfrntTstZrp/bCljbx6N4f3JpCsxDL9aYyQmlb9bP0X3Eu8Z
	 p/MzIbja738YlaRTq1e37dGcsDPFDGZG9vfjrsJ+XkAWrwx4uRL776Fy5zD6ZmTorBOL1
	 YYVNtrvW6bTeMlc+wepPX3rj/vvYKnC6b2hBxRXa1A+7hxMGVv63kZ7UAJ1c5gVI6PXfT
	 VDXOnu8Mmz49DspMt2XGZxvyMgHtd0MQ72aVMy6qHtTpwKntK1fnR6OAf605dB3Apjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FmLJ24yR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F567606A333;
	Fri, 20 Nov 2026 02:09:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FmLJ24yR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADC031F000C4;
	Fri, 20 Nov 2026 02:09:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795140551;
	bh=7KSTUTWKR6z0mtuzR0Dqh7groM7u3B48btiIzfsMnh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FmLJ24yRe9cIS3tJNHtwR+ONQj8n0jfxy1dw+TCg/eDImgI0nuWwHlLzAbtxNB38c
	 PZoABC3cSgAbyPwKINF6ndYgy/F0awpNAmqr/0lbLYJ9/sFOuZhxB181/VKqDKoIrG
	 Fbmq/rMbxPotoEk4dDQuSRGfTo1hDnF8sjNoaWcOJh+t5lzniU9t+3RKmfdrkj9Wu3
	 5j5qgXDeXjHehp/rH8DtQhsc16gGNu8CiYXXPRkYQ5DFcHy7OVaBJyLNL0fYwW4zMG
	 gfGp2pd4JPM3rhH+pmPfI3ZgdDSQWvxBzzUp4qN+iFfbV7V7i7xPDpcj86ybVm6Cro
	 fgULqVk/8GBLw==
From: Sasha Levin <sashal@kernel.org>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Aristo Chen <aristo.chen@canonical.com>,
	Vinod Koul <vkoul@kernel.org>,
	Dominique Martinet <asmadeus@codewreck.org>
Subject: Re: [PATCH 7.3 1238/2651] phy: freescale: fsl-samsung-hdmi: initialize default rate
Date: Thu, 19 Nov 2026 21:08:58 -0500
Message-ID: <20261120020908.2320910-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261118223142.GA597634@francesco-nb>
References: <20261118150247.972732815@linuxfoundation.org> <20261118150332.571312313@linuxfoundation.org> <20261118223142.GA597634@francesco-nb>
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

On Wed, Nov 18, 2026 at 11:31:42PM +0100, Francesco Dolcini wrote:
> This patch introduces regression in any RC release, 6.12, 6.18 and 7.3,
> please drop it.

Dropped c01ccf91b257 ("phy: freescale: fsl-samsung-hdmi: initialize
default rate") from the 7.3, 6.18 and 6.12 queues. On 6.12 the five
patches that were queued only as its dependencies are dropped with it:

  - 4a5a9e2577d6 ("phy: freescale: fsl-samsung-hdmi: Replace register
    defines with macro")
  - 375ee44adb36 ("phy: freescale: fsl-samsung-hdmi: Simplify
    REG21_PMS_S_MASK lookup")
  - 1951dbb41d1d ("phy: freescale: fsl-samsung-hdmi: Support dynamic
    integer")
  - 279950205dde ("phy: freescale: fsl-samsung-hdmi: Use helper function
    devm_clk_get_enabled()")
  - 739214dd1c20 ("phy: freescale: fsl-samsung-hdmi: Fix 64-by-32
    division cocci warnings")

Dominique, the 6.12 NULL dereference you bisected is this same patch:
6.12 does not set cur_cfg before the clock is registered.

-- 
Thanks,
Sasha
