Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EB0F20C038;
	Tue, 20 May 2025 11:18:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747739923; cv=none; b=XdNwtfkW5HyREqQZEC4WlN3IqKtxTetuRsyUNYpYcjbKfg0y6xuXiQFOK7vAfQGZvMfnuf21XY9+a9GDpWveEHhPHISbhstCoJvtS81gh4TiOHWEipxDLwBNQKhRx8gGC9YEdZsWRtNLOke0upmSbw5r3Bk9wO4ZjzL065tnwhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747739923; c=relaxed/simple;
	bh=qjYvdvfya/ilgDwMe8hIoPpTxDFUOlZyCkJtQZaKTVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VP3Y0vCP9NYgrjIN5n+veEooBgq1IHWa45nCTW5lJ4WyP0PnJAdbvxPhGA1fzOfA1hEjeUAl2Jk5enwTx5r05O4uiFAaZ9nsNWuGkHCI0tpLQGUd++ofvCN48jX0TmkpCBj7IH/tV+Lm1K4OZvd09veBxWE0hezRzaq7lycI3j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I2HxntDq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I2HxntDq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C29CC4CEE9;
	Tue, 20 May 2025 11:18:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747739920;
	bh=qjYvdvfya/ilgDwMe8hIoPpTxDFUOlZyCkJtQZaKTVs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=I2HxntDqMnDxdlcyjmxyLHFLDg6rgXYZKChTiKXcZIkPOXGpwDNUEAtI6FIT0399u
	 cQIKl9y7us9c7ymMZKOpcBnSobJJRVc956jMIwfsKnWNQwrNJdi6KZWEF4tx69rbRp
	 W+/G4yKroxaoPrVy0viEDtdksqrJqzGBAKq49bbI=
Date: Tue, 20 May 2025 13:18:37 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: jianqi.ren.cn@windriver.com
Cc: stable@vger.kernel.org, paul@paul-moore.com,
	stephen.smalley.work@gmail.com, eparis@parisplace.org,
	selinux@vger.kernel.org, cgzones@googlemail.com,
	patches@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.1.y] selinux: avoid dereference of garbage after mount
 failure
Message-ID: <2025052025-alias-sublime-c6b0@gregkh>
References: <20250512014400.3326099-1-jianqi.ren.cn@windriver.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20250512014400.3326099-1-jianqi.ren.cn@windriver.com>

On Mon, May 12, 2025 at 09:44:00AM +0800, jianqi.ren.cn@windriver.com wrote:
> From: Christian Göttsche <cgzones@googlemail.com>
> 
> commit 37801a36b4d68892ce807264f784d818f8d0d39b upstream.
> 
> In case kern_mount() fails and returns an error pointer return in the
> error branch instead of continuing and dereferencing the error pointer.
> 
> While on it drop the never read static variable selinuxfs_mount.
> 
> Cc: stable@vger.kernel.org
> Fixes: 0619f0f5e36f ("selinux: wrap selinuxfs state")
> Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
> Signed-off-by: Paul Moore <paul@paul-moore.com>
> Signed-off-by: Jianqi Ren <jianqi.ren.cn@windriver.com>
> Signed-off-by: He Zhe <zhe.he@windriver.com>
> ---
> Verified the build test

No you did not :(

