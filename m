Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86B4428D83B;
	Wed, 23 Apr 2025 17:29:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745429348; cv=none; b=DyC9HNwwO46sRTCVjEeZL0pD283+K4jzhA1HElebLUinWwjYCEVeWXEwnNu0NWKcPwCV1svMgqc4UFzPmRWgMiBeUyeBgxZhRARguY+xkMsx5ncj0Nz4xb9gCZ/ljE1EX6d6PdK7S2tP5JfFpIHQC/eXtObh74KFYprWHHu3xzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745429348; c=relaxed/simple;
	bh=BLUXHEVKgbX3+ZC/NNSHVdvoumci16WGdcd07NTrr3c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=oKVf8qdGLp/k6F9vty1gsmjKHwqI4HCrU/UUcC/5Cx2MnkAe68wlCw06vuAImG2EA7GekykzHoZpcqWWSj3ruOXNM+KRCGf2ZVctdpnHVEAld5rzuzUbx/A9RBCDGHDCIxGp/Nv3FmeSXCyIUh/IDREGxnm2O44RXJHq/G5dIkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nDpRR3dv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nDpRR3dv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AACEC4CEE2;
	Wed, 23 Apr 2025 17:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1745429348;
	bh=BLUXHEVKgbX3+ZC/NNSHVdvoumci16WGdcd07NTrr3c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nDpRR3dvKqzBue0UlTsb8lnTPUQYLqpmgRmpjDAUCDSQD+4n9kxyamZcT+OkCF+MA
	 e46M9fIkuVb0jPNIZTsoaI+j8j+2RRnBMbt3MCqk6piUlL5eQSQTcQBk6Dg4g1vB1q
	 51XS+O7iYBZVuVqC7eIFkx+AwdGqkSpEydwxx2xFOeZfKDZoVqgIDKlZrl+/br3XIn
	 ovJtR4NZUmwIOVPqUMeqiWzcbtBB8otoA6v5tXqZy+KQZx6Y+teobZ+MlMU+e9JnAA
	 D7XBiUDCBdC+jNWIyH5/okUc3xZ5gc4mbkl4xePIrionS2hhHGz21jrlSPISWJoJBI
	 tJTyJdbH9dqRA==
Date: Wed, 23 Apr 2025 10:29:03 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: neil.armstrong@linaro.org,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Jessica Zhang <quic_jesszhan@quicinc.com>,
	dri-devel@lists.freedesktop.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] drm/panel: himax-hx8279: Initialize goa_{even,odd}_valid
 in hx8279_check_goa_config()
Message-ID: <20250423172903.GA1472499@ax162>
References: <20250422-panel-himax-hx8279-fix-sometimes-uninitialized-v1-1-614dba12b30d@kernel.org>
 <a6e47775-33c3-44c2-b6d5-58164e4a0a50@linaro.org>
 <b8d21e46-c50a-4212-ae7a-d292c2ec6ce4@linaro.org>
 <4cd274f8-85ab-43dc-bef4-41646d43b775@collabora.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4cd274f8-85ab-43dc-bef4-41646d43b775@collabora.com>

On Wed, Apr 23, 2025 at 04:01:20PM +0200, AngeloGioacchino Del Regno wrote:
> or the shorter form:
> 
> 	goa_odd_valid = (num_zero != ARRAY_SIZE(desc->goa_odd_timing));
> 
> 	/* Up to 3 zeroes is a valid config. Check them all. */
> 	num_zero = 1;
> 	for (i = 0; i < ARRAY_SIZE(desc->goa_even_timing); i++) {
> 		if (desc->goa_even_timing[i])
> 			num_zero++;
> 	}
> 
> 	goa_even_valid = (num_zero != ARRAY_SIZE(desc->goa_even_timing));
> 

Ah yeah, I think I like this the best as it is the most compact while
always ensuring the variable is always initialized. I will send a v2
with your Reviewed-by carried forward and an additional Suggested-by
shortly.

Cheers,
Nathan
