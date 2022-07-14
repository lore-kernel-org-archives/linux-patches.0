Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2164600D
	for <patches@lists.linux.dev>; Thu, 14 Jul 2022 20:11:11 +0000 (UTC)
Received: from [192.168.88.254] (unknown [180.242.97.168])
	by gnuweeb.org (Postfix) with ESMTPSA id C94697E328;
	Thu, 14 Jul 2022 20:11:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
	s=default; t=1657829471;
	bh=+rxFgLeYYs9tu6LozpzlQLg7alTzo8OFcgAq8bSq8bk=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=pJfgFBnZlAzoTd7HkRbwN77pNA+iEi3P1zq3sAAGUDAMqLEqvBXVNZfJxVlwZq4nD
	 K10JF9d1TZOGlwYOR+x6IrchtgF0Qp4I/fTnCM0qBvry3rNzbEEiMErgxtSZAs02jk
	 Z1UIplNYg4FLjnZ19QCMNxOFPRr+gxGinBlplXc69UZ6XtvwV9341Mrb9r17vlDeNj
	 Of4DIotuCTsYM2eo55YSYc6xHqmlkmkrY2acRI2Z/0zxX455fCssQkMDuVIKNt167M
	 gD0I5vYEa4EHg34GBiTDwvCJrB6edOJ706HZDgUWlgc071sXRjb7x4hmJpavjobciS
	 YYAHxr2wDrOyg==
Message-ID: <b3a322e3-386e-2064-7a33-5d9c7812802b@gnuweeb.org>
Date: Fri, 15 Jul 2022 03:11:01 +0700
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
> 
> Just testing
> 
> Tested-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Hmm... this doesn't show up on the lore.

-- 
Ammar Faizi
