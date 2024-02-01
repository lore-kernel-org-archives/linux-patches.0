Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADEED5D490
	for <patches@lists.linux.dev>; Thu,  1 Feb 2024 14:37:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706798263; cv=none; b=OzaiI28poC4337p6VY+gORydNo3BLXBLnsSyxB7mrsJB0yTGkp36OmVd/hfjxU3MK8p2iMA99330zsXMS8nByREhUAVmCkBcnGvdgVtESHY2CODZOmLGEN/sw7T+K/y5LsO1kgBJOtCaPJFeFcc+ULDchuoZCIp0sOA3d4zbhz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706798263; c=relaxed/simple;
	bh=bpxojyvJfxUg9T/YapxRu/G5Lc+yOYbSb6q1B1Gxkcg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=VUHVngrin2zep//VxUZej+yVh0TUupsLkDSueJkJsm3QTf57aZGy+aB2lVJjxSu0xjtqEuEg3tb4JIAYlbY/GFYG+f/QBuMHxEDaYaCCDMc0sG8ii1GiPwL0uQvB8g+4yNVmAWnYlxpJFqNwwEHJDtkYX9jTo/cMKtuulgE3uSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=CzD7Fy3x; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="CzD7Fy3x"
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 83DCF45ACA
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1706798255; bh=5Fnb4z9xsKpaQ/5Dt7jqZU4EVkp2u0kZX01kgfZOPow=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=CzD7Fy3xseFNYoilZGbjaKQZvcBEjGA8jOczgXT0qPx6fwDa4xmUE1GiR7uJqDMK8
	 GirBjNifgnyFs8+DmQZEUeQOlYwnlWJ4x3ZQi37U2sVfEkUH8DAiNLsE9ujy6HLFvu
	 +gGIZgOmR9yDjzQru/fkqRdnkXWLIioxlESUVLZVF4xTS1ihjjUg9O0ppMqJmoY8NX
	 W6Rujz8OytwHp8ne2wOZpKra7JlWTx79BUMqsR95ADgZVXrZtIH6FbkbetszmIqVIU
	 frg8tdtFUra9H/8GeWUNZADfzGIH+9pGowdfL4fgqdD5tPOTV7JUU0C9JA1NnWy04B
	 sV0NH2EZa19xA==
Received: from localhost (unknown [IPv6:2601:280:5e00:7e19::646])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 83DCF45ACA;
	Thu,  1 Feb 2024 14:37:35 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Justin Forbes
 <jforbes@fedoraproject.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Jani Nikula
 <jani.nikula@intel.com>, Vegard Nossum <vegard.nossum@oracle.com>, Sasha
 Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.6 003/331] docs: kernel_feat.py: fix potential command
 injection
In-Reply-To: <2024020151-purchase-swerve-a3b3@gregkh>
References: <20240129170014.969142961@linuxfoundation.org>
 <20240129170015.067909940@linuxfoundation.org>
 <ZbkfGst991YHqJHK@fedora64.linuxtx.org> <87h6iudc7j.fsf@meer.lwn.net>
 <CAFbkSA2tft--ejgJ58o3G-OxNqnm-C6fK4-kXThsN92NYF8V0A@mail.gmail.com>
 <2024020151-purchase-swerve-a3b3@gregkh>
Date: Thu, 01 Feb 2024 07:37:34 -0700
Message-ID: <87le842qtt.fsf@meer.lwn.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:

> On Thu, Feb 01, 2024 at 06:43:46AM -0600, Justin Forbes wrote:
>> Well, it appears that 6.6.15 shipped anyway, with this patch included,
>> but not with 86a0adc029d3.  If anyone else builds docs, this thread
>> should at least show them the fix.  Perhaps we can get the missing
>> patch into 6.6.16?
>
> Sure, but again, that should be independent of this change, right?

Yes, it's an independent change but seems worth backporting if people
are running into the issue.

Thanks,

jon
