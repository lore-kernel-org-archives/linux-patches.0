Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43C962236F7
	for <patches@lists.linux.dev>; Tue,  7 Apr 2026 03:38:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.9.28.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775533105; cv=none; b=emXx+7MDyTzBZHknVFxKM44mD1v3LmBuwJmRzD7sGAJNEfhk/+HstZou9yS15ua4MhNLdDBlQ0dTQcVYrUNi0DxgCa4HaB45BRKZ0hn3Van32pnW6Xvm+xuCbZploJ2EY2Fo+m5HidoijV4jPFvU7NIEZkr0HztG8hFmbOox2Ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775533105; c=relaxed/simple;
	bh=XwUuTbs1hAhlLyoECrrFP0mApSwcp7K4Dx5DRnt0ErE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VteNb2FbGfhaqg0OwS88wf3YIM4kjKBH7rsZTMv+iiYkXdTg1epGjno/S6RYnxHVTYADR+rNSIQhksyY5dtqBwQux/IZYAOTXACKKkyqrnPX31GqJXk8c0lpW3fB+HNvEW4NwYX6GWYm0dQLr4TwF5Dg7K/5pHVHLr/iQRUH/Co=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu; spf=pass smtp.mailfrom=mit.edu; dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b=M2+nCCPP; arc=none smtp.client-ip=18.9.28.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mit.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mit.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mit.edu header.i=@mit.edu header.b="M2+nCCPP"
Received: from macsyma.thunk.org (pool-173-48-116-90.bstnma.fios.verizon.net [173.48.116.90])
	(authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
	by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 6373bAHJ000597
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Mon, 6 Apr 2026 23:37:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
	t=1775533039; bh=Ef29MIXHmCFvXd7qD+8FbEPi4SrYNu9WMXc8RtIZ9HY=;
	h=Date:From:Subject:Message-ID:MIME-Version:Content-Type;
	b=M2+nCCPPwgabng56tJINbLlAugGW/3OSGVRV32qonNkRy/f491qWZhiSSbYkUVUtB
	 5FDVVJbHLCtjs3FCt/S6ZYTtZ0Ol4YszrhIu+/27svn+1DEko8eWD5mT8AEIXs1QB3
	 VYWWy8DnuykScDM84UD3d4xKEeZt2dfJ1Mz5rmxFn01smslA8f4182i2D1VbkSWZs8
	 H0QHXhI9pXVvm6ruVYawSVd5hmp94o33uIKjxaQS27ak4QgQB6k1nAm4UbdMCagpB8
	 LZee1GIWyFVpc4obSuMNRGx9pXX9n+NfkCJRvJ5ej53wuI1tUYoev4HuM94EHg/o4i
	 LvLYa9Mgec3Nw==
Received: by macsyma.thunk.org (Postfix, from userid 15806)
	id 3A792621DF6A; Mon,  6 Apr 2026 23:37:10 -0400 (EDT)
Date: Mon, 6 Apr 2026 23:37:10 -0400
From: "Theodore Tso" <tytso@mit.edu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Mark Brown <broonie@kernel.org>, Jan Kara <jack@suse.cz>,
        Francesco Dolcini <francesco@dolcini.it>,
        Brian Foster <bfoster@redhat.com>,
        Yongjian Sun <sunyongjian1@huawei.com>,
        Matthew Wilcox <willy@infradead.org>, Gou Hao <gouhao@uniontech.com>,
        Kemeng Shi <shikemeng@huaweicloud.com>, Zhang Yi <yi.zhang@huawei.com>,
        Baokun Li <libaokun1@huawei.com>, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
        conor@kernel.org, hargar@microsoft.com, achill@achill.org,
        sr@sladewatkins.com
Subject: Re: [PATCH 6.1 000/481] 6.1.167-rc1 review
Message-ID: <20260407033710.GA12536@macsyma-wired.lan>
References: <20260323134525.256603107@linuxfoundation.org>
 <20260324073447.GA5062@francesco-nb>
 <mhqesgj3u7dr33zit6iwjhykw2zpuallru4qvoloyyqzdqgvki@bpwwmihh357r>
 <d8080343-20cd-4a4a-b726-b9e3c6a5c5eb@sirena.org.uk>
 <20260325035931.GC61656@mac.lan>
 <2026032535-casino-cable-e039@gregkh>
 <20260325131110.GC2107@macsyma.local>
 <2026032547-spleen-mortify-1cf9@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026032547-spleen-mortify-1cf9@gregkh>

On Wed, Mar 25, 2026 at 02:31:28PM +0100, Greg Kroah-Hartman wrote:
> > Thanks!  Just as another heads up, I decided to run a full regression
> > test suite on 6.1.167-rc1 with those three reverts, and there ar still
> > some crashes with generic/051 and ext4/039:
> > 
> > ext4/4k: 711 tests, 1 errors, 83 skipped, 4645 seconds
> >   Errors: generic/051
> > ext4/1k: 636 tests, 7 failures, 1 errors, 78 skipped, 5612 seconds
> >   Errors: ext4/039
> > ....

> > I'll start trying to bisect this as I have time today.  Are you going
> > to put out another rc and restart the 48 hour testing clock?
> 
> No, I've already done a release, I dropped more than just those 3, I
> dropped all the dependent ext4 patches.
> 
> If you could test the last release and if I should do any reverts there,
> please let me know.

I finally got around to doing the bisect, and found the guilty commit:

# first bad commit: [b6a01b66cdaa2da526b512fc0f9938ea5d6c7a1c] ext4: get rid of ppath in ext4_ext_insert_extent()

As it turns out, this is one of (5!) prerequisite commits needed for
commit 1606176c5c6c ("ext4: subdivide EXT4_EXT_DATA_VALID1").  And
unfortunately, commit 1606176c5c6c doesn't revert cleanly.

... and with that, I've exhausted my available time to support ext4 on
an ancient 6.1 LTS kernel.  I will note that I'm no longer regularly
running ext4 regression tests on 6.1.  (I stopped last year, when 6.18
got elevanted to be the YE2025 LTS kernel, since I only have bandwidth
to evaluate the regression test results of 3 LTS kernels.)

So if there's someone who is willing to the ext4 LTS 6.1 stable
maintainer, I wonder if we should just stop trying to backport ext4
fixes to 6.1 LTS, lest that attempts to backport patches all the way
to 6.1 might result in more bug escapes.  If someone is interested in
applying for the job, and/or working on figuring out how to revert
these commits, please let me know:

1606176c5c6c - ext4: subdivide EXT4_EXT_DATA_VALID1 (13 days ago)
  4d03e2046f73 - ext4: get rid of ppath in ext4_split_extent_at() (13 days ago)
  b6a01b66cdaa - ext4: get rid of ppath in ext4_ext_insert_extent() (13 days ago
)
  15908fc35056 - ext4: get rid of ppath in ext4_ext_create_new_leaf() (13 days a
go)
  b5a010bc7dba - ext4: get rid of ppath in ext4_find_extent() (13 days ago)
  bfe24a48c1d5 - ext4: make ext4_es_remove_extent() return void (13 days ago)

       	       	    			    	   - Ted
							   
git bisect start
# status: waiting for both good and bad commits
# good: [f2ddafa93a259310ca47507153b7811ec54ab7fd] Linux 6.1.166
git bisect good f2ddafa93a259310ca47507153b7811ec54ab7fd
# status: waiting for bad commit, 1 good commit known
# bad: [1989cd3d56e257c783ac75200496a2341b50599c] Linux 6.1.167
git bisect bad 1989cd3d56e257c783ac75200496a2341b50599c
# bad: [7507fbaf81dab28d1d27216c533e228894e9d1f6] parisc: Check kernel mapping earlier at bootup
git bisect bad 7507fbaf81dab28d1d27216c533e228894e9d1f6
# bad: [30752d8bbd149abce36f37e83b89bd2934bfa33c] bpf: export bpf_link_inc_not_zero.
git bisect bad 30752d8bbd149abce36f37e83b89bd2934bfa33c
# bad: [6458b4908489029bc3bb3c0a7c2fc5cb0c2893f3] ALSA: hda/conexant: Fix headphone jack handling on Acer Swift SF314
git bisect bad 6458b4908489029bc3bb3c0a7c2fc5cb0c2893f3
# good: [5135f242e01e8fd602211703e94171b85bb87d4f] KVM: x86: Return "unsupported" instead of "invalid" on access to unsupported PV MSR
git bisect good 5135f242e01e8fd602211703e94171b85bb87d4f
# bad: [1606176c5c6c323167dcd7d4b4f7212b2c8d3d13] ext4: subdivide EXT4_EXT_DATA_VALID1
git bisect bad 1606176c5c6c323167dcd7d4b4f7212b2c8d3d13
# good: [b5452125f9bd60f90f06da080d3eb18445c61d24] drm/tegra: dsi: fix device leak on probe
git bisect good b5452125f9bd60f90f06da080d3eb18445c61d24
# good: [b5a010bc7dba7e3d0966c0231335ca76b3f8780e] ext4: get rid of ppath in ext4_find_extent()
git bisect good b5a010bc7dba7e3d0966c0231335ca76b3f8780e
# bad: [b6a01b66cdaa2da526b512fc0f9938ea5d6c7a1c] ext4: get rid of ppath in ext4_ext_insert_extent()
git bisect bad b6a01b66cdaa2da526b512fc0f9938ea5d6c7a1c
# good: [15908fc35056e9a6fd71552eda884a353496e6c7] ext4: get rid of ppath in ext4_ext_create_new_leaf()
git bisect good 15908fc35056e9a6fd71552eda884a353496e6c7
# first bad commit: [b6a01b66cdaa2da526b512fc0f9938ea5d6c7a1c] ext4: get rid of ppath in ext4_ext_insert_extent()
