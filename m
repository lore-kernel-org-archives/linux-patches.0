Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC1C6FB9;
	Sat, 29 Jun 2024 08:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719648455; cv=none; b=tkl+0xxwi9nG/lgB+5JWa6R2oQ2MG4wHym4h132X1MRPZatYaivgKatLyu6jiNkotPd6ZS5rPRIQhpWoIxhoN6XqrF738ib9Uo9NXikvJtvxZNzmMdcETlVKVBy67XOmHoPbAcBmlP2SeY4dGjGQKQnnQYFwH52zKJP0fWXecjA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719648455; c=relaxed/simple;
	bh=HZyRI4VrAeEz1YY6UlpfHipWqgudDrSenhok5CLTIvE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JnAu5LJkfFw45OQSrbQnzx5YQzFKUrn92A2oT2hsh+f2zRKfeCSqwCCgHdTuFX55Z1UsMhvfe9FhvMkKQxt/6sr5/roZUYpRHpJOAfIf/bFseHApO6YbQAWO1SV3eX+47yWq1yRMMuRl36pkdeLVP4lHKCAojKB6ov9Uq1VMrRg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=krT/cYZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="krT/cYZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36CC8C2BBFC;
	Sat, 29 Jun 2024 08:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719648455;
	bh=HZyRI4VrAeEz1YY6UlpfHipWqgudDrSenhok5CLTIvE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=krT/cYZy904cb6qHLyG4jWtZ85weqEZ+mlCsMeDVZnTdScLRw4F6/mwUtvIpGmwce
	 nFPKT7sWgq+mbPkMRchaTDFxER/gI2S72kx1qDq6EGciJ+Y56QLW6TMKtaOWaa2iJA
	 Z5yQ4u67gsSY8jhrreoPVtptz8jQjM3AjBx2EC2A=
Date: Sat, 29 Jun 2024 10:07:29 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc: Eric Woudstra <ericwouds@gmail.com>, stable@vger.kernel.org,
	patches@lists.linux.dev, Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.9 029/250] net: sfp: enhance quirk for Fibrestore 2.5G
 copper SFP module
Message-ID: <2024062902-retrieval-distort-4718@gregkh>
References: <20240625085548.033507125@linuxfoundation.org>
 <20240625085549.174362251@linuxfoundation.org>
 <20240628172211.17ccefe9@dellmb>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20240628172211.17ccefe9@dellmb>

On Fri, Jun 28, 2024 at 05:22:11PM +0200, Marek Behún wrote:
> On Tue, 25 Jun 2024 11:29:47 +0200
> Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> > 6.9-stable review patch.  If anyone has any objections, please let me know.
> 
> Sorry I overlooked this, I thought I already replied to this, but in
> fact I replied to another patch not to be backported:
> 
>   net: sfp: add quirk for another multigig RollBall transceiver
>   https://lore.kernel.org/stable/20240527165441.2c5516c9@dellmb/
> 
> This patch (net: sfp: enhance quirk for Fibrestore 2.5G copper SFP
> module) has the same problem: it depends on the same series, so it
> should not be backported.
> 
> Eric informs me that it was already released as 6.9.7 :-(
> 
> What can we do?

Revert is the best, want to send it or can you wait until Monday when I
can do it (am traveling this weekend).

thanks,

greg k-h
