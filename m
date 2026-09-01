Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E66118FDDE;
	Tue,  1 Sep 2026 12:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788265548; cv=none; b=Lk32HrkYUeFXUAKZrENChTSNo8l9Lja5wo0v9lr13ofJAF8gUf/zZWxvFTV3mnw+2LdsTd3I/H8Q3kZjzqLZAJONjGVKdFMBimG5iA131kA8EN4isIk/bzr2gSICQS442BKNuPyXGNRysPanYsy+7pE59LtA2oHBEPWcSFhxbh4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788265548; c=relaxed/simple;
	bh=XZrWj5v+IwHewyXl4FDaI40CwfdatKDWv2CoDe3RFqk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=a9EsO2GHiC+5Ojpddbf23EF1QiseBfjdzgx11elwDclsneWT8T96AhO2+BqGyJYSKncE23CZbiknvH0W3J13U+ILW3mCEQsI1ortneoozmoxy55K3TAdsiNWqzwOS1c2DRk1GKEKUoyY5KiC73vi+A36OEJFOkPcqtB0TmxtUEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lRi92VTs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lRi92VTs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AABFA1F000E9;
	Tue,  1 Sep 2026 12:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788265547;
	bh=vQPLILDv5FFDjI9csyICvmlnOlCvLH+KWAZmiWBg4Cw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=lRi92VTsVQjNnZzsUSnAG8H8SWxWvCwvRPfWgHDVfhw9k9WKRzjjZ3uZ/GLuhHPh8
	 pmQ3Yho4cPzQ55OBx1QRVeePI7qdqvghn1sOEb2CmhfywXEM4k/ans/bs+BLws7RL4
	 IT98dYdGPj8ogY8POJy9RfefNBWWkUMAlnbnlZp9hY4/pFun93nU2dBlaomukyL8ua
	 AdXXAELmSyziXF4PM/S5Leqyu2xVwOvslGXNIeZ3MS9+KjgQHbhDZcCKkV5TGdZvhy
	 3uz3aGhEwtCAqvFPx2McMtdJAQWVibTEzkoQqns4TBGuyGmKT6tK0AsbwOKBsLJnBY
	 lhpugEQHjkpQA==
Date: Tue, 1 Sep 2026 08:25:45 -0400
From: Sasha Levin <sashal@kernel.org>
To: Sergey Lebedev <lsa.uz@pm.me>
Cc: stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.18] ASoC: rt1320: run the initialisation preset
 on the first hardware init
Message-ID: <apbESbDffji_4bIu@laps>
References: <20260831133314.4125787-1-sashal@kernel.org>
 <20260831133314.4125787-601-sashal@kernel.org>
 <20260831142522.85439-1-lsa.uz@pm.me>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260831142522.85439-1-lsa.uz@pm.me>

On Mon, Aug 31, 2026 at 02:25:30PM +0000, Sergey Lebedev wrote:
>Author's ack for the AUTOSEL 6.18 pick of

Ack, thanks!

-- 
Thanks,
Sasha
