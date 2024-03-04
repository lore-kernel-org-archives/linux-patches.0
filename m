Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 566807D3EC;
	Mon,  4 Mar 2024 23:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709595994; cv=none; b=Ch2o5TCJvZe94/wf6/ivsWbp5JOurmr8fP15kJWyq2H7mZJdra3czE49U04meGC789RuvUbl9Au5HJ5nzQju3QSRWSzTh6pZz+29YzBAaag8KDRu05Rn2lmvhu1tn10Sk5Z4Rk4GcNrqH2eVWDqOKYv/evad8mDJCvUHDNpC73E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709595994; c=relaxed/simple;
	bh=LSAKc3FQgIkO0qXl+59tXDH4qtEfz5/s1oe9x85k24c=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=fNyg7XqBic4mJmpe8RHF3dPfQBZAyuz8M1PLSi2YTFI3jOBP1XbJJ1duui1D6ECJTarFPrTxQF989J0uxG8Z5gEKmuTRBkwFPF7A/qcXk3DT3thk5iZ3uIikLwx/GhvyMtpC4i0WzMsRelhm023SA+5tvqAvYsqdvpdwyi2nuWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EIevkZqK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EIevkZqK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72C8CC43390;
	Mon,  4 Mar 2024 23:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709595993;
	bh=LSAKc3FQgIkO0qXl+59tXDH4qtEfz5/s1oe9x85k24c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=EIevkZqKMSim3nbnE9VCzWvUECit4Q+FraGLwyuHlgkgdzGMcGN5Pt03aBTe+vnoB
	 wpo/nQHiWMQAXY6Lam3ZjynldkUz369vgyshosUmcKvgFLvlGujaq7usSmfMO/1r/H
	 uQEpIgGl7T0IWKVwuLHimlfewAOk0j7j17xbMEPg=
Date: Mon, 4 Mar 2024 23:46:31 +0000
From: Greg KH <gregkh@linuxfoundation.org>
To: Arnav Kansal <rnv@google.com>
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
	dvyukov@google.com, elver@google.com, glider@google.com,
	hpa@zytor.com, mingo@redhat.com, patches@lists.linux.dev,
	quic_charante@quicinc.com, stable@vger.kernel.org,
	syzbot+93a9e8a3dea8d6085e12@syzkaller.appspotmail.com,
	tglx@linutronix.de
Subject: Re: [PATCH 6.1 214/219] mm, kmsan: fix infinite recursion due to RCU
 critical section
Message-ID: <2024030457-aware-trusting-9e48@gregkh>
References: <20240203035346.771599322@linuxfoundation.org>
 <20240304222011.2221862-1-rnv@google.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240304222011.2221862-1-rnv@google.com>

On Mon, Mar 04, 2024 at 10:20:11PM +0000, Arnav Kansal wrote:
> Are there any plans to backport this to 5.15, or 5.10?
> 
> The buggy commit (commit id: 5ec8e8ea8b77 "mm/sparsemem: fix race in
> accessing memory_section->usage") this commit fixes was backported to
> 5.10 and 5.15 and wondering if there are any plans of backporting the
> fix to 5.10, or 5.15?

Does it apply cleanly there?  If not, can you provide a working
backport?  If so, can you send the tested commit as well?

thanks,

greg k-h
