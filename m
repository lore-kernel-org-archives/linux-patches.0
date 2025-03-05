Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F731EDA26;
	Wed,  5 Mar 2025 12:59:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741179571; cv=none; b=NWJOGSwvbsLmnfLKK2yiunW9NQzZTRuB9SB/msJOYacDj9D/RMW75BDghRbCJVcTL9FpHKM0iQXpbE8l6CVHROtgvGemq4jHN0zAJktG0vBkHQneCzQ9u+n9YpeD6YUJODlqPfnvB4Ie671y37DNZmLlvINJ+nw/Q31livw0/OE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741179571; c=relaxed/simple;
	bh=ydjrl0nn4CMEHtCBM5l94ZW9OOFOLfL9ZmqhrjUkLU8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GrN8EfArMXUXOFjEdEKdFdbhvbbmWq2rxAddrUdFUQJaUvrvS+CTCQ7K7TJwK1IA02BIgtV18s3bDeSqKco/I/7v/AjPqMvFNGJXKP2F7b4vh87u5ac3QNFbyD69yhq3RZWDGrWvANjjspK+4dNNbia5vF5olGXbYnlI7xpIBDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gxtn+5Go; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gxtn+5Go"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 724A7C4CEE2;
	Wed,  5 Mar 2025 12:59:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741179571;
	bh=ydjrl0nn4CMEHtCBM5l94ZW9OOFOLfL9ZmqhrjUkLU8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Gxtn+5GoabVjRIFGeo6k90yuhftoXIsgh8485THT0klS3lm3MELFOiTyn9puOh/Hh
	 oZhEMXf8RNe1BicDJVNZ806+RUl3367La3PehMzeDn7q7wdk/VJdt2EdP3GZAUvF0N
	 y1xvdNowyOrM4+rj7hiRFtGWLOsVtFgATFEZV1qs=
Date: Wed, 5 Mar 2025 13:59:28 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: jianqi.ren.cn@windriver.com
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	alexander.deucher@amd.com, daniel.wheeler@amd.com,
	mario.limonciello@amd.com, josip.pavic@amd.com,
	aurabindo.pillai@amd.com, sohaib.nadeem@amd.com,
	harry.wentland@amd.com, sunpeng.li@amd.com,
	Rodrigo.Siqueira@amd.com, christian.koenig@amd.com,
	Xinhui.Pan@amd.com, airlied@gmail.com, daniel@ffwll.ch,
	wayne.lin@amd.com, sashal@kernel.org,
	dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	charlene.liu@amd.com, gabe.teeger@amd.com,
	amd-gfx@lists.freedesktop.org, Nicholas.Kazlauskas@amd.com
Subject: Re: [PATCH 6.1.y] drm/amd/display: fixed integer types and null
 check locations
Message-ID: <2025030548-spinal-breezy-ef8e@gregkh>
References: <20250227032633.4176866-1-jianqi.ren.cn@windriver.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250227032633.4176866-1-jianqi.ren.cn@windriver.com>

On Thu, Feb 27, 2025 at 11:26:33AM +0800, jianqi.ren.cn@windriver.com wrote:
> From: Sohaib Nadeem <sohaib.nadeem@amd.com>
> 
> [ Upstream commit 0484e05d048b66d01d1f3c1d2306010bb57d8738 ]
> 
> [why]:
> issues fixed:
> - comparison with wider integer type in loop condition which can cause
> infinite loops
> - pointer dereference before null check
> 
> Cc: Mario Limonciello <mario.limonciello@amd.com>
> Cc: Alex Deucher <alexander.deucher@amd.com>
> Cc: stable@vger.kernel.org
> Reviewed-by: Josip Pavic <josip.pavic@amd.com>
> Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
> Signed-off-by: Sohaib Nadeem <sohaib.nadeem@amd.com>
> Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
> Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> [ To fix CVE-2024-26767, delete changes made in drivers/gpu/drm/amd/display/dc/link/link_validation.c
>  for this file is deleted in linux-6.1 ]

It's not that the file is deleted, it is just not present yet, as it had
not shown up in the tree.

I've manually edited this changelog, please be more careful next time.
Also, no need to mention a CVE id, they don't mean anything here :)

thanks,

greg k-h
