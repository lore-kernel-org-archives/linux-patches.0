Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA4BA35E941;
	Fri, 13 Mar 2026 16:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773419103; cv=none; b=UiJJ9BBDCwv47ZvqJVTmRKtY+V3GgM0QNpSLFaBLZQqypc+6Y02QAP89vGo/YMrbVkM/hdrbGQ4ttyHc0CpJpJmTrUkXiPOYr96aPjm0n+E+lO0RbTa14KMlO8S4rJnd/AQj9Aev009M8IotZNosz7frQmTtsjE8SP+Jmf+5wq8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773419103; c=relaxed/simple;
	bh=3rjNHEQ6hjJP8MCUtndHq1kMAoBHoV8eDgKTolzpC8c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=o5Ns+1drWvG5OAnEGR+WWBn25CeKNUuv11P4Kve53oG6/S8LvrrIvQbxA8gc6ZWUR+FY7RVQggtjG/bYWBbGUCgJPkx0AMX8qsdPAE2WJFJ6Oe1Lh1BC6WEaKyDj3HcOVv7nVqcuqbRTDVE7SgFskH0E9rJRHMM1tLsbMKKXnGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ey6deaIW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ey6deaIW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846BBC19421;
	Fri, 13 Mar 2026 16:25:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773419103;
	bh=3rjNHEQ6hjJP8MCUtndHq1kMAoBHoV8eDgKTolzpC8c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Ey6deaIWuiirWLWtjKFUy6uZyN/kIDrRWvOlM/qqllvXADyubmpq7ZqXPfoJb2S0r
	 WlcdCDUF+bCV/EMmssq3zSdrHMCBu744IPUF1gGMcUhuc2fyAh93/wpQLR+sKcqB/a
	 4FL3KqI3wrv/lcHiY2pFp9OFEQtXka8G4bnub6EZEvem0ds/LnD+jE66lf6IFHtE7e
	 ap0j6mtfaKt9MAhF70gHu+zIYnmMlTTkyOcNc5Keb+LllPnLMLpXqJy1gPV1Y1/Q3c
	 8SdR+d5haAcXgQgBD2fFrr5Cqzpp1CpupjgUqbaEdoCe5xDih4mLkVLfK8BRq5cZ2R
	 SEt779wSJlesw==
Message-ID: <f0b6c0b7-797f-45ea-83b1-e52eb650c26e@kernel.org>
Date: Fri, 13 Mar 2026 17:24:59 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird Beta
Subject: Re: [PATCH 6.12 162/265] selftests: mptcp: join: check removing
 signal+subflow endp
Content-Language: fr, en-GB
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Mat Martineau <martineau@kernel.org>, Jakub Kicinski <kuba@kernel.org>,
 Sasha Levin <sashal@kernel.org>, MPTCP Linux <mptcp@lists.linux.dev>
References: <20260312201018.128816016@linuxfoundation.org>
 <20260312201024.124696392@linuxfoundation.org>
 <0fe5137d-9b80-4afe-a7d8-cb38a3118070@kernel.org>
 <2026031328-subpar-scruffy-b4b8@gregkh>
From: Matthieu Baerts <matttbe@kernel.org>
Autocrypt: addr=matttbe@kernel.org; keydata=
 xsFNBFXj+ekBEADxVr99p2guPcqHFeI/JcFxls6KibzyZD5TQTyfuYlzEp7C7A9swoK5iCvf
 YBNdx5Xl74NLSgx6y/1NiMQGuKeu+2BmtnkiGxBNanfXcnl4L4Lzz+iXBvvbtCbynnnqDDqU
 c7SPFMpMesgpcu1xFt0F6bcxE+0ojRtSCZ5HDElKlHJNYtD1uwY4UYVGWUGCF/+cY1YLmtfb
 WdNb/SFo+Mp0HItfBC12qtDIXYvbfNUGVnA5jXeWMEyYhSNktLnpDL2gBUCsdbkov5VjiOX7
 CRTkX0UgNWRjyFZwThaZADEvAOo12M5uSBk7h07yJ97gqvBtcx45IsJwfUJE4hy8qZqsA62A
 nTRflBvp647IXAiCcwWsEgE5AXKwA3aL6dcpVR17JXJ6nwHHnslVi8WesiqzUI9sbO/hXeXw
 TDSB+YhErbNOxvHqCzZEnGAAFf6ges26fRVyuU119AzO40sjdLV0l6LE7GshddyazWZf0iac
 nEhX9NKxGnuhMu5SXmo2poIQttJuYAvTVUNwQVEx/0yY5xmiuyqvXa+XT7NKJkOZSiAPlNt6
 VffjgOP62S7M9wDShUghN3F7CPOrrRsOHWO/l6I/qJdUMW+MHSFYPfYiFXoLUZyPvNVCYSgs
 3oQaFhHapq1f345XBtfG3fOYp1K2wTXd4ThFraTLl8PHxCn4ywARAQABzSRNYXR0aGlldSBC
 YWVydHMgPG1hdHR0YmVAa2VybmVsLm9yZz7CwZEEEwEIADsCGwMFCwkIBwIGFQoJCAsCBBYC
 AwECHgECF4AWIQToy4X3aHcFem4n93r2t4JPQmmgcwUCZUDpDAIZAQAKCRD2t4JPQmmgcz33
 EACjROM3nj9FGclR5AlyPUbAq/txEX7E0EFQCDtdLPrjBcLAoaYJIQUV8IDCcPjZMJy2ADp7
 /zSwYba2rE2C9vRgjXZJNt21mySvKnnkPbNQGkNRl3TZAinO1Ddq3fp2c/GmYaW1NWFSfOmw
 MvB5CJaN0UK5l0/drnaA6Hxsu62V5UnpvxWgexqDuo0wfpEeP1PEqMNzyiVPvJ8bJxgM8qoC
 cpXLp1Rq/jq7pbUycY8GeYw2j+FVZJHlhL0w0Zm9CFHThHxRAm1tsIPc+oTorx7haXP+nN0J
 iqBXVAxLK2KxrHtMygim50xk2QpUotWYfZpRRv8dMygEPIB3f1Vi5JMwP4M47NZNdpqVkHrm
 jvcNuLfDgf/vqUvuXs2eA2/BkIHcOuAAbsvreX1WX1rTHmx5ud3OhsWQQRVL2rt+0p1DpROI
 3Ob8F78W5rKr4HYvjX2Inpy3WahAm7FzUY184OyfPO/2zadKCqg8n01mWA9PXxs84bFEV2mP
 VzC5j6K8U3RNA6cb9bpE5bzXut6T2gxj6j+7TsgMQFhbyH/tZgpDjWvAiPZHb3sV29t8XaOF
 BwzqiI2AEkiWMySiHwCCMsIH9WUH7r7vpwROko89Tk+InpEbiphPjd7qAkyJ+tNIEWd1+MlX
 ZPtOaFLVHhLQ3PLFLkrU3+Yi3tXqpvLE3gO3LM7BTQRV4/npARAA5+u/Sx1n9anIqcgHpA7l
 5SUCP1e/qF7n5DK8LiM10gYglgY0XHOBi0S7vHppH8hrtpizx+7t5DBdPJgVtR6SilyK0/mp
 9nWHDhc9rwU3KmHYgFFsnX58eEmZxz2qsIY8juFor5r7kpcM5dRR9aB+HjlOOJJgyDxcJTwM
 1ey4L/79P72wuXRhMibN14SX6TZzf+/XIOrM6TsULVJEIv1+NdczQbs6pBTpEK/G2apME7vf
 mjTsZU26Ezn+LDMX16lHTmIJi7Hlh7eifCGGM+g/AlDV6aWKFS+sBbwy+YoS0Zc3Yz8zrdbi
 Kzn3kbKd+99//mysSVsHaekQYyVvO0KD2KPKBs1S/ImrBb6XecqxGy/y/3HWHdngGEY2v2IP
 Qox7mAPznyKyXEfG+0rrVseZSEssKmY01IsgwwbmN9ZcqUKYNhjv67WMX7tNwiVbSrGLZoqf
 Xlgw4aAdnIMQyTW8nE6hH/Iwqay4S2str4HZtWwyWLitk7N+e+vxuK5qto4AxtB7VdimvKUs
 x6kQO5F3YWcC3vCXCgPwyV8133+fIR2L81R1L1q3swaEuh95vWj6iskxeNWSTyFAVKYYVskG
 V+OTtB71P1XCnb6AJCW9cKpC25+zxQqD2Zy0dK3u2RuKErajKBa/YWzuSaKAOkneFxG3LJIv
 Hl7iqPF+JDCjB5sAEQEAAcLBXwQYAQIACQUCVeP56QIbDAAKCRD2t4JPQmmgc5VnD/9YgbCr
 HR1FbMbm7td54UrYvZV/i7m3dIQNXK2e+Cbv5PXf19ce3XluaE+wA8D+vnIW5mbAAiojt3Mb
 6p0WJS3QzbObzHNgAp3zy/L4lXwc6WW5vnpWAzqXFHP8D9PTpqvBALbXqL06smP47JqbyQxj
 Xf7D2rrPeIqbYmVY9da1KzMOVf3gReazYa89zZSdVkMojfWsbq05zwYU+SCWS3NiyF6QghbW
 voxbFwX1i/0xRwJiX9NNbRj1huVKQuS4W7rbWA87TrVQPXUAdkyd7FRYICNW+0gddysIwPoa
 KrLfx3Ba6Rpx0JznbrVOtXlihjl4KV8mtOPjYDY9u+8x412xXnlGl6AC4HLu2F3ECkamY4G6
 UxejX+E6vW6Xe4n7H+rEX5UFgPRdYkS1TA/X3nMen9bouxNsvIJv7C6adZmMHqu/2azX7S7I
 vrxxySzOw9GxjoVTuzWMKWpDGP8n71IFeOot8JuPZtJ8omz+DZel+WCNZMVdVNLPOd5frqOv
 mpz0VhFAlNTjU1Vy0CnuxX3AM51J8dpdNyG0S8rADh6C8AKCDOfUstpq28/6oTaQv7QZdge0
 JY6dglzGKnCi/zsmp2+1w559frz4+IC7j/igvJGX4KDDKUs0mlld8J2u2sBXv7CGxdzQoHaz
 lzVbFe7fduHbABmYz9cefQpO7wDE/Q==
Organization: NGI0 Core
In-Reply-To: <2026031328-subpar-scruffy-b4b8@gregkh>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 13/03/2026 17:02, Greg Kroah-Hartman wrote:
> On Fri, Mar 13, 2026 at 10:54:07AM +0100, Matthieu Baerts wrote:
>> Hi Greg,
>>
>> On 12/03/2026 21:09, Greg Kroah-Hartman wrote:
>>> 6.12-stable review patch.  If anyone has any objections, please let me know.
>>>
>>> ------------------
>>>
>>> From: Matthieu Baerts (NGI0) <matttbe@kernel.org>
>>>
>>> commit 1777f349ff41b62dfe27454b69c27b0bc99ffca5 upstream.
>>>
>>> This validates the previous commit: endpoints with both the signal and
>>> subflow flags should always be marked as used even if it was not
>>> possible to create new subflows due to the MPTCP PM limits.
>>
>> FYI, this patch adds a new subtest in the MPTCP selftests to validate
>> that the upstream parent commit -- 579a752464a6 ("mptcp: pm: in-kernel:
>> always mark signal+subflow endp as used") -- fixes a warning. Except
>> that this commit had a conflict and is currently not in v6.12. Sasha
>> sent a version without the conflict (BTW, thank you for that!):
>>
>>   https://lore.kernel.org/20260309153846.1288656-1-sashal@kernel.org
>>
>> I guess that's probably fine like that because the issue exposed by this
>> new test is not new, and it will be fixed by the missing patch soon I
>> suppose. Probably no need to modify this RC, and the fix can wait the
>> next version, but I prefer to send this message just in case people hit
>> the issue.
> 
> Thanks for the info, I'll queue up that other patch for the next round
> of stable releases

Thank you!

> sorry I didn't get to it at this point in time.

No need to apologise, I understand, no hurry :)

Cheers,
Matt
-- 
Sponsored by the NGI0 Core fund.

