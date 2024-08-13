Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642E73A8CE;
	Tue, 13 Aug 2024 14:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723558866; cv=none; b=AYWjNyJCIZK12ImY+yWDYPHWFlNqN1wZTFdG1rdvS3dxiUM7u0qYovD7WUtgrr08ZqWebePOwJj9my/acx5MQZxE621PLotjgCWp2lWcp7ZESa+eYhBj11v5mYditsOCpxKXXj4hoWF/dNhMgH+WI9Qn8rp6JT5hxFXan9whNtM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723558866; c=relaxed/simple;
	bh=huR3h3AmWTZYJ7sJJgMy8wBRJAm5Oy/zAK9OtWtxJwI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HTlM+Yt1jWmvGoLns3A1ioIh3bQlBGI3HqnHoj4qaPFFOFstiASJDEDS9DZ7eh4Uu0PJ1U+UfJDl4+ZffazcnvhMrmt0NsRIXViBtL5xcr6Dv8hex0GRTi8n6sKH9Bft4fgVclmcj8DF9rF7ASXlnqqEf17R3A361bJ0Kk9pG4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dD6f9536; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dD6f9536"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FF76C4AF0B;
	Tue, 13 Aug 2024 14:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723558865;
	bh=huR3h3AmWTZYJ7sJJgMy8wBRJAm5Oy/zAK9OtWtxJwI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=dD6f95365Pa51QEz6SOX3Qn7YQ8QTlyRueuSbX5H07sCSQN9Pa/jpideKjzQJFBzP
	 JKDWWxEIdEEP3X2iqE0jlxmS2Zro4cOkw4OXt2fZfwiPK4Udm3vMG8iMuHNOpZm10b
	 6zP+lPuMUnM37C+jSgUiw/TOHa3vKN99aStW0sJw=
Date: Tue, 13 Aug 2024 16:21:02 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kevin Holm <kevin@holm.dev>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Mario Limonciello <mario.limonciello@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Hersen Wu <hersenxs.wu@amd.com>, Wayne Lin <wayne.lin@amd.com>,
	Daniel Wheeler <daniel.wheeler@amd.com>
Subject: Re: [PATCH 6.10 257/263] drm/amd/display: Defer handling mst up
 request in resume
Message-ID: <2024081345-eggnog-unease-7b3c@gregkh>
References: <20240812160146.517184156@linuxfoundation.org>
 <20240812160156.489958533@linuxfoundation.org>
 <235aa62e-271e-4e2b-b308-e29b561d6419@holm.dev>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <235aa62e-271e-4e2b-b308-e29b561d6419@holm.dev>

On Tue, Aug 13, 2024 at 02:56:18PM +0200, Kevin Holm wrote:
> 
> On 8/12/24 18:04, Greg Kroah-Hartman wrote:
> > 6.10-stable review patch.  If anyone has any objections, please let me know.
> This patch seems to cause problems with my external screens not getting a signal
> after my laptop wakes up from sleep.
> 
> The problem occurs on my Lenovo P14s Gen 2 (type 21A0) connected to a lenovo
> usb-c dock (type 40AS) with two 4k display port screens connected. My Laptop
> screen wakes up normally, the two external displays are still detected by my
> system and shown in the kde system settings, but they show no image.
> 
> The problem only occurs after putting my system to sleep, not on first boot.
> 
> I didn't do a full git bisect, I only tested the full rc and then a build a
> kernel with this patch reverted, reverting only this patch solved the problem.

Is this also an issue in 6.11-rc3?

thanks,

greg k-h
