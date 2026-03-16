Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E63B330D24;
	Mon, 16 Mar 2026 22:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773698740; cv=none; b=intwqSKwrr5WxZipog4CVGzLIQAfkEHDJXql5gg9EnEuFurqVgFlq/N4ehWqKwrkaT6RmZ5NZc//gh5iebe8uwumNc+ZUYWEjmXpUvkLIkcDi0LcAYdx33IO4OH558fSH8HI5uYn8xaXgijpusJYp5gAmotldQDJaXwkBLOpfnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773698740; c=relaxed/simple;
	bh=YNcaTZjNp321kSlh3EZlHHB7xQiTOdMp7cQdipH4EOQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=iSqjt6iYxbfWIZ0gdl60CMGK5eHx/BqOlofxhduQsMW4hMKDCj+oZFyo/QiMLlxZ4nneh9+jBqKZTf4QK5FgaUb3B+radX5yks3MLfeYPsq9088DMkGO4dNTxsCMr/kB9zjW/ZLjogimrW5vQHC3E4fisEyNRHAP2HnsBL7JvSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NEdnSKxC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NEdnSKxC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57B0C19421;
	Mon, 16 Mar 2026 22:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773698739;
	bh=YNcaTZjNp321kSlh3EZlHHB7xQiTOdMp7cQdipH4EOQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=NEdnSKxC7VqE4KU9N83heHN+QiwOfUwFHBAqqOvVUUArxBMmzBvLZnigwhV/6+GJd
	 vMU03bJlmjA9Y6pOGHeesS8yBXlQuv0Fmzyil+rImG0EOKpYjdMtf39CMnyW0Lq/NI
	 HTqr3nJqNBUj3I44ocmjQYFLLSMs3Ccd8q/YSDBUjE5xmAUwk0KQrA+B7QSZU+zobG
	 aYruLHx+2UP8e11FSMs3XOP4u1tpgrb9YBhNYXmqPyOALkOeGSMGKuYX+9A57rhrf9
	 a4Y59GZ0YrU+JMhCTUuRFyrV8ckifXuUDglXx0kMV4ZBbKGlzfpcj5ercZIsJ6QJ2W
	 Pn+YMHH1Z88nA==
Date: Mon, 16 Mar 2026 15:05:33 -0700
From: Nathan Chancellor <nathan@kernel.org>
To: Sasha Levin <sashal@kernel.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	patches@lists.linux.dev, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org,
	pavel@nabladev.com, jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
	hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
	sr@sladewatkins.com
Subject: Re: [PATCH 5.15 000/410] 5.15.202-rc2 review
Message-ID: <20260316220533.GD1329928@ax162>
References: <20260302160955.2522727-1-sashal@kernel.org>
 <20260305220801.GA3148061@ax162>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260305220801.GA3148061@ax162>

On Thu, Mar 05, 2026 at 03:08:09PM -0700, Nathan Chancellor wrote:
> On Mon, Mar 02, 2026 at 11:09:55AM -0500, Sasha Levin wrote:
> > Jamie Iles (1):
> >   i3c: remove i2c board info from i2c_dev_desc
> 
> You missed commit 6cbf8b38dfe3 ("i3c: fix uninitialized variable use in
> i2c setup") as a fix for this one, as rightfully pointed out by clang:
> 
>   https://lore.kernel.org/177198114226.2577.15577566399399369654@d14e337afe00/
> 
>   $ make -skj"$(nproc)" ARCH=x86_64 LLVM=1 mrproper allmodconfig drivers/i3c/master.o
>   drivers/i3c/master.c:2203:3: error: variable 'i2cdev' is uninitialized when used here [-Werror,-Wuninitialized]
>    2203 |                 i2cdev->dev = i2c_new_client_device(adap, &i2cboardinfo->base);
>         |                 ^~~~~~
> 
> I guess that report was missed because it was not actually addressed to
> anyone?
> 
> FWIW, this patch appeared in a previous 5.15-rc release but Ben
> rightfully pointed out it really was not necessary and Greg said he
> would fix it up by hand:
> 
>   https://lore.kernel.org/2026011724-florist-brook-5f1f@gregkh/
> 
> Guess that never happened?

Ping? I don't see 6cbf8b38dfe3 queued up in 5.15 and this continues to
break our builds:

  https://github.com/ClangBuiltLinux/continuous-integration2/actions/runs/23093834605

Cheers,
Nathan
