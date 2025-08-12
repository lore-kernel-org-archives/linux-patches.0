Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192F13D987;
	Tue, 12 Aug 2025 21:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755033803; cv=none; b=F3ng/YjkHWXs8aiU68kt5X6v35OyUzmP6HFtINE4c387P3zSRLVOJXSmkPW8lBwo+jsBhyAk/nzHM5xFwsbRE3fQPJWpSfcEuDB78yfThdeHlQ+jcN75i5gstRoJ6wNOUFo5IG2wxrGQQg7vAC6JkT/P9k1mTLUgku/suHcHu58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755033803; c=relaxed/simple;
	bh=LPtqBbPzWjgmOf3CGPgRdpHTJUzsIJM11FkblEDdPSg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EvleljaF7vGKItlkfdLxd+iQYLOTUKo9Pm/vBSautdyvx84fxMlu9YVy2UzYnRB8B5uZmzE9Tp+94wwXZgW3sLte1G5O3J9cVvMWCFLHIDODrR8fhQE7fpF4fdh0hi8O0eNi2481cJoL1n3dfxnb7HXCwkDKbp/y4UGR9Bp90Kw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C1FOaepc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C1FOaepc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA5C4C4CEF0;
	Tue, 12 Aug 2025 21:23:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755033802;
	bh=LPtqBbPzWjgmOf3CGPgRdpHTJUzsIJM11FkblEDdPSg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=C1FOaepcrShGvDBkDI/S7FsUqavgjO0e/GasdRkXF78Yrze8J+5CbMd2e0PG1SzNh
	 qSHsK6JJY+nyA5bXH0IRVoZdTz6dN+KeHol+nol71nozH4VCbGgLeMQyzwjLSCTNt4
	 Vsivx0pt+DLFlroDsZwtpSxCRA35cICCigpfMOejF57osddiLCGGI0Ow9mu93OFtGl
	 QOwc/cuqoVSljFoAVscnx698j3eS/KjRw0UE7jdbsS6oAOGWhDmDRbMGtnbGjJZzcV
	 WDgxy/TT7O9D6DjiwnezAagikpjchwRcPDWwhY8S+AweVjIYHS14oXEziqPP6J8Cb9
	 1C8yt//0HMArw==
Date: Tue, 12 Aug 2025 14:23:18 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	linux-hardening@vger.kernel.org, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] hardening: Require clang 20.1.0 for __counted_by
Message-ID: <20250812212318.GD532342@ax162>
References: <20250807-fix-counted_by-clang-19-v1-1-902c86c1d515@kernel.org>
 <a9c64598-41e9-4ec8-8ec1-add5a5f903b4@intel.com>
 <20250811210906.GA924329@ax162>
 <adb1b558-124c-4f7f-b193-bf44a6132fa2@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adb1b558-124c-4f7f-b193-bf44a6132fa2@intel.com>

On Tue, Aug 12, 2025 at 06:28:29PM +0200, Alexander Lobakin wrote:
> Aaah okay, I didn't know that, thanks!

https://discourse.llvm.org/t/rfc-llvm-releases-every-two-weeks/84245 has
some more information about that recent change if you or anyone else is
interested.

> BTW 21-rc1 was released roughly a month ago, does this mean that 20.x is
> already unsupported?

Correct, LLVM 20.1.8 was the last release for release/20.x.

Cheers,
Nathan
