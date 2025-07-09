Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4CD22DA0B;
	Wed,  9 Jul 2025 08:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752050827; cv=none; b=h6CdKg/6J0NAGGP77YJwv4yjQUDgs3xmZDEz6iYOP1oOdLDQOLEZVky+J94g1a1lALrxelI05gd0kBhauKmb23AWYb9vz1EdJV8LNiatt73tywOZaTCvwjl64H4T/qWsKxejLSlXVZqF3jIscXBkenObAKYff0cZN0ZMpkJTrEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752050827; c=relaxed/simple;
	bh=8eDfT1aIq5sj46Nlnip13kyLM/TlVQ5rzf4ZGoIRzAk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AODJ6sl//dLadf6KbC1Q7Y8wp19fg1sUZFoXUyRt3fihD0afmo38QAwARwZyLSk5VCvDITMQla1cgU7U6eG8kfXgSRk9QefdyJ9nsBwcmA7eO1okwws2tDqQJmB5L7UJRRwrLEud2V15JXKExUDZAaTYmBE67yVkoBupIj84ECw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lIfg4+ic; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lIfg4+ic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE221C4CEEF;
	Wed,  9 Jul 2025 08:47:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752050827;
	bh=8eDfT1aIq5sj46Nlnip13kyLM/TlVQ5rzf4ZGoIRzAk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=lIfg4+icJ80KDbIzfntTJ2bx86u4pZ6Rs+dyTOaJCZWOAxxdNjZ8aQv9gwZiwPfg4
	 9wviVUgiLKJ/PAamwx2N3V+AfYLcB/s2yhijtC7rdlTdL+v3CZpWlKZdWyNWmyFx6U
	 eFdDZSZIKc31tvI1hGedu3/U/MCLBI145wD9oCrw=
Date: Wed, 9 Jul 2025 10:47:04 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: WangYuli <wangyuli@uniontech.com>
Cc: chuck.lever@oracle.com, masahiroy@kernel.org, nicolas@fjasle.eu,
	patches@lists.linux.dev, stable@vger.kernel.org, dcavalca@meta.com,
	jtornosm@redhat.com, guanwentao@uniontech.com
Subject: Re: [PATCH 6.6 129/139] scripts: clean up IA-64 code
Message-ID: <2025070914-hankering-saucy-ec33@gregkh>
References: <20250703143946.229154383@linuxfoundation.org>
 <E845ABA28076FEFB+20250708032644.1000734-1-wangyuli@uniontech.com>
 <2025070857-junkman-tablet-6a45@gregkh>
 <572685AD12256749+e24050a6-dde6-4447-8b45-69578b352e5f@uniontech.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <572685AD12256749+e24050a6-dde6-4447-8b45-69578b352e5f@uniontech.com>

On Tue, Jul 08, 2025 at 03:45:16PM +0800, WangYuli wrote:
> Hi greg k-h,
> 
> On 2025/7/8 15:20, Greg KH wrote:
> > Is ia-64 actually being used in the 6.6.y tree by anyone?  Who still has
> > that hardware that is keeping that arch alive for older kernels but not
> > newer ones?
> > 
> I'm afraid I don't quite follow your point.
> 
> In v6.7-rc1, we introduced the commit to remove the IA-64 architecture code.
> 
> This means linux-6.6.y is the last kernel version that natively supports
> IA-64, and it also happens to be the currently active LTS release.

6.12.y is the "currently active LTS release", along with 6.6.y and older
ones.  So are all ia64 users sticking with 6.6.y only?

> In any case, I'm quite confused by the current situation because we've
> essentially broken IA-64 build support in this kernel version.

Sorry, I didn't realize this, it came in for a different patch that
fixed a different issue as the thread shows.

> If you genuinely believe that no one is using IA-64 devices with
> linux-6.6.y, then it might be best to directly backport commit cf8e865
> ("arch: Remove Itanium (IA-64) architecture") to completely remove IA-64.
> 
> This would avoid any misunderstanding.
> 
> Otherwise, someone in the future will inevitably assume linux-6.6.y still
> supports IA-64, when in reality, it's no longer functional.

Who assumes this?  Again, who is still using/maintaining this arch for
6.6.y anymore?

I'm all for reverting this, but would like to see some reports of real
users first :)

thanks,

greg k-h
