Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994E62FB62A;
	Wed,  3 Dec 2025 17:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764781310; cv=none; b=kDUXZXVOh7cE37YK2boNjJb/V5mdwENdU4RE/JkTDFCXHTd1U6fU/wbB3n/jCSS691675lQCqnQ6Ki+p8nIFaNxPtTekI+vpSQyAYdZo+NZIe8IvEnxKU1uugvGYc2kzLXdpkNuI/Up+KXNk6ATWBkWz3QSRRMFoWKngUU5c/DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764781310; c=relaxed/simple;
	bh=Jz4j48Tr4wWmRBTPZRktRDrZx64BcBwRAQmwpwxIJ9E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h57MY11z9/52wFxbPL0LFvddgjOVHcP24g04L+6DC6ib7J+lOJcqqebPuHaGvwg8hGOc94YH0u0WFhUcZeEB+zFPzbIz+uMYuDcGUAyFQQdsltc2X4SnWloMdzUkAJvtHzooczQ8evAhs4n7VGElyYsqcigi6BsRbTqZZsP+5Qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gN3CFo36; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gN3CFo36"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13A30C4CEF5;
	Wed,  3 Dec 2025 17:01:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764781310;
	bh=Jz4j48Tr4wWmRBTPZRktRDrZx64BcBwRAQmwpwxIJ9E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gN3CFo36Lx6VrgMNSnybNYl/cWASD2EJc5FjBO7pLwqFcyhFlWAFs6AESCdH0z0jd
	 XPqT8tzqQZLZ5m6NJzFl+VV2+EW4B7X7zhEE1Ijhu+p8qUtJ5CM/Bf7nQkfKaOLDXj
	 GYy2LJubOCBVYR1gSACgXP5PjMr9L0G1eFKK3xPU=
Date: Wed, 3 Dec 2025 17:24:03 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Christian =?iso-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Prike Liang <Prike.Liang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: Re: [PATCH 6.17 129/146] drm/amdgpu: attach tlb fence to the PTs
 update
Message-ID: <2025120333-earpiece-dragonfly-457d@gregkh>
References: <20251203152346.456176474@linuxfoundation.org>
 <20251203152351.182356193@linuxfoundation.org>
 <725a5847-9653-454e-a6f6-5e689825d64c@amd.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <725a5847-9653-454e-a6f6-5e689825d64c@amd.com>

On Wed, Dec 03, 2025 at 05:03:11PM +0100, Christian König wrote:
> Oh, wait a second, that one should clearly *not* be backported!

Why not, it was explictly asked to be backported:

> > Cc: stable@vger.kernel.org

Did someone add this incorrectly?

confused,

greg k-h
