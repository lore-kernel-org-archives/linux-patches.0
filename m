Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2557918CBF9;
	Wed,  9 Oct 2024 11:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728474357; cv=none; b=ZXNtB8bFG1BZxvI0bXURq8rVJXyFOdAw6FRdxTrNXcgLSLC6W3hOfJfSdlyVyjwYsNzE5cAT3CSWs0PRPfZpAqGbmXaVMJ3DYorZMvvqodFWbmXd7S0kdT/hUFp2QL42IV88Rd5P0Je3MCAsdFioqUQ3FPRqpeyhdJ2O8KkZZv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728474357; c=relaxed/simple;
	bh=quYKhS67wuohTeAR4X28iGjPhwdPoA4GmCtAnks2/CU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ABcIycL/Dur7MLadDn+8lpXhGQgurNdmi93lXCHRo7ul3hzWMFzCtI9nEDukfIgBzW8uNqB3c2afTS970zPJO78uFqxeDPL6/brCH+Eap3MDfuNQ9AeE0Ques9s5RyLI3fSG6rHQp0elYrKHyWZhFzZy3TdOwduh+UtcTMJZxqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a89JVa3x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a89JVa3x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74C2FC4CEC5;
	Wed,  9 Oct 2024 11:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728474356;
	bh=quYKhS67wuohTeAR4X28iGjPhwdPoA4GmCtAnks2/CU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a89JVa3xVLDc/GoFQmK6/SbMeCABBAm6KnbaImELm6nerudIGi7vo83T41KjhbvOi
	 uIJ8UZo4TPUcy9UEtSOFsAH/CUBjnBJwsqGti329CRcGY6Cl+/oAwhohqMRvbdD9Bf
	 amPHFbtAFZ3txEv8Lg3rgjL8iTYI/xJaJ1B0Eko/52yVHnh5yxO1fGaEuXjz1F2Sjj
	 QC0e+laSraMwy65blAl6lezlDOu0Fo0G/qpezRoC1EKI3uH/yaYajxHXDTqy3LHgoT
	 0lXaHRVX1GEG+McprzxyA1I48tcaQ4V9GdPXj0V9rGFKl6CbXjIesMjQPoy5TdtNOU
	 0szLuJVILTj5A==
Date: Wed, 9 Oct 2024 07:45:55 -0400
From: Sasha Levin <sashal@kernel.org>
To: Jiri Slaby <jirislaby@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Yosry Ahmed <yosryahmed@google.com>,
	Arnd Bergmann <arnd@arndb.de>, Chris Down <chris@chrisdown.name>,
	Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
	Vitaly Wool <vitaly.wool@konsulko.com>,
	Christoph Hellwig <hch@lst.de>,
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Huacai Chen <chenhuacai@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	"Naveen N. Rao" <naveen.n.rao@linux.ibm.com>,
	Nicholas Piggin <npiggin@gmail.com>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.11 535/558] mm: z3fold: deprecate CONFIG_Z3FOLD
Message-ID: <ZwZs86uWxSl9SuCq@sashalap>
References: <20241008115702.214071228@linuxfoundation.org>
 <20241008115723.285094488@linuxfoundation.org>
 <773cfdfb-005b-4264-91d9-003d6ba45b7d@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <773cfdfb-005b-4264-91d9-003d6ba45b7d@kernel.org>

On Wed, Oct 09, 2024 at 12:10:50PM +0200, Jiri Slaby wrote:
>On 08. 10. 24, 14:09, Greg Kroah-Hartman wrote:
>>6.11-stable review patch.  If anyone has any objections, please let me know.
>>
>>------------------
>>
>>From: Yosry Ahmed <yosryahmed@google.com>
>
>Any reason this is missing the usual [ upstream commit ] part?

Sorry, my bad. Now fixed.

-- 
Thanks,
Sasha
