Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00AE52C11C6;
	Fri, 31 Jul 2026 06:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785480504; cv=none; b=jSfzF8sKTCrJzhVRH+sd8t+wlisgb8oRU9g4BaenPEKLGF0MOkdULt+vNb4CPav7Osn9rKuExm7e/dH2ehBDyLceEMvj7zK/tCAjq525xVFyVz4QBd+OMJLFDdW7JD7L0PDCwDIxPNrkKStiUW2+y0rGlBy/TpNhFcphEiU6bxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785480504; c=relaxed/simple;
	bh=+37+warcQXyTdg8V+TbFbL4Pdv57qbqp3KlgtVk34Ww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gHh+9rjUKGfeHKhVQ69DoqjbD9fvxgQaaY8J2//BTpLtZBTtUqHnPB+nY+Ef33UxtRXkXXjgTE451A51MopcbSOaTdpJusqxOhUG/OzPvKJRaWuq7uMJ82BKSyUb9LkCF+Y0h9iiMpbQCw7AzX6DX34L6T2nDSSU51klpuV4vQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RdWZB/12; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RdWZB/12"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 115891F000E9;
	Fri, 31 Jul 2026 06:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785480502;
	bh=8puoi89pjrjjwjgty8ZZFtCgNyhtaZqHMnJgigBUYdc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RdWZB/12jmIfTu+7Ec2Xs4Jc6sOse3A9gOG8CyPLcQQuz6MkJ1s84qCX4sdOSmUmF
	 UZQDp/oWQrqy0HVQIQjj6bMwCUZYgXA9Qc0qeyjhn9VHhJaIYVobRemjgs20i68p0y
	 W5wChhEEmb/qh0F/9IN7sa6mjbC/aBoEH6aPUlEM=
Date: Fri, 31 Jul 2026 08:48:00 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Frank Sorenson <sorenson@redhat.com>,
	Steve French <stfrench@microsoft.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 7.1 286/744] cifs: prevent readdir from changing file
 size due to stale directory metadata
Message-ID: <2026073141-canteen-flinch-7229@gregkh>
References: <20260730141444.267951807@linuxfoundation.org>
 <20260730141450.369284870@linuxfoundation.org>
 <3f871221-c64e-4a68-95a5-56a9c5ff83d0@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3f871221-c64e-4a68-95a5-56a9c5ff83d0@kernel.org>

On Fri, Jul 31, 2026 at 08:19:41AM +0200, Jiri Slaby wrote:
> On 30. 07. 26, 16:09, Greg Kroah-Hartman wrote:
> > 7.1-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Frank Sorenson <sorenson@redhat.com>
> > 
> > [ Upstream commit e8a8d54c2d508891c142a928fc7d298c4c8bd0dd ]
> 
> These two allegedly fix the above:
> ecababf08905 ("cifs: fix time_last_write stamp placement in setattr/truncate
> paths")
> 0e3ea5445c22 ("cifs: consolidate time_last_write stamp into
> _cifsFileInfo_put()")

I don't scan Linus's tree (i.e. stuff before a -rc) so I missed these.
Thanks for that, I'll go queue them up now.

greg k-h
