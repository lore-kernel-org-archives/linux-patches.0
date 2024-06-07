Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DCF3225AE;
	Fri,  7 Jun 2024 05:29:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717738199; cv=none; b=dscnfQ4ujye4mkEbbXcg4MeTbQk7wTaOddB+89V6OiLxQI2pKn2k+JDlDVR2o+bUQmHC28ndVE11LUQcZmxhyUq9JI4Flf3qb9GMEFbbD+B7dBreMMg9N1+yc7aRdcZGBVR9C2Az1+dq9NgxCw5I5gZkweC2u0SQ3g+Nxiypb8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717738199; c=relaxed/simple;
	bh=9rz8+VMgAcb32PW6KclGIGwgYHTKbeIqic3AZoRiX8M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=q+JmoEqDnqDcpVUmFdJu0hBobNpIgDFWJ8BYRvIh6Q7uB0bBnaqY05LO16U5+7XSjn36fvznPptNcnz+v+Kr7WbXdTOvwwQ75Jq0jhtJvCqBxRZxmnJO6TW36SBhWY9iwzy6FAdEWmpPZJIfi9cctu3NKBMPRFRhb8O1sxAjKsc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=w_armin@gmx.de header.b=RY2x4zSk; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=w_armin@gmx.de header.b="RY2x4zSk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1717738183; x=1718342983; i=w_armin@gmx.de;
	bh=LSAsYouB9E+Wh4jg7ST3qpfGr5N0dg61aPoOi3EDWvM=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=RY2x4zSkxVKiDqKfkPy2xXVmL47NfwHU55vUC4cWsn9gxS2hselv8cKma1zYt27O
	 8F/HTYUcOW+S1YrvnxHUHqLss4iXZSsWO5+mxucI4Nw6J1UhMosSXjFqo7jf5iJ7K
	 5cHhDftTi2It1YipZXvsVSxVfV/7yx+Jy0rNroQvnwtTFZVGTfQVf43iICSI/g69h
	 wkYKb8aPjGh2tXNdEXSm0B+c4uDq12SLbXGTNGHUxM+mJ5UVlpgbjM2Ek/LRivzF5
	 pgGuA/g3gJDdKrST18ICHVPvzLJl8muLhIpTQjpvQzCMDpEtV2f//T3NL2Y+3R0PJ
	 RiYDmiVLi6vP14vGfQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.2.35] ([91.137.126.34]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MhlGk-1sstap0Xnk-00fK5J; Fri, 07
 Jun 2024 07:29:43 +0200
Message-ID: <f48f7d3b-fd25-4d34-9689-dab225d29aff@gmx.de>
Date: Fri, 7 Jun 2024 07:29:40 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 307/744] platform/x86: xiaomi-wmi: Fix race condition
 when reporting key events
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
 Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
 Hans de Goede <hdegoede@redhat.com>, Sasha Levin <sashal@kernel.org>
References: <20240606131732.440653204@linuxfoundation.org>
 <20240606131742.234515336@linuxfoundation.org>
Content-Language: en-US
From: Armin Wolf <W_Armin@gmx.de>
In-Reply-To: <20240606131742.234515336@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:v/A/pnmeR6s5nJ0LILeR0Nn0SbfIiBklaRgwjzaxVBdtBHM0sHF
 tVjIRvnHxX+oBw0upxXwwKy4+qwog5oWsnsdxn4F6AFwnsO1HF+onGizdcVinPXAMDxk1Xi
 X7t/qthsrSUvmFeZa78HU+h3miB0v4gkFhC5bS5bOcPZsZDky71NnhpWb6S7wbAlytnhwhg
 I2XY6YnKYnFYXMpgqvTqQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Jrv3MkR3T6o=;aIU3uxJhA78B9N+aTDGOPs/ckUU
 h0UexnmuYPOKcKzzCF7aVnd9pTs9ZZBM+IFSGN9c6kWRhR2r6pScZUeP+t5l5CZkn/EWwLY+1
 kx/LW45ZjDh4+LtP44Qc4SGlH2Pju2ieewn4JuDvUdLHju9CHso/Qfa8678rsOEiYZJESoqWG
 V0RWGD20pewSAUjI0SvGUY93g6N3bU0NCCKdxQ7NwbHeJA3vWU36oKR9kFvL8x13+m8R8BCOo
 gHxrDpaRpWQt1s0lGVmg3TJUW/cz/RZCJYItdmLpUV+EKJ0GUtm9/A/ZAxG5DyPo5cqLzkStF
 waiUOBoIdIv2jOrODc1lyUdmaGeBrGJrEDpPuf+ZQ/jG9KVw0UGJ4HJs2wPFLCECS6clQOjov
 a24PgzVVcl3JNCFEy4YmoiAn5CM8jzA9w6Iam4WJOv+H9BvPZdzguP4c7dHpQu1T0haCxhSx2
 hsxx2bCz1BFscyD1UDEOZMDGyu0rWsRy4PCCvwCUrELPVClLYmeycskdE6wNp4DK4shw4Pnlz
 S7+Gje4/Obti/+JBJTp9TIdjRLT7lOBob4Mt8Cowgmcy+c1jd4b7FHYGJcCUHIc+Gvq7zE3bU
 dPFho7vsVpimQ3c6QM3e03+z+ZU2JYVDdu3a+w9L7h3/zxnQPAlICpkgZ4XSXosfeSHh5Yl0B
 yHGzpnQlgFvH0QlhzjqMNdxACljpSZEN2j2xY8zFW93zJTtzpf+D7gxudxCtPOfGauGy09fJW
 T0JwSNlb5N1bCQfJ57IVhJdGDt/iGcJzWwQRrQHU6zfArvMpLpOq5bkAo9ZWx3z0Yl9a+fdP8
 n/JUYC2Vr7VqaUN6Im4RasAJ8IeBadF4nQQX3NxikQU8A=

Am 06.06.24 um 15:59 schrieb Greg Kroah-Hartman:

> 6.6-stable review patch.  If anyone has any objections, please let me kn=
ow.

Hi,

i already said that the underlying race condition can only be triggered si=
nce
commit e2ffcda16290 ("ACPI: OSL: Allow Notify () handlers to run on all CP=
Us"),
which afaik was introduced with kernel 6.8.

Because of this, i do not think that we have to backport this commit to ke=
rnels
before 6.8.

>
> ------------------
>
> From: Armin Wolf <W_Armin@gmx.de>
>
> [ Upstream commit 290680c2da8061e410bcaec4b21584ed951479af ]
>
> Multiple WMI events can be received concurrently, so multiple instances
> of xiaomi_wmi_notify() can be active at the same time. Since the input
> device is shared between those handlers, the key input sequence can be
> disturbed.
>
> Fix this by protecting the key input sequence with a mutex.
>
> Compile-tested only.
>
> Fixes: edb73f4f0247 ("platform/x86: wmi: add Xiaomi WMI key driver")
> Signed-off-by: Armin Wolf <W_Armin@gmx.de>
> Link: https://lore.kernel.org/r/20240402143059.8456-2-W_Armin@gmx.de
> Reviewed-by: Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linu=
x.intel.com>
> Reviewed-by: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/platform/x86/xiaomi-wmi.c | 18 ++++++++++++++++++
>   1 file changed, 18 insertions(+)
>
> diff --git a/drivers/platform/x86/xiaomi-wmi.c b/drivers/platform/x86/xi=
aomi-wmi.c
> index 54a2546bb93bf..be80f0bda9484 100644
> --- a/drivers/platform/x86/xiaomi-wmi.c
> +++ b/drivers/platform/x86/xiaomi-wmi.c
> @@ -2,8 +2,10 @@
>   /* WMI driver for Xiaomi Laptops */
>
>   #include <linux/acpi.h>
> +#include <linux/device.h>
>   #include <linux/input.h>
>   #include <linux/module.h>
> +#include <linux/mutex.h>
>   #include <linux/wmi.h>
>
>   #include <uapi/linux/input-event-codes.h>
> @@ -20,12 +22,21 @@
>
>   struct xiaomi_wmi {
>   	struct input_dev *input_dev;
> +	struct mutex key_lock;	/* Protects the key event sequence */
>   	unsigned int key_code;
>   };
>
> +static void xiaomi_mutex_destroy(void *data)
> +{
> +	struct mutex *lock =3D data;
> +
> +	mutex_destroy(lock);
> +}
> +
>   static int xiaomi_wmi_probe(struct wmi_device *wdev, const void *conte=
xt)
>   {
>   	struct xiaomi_wmi *data;
> +	int ret;
>
>   	if (wdev =3D=3D NULL || context =3D=3D NULL)
>   		return -EINVAL;
> @@ -35,6 +46,11 @@ static int xiaomi_wmi_probe(struct wmi_device *wdev, =
const void *context)
>   		return -ENOMEM;
>   	dev_set_drvdata(&wdev->dev, data);
>
> +	mutex_init(&data->key_lock);
> +	ret =3D devm_add_action_or_reset(&wdev->dev, xiaomi_mutex_destroy, &da=
ta->key_lock);
> +	if (ret < 0)
> +		return ret;
> +
>   	data->input_dev =3D devm_input_allocate_device(&wdev->dev);
>   	if (data->input_dev =3D=3D NULL)
>   		return -ENOMEM;
> @@ -59,10 +75,12 @@ static void xiaomi_wmi_notify(struct wmi_device *wde=
v, union acpi_object *dummy)
>   	if (data =3D=3D NULL)
>   		return;
>
> +	mutex_lock(&data->key_lock);
>   	input_report_key(data->input_dev, data->key_code, 1);
>   	input_sync(data->input_dev);
>   	input_report_key(data->input_dev, data->key_code, 0);
>   	input_sync(data->input_dev);
> +	mutex_unlock(&data->key_lock);
>   }
>
>   static const struct wmi_device_id xiaomi_wmi_id_table[] =3D {
