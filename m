Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5222E182D3;
	Fri,  8 Aug 2025 17:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754672646; cv=none; b=KhXXizS2ANDbI36JsIgdopWbszV++WfdMamQTBBZS9nnsNh3VouHoGppdG8zYsIqmQq00XZiElD/N0d8s7z1O75gOmo0imuUvP2eNX4Ltlzo5rFq31yXoZkSY9TQ53eTVczjTCnOq2flvAU6U4+I37m11s6PjsNybSI59Nwr80Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754672646; c=relaxed/simple;
	bh=1x1qHlFBl7yOrv3dMBvgEuOQ3c4yYXP9OfIu5ljyKq4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Lyq5S5OJcfA413L0BlyrduBE1tQmg/RN3hSh2NuJJ1IZRcmSaeYlT1bGx52NTuiDweTR2R3pTmz/GaR7OPQkV/uCR56hAtnavh9qVq7bvgeX1QE9phAiAb5hrsvCXwqjTKZfOMcc21MmIINAa5uK4NwuxehH6KBbnxsOTIGXQUU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VsKW5hA8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VsKW5hA8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8392FC4CEED;
	Fri,  8 Aug 2025 17:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754672645;
	bh=1x1qHlFBl7yOrv3dMBvgEuOQ3c4yYXP9OfIu5ljyKq4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=VsKW5hA8wPmgp8sy7LkNtPiwfpcKqVsfIawuPDnGBM8zhJivEtTWBPKQ3Vl/ql4S1
	 eH1ySNTFEueCtU/Rj62cy7ETAcreEwhqktphO4asIbYH59DwUzlwQakxNN6daHQ+TB
	 fDlwYaqACF1QvoCTlUUR9luecJHrADGYNzldSbzSlA2vLKTHrmDjyqDPiEWa2M2dly
	 knr9f1m6fDbb0gRsZeDZmAx7Zbu5esVDFQE/mX+kNs1kBj5EBrJhEluB6dOGJ9F2Zs
	 fa43D9b7G04BBCEdmwAvzLLakuDyKD4sCrgtTg/FkIHGh/KEr0QYFIYWzO8cmDzTVr
	 G5EKGmcpdvQNA==
Date: Fri, 8 Aug 2025 13:04:02 -0400
From: Sasha Levin <sashal@kernel.org>
To: Timothy Pearson <tpearson@raptorengineering.com>
Cc: patches@lists.linux.dev, stable@vger.kernel.org,
	Shawn Anastasio <sanastasio@raptorengineering.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	linuxppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: [PATCH AUTOSEL 6.16-5.10] PCI: pnv_php: Clean up allocated IRQs
 on unplug
Message-ID: <aJYuAoqFT206dYwI@lappy>
References: <20250808153054.1250675-1-sashal@kernel.org>
 <20250808153054.1250675-14-sashal@kernel.org>
 <1852420641.1614920.1754668740466.JavaMail.zimbra@raptorengineeringinc.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1852420641.1614920.1754668740466.JavaMail.zimbra@raptorengineeringinc.com>

On Fri, Aug 08, 2025 at 10:59:00AM -0500, Timothy Pearson wrote:
>While the autoselector has the right idea, in that this is critical functionality that currently induces panics on older stable kernels, this entire patch series should be backported, not just these two isolated patches.
>
>The correct series for backport would be:
>
> PCI: pnv_php: Fix surprise plug detection and recovery
> powerpc/eeh: Make EEH driver device hotplug safe
> powerpc/eeh: Export eeh_unfreeze_pe()
> PCI: pnv_php: Work around switches with broken presence detection
> PCI: pnv_php: Clean up allocated IRQs on unplug
>
>Backport is especially critical for Debian, so that we don't ship a broken kernel with the soon to be released Trixie version.

Okay, I'll just queue these up directly. Thanks!

-- 
Thanks,
Sasha
