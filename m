Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 641C53002D1
	for <patches@lists.linux.dev>; Wed, 10 Jun 2026 19:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781119330; cv=none; b=Uzguwd6XgqnYJBr3aYMT5+rMAJfpdDqQ3XzrnENANOW6FIMW2Zw5Zsc9sIEZYcmLTQuYaim4Vs0ovE9peWKFT0NQmTB7usSIqZo8z3o6zVUK7K2vmNYYDRQPii88wZ1fkeEgsZtBeFoFkIkavSJpFUrmocqw119lCPiInn2jmdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781119330; c=relaxed/simple;
	bh=0qrtKIrXQHyuftOxv5j4FcsH8NaGxLW71EiWaSAHaBU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CHSmxNGgTikLrJL6pPgV/WJJ+YamyIM+Q/2njwDL8GGoo1xmjrAsmYvwtVnqK+ct2nl9CIffzQ82vbjaKxrb+f+VEdgP2qyhzpMSZ4qUwYWYh9nBIRb/LM3Ygrp9mXESuqNRTRd+74xs2oQFKm45jcTN/Cxs3uX/40pnoJufLDI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=K6GClaZs; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="K6GClaZs"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 4341C40E0215;
	Wed, 10 Jun 2026 19:22:07 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id 1Te8syyovWE8; Wed, 10 Jun 2026 19:21:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1781119317; bh=/yQG4T7dXwxzL5IQvBPouVF2werFUWkVrk3BmI1NUOs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=K6GClaZsIcO1wnvYunBKV42BoD525oNzJg7Dmu6AECaIAujk+q3rd2tWFvSOKKpkU
	 LTDhNb7+OSAStpWVFVCRX6rxm3c9CEyQ1Uqjqn9Gdtazr9pqE3gHp6gBr6xjW7ai0g
	 OvCkN1Bx6MwlMNXxx3JrLrwwWoUdKs/oVOPXV6FQ1tWwN5SGQ8l5Hdnt7rbxgn67ZN
	 L8S6hrvVh57R20NrxpLi9ha7Oo8ccCLQjXycuJY1oKMBEiqLBQW2E9ujiQU7hSO1F5
	 4BGYWiN6gt/udVBWuUUF+GspJ7FgDsNMpfy507bG8vRdfgrXvuHuqiQlO0SF9f99K3
	 tdqwoSRNrSTtl0S3+4fMqDnNzlN+Qdjq/cbim4K9G+5sAjiAn/PGQhl5iNuoM0Y6de
	 2R2/lk3tVCW3O3Pxvahq3zvR2zP7Hj53xfEstIXBkssL6R4joeb2OlSfRtjqEXf9Qw
	 9SyIJsheFVDtwXkDoJFmP5ZlzW7YI3vOubTZ5R/yHag5a7KGswAab8MkPZum8pls+f
	 BD0N9tpQKswn0eiBcGnu8h7gy/Erc1ILWPWNDfq6rI+y3wKqm2zYeTplxLioLarMHz
	 XAKbiyKFvwSY9p5/b+RoMVSMwgNCKI28mPCg0IffidaMLqjiQ25x1ECPzyt9L8urpl
	 FARtz3CGKDR80IAZBfBLpKEE=
Received: from stx.tnic (unknown [IPv6:2600:1700:38ca:c00::1a])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 8535640E0177;
	Wed, 10 Jun 2026 19:21:40 +0000 (UTC)
Date: Wed, 10 Jun 2026 12:21:37 -0700
From: Borislav Petkov <bp@alien8.de>
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: tony.luck@intel.com, james.morse@arm.com, Dave.Martin@arm.com,
	babu.moger@amd.com, tglx@linutronix.de, dave.hansen@linux.intel.com,
	x86@kernel.org, hpa@zytor.com, ben.horgan@arm.com,
	fustini@kernel.org, fenghuay@nvidia.com, peternewman@google.com,
	yu.c.chen@intel.com, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v5 00/11] x86,fs/resctrl: Fix long-standing issues
Message-ID: <20260610192137.GCaim5QSFx-YKgAzSV@fat_crate.local>
References: <cover.1781029125.git.reinette.chatre@intel.com>
 <28449c4f-49e6-4342-938c-4a3699e3d682@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <28449c4f-49e6-4342-938c-4a3699e3d682@intel.com>

On Wed, Jun 10, 2026 at 10:48:06AM -0700, Reinette Chatre wrote:
> After considering the latest Sashiko feedback and deciding to stop adding
> new fixes to this series, I do think this series can now be considered as
> "settled".  If there are no concerns with this series self then I would like
> to proceed for it to be considered for inclusion.

Ping me after the merge window pls. They'll have to catch the "next train" as
it is too late now.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
