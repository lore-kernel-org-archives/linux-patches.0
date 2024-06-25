Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74A2514A4DC;
	Tue, 25 Jun 2024 10:17:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719310655; cv=none; b=PuBmWgsMKiGlXQIe/nhjwgWEmssBr3mh7HCxXH1uCobbAW6NgdkDr9gpeIjE2h98amWEeTh4qE3Z5jtWY3Zo/L6mA8cNFQBhvq6oiFqlo6E87H0HIWqv8zbZZq5XcYIP3ehLO/WyohZ7H+txKrrZSWbvScrmLlq06MgfTUJ8FHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719310655; c=relaxed/simple;
	bh=JOWPRxQ5QtbgfQpd2h30bAEZa9RhvRMRbQaALkdf2Ec=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=byFy0+wJy6EkXWiDsDrMswknLe5Qc6v5g/87ZxMtPhay4t5yrEIm0S6swOKkB+f2U9QqDAq7d8uUDA23EuJA4gGxIWnsj+11GJvb3sRw/ab7oCmoOV+CfAo1q8ZE4dES/P68IMvMrwNiZd0NeG9WlxpLjYnLvCSWHsroFjryLnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rloaT4Wv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rloaT4Wv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE43C32789;
	Tue, 25 Jun 2024 10:17:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719310655;
	bh=JOWPRxQ5QtbgfQpd2h30bAEZa9RhvRMRbQaALkdf2Ec=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=rloaT4WvyqYM27ZsW44tEaxV3ovvJGtyhQ8YwTbLlqo+YxtuZt0Zge18wDESXX7R9
	 qcGTbyG8/izoB9yHv0P7RZUP5I4SXzoCF+2MPDufxXqDKhuA0W4sbUb6wGIcfNRbVX
	 kIGg1q/kV4oX522ziknef6cAD16Qa7oUt9F2aZ9c=
Date: Tue, 25 Jun 2024 11:49:59 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Luke Jones <luke@ljones.dev>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Jiri Kosina <jkosina@suse.com>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.9 041/250] HID: asus: fix more n-key report descriptors
 if n-key quirked
Message-ID: <2024062552-exclude-womanless-d816@gregkh>
References: <20240625085548.033507125@linuxfoundation.org>
 <20240625085549.637011725@linuxfoundation.org>
 <532a1188-0429-4126-94cd-d77eccebd85d@app.fastmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <532a1188-0429-4126-94cd-d77eccebd85d@app.fastmail.com>

On Tue, Jun 25, 2024 at 09:42:16PM +1200, Luke Jones wrote:
> On Tue, 25 Jun 2024, at 9:29 PM, Greg Kroah-Hartman wrote:
> > 6.9-stable review patch.  If anyone has any objections, please let me know.
> 
> Hi,
> 
> No objections here but I believe this patch must also be included if not already - https://lore.kernel.org/linux-input/20240528050555.1150628-1-andrewjballance@gmail.com/

Thanks, already included!

greg k-h
