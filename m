Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792872700;
	b=cwTwhBasLllAlrHFRAIawVIZiT0KaR8gDfXEMZpxRO63KffkObceiAAAwLKhJbRWkwUg
	 kP50iiUWRGO05U9oeEZw3KsPwcgCMFHhps+QAcbLgbOW05llqZzrZ+ZWx5+3VNYlAFogr
	 iP+nof4U0jg5cYPeeYRb9GTK1282hvLD3GGmVDlOy8XyRH9DmPJhFXLDK522LGVHjMfRt
	 buncxQ7HOGBvKaN640YS5DAhXDnuWyeX3W3sLhxbvoZs3hnOYSOxFhMAksKvF5Pgb9xZ0
	 azS6hqHwTdVQT6ZF6gOybazQ2zn42Ib7/tj50yHTNv4Ccr0EyY/5/07o3wqgg+PcY+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792872700;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:MIME-Version:Content-Transfer-Encoding;
	bh=6wOFlCbTF75z81bE70PcvQC938lPSXNjRFI10kk0L1Y=;
	b=opRiuOH3TH+5fzq2u7z3HbUAFySE9wXP2vKcxFtZu5U7ggXJM5yXV8JObiNnoNLi9bSA
	 q+aV8U12g1FtPM9d8DaafH3CJlbwKGZT3vHdT7W264rxhp7puodGcXHkBGVf8qoI6uV1f
	 HcxyP2QIxLobZqmebpLzA53wDT7dGPvw3NJhwsi3PTe/XBCdSNzrFWkG7yU3E5hKm4KLT
	 mJCWAdA3U/4xN34thxz2DhJJpWyYFoVlBwhCnvA6cRvahN6DqTyDObsB7wpLelUSAvjO+
	 iltPkrTDrICNcO3P9rpL80SPMDFCEmO3KZRcBNSkDc+0QoXi2XKTlSWrsrO3Ku7RgKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S5CAVdk0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D90C606A31F;
	Sat, 24 Oct 2026 20:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=S5CAVdk0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61C2A1F031E1;
	Sat, 24 Oct 2026 20:11:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792872700;
	bh=6wOFlCbTF75z81bE70PcvQC938lPSXNjRFI10kk0L1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S5CAVdk0e7Bl2DQaWzUi0YPh0mA/v89hfXGFgU5h5yWoNY2of+D8MnJ7fytreYVQE
	 ix+qmAm2FybMBNuSWPrPs4ubLwGy/bo8yOnu3M3XftUg89yI895gPonCuiyI7B8eFC
	 cS0UO9f2P5sT7+CUd4qaIq9X3jBmYMTH6Jo/nPkX6hf3n6Qwm7enSFiJyeu/tP4z3N
	 zm7OMTNPmRVz4T0kRBN3cNYVjwZ1l8K2caOIPqIZ6qsG99M3jYBgwJtLN28PBNtAWK
	 M/Bkzjcj5xpHAPkZs1eETmiRreT5NJoHUQRbl7OoROdlMmko/tQWP6HDkCqTazekiv
	 d8e4NN0oBVsSQ==
From: Sasha Levin <sashal@kernel.org>
To: Nikola Ciprich <nikola.ciprich@linuxbox.cz>
Cc: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	Jacob Keller <jacob.e.keller@intel.com>,
	Michal Kubiak <michal.kubiak@intel.com>,
	Alexander Nowlin <alexander.nowlin@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Alexander Lobakin <aleksander.lobakin@intel.com>
Subject: Re: [PATCH 6.18 158/621] ice: drop page splitting and recycling
Date: Sat, 24 Oct 2026 16:11:13 -0400
Message-ID: <2026-10-24-1-daily-reply-0016-ice-xdp-rxq-frag-size-6-18@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <atsythEG2rkGdc6Z@pcnci.linuxbox.cz>
References: <atsythEG2rkGdc6Z@pcnci.linuxbox.cz>
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

> 02852b47c706 ("ice: fix rxq info registering in mbuf packets")
> e142dc4ef0f4 ("ice: change XDP RxQ frag_size from DMA write length to xdp.frame_sz")
>
> That leaves 6.18 without the XDP frag_size fix (the fifth one above). Could
> someone from Intel send an adapted [PATCH 6.18.y] of it for the 6.18 Rx code,
> without Page Pool?

With the full Page Pool conversion back in the 6.18 queue, no adapted patch
is needed. Queued the two XDP RxQ fixes quoted above for 6.18 as well, thanks.

-- 
Thanks,
Sasha
