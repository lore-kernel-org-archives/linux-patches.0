Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6960D1991BD;
	Fri,  8 Nov 2024 16:55:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731084935; cv=none; b=speIbh9LSFKEpij16jOmStJI3OrI2kfiFluGE0X7M9SOuHQpLlFlTRC/BNYXjGVZyQrJjgRF/ee2RMwGE/3lYqnhMi4u6lGviKPhXVD638gvky6WIeIg1EjEJahuOw7AW5qlDWRjiIdYm2UkYs3ru9T5KcrZWFxMWpacBH/cOO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731084935; c=relaxed/simple;
	bh=kICkJghl4CqQ5MV25sHO+sQ4MhXX6W6lZJNTy62c1I0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=knYF4Gcx21K2BGPu8VyCXqnzK0WgGMHJIS2Hmj4gp1ZIoNOlxmmhil4EKdZOSORAOgBCT839fyspsUoXT/GdocbzOrjwjvhLP2m5h5nWAguH2a74ueSCOov8F4geUZiHxf9fZw3xAq8RGWizWj+eyZfLeouNYJ0LeAD4CMHFAhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d4BTTqei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d4BTTqei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A787FC4CECD;
	Fri,  8 Nov 2024 16:55:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1731084933;
	bh=kICkJghl4CqQ5MV25sHO+sQ4MhXX6W6lZJNTy62c1I0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d4BTTqeiIYW6gVnnPCHN6OSIdoa7+aiamxw/x0XPnSje0elpy6fxPKnDrKmIOEgBv
	 /NLEtZONtpvjdPn2nf+iUKAqenZ1uoyq2bX6kdawp3xzhIpgrvE7YNhxDR09iEJICL
	 jvdt2zYGgBFyCE3bdGNlQiW2CFKPsmhAg4nujn+9lcX5iw5PVwsnvWlqsHaeuOyVqn
	 M09qy6R7blBnQ99IlwnoS98dre6aCHiqiSmjHSd2f29cymxPkOfM1MAQHe/EXvaeRg
	 qixMDqJrGAU92L3MVfs5Lpr75b/eoNHlKPE2b1GfuCAbq7Vthtkc7Lvxo84JpFrHhy
	 58MmyoXipJL/g==
Date: Fri, 8 Nov 2024 10:55:32 -0600
From: Rob Herring <robh@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>,
	Stephen Boyd <sboyd@kernel.org>
Cc: Saravana Kannan <saravanak@google.com>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, devicetree@vger.kernel.org,
	kunit-dev@googlegroups.com
Subject: Re: [PATCH] of: Allow overlay kunit tests to run CONFIG_OF_OVERLAY=n
Message-ID: <20241108165532.GA2411452-robh@kernel.org>
References: <20241016212016.887552-1-sboyd@kernel.org>
 <20241017203810.GA814469-robh@kernel.org>
 <38153cbf2616a4a6706412952778eec1.sboyd@kernel.org>
 <CAMuHMdWp84u66Y-ELtbbRmySYwQch_=2qQiXzWJzrSkGeLZYBA@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMuHMdWp84u66Y-ELtbbRmySYwQch_=2qQiXzWJzrSkGeLZYBA@mail.gmail.com>

On Fri, Nov 08, 2024 at 09:56:15AM +0100, Geert Uytterhoeven wrote:
> Hi Stephen,
> 
> On Sat, Oct 19, 2024 at 12:21 AM Stephen Boyd <sboyd@kernel.org> wrote:
> > Quoting Rob Herring (2024-10-17 13:38:10)
> > > On Wed, Oct 16, 2024 at 02:20:15PM -0700, Stephen Boyd wrote:
> > > > Some configurations want to enable CONFIG_KUNIT without enabling
> > > > CONFIG_OF_OVERLAY. The kunit overlay code already skips if
> > > > CONFIG_OF_OVERLAY isn't enabled, so this select here isn't really doing
> > > > anything besides making it easier to run the tests without them
> > > > skipping. Remove the select and move the config setting to the
> > > > drivers/of/.kunitconfig file so that the overlay tests can be run with
> > > > or without CONFIG_OF_OVERLAY set to test either behavior.
> 
> Thanks for your patch, which is now commit 027af8c26fdc0642 ("of: Allow
> overlay kunit tests to run CONFIG_OF_OVERLAY=n") in dt-rh/for-next.
> 
> > > > Fixes: 5c9dd72d8385 ("of: Add a KUnit test for overlays and test managed APIs")
> > >
> > > Doesn't really seem like a fix.
> >
> > Ok. Feel free to drop the tag.
> >
> > > Does this need to go into 6.12?
> >
> > It's only important for 6.12 if kernel configurators want to build the
> > kernel with OF_OVERLAY_KUNIT_TEST enabled and not be forced to enable
> > CONFIG_OF_OVERLAY. I don't mind if it waits a while.
> 
> I'd say it's a fix, so please keep at last the Fixes tag. Merely
> enabling kunit tests (which can be modular) should not increase the
> possible attack vector on a product by enabling extra unneeded code.

Not sure I buy that that is an actual problem. However, not worth 
arguing over. I only really care because if there's a Fixes, then this 
really should go to Linus for 6.12 rather than eventually get 
auto-selected from 6.13 to go to stable. So I moved it to send to Linus, 
but I found that CONFIG_OF_OVERLAY is still selected with this patch. 
That's because the clock kunit tests also select CONFIG_OF_OVERLAY. 
That's fixed in next, but it's not queued up for 6.12.

Rob
