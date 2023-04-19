Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07A4C2564
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 07:27:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 272FEC433EF;
	Wed, 19 Apr 2023 07:27:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681889227;
	bh=qBPs4oC4w1WBDc+Fi9gvrTzgv2/ZIaVa9SwRIdvOPhc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BuAcu3n9XOrGnzRT0bX584PCwyZp/zQ30+wKAKeYUVBWytmUaBpNEqznDbbn2n5aw
	 deew7TbcrNO2FHjJT9bqm7gaNdyxBbygDnB6OAlSSFx843ZEviojksrFL+PJo3b5FX
	 EauNbMP9ASd5UZ0hhq766K+dP3AS7yPHfdc/iVU0=
Date: Wed, 19 Apr 2023 09:27:04 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Conor Dooley <conor.dooley@microchip.com>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Alexandre Ghiti <alexghiti@rivosinc.com>,
	Palmer Dabbelt <palmer@rivosinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.1 129/134] riscv: Move early dtb mapping into the
 fixmap region
Message-ID: <2023041948-overthrow-debtor-289d@gregkh>
References: <20230418120313.001025904@linuxfoundation.org>
 <20230418120317.673170852@linuxfoundation.org>
 <20230418-tactile-cocoa-4242e87bf994@wendy>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418-tactile-cocoa-4242e87bf994@wendy>

On Tue, Apr 18, 2023 at 02:10:54PM +0100, Conor Dooley wrote:
> On Tue, Apr 18, 2023 at 02:23:05PM +0200, Greg Kroah-Hartman wrote:
> > From: Alexandre Ghiti <alexghiti@rivosinc.com>
> > 
> > [ Upstream commit ef69d2559fe91f23d27a3d6fd640b5641787d22e ]
> 
> Hey Greg,
> 
> Please check out <e3a6656c-0ec4-9d54-b262-1af08c292ed5@microchip.com>
> (I can't find a lore link for stable-commit@vger stuff)
> as I am not sure whether it is okay to backport this in isolation.

I'm confused, what is needed to be done here?

thanks,

greg "drowning in email" k-h
