Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22E6330EF8F;
	Wed, 25 Mar 2026 08:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774429023; cv=none; b=W/xNhq1rBRQ43LuYABqg3slyAduPugu8feBZYsDLIU+/1vAHV7brj+DnVg1465v2pdRec75hDp7oAzs3Mz66VJi1/JYD6h+IWGppf25Ewbr9U3e/IF46I34b6EPEYme5rpdQtgSUTTb3DfO1b7TxWUIP5LKX0mUw9paL8feNA5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774429023; c=relaxed/simple;
	bh=ASb4qupdpo3t59cNNXSuFHQ4PhJqBhPSPN6ncoCGWmg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AEz4oU6WOytNn3ACq56pX52Wm8zPSL6oH4UtIdV9ZagUltbYorOgTQSelAcDYDyA9lGIY57MjZUTMMEeovSKVPyHuX44hFG6tfxjPtHiTz0LMu6+ZvJnZGx2aH5Qvxy8UZvYLvgP6MVuNUywL5q974NdGuwQOwh0vW6opuehzvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T2UrqIJA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T2UrqIJA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 420D5C2BC9E;
	Wed, 25 Mar 2026 08:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774429022;
	bh=ASb4qupdpo3t59cNNXSuFHQ4PhJqBhPSPN6ncoCGWmg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=T2UrqIJA2QgOqgRocCqFH673n3qNaRK+AJfMcBJUeuS5VcICnRIwHRfd8JcmnJV2G
	 xQkaHOfK4JGZii/BuDw1zggIGljycgxpwFHo3D+5uenSI5X9mPWyQdt8SIexLZzvlt
	 ulhQNfd2rSEo5XJuH/vulAICmKVQklbANMHaO680=
Date: Wed, 25 Mar 2026 09:56:39 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Dave Jiang <dave.jiang@intel.com>
Cc: Keith Busch <kbusch@kernel.org>, stable@vger.kernel.org,
	patches@lists.linux.dev,
	Jonathan Cameron <jonathan.cameron@huawei.com>,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 6.19 378/378] cxl/acpi: Fix CXL_ACPI and CXL_PMEM Kconfig
 tristate mismatch
Message-ID: <2026032511-construct-blurt-07cf@gregkh>
References: <20260317163006.959177102@linuxfoundation.org>
 <20260317163020.886316423@linuxfoundation.org>
 <acK_mxmLlvD5vQog@kbusch-mbp>
 <551037c4-665e-4701-9689-a75bdabe4211@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <551037c4-665e-4701-9689-a75bdabe4211@intel.com>

On Tue, Mar 24, 2026 at 09:49:43AM -0700, Dave Jiang wrote:
> 
> 
> On 3/24/26 9:45 AM, Keith Busch wrote:
> > On Tue, Mar 17, 2026 at 05:35:35PM +0100, Greg Kroah-Hartman wrote:
> >> 6.19-stable review patch.  If anyone has any objections, please let me know.
> > 
> > No objection, but a little confused how this got to stable before
> > landing in Linus' tree. Does stable pull directly from downstream
> > subsystems now?
> > 
> > Speaking of upstream, will the CXL maintainers be submitting a pull
> > request for the staged fixes soon? I'm just getting new bug reports from
> > people testing 7.0-rc, so wanted to check in on that.
> 
> I can send it today. Looks like I got enough days in linux-next soaking for the PR.
> 

I took it as it was "obviously" correct, fixed reported regressions, and
it was in linux-next and going to Linus "soon".

thanks,

greg k-h
