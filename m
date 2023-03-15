Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E42385681
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 18:00:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74968C433D2;
	Wed, 15 Mar 2023 18:00:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1678903236;
	bh=eeIgKjIrne1XGkPGwXznoaDAfu4V7cmqsmC58TcUsXI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mN/kPYqsleAOmHF5TGzbOAf4WdVgTy/wZzYMF/bf6CfqMOPcikufeb5udER6QdIrc
	 wGl6R0522tsaEyYkvPa2Ihsl6C+r1ba2mVOiwEY70OejVZKdN67MB5dqcloaaS4Fkr
	 AlcT0NzP341IXls421wFRlLDtY0W806dUDPv5tjE52OQoIhLDTxPXJpXQHNTEIJDNw
	 HOUyIWNNPCzh6i7T09keSwY2glJqDtt+tQwhKUQjfbIvsh1Nohd3nyuFukhFD0IZFH
	 7TRpBbyEelrIJ0FR42SIfg6NasdDjdLHe/woxO8lti7i951x21itpxtlcv6j7URWhK
	 zvxFj0I7ylOYQ==
Date: Wed, 15 Mar 2023 14:00:35 -0400
From: Sasha Levin <sashal@kernel.org>
To: Conor Dooley <conor@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Andrew Jones <ajones@ventanamicro.com>,
	Conor Dooley <conor.dooley@microchip.com>,
	Palmer Dabbelt <palmer@rivosinc.com>
Subject: Re: [PATCH 6.2 112/141] RISC-V: clarify ISA string ordering rules in
 cpu.c
Message-ID: <ZBIHwzn12WZeoNwu@sashalap>
References: <20230315115739.932786806@linuxfoundation.org>
 <20230315115743.408666245@linuxfoundation.org>
 <4576eb25-2c86-49d3-a290-398d583f479a@spud>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <4576eb25-2c86-49d3-a290-398d583f479a@spud>

On Wed, Mar 15, 2023 at 01:18:17PM +0000, Conor Dooley wrote:
>Hey Greg,
>
>On Wed, Mar 15, 2023 at 01:13:35PM +0100, Greg Kroah-Hartman wrote:
>> From: Conor Dooley <conor.dooley@microchip.com>
>>
>> [ Upstream commit 99e2266f2460e5778560f81982b6301dd2a16502 ]
>>
>> While the current list of rules may have been accurate when created
>> it now lacks some clarity in the face of isa-manual updates. Instead of
>> trying to continuously align this rule-set with the one in the
>> specifications, change the role of this comment.
>>
>> This particular comment is important, as the array it "decorates"
>> defines the order in which the ISA string appears to userspace in
>> /proc/cpuinfo.
>>
>> Re-jig and strengthen the wording to provide contributors with a set
>> order in which to add entries & note why this particular struct needs
>> more attention than others.
>>
>> While in the area, add some whitespace and tweak some wording for
>> readability's sake.
>>
>> Suggested-by: Andrew Jones <ajones@ventanamicro.com>
>> Reviewed-by: Andrew Jones <ajones@ventanamicro.com>
>> Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
>> Link: https://lore.kernel.org/r/20221205144525.2148448-2-conor.dooley@microchip.com
>> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
>> Stable-dep-of: 1eac28201ac0 ("RISC-V: fix ordering of Zbb extension")
>
>I've been sick for the last week, and am not 100% sure what I did and
>did not reply to stable selection emails for, but I'm pretty sure that I
>did say that the ZBB stuff was a 6.3 feature and the order fix should
>not be backported.
>
>I'm not sure that I understand how this comment rework is a stable
>dependency of that backport either, but this should be dropped.
>Apologies if I missed a selection email for this one while I've been
>sick, but I was sick after all...

My bad, this one shouldn't have been left here, now dropped. Thanks!

-- 
Thanks,
Sasha
