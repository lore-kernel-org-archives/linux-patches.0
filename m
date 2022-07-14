Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F547E
	for <patches@lists.linux.dev>; Thu, 14 Jul 2022 20:41:11 +0000 (UTC)
Received: from [192.168.88.254] (unknown [180.242.97.168])
	by gnuweeb.org (Postfix) with ESMTPSA id 682357E328;
	Thu, 14 Jul 2022 20:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1657831271;
	bh=oHpkf2Cf8ZsxOXp3bSZkGSXranBxetWDRBC8nm+rCxM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KmZa9qWFGhdMTvEMJFyiuzmhQP5FaZKNyuwr8SR0fGBty5XT6g19HkEmHpgMnGC4X
	 57Zrd5XRDW9g2lOqNmV4BJttDXbTTjifYx2SUxsts7vhkv228tYM/yC205PFVhFvcn
	 1cmh/nNa4+I4J9m+c/94eHsUCIXUv6eRscX+RnhZrS8Y3L3/Mq6ARF9mmUOyS7HaXl
	 lI6n7Y74JFnfHEuggnuX/nM9G/SSgb4wBl+gbJAWiboSiKdZ0mqqySOSahTAAb6hsK
	 qHuPDU3Mhxy4jkfx4bPKOd5ZWfl5VtL898H7HKZNg/OOluaxG3tWjNzWVxDeeDlcUK
	 PpNrzJ7jXMvvg==
Message-ID: <97675707-1da9-d32e-c5d1-c74fa3c6a851@gnuweeb.org>
Date: Fri, 15 Jul 2022 03:40:57 +0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH WIP v1 3/3] Add myself as ultimate maintainer
Content-Language: en-US
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: patches@lists.linux.dev
References: <20220707-my-new-branch-v1-0-8d355bae1bb5@linuxfoundation.org>
 <20220707-my-new-branch-v1-3-8d355bae1bb5@linuxfoundation.org>
 <b49b97df-8051-ea88-dfa7-5c64f611a10f@gnuweeb.org>
 <fa7a99b1-11a7-c170-05f9-3327bbf7fdfa@gnuweeb.org>
 <20220714200758.hzweoskhf4kottoo@meerkat.local>
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220714200758.hzweoskhf4kottoo@meerkat.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/22 3:07 AM, Konstantin Ryabitsev wrote:
> On Fri, Jul 15, 2022 at 03:05:09AM +0700, Ammar Faizi wrote:
>> On 7/15/22 3:02 AM, Ammar Faizi wrote:
>>> On 7/15/22 2:52 AM, Konstantin Ryabitsev wrote:
>>>> This is not a real commit. I am using it as testing grounds for
>>>> b4-submit. Do not read anything into this. :)
>>>>
>>>> Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
>>>
>>> Shouldn't we have a "---" here?
>>
>> Ah, it can apply with that too. TIL.
> 
> The actual message body is generated using git log --format=email, so b4 isn't
> really doing anything crazy here. :)

BTW, these patches are missing an "In-Reply-To" header to the cover letter.
Just noticed my Telegram bot doesn't properly group this series because of that.

-- 
Ammar Faizi
