Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 103BC1DFE36;
	Wed, 19 Feb 2025 13:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739971352; cv=none; b=fP4a4iX2qiu81Huy5VSEqaH2198JyqtwyYgGdN8qm86jC8Nzdbtc4AYsnXBZU2xEdDKiCesa6txqbjU3FBMLQsIX9uvqHZ8g2Ixo+/eAfg3qnfk/BAaUYMVDfzQ/RNeCIUk7MCpUdUdS33Rj43jIHDQhyeS2laoNqiK9uvYRVm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739971352; c=relaxed/simple;
	bh=AE3t/HF1Ep1DcA8Mtk0eFAj43zj1QAw0T/jQT4X0X7A=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NgUQRu1MGGfITiPhcr05NHSCK+ve7kMcnL62svT/iXxaChzusZByNT+4v/rl/zt6cBq+cswU8EDEudaR0WHq7EegkfXLiNpEtz+G1/4Cp+m6ncvsy9VPeDjHj/BqrXeGGAeZXW+4RCZAtJMqwlHUsk0TWmI24kvQVCOaUcvYhCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jsZOjSK9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jsZOjSK9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33C4DC4CED1;
	Wed, 19 Feb 2025 13:22:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739971351;
	bh=AE3t/HF1Ep1DcA8Mtk0eFAj43zj1QAw0T/jQT4X0X7A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jsZOjSK926pb7DhIO9tuLRXqqyC6Jzh4UL2vaQn/PpJIOK/Wghc/YhKepPrBSgIys
	 lQTpSydG6/Bs18svCVKCKpi8ka6OoBNZNpEIJzWqd9jKWPk5T1VsfEz27++CGr8h69
	 d5Twdt/1K+AfZnhGbRfW18ctiFTwCnwIO5X4CSyc=
Date: Wed, 19 Feb 2025 14:22:28 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Deucher, Alexander" <Alexander.Deucher@amd.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	"Lazar, Lijo" <Lijo.Lazar@amd.com>
Subject: Re: [PATCH 6.13 117/274] drm/amdgpu: bump version for RV/PCO compute
 fix
Message-ID: <2025021920-sports-zipping-3dd8@gregkh>
References: <20250219082609.533585153@linuxfoundation.org>
 <20250219082614.200745355@linuxfoundation.org>
 <BL1PR12MB51448EAD680DD8D7EF63DC09F7C52@BL1PR12MB5144.namprd12.prod.outlook.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BL1PR12MB51448EAD680DD8D7EF63DC09F7C52@BL1PR12MB5144.namprd12.prod.outlook.com>

On Wed, Feb 19, 2025 at 01:06:34PM +0000, Deucher, Alexander wrote:
> [Public]
> 
> > -----Original Message-----
> > From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Sent: Wednesday, February 19, 2025 3:26 AM
> > To: stable@vger.kernel.org
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>; patches@lists.linux.dev;
> > Lazar, Lijo <Lijo.Lazar@amd.com>; Deucher, Alexander
> > <Alexander.Deucher@amd.com>
> > Subject: [PATCH 6.13 117/274] drm/amdgpu: bump version for RV/PCO compute
> > fix
> >
> > 6.13-stable review patch.  If anyone has any objections, please let me know.
> 
> 
> Please drop this one from all stable trees.  It has a dependency on another patch that was dropped due to needing a stable specific backport.  I'll include it with the backport.

Now dropped, thanks.

greg k-h
