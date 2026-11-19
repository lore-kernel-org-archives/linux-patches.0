Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058425;
	b=AXge87LURLP2AS42OuztX7GMKo6MrDM0kepD0PMtYbgpd5S10+UaQxUdhETH05P8HfLb
	 h1fHJMslJGV+9YsfLFZVnP3KaHznEQ1VRAsxTxPhzLroufevhYNpPQzsd72upRCq4dL+c
	 DqrQek/8zLrTV4mQa6l3wXJugzXdKpfptRTXC16RXA0HTeq8wA25EDGqmQS3UUX2Rha0u
	 EHYXxkQjdiUCL6lOl8n0w5azgjdmgGz7BEng/4DYmmlYeXXDfTtX5Z9N+94P7qrA+9kie
	 eGQoRvIDSsnE8Bp08TYsTCTkRNkNtzRJitc57GRwTGP/mSoiVrVJY80PpeilhflW2sA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058425;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=8vivqbeMZlQVIuNOlIzi61KdnMWeRa64jhoNAmgnXdo=;
	b=Hce08FS7cfanFo14eEFL0sFsqsx5q8eWYcNhF/D1YviDHQOdsyklahZ/dTCZ7UFqQhD3
	 8sRpDqe9MrAs3ESa9Jm2KubInESuTbPBRr4235vi4RaWF3wongsmli6MUeXl6g9J76wdZ
	 jYsS9dJ4JJ0XxUhrMkYfek0fQfmB3bg+RDSu1DzOg0TaE6I10WmnfKbh+FPPWQa0rk/ly
	 lVn4A+PyskgdYBUHP3UTb34C9PyZe1Mdmjug2+7GUEESSh8xCtAM+ZV+czEvOD4yBIYlN
	 xVVAIRTG96ByRF0eW153pxB3zyjhyU0VbScTqQd5GvlDA2drYi81WjNZqIP5azYfqtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kDGzcMSX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FD69606A325;
	Thu, 19 Nov 2026 03:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kDGzcMSX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6175A1F000C5;
	Thu, 19 Nov 2026 03:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795058425;
	bh=8vivqbeMZlQVIuNOlIzi61KdnMWeRa64jhoNAmgnXdo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kDGzcMSXYyHI2t0ZAqLpku1lM/an0BdStxVyKJrr7E8mXwefYG4NnLoepEVuANb4Y
	 UOIGYFoo1IrSdfGJbagEyJVDdLSH4Z3kkh9GRJmHEEkzd22Kmn8041Leg//EzpM1xR
	 XiAl/sgkT/RjzX7+ZDtdd9c480gVg+MCQOFYfPt8xTuVzTxVTGToeD0zbij4KWt+sH
	 JZcA1c6VFi19A2yWPLhkYIfFIbBNhmgTFLcp/a2UyXqYtN69nFgnf17OLJMP+sBT5G
	 iDGF8wSYruvKcyAaBzOYZmApsNzVcLrQZHU9/OgMCkPzzs6+obtppIwqfWYtpdJxBu
	 QoPcskYZ1Y1hw==
Date: Thu, 19 Nov 2026 08:50:21 +0530
From: Vinod Koul <vkoul@kernel.org>
To: Francesco Dolcini <francesco@dolcini.it>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Aristo Chen <aristo.chen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 7.3 1238/2651] phy: freescale: fsl-samsung-hdmi:
 initialize default rate
Message-ID: <av5q9YYIpTIGj04t@parshuram>
References: <20261118150247.972732815@linuxfoundation.org>
 <20261118150332.571312313@linuxfoundation.org>
 <20261118223142.GA597634@francesco-nb>
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261118223142.GA597634@francesco-nb>

On 18-11-26, 23:31, Francesco Dolcini wrote:
> Hello Greg,
> 
> On Wed, Nov 18, 2026 at 03:41:18PM +0100, Greg Kroah-Hartman wrote:
> > 7.3-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Aristo Chen <aristo.chen@canonical.com>
> > 
> > [ Upstream commit c01ccf91b257741e9edc374a465126bae9ae4711 ]
> 
> This patch introduces regression in any RC release, 6.12, 6.18 and 7.3,
> please drop it.

Yes makes sense, lets drop it from stable
> 
> Multiple people is affected, and I did send a revert 2 days ago, see
> https://lore.kernel.org/all/20261116162409.218059-1-francesco@dolcini.it/

Ack

-- 
~Vinod
