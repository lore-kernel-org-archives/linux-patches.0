Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97C9686AF0
	for <patches@lists.linux.dev>; Tue, 30 Jan 2024 16:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706631669; cv=none; b=NsMRK68iA+n0Zjd1vx2IbRA3pSZ6IEni54JczASO+Ib5f2lRHnchKS4etpJ1R/DzAUMt1idPyopjCqU8PVDvNSpudHriuMJU9n+qB3bfA1CzPJgmatYhAQJ+bWzwZi6FAUa+1U51OwPkExc1Zn9sf4DZYyuqzACbW+Dg1DnQUnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706631669; c=relaxed/simple;
	bh=OwcGd6pgEB8M1Rd0VLxKoDA7ulpg30L8inV7kIdkz24=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=un6QGEUvWyLyxJ7NAenBrOd5x/4R9DjmR9MeG+BfiZlvGD4WUOLQ70Bat49i8obKuXu9BrFXhO5NiGkcCv8IZEOFhiUwqzE80APVzwaW0cF1hnNY4cYtaoW6Ghnjx0lgL+PYN2P1HPdlDy4Mn2j4SpKjFCCqCMO2gwBKBnesT84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=ns1ujTi+; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="ns1ujTi+"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net A97F747AA8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1706631665; bh=ilVz9ATi/E1XgwoOUQj0B/KNO6tp3Ig21nSWwn56D44=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=ns1ujTi+q5TrNzZMVfBmprl7dUkGteNZZ+8xO85YjXlomNZn2phSfp/9/0H+iyMt3
	 7tjoqkjhIPD6igwjWmZQMQKTV8rYJcubFc4kjM178nJ4H1sW2ZmVLXFVIvLapHBx6t
	 QXkt8fqs5rcojYlUixKPx1C+x47ecX/so0qI2dDjCRzl4Rz/ZwS+jmrBS7rUl6q8CT
	 KDdCxFeDjjlGCCT4IkynDHfrCThvcrQTZkuJkjcgZw46cxFHuJEOZQ7W44L/UDriMq
	 qD8NtoL7IgFiVFiZxTyPdxzdYhsHNf1Hvu5awJRxTdzOqfPtYBBE/C9T6F50sRNiTK
	 0kelI1mrIxdpQ==
Received: from localhost (unknown [IPv6:2601:280:5e00:7e19::646])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id A97F747AA8;
	Tue, 30 Jan 2024 16:21:05 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Justin Forbes <jforbes@fedoraproject.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Jani Nikula
 <jani.nikula@intel.com>, Vegard Nossum <vegard.nossum@oracle.com>, Sasha
 Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 003/331] docs: kernel_feat.py: fix potential command
 injection
In-Reply-To: <ZbkfGst991YHqJHK@fedora64.linuxtx.org>
References: <20240129170014.969142961@linuxfoundation.org>
 <20240129170015.067909940@linuxfoundation.org>
 <ZbkfGst991YHqJHK@fedora64.linuxtx.org>
Date: Tue, 30 Jan 2024 09:21:04 -0700
Message-ID: <87h6iudc7j.fsf@meer.lwn.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Justin Forbes <jforbes@fedoraproject.org> writes:

> On Mon, Jan 29, 2024 at 09:01:07AM -0800, Greg Kroah-Hartman wrote:
>> 6.6-stable review patch.  If anyone has any objections, please let me know.
>> 
>> ------------------
>> 
>> From: Vegard Nossum <vegard.nossum@oracle.com>
>> 
>> [ Upstream commit c48a7c44a1d02516309015b6134c9bb982e17008 ]
>> 
>> The kernel-feat directive passes its argument straight to the shell.
>> This is unfortunate and unnecessary.
>> 
>> Let's always use paths relative to $srctree/Documentation/ and use
>> subprocess.check_call() instead of subprocess.Popen(shell=True).
>> 
>> This also makes the code shorter.
>> 
>> This is analogous to commit 3231dd586277 ("docs: kernel_abi.py: fix
>> command injection") where we did exactly the same thing for
>> kernel_abi.py, somehow I completely missed this one.
>> 
>> Link: https://fosstodon.org/@jani/111676532203641247
>> Reported-by: Jani Nikula <jani.nikula@intel.com>
>> Signed-off-by: Vegard Nossum <vegard.nossum@oracle.com>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Jonathan Corbet <corbet@lwn.net>
>> Link: https://lore.kernel.org/r/20240110174758.3680506-1-vegard.nossum@oracle.com
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>
> This patch seems to be missing something. In 6.6.15-rc1 I get a doc
> build failure with:
>
> /builddir/build/BUILD/kernel-6.6.14-332-g1ff49073b88b/linux-6.6.15-0.rc1.1ff49073b88b.200.fc39.noarch/Documentation/sphinx/kerneldoc.py:133: SyntaxWarning: invalid escape sequence '\.'
>   line_regex = re.compile("^\.\. LINENO ([0-9]+)$")

Ah ... you're missing 86a0adc029d3 (Documentation/sphinx: fix Python
string escapes).  That is not a problem with this patch, though; I would
expect you to get the same error (with Python 3.12) without.

Thanks,

jon
