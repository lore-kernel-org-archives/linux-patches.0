Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 109B41877;
	Sun,  3 Mar 2024 07:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709451396; cv=none; b=SOp/hLPRokZH1/YHPuUalPgtOvOV1w2IDu3UPQSLviXrKkip1m8AvanAzTa3/hCvxp5OO0VEupioQuwm0kb3DwzdvdA0tUdJ6mzLUzeGORWBbmc9fCtk8wzIqgAi0wswlnDBDXVFRQgsLc1sTDcfqNoX/AiBZFPWshK+I0N1au8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709451396; c=relaxed/simple;
	bh=Z8h8eVJYGBG8iV2sg1TpVEiLIPVClTONfsNOE/4fmnA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qya7rP8M67XZ4716pNnkACngbpCa50r831jONpk7+UwJDLo66W4To6mkioIDYysd73iWU4c4nCnsr3STbk+Sj6RHIFGiug7pQnF47ynf6Bk50szk3hsjGphRe5Nbq1lMJUkcZQhJthTfCnRqEDE1JzRVueLfukdpeYS1WJ0paJY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A5UDItbY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A5UDItbY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 817CAC433C7;
	Sun,  3 Mar 2024 07:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709451395;
	bh=Z8h8eVJYGBG8iV2sg1TpVEiLIPVClTONfsNOE/4fmnA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=A5UDItbYzO5/4cW691q34mb5yx7EBW2hYxqfwSY8SBfe09L7pngR+5m2blbapnlgK
	 KqFLgvXxmKem0N2smE/dsJHpyh4mgdA4h98nw1X5vJ+1/VJVt8jAsVh0mCZEMFWJao
	 8YpSHHZxblUWZZXfaijCH3nQIS2YXr2ThVR5m2gI=
Date: Sun, 3 Mar 2024 08:36:33 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jeffrey E Altman <jaltman@auristor.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Marc Dionne <marc.dionne@auristor.com>,
	linux-afs@lists.infradead.org, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.4 032/267] afs: Hide silly-rename files from userspace
Message-ID: <2024030356-moody-flight-5f4f@gregkh>
References: <20240221125940.058369148@linuxfoundation.org>
 <20240221125941.044302264@linuxfoundation.org>
 <03aa52e3-7ab9-484e-9ad2-b03938d2019b@auristor.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03aa52e3-7ab9-484e-9ad2-b03938d2019b@auristor.com>

On Sat, Mar 02, 2024 at 11:32:04PM -0500, Jeffrey E Altman wrote:
> Greg,
> 
> If its not too late it would be best not to backport this change to 6.7,
> 6.6, 6.1, 5.15, 5.10, and 5.4.

This commit is already in the following releases:
	5.4.269 5.10.210 5.15.149 6.1.76 6.6.15 6.7.3 6.8-rc2

> This change can result in an infinite loop in directory parsing and the fix
> for that has yet to be merged by Linus.

Is it in linux-next with a stable git id?

If not, we can revert it, just let us know.

thanks,

greg k-h
