Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F2B52459DD;
	Sat, 10 Jan 2026 20:00:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768075242; cv=none; b=AAiBR8fBCocgydKNwpjSdpRZCagMsuCOwc9wnZX0LSrHdb4lmTUHNPyuQDezXlVGaTQjGAJPvS9zB5NsxDMv1Xm84C/2SJfjCJ9hl1JsDyCs8bNaXwXleYvHZAVWlSw5cU3LPrYUlZ9ZDbxy4ng4sIAj6E04L8pMqCEFsi0yN6Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768075242; c=relaxed/simple;
	bh=XhNuhcoBBONkDEFpQ9TxAOCaiCNwX6vm9uj5PPXhuoY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tjq/8pY1C4YN6zWDf5q+f4mgglozg4EbuHf4DDVmjmB5HIpql8KdRqilYzmfES6xpXriIf3XurlUoYF4oDGgrL9NJpCk8H7qpmXGQsZUfWGHkzRbimIQmU+uClci3pcBtxWJ2i0rf+6dcu/tQm8J+Q+MW6/KcFqFEwDgQ03c9uA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXVohqWj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXVohqWj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4531CC4CEF1;
	Sat, 10 Jan 2026 20:00:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768075241;
	bh=XhNuhcoBBONkDEFpQ9TxAOCaiCNwX6vm9uj5PPXhuoY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vXVohqWjyluQMVcNJ3z0spXzJKTFeS7Ne6hKBsxG86q9Xc8GSYpSAb1p53Vucb0Lz
	 HSiV6kQTlA2bx11re5lkZgGahEtBXB+ANzkpdTqMurlFJJVT+Oy0FsXXlAfFLbdMNb
	 BOXZebJISWdNbZhaAUJ1yUeetNqk0gh/cGE7EioY=
Date: Fri, 9 Jan 2026 15:13:55 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com,
	Lizhi Xu <lizhi.xu@windriver.com>, Theodore Tso <tytso@mit.edu>
Subject: Re: [PATCH 6.6 731/737] ext4: filesystems without casefold feature
 cannot be mounted with siphash
Message-ID: <2026010942-overdue-repayment-b202@gregkh>
References: <20260109112133.973195406@linuxfoundation.org>
 <20260109112201.603806562@linuxfoundation.org>
 <aWEFUlM6PsTMMXxr@quatroqueijos.cascardo.eti.br>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aWEFUlM6PsTMMXxr@quatroqueijos.cascardo.eti.br>

On Fri, Jan 09, 2026 at 10:40:34AM -0300, Thadeu Lima de Souza Cascardo wrote:
> Hi, Greg.
> 
> The followup to 985b67cd86392310d9e9326de941c22fc9340eec, that I submitted
> in the same thread, has not been picked up.
> 
> 20260108150350.3354622-2-cascardo@igalia.com
> https://lore.kernel.org/stable/20260108150350.3354622-2-cascardo@igalia.com/
> a2187431c395 ("ext4: fix error message when rejecting the default hash")
> 
> You picked it up for 6.1 and 5.15 though.

It's in the queue, odd you didn't get an email.

thanks,

greg k-h
