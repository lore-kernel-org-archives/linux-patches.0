Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 938C9320CD1;
	Thu, 24 Sep 2026 01:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790212509; cv=none; b=egJs4UDl3mzMOg/WoV+k4mx+aBGt1kVdDcODv/jBwHzoFKNdS8ydBzN5kVbNWwoL+eQKFEVrXVbAWEkuIq+NftbLbxHd0MuCBQcXMjTfIx/xindIZK4UDHMuQfxTWJRRDdzHh4uuqSbjKj8EjCXvtJbmCnToxw2IiWgocefbjHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790212509; c=relaxed/simple;
	bh=23rJ5SUmnp3Uive9BlWxaPRXlzqgi5ynhDLuaO8VvyI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Zr7e26YDd7EWmshIB5dZtJdxzZldSKU048FQR2nO4rS9uBSsUwhiiOgBUUlzkY3EZbrwIpBjX9aQyGRVHauK0QfSRc9PJ6W8aBjUn3IWxaocLwHhFYCEEzIaJczuzfP3QIFkzjxNrUrl8q6/24G/7qN/f0wel9v4jDVOg1D8u4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jKNoXukf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jKNoXukf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27FCD1F000FF;
	Thu, 24 Sep 2026 01:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790212508;
	bh=7iQmSZDG9WCUuvYOvT/7OBrDkdLsvivRjtVmz9U/QGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jKNoXukf4kzGvQ3F2jB0ClCWRT16S1J2BYXS7hXkbRn95+Djsp1CGAOzn83ZLqQfA
	 u6Nd6bSNe9a2OrNTvvLgL2ZfINWNbb0etM+iXqiQVY9jHSaKLfygD2UtFN7WszO72X
	 T6C+y4KyT2/cd2EBNz3ay2pDnS2h6m/+44mueFB1AzJ7kLUVEIQwoWDyFtpiKrK8Hc
	 NGW/Hax9ZUzcsv30ehbFe25ESxxL1Mkbq8U1P5gpnJVbswWb9hi3dNYA6BFtPGTq4q
	 viuyTc2EerDhE6GZgSwUckInXLGY3yjbL4u7komeX0DxVIXxwDSX0jeE7g4nLJuy3Z
	 n0AOB87fZepYQ==
From: Sasha Levin <sashal@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Karl Mehltretter <kmehltretter@gmail.com>,
	stable@vger.kernel.org,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	Jianfeng Liu <liujianfeng1994@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>
Subject: Re: [PATCH 7.2 104/438] dma-buf: Make DMABUF_DEBUG default to y on DEBUG_KERNEL kernels
Date: Wed, 23 Sep 2026 21:15:03 -0400
Message-ID: <20260924010940-6fdce3544586@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260923204146.6699-1-kmehltretter@gmail.com>
References: <20260923140644.756254324@linuxfoundation.org> <20260923140647.476063815@linuxfoundation.org> <20260923204146.6699-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, Sep 23, 2026 at 10:41:46PM +0200, Karl Mehltretter wrote:
> I object to including this patch in 7.2.8. I authored the upstream
> patch, but did not tag it for stable. It corrects a Kconfig default
> and thereby enables the DMA-BUF importer checks in configurations
> that take the DEBUG_KERNEL default.

Dropped from the 7.2 queue, so it won't be in 7.2.8.

-- 
Thanks,
Sasha
