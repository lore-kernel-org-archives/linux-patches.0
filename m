Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EDE600D
	for <patches@lists.linux.dev>; Thu, 14 Jul 2022 20:05:19 +0000 (UTC)
Received: from [192.168.88.254] (unknown [180.242.97.168])
	by gnuweeb.org (Postfix) with ESMTPSA id F0F1A7E7D0;
	Thu, 14 Jul 2022 20:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1657829119;
	bh=NxOhIz2NEX+yH6ZF8f2Sm2snVoCs4RilLemobyD/s4Y=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=Vk69jaX/iL51vE/KTtLNADkx5rrQh4pZBZTH4vKcx5KvyV8KnptnmRvJeVBY2Utjr
	 f+G/zefdzUkoy0Y7FjDTkUBEgLsOrsbNdUNqkyb1E6mOOyfaXz7uGAOf8pBk1vM0CG
	 eOhV1llJKoOSTKj5ivmG8MbcKj4X6Irfwpxa0kZKOTbF3MqC8nilxyAH77T3n4s4Xy
	 +8eBv9xWwcTh4zfrDfkFH/n4LzErgyYQX3i2HDq1peVqIoNtK/s/Gav8M+nEi93gQV
	 Z5J7Bg1fGkmUdQkQETJ4dCwGuZVa1ROJlvg59AWlP+j7hbjSkkk0GtqtAkPlF5ypUt
	 Z0gpcyAyhwX+A==
Message-ID: <fa7a99b1-11a7-c170-05f9-3327bbf7fdfa@gnuweeb.org>
Date: Fri, 15 Jul 2022 03:05:09 +0700
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
From: Ammar Faizi <ammarfaizi2@gnuweeb.org>
To: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
Cc: patches@lists.linux.dev
References: <20220707-my-new-branch-v1-0-8d355bae1bb5@linuxfoundation.org>
 <20220707-my-new-branch-v1-3-8d355bae1bb5@linuxfoundation.org>
 <b49b97df-8051-ea88-dfa7-5c64f611a10f@gnuweeb.org>
In-Reply-To: <b49b97df-8051-ea88-dfa7-5c64f611a10f@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/22 3:02 AM, Ammar Faizi wrote:
> On 7/15/22 2:52 AM, Konstantin Ryabitsev wrote:
>> This is not a real commit. I am using it as testing grounds for
>> b4-submit. Do not read anything into this. :)
>>
>> Signed-off-by: Konstantin Ryabitsev <konstantin@linuxfoundation.org>
> 
> Shouldn't we have a "---" here?

Ah, it can apply with that too. TIL.

-- 
Ammar Faizi
