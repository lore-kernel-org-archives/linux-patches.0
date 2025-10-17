Received: from mail.alien8.de (mail.alien8.de [65.109.113.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 310562EB5C8
	for <patches@lists.linux.dev>; Fri, 17 Oct 2025 16:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=65.109.113.108
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760720024; cv=none; b=o/bCPxqpKGmPcvODUgI1x2mkx36yORIWCTuZ8NeBW+wJlVOJ8nxOkBdJ9vVyZCwQqxF/WS3ye9Ib8x/LWw1Oa2fGRA0FO6boJneUoSJvttG9z+VFDxTnpGaEgYkY+mhS+RWuD+0PJOJj+OwRMRUwagqGNgRH5Ogcq8qWXsllFZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760720024; c=relaxed/simple;
	bh=lhLaTP4i6wTM8dhctfYFi0F+wRr7OtCzWVNbtHn/mYI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nRHKmcxzAlcf8Pym6oH3aWbWBxTiRuwWoWlPqKlqIx4yzgcjOvxteAcQ5MirXCj87uxTiDj2JTTaTt0E8fBWLo+MsBGvm2cl1pIcPdxMMdftzRYn++8ZVcy9wR2YKFpZ0IqIWbKX3rPJPxz5M8hJQ+tzvjF6dliOFan/0L3nrLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de; spf=pass smtp.mailfrom=alien8.de; dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b=f99vrMjs; arc=none smtp.client-ip=65.109.113.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=alien8.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=alien8.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=alien8.de header.i=@alien8.de header.b="f99vrMjs"
Received: from localhost (localhost.localdomain [127.0.0.1])
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with ESMTP id 20E0040E01AB;
	Fri, 17 Oct 2025 16:53:41 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at mail.alien8.de
Authentication-Results: mail.alien8.de (amavisd-new); dkim=pass (4096-bit key)
	header.d=alien8.de
Received: from mail.alien8.de ([127.0.0.1])
	by localhost (mail.alien8.de [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id zDbjsLdi0gWn; Fri, 17 Oct 2025 16:53:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=alien8;
	t=1760720017; bh=Bk8lFwaQKYdpxzkysfTwMCZpN29bMISfMdKWT0QHnAo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=f99vrMjsSQDzcDmQBTNQHiV0SRJ7RGbqNYUlYMnYgkcnXOmERXQPqeG+i6jHlZR7C
	 5Yi4ipH25MPMVtt69NbJdpmZ6nubP3rQdwDYsbuy791QZgS4R/fTbq0/6cHIYK6SOX
	 5leHh8BZ7bth3mld3mmvKmv/mSoPB+mea4nNZP8FyFdmstkKKELex58roeYzljEvWD
	 envMMTFaY7eJ5G6c8vGQH1P2tdREWCd8YACvdbIsguHLLwhczsJ46+qj2e0nvdlEkV
	 2rgl/2+Z+zVhZWrJtTQC91qBPnTIyRrMvmt0qR1+qgx1wuEhO6CMz2p6X1Vo5mpq4f
	 R/+NaoYCDXjuHiHrI5Bj6Wzph+PkbwVLd2tYYmJmnnXRCuCjQ1H6A7Jxf/ltHa9E2s
	 6kSU+Gvzii0yUoc+fp/+GBWdsJ37ojCcv4gzXncwV87YQVxSKtkYHa7DmURvZ+fqBN
	 DyRj0BqoCQaZEXhZuN5VOhFeUJka1zEoECg/wuHrQ08PNjZAgDIcFJdKEEQzZSkaiu
	 1AK+WJ1aPSTbsVbYsw823kzLhLfuX39PwkhsoS+7xnhXd2R3+/GfBanTlZN9jP7e1o
	 1NoekcCvtw12d+kUhCtQ9Kx74Krzw1uOd2mLIR+vaX4slha0/SdjnICpOxOf3l6bKi
	 JBgzvRb2xb3ZN3Y/2YtVClhc=
Received: from zn.tnic (pd9530da1.dip0.t-ipconnect.de [217.83.13.161])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by mail.alien8.de (SuperMail on ZX Spectrum 128k) with UTF8SMTPSA id 2C6A340E01F9;
	Fri, 17 Oct 2025 16:53:31 +0000 (UTC)
Date: Fri, 17 Oct 2025 18:53:25 +0200
From: Borislav Petkov <bp@alien8.de>
To: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	Boris Ostrovsky <boris.ostrovsky@oracle.com>,
	patches@lists.linux.dev, Nikolay Borisov <nik.borisov@suse.com>
Subject: Re: [PATCH 6.12 238/277] KVM: x86: Advertise SRSO_USER_KERNEL_NO to
 userspace
Message-ID: <20251017165325.GBaPJ0hXW917YN8BX0@fat_crate.local>
References: <20251017145147.138822285@linuxfoundation.org>
 <20251017145155.829311022@linuxfoundation.org>
 <ba4f2329-8e29-4817-993a-895b8aee4fb8@oracle.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ba4f2329-8e29-4817-993a-895b8aee4fb8@oracle.com>

On Fri, Oct 17, 2025 at 10:11:36PM +0530, Harshit Mogalapalli wrote:
> Also, I haven't yet got ACK from Borislav, so should we defer ?

I assume you're in much better position than me to verify those bits are
actually exported and visible in the guest. So you don't really need my ACK.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
