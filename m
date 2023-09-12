Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 606D99443
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 11:31:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45413C433C7;
	Tue, 12 Sep 2023 11:31:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694518308;
	bh=muFzVWE7/Pn8WOpl2g8Ur9UebZr9nl6F+cpwiGSAsU4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ssgALcrFyIqzhhNG6SJgV891MPCHPg59WF/GhSWjsyx6rW3rqQw/HvCxqZ0tvWL7x
	 Ut0Y6+XOLYPIx8vcmickPxG7N+i9gmmoT23pYZavRxUuVV0DPdIiQHXeSvN+NKVF/P
	 MsS9jYqVvzi3GfbCVNntOCCb0gawjus1BZ0eJJrA=
Date: Tue, 12 Sep 2023 13:31:45 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Koenig, Christian" <Christian.Koenig@amd.com>,
	"Yu, Lang" <Lang.Yu@amd.com>, Sasha Levin <sashal@kernel.org>,
	Bryan Jennings <bryjen423@gmail.com>
Subject: Re: [PATCH 5.15 015/139] drm/amdgpu: install stub fence into
 potential unused fence pointers
Message-ID: <2023091236-renovator-bronchial-52c6@gregkh>
References: <20230824145023.559380953@linuxfoundation.org>
 <20230824145024.239654518@linuxfoundation.org>
 <BL1PR12MB5144A0E84378A2666A26AE18F7F2A@BL1PR12MB5144.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BL1PR12MB5144A0E84378A2666A26AE18F7F2A@BL1PR12MB5144.namprd12.prod.outlook.com>

On Mon, Sep 11, 2023 at 08:44:28PM +0000, Deucher, Alexander wrote:
> [Public]
> 
> > -----Original Message-----
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: Thursday, August 24, 2023 10:49 AM
> > To: stable@vger.kernel.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>;
> > patches@lists.linux.dev; Koenig, Christian <Christian.Koenig@amd.com>; Yu,
> > Lang <Lang.Yu@amd.com>; Deucher, Alexander
> > <Alexander.Deucher@amd.com>; Sasha Levin <sashal@kernel.org>
> > Subject: [PATCH 5.15 015/139] drm/amdgpu: install stub fence into potential
> > unused fence pointers
> >
> > From: Lang Yu <Lang.Yu@amd.com>
> >
> > [ Upstream commit 187916e6ed9d0c3b3abc27429f7a5f8c936bd1f0 ]
> >
> > When using cpu to update page tables, vm update fences are unused.
> > Install stub fence into these fence pointers instead of NULL to avoid NULL
> > dereference when calling dma_fence_wait() on them.
> >
> > Suggested-by: Christian König <christian.koenig@amd.com>
> > Signed-off-by: Lang Yu <Lang.Yu@amd.com>
> > Reviewed-by: Christian König <christian.koenig@amd.com>
> > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Please revert this from 5.15.  This was autoselected for 5.15, but is not applicable to this branch.  This is causing log spam on 5.15.  It was included in 5.15.128 as commit 4921792e04f2125b5eadef9dbe9417a8354c7eff.  See https://gitlab.freedesktop.org/drm/amd/-/issues/2820

Now reverted, thanks.

greg k-h
