Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36EFD211F;
	Fri,  5 Sep 2025 05:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757048864; cv=none; b=Lh1qQfeMO6/Mx8jC9ZnEO409Yge/vHvoclzg4XPTUQih0nPiITU5cP0iLhb82Ojbn0km2VpJuwMytFA1NBtFwIU+mPNba5seYoonj+8exSfc9LjifDf6ZrVz2IxYL+JXwPsgCOcGxX5XjNMAzovMdYGeA+zkWp7lxvfnd1XxT6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757048864; c=relaxed/simple;
	bh=Ink7x/UMnv0pA1jyrItyKela2fO1SaLcgrzgep4j6wQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UFOmkFFxPEDZ+/93mYXpudK3pwaakb36E7o4gfFsJ7ueVcvV4JheDsYATa+oCeyKlScqotSR182BmfHFDbknxCoaOdMaYLpVbjJT0dIgqXxdpbWKGCBDi5svX1OrvSK9ZIcnGiRaou/q3ZC5eH68shfBl3k+pQILCJ6nsnNTznM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PKZt52X2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PKZt52X2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5A2C4CEF1;
	Fri,  5 Sep 2025 05:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1757048863;
	bh=Ink7x/UMnv0pA1jyrItyKela2fO1SaLcgrzgep4j6wQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PKZt52X2nhRDZT2WTYCyzMa4pjKmL0t/psW5LPAH/Uyo9R00uWucciWf11UoKD82c
	 POVPQtfesmATN06YTys8w82ZLbD5sJFTCoDMvd5sMilc7TrJIkzkHE3o8AhYBszR6p
	 dyVFY9aoLZeXW+CuaQOLlTSzx9GJWn1i52Lpuwaw=
Date: Fri, 5 Sep 2025 07:07:40 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Imre Deak <imre.deak@intel.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.16 139/142] Revert "drm/dp: Change AUX DPCD probe
 address from DPCD_REV to LANE0_1_STATUS"
Message-ID: <2025090551-setup-crescent-a670@gregkh>
References: <20250902131948.154194162@linuxfoundation.org>
 <20250902131953.603872091@linuxfoundation.org>
 <aLoJG4Tq4nNwFLu6@ideak-desk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aLoJG4Tq4nNwFLu6@ideak-desk>

On Fri, Sep 05, 2025 at 12:48:11AM +0300, Imre Deak wrote:
> Hi Greg,
> 
> On Tue, Sep 02, 2025 at 03:20:41PM +0200, Greg Kroah-Hartman wrote:
> > 6.16-stable review patch.  If anyone has any objections, please let me know.
> 
> Thanks for queuing this and the corresponding reverts for the other
> stable trees. This one patch doesn't match what I sent, the address
> should be changed to DP_TRAINING_PATTERN_SET not to DP_DPCD_REV, see
> [1]. I still think that's the correct thing to do here conforming to the
> DP Standard and matching what the upstream kernel does, also solving a
> link training issue for a DP2.0 docking station.
> 
> The reverts queued for the other stable trees are correct, since for
> now I do not want to change the behavior in those (i.e. those trees
> should continue to use the DP_DPCD_REV register matching what's been the
> case since the DPCD probing was introduced).

Ick, why were the values different for different branches?  That feels
wrong, and is why I missed that.  Can you just send a fix-up patch for
the one I got wrong?

thanks,

greg k-h
