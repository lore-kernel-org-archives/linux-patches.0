Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2592E22069
	for <patches@lists.linux.dev>; Fri, 24 Nov 2023 19:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=deller@gmx.de header.b="rCRqeoHv"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
	t=1700855259; x=1701460059; i=deller@gmx.de;
	bh=dutzQTH16tMCgNogtMlxISGpAb756yATkebYUyKYHaE=;
	h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:
	 In-Reply-To;
	b=rCRqeoHv29O1yO/AdKobdETKzCi2grysA9rzg4SzKk+JjeW4Lr3D3Aqz1XTRMG+d
	 pdCtGNWEO4TkmYbiD3lKapFN09+5V2mkuAQn1slxK+d/m3rTAlVWCIUmMvIoEevxE
	 q+Hhza3ww4XkRX7Z4svRqmLmAgtPBoueDkQbspYP1LCY4zI9MnGx+Ky4nGHQb+Cb2
	 oiaB/nsusZa+YF8BnGSIEgH8/ttRToBcBhn3PNOGWrBCDHIW8QY2iewRuTRj8xuce
	 mRjd3ceGGaGeYtKabtDHQ+hzhpMUoLkCspbin4PP2K9BLkKVFXw6WoXLkK/d5IAGt
	 CRjK5hioLvkq4DgU3A==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.145.42]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MEFzr-1qz9NG0oDt-00AH19; Fri, 24
 Nov 2023 20:47:39 +0100
Message-ID: <ed27b9c1-024c-4839-85cc-91fa88a2271a@gmx.de>
Date: Fri, 24 Nov 2023 20:47:38 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 084/159] parisc/power: Add power soft-off when running
 on qemu
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev
References: <20231124171941.909624388@linuxfoundation.org>
 <20231124171945.420849740@linuxfoundation.org>
From: Helge Deller <deller@gmx.de>
Autocrypt: addr=deller@gmx.de; keydata=
 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
In-Reply-To: <20231124171945.420849740@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:UVPxouMS9RfRJAfz81C9URHAaWZeIKSALSZqFpMSyvQPtCHHiec
 C1iW73Fes2htzITx9otV5GyULuldQA6gkKRs+ll49lXSTXYlG9uTDv2exruNBE9sypBSksg
 3/m4PxNplAO/aCZhYk5wDUmuc5G9alxGh3+lu1lw2fkHHywj0Z4TkZklBXuSbQjwVvZgICW
 T5m6xXPq5I/NBz3IYcwKg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:VbVjzVdHtQA=;GpJDqtt2ud9RUfsgdakI/dVnHpU
 q7tEnbvhpaB1KgEqOcoxzNwjf9h8ydjLDGLU3IG4khlekujDqbNv0g0E0hybSb5soIMPyqAdg
 c3lUsDmJRfECVjf5DGqVJ3rgpgVDcbCiC0cwOZqUHjKD5DKQrlDyZavTlDs6NNJNR06Tpss80
 btj7DFaoE74OHXMfL7vrST+ZpP4wcG054tpjH/4+iQfQU+KnEoDwJJXVHMdS96rJz7Rwr4MZ+
 N9Mp8uEO2GtLDk6J6iPYWg1f14PrNOJrmZZ+Zk1coNKj7alqwvJ/9Cf0EfbwWy35/Z/PlBdyd
 En3PXkG82WK7jZmd+jcq2Gawb40i0X2UJ5LdkeWTGNGn7wsVwxMLsbdwHXWE1+27oBLromf1u
 fP8up7rhbUjJtQ2wNOBrxPxzM8W/4zynTcDXsLnGtwHJrW+hwNuMAjDQW/HmezVUFiwoaQ25o
 2TIbgRaS1/80wA2gdXlTY+hvpyhlOjyJZWbVGttUt0E9ThovDr6rMRrkMJZE0Jia74FRgphYF
 I8YVhZgwk6AajpIwIN3LKFhuFjhRLRIccIgdC8f2bxoAU1gOBNU+VWoPXmjvC2nBG5pzh2NTu
 7E9Zs/hwxFx542yfAumjNhu6NXl1n0nYhN5PYxdFCbkvdPxsx64kvJn6198D413nzPU1RA2AN
 l5+5fA4FH+igpYczQ5SJn8q9yxsTjddihZMZV/iRJCbS7fyL+CQbeuNTBK6NxqW888OLuO+4D
 BYoWh4zgD665ma/vfc362BLmb+Z11xtHdnkyPRTJS9Rk5rHrNFgJKGxLAkXSfZmje66Pia0yr
 gOkzljjaewTvEQUiHUyjmTx5HwWfY6+TeTs5DZCoKSn9kqKL5aNY3IwwqQDV7a2Hu64oGP90i
 5TywDMo42/cIME5Mrw16oICge0TGJXuASc2gm9cUtSnF3kfk0IL0+s6P6flUNFinQA+IpcV9s
 Rmqwzw==

On 11/24/23 18:55, Greg Kroah-Hartman wrote:
> 5.4-stable review patch.  If anyone has any objections, please let me kn=
ow.

Please drop this patch from all stable kernels < 6.0.
It depends on code which was added in 5.19...

Thanks,
Helge



> ------------------
>
> From: Helge Deller <deller@gmx.de>
>
> commit d0c219472980d15f5cbc5c8aec736848bda3f235 upstream.
>
> Signed-off-by: Helge Deller <deller@gmx.de>
> Cc: stable@vger.kernel.org # v6.0+
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/parisc/power.c |   16 +++++++++++++++-
>   1 file changed, 15 insertions(+), 1 deletion(-)
>
> --- a/drivers/parisc/power.c
> +++ b/drivers/parisc/power.c
> @@ -192,6 +192,14 @@ static struct notifier_block parisc_pani
>   	.priority	=3D INT_MAX,
>   };
>
> +/* qemu soft power-off function */
> +static int qemu_power_off(struct sys_off_data *data)
> +{
> +	/* this turns the system off via SeaBIOS */
> +	*(int *)data->cb_data =3D 0;
> +	pdc_soft_power_button(1);
> +	return NOTIFY_DONE;
> +}
>
>   static int __init power_init(void)
>   {
> @@ -221,7 +229,13 @@ static int __init power_init(void)
>   				soft_power_reg);
>   	}
>
> -	power_task =3D kthread_run(kpowerswd, (void*)soft_power_reg, KTHREAD_N=
AME);
> +	power_task =3D NULL;
> +	if (running_on_qemu && soft_power_reg)
> +		register_sys_off_handler(SYS_OFF_MODE_POWER_OFF, SYS_OFF_PRIO_DEFAULT=
,
> +					qemu_power_off, (void *)soft_power_reg);
> +	else
> +		power_task =3D kthread_run(kpowerswd, (void*)soft_power_reg,
> +					KTHREAD_NAME);
>   	if (IS_ERR(power_task)) {
>   		printk(KERN_ERR DRIVER_NAME ": thread creation failed.  Driver not l=
oaded.\n");
>   		pdc_soft_power_button(0);
>
>

