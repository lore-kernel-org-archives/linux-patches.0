Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2EAA73477;
	Sun, 12 Jan 2025 17:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736702729; cv=none; b=ghnh+Ng9Y8x8epmmR16yAwWVMT2h9KeLTGl77lG5QDVYR2bYxLRB6qN0LBre9HZ0Gh4cJ+QneX96XGdIXVAYZyZm2YK+DVCCM8Tzx8+rrj2DHj9NoAFHzRCrtnPO0X19m4dV/aheFf1g/iUv0c99WgczIPMJRpRXGjhLYN1peJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736702729; c=relaxed/simple;
	bh=NjQJKmPE9y/RB0vBiPBNLd4m273UABjY8sN5cGArtE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fe9vFQWriYRDD2SmaP+K8SvWLOobSIRTy0rQEP+7S2IPwHiXLx0EmpmalzbiVidrUi1pqG6UWYCEav0iSUp+koci9GkRPRqHUjQ9Oi/CdS454XQV15S0L8xO2tTg6oDWiUBi27hVhDXQ6wphO5Ct5EJDc9QmKHo1NEbckFp04LY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bPw2IEaE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bPw2IEaE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E7CC4CEDF;
	Sun, 12 Jan 2025 17:25:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736702728;
	bh=NjQJKmPE9y/RB0vBiPBNLd4m273UABjY8sN5cGArtE0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=bPw2IEaEGCOBJo2xIcof8RCmMct4j6cmu0GGW0etu8WuqMDw9jSJllPRfg8YwO8+6
	 yBOC9ZoyxwxFNymsjemzRmsNPVtmk43FtdCNhh6AHxbl/RGpvbsLcEtScXTv2LQu46
	 EGWD8aHOntIZgO+sxNhxzgtjXsUmOHujypQUWcWg=
Date: Sun, 12 Jan 2025 18:25:25 +0100
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
	Shuah Khan <skhan@linuxfoundation.org>,
	Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 2/3] docs: submitting-patches: clarify difference between
 Acked-by and Reviewed-by
Message-ID: <2025011219-appetizer-wired-ba35@gregkh>
References: <20250112152946.761150-1-ojeda@kernel.org>
 <20250112152946.761150-3-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250112152946.761150-3-ojeda@kernel.org>

On Sun, Jan 12, 2025 at 04:29:45PM +0100, Miguel Ojeda wrote:
> Newcomers to the kernel need to learn the different tags that are
> used in commit messages and when to apply them. Acked-by is sometimes
> misunderstood, since the documentation did not really clarify (up to
> the previous commit) when it should be used, especially compared to
> Reviewed-by.
> 
> The previous commit already clarified who the usual providers of Acked-by
> tags are, with examples. Thus provide a clarification paragraph for
> the comparison with Reviewed-by, and give a couple examples reusing the
> cases given above, in the previous commit.
> 
> Acked-by: Shuah Khan <skhan@linuxfoundation.org>
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  Documentation/process/submitting-patches.rst | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/process/submitting-patches.rst b/Documentation/process/submitting-patches.rst
> index c7a28af235f7..7b0ac7370cb1 100644
> --- a/Documentation/process/submitting-patches.rst
> +++ b/Documentation/process/submitting-patches.rst
> @@ -480,6 +480,12 @@ mergers will sometimes manually convert an acker's "yep, looks good to me"
>  into an Acked-by: (but note that it is usually better to ask for an
>  explicit ack).
>  
> +Acked-by: is also less formal than Reviewed-by:.  For instance, maintainers may
> +use it to signify that they are OK with a patch landing, but they may not have
> +reviewed it as thoroughly as if a Reviewed-by: was provided.  Similarly, a key
> +user may not have carried out a technical review of the patch, yet they may be
> +satisfied with the general approach, the feature or the user-facing interface.
> +
>  Acked-by: does not necessarily indicate acknowledgement of the entire patch.
>  For example, if a patch affects multiple subsystems and has an Acked-by: from
>  one subsystem maintainer then this usually indicates acknowledgement of just
> -- 
> 2.48.0
> 

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
