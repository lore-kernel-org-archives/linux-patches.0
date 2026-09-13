Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A703B3BEF
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 11:11:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789297877; cv=none; b=moJLKS+lATlxwlJqSA4Gy0E4sgHporqOhHy0oR3E1k7/QWsczAGWkC38P5BD5ZCdMAG8GhJeG7GFSj/LlAIBTWF5lQiQdnIzcouLJTpiuXbAt5SWdgRbojIhTCbWghs4+GJPZxO4L45fWSe3ylYwUmi62kCkfLMbwgVIUBw7gqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789297877; c=relaxed/simple;
	bh=o/crwe87fYD7qW90Fm+rwOvNErVmvLHTv/kmQxU6Cxc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lNOrpfcbooH8GOU4465YdcI+Ga/0DA6G3hYyCCfsE2ATi+tTCQ0kT5sI9Bjrpw2YiEDHDhq/z15EbvNTuRScGSkjpn7VHM5uzHgzcfzMFIZGEIjXBS8LgNZ6S0WHAeGoY7GeDhnf630DzhoD7+bIkGoUNN710NsFuRyOZxamTvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=FUrP9qBP; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="FUrP9qBP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1789297868;
	bh=o/crwe87fYD7qW90Fm+rwOvNErVmvLHTv/kmQxU6Cxc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FUrP9qBP68NCSH2N0GSVG7tv1tgMOsq07FGl6q8Lfu1wCg4yiqh+0E8lrQbremPE4
	 Dn5b5uusF8oe7PINveHJyOnQQqnic9bBzZSr/MBMDpInnNnxuQZDDaC8ugi1BhKgxU
	 HCUCMNGOMqdEY2s3lGwKZWNMAlPyltulRRUDK1kk=
Date: Sun, 13 Sep 2026 13:11:07 +0200
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>, Thomas Gleixner <tglx@kernel.org>, 
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.18 0248/1518] timens: Remove dependency on the vDSO
Message-ID: <836d73d0-163b-458b-8481-60185f88d577@t-8ch.de>
References: <20260912065623.398859879@linuxfoundation.org>
 <20260912065629.093403177@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260912065629.093403177@linuxfoundation.org>

Hi Greg,

On 2026-09-12 08:40:17+0200, Greg Kroah-Hartman wrote:
> 6.18-stable review patch.  If anyone has any objections, please let me know.

I object.

This now lets SPARC enable time namespaces. But the SPARC vDSO can not
handle those (yet, in v6.18). Userspace will read incorrect data
from the vDSO inside a time namespace.

(...)

> Stable-dep-of: 06aba58e5849 ("time/namespace: Validate nanosecond field in proc_timens_set_offset()")

This does not look reasonable to me. The mentioned commit should be
backportable as-is, without pulling in four additional patches.

If you want to keep this patch, at least drop the deletion of

	"depends on GENERIC_GETTIMEOFDAY"

Thomas

(...)
