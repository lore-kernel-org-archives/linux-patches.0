Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 855F121518D;
	Fri, 14 Feb 2025 07:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739519536; cv=none; b=ELBvP9KlzItPqQcGirlwln5zTUE6pgG7G6y3C2zpgfXP1wGjXPEZ1Vj37MCJn15iNdC09eelJr4YLeRelfRsjyWfIYtUEMcRLID0u3GSXgtgEHw+wsZZ/OJ0mfMb+jBP/Gc6usmOxHdESz6Rpe4FM9QN8UQucVHqXQjwJWs0Frg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739519536; c=relaxed/simple;
	bh=GyM2DW4KEw+Utjl2Rvsy93NlvB1BHozz8QQQyZDW2QI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qj3Jrby9Vxk4tEyuTgom0RueC8RJXw6fvXQ+oI/goEjb8q/oUuOMOpjITYGXNkpS8U25Duh/lgaeQLdiAO+TE0oapf+kcBdk8qIW18qzu1vS5CB5H1BhJVKKu442y8sd7FAVUo0/fFlVB9n3zG6ZcnBzWqDotfxIdxIRkKvzYkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S+EmeOlf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S+EmeOlf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 468A2C4CED1;
	Fri, 14 Feb 2025 07:52:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739519535;
	bh=GyM2DW4KEw+Utjl2Rvsy93NlvB1BHozz8QQQyZDW2QI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=S+EmeOlfKoKQY6wOfcc6A+ygJJH27ICqcBiZW3a2OstI+T1dypSi9jrN4czStslvD
	 f216Mmg5d/MLC0oBGHDPaUg9bS4XsfiI1kuYoQuUSiP2rMsAlG6dNOyUPXp7NRFm/Z
	 GBbYkItgDtNGAZuurhImWUZ4hP8kzXBDEcrIP5T4=
Date: Fri, 14 Feb 2025 08:52:11 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Daniel Baumann <daniel@debian.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Niklas Cassel <cassel@kernel.org>
Subject: Re: [PATCH 6.12 345/422] ata: libata-core: Add ATA_QUIRK_NOLPM for
 Samsung SSD 870 QVO drives
Message-ID: <2025021450-wolverine-tapeless-603a@gregkh>
References: <20250213142436.408121546@linuxfoundation.org>
 <20250213142449.867734843@linuxfoundation.org>
 <93c10d38-718c-459d-84a5-4d87680b4da7@debian.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93c10d38-718c-459d-84a5-4d87680b4da7@debian.org>

On Fri, Feb 14, 2025 at 06:54:30AM +0100, Daniel Baumann wrote:
> Hi Greg,
> 
> On 2/13/25 15:28, Greg Kroah-Hartman wrote:
> > 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> there was a report from a user that this is breaking it for them with
> newer firmware versions on the SSD - I'm narrowing it down to a list of
> older firmware versions that are affected and providing a follow-up patch.
> 
> It takes a bit more time than expected due to the cumbersome flashing
> routine (windows :/). It would be safe to not merge the original commit
> in the meantime to stable.

Thanks for letting us know, I've dropped this from all stable queues
now.  If you want it back in the future, please email us.

greg k-h
