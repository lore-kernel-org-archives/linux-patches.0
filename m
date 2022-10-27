Received: from mail.itouring.de (mail.itouring.de [85.10.202.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6626A1C13
	for <patches@lists.linux.dev>; Thu, 27 Oct 2022 19:16:57 +0000 (UTC)
Received: from tux.applied-asynchrony.com (p5b07ea35.dip0.t-ipconnect.de [91.7.234.53])
	by mail.itouring.de (Postfix) with ESMTPSA id 29A30103762;
	Thu, 27 Oct 2022 21:07:55 +0200 (CEST)
Received: from [192.168.100.221] (hho.applied-asynchrony.com [192.168.100.221])
	by tux.applied-asynchrony.com (Postfix) with ESMTP id 7AA85EEB63F;
	Thu, 27 Oct 2022 21:07:54 +0200 (CEST)
Subject: Re: [PATCH 6.0 00/94] 6.0.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net
References: <20221027165057.208202132@linuxfoundation.org>
From: =?UTF-8?Q?Holger_Hoffst=c3=a4tte?= <holger@applied-asynchrony.com>
Organization: Applied Asynchrony, Inc.
Message-ID: <e5d591a0-5052-0d69-648a-8b3fa08191ff@applied-asynchrony.com>
Date: Thu, 27 Oct 2022 20:46:14 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20221027165057.208202132@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit

On 2022-10-27 18:54, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.6 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Looking good on various x86-64 machines (desktop, server) and
my Zen2 Thinkpad. Btrfs still works, too. :)

Tested-by: Holger Hoffstätte <holger@applied-asynchrony.com>

cheers,
Holger
