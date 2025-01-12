Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC381BEF63;
	Sun, 12 Jan 2025 17:24:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736702699; cv=none; b=TknbnaF44owi4f/HG/cfa2iz12tZQoWSnp7zlheJnEupST2U6TojoAK+lJ4ftk1/NZh+3tC72TioqV4fSIoWCHkXnT2CkprAxzIXcEcMAdNKUbHcEQrPcDm9L67RQOtLJ7esco28hPhMdAxuTT7yQq59alHZEyK6svZ9kYlAsJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736702699; c=relaxed/simple;
	bh=bLQauQCnbYheMnUjUqqUvNAnMytlVgSKGvj37BsWMJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=A4CrA3iI+AluXv2RsSWWSnsihy0aPRf8jnRF9JgPqAEKK12OH0Lx44ActTc9kbjiJdaxQpPgzNVGahXQwWkkC5IwJ2o00X93R3FzaStK5VHqo81okvcPKaS1VrVzdz8Wa8tOY3OMu8LFN57Gy4S3pgclwgFKkXf+RpHN4vfkl0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zGLSso2K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zGLSso2K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B17C4CEE3;
	Sun, 12 Jan 2025 17:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736702698;
	bh=bLQauQCnbYheMnUjUqqUvNAnMytlVgSKGvj37BsWMJw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=zGLSso2KEo1LuK4jQqSN6oSjY7n9ES6xq3Nrr669BsdwBU0pYDYfpPhL4xSzqMH6/
	 KqjlvT+ysYN+u6/vqr1rmyK/tIrg+tlFKXleWfuS5n1+HKbv+f+UzNtjMDTn9AxxJb
	 f0ALwyeqTHf1cd2nu9YG79zvcoTNr7W5IDoxCRuI=
Date: Sun, 12 Jan 2025 18:24:55 +0100
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
Subject: Re: [PATCH 1/3] docs: submitting-patches: clarify Acked-by and
 introduce "# Suffix"
Message-ID: <2025011246-poem-aluminum-ec75@gregkh>
References: <20250112152946.761150-1-ojeda@kernel.org>
 <20250112152946.761150-2-ojeda@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250112152946.761150-2-ojeda@kernel.org>

On Sun, Jan 12, 2025 at 04:29:44PM +0100, Miguel Ojeda wrote:
> Acked-by is typically used by maintainers. However, sometimes it is
> useful to be able to accept the tag from other stakeholders that may not
> have done a deep technical review or may not be kernel developers. For
> instance:
> 
>   - People with domain knowledge, such as the original author of the
>     code being modified.
> 
>   - Userspace-side reviewers for a kernel uAPI patch, like in DRM --
>     see Documentation/gpu/drm-uapi.rst:
> 
>     > The userspace-side reviewer should also provide an Acked-by on the
>     > kernel uAPI patch indicating that they believe the proposed uAPI
>     > is sound and sufficiently documented and validated for userspace's
>     > consumption.
> 
>   - Key users of a feature, such as in [1].
> 
> Thus clarify that Acked-by may be used by other stakeholders (but most
> commonly by maintainers).
> 
> Since, in these cases, it may be confusing why an Acked-by is/was
> provided, allow and suggest to provide a "# Suffix" explaining it.
> 
> The "# Suffix" for Acked-by is already being used to clarify what part
> of the patch a maintainer is acknowledging, thus also mention "# Suffix"
> in the relevant paragraph.
> 
> Link: https://lore.kernel.org/rust-for-linux/CANiq72m4fea15Z0fFZauz8N2madkBJ0G7Dc094OwoajnXmROOA@mail.gmail.com/ [1]
> Acked-by: Shuah Khan <skhan@linuxfoundation.org>
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Miguel Ojeda <ojeda@kernel.org>
> ---
>  Documentation/process/submitting-patches.rst | 12 ++++++++++--
>  1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/process/submitting-patches.rst b/Documentation/process/submitting-patches.rst
> index 1518bd57adab..c7a28af235f7 100644
> --- a/Documentation/process/submitting-patches.rst
> +++ b/Documentation/process/submitting-patches.rst
> @@ -463,9 +463,17 @@ If a person was not directly involved in the preparation or handling of a
>  patch but wishes to signify and record their approval of it then they can
>  ask to have an Acked-by: line added to the patch's changelog.
> 
> -Acked-by: is often used by the maintainer of the affected code when that
> +Acked-by: is meant to be used by those responsible for or involved with the
> +affected code in one way or another.  Most commonly, the maintainer when that
>  maintainer neither contributed to nor forwarded the patch.
> 
> +Acked-by: may also be used by other stakeholders, such as people with domain
> +knowledge (e.g. the original author of the code being modified), userspace-side
> +reviewers for a kernel uAPI patch or key users of a feature.  Optionally, in
> +these cases, it can be useful to add a "# Suffix" to clarify its meaning::
> +
> +	Acked-by: The Stakeholder <stakeholder@example.org> # As primary user
> +
>  Acked-by: is not as formal as Signed-off-by:.  It is a record that the acker
>  has at least reviewed the patch and has indicated acceptance.  Hence patch
>  mergers will sometimes manually convert an acker's "yep, looks good to me"
> @@ -477,7 +485,7 @@ For example, if a patch affects multiple subsystems and has an Acked-by: from
>  one subsystem maintainer then this usually indicates acknowledgement of just
>  the part which affects that maintainer's code.  Judgement should be used here.
>  When in doubt people should refer to the original discussion in the mailing
> -list archives.
> +list archives.  A "# Suffix" may also be used in this case to clarify.
> 
>  If a person has had the opportunity to comment on a patch, but has not
>  provided such comments, you may optionally add a ``Cc:`` tag to the patch.
> --
> 2.48.0

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
