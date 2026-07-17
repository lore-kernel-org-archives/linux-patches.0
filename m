Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 248203B892D;
	Fri, 17 Jul 2026 07:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784273971; cv=none; b=ke3Y/ocaNqOSIXsKJKMzHSqGk6hbZlF04s6Bb5wAJE3jd/Abu6ekWYbn9Ze+boy9uaOMFOhvSoZL0YMSSqMCiwBynFa+24NfAX5HyRQf4mIdHCD6jmxrmJsqgqARLjV/immH2er6mEMjzLlH0YAvGpldlgTBuV9DlQ5jwfzOEX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784273971; c=relaxed/simple;
	bh=5tFL1PH7prPzH4wPyJtK7F3tr0cOvgbRcwxfot9bFCA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ben0+1dp40nklw05OgG46lxTO1DRSTOiCCsdr4CIbfIrId357NistbK/nLi1MPpvHtH/v5TJRkxl956X1CCuf0Di5UGf4Wzpfc7JQVMSd1/J77MHJfbnUtR+cxTKesI8oKnrl81Blrn+SMxALC7Evq/Uh2+zFONgyusqXq2oJbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4azZUBw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4azZUBw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1F741F000E9;
	Fri, 17 Jul 2026 07:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784273969;
	bh=5c3hFhVg+UxNhtE1IvSzccMYNFWd7NfOTEs/lnb1Dg8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=r4azZUBwWDzat///77IR1BSRzNZnLcG5xcmhOh+SXfY3hxtYc5uMNBrhKbgvLNuiX
	 IwESNe5PvuS89/RLp2HyT8BaB5Ar+1xC/5ZV4nqAbxyc+Of8gfbOwR9d986sczw/Iy
	 JtzZ8MUecry5VUkQj3WXfR9R/EXso40a9xQ/pP7Q=
Date: Fri, 17 Jul 2026 09:39:22 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Vivian Wang <wangruikang@iscas.ac.cn>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Paul Walmsley <pjw@kernel.org>, Han Gao <gaohan@iscas.ac.cn>
Subject: Re: [PATCH 6.12 310/349] riscv: mm: Define DIRECT_MAP_PHYSMEM_END
Message-ID: <2026071714-clarinet-diabetes-279d@gregkh>
References: <20260716133033.287196923@linuxfoundation.org>
 <20260716133040.256132969@linuxfoundation.org>
 <777f4850-cfa8-4751-b3cd-2875f55c20e6@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <777f4850-cfa8-4751-b3cd-2875f55c20e6@iscas.ac.cn>

On Fri, Jul 17, 2026 at 01:20:36AM +0800, Vivian Wang wrote:
> On 7/16/26 21:34, Greg Kroah-Hartman wrote:
> 
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> >
> > ------------------
> >
> > From: Vivian Wang <wangruikang@iscas.ac.cn>
> >
> > commit f3336b48cf9d3f2d1fc78e3289c0ded2f00876ee upstream.
> >
> > On RISC-V, the actual mappable range of physical address space is
> > dependent on the current MMU mode i.e. satp_mode (See
> > Documentation/arch/riscv/vm-layout.rst).
> >
> > Define the DIRECT_MAP_PHYSMEM_END macro based on the existing virtual
> > address space layout macros to expose this information to
> > get_free_mem_region(). Otherwise, it returns a region that couldn't be
> > mapped, which breaks ZONE_DEVICE.
> >
> > Cc: stable@vger.kernel.org # v6.13+
> 
> Please drop for all <= 6.12 (so, keep for 6.18.y, 7.1.y; drop for
> 6.12.y, 6.6.y, 6.1.y, 5.15.y).
> 
> The name DIRECT_MAP_PHYSMEM_END is only in use since 6.13 (commit
> afe789b7367a ("kaslr: rename physmem_end and PHYSMEM_END to
> direct_map_physmem_end")). It does nothing for earlier versions. I also
> don't think it's important enough to be worth backporting for these
> older branches.

Now dropped, thanks for the the review!

greg k-h
