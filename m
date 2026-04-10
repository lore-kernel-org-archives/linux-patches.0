Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E043D75C8;
	Fri, 10 Apr 2026 14:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775832533; cv=none; b=IRDo0AP1S9DHJ6U1TaoxvK3e2JM1Vr6sUyESZXvTjXY6Pc/mMSoOtOzHGvXp9/ulXLIjsayotyMWosDb2aRVSps8rsfkRAys2bnwBMtVMSpcnmlWt+Bv9P8aI8axk6etPvKlmylGRbzJQ4JxE3iHlnNF8KNLOTwKVMO/BY/Vt4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775832533; c=relaxed/simple;
	bh=iS9X+PadMq2+8B05uaJAJuX8TQ4CC9n5eOBJVk/iMek=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ao3zrwfa+GlfSi0mudf7+5ZjRoevNQsHcneoD8Xl2iNuCLFVtHbA4zSVClUOSZVkSTq1l1i61Ul3UUwIHSpEbz/ot8C4JU1SQ1NMGYUzIYch7mHiRgigLvLa0QKKRNzoWxLEcdLlEm9Dny1NTwNdAGd15+/nS4PIlvr+ikiLbQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GQoW0bq2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GQoW0bq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD473C19421;
	Fri, 10 Apr 2026 14:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775832533;
	bh=iS9X+PadMq2+8B05uaJAJuX8TQ4CC9n5eOBJVk/iMek=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=GQoW0bq2V4bpJb/R5rId796pdq4fZFG7P7eisdpYxNigWvisEZ4RPujpZTICWsjXD
	 jkA1wwg6Ljld2rqCrn8bmRZxQlYknRsetAWprxIsKBZc70axUMoxfP7Jo336dau2JC
	 YugqYhg7comKHNpN6SAyhW7eNuWeEzSq+oA6et0uEygJitjJxA+gAgR7/TXVa1X8Hl
	 uIfUmP5DUCo7mLCVspweCqCFjmKDirj7DfRFoi45DoJLe5is3ESRe9AsmjIu8C6gDV
	 uPthpcJNyRn72l8PTNxCh9fQwyM3eHvntzvnOiozO7ZC/VuYh0qebOpbi1cDwGUG27
	 aZQ23nALVIiUA==
Date: Fri, 10 Apr 2026 10:48:51 -0400
From: Konstantin Ryabitsev <mricon@kernel.org>
To: Sasha Levin <sashal@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	stable@vger.kernel.org, patches@lists.linux.dev, Jason Gunthorpe <jgg@nvidia.com>, 
	Kevin Tian <kevin.tian@intel.com>, Alex Williamson <alex.williamson@redhat.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Tugrul Kukul <tugrul.kukul@est.tech>, 
	Florian Fainelli <florian.fainelli@broadcom.com>, "Pavel Machek (CIP)" <pavel@denx.de>, Ron Economos <re@w6rz.net>, 
	"Justin M. Forbes" <jforbes@fedoraproject.org>, Mark Brown <broonie@kernel.org>, 
	Conor Dooley <conor.dooley@microchip.com>, Jon Hunter <jonathanh@nvidia.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Peter Schneider <pschneider1968@googlemail.com>, 
	Alex Williamson <alex@shazbot.org>
Subject: Re: [PATCH 6.6 111/160] vfio: Create vfio_fs_type with inode per
 device
Message-ID: <20260410-sceptical-astonishing-ape-c28922@lemur>
References: <20260408175913.177092714@linuxfoundation.org>
 <20260408175917.326372651@linuxfoundation.org>
 <2026040839-around-uplifting-b023@gregkh>
 <adbXkABn-NDAvX4S@laps>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <adbXkABn-NDAvX4S@laps>

On Wed, Apr 08, 2026 at 06:32:48PM -0400, Sasha Levin wrote:
> Argh... I switched to using b4 to pick up backports that folks send on the
> mailing list. Looks like it picks up trailers from unrelated messages...

It will pick up all trailers sent to that patch, matching it by patch-id. You
can see where every trailer came from if you run "b4 -d". E.g.:

  ✓ [PATCH 4/4] fork: defer linking file vma until vma is fully initialized
    + Tested-by: Mark Brown <broonie@kernel.org> (✓ DKIM/kernel.org)
      origin: 9716b9fa-132f-415a-8998-89d6d032dd73@sirena.org.uk
    + Tested-by: Ron Economos <re@w6rz.net> (✗ DKIM/w6rz.net)
      origin: 76dff695-827c-419d-990b-5b7845a46c3f@w6rz.net
    + Tested-by: Florian Fainelli <florian.fainelli@broadcom.com> (✗ DKIM/gmail.com)
      origin: 304e55c8-7e0f-49b3-b952-17c14dd79201@gmail.com
    + Tested-by: Peter Schneider <pschneider1968@googlemail.com> (✓ DKIM/googlemail.com)
      origin: 80c1d385-b3ec-4960-b119-b5cb2b209d9b@googlemail.com
    + Tested-by: Miguel Ojeda <ojeda@kernel.org> (✓ DKIM/kernel.org)
      origin: 20260409154435.33340-1-ojeda@kernel.org
    + Tested-by: Francesco Dolcini <francesco.dolcini@toradex.com> (✓ DKIM/dolcini.it)
      origin: 20260409073909.GA32276@francesco-nb
    + Tested-by: Jon Hunter <jonathanh@nvidia.com> (✓ DKIM/nvidia.com)
      origin: 8a6c3a22-4eca-4310-bdc7-7ae65b78f72e@drhqmail202.nvidia.com
    + Tested-by: Shung-Hsi Yu <shung-hsi.yu@suse.com> (✓ DKIM/suse.com)
      origin: dozxr24wmpnj4k72ojbvtnhdgi4ekkgkfjdf6xaj7eoupboyg4@vnefmfsdk35m
    + Tested-by: Shuah Khan <skhan@linuxfoundation.org> (✓ DKIM/linuxfoundation.org)
      origin: 91e440e7-620a-4166-8453-a8195b8c4913@linuxfoundation.org
    + Acked-by: Alex Williamson <alex@shazbot.org> (✗ DKIM/shazbot.org)
      origin: 20260407121605.17eb56d1@shazbot.org

Looks like a lot of these came in response to stable review requests, sent to
the cover letter.

This is generally the desired behaviour for b4 -- if someone sent a trailer to
a patch, we want to reflect it even if it was received for a previous revision
or when the patch was posted as part of a different series.

I'm happy to make more nuanced exceptions for special-case situations like
stable reviews.

-- 
KR
