Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389F280D;
	Wed, 12 Jul 2023 03:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A955CC433C8;
	Wed, 12 Jul 2023 03:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1689131708;
	bh=cXX15OpDYjd3XmJnLey2o0GhrG8lr8HHYH3YCewR61c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Oh5folkV0QWUsh7tNheg8KRnfXa0fKakeE16XvIvmqlYaMJRyD9CBNRrkq4U/V/1J
	 iEnieM2WLLe5YUzewFiSKu29jA5/dyr+vHxs+cYAcIMbA9FwjaLL5W4Z94BU+Ke8KU
	 twzQKO8U+IdTts5daESaE6NQGCBSiIIJGgQTMuFB/1Zpb8bmQBuYI9WGhXbyHVZxMf
	 BgtDhwMPnv8ZeRjsJyY9j5typoP7A40vC4bNs25Qwh8FeY1K4hurqgCEsSoFwWUPyd
	 UWw4GINdfzi+dxzMNZqtWIwds9wBEnwt+pNjjFBCzHd4IkD1NC0uJvq4gqOBzICJDE
	 CoLErVpRODaow==
Date: Tue, 11 Jul 2023 20:15:06 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Qingfang DENG
 <qingfang.deng@siflower.com.cn>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>,
 YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>, Masahide NAKAMURA
 <nakam@linux-ipv6.org>, Ville Nuorvala <vnuorval@tcs.hut.fi>, Netdev
 <netdev@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, "open list:KERNEL
 SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH 6.4 0/6] 6.4.3-rc2 review
Message-ID: <20230711201506.25cc464d@kernel.org>
In-Reply-To: <CA+G9fYtEr-=GbcXNDYo3XOkwR+uYgehVoDjsP0pFLUpZ_AZcyg@mail.gmail.com>
References: <20230709203826.141774942@linuxfoundation.org>
	<CA+G9fYtEr-=GbcXNDYo3XOkwR+uYgehVoDjsP0pFLUpZ_AZcyg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 10 Jul 2023 17:11:18 +0530 Naresh Kamboju wrote:
>   git_repo: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
>   git_sha: 3e37df3ffd9a648c9f88f6bbca158e43d5077bef

I can't find this sha :( Please report back if you can still repro this
and how we get get the relevant code
