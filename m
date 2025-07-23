Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2461426E6E7;
	Wed, 23 Jul 2025 06:41:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753252870; cv=none; b=u9TBLQpIkhGtrJyeGd5o5AsfFVx2WmeWYpcC1ywjvAxuNIbPeC48shot4VU2Y7ZrmZtniL+hxtE9lPJsEosJVoluUFREvsP1vo/Od6dAf6ZJFk7uM2M2JHGHdgzdA9YlrKNYc+QbSNf4iYdhfClHD1Bl30IaJOsUyZPx+54yVTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753252870; c=relaxed/simple;
	bh=CzbSJqERIMrNUoEYj94E3EKV6liM2AWnEKfqqA4iYDA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=muGwNj79yrjwGE8TNbOM3Z8tfvVTpz5fMnlabFVif+ihsyIssMr+Jy1bbAYzv2SPlJJuz4VdO/auC67t+WZEoJ9zS6hz8PIWSLk+D2XHxNtDrYBkfykcD+3OgDDnJzpNL7+CE0fm8Ib9yOhev4UuO095uMvpzfOGghHdAsegY6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qaxow255; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qaxow255"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F1EC4CEE7;
	Wed, 23 Jul 2025 06:41:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753252869;
	bh=CzbSJqERIMrNUoEYj94E3EKV6liM2AWnEKfqqA4iYDA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=qaxow255Ohi+U813h3zP061AkiOyIgjFiP6xWOc8W/7Ev5BM5lBysr2/o1pNmahEN
	 I191EeGlVtsD1vlf5rbQeqUcrOtA1x7zDVdSLapJPFhZW7YZAusl02x3XODD4VA7xx
	 CHW5NP+ae8jKIye34Cmuw9xQUAAmlZMgIVazuquE=
Date: Wed, 23 Jul 2025 08:41:06 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Michael Pratt <mcpratt@pm.me>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>,
	"patches@lists.linux.dev" <patches@lists.linux.dev>,
	INAGAKI Hiroshi <musashino.open@gmail.com>,
	Srinivas Kandagatla <srini@kernel.org>,
	"sashal@kernel.org" <sashal@kernel.org>
Subject: Re: [PATCH 6.6 111/111] nvmem: layouts: u-boot-env: remove crc32
 endianness conversion
Message-ID: <2025072359-deranged-reclining-97ac@gregkh>
References: <20250722134333.375479548@linuxfoundation.org>
 <20250722134337.561185968@linuxfoundation.org>
 <OtYC5V_o5aJvujD0QIBYfFMqHJbKopAZebvBnDZ398q36FII2UJGr-gWv2Z-ogM5GLwXLnmHjT0orC0RyuAbvPYG-P-EP82l14gy4pG7H-w=@pm.me>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <OtYC5V_o5aJvujD0QIBYfFMqHJbKopAZebvBnDZ398q36FII2UJGr-gWv2Z-ogM5GLwXLnmHjT0orC0RyuAbvPYG-P-EP82l14gy4pG7H-w=@pm.me>

On Wed, Jul 23, 2025 at 06:33:10AM +0000, Michael Pratt wrote:
> Hi,
> 
> I don't mean to be nitpicking too hard
> but the manual edit description below would  read better as:
> 
> On 7/22/25 9:56 AM, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 
> >  6.6-stable review patch.  If anyone has any objections, please let me know.
> >  
> >  ------------------
> >  
> >  From: Michael C. Pratt <mcpratt@pm.me>
> >  
> >  commit 2d7521aa26ec2dc8b877bb2d1f2611a2df49a3cf upstream.
> >  
> >  On 11 Oct 2022, it was reported that the crc32 verification
> >  of the u-boot environment failed only on big-endian systems
> >  for the u-boot-env nvmem layout driver with the following error.
> >  
> >    Invalid calculated CRC32: 0x88cd6f09 (expected: 0x096fcd88)
> >  
> >  This problem has been present since the driver was introduced,
> >  and before it was made into a layout driver.
> >  
> >  The suggested fix at the time was to use further endianness
> >  conversion macros in order to have both the stored and calculated
> >  crc32 values to compare always represented in the system's endianness.
> >  This was not accepted due to sparse warnings
> >  and some disagreement on how to handle the situation.
> >  Later on in a newer revision of the patch, it was proposed to use
> >  cpu_to_le32() for both values to compare instead of le32_to_cpu()
> >  and store the values as __le32 type to remove compilation errors.
> >  
> >  The necessity of this is based on the assumption that the use of crc32()
> >  requires endianness conversion because the algorithm uses little-endian,
> >  however, this does not prove to be the case and the issue is unrelated.
> >  
> >  Upon inspecting the current kernel code,
> >  there already is an existing use of le32_to_cpu() in this driver,
> >  which suggests there already is special handling for big-endian systems,
> >  however, it is big-endian systems that have the problem.
> >  
> >  This, being the only functional difference between architectures
> >  in the driver combined with the fact that the suggested fix
> >  was to use the exact same endianness conversion for the values
> >  brings up the possibility that it was not necessary to begin with,
> >  as the same endianness conversion for two values expected to be the same
> >  is expected to be equivalent to no conversion at all.
> >  
> >  After inspecting the u-boot environment of devices of both endianness
> >  and trying to remove the existing endianness conversion,
> >  the problem is resolved in an equivalent way as the other suggested fixes.
> >  
> >  Ultimately, it seems that u-boot is agnostic to endianness
> >  at least for the purpose of environment variables.
> >  In other words, u-boot reads and writes the stored crc32 value
> >  with the same endianness that the crc32 value is calculated with
> >  in whichever endianness a certain architecture runs on.
> >  
> >  Therefore, the u-boot-env driver does not need to convert endianness.
> >  Remove the usage of endianness macros in the u-boot-env driver,
> >  and change the type of local variables to maintain the same return type.
> >  
> >  If there is a special situation in the case of endianness,
> >  it would be a corner case and should be handled by a unique "compatible".
> >  
> >  Even though it is not necessary to use endianness conversion macros here,
> >  it may be useful to use them in the future for consistent error printing.
> >  
> >  Fixes: d5542923f200 ("nvmem: add driver handling U-Boot environment variables")
> >  Reported-by: INAGAKI Hiroshi <musashino.open@gmail.com>
> >  Link: https://lore.kernel.org/all/20221011024928.1807-1-musashino.open@gmail.com
> >  Cc: stable@vger.kernel.org
> >  Signed-off-by: "Michael C. Pratt" <mcpratt@pm.me>
> >  Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
> >  Link: https://lore.kernel.org/r/20250716144210.4804-1-srini@kernel.org
> >  [ applied changes to drivers/nvmem/u-boot-env.c after code was moved from drivers/nvmem/layouts/u-boot-env.c ]
> 
> [ applied changes to drivers/nvmem/u-boot-env.c before code was moved to drivers
> drivers/nvmem/layouts/u-boot-env.c ]

Now fixed, thanks.

greg k-h
