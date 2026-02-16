Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD10A18C2C;
	Mon, 16 Feb 2026 13:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771247554; cv=none; b=lk2CllhGU6nzzFdmenkxbrtq7VHh6lXoOw0uLBpagkyaMR+9m5KFbXn4Uc7eV8IO5AcrJh8Jo3/KOMFczu6e6OXsv3B0Pkp4MTo0uh50WYCrRrZi2JqY9UFGZnnh1SjodZ3ei0dSBQiQ47HuzMtSZJ6BhATxZ3e2t/DOlo6LTWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771247554; c=relaxed/simple;
	bh=+sJ8Q79TtnPFGVadz5HA6/HrYp0WOEfUHGZ/PBY7wLs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rtTzsu9cQPZ40kk5JLT3WJC8ijkY2+VzVUR+HkHsfPdnxC2qO1uqSX9JYt6T/aCrSi+xIHwOOwmWarzxHMs81kK8ZlVTx3WxaCD7DipqL4ttPgftF3e2dkMVZX46y7QHr2NrkpdVmmfu09Q3pTq18G5qr6/Vbt/i3xpXQKgpd8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SWmOllPO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SWmOllPO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50366C116C6;
	Mon, 16 Feb 2026 13:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771247554;
	bh=+sJ8Q79TtnPFGVadz5HA6/HrYp0WOEfUHGZ/PBY7wLs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SWmOllPOOvkZmq9G5c79cjT7xlJhHZ1Ge6xBe9qEL2prmSVoIz1MOWhlhpQo8QXTo
	 pXeKpGtWkPv+w0/WW1wTtJO63PHvp7ki4ozQMVgyRAr5rMdN1iBccbeburTWShOqdQ
	 QqfzLMR642n9TGN3+xKv5kQFoxirmCZx+SM57p3qlijQvnaGLc6nJyqGblqz9s6LIm
	 BBLRuJk1yzRw+ih8YQGEYz7qOnwGUTS+mdMrK9tgWlnmozhuRt/shXuHjnDjQGHCI2
	 nIESX52GmSRwThKSLkeviKDEWQmDGImMPtNUnwJ08TlPKgyC2p7IcrbtVqUPxX3srC
	 e4hItKa765p8Q==
Date: Mon, 16 Feb 2026 08:12:33 -0500
From: Sasha Levin <sashal@kernel.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Helge Deller <deller@gmx.de>, guoren@kernel.org,
	neil.armstrong@linaro.org, brauner@kernel.org,
	yelangyan@huaqin.corp-partner.google.com,
	schuster.simon@siemens-energy.com, linux-csky@vger.kernel.org,
	Parisc List <linux-parisc@vger.kernel.org>
Subject: Re: [PATCH AUTOSEL 6.19-5.10] parisc: Prevent interrupts during
 reboot
Message-ID: <aZMXwfvJjG0YkuF5@laps>
References: <20260214005825.3665084-1-sashal@kernel.org>
 <CAMuHMdVeGv=f-Oo1=GQLghn_hwpe2YN5OS79fQsy2uccwyVUZg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAMuHMdVeGv=f-Oo1=GQLghn_hwpe2YN5OS79fQsy2uccwyVUZg@mail.gmail.com>

On Mon, Feb 16, 2026 at 11:21:25AM +0100, Geert Uytterhoeven wrote:
>Hi Sasha
>
>Cc linux-parisc
>
>How did you (or the LLM?) came up with that CC list?!?

Interesting...

$ ~/linux/scripts/get_maintainer.pl --pattern-depth=1 --no-rolestats --nor --nos 0001-parisc-Prevent-interrupts-during-reboot.patch 
Neil Armstrong <neil.armstrong@linaro.org>
"Guo Ren (Alibaba Damo Academy)" <guoren@kernel.org>
Christian Brauner <brauner@kernel.org>
Geert Uytterhoeven <geert@linux-m68k.org>
Andreas Larsson <andreas@gaisler.com>
Helge Deller <deller@gmx.de>
Langyan Ye <yelangyan@huaqin.corp-partner.google.com>
Simon Schuster <schuster.simon@siemens-energy.com>

I think that I'll fix it by replacing --pattern-depth with --nogit --nogit-fallback:

$ ~/linux/scripts/get_maintainer.pl --no-git --nogit-fallback --no-rolestats --nor --nos 0001-parisc-Prevent-interrupts-during-reboot.patch 
"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Helge Deller <deller@gmx.de>
linux-parisc@vger.kernel.org
linux-kernel@vger.kernel.org


Thanks for reporting this!

-- 
Thanks,
Sasha
