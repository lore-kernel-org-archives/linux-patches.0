Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07A51EB32
	for <patches@lists.linux.dev>; Fri, 24 Nov 2023 19:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=deller@gmx.de header.b="VkTAiB5u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.de; s=s31663417;
	t=1700855298; x=1701460098; i=deller@gmx.de;
	bh=OVEBpfUU7SZZ+YX9sqtJ1N4aP33XtHbSVkcqMqapQck=;
	h=X-UI-Sender-Class:Date:Subject:To:Cc:References:From:
	 In-Reply-To;
	b=VkTAiB5uVXw4HargaoHl1SCrtR5EaGgR0R+t4XaJiAtnDgxTwKPWUYfYLAqjy2au
	 PKYb6PqcHrk3QDwiH9CX1k2ZAeTk1CeX2u7VUdVvhYNZXkzkYFTHERv3gXtDMpu8i
	 JdkgZKAFc5chyLlS0cZK8sQGhIndUbobzjAwZV63ouOWNkVh6IuyghrWbbkmlF0pz
	 vhbOt6keJb95lDMFrXwLquBJtyMqoZsTvHl3khubIOSQcajUsFj6z8z8z2kFUbp5e
	 8C0YZSj4sI7cGskeDp09myNvj5MnSc1wHos3BbU8DXDUeNB064IDe7t3MIho7+sWn
	 JsZr5jrqq6JdquHSzQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.20.60] ([94.134.145.42]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N4QsO-1rGolA02WU-011Ppo; Fri, 24
 Nov 2023 20:48:18 +0100
Message-ID: <ea2ad6bb-22a5-4100-937f-eff9d9bc5f4d@gmx.de>
Date: Fri, 24 Nov 2023 20:48:17 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 102/159] parisc/power: Fix power soft-off when running
 on qemu
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev
References: <20231124171941.909624388@linuxfoundation.org>
 <20231124171946.135466035@linuxfoundation.org>
From: Helge Deller <deller@gmx.de>
Autocrypt: addr=deller@gmx.de; keydata=
 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
In-Reply-To: <20231124171946.135466035@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:1uTtGi7ex0ePQQJ3u8PQj1Nhc0CMf7uXz5Jhn5XPsaxLvF7i623
 WfbOH8JxYuHeF7pIFClbxd+M+KwaOdnC91/KdpUPK2Dg1JzimpCIk4emdUfVAaoY+Wcfu5m
 7RPCiQiCNSqayDT7U1it9MkqcZR/nIKYQUAnM0OAMhNwxa0iMo1/qr2QCoyEHSyfoPqIZ3R
 fBPcrTjhzBiCn+wVtHIkw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:hjKUtT2HOFQ=;YRFhi2xJLi18Ga0kHxuaOZIzTBe
 BK4p/CEhq8X6gKYyrAbvBqJmWKO2vR6gSBziaSMGjVDND0tWcAmhWy3FUgYwXLUSPZD4W8O6J
 Lpx1xhaWz36xYmc4bscFrCVXFclPOok59hD17XHnFQ0ZJO1FniEWnNvZHu13CQWnrkVKU2LlT
 eBeH+iw46l2E/gkgXfdz4rs7pRV1jRXIO5YRbSXgiuYpxG9/V+IlTK6pZTKFRMD2QoGrH2jUj
 UY3BMucyh8XDvftDfSH67WL2nBvS4H4LYgxaUDzYtJWfDnQwaypyPMuvUDjpk++q5GtU+xsu2
 bbLf8hqqFPvan8uAuS+4B020GOjWyfljhe/LRtkGbGzVaZDeHPCdNicUgOTLaMaYr8G9frBVd
 oUaAAa3+evdM6E/ThhDUW4HIrtmCIiw5SA045qY4cKS4j2GQxsRDfckZbjg0DkQch30dvv3Zo
 FokHTz0CLRgWQT8d90Cg584Z2V/WmUo5QdJbiFN6AVoCL31oWVjA2rXBaIKQv8sbrNReFcEa8
 cObInFF7aDbLbyjzxFD+9bL0p4W+TogA1YZxj1V0iKJ5qvhHRC0C8N/Q0tMPpU8RKmefV1r2Q
 7HDuiFJo1Is210//ot4krbvkLLFicZ6p1sK8u5FyAWWxM8pVmKPy0g2hq4QXsHNC++wb3B3BC
 Mm4eHWyIl+PSD7vZtTDv6u7kRoT930LHMLZOoQVSmp1UrN15sjonXyoLBmqUxn4FvxAkyOchW
 yRRewVbiHmOhuwnz2ayZQGs7PQfwUnGCNwqnZRVJq8YV7Ek0WZNIs9reTkkkXHGUlyMvskjf4
 U0KZji5tX/Ait5NSo8Fmhuf9myYRG56innn9dDhBvDTdvI1zeLHC8RiYhQiqMB14etzXBzh2M
 E8c4p33Vx+yHx/nzKEvCl+5W9JWhCb33zFBFZx447I75TMCLlmtg22YWSBg9T9O5gqhpIThyO
 pSvb9Q==

On 11/24/23 18:55, Greg Kroah-Hartman wrote:
> 5.4-stable review patch.  If anyone has any objections, please let me kn=
ow.

Please drop this patch from all stable kernels < 6.0.
It depends on code which was added in 5.19...

Thanks,
Helge

>
> ------------------
>
> From: Helge Deller <deller@gmx.de>
>
> commit 6ad6e15a9c46b8f0932cd99724f26f3db4db1cdf upstream.
>
> Firmware returns the physical address of the power switch,
> so need to use gsc_writel() instead of direct memory access.
>
> Fixes: d0c219472980 ("parisc/power: Add power soft-off when running on q=
emu")
> Signed-off-by: Helge Deller <deller@gmx.de>
> Cc: stable@vger.kernel.org # v6.0+
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>   drivers/parisc/power.c |    2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
>
> --- a/drivers/parisc/power.c
> +++ b/drivers/parisc/power.c
> @@ -196,7 +196,7 @@ static struct notifier_block parisc_pani
>   static int qemu_power_off(struct sys_off_data *data)
>   {
>   	/* this turns the system off via SeaBIOS */
> -	*(int *)data->cb_data =3D 0;
> +	gsc_writel(0, (unsigned long) data->cb_data);
>   	pdc_soft_power_button(1);
>   	return NOTIFY_DONE;
>   }
>
>

