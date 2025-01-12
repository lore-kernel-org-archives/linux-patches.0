Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0292F20328;
	Sun, 12 Jan 2025 17:22:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736702554; cv=none; b=cuaLylKlWdYsXKElkEEXP4FdIJyJKXK9zxloWculi6Xk/vfHellHsK0ENfN1X9diQTSz8fmGHeAYr607f7kpyTee4LZTUCUQzOlMoRqOxGAYAy7RPkfzkYSrYliJfnNimq4B5hu19g+38VuRMcSlC0iBtE5uk7mHK5mf8dUt15U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736702554; c=relaxed/simple;
	bh=/rijT1Prefvu2JjcA/TN7ZxE125/n8TovynxAerhJmE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XF11qsPp/VT5pnUZCErrpnwGhymAJx9aniOoZQ/e74bPhOspnfDeTqCD59IdsEpl3P5CDJ8QsD44MsMSWtsHoO1SkEs7wxFh1OBm1CkTsKWD2LOJJHODL6MA0add4nF+hLEbvNLSCKtKSKNmjxBB2pnXGDn9oGOC2bphl1s17Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dKP32P5O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dKP32P5O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E21AAC4CEDF;
	Sun, 12 Jan 2025 17:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736702553;
	bh=/rijT1Prefvu2JjcA/TN7ZxE125/n8TovynxAerhJmE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dKP32P5OoNGSdaBTSUJ1KAlPMh6ss5nhZCuv/NOMiJUlPR3OjE+cA7t7ILi8LjRlT
	 1ixe4v/hXsFcgJnxYQ9GexDduPR89WD3bHhV99izQeUnlwmHkjLBQ/ktbbyeLrX051
	 ANl/hxxcpNc2fMJRlAXipugh7nMNbZLpIgSsJNp8=
Date: Sun, 12 Jan 2025 18:22:29 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Miguel Ojeda <ojeda@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>, workflows@vger.kernel.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev, Neal Gompa <neal@gompa.dev>,
	Sami Tolvanen <samitolvanen@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	tech-board@groups.linuxfoundation.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dan Williams <dan.j.williams@intel.com>,
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH 3/3] docs: submitting-patches: clarify that signers may
 use their discretion on tags
Message-ID: <2025011219-ashen-epilepsy-ba32@gregkh>
References: <20250112152946.761150-1-ojeda@kernel.org>
 <20250112152946.761150-4-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250112152946.761150-4-ojeda@kernel.org>

On Sun, Jan 12, 2025 at 04:29:46PM +0100, Miguel Ojeda wrote:
> Tags are really appreciated by maintainers in general, since it means
> someone is willing to put their name on a commit, be it as a reviewer,
> tester, etc.
> 
> However, signers (i.e. submitters carrying tags from previous versions
> and maintainers applying patches) may need to take or drop tags, on a
> case-by-case basis, for different reasons.
> 
> Yet this is not explicitly spelled out in the documentation, thus there
> may be instances [1] where contributors may feel unwelcome.
> 
> Thus, to clarify, state this clearly.
> 
> Link: https://lore.kernel.org/rust-for-linux/CAEg-Je-h4NitWb2ErFGCOqt0KQfXuyKWLhpnNHCdRzZdxi018Q@mail.gmail.com/ [1]
> Suggested-by: Dan Williams <dan.j.williams@intel.com>
> Acked-by: Shuah Khan <skhan@linuxfoundation.org>
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  Documentation/process/submitting-patches.rst | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/Documentation/process/submitting-patches.rst b/Documentation/process/submitting-patches.rst
> index 7b0ac7370cb1..6754bc15f989 100644
> --- a/Documentation/process/submitting-patches.rst
> +++ b/Documentation/process/submitting-patches.rst
> @@ -614,6 +614,10 @@ process nor the requirement to Cc: stable@vger.kernel.org on all stable
>  patch candidates. For more information, please read
>  Documentation/process/stable-kernel-rules.rst.
>  
> +Finally, while providing tags is welcome and typically very appreciated, please
> +note that signers (i.e. submitters and maintainers) may use their discretion in
> +applying offered tags.
> +
>  .. _the_canonical_patch_format:
>  
>  The canonical patch format
> -- 
> 2.48.0
> 

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
