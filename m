Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C44A2207A26;
	Thu, 24 Apr 2025 07:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745479396; cv=none; b=f/1NWgHqBIF2Qn8lrXYh6VsWK5kF6AtYhcDeouRLv0XJUBR7SGT+oagamvDWQc9aZFpXfiE61rMIyFNfU1PnPJI/Im09SyqUJrHEpmXnsReGXCNSDJQyjlH9qkdIMugNeS+YYnZWmReQ2YqHXhQc5MBbCc5Q/S9O/SbJ33osv1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745479396; c=relaxed/simple;
	bh=VumYsSmkonN04kMakyptQ61ZziCwgpn0S2e2cLk2ngc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WZUyzUynujNP4XaCVNppMKbljnEmYyf0Yu1nDjZF7HpAmTC8l4PYqFVDRtVMiq+xLUFdqsqj2vbSRbXqa4MtV8CtxfeILYbujBUA/pWYQUdjEHJWOLhuzVFGqbVhhvIC+DyNkhnjtng+DTLardKdcdfX8up3AE6+v1hVO83kxBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=Z8t0DcaZ; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="Z8t0DcaZ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1745479393;
	bh=VumYsSmkonN04kMakyptQ61ZziCwgpn0S2e2cLk2ngc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Z8t0DcaZz/8ioInBq6azat9/5KWCYu9uRlcpqjS8B82EJMKrpiqKGj76nu0hixsbT
	 zxYCVJcm3RZd2WOtqhJgyofi8MCFSFr/79lfsdwLAEdSbKvDt/nlvNdjdm8XNbV9mo
	 YCYmRoKfJ91yOWdm9N1qu784f7pvLZ1f976Z5Eg5jyY8mBaWV57/OOQmtiXk+cHCj/
	 dcpBF8N/iavKzrdwcX+59uDXhZB1scM5cxu1nqvQ3LVKT7jy3e+3AFop8XhrF/Y+eZ
	 /gXQNSOGQBTZzu+qZaCkSjb5CouYwTwuEmUWfo5MMYtE1wg7llkGNqlS2adnU5k2Iv
	 ekGUnsq/dtweg==
Received: from [192.168.1.100] (2-237-20-237.ip236.fastwebnet.it [2.237.20.237])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits))
	(No client certificate requested)
	(Authenticated sender: kholk11)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id 9C6A717E0808;
	Thu, 24 Apr 2025 09:23:12 +0200 (CEST)
Message-ID: <78d3095e-0cfd-4589-ada6-35569e01bc20@collabora.com>
Date: Thu, 24 Apr 2025 09:23:11 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] drm/panel: himax-hx8279: Always initialize
 goa_{even,odd}_valid in hx8279_check_goa_config()
To: Nathan Chancellor <nathan@kernel.org>,
 Neil Armstrong <neil.armstrong@linaro.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>
Cc: Jessica Zhang <quic_jesszhan@quicinc.com>,
 dri-devel@lists.freedesktop.org, llvm@lists.linux.dev,
 patches@lists.linux.dev
References: <20250423-panel-himax-hx8279-fix-sometimes-uninitialized-v2-1-fc501c6558d9@kernel.org>
From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Content-Language: en-US
In-Reply-To: <20250423-panel-himax-hx8279-fix-sometimes-uninitialized-v2-1-fc501c6558d9@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Il 23/04/25 19:41, Nathan Chancellor ha scritto:
> Clang warns (or errors with CONFIG_WERROR=y):
> 
>    drivers/gpu/drm/panel/panel-himax-hx8279.c:838:6: error: variable 'goa_even_valid' is used uninitialized whenever 'if' condition is false [-Werror,-Wsometimes-uninitialized]
>      838 |         if (num_zero == ARRAY_SIZE(desc->goa_even_timing))
>          |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    drivers/gpu/drm/panel/panel-himax-hx8279.c:842:23: note: uninitialized use occurs here
>      842 |         if (goa_odd_valid != goa_even_valid)
>          |                              ^~~~~~~~~~~~~~
>    drivers/gpu/drm/panel/panel-himax-hx8279.c:838:2: note: remove the 'if' if its condition is always true
>      838 |         if (num_zero == ARRAY_SIZE(desc->goa_even_timing))
>          |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>      839 |                 goa_even_valid = false;
>    drivers/gpu/drm/panel/panel-himax-hx8279.c:818:36: note: initialize the variable 'goa_even_valid' to silence this warning
>      818 |         bool goa_odd_valid, goa_even_valid;
>          |                                           ^
>          |                                            = 0
> 
> Even though only the even valid variable gets flagged, both valid
> variables appear to have the same issue of possibly being used
> uninitialized if the if statement initializing them to false is not
> taken.
> 
> Turn the if statement then variable assignment into a single variable
> assignment, which states that the configuration is valid when there are
> not all zeros, clearing up the warning since the variable will always be
> initialized.
> 
> Fixes: 38d42c261389 ("drm: panel: Add driver for Himax HX8279 DDIC panels")
> Suggested-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
> Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Actually, I prefer this one, as Arnd's commit fixes only one of the two, but this
initializes both :-)

Cheers,
Angelo

