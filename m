Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D1D439F86;
	Sun, 18 Oct 2026 06:48:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792306087; cv=none; b=m1QJuJx6rn6ustnjQJpBJlyDN0DxIKdFzmTvSo4BzfhPlacaSB5GxlayL8/K+fkpvxD9HuXHYTQh6OBZZk+G64RaZLUCWDdPkC0dWLSK7kVcR+ey45UVWzMR6Gp6M/MlIIhV+5zh7Q7O6lbKONdiGMeBJE2HBVhJyWVsaI48xpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792306087; c=relaxed/simple;
	bh=iQfvt4g+CBd4iwWQTbU00WFNMQTH4jC26Fv3rG1YsdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IJqCfa7e0IfD86YqAktSD1iSDx8jfKmZccekjIXFGOYtT/Yylmj9o5veUEDb/2ubJIw3o0gWZk7GWo4HOIEZjTtFTGwfzJnWB2xueLtyUCqyAbdDp2UkY1UgC5MzsPqn4pnFg5a0tSu/qgr/985CX1C8+0/yktPoivNKIsCVHPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qVG46ChB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qVG46ChB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6DB21F000C4;
	Sun, 18 Oct 2026 06:48:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792306086;
	bh=38CxoU2lnztbMqacap8GKTToa+yQxjEToffmo0cfXhU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=qVG46ChBzz1aJjQAs5Tq3lcCurn54VhoQkaR7N3oAtV95nhbJo0VF9u/6YnI2qJg+
	 AlniwX7j5rkwxZBaXEMLYWOV/n9s4KXCd4WptBTj/QThr7p397x8/XikYSNLkSdl8D
	 lYN13pssYlfYbjVdBwd8y28CNpwhZbWfbcoSIL/g=
Date: Sun, 18 Oct 2026 08:48:03 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Wolfgang Walter <linux@stwm.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: regression 6.18.57: acpi power button vanished in machines
 running in qemu
Message-ID: <2026101834-parchment-reps-0bee@gregkh>
References: <5fe757e7aa54c38df3525d313598db99@stwm.de>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5fe757e7aa54c38df3525d313598db99@stwm.de>

On Sat, Oct 17, 2026 at 07:26:54PM +0200, Wolfgang Walter wrote:
> Hello,
> 
> since 6.18.57 there is no acpi power button any more in virtual qemu based
> machines (as far as I can see model doesn't matter).

Can you use 'git bisect' to find the offending change?  Does this also
happen in the latest 7.2.y and 7.3-rc releases?

thanks,

greg k-h
