Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B8047F;
	Thu,  2 Feb 2023 07:11:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 852A2C4339B;
	Thu,  2 Feb 2023 07:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1675321882;
	bh=gfS7S4W2HkaLaI++1EN/mssAKz2M7IN90iHqH4OBoY0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ScMauiOUiUlUWfVref7DNRefq7GQ+/PNaBdNUP99U4EHXTZXqS8L63Oj8pajaNmwh
	 sl26i+XurUNUo6FbB8QRh8qXE31dwwSppi/mfOd2SRpsc9GgYo3nHcmTyAWN0Pmh8v
	 Ux7GjQj2QBWr43Wx710NGbIpuupIY0Ucz47guTQAos0U40MJrvcv7m3buostOZE2lC
	 YJuhmt7HBnvCGf4Pt6KyAOZ2CMtvp+t5dKbRr8ILE46PeMydzRIb+79ZKam2op5HEB
	 eRvmSqnmTzV/pPRXJq3E1UALzBG4laJd1o6GgDjMO7mEFB+J67H4OYe6ehl/PDB8dZ
	 CUcppGV414n+A==
Message-ID: <e4dec7de-40d8-5e66-2e83-17e1540042ff@kernel.org>
Date: Thu, 2 Feb 2023 15:11:18 +0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH] f2fs: Fix type of single bit bitfield in f2fs_io_info
Content-Language: en-US
To: Nathan Chancellor <nathan@kernel.org>
Cc: jaegeuk@kernel.org, ndesaulniers@google.com, trix@redhat.com,
 linux-f2fs-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
 llvm@lists.linux.dev, patches@lists.linux.dev,
 kernel test robot <lkp@intel.com>
References: <20230201-f2fs-fix-single-length-bitfields-v1-1-e386f7916b94@kernel.org>
 <64d1f9d3-12d8-cc7a-501e-5c0286b0cfa1@kernel.org>
 <Y9tU+woHY23zHpmv@dev-arch.thelio-3990X>
From: Chao Yu <chao@kernel.org>
In-Reply-To: <Y9tU+woHY23zHpmv@dev-arch.thelio-3990X>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2023/2/2 14:15, Nathan Chancellor wrote:
> On Thu, Feb 02, 2023 at 02:13:18PM +0800, Chao Yu wrote:
>> On 2023/2/2 0:40, Nathan Chancellor wrote:
>>> Clang warns:
>>>
>>>     ../fs/f2fs/data.c:995:17: error: implicit truncation from 'int' to a one-bit wide bit-field changes value from 1 to -1 [-Werror,-Wsingle-bit-bitfield-constant-conversion]
>>>             fio->submitted = 1;
>>>                            ^ ~
>>>     ../fs/f2fs/data.c:1011:15: error: implicit truncation from 'int' to a one-bit wide bit-field changes value from 1 to -1 [-Werror,-Wsingle-bit-bitfield-constant-conversion]
>>>                             fio->retry = 1;
>>>                                        ^ ~
>>>
>>>     ../fs/f2fs/segment.c:3320:16: error: implicit truncation from 'int' to a one-bit wide bit-field changes value from 1 to -1 [-Werror,-Wsingle-bit-bitfield-constant-conversion]
>>>                     fio->in_list = 1;
>>>                                  ^ ~
>>>
>>> There is not a bug here because the value of these fields is never
>>> explicitly compared against (just whether it is zero or non-zero) but
>>> it is easy to silence the warning by using an unsigned type to allow
>>> an assignment of 0 or 1 without implicit conversion.
>>
>> Nathan, thanks a lot for catching this, do you mind letting I merge this fix
>> into original patch? as the original patch has not been upstreamed yet.
> 
> No worries, do whatever you need to! I just care that the problem gets
> resolved one way or another :)

Thank you! Updated a v3 patch. :)

Thanks,

> 
> Cheers,
> Nathan
