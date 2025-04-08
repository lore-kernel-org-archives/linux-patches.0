Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542E61D5CCD;
	Tue,  8 Apr 2025 15:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744125721; cv=none; b=dyeUjY1ygIuoLqU3XNIugqgcd2+diqMGGlFaBKlFi+7OOSMG+llAKpkPm2sZr2gJsETn5VTam73+JOdvuOfa0mw1Z0xHuPKwzS1wDSqth6uEbC+Wbdfl5jzjzOc1gBw4856QdxD9HUsagMXpiA+pdaTQ5JxXd8kuhLR9fw+TF/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744125721; c=relaxed/simple;
	bh=aEccqxi93Pss7RLf1jr/RmT8vl2tP/YjJ/S/HA7brTQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gwuJocv02zOcvNx1mEKK8uAr1pvbvP/1iKG/VJpoFixE4mP9dWEMItavl5sPE4/3Vv4dvTCTFqVHB1OKkauBT1TEpf7cNEu7HOOr/AcXh6cRPVUAC32YRZ8gcK0FcEg1pJavgMU75WAE8p0nxe3lbNW13lHqTstXs6T2aWewV+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=is+SIRCD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="is+SIRCD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0233BC4CEE5;
	Tue,  8 Apr 2025 15:21:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744125720;
	bh=aEccqxi93Pss7RLf1jr/RmT8vl2tP/YjJ/S/HA7brTQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=is+SIRCD5eMbA8msQUV/1Xp72zlGAUSaqPkALSxc2MWkN5arcZzU11N8Fr+kg4+Fb
	 KmeqXkRWt3z+63RZVLk2ViAQHAI+ieliRbKejH+5rASInihb1GOoQejVHOw5rGnmKo
	 KSSYOq7HYzL7AZZsEDNi8qWicvywpcRWwi8OtgH0=
Date: Tue, 8 Apr 2025 17:20:26 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
	jonathanh@nvidia.com, f.fainelli@gmail.com,
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
	conor@kernel.org, hargar@microsoft.com
Subject: Re: [PATCH 6.14 000/731] 6.14.2-rc1 review
Message-ID: <2025040811-irate-cold-152e@gregkh>
References: <20250408104914.247897328@linuxfoundation.org>
 <0e5aaddf-d149-40e0-8604-b3975f3998bb@sirena.org.uk>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0e5aaddf-d149-40e0-8604-b3975f3998bb@sirena.org.uk>

On Tue, Apr 08, 2025 at 03:59:40PM +0100, Mark Brown wrote:
> On Tue, Apr 08, 2025 at 12:38:17PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 6.14.2 release.
> > There are 731 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> This fails to build an arm multi_v7_defconfig for me:
> 
> arm-linux-gnueabihf-ld: kernel/sched/build_utility.o: in function `partition_sched_domains_locked':
> /build/stage/linux/kernel/sched/topology.c:2794:(.text+0x8dd0): undefined reference to `dl_rebuild_rd_accounting'

Is this a dependancy issue, the function is there in the tree.  Let me
dig....
