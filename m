Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B5AD295DBD;
	Wed, 18 Jun 2025 13:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750252046; cv=none; b=kFIah8XEr8WT75jEQvfvxneiaPn62oDpbyiM/lU2qh30DO/ddxwPJlqcSOZXqzI+mOjxYj/Iyt/iGqXG/+x96A7ATAz3tg8+RBGqFqrbNsgrjApsdhWXLXMUR2JGkJJS+EqJQGOIp1RccAsGEAkOVRiEXQGSJGa98YtnXv+6olY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750252046; c=relaxed/simple;
	bh=9V++2TXtSenm2W6D8GAiFEV/ZY0lvFNBGxcum04VwLY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iG9ViyTBAz5J+WGn2kgGOvfleTRY1gaJzU+Z/N6qN8rSlrYDmdX+YjLAZMGt/smY5VUmijkSLBXpxGQrcFbPkb+GWqQDRSPeepRDFjmowVv/AkpLYLBzgMkQDENbvNXa4gA6gtEl/KNNqkdwgPDc8BywV9/xwlNcwbYJPritT2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YUZczBbb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YUZczBbb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EF8CC4CEE7;
	Wed, 18 Jun 2025 13:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750252045;
	bh=9V++2TXtSenm2W6D8GAiFEV/ZY0lvFNBGxcum04VwLY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YUZczBbbPW5PNdicCXn2Tq50u6wQT71iT7eTqJ/t2N08oVFyZc19aKmAYk0lukE5i
	 gGADll+WCM4LW6aiJQ2n9NDGWqzre6mS2vrzkajGMI6iwI0VkxUhsHE9Ux83Z7/D7n
	 7mYsD5wZjn79tFxtsAhm5/mE1b7NfDqhniL0v4ZY=
Date: Wed, 18 Jun 2025 15:07:22 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Wu, David" <David.Wu3@amd.com>,
	"Deucher, Alexander" <Alexander.Deucher@amd.com>,
	"Dong, Ruijing" <Ruijing.Dong@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 399/512] drm/amdgpu: read back register after
 written for VCN v4.0.5
Message-ID: <2025061834-cradle-designate-edbb@gregkh>
References: <20250617152419.512865572@linuxfoundation.org>
 <20250617152435.755793153@linuxfoundation.org>
 <8327c670-2252-4b02-bab0-e0ab9bb47645@amd.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8327c670-2252-4b02-bab0-e0ab9bb47645@amd.com>

On Tue, Jun 17, 2025 at 04:52:16PM +0000, Limonciello, Mario wrote:
> On 6/17/25 10:26 AM, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: David (Ming Qiang) Wu <David.Wu3@amd.com>
> > 
> > [ Upstream commit 07c9db090b86e5211188e1b351303fbc673378cf ]
> > 
> > On VCN v4.0.5 there is a race condition where the WPTR is not
> > updated after starting from idle when doorbell is used. Adding
> > register read-back after written at function end is to ensure
> > all register writes are done before they can be used.
> > 
> > Closes: https://gitlab.freedesktop.org/mesa/mesa/-/issues/12528
> > Signed-off-by: David (Ming Qiang) Wu <David.Wu3@amd.com>
> > Reviewed-by: Mario Limonciello <mario.limonciello@amd.com>
> > Tested-by: Mario Limonciello <mario.limonciello@amd.com>
> > Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
> > Reviewed-by: Ruijing Dong <ruijing.dong@amd.com>
> > Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
> > Stable-dep-of: ee7360fc27d6 ("drm/amdgpu: read back register after written for VCN v4.0.5")
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > ---
> >   drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c | 8 ++++++++
> >   1 file changed, 8 insertions(+)
> > 
> > diff --git a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
> > index e0b02bf1c5639..db33a2b9109aa 100644
> > --- a/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
> > +++ b/drivers/gpu/drm/amd/amdgpu/vcn_v4_0_5.c
> > @@ -985,6 +985,10 @@ static int vcn_v4_0_5_start_dpg_mode(struct amdgpu_device *adev, int inst_idx, b
> >   			ring->doorbell_index << VCN_RB1_DB_CTRL__OFFSET__SHIFT |
> >   			VCN_RB1_DB_CTRL__EN_MASK);
> >   
> > +	/* Keeping one read-back to ensure all register writes are done, otherwise
> > +	 * it may introduce race conditions */
> > +	RREG32_SOC15(VCN, inst_idx, regVCN_RB1_DB_CTRL);
> > +
> >   	return 0;
> >   }
> >   
> > @@ -1169,6 +1173,10 @@ static int vcn_v4_0_5_start(struct amdgpu_device *adev)
> >   		fw_shared->sq.queue_mode &= ~(FW_QUEUE_RING_RESET | FW_QUEUE_DPG_HOLD_OFF);
> >   	}
> >   
> > +	/* Keeping one read-back to ensure all register writes are done, otherwise
> > +	 * it may introduce race conditions */
> > +	RREG32_SOC15(VCN, i, regVCN_RB_ENABLE);
> > +
> 
> The scope of this change is incorrect.  It should be in the for loop above.
> 
> IE here:
> 
> 	for (i = 0; i < adev->vcn.num_vcn_inst; ++i) {
> 
>  >>>>>>>>

Yeah, something went really wrong here, these were 3 "dep-of" patches
without the actual commit in the tree.  And I think it's just referring
to itself due to the broken DRM tree way of having duplicate git ids for
the same change.

I've dropped this, and the 2 previous patches in the series now, thanks.

greg k-h
