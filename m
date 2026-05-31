Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5EE344DAB
	for <patches@lists.linux.dev>; Sun, 31 May 2026 01:29:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780190954; cv=none; b=klKRh0wgFdHq2QOlVKYbfS4HSQRQ4P8aVO7k7cK4YgZ7g3zZGLaiaHZI+c7NHV9XOyaS4VJ7EStcVhqqXIy+C+83suFKen1MQodWcpCWBVVVFvcCn3r0svV2aJApTQbnUQsppmwF9xSvTQtVDnAtp0+0V3DJwXs2cOKaCa6P12w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780190954; c=relaxed/simple;
	bh=307yPJJAHpzr2/1FcYA8kldsdHxrtXw1QnbV/mVS2fw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IGZHq6OOALBYZre3vZx98yeygS01CnArVtJ+Jc5PzUYp8U9bbg8jBaApyjHWU1cf9jbvm7p3+pEQEfmpO2JxqnaBj+aOFmpkieaG8Xn27BIHNF3t+Or2hKshy6lIyWH8JXb+92dOawfQsE3bKCTrzxv7tvzQR4TmiFbv0w99bfI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com; spf=pass smtp.mailfrom=pobox.com; dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b=qRADWNpR; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=h5VqDS7y; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=pobox.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=pobox.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=pobox.com header.i=@pobox.com header.b="qRADWNpR";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="h5VqDS7y"
Received: from phl-compute-04.internal (phl-compute-04.internal [10.202.2.44])
	by mailfhigh.phl.internal (Postfix) with ESMTP id D1FDE140005C;
	Sat, 30 May 2026 21:29:10 -0400 (EDT)
Received: from phl-frontend-02 ([10.202.2.161])
  by phl-compute-04.internal (MEProxy); Sat, 30 May 2026 21:29:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pobox.com; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1780190950;
	 x=1780277350; bh=FXHoUwq6+hJslcgA+GH0HnzXbfw3bpiGTV2ua8fi5LI=; b=
	qRADWNpRx9l1oOMNZ2vRBhmMwnTjRSInv/o0QzZ3CfZttrwQnU4aCIFbSlaCOkfv
	O09YJvM6sy6WpXd9mOUtVT96mL6uj1EKk+wCalyjkdYJxn/weZSVXHXj4dfjtAWI
	y46pbHxvkdVlUN7ENw4B0/JuOUGp2GJbubJD6IyXmYzHKngURV7FsqYeoKny8itD
	ro15BBNg5fs8+dteHqXJ8c6MDdEHRX7pBQQdZdIXSB7XURp6MxkmcUJMes5QaJNs
	8nohqQAz6dOZMl0FRwc91Tz+vzfB/IPYpZhmMFSArGhQ8Gb8Fu+PxTVUdNtBTevu
	2rIFgrsd3qWuDBmP6ZOWWg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1780190950; x=
	1780277350; bh=FXHoUwq6+hJslcgA+GH0HnzXbfw3bpiGTV2ua8fi5LI=; b=h
	5VqDS7ymaBfOUB3DxbF64XJl2u4ikYvwopIvYI7eg1rZhDtVv2frZn+cPvqzAeQC
	imasBxUGqSN03FMU3ThSuAUAnR2Utm0LfgJOx//ggGWPJKClLdiaSqaH2M/Q8MZ+
	p3YB/88v/oRBCX2g83XHlJW+thk4xNpZ2hwdk/BQ7CI6d7FeZq55E/oAT4AtjsDO
	QGIvYhqU328n5rN3Z+ZqRFtQNW7VMz8utm3CWWO90oUE0d1FB7IuspOCt1B5ukTI
	eUzN5r0zN2FZT6A29TSY7sqSwI6hiR/v8MIbywvfRnoxHIpr6zsJoU+3524Gc0YB
	64Zj6k3C9DP6slVDUlcbw==
X-ME-Sender: <xms:5Y4barhTodSyoWrQvg3XUETFWr6cIMr0iIdzyIjK1s81Syd51SRzJw>
    <xme:5Y4bapaMopnj6DoiBP2xM0bZ-QgXIr0qknzkgdLp6KnlHsL48LfHtvJFc02TiRslC
    AzbnFEIpS9s2nqXfo8z8cN4jesmGfMbzPizMzaaOwpG1Cxu_crREYM>
X-ME-Received: <xmr:5Y4bakVfg74TEUesEtu6Ka8BUGuq0GNBjFxV0ERnffpYY564HwlVrkuoWto7OL8A3jJ-Wwtep_jvzwjWeXa7hCjR201Mdthq>
X-ME-Proxy-Cause: dmFkZTETXgvviTlQhfv1mnp2y3iuBRVhrNr4mhTa6gJtfCaKyGCL9r0NoGGVmCvKuK9jGc
    le5QrzNdL0sQRvgSnBNYnZOU6wfbiNWC+lBlColRDY8qn4bFgrP81eIk2VHVaMlEAUt/FX
    UHT6c8NI+pZHtkNFQFshvxfcewSkXaYjwdT2zKl4xiC1viMlQRmw4a2WqW9/jL8MYGKiV7
    mlte9HB2PEeeOQ3/ZIKXV0y1dlYidsKvKNxRwTSudJDSKY+SaoF3Qm9PDIapWXJ5+Xn1+Q
    WEgdZKzB1qBR5ee1c/idmwur+3/V7fWlqOejl8hj1Q2RO+0Tb5ngorReye9jCK79gcavOA
    YVPMfr27hUYl/BVrjp8YWgRQ6PYNh+txrbfW5diB4VcXtQaRW+kEawmB98oDe8BrP0E/wh
    VJOKWpzkUkn+V8v9ACmWeu+dVQxtf/bVlse0JoCiz9v9edjvK5Er51CO2wT09fSgSXrtqa
    Y5tSqNuKpeAljkkdxrOsdK/qDUpaVy0ey1L3qhA1otXOgFWg50KpuhqrWqtaC3gyhiTd2N
    igQSIPIbpDjEfNnX+ewZpd8JaOdSuiofOspWGtcAIi01PFaLxDONcxEmd25m7HT7uzWMyV
    vIfpHJqZAJ2AeqM5xdudvAPxs11gMQ1lWTRPCYIDrz+mwqcgzs24480dvPUg
X-ME-Proxy: <xmx:5Y4baghFGtOJsTQFTTNMKAHS-_HfLxNkd5XLBpgvG1WTakHCztk2eQ>
    <xmx:5o4bavmdOiUMm4IObkF7MxJJMJA58SELFxhH2aMZISvYFDGMN6NiZw>
    <xmx:5o4bapxWUig_tyaf98ZZ1ntzX5LCywd3797cHfArtRaswfpk945tAg>
    <xmx:5o4baqtanvYYu9k8vJR9HdNWbJNFNpCNn74K4aYaYaBFEjQCivpKHA>
    <xmx:5o4balPTub55SyXwXvSieE4D3LWqF8rOLbg6NkKsUyCfigdPsXrjKbbg>
Feedback-ID: i6289494f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 30 May 2026 21:29:07 -0400 (EDT)
Message-ID: <5e2ac444-451c-4220-8013-0e6382b5f165@pobox.com>
Date: Sat, 30 May 2026 18:29:06 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 072/589] media: uvcvideo: Use heuristic to find
 stream entity
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Angel4005 <ooara1337@gmail.com>,
 Ricardo Ribalda <ribalda@chromium.org>, Hans de Goede <hansg@kernel.org>,
 Hans Verkuil <hverkuil+cisco@kernel.org>, Ron Economos <re@w6rz.net>,
 "Pavel Machek (CIP)" <pavel@nabladev.com>,
 Brett A C Sheffield <bacs@librecast.net>, Mark Brown <broonie@kernel.org>,
 Peter Schneider <pschneider1968@googlemail.com>,
 Francesco Dolcini <francesco.dolcini@toradex.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Jon Hunter <jonathanh@nvidia.com>,
 Florian Fainelli <florian.fainelli@broadcom.com>,
 Miguel Ojeda <ojeda@kernel.org>,
 Vijayendra Suman <vijayendra.suman@oracle.com>,
 Sasha Levin <sashal@kernel.org>
References: <20260530160224.570625122@linuxfoundation.org>
 <20260530160226.496219768@linuxfoundation.org>
Content-Language: en-US
From: "Barry K. Nathan" <barryn@pobox.com>
In-Reply-To: <20260530160226.496219768@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/30/26 8:59 AM, Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ricardo Ribalda<ribalda@chromium.org>
> 
> [ Upstream commit 758dbc756aad429da11c569c0d067f7fd032bcf7 ]
> 
> Some devices, like the Grandstream GUV3100 webcam, have an invalid UVC
> descriptor where multiple entities share the same ID, this is invalid
> and makes it impossible to make a proper entity tree without heuristics.
> 
> We have recently introduced a change in the way that we handle invalid
> entities that has caused a regression on broken devices.
> 
> Implement a new heuristic to handle these devices properly.
> 
> Reported-by: Angel4005<ooara1337@gmail.com>
> Closes:https://lore.kernel.org/linux-media/CAOzBiVuS7ygUjjhCbyWg-KiNx+HFTYnqH5+GJhd6cYsNLT=DaA@mail.gmail.com/
> Fixes: 0e2ee70291e6 ("media: uvcvideo: Mark invalid entities with id UVC_INVALID_ENTITY_ID")
> Cc:stable@vger.kernel.org
> Signed-off-by: Ricardo Ribalda<ribalda@chromium.org>
> Reviewed-by: Hans de Goede<hansg@kernel.org>
> Signed-off-by: Hans Verkuil<hverkuil+cisco@kernel.org>
> Tested-by: Ron Economos<re@w6rz.net>
> Tested-by: Pavel Machek (CIP)<pavel@nabladev.com>
> Tested-by: Brett A C Sheffield<bacs@librecast.net>
> Tested-by: Mark Brown<broonie@kernel.org>
> Tested-by: Barry K. Nathan<barryn@pobox.com>
> Tested-by: Peter Schneider<pschneider1968@googlemail.com>
> Tested-by: Francesco Dolcini<francesco.dolcini@toradex.com>
> Tested-by: Shuah Khan<skhan@linuxfoundation.org>
> Tested-by: Jon Hunter<jonathanh@nvidia.com>
> Tested-by: Florian Fainelli<florian.fainelli@broadcom.com>
> Tested-by: Miguel Ojeda<ojeda@kernel.org>
> Tested-by: Vijayendra Suman<vijayendra.suman@oracle.com>
> Signed-off-by: Sasha Levin<sashal@kernel.org>
> ---
>   drivers/media/usb/uvc/uvc_driver.c | 15 ++++++++++++++-
>   1 file changed, 14 insertions(+), 1 deletion(-)

Comparing this patch to the corresponding patches that went into
5.15.203/6.1.169/6.6.117/6.12.58/6.17.8, I believe these Tested-by tags
may be incorrect.

(Incidentally, I think my email client may have removed some of the
spaces in the quoted text, but I'm not sure why that happened.)

-- 
-Barry K. Nathan  <barryn@pobox.com>
