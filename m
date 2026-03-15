Received: from m.b4.vu (m.b4.vu [203.16.231.148])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB06837B415
	for <patches@lists.linux.dev>; Sun, 15 Mar 2026 19:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.16.231.148
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773601215; cv=none; b=faEH3oM5WJN9n18Ivq9B1EKbMf4+g11uNtCd+05D0ZAZb1AvYyUrvVbSNEM8u4i+74Iu6D4p20POj2SamZ5ExxFWFMOCeJq1POPBqHmz+lt89itPDvhSLfYQfXQMMmjP/L31+kjMc2f8D61N14Xlku/YUmmy3Nl4ReG2ivZ7kdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773601215; c=relaxed/simple;
	bh=OFaa1T9u+uSLmtJRAe56Fb1TCQ2XzYkq5bRxObJiXmo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N6k1l+cLpmgNw0tqXLnapfzWJptG+QYmTS3nbd9/8Y36dyVjlp+MuQ+49GW2D81BWlE5xzQcSWqJdOC+ayISDGHlwvJHefRM5t1dxcAKemIngCsM38OZEK8Grg8moEQOd5n9KT2cPOqkKdNdjSkt9n1g4/E5sro8jIsVIX+k1m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=b4.vu; spf=pass smtp.mailfrom=b4.vu; dkim=pass (2048-bit key) header.d=b4.vu header.i=@b4.vu header.b=NpiBJUXe; arc=none smtp.client-ip=203.16.231.148
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=b4.vu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=b4.vu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=b4.vu header.i=@b4.vu header.b="NpiBJUXe"
Received: by m.b4.vu (Postfix, from userid 1000)
	id B55BA6792310; Mon, 16 Mar 2026 05:24:31 +1030 (ACDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 m.b4.vu B55BA6792310
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=b4.vu; s=m1;
	t=1773600871; bh=kwi2gTZOa3Ar8ndt1TXk+t9vC2qMZ3g1oYe6sQzcylU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NpiBJUXepl6VbfTtlnqgAA3TrnxNxKP/OUG6gEdnVWCN5KT8hggxQXB5wkK1piAM0
	 AT7ZRNU3LuPTeTvTe5eH0C4va2F/2ZWNy0S1hcNPkAZQtf8fCsscDyed0rJWHybEAP
	 SBwLFknHu2zTnU773d+dupnWUOlbLE2Sj3OlHvYCjhq0zadj24gsyD56OGLe/tD5ip
	 N5Mz5zCroWzFmID6wco5nz/tfAZtXA+/Mp52HNsznBMMVSkIh1XXLYy7hGTKQx5BWg
	 Xw3ADtanPoioTQLgQW4LABvyCXVgP9qzo6s0+Dt5t4eYxAs3wLO4M3Dfvmw+G+9eZc
	 Qaw1baLldYrSw==
Date: Mon, 16 Mar 2026 05:24:31 +1030
From: "Geoffrey D. Bennett" <g@b4.vu>
To: Sasha Levin <sashal@kernel.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Takashi Iwai <tiwai@suse.de>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 6.19 017/311] ALSA: usb-audio: Remove VALIDATE_RATES
 quirk for Focusrite devices
Message-ID: <abcAZzOM0P7fKVoz@m.b4.vu>
References: <cover.1773140654.git.sashal@kernel.org>
 <3fc64e0aaa72a20bed4ebd8951c89cfadf474e62.1773140655.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fc64e0aaa72a20bed4ebd8951c89cfadf474e62.1773140655.git.sashal@kernel.org>

On Tue, Mar 10, 2026 at 07:01:04AM -0400, Sasha Levin wrote:
> From: "Geoffrey D. Bennett" <g@b4.vu>
> 
> [ Upstream commit a8cc55bf81a45772cad44c83ea7bb0e98431094a ]
> 
> Remove QUIRK_FLAG_VALIDATE_RATES for Focusrite. With the previous
> commit, focusrite_valid_sample_rate() produces correct rate tables
> without USB probing.
[...]

Hi Sasha, Greg,

This commit depends on its predecessor 24d2d3c5f940 ("ALSA: usb-audio:
Improve Focusrite sample rate filtering") which was not picked up for
stable because it didn't have a Fixes tag.

Without the rate filtering patch, the Focusrite Scarlett 18i8 3rd Gen
gets all sample rates advertised on every altsetting instead of the
correct per-altsetting subset. I've confirmed this on 6.19.7.

Could 24d2d3c5f940 be queued for stable please?

Thanks,
Geoffrey.
