Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61BD625774;
	Sun, 11 Aug 2024 10:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723371289; cv=none; b=SWd2M1OOcYZAcBFxRdQVRCFboptBRQUgX4MpyVs9F/rkdP1ouaQ6RAjEIFkPOKXWanwLroEw/DOCWIKgpkBKQpUGhpIS6jHC8d/htiiproPt8Z4zkEMy+TP/KEbusxZCcjgcsQroBLPAIeB0dBpZ+QR6TL4cr8DuNS+GAPwkdKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723371289; c=relaxed/simple;
	bh=Ys2xZRQLEQ80J6XX4GeFDWVO9pFKSSZFUOFsKJMairY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ljhANtH6zJ2am02hAzrwL/NF7PRav7i0jIq9y96tTIxgKdLXjWrwvceFvZJZi8T7ZFtFP0ZmMxZhdWl+ZIJbwdQaKshFe902arclWet2I90GGJINqDuNtH9oxpmwUjBJd+11ql/bNked1O0PDEX53ZMvwTStRDkVZrPLJF56VdA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RWJWX60A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RWJWX60A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1595CC32786;
	Sun, 11 Aug 2024 10:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723371288;
	bh=Ys2xZRQLEQ80J6XX4GeFDWVO9pFKSSZFUOFsKJMairY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=RWJWX60A7Qu7gMO1UGhu1+x0tyMZNl3vjzqnZg9rUi+we7eTkl+eqU5XhG5Kwvgba
	 Y7qCqSyjtLu2LKOB3T2EjzNEnceIMpV6hY8TQ1hbVIaUks8vR+l+1AA/YZsyw6fBrA
	 l6zjZkS9oYboXvnMZy1qdOEFZmOMKm4yLbtTPhY0=
Date: Sun, 11 Aug 2024 12:14:44 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ron Economos <re@w6rz.net>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
Subject: Re: [PATCH 6.1 00/86] 6.1.104-rc2 review
Message-ID: <2024081131-punch-uninvited-9557@gregkh>
References: <20240808091131.014292134@linuxfoundation.org>
 <96b86f9b-c516-9742-5e33-e5cbfbed10b3@w6rz.net>
 <c4b1489f-42b8-8c16-f487-93b0dd8cd8c4@w6rz.net>
 <b6caeb4b-116e-068c-440d-7489ce7e8af3@w6rz.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b6caeb4b-116e-068c-440d-7489ce7e8af3@w6rz.net>

On Thu, Aug 08, 2024 at 09:45:57AM -0700, Ron Economos wrote:
> On 8/8/24 7:43 AM, Ron Economos wrote:
> > On 8/8/24 4:55 AM, Ron Economos wrote:
> > > On 8/8/24 2:11 AM, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 6.1.104 release.
> > > > There are 86 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Sat, 10 Aug 2024 09:11:02 +0000.
> > > > Anything received after that time might be too late.
> > > > 
> > > > The whole patch series can be found in one patch at:
> > > >     https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.104-rc2.gz
> > > > 
> > > > or in the git tree and branch at:
> > > >     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > > > linux-6.1.y
> > > > and the diffstat can be found below.
> > > > 
> > > > thanks,
> > > > 
> > > > greg k-h
> > > > 
> > > I'm seeing a build failure.
> > > 
> > > sound/pci/hda/patch_conexant.c:273:10: error: ‘const struct
> > > hda_codec_ops’ has no member named ‘suspend’
> > >   273 |         .suspend = cx_auto_suspend,
> > >       |          ^~~~~~~
> > > sound/pci/hda/patch_conexant.c:273:20: error: initialization of
> > > ‘void (*)(struct hda_codec *, hda_nid_t,  unsigned int)’ {aka ‘void
> > > (*)(struct hda_codec *, short unsigned int,  unsigned int)’} from
> > > incompatible pointer type ‘int (*)(struct hda_codec *)’
> > > [-Werror=incompatible-pointer-types]
> > >   273 |         .suspend = cx_auto_suspend,
> > >       |                    ^~~~~~~~~~~~~~~
> > > sound/pci/hda/patch_conexant.c:273:20: note: (near initialization
> > > for ‘cx_auto_patch_ops.set_power_state’)
> > > sound/pci/hda/patch_conexant.c:274:10: error: ‘const struct
> > > hda_codec_ops’ has no member named ‘check_power_status’; did you
> > > mean ‘set_power_state’?
> > >   274 |         .check_power_status = snd_hda_gen_check_power_status,
> > >       |          ^~~~~~~~~~~~~~~~~~
> > >       |          set_power_state
> > > sound/pci/hda/patch_conexant.c:274:31: error:
> > > ‘snd_hda_gen_check_power_status’ undeclared here (not in a
> > > function); did you mean ‘snd_hda_check_power_state’?
> > >   274 |         .check_power_status = snd_hda_gen_check_power_status,
> > >       | ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> > >       |                               snd_hda_check_power_state
> > > 
> > > This is triggered because my config does not include CONFIG_PM. But
> > > the error is caused by upstream patch
> > > 9e993b3d722fb452e274e1f8694d8940db183323 "ALSA: hda: codec: Reduce
> > > CONFIG_PM dependencies" being missing. This patch removes the #ifdef
> > > CONFIG_PM in the hda_codec_ops structure. So if CONFIG_PM is not
> > > set, some structure members are missing and the the build fails.
> > > 
> > > 
> > Same failure occurs in 6.6.45-rc1 if CONFIG_PM is not set.
> > 
> > 
> Note: Both upstream 9e993b3d722fb452e274e1f8694d8940db183323 "ALSA: hda:
> codec: Reduce CONFIG_PM dependencies" and
> 6c8fd3499423fc3ebb735f32d4a52bc5825f6301 "ALSA: hda: generic: Reduce
> CONFIG_PM dependencies" are required to fix the build if CONFIG_PM is not
> set.

thanks, I have fixed this all now up.

greg k-h
