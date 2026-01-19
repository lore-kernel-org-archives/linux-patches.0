Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1CB2276050;
	Mon, 19 Jan 2026 11:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768820720; cv=none; b=RFK55yp9QpmSvn09/KSNGgsMsPsIU4xgqQzK8J6RfeGxz1mBo+52GxUEGOgx6chAQlAOH9WQ0AuH+TZ/JV18/BHHYEk60qYAcXTD6TPyHEDuVhaszTmZzmLWOUvFJ5jsw3XFVU2MGD+juJS1sNAsVlSGTiAy9qc+iKk9Iz5hxYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768820720; c=relaxed/simple;
	bh=a4NQFRwVNmmjBMHSe/Sdrg5TBV7GR/CfR8sVey8BxVg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lDkBCwGLtVECaFDkRvrMzR0U3MJZA+MSFrWmkAHf4EWfQrmU99bvIPwM7fnVTKma4ypJYSkqdw4SZgtTK25ZjgvhqA9fazh5x5nl7KLP7VRyKQ7H9X1dgNYt8K8tTY6rzSv8JCtKFyPwbdojQ7m6mCHiis9qF+GXes4Ao+Irs+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aAtsBZkK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aAtsBZkK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F4166C116C6;
	Mon, 19 Jan 2026 11:05:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768820720;
	bh=a4NQFRwVNmmjBMHSe/Sdrg5TBV7GR/CfR8sVey8BxVg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=aAtsBZkKlo7Bh5JX8W5uU/sv2epZ/7sSg4CmqIquWP++WjdCDbziunIole2iAHGYB
	 6bhOi9IgG1hSBpS28cfa2TkkQKWc4irmDQjTGs2T+ZwyJ8FSiFgzXIX6X4rl0NBOCW
	 DilMCMiJhkKB7rUmgn6ckfS53A7kpKowqtgRH+rE=
Date: Mon, 19 Jan 2026 12:05:17 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Troy Mitchell <troy.mitchell@linux.dev>,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Encrow Thorne <jyc0019@gmail.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 212/451] reset: fix BIT macro reference
Message-ID: <2026011910-ageless-durably-9fd5@gregkh>
References: <20260115164230.864985076@linuxfoundation.org>
 <20260115164238.569421501@linuxfoundation.org>
 <dd71077782437d4517ee09ff7e10abbfc3672ddb.camel@decadent.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd71077782437d4517ee09ff7e10abbfc3672ddb.camel@decadent.org.uk>

On Sat, Jan 17, 2026 at 09:22:15PM +0100, Ben Hutchings wrote:
> On Thu, 2026-01-15 at 17:46 +0100, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Encrow Thorne <jyc0019@gmail.com>
> > 
> > [ Upstream commit f3d8b64ee46c9b4b0b82b1a4642027728bac95b8 ]
> > 
> > RESET_CONTROL_FLAGS_BIT_* macros use BIT(), but reset.h does not
> > include bits.h. This causes compilation errors when including
> > reset.h standalone.
> > 
> > Include bits.h to make reset.h self-contained.
> [...]
> 
> This should have had:
> 
>     Fixes: dad35f7d2fc1 ("reset: replace boolean parameters with flags parameter")
> 
> That commit went into 6.13, so only the 6.18-stable branch needed this.

Now dropped, thanks.

greg k-h
