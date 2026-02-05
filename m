Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F34E70810
	for <patches@lists.linux.dev>; Thu,  5 Feb 2026 11:43:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770291827; cv=none; b=LCau7vTNqY9tqP5aaZcNQvwPMyUBaAePKX3kTGF4V6WZOt76COhanpdokrRMQsMymiz8WhCOBAt0VdepUGqK7XvXOsb3NsrKdCKg/pcMkWS2oOoHZAfdWRL7sQr173p/b/gQNhEin4Atl+/N6lp5b0Mh5KljI6jTm7iHGF3uMno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770291827; c=relaxed/simple;
	bh=vjEXTaSTawfH1ca3LhmSc8JEfQI/Je7hHvUf3p5l+5c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PWve4I8GIUW6PQ8Qit8f7UcCAxB7WiBoTbD+cF75+PjO92BRxpP92u2IUNCT/p4z6anA9fgB8Lppp42NYUww+ULvIQ33gcN2W7oG25NZ7MXgjg1o7MQBih3f6Wc4HILhSSXJSYsEiLLl9lpQGOR6uTB+h2uadZnJVP+YbEQ15Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=k7B4+b7g; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="k7B4+b7g"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1770291825;
	bh=vjEXTaSTawfH1ca3LhmSc8JEfQI/Je7hHvUf3p5l+5c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=k7B4+b7gCE10wBWECw7ovibE2MBwyVS9iT6BI4EpMMTm8WSCXWMUZVY3PT1oOrNct
	 gN37xSvFotB2ZJN6HlN5BuzNBTFQYJP9dfkRdeS7UD5jZh+uQh78TOUA3VzRq+2bIh
	 p8UDrUHiAgdRtPl3DnmkQ1xiwmiXg1vEH/YL8qtEhUMPoXY6eWNclZznM3RMwEbDRe
	 bc6R8bJG/qV3zO5SzJZtIUpuGZHo1UisTDbeU4Vu8f3vzYBOqtzuqCcejZGq4gXevK
	 +nWl4fDATiZ9KwkDhoBo6C4XpTAJmTjbXF/7ZvZlekKWAtKaVct3ipHiWEu4zoQhTm
	 g6eHXBsLaXJiQ==
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 7F81917E06C3;
	Thu,  5 Feb 2026 12:43:45 +0100 (CET)
Message-ID: <4171d9d6-1f2c-44d3-b908-3ca11ffa9d96@collabora.com>
Date: Thu, 5 Feb 2026 12:43:44 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "clk: Respect CLK_OPS_PARENT_ENABLE during recalc"
To: Stephen Boyd <sboyd@kernel.org>,
 Michael Turquette <mturquette@baylibre.com>
Cc: linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
 patches@lists.linux.dev, Alexander Stein <alexander.stein@ew.tq-group.com>,
 Mark Brown <broonie@kernel.org>,
 Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
 Brian Masney <bmasney@redhat.com>, Chen-Yu Tsai <wenst@chromium.org>
References: <20260203002439.1223213-1-sboyd@kernel.org>
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Content-Language: en-US
In-Reply-To: <20260203002439.1223213-1-sboyd@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Il 03/02/26 01:24, Stephen Boyd ha scritto:
> This reverts commit 669917676e93fca5ea3c66fc9539830312bec58e.
> It's been shown to cause problems on i.MX and STM32 platforms
> where the board doesn't boot. In one case, a clk with
> CLK_IS_CRITICAL and CLK_OPS_PARENT_ENABLE is being registered
> causing the parent to be enabled, the rate recalculated, and then
> the parent is disabled causing the critical clk being registered
> to stop clocking.
> 
> A fix for that would be to calculate the rate of the clk after
> enabling the critical clk itself, but that wouldn't fix another
> problem where a clk with CLK_OPS_PARENT_ENABLE is registered
> before the parent is registered. In this case the hardware access
> in the clk_ops::recalc_rate() function would fail if the parent
> is disabled.
> 
> There are even more problems exposed by this patch because it
> introduces logic that disables clks earlier in system boot than
> has existed previously. Historically we've not disabled clks
> until late init (clk_disable_unused) under the assumption that
> clks have been registered enough to have a consistent view of the
> clk tree. The clk_disable_unused logic doesn't work very well
> though, leading to quite a few devices booting with
> clk_ignore_unused on the kernel command line.
> 
> Long story short, disabling clks during clk registration is full
> of pitfalls. Revert this commit until a proper solution can be
> found.
> 
> Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> Closes: https://lore.kernel.org/r/6239343.lOV4Wx5bFT@steina-w
> Reported-by: Mark Brown <broonie@kernel.org>
> Closes: https://lore.kernel.org/r/036da7ce-6487-4a6e-9b15-97c6d3bcdcec@sirena.org.uk
> Cc: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
> Cc: Brian Masney <bmasney@redhat.com>
> Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
> Cc: Chen-Yu Tsai <wenst@chromium.org>
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>

Makes sense, and I agree.

Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>


