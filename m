Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13302268693;
	Fri, 14 Feb 2025 16:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739550500; cv=none; b=bCst1nj1y1C2jy6ZUETqbvOgi1sJuzbmmAo5ebGymnTLCXsDwVdjY3FuSqK/ppAZMKygvuJfw8dOQvC/BRJR2Uo4tbLmtf32KWhWL4aKCZ8ejKORbSo1/K6qfAjBTa5y827CJcm2uyL2nY6Q5PLhnqAviNbypLl0c0yqLaJGnDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739550500; c=relaxed/simple;
	bh=pgd71EpmnkUr9PBF4eQep648ge+sakFKW/+uPciam1I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ivgU8GhtdjCOCTFR//Co7HUkgNHVtvhllpETJfSkTQsvKSqzaf+COGzIyw8c1ZPwrl50L/ttMWVCm9Pgn+opyOQ0cng08BfeENEs+MLy3SqjkM3J4clJcnimZThncDvk4V+ThXxH6lWrGguHAoGM7+3caHZV5xXhtpxl9c3O/IM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kU3OvjKM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kU3OvjKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAB67C4CED1;
	Fri, 14 Feb 2025 16:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739550499;
	bh=pgd71EpmnkUr9PBF4eQep648ge+sakFKW/+uPciam1I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=kU3OvjKMmCfrYrIVpg50Qc1QvEVT1ZqLFCMAlw28HHgePVedUhFe1sD/Ug/28cHgq
	 +n8ZRLH48l9Xwa39NAG7lxoMyfNsSNgplB9ekCLOLKWA7Oazt8r52RhNHYF6joJsic
	 +rSIpHDqnpxz03438kgp2PFzSafbCXDkKq477w5OjroAIhRuC9NYfL9iHLUf3NvmpT
	 dFnrvIl6HBN5GO9owmmVxxCvmTLbIjP9Q0HAZ8z7ysOkXvOAZoFJ890gUg6OgBZdXy
	 UPxGvt7pdrAMSeOcsNauRitDEJbuWri56uVNEhceW6gS0HoBLIDCF0Udl8WQCKwyz2
	 BrChrsPDUtNig==
Date: Fri, 14 Feb 2025 09:28:13 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: Harry Wentland <harry.wentland@amd.com>, Leo Li <sunpeng.li@amd.com>,
	Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
	Xinhui Pan <Xinhui.Pan@amd.com>,
	Austin Zheng <Austin.Zheng@amd.com>,
	Dillon Varone <dillon.varone@amd.com>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	llvm@lists.linux.dev, patches@lists.linux.dev
Subject: Re: [PATCH] drm/amd/display: Disable -Wenum-float-conversion for
 dml2_dpmm_dcn4.c
Message-ID: <20250214162813.GA3221808@ax162>
References: <20241219-amdgpu-fix-enum-float-conversion-again-again-v1-1-ef2c619724b1@kernel.org>
 <CADnq5_NKWH7UC_ow825aAtF1tZXJTVOwDWaqDR8_4Y6EmPXUiA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CADnq5_NKWH7UC_ow825aAtF1tZXJTVOwDWaqDR8_4Y6EmPXUiA@mail.gmail.com>

On Thu, Dec 19, 2024 at 05:21:41PM -0500, Alex Deucher wrote:
> On Thu, Dec 19, 2024 at 12:23 PM Nathan Chancellor <nathan@kernel.org> wrote:
> >
> > Commit be4e3509314a ("drm/amd/display: DML21 Reintegration For Various
> > Fixes") blew away commit fdedd77b0eb3 ("drm/amd/display: Reapply
> > 2fde4fdddc1f"), which itself was a reapplication for the same reason,
> > which results in that compiler warning returning:
> >
> >   drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/dml21/src/dml2_dpmm/dml2_dpmm_dcn4.c:215:58: error: arithmetic between enumeration type 'enum dentist_divider_range' and floating-point type 'double' [-Werror,-Wenum-float-conversion]
> >     215 |         divider = (unsigned int)(DFS_DIVIDER_RANGE_SCALE_FACTOR * (vco_freq_khz / clock_khz));
> >         |                                  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ ^ ~~~~~~~~~~~~~~~~~~~~~~~~~~
> >
> > Just disable the warning for the whole file via Makefile to avoid having
> > to reapply the same fix every time the code syncs from wherever it is
> > actually maintained.
> >
> > Fixes: be4e3509314a ("drm/amd/display: DML21 Reintegration For Various Fixes")
> > Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> > ---
> > If you would prefer reapplying the local fix, feel free to do so, but I
> > would like for it to be in the upstream source so it does not have to
> > keep being applied.
> 
> I've reapplied the original fix and I've confirmed that the fix will
> be pushed to the DML tree as well this time.

Did that actually end up happening? Commit 1b30456150e5
("drm/amd/display: DML21 Reintegration") in next-20250214 reintroduces
this warning... I guess it may be a timing thing because the author date
is three weeks ago or so. Should I send my "Reapply" patch or will you
take care of it?

Cheers,
Nathan
