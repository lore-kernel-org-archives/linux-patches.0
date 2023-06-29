Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA763BE5F
	for <patches@lists.linux.dev>; Thu, 29 Jun 2023 09:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1688031571; x=1688636371; i=deller@gmx.de;
 bh=15Ugg2PE4uz+Ae1gXK2MHkOYgcvo2EPSZTEHkpk9oQ4=;
 h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
 b=d0xnAv+Z9hJJAk0zSxU9J5nZgE3WDTCX/ZGH3t0g4Ly3CWeGd4igtS8EzbiiSvPswfnDsbz
 2ZuZOUnigLIHyDL5nF/UYr7uAE1bR/7XHG+sRwFDu1MNkZ/AyOY2GCx8SWmB0zELUEDKzCEWb
 SSS23nNkJMLy35C2ecKW/v9ljmm/MeMwrAje8MtgQwDljiD5XBXLJs9O4iwj1y+POsUCtEAtO
 n27VLNWUTn2rGwkcfkBy590AfzOSC09wOOpmEPPcUirzzuYlOf+03yf1Kj99tHT4B3xkI51gV
 xdkw/hr6IYsJKQtouFSLX10M/9/Rpn2RijWI/YPR/gObU3faNj6A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.146.6]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MN5eX-1qUxvi0NnB-00J65B; Thu, 29
 Jun 2023 11:39:31 +0200
Message-ID: <c1c90ed4-7b06-dabd-0186-3fff344961e3@gmx.de>
Date: Thu, 29 Jun 2023 11:39:30 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 4.14 19/26] fbdev: imsttfb: Release framebuffer and
 dealloc cmap on error path
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 Sasha Levin <sashal@kernel.org>
References: <20230626180733.699092073@linuxfoundation.org>
 <20230626180734.413046667@linuxfoundation.org>
 <2b0316ee-d5be-9f86-14d1-debb1e756e54@gmx.de>
 <2023062922-unweave-configure-a094@gregkh>
From: Helge Deller <deller@gmx.de>
In-Reply-To: <2023062922-unweave-configure-a094@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:q+v/ZldwntjwaodqgqwR8Gg4fODZjrcBN+rlyr3+Lgw/vI4K/b8
 TZzcnTigE9OtOvKkOKI7+HKjD0jQdGJ3m9naI1ZD10pCFKcj81InpDsgLC7cySm8oiXvFH4
 blNAKZIvZ+JWF/kcqdL9p9S4Omjf2B2xhKv8SX+lKN42aoH3Z6WqoSEZMBJOn1K5N+OEBKV
 q1afscSk7Nvf0xUFYccYA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:tsYH57k5TH8=;Sl0GzEe5mPUO5v6R3/acIel9vkb
 hLRwuUUak69IX3fc7HX4shClr1CtSsfo3lXKl68F0P33E5Opi0mHe+/8p9xO+hstfhZ8wGCrn
 ZfbvyxSHHORHA/5JQqQo81PrpCw4D+hO/xgCAo2RK0BkCWX+rbqZ7bxvXPIR7uWPAhT0+5AaT
 8jBCqVWSdcSlK076F7xyAMagVNIbaRootQPCFKTVILMGVVw2RgUYFsFKB8HvHe/LkomFrlcko
 jO3eO2fLEzYewx2JGn5hCZkuojHJ/Xeq2Y5qU4hVOoaobdzf9IfbeIQhW8tM3QjueAWaLdRha
 WNKyLJ5bFgnWrYgXBAm6ySDpAAmEOki7uvMLCeSYgokvPuPMr2ttCbIKwnhYVs+ScLqtUYck2
 j2hMsac6s9JALSowirV8MHkQenuxiZAthnKx2BG04I3GVWE0qiVz2VvgYgoEXvfbXBu7AZh4l
 tSg4SYHmpUi/cSCVPo97OUUe5Tf3aVXEtDGkyP1L+RZrRCp79Ylmg7LmetNNtY/HnrA293etV
 99fHUVkt3WGueEhMl5elLjRbC/hL+UUy3J461Uzlaytd11276daSDBDNHIbg5w/4sft5eEonD
 qxzpx3I11//3zu9wDs9KW4FjtM5dbs5Mi2iGzj3Ger4ZO3wOnmvAX3z9991h0TO6Trhif24zL
 KU+f+d4Q6cyi0OuuOz0M+xtvFMs0fGcCe1JSgN7PYkFa0aAiDEYssIZeu1bmbntgJ0o5ORGfF
 Qx6E5xYw8IPBaajO+IFJLTRyEsYGVMfxcEHjgx12RJE8YKR3MgPZrgFyS5YlVi7x0+cYEKwn/
 FucWMvpIuFibopBq+rO7CMrDUalTsxYbWIY6CmOPouSMiGIdflhJoMNAiOwne4R+GPB1zvuZc
 yQpfdgXVmPJOGWYYjv29YYSv09CaT21QMHGIRd57IXQoG6QUk3YNCiLyJLvjyY7tI29Yimoel
 0eE7tQ==

On 6/29/23 09:06, Greg Kroah-Hartman wrote:
> On Wed, Jun 28, 2023 at 11:41:33PM +0200, Helge Deller wrote:
>> Hi Greg & Sasha,
>>
>> The patch below landed in 4.14-stable and breaks build with this error:
>>
>> drivers/video/fbdev/imsttfb.c:1457:3: error: void function 'init_imstt'=
 should not return a value [-Wreturn-type]
>>                     return -ENODEV;
>>                     ^      ~~~~~~~
>>     1 error generated.
>>
>>
>> I suggest to simply drop (revert) it again from the v4.14-stable tree.
>> Shall I send a revert-patch, or can you do it manually?
>
> How about just fix it up by changing the line to "return;" instead?

Sure.
I'll send a patch.

Helge

