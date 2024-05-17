Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222C012FF6D
	for <patches@lists.linux.dev>; Fri, 17 May 2024 18:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715970566; cv=none; b=bdct7YS+kEtShwfTJr4RIVdc1g5VQE7wWPQXQolfkra7HiCHrNr+b1LmCFb3EeZQOV89nXBxZya0djfINfWmKlnsIhvnylkBz26m8dfJdxasDVK/7s+gZVo1l2w7XmAo9xMkysMJeJJQ23YIG6hgD9cTrcLW1y1d5mZAckIfL84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715970566; c=relaxed/simple;
	bh=df+lEAM18IB6tecfCHigBHT3gT3NP3mvFuDueA2ulTA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Ce074IfVQSaP+sTn1xm4ZDfA2rVXDctjnnYpj+0+RnESH68ovn5N7dZvZMY/vSKU6ebmKk4L92ctpr07WiVFVMz7kCovql6Mb+e3y7LOgIDSHn5nieuJKNjQ/YfR9CX+ZaLa3n+U6Swt7Zb1I1m3+jZqTcgSYzaMBrVIJMxFYoI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=ApTxYsNI; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="ApTxYsNI"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 98F4340E02A6;
	Fri, 17 May 2024 18:29:21 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id bmz9oZhizfq2; Fri, 17 May 2024 18:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1715970558; bh=/NB5BQv4FVCJGiaPuaya/FSVElUlT/rXVpI7wxyep7s=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ApTxYsNI6qiO/wGxpxZyJ/HWrT4rgnWdpLhfWX2Hr8QRf8SB6dNUdWI5S0oknAMKR
	 GkgruKDoZU47rSiYHJno+MmZPSvK3Vy3L/eBwSg1dzXOnRA2OTfiJBMF/T5eBQwR75
	 mzW1RwaSw5hCwBBHYwZL2SuXGcnf94g/vqSkOa5FlrS45RfzWgkmvoXs/lLpkYg0Yr
	 IwF6epYEFmWEVY9J86KpNR7ZEws39vQGx2VnDTXGaO/3+wgIlFjXHWhe6f8elI0Y9q
	 +7mmfkxQ2c3QTQgmE/5autkSNAACgCXLYZqYY080QgTiYUmfHFA7mwOI4Jj3Tl6MQD
	 ulj2WXLzVw36qTtdwOf9SeNtRhf3eyFJB5Fa2TZAlZGDicm1Q9SsmIbFqAfaXzgNSV
	 AzNJ5lNexMPlo5ggLuHXu1YdPBBKSWXCjQs2VQlO0jaqWRfV0djF7jtMLd2KlblsBr
	 yUdzeVx8sK/spF/TD3DPcBbXP7nGpyHE3Grj/y3WHwCm8gz4hQ9+RMhFuOkpJpCEkr
	 8e3BuUfwJqaePSaWpUNKTk7f79tx9ai6L9XiGU765cWKc76FjU0Z/ualpEGPjwCFHf
	 G5UKsZOPlq/ib6XLKsg/hP9YHR3kRpnYA78QvvOD3NlcqYvoG5jwMHcNBw+YE8eXfo
	 rFsfMy+mEfh2p36EZBRPkV1Q=
Received: from zn.tnic (p5de8ee85.dip0.t-ipconnect.de [93.232.238.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id D649D40E023A;
	Fri, 17 May 2024 18:29:01 +0000 (UTC)
Date: Fri, 17 May 2024 20:28:56 +0200
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Luck <tony.luck@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Uros Bizjak <ubizjak@gmail.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Arnd Bergmann <arnd@arndb.de>, Mateusz Guzik <mjguzik@gmail.com>,
	Thomas Renninger <trenn@suse.de>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Andi Kleen <ak@linux.intel.com>, linux-kernel@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH v3] x86/cpu: Fix x86_match_cpu() to match just
 X86_VENDOR_INTEL
Message-ID: <20240517182856.GHZkeh6DOiNa-23-EW@fat_crate.local>
References: <20240517172134.7255-1-tony.luck@intel.com>
 <20240517173811.GFZkeWAzKjYtEMwe1e@fat_crate.local>
 <EEEDDDD9-3514-4246-B506-6A1DBD5CF794@zytor.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <EEEDDDD9-3514-4246-B506-6A1DBD5CF794@zytor.com>

On Fri, May 17, 2024 at 10:46:29AM -0700, H. Peter Anvin wrote:
> Thought: why don't we add VENDOR and CPUID as synthetic CPU feature flags as well? Not saying it necessarily solves this specific problem but it might make some other code more uniform. 
> 
> Obviously on x86-64 CPUID is baseline; VENDOR might not be known, however.

Well, there's only a handful of X86_VENDOR_UNKNOWN usages in the kernel
so meh. Or do you mean something else?

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
