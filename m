Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 980E21448D9;
	Tue, 25 Jun 2024 20:12:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719346320; cv=none; b=H4rycEGp1JqJsy1cVRa/uBijEEkDqapmhr/6KGvKMTxzNiKbspsCl1wkyyS+0TwmfeKG1BR2GKn7jUzttN8hN0PrODgk4SKF0XToMr+SKUgWunl/fCGstbZO9lj1/2/URGnVeaDfRMJ1qPGwv6OXbfzytkjWeqGdT0aazuVw6MA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719346320; c=relaxed/simple;
	bh=Dy/Nt2MgK+HavWw4n2GQy8JA0N7lu53sTzJ5aIyv+Bg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rqzc0SRas0NZATme02T11mexf84xzL2RJi5zFPcTy5lb70eXqelb+CrTo71bY2IlQcSZ9+9kANbOS7NIa6eCgn2uuJQrSCxRBp4otzOUTDrwNXuw3EuV4BX2iOA59NgoI7yJAE2lUqTrIWGsBgvCmUU5pk9xpZVNmfI64Q724vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pXHdDD/v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pXHdDD/v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68E6BC32781;
	Tue, 25 Jun 2024 20:11:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719346320;
	bh=Dy/Nt2MgK+HavWw4n2GQy8JA0N7lu53sTzJ5aIyv+Bg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pXHdDD/vqbC+eJJOz69Hdmxv9C1Bme2Vkn1MMlBTrXqLTyn9su4ka4E3oYQYtdvU9
	 YR9zGENAEWjMWZzN3xbbX6j/FJH0cvjTKsvYpms3nj82R559k3lks842BfVYqE6nuY
	 8Zw4aFWYKUeWNwuOsB+h25iEC+r09qmjNO9F93AY=
Date: Tue, 25 Jun 2024 22:12:05 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>, Dave Airlie <airlied@gmail.com>,
	"Vetter, Daniel" <daniel.vetter@intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	tursulin@ursulin.net, Francois Dugast <francois.dugast@intel.com>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	Matthew Brost <matthew.brost@intel.com>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: Re: [PATCH 6.9 073/281] drm/xe: Use ordered WQ for G2H handler
Message-ID: <2024062517-elderly-rocky-cb20@gregkh>
References: <20240619125609.836313103@linuxfoundation.org>
 <20240619125612.651602452@linuxfoundation.org>
 <ZnLlMdyrtHEnrWkB@fdugast-desk>
 <2024061946-salvaging-tying-a320@gregkh>
 <ZnqyFRf9zPa4kfwL@intel.com>
 <2024062502-corporate-manned-1201@gregkh>
 <87ed8ldwjv.fsf@intel.com>
 <2024062537-panorama-sled-3025@gregkh>
 <ZnsUKiEiZEACancl@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ZnsUKiEiZEACancl@intel.com>

On Tue, Jun 25, 2024 at 03:02:02PM -0400, Rodrigo Vivi wrote:
> > > >> > 
> > > >> > > > (cherry picked from commit 50aec9665e0babd62b9eee4e613d9a1ef8d2b7de)
> > > >> > 
> > > >> > Would help out here, but it doesn't.  
> > > >> 
> > > >> I wonder if there would be a way of automate this on stable scripts
> > > >> to avoid attempting a cherry pick that is already there.
> > > >
> > > > Please tell me how to do so.
> > > >
> > > >> But I do understand that any change like this would cause a 'latency'
> > > >> on the scripts and slow down everything.
> > > >
> > > > Depends, I already put a huge latency on drm stable patches because of
> > > > this mess.  And I see few, if any, actual backports for when I report
> > > > FAILED stable patches, so what is going to get slower than it currently
> > > > is?
> 
> My thought was on the stable scripts doing something like that.
> 
> For each candidate commit, check if it has the tag line
> (cherry picked from commit <original-hash>)

Right there, that fails with how the drm tree works.  So you are going
to have to come up with something else for how to check this.  Or fix
your process to make this work.

Look at the commits tagged for stable in the -rc1 merge window.  They
don't have the "cherry picked" wording as they were not cherry picked!
They were the "originals" that were cherry picked from.

> if so, then something like:
>  if git rev-parse --quiet --verify <original-hash> || \
>     git log --grep="cherry picked from commit <original-hash> -E --oneline >/dev/null; then
>             echo "One version of this patch is already in tree. Skipping..."
> 	    # send-email?!
>         else
>             #attempt to apply the candidate commit...
> 
> > > > Normally you all tag these cherry-picks as such.  You didn't do that
> > > > here or either place, so there was no way for anyone to know.  Please
> > > > fix that.
> 
> I'm afraid this is not accurate. Our tooling is taking care of that for us.

Then your tooling needs to be fixed.

> > > To be fair, this one seems to have been an accident. The same commit was
> > > cherry-picked to *two* different branches by two different people
> > > [1][2], and this is something we try not to do. Any cherry-picks should
> > > go to one tree only, it's checked by our scripts, but it's not race free
> > > when two people are doing this roughly at the same time.
> 
> Also I don't believe there's anything wrong here. It was a coincidence on
> the timing, but one is
> drm-xe-next-fixes-2024-05-09-1
> and the other
> drm-xe-fixes-2024-05-09
> 
> both maintained by different people at that time.
> 
> > 
> > any cherry-pick SHOULD have the git id referenced when they are
> > cherry-picked, that's what the id is there for.  Please always do that.
> 
> Original commit hash is 50aec9665e0babd62b9eee4e613d9a1ef8d2b7de
> 50aec9665e0b ("drm/xe: Use ordered WQ for G2H handler")

And that's not in Linus's tree.

> drm-xe-next-fixes-2024-05-09-1
> has commit 2d9c72f676e6 ("drm/xe: Use ordered WQ for G2H handler")
> which contains:
> (cherry picked from commit 50aec9665e0babd62b9eee4e613d9a1ef8d2b7de)
> Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
> 
> drm-xe-fixes-2024-05-09
> has commit c002bfe644a2 ("drm/xe: Use ordered WQ for G2H handler")
> which contains:
> (cherry picked from commit 50aec9665e0babd62b9eee4e613d9a1ef8d2b7de)
> Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>

Ok, but again, the original is not in Linus's tree.

So how am I do know that the cherry picked line was already in the tree?
Added it twice is odd, but really, that's not the common failure here at
all.  The real problem is the -rc1 window where there is NOT a commit id
that can be matched up with (as it happening with a few commits here,
and with lots of AMD patches now.)

thanks,

greg k-h
