Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7F0AC14D
	for <patches@lists.linux.dev>; Wed, 28 Jun 2023 21:41:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de;
 s=s31663417; t=1687988494; x=1688593294; i=deller@gmx.de;
 bh=P0ySrlluaBLMmJk4f2GQ+fXipC1OuPBh4hunAUA5kgw=;
 h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:In-Reply-To;
 b=S1IzEyC61ni6AMWFvX33nm85FQzdCIER/AufODHMkZAy5ny7Q6Vq0pHfkOmW7ffSjH+JJN0
 CUAIQTWTiwrV0Da77Drtl+42GiZjiKCLAij/Jg+yUKQppKeUBoF+XjhDo/jkpK0h8ssXC7a7s
 BuyhFJTnJ4UshMXA+b8itwDlCzwiRi0ebVJzpHnzNM5vcVv8vVwSmOOHIS93TvLaLkPT68Ig2
 Cvf0eQqXLzW1+XSTh4lnhNd5GGij1CWAyoTQ/j3v3Pk2WcL2drkxAtc3wDcZMJEkmAdY8Qmlv
 6wsepmqC7ZQDtepoZ72JL30yyGp0Hqsd5SozlnXk984Nd+pfaIPA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.152.41]) by mail.gmx.net (mrgmx005
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1M72oH-1q7lYn0eZ5-008cti; Wed, 28
 Jun 2023 23:41:34 +0200
Message-ID: <2b0316ee-d5be-9f86-14d1-debb1e756e54@gmx.de>
Date: Wed, 28 Jun 2023 23:41:33 +0200
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
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, Sasha Levin <sashal@kernel.org>
References: <20230626180733.699092073@linuxfoundation.org>
 <20230626180734.413046667@linuxfoundation.org>
From: Helge Deller <deller@gmx.de>
In-Reply-To: <20230626180734.413046667@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:T54BKfgFEMv2Oyz8mxRBRP7uSUeu0KFNEqE4aw1enoM8WbtCUmm
 QWcx/dEk4t0dyrcXt7m1zR6E69Va+JOG6Auung3GDW/AhxM5iKVNMu8kyXFPxrGGpSpz/gH
 fiygtqAKRe65xp39uUTr4fIzv32H3I6XfTcz0UZ7evTldgK6GAubK7rdYHZbB5/9Opny9Rw
 SIASxSrWDGWm5ct+Bfcug==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:/9jSRT5O9D4=;pLr6DRTh/i9+GSM/vgZlK0HuWg3
 r3Gx3SdVAUFMs0C9ZMzF4M9rU0tt7jsaZaV+CsXBg56Rm9O75/EVgL6Pa6fGJW4l12MNZx0UB
 MnzcZLxpnOQD0Vn6Momwxl3tEgba/GfnvUEiJjPnKiBzWiGgZM7Bbde+LeVaLkCJYiwCC6Eom
 xFzDgQazRNO/5m/E0LSlM4EzokE7mNxB0Tlrmgad8e+VVMJxsfdX9MJpjqjcPuNKLgMfD0Jc9
 Cv4WZbGLt5L2XK50ZfFk+gccIo4BdhprAJJvZUD3xf1jD9Sgf+3r/IgxIz4tCJhpPOheE1SdU
 ZVJwIabDD//9NyNk+et5v6u/9h91eloUVx4OP/H0oPRmr3KEkRcQh8XvLjvQBJCSqckhaBama
 +go46Cy6e2KHaAIPIRDaXGPKAdoabmb3I8USbuF7ijb7jA51KKkAsRDbm3h0cZvvhAk/erLjc
 SjuNlzfKn0nxuc/ZmN1tcPSqeOZkk8OSrIvpOCzKWiHjBnM+SpZ60NSPrDbhEC8G2ZFl0oXca
 C9dK3hdbIa8AIpqmnmIe3wRvD/LumcSf+IVp/qlzZapR3tdrhFLCz1l9dkzDPkSw4xGKLjQst
 doHn8enfzQx01Yu2YVg3hoWRbssZP+tWka2UHiNhSRw2WiNBN4juCSU65KFo/JI23YX2fF+ml
 y6mnHboIVH9FPSW5OPmxYnUl3ugKwEf2m6uH0oDBTW8kEviLAL9CNRdmqNQJzw5485acDPAM2
 Pm55l7rv/KDhITmp3kvYMpPbdo+0yVAeKzaRLHOx1ys0WHUJVKl4diMe8AESZZRZ/Mc9NhEyM
 XELRbq0HcGa48HTSUwJXXiP2+89EBl8osQXXPUdxbWUOh9n12R8MSDl/q+tQUUfd+ONa60WGM
 zJ58r7w1qq9QiasxI+K0sK/5kfA2CY/2HyQfYl6UYUb19N1CqnWR4w3ubVEltJ52fIwVM/+F+
 am0ozg==

Hi Greg & Sasha,

The patch below landed in 4.14-stable and breaks build with this error:

drivers/video/fbdev/imsttfb.c:1457:3: error: void function 'init_imstt' sh=
ould not return a value [-Wreturn-type]
                    return -ENODEV;
                    ^      ~~~~~~~
    1 error generated.


I suggest to simply drop (revert) it again from the v4.14-stable tree.
Shall I send a revert-patch, or can you do it manually?

Helge



On 6/26/23 20:11, Greg Kroah-Hartman wrote:
> From: Helge Deller <deller@gmx.de>
>
> [ Upstream commit 5cf9a090a39c97f4506b7b53739d469b1c05a7e9 ]
>
> Add missing cleanups in error path.
>
> Signed-off-by: Helge Deller <deller@gmx.de>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/video/fbdev/imsttfb.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/video/fbdev/imsttfb.c b/drivers/video/fbdev/imsttfb=
.c
> index ecdcf358ad5ea..6589d5f0a5a40 100644
> --- a/drivers/video/fbdev/imsttfb.c
> +++ b/drivers/video/fbdev/imsttfb.c
> @@ -1452,9 +1452,13 @@ static void init_imstt(struct fb_info *info)
>   	              FBINFO_HWACCEL_FILLRECT |
>   	              FBINFO_HWACCEL_YPAN;
>
> -	fb_alloc_cmap(&info->cmap, 0, 0);
> +	if (fb_alloc_cmap(&info->cmap, 0, 0)) {
> +		framebuffer_release(info);
> +		return -ENODEV;
> +	}
>
>   	if (register_framebuffer(info) < 0) {
> +		fb_dealloc_cmap(&info->cmap);
>   		framebuffer_release(info);
>   		return;
>   	}

