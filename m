Received: from submarine.notk.org (submarine.notk.org [62.210.214.84])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64D7F60DCF;
	Wed, 20 Nov 2024 08:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.210.214.84
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732090053; cv=none; b=sJVQ40J5Wt4bLQIFRL+ILecT/ajMX4B/CwrwGRU72cvCOw0e7tNyTB+anIwddwTSo/HinWU3tn0VhUoxGC+IOPCCf0BZj24EBDlnYHFA9pcV4FfcCsc8Q4hyXy9I/I1QxUY/340jowKchIPtPkz5hdN6/JTGQXvckpX1cHFmLeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732090053; c=relaxed/simple;
	bh=xfk+WNaOx/09IshPPk1YlEwf4JTXmLvJPmiYt1wv2iw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BMTAu/nNRVRog8gj5v7rhyCMAOkLlvfhdzUoN9pCTTueBo1PRisHVgkJ+vqa7Jz2kmtC9jjXuLYEnjhQaDqZfPCt8fiYCWsCbwOvPrdJizmaZe2vyHQv2hqL6SIoDDudI+Z+ILzEV2Sc23FzQlIuBZv9flx8QCnCO0NqErFQdbU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org; spf=pass smtp.mailfrom=codewreck.org; dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b=u7AleqZ5; arc=none smtp.client-ip=62.210.214.84
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=codewreck.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=codewreck.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=codewreck.org header.i=@codewreck.org header.b="u7AleqZ5"
Received: from gaia.codewreck.org (localhost [127.0.0.1])
	by submarine.notk.org (Postfix) with ESMTPS id 998AD14C1E1;
	Wed, 20 Nov 2024 09:07:25 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=codewreck.org;
	s=2; t=1732090048;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0UeYrJzLuOf/XDNh09gGB+kuPfo3IOUJCIGKHMVimvQ=;
	b=u7AleqZ5AM0z/9sOA8DuAvJ4yUG8ulk3LEeEc+/rTqY2IcTW+yYVTEBpzeHfIuyaBZmP+o
	EgR/CJAa4DnGC56dZGUtu/CcCMWqWsIVyC3jXX/o70VzLRWmPhq2k5ZDK0pS8i5Jkvzstt
	5VN6MPwVUGhftBbkH9TcUPAF0ALZuZT/Uz91K87dVjiZyD4VTBc3imQPw6+EhbMZwNqrp3
	5vA16zwScN3yNC8dC0rBctgkPN1GbREQWj9dlOV8TnqbkUTjd4ihuaIsJenNkbPUUHvVvp
	H3ePSSaEqFVLTpSnngcyKZltW4Ccqp9HgRyhlj9erOMdfNo7+IkM/IpaDVNe/A==
Received: from localhost (gaia.codewreck.org [local])
	by gaia.codewreck.org (OpenSMTPD) with ESMTPA id 2d655f32;
	Wed, 20 Nov 2024 08:07:23 +0000 (UTC)
Date: Wed, 20 Nov 2024 17:07:08 +0900
From: Dominique Martinet <asmadeus@codewreck.org>
To: Ulrich Teichert <ulrich.teichert@kumkeo.de>,
	Salvatore Bonaccorso <carnil@debian.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, y0un9n132@gmail.com,
	Kees Cook <keescook@chromium.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Jiri Kosina <jkosina@suse.com>, Sasha Levin <sashal@kernel.org>,
	regressions@lists.linux.dev
Subject: Re: [PATCH 6.1 175/321] x86: Increase brk randomness entropy for
 64-bit systems
Message-ID: <Zz2YrA740TRgl_13@codewreck.org>
References: <20240827143838.192435816@linuxfoundation.org>
 <20240827143844.891898677@linuxfoundation.org>
 <Zz0_-iJH1WaR3BUZ@codewreck.org>
 <Zz2JQzi-5pTP_WPx@eldamar.lan>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Zz2JQzi-5pTP_WPx@eldamar.lan>

Salvatore Bonaccorso wrote on Wed, Nov 20, 2024 at 08:01:23AM +0100:
> Interestigly there is another report in Debian which identifies the
> backport of upstream commit 44c76825d6eefee9eb7ce06c38e1a6632ac7eb7d
> to cause issues in the 6.1.y series:
> 
> https://bugs.debian.org/1085762
> https://lore.kernel.org/regressions/18f34d636390454180240e6a61af9217@kumkeo.de/T/#u

Thanks for the heads up!

This would appear to be the same bug (running qemu-aarch64 in user mode
on an x86 machine) ?
I've added Ulrich in recipients to confirm he's using qemu-user-static
like I was.

Shame I didn't notice all his work, that would have saved me some
time :)


Thanks,
-- 
Dominique Martinet | Asmadeus
