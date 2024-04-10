Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C895C129;
	Wed, 10 Apr 2024 05:46:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712728006; cv=none; b=VIJ1t8j9zcN16kygvRrCkJlwr9PaiMeHxOQs18xpuv0CCaiadrzQa8POLeT0KuRsXGQC1rYA+0ZXbkjHsBJImVoO712xBGWba5aoezG6xTUv0wfMoxCtYZH2eu8G5M70lgRMXkiys1R3ZJjtgGSX/zGfCg7YhxKL21+/8HLg7Ow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712728006; c=relaxed/simple;
	bh=O3EKkrmU4Chul1SEiikEmCq/sj0SnbTUXOV5OWsRMww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IA76qXvD47ZwyGGf/DlLDBDzXnoGhdQO7aElKdsX1D/ribygGLGXIlYLabtWsrGFl7Xp4s2O6DNY1f2BS3CKpY4D6I/pLsxPR4ya3ACWnPbX6xEd2yFsim6CT6HV+G2Ni42NoApr/pBXf0ruCI77KbQFi1a3jzNXdr52SxELG7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9d25Zxm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9d25Zxm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB60AC433F1;
	Wed, 10 Apr 2024 05:46:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712728006;
	bh=O3EKkrmU4Chul1SEiikEmCq/sj0SnbTUXOV5OWsRMww=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=e9d25ZxmFEWUJaYgOaxcQTXDYCppgh7JBQmzCEtctydJp15h+L/wu7l+zfk9ojkTR
	 9AEDWuDHJXm7lDcN6FEHJ83eEhQgi+tv7cLKiLk/LUSjFlmLUyPtloz5IRP7dda0sR
	 wD38vRuzmao/T+cG+CHegQusxKLm4mflkeekb9H8=
Date: Wed, 10 Apr 2024 07:46:42 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Pascal Ernster <git@hardfalcon.net>, Ard Biesheuvel <ardb@kernel.org>,
	stable@vger.kernel.org, patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>
Subject: Re: [PATCH 6.8 271/273] x86/sme: Move early SME kernel encryption
 handling into .head.text
Message-ID: <2024041024-boney-sputter-6b71@gregkh>
References: <20240408125309.280181634@linuxfoundation.org>
 <20240408125317.917032769@linuxfoundation.org>
 <76489f58-6b60-4afd-9585-9f56960f7759@hardfalcon.net>
 <20240410053433.GAZhYk6Q8Ybk_DyGbi@fat_crate.local>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240410053433.GAZhYk6Q8Ybk_DyGbi@fat_crate.local>

On Wed, Apr 10, 2024 at 07:34:33AM +0200, Borislav Petkov wrote:
> On Tue, Apr 09, 2024 at 06:38:53PM +0200, Pascal Ernster wrote:
> > Just to make sure this doesn't get lost: This patch causes the kernel to not
> > boot on several x86_64 VMs of mine (I haven't tested it on a bare metal
> > machine). For details and a kernel config to reproduce the issue, see https://lore.kernel.org/stable/fd186a2b-0c62-4942-bed3-a27d72930310@hardfalcon.net/
> 
> I see your .config there. How are you booting the VMs? qemu cmdline?
> 
> Ard, anything missing in the backport?
> 
> I'm busy and won't be able to look in the next couple of days...

As reverting seems to resolve this, I'll go do that after my morning
coffee kicks in...
