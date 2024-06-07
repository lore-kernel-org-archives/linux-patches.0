Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3395623DE;
	Fri,  7 Jun 2024 05:31:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.15
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717738266; cv=none; b=JTrHNsMo19j8kwSOQhdJ4I3KHxrbBdihlSGQ/Y5Fzh16TovwnaO8wFVhmdWgiNNDqJcsDuYHfH1rM+/mKW7VG/xJEqlOUizgF6CQ4y9AyAyQICDiL1ROevUeldSXjhvy0PerECSu6oXjAS4aAV4c5BE7b3ITIFZspbUqiDyU5TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717738266; c=relaxed/simple;
	bh=d7Pfspoh2Qi+kTsdaKamKu7pYvRWH5YrdcyTJO+Qweg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M5jcDwuB3O2V3hoeLCjfODffKnibVph8fXoCGfjO8TV+oaUJG27FTJyfVKTQ7oNg6u/7PH7opt52liUJD8QLpQNaRrHd2Ij8GXSif/ZAaR5h1MC/Cf2iv6zIhZ/HBz6GiH9ZkEjj9z/vazPW15pBcmQobnAjmEUutzp0uO3se+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=w_armin@gmx.de header.b=gZAZhJr+; arc=none smtp.client-ip=212.227.15.15
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=w_armin@gmx.de header.b="gZAZhJr+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1717738252; x=1718343052; i=w_armin@gmx.de;
	bh=6O9P6JXvaaHNit8nIQ9Ie1N76L02iOTre1AEWeqJmgA=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=gZAZhJr+rExZmH4kRJczS6l5l1dUpeMFa/Gkluc7cgP02y2crIvZ1m12miAqKHSN
	 xoFXJMFgGkSvAguO9LG9gL6jIJQvwJIhP5dbrE+LM5QBiZnKRYys0KRK3GG4m0t9t
	 aIQHMD8O+FWgTzToPfm1HB4ZSq6B05Fr0ogqNJDn6VuhZSlfR7LUlURDJ3ISy8cmS
	 uJrX8glArMdQZmQ4NMeqd8wCftaFxuYXebbnYg4z4yEXGxpC3tFH58DoS0OnymhGD
	 K9JiI/4gtD3CvU2YFkkDVGBm0SUOV0EKfVtT/tqIndHIdyBw9BCUB4y29+ORpcyn7
	 iHpW0qnQs7l/mokXdg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.2.35] ([91.137.126.34]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1MA7GS-1s8KO60w9K-00CMYD; Fri, 07
 Jun 2024 07:30:52 +0200
Message-ID: <7a4636f4-9b38-468c-9300-e05f60220df9@gmx.de>
Date: Fri, 7 Jun 2024 07:30:50 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 213/473] platform/x86: xiaomi-wmi: Fix race condition
 when reporting key events
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev,
 Kuppuswamy Sathyanarayanan <sathyanarayanan.kuppuswamy@linux.intel.com>,
 Hans de Goede <hdegoede@redhat.com>, Sasha Levin <sashal@kernel.org>
References: <20240606131659.786180261@linuxfoundation.org>
 <20240606131706.958934841@linuxfoundation.org>
Content-Language: en-US
From: Armin Wolf <W_Armin@gmx.de>
In-Reply-To: <20240606131706.958934841@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:2OMsbjubz3TbUl5AF4DMf+gVjJsKLgqvQShzJaNFkKs1bvGpK5w
 5wWDhPNEUsInWF4FtcPbcjsjTq+2wHxmoCFU5MMcMo8DTdaJmL5J75xeyy7m1AtwE60AUXm
 fpZAXQTiTDlvw4tGNyZaB4sohiAvCrjyrn+cv6e7EXvKPJcfCqKDqAZMTIu9CDEXhdSjQ/i
 hsHFA+z7Q4APCrpAMGMvw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:UfuAZy/JUto=;LVdsZouP5BheXr77tmJPQLvzCVi
 dnF1seCt4idZiUumTSRWPZdmpCrrJwcM7FdN9IUi63sM0qcPVQP07WiFOWLG2ZjmjmH0zcAoK
 EvFVHd+dRdwyAeFLy9CNRZ2PGTjv+e5BXUDjhwBnFTJlGMxe1vZ+wzRHNVYAI5+QmFTgptEh+
 0lQo+5xQRt8s+vj9ItyNDn+kY4DFSCYCtk0BhgbuUxq7b3M4gqe9TKmIE8M4puhqiXrwnnPIS
 OY2r0tspPFPwHFD6sJFLJdhcnJ4aUQACsoBBU+zGDXZmQ+Stt8+q/lih1Q4aP6dckutOwgfFL
 puFHXFM/STX1bk8EJCxHu2II3vESusSJO3IDaE+IbVCvy8C1MMgykzSt6VHEWJfQEJ+jJbnoK
 0WFWAXCEup00z77HlAxSJ4wjAmXuLbm+FpE+7rrwphiyLHx86+I5QlxM6Jtop/MWLQ9eKvdYa
 0p3u2rwB62fOHDTw3IrKlS3IPXZ+AlqVP/8W89wzT9e2IXoQQKOC1r8BImiIaJ4zcaBGekgyV
 ktjjosbcVPIe2XlmmSd3FTP6SNut3VMOU0rTirLJ8i1cnvXBWjQNXXoI3jmcKpnuxrRrmHdPc
 T+3Fr2eSa0FYfrbWZIs4F6htlK6Kar/X1YJOZiJoC+6MutMxzjDCCcRuNIdBX3ZEkE6VGlzwh
 ztVzExN/WL5L1p1sPkGH3vhefDYYd01S/IMJuxm00M+MNg0i0K+QotyOGjDq1m/qO0TkMrJdn
 ffeYFoIT1OMzsnL6FUpqoPEc6V+pgRFm/UjxuXgKMlqzBhih2e+Z1D/H/qvkaz1zz1EPlCOgK
 MFEKnYTDBpKoKRGicZwDH/pZynD1KssLRJvpcskYOZIfI=

Am 06.06.24 um 16:02 schrieb Greg Kroah-Hartman:

> 6.1-stable review patch.  If anyone has any objections, please let me kn=
ow.
>
> ------------------

Hi,

i already said that the underlying race condition can only be triggered si=
nce
commit e2ffcda16290 ("ACPI: OSL: Allow Notify () handlers to run on all CP=
Us"),
which afaik was introduced with kernel 6.8.

Because of this, i do not think that we have to backport this commit to ke=
rnels
before 6.8.

Thanks,
Armin Wolf

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
