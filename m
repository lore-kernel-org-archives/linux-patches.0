Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EBE253E31
	for <patches@lists.linux.dev>; Tue, 21 May 2024 08:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716280371; cv=none; b=Nf0WsimoU2q6+NjMeEERBxiIhgFDfN13wd3tPFSgRi6VRMLrES/WLEFtUZ1TYfvF9XvgS4+xndGgMx3T0gAzIpJGZ4KULNWUKLMMorrz6OLTW7XdtaX5savDczHdYLIl8PpReOvneSJpjuxw7X3+s4cABAF//HBNzZL3AtRaK4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716280371; c=relaxed/simple;
	bh=yuk0R3PPjGDSIVmdjaaD6LOqzGinRK6RRZpz5FjM2hM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DRKV5DUgmQVdqf239DE8AbXSPtKugHTWkltPGuYk+4PekVgBQlnWW1RQQ6zdsTPto1+76LpRPHzZ/jDelfjKXu+xDptAc9w0irLWpk55m5dY6MSAipd0XyorcTeykMJniQilVwFlj1+Z2OhDSfvyhi6feEOegbColDSVPKFv/jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=SMX13i6V; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="SMX13i6V"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id EA77840E02A9;
	Tue, 21 May 2024 08:32:46 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id q-qpjTndqK2A; Tue, 21 May 2024 08:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1716280362; bh=G65LmZjfDcpaqhQDZT/O13k+7rVmcMprWbg79/HsMvY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SMX13i6Vt31r8MjlSEnjZAAO/VjixJNf7F8rM7gcg9ZfbQR4dfxIqfK4X3sDc0gKg
	 UV0VE2zdqcgW09jNSW4/UwQRt/SQy7C69+LNDRRxgQVwNOXhCUFStp24s2qq0P/3L2
	 cXXfvktU2+jDIQnMqQA7mT0NluPgBAgRxOZ5qBEO/I0E+sV3ytZXGb8C7pYayeAS47
	 WPK5AFbHXRZ+UvycgOlOMueu+RSL0IFVKTkJhj9A3zatbGY5Gdce6Ug1aAi1DfO13w
	 JCMPCuc02H80ypTLZxfzyXy0tWzWX4G0e9k3i1QB/koMD7fILF7sLhIybu/Na0HOpv
	 HQDv3OGkwb9Brqe4KN0cdDIhFmKhbL0SSA2UdkCWI6Pyx1Fh5PRwe8YZ3HPlJCUNVQ
	 k0TR/mlbmBQZ/cVlxdHDwraR1LsQHrw3AQN0qwWvzZLC6DBIFSDWR/fKmCUbWbAN3M
	 7ogiQ7l4eRbFnZopVp1L37D5wy0Ty+2aSq8uu/x03L1RdyFFmKvFcj2j/5B4iOsHpW
	 J+3I/oJEdfppJflPngAKFgA1qhvU0s1f1pDYc4eVA7MMzg+WF+Hhql+ugtoHS8ycpQ
	 H71bWY0iR3iKVRuqD4yVKsBD5VGUnHhGSyQEovIjEYAqhV43Q98X3EFBw0Pn+DwQnZ
	 jdo/AF+vippql0hamt2hvfWU=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 625F440E0254;
	Tue, 21 May 2024 08:32:27 +0000 (UTC)
Date: Tue, 21 May 2024 10:32:21 +0200
From: Borislav Petkov <bp@alien8.de>
To: Tony Luck <tony.luck@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>, Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>, Andi Kleen <ak@linux.intel.com>,
	linux-kernel@vger.kernel.org, patches@lists.linux.dev
Subject: Re: [PATCH v6 00/49] New Intel CPUID families
Message-ID: <20240521083221.GCZkxcFSautABFdQmg@fat_crate.local>
References: <20240520224620.9480-1-tony.luck@intel.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20240520224620.9480-1-tony.luck@intel.com>

On Mon, May 20, 2024 at 03:45:31PM -0700, Tony Luck wrote:
> tl;dr
> - Please consider patches 0001 & 0002 as urgent to fix a regression.

1 and 2?

Only 2 I think...

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
