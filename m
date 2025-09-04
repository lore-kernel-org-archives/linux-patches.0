Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4265271469;
	Thu,  4 Sep 2025 12:05:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756987511; cv=none; b=DjZnUhjUqzElOTnUP3I1iFscAonlv/SSxSQL3fKjs8am3AIwjyelUoUkMMf1ZYM99bjsUbYp3qpwtfeKz/XW2CC2BFcI/ruRJqrwlNJaBJ1bTZz04+JluILTnDh8SdYQ65iXoyyXjaU5RLozFa/t9ZxBxaOc1uzIUqOIAmQZxBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756987511; c=relaxed/simple;
	bh=f/PtkGUUho/vUypI5PNDrwb7DLE9aEAi7b+SZrdBg38=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=geaNoztbUXMNhRFKYmO+WFsAaX/duZ9dLHs15CY2oGqH1PSS7TTWMHwBvJbKbJB55dsYmrffJCTN1tMiD/qYVU7AGga9FpVupwQFXwBVlgtNqz5/NCOwX2KKZ6YW90DuVWoBofUnQN1T4gpT755X4f/Qp0nL8LaVCdIA2fQrDQE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AyGpRLjM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AyGpRLjM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47D8C4CEF1;
	Thu,  4 Sep 2025 12:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756987511;
	bh=f/PtkGUUho/vUypI5PNDrwb7DLE9aEAi7b+SZrdBg38=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=AyGpRLjM5E3S56B3xIptiqaSxDhICCXYklpKdzM+BGxDLtG5W3rb9odLB1kkj4Lnp
	 eudQHFc4oNvm5mqdR+duFejTQQoiihQtKA8wm/iEJiM2OazNoBMvwjYSjw/f21//vy
	 uLTx5DIQIbplczUIJi7YqMzb7uW2bNiZT/xYZvv0=
Date: Thu, 4 Sep 2025 14:05:08 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: =?utf-8?B?TWljaGHFgiBHw7Nybnk=?= <mgorny@gentoo.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Brent Lu <brent.lu@intel.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: Re: [PATCH 5.10 33/34] ASoC: Intel: sof_da7219_mx98360a: fail to
 initialize soundcard
Message-ID: <2025090457-unkind-caviar-4e53@gregkh>
References: <20250902131926.607219059@linuxfoundation.org>
 <20250902131927.927344847@linuxfoundation.org>
 <97d648ff7cea3aecd6c2606ea60edf928e1cf1aa.camel@gentoo.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <97d648ff7cea3aecd6c2606ea60edf928e1cf1aa.camel@gentoo.org>

On Tue, Sep 02, 2025 at 03:52:55PM +0200, Michał Górny wrote:
> On Tue, 2025-09-02 at 15:21 +0200, Greg Kroah-Hartman wrote:
> > 5.10-stable review patch.  If anyone has any objections, please let me know.
> > 
> 
> I think the prerequisite patch is missing (4/5 in my set):
> 
> https://lore.kernel.org/stable/20250901141117.96236-4-mgorny@gentoo.org/T/#u

Ugh, I missed that somehow, thanks!  now queued up.

greg k-h
