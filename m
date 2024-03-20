Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BE0B2F26;
	Wed, 20 Mar 2024 16:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710953719; cv=none; b=mLnHuo0qEZlhDk0AtA3EZqsch8v4lC35BFoZ5PvJNZB/u5elJ3EpoO52NuF9CwHv1EWCzV1qT2JWi360pQXZiNIqE9B/KdL74phl6j2IRG3Lsn31mwjLZKHnshN3HZuYjksI/phhQW4EwC4OUZRDVyyA6ZOKEMtv2TRrGAqaZM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710953719; c=relaxed/simple;
	bh=nF1u6F3n84mireWU/aPNiSouEgIpFWkegsFHyALeo+M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=g1vvDpbAGBttCNT12JAQAu0Z+bJZrHHRu/b9V7zcLcuzoZz8PeAvRIQfXQNIDRg5w84Hpe1ayLEuf7grd9Qslpbn4UNrFXW+KSWZY/EgVUZkMJVCZbLTqaQshp25mrJ2RLLAjkHiEVdQUawbNaWiZMDXM3M3bqdx4b+L9zTDznk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H76nBNX3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H76nBNX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A926DC433C7;
	Wed, 20 Mar 2024 16:55:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1710953718;
	bh=nF1u6F3n84mireWU/aPNiSouEgIpFWkegsFHyALeo+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=H76nBNX3OokYbqeq7gybgpvmQcDGqKeAFVojvYZZGaZPY6ZVcGo0+oCt6Q/Z4H6Gn
	 QUDgQ7fCjVABxSh4OMK9o+FIY2TF+qBqGX98Bobi0gGUW1wNN79t7tfrVrEhZ62JWY
	 3IpllUIM2/D8uGwca51sVWvRaZfKuPMSHUehNJR3McoWbn0T+ZuFH7FjnDqp91O9qS
	 JdlckE5DmFO4d3zcytutSmp7MwhypEFxp4lyfwTAaTi8aXR7fBr92nUXN9wnaPDjq6
	 MqCPtNcfgffgCvhHK8yKj2olZiDUbOEtzalxE/FsMYmL1GEpD5zLlyQ5GFE8H305Kp
	 OCwVmhuQrmtog==
Date: Wed, 20 Mar 2024 12:03:59 -0400
From: Sasha Levin <sashal@kernel.org>
To: Borislav Petkov <bp@alien8.de>
Cc: Emeric Brun <ebrun@haproxy.com>, Omar Sandoval <osandov@osandov.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Josh Poimboeuf <jpoimboe@redhat.com>, stable@vger.kernel.org,
	patches@lists.linux.dev
Subject: Re: [PATCH 5.10 085/122] x86/ibt,paravirt: Use text_gen_insn() for
 paravirt_patch()
Message-ID: <ZfsI77yMclj5yEkA@sashalap>
References: <20240227131558.694096204@linuxfoundation.org>
 <20240227131601.488092151@linuxfoundation.org>
 <ZeYXvd1-rVkPGvvW@telecaster>
 <4d33ef17-72a0-47e0-8591-20b0bf9bddb9@haproxy.com>
 <20240318142014.GBZfhNnupMQ4XoDLUm@fat_crate.local>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20240318142014.GBZfhNnupMQ4XoDLUm@fat_crate.local>

On Mon, Mar 18, 2024 at 03:20:14PM +0100, Borislav Petkov wrote:
>On Mon, Mar 18, 2024 at 11:17:10AM +0100, Emeric Brun wrote:
>> Exact same issue here, also since 5.10.211 and still present in 5.10.213.
>
>Sasha,
>
>can you pls pick up this one:
>
>https://lore.kernel.org/r/20240305112711.GAZecBj5TMaQDSz6Ym@fat_crate.local

I'll take it, thanks!

-- 
Thanks,
Sasha
