Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B9EA352FA8
	for <patches@lists.linux.dev>; Tue, 10 Feb 2026 10:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770718781; cv=pass; b=uhWyWV5kWhQDhESMfZIC2m2RZxbJ4mMCFBgGY+AQE3C/WzTkUf/2Kqryvuus2EJ9WHQdxuUxAIqoLM+A8iTbwnNYsn2vtIwetZlqjedWPY/wlbWDWxhXMQJV/ktPs1sjl2r9sR6ak/1kns3akhuyaqMRwLgLE6/id/+k7+mQRW4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770718781; c=relaxed/simple;
	bh=dSFTEfgXKbykpk9p92H0dQTA0zHwTAdF8HS1JKm5Wqg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rRhv1SldBShLhkm4MAVewks8RahhlGYItDx3k58ikMGrAVnra27NcGaPNu0cUyYCaFLXPdA3QP6AtPCNAhHFexL79KkrCJsqibW69LXtT1EOgZyr8SWOsnTvQyd/4d1tDstTTemEIvoJFSDD91ODt3ZtvgJqhHwfzqKr4pliSHc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gooddata.com; spf=pass smtp.mailfrom=gooddata.com; dkim=pass (1024-bit key) header.d=gooddata.com header.i=@gooddata.com header.b=Rc/jzQam; arc=pass smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gooddata.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gooddata.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=gooddata.com header.i=@gooddata.com header.b="Rc/jzQam"
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1270ac5d3efso3286221c88.1
        for <patches@lists.linux.dev>; Tue, 10 Feb 2026 02:19:40 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770718779; cv=none;
        d=google.com; s=arc-20240605;
        b=Q5ure8yfANk52HAMYm68hp2kk7TzCFJ3z8NYEsrMhi0wvxw8SfUF0yQd5pZyJ7bUFP
         T6Oh1WiugzRWtyl5PbnWYumpPQj2Om4K7XKqZzMdwbdgoip1tG/opZ4wFeCdrxbbEzcV
         SR39qz0oumgaRUFWT7KfYaXqF/E6Duvjw8jBR8QHmtykRgfXZaXEedSH60bXsk0eJmyr
         cD7XNJOyS/gBnR7eG3pHfjnqj9m2WmCXTskufvRDNBUcb9b1E2J0MLNVStsncqHvARk5
         rTG2GYDaAu+b9N5bGRkVSgRxw9YNN7K94U+RqRmligMM6wyamrhPTgbja6z/cFok/C1c
         J80g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=v1As3rR/RqPznaN0GwCfzUHJgmd9J2i2tp9S3bSufFU=;
        fh=gj+3CSaw5t0l6iSJbzO+8cxnV+N0EwnFjtoolLPAlEA=;
        b=WqipENJ6IcllplFicbQSsUsupwOwEYm33rsjmFMDzNI1sFBXg39Q46XAGIEidqe5yj
         iDYbhbM4U+7+B8CeAIUZ80L5h1NWFaT6YM5oHOHCICs+Y29PfxHidvyY5pvlZx2Cf9/O
         /ua/bqYTM0oeq70KWOXyMhNCqQTJj4IGZWWKFqKgK18QN48ALa5hWqSJcXXqHi9WrYjs
         PYprc/8B5yIxpSt1LNpgJ+YGu+WwKuRpjl0UuZgPRGmc1GtbqOpF/o3HHpiYhEBkuzK4
         z9DmKR2IV8s98Xbr4OfQ/AWmGEfoYhudwisxDGG+MfSbggedHLeis37S6Fgq5deF5OHB
         Bzhw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gooddata.com; s=google; t=1770718779; x=1771323579; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=v1As3rR/RqPznaN0GwCfzUHJgmd9J2i2tp9S3bSufFU=;
        b=Rc/jzQamAzmJsjf/UzTYwCt/pA+RHarnRAXkRrs+Q4d3fCMpf14VERISWT64nwAHoA
         0mv1BRiG9902hev28IGQ0ROpTQK4WQ7jXx+0L4dRiq+1HIIA8D1iZzHLuPa/Fie2ld7l
         Yeuwa5DErrPkQoWzh/ZP9QTEzwnbywZkSuuks=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770718779; x=1771323579;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v1As3rR/RqPznaN0GwCfzUHJgmd9J2i2tp9S3bSufFU=;
        b=v5KfkN1sRuSGFNPZHCahhsDoSh9XbikB+iz1xzs8uxtpZ0nGimmS1yysnLLqSRU/a6
         TRzjUvdtm8u9+wEx1BPfAqYPMzTu3nE44MXBkT37d8H0vUVIcAcrdaEVleOBVr76JiIM
         ZHB3APJpLQO5dwCr8pbzYglymzcwL6WC2OR+KU/lzXbKovuln63CoZJ12e0nxXYTzoGu
         HW2M7Y7gPwAsnDkODg8fTE8ii1avljKrM6LQzd+I0Cje6DQGjqW/Gy9wnrkEmX6vOUiW
         vFa1rhL0LOde7crgEKberQM9NXok60yEGLMBiie4MQL8qxFYhbu26n5GrJxftAx5ovUv
         Adhw==
X-Forwarded-Encrypted: i=1; AJvYcCUkGXz4nQRKwxMDn0z0Omi7kNYlVgfCgB5Ls5GybpuPHjHB+E41CwXtqH0HtP45iUVN8FKuCrXN@lists.linux.dev
X-Gm-Message-State: AOJu0YxeQwwqgER1Zfk+Wu+Xhsr3D28xdurPcy6120RNZ9c2BHcxO3s4
	LBFZ5ddYCWk/aHqYUZP2rh6dYbkpwofK3yrmdlgZ6LHZa1VaUnBD8pIur9rsaBf3g8eyEdK7/um
	g8VqVtH6B0TNInusXfB+zPrdCTVcoMjQysQdX4vzo
X-Gm-Gg: AZuq6aJyWrpduOCc9lp7iIXZbdMEnG5PmfgGx/84NNCjJw1eZk7hZ6Q7Z/YGfaPnC3C
	LyBthmATFlHxpy+L2mtn5uRSAymVgSwjJipAXhHkEb4IQwr6v9tZwvMViIgRhbz418Ql1GF419Q
	PfXMNs9QvOnAWX7ACH8SPRrQqx8eU/YAVVq0Azhz8HmeBfHDHAyyOqW3s/wchiSkHeRIAqxnX96
	Exsic9WDNpnThwkvftEJdSiul9zjlQK+VKc9WYbRO2vDe/mozUkmLPLaUotAAQCJjF1KK5fA+/R
	jKMRyZOqyfKcR+Hstyo=
X-Received: by 2002:a05:7022:62a7:b0:11b:1c6d:98bd with SMTP id
 a92af1059eb24-12703f544a0mr5345549c88.9.1770718779531; Tue, 10 Feb 2026
 02:19:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260209142320.474120190@linuxfoundation.org> <20260209142325.330634333@linuxfoundation.org>
In-Reply-To: <20260209142325.330634333@linuxfoundation.org>
From: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Date: Tue, 10 Feb 2026 11:19:12 +0100
X-Gm-Features: AZwV_Qj7lRHJCwijfuEMUmqtqEp8DvF0UoJEcCYAAmPadURwkWOzymYFJDg8h-Q
Message-ID: <CAK8fFZ5n-og8dxFrh4J7pWW9h+iTp+AbdGUF1cd_7jDZpKEj8w@mail.gmail.com>
Subject: Re: [PATCH 6.18 134/175] hwmon: (acpi_power_meter) Fix deadlocks
 related to acpi_power_meter_notify()
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, Guenter Roeck <linux@roeck-us.net>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

>
> 6.18-stable review patch.  If anyone has any objections, please let me know.
>
> ------------------
>
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>
> [ Upstream commit 615901b57b7ef8eb655f71358f7e956e42bcd16b ]
>
> The acpi_power_meter driver's .notify() callback function,
> acpi_power_meter_notify(), calls hwmon_device_unregister() under a lock
> that is also acquired by callbacks in sysfs attributes of the device
> being unregistered which is prone to deadlocks between sysfs access and
> device removal.
>
> Address this by moving the hwmon device removal in
> acpi_power_meter_notify() outside the lock in question, but notice
> that doing it alone is not sufficient because two concurrent
> METER_NOTIFY_CONFIG notifications may be attempting to remove the
> same device at the same time.  To prevent that from happening, add a
> new lock serializing the execution of the switch () statement in
> acpi_power_meter_notify().  For simplicity, it is a static mutex
> which should not be a problem from the performance perspective.
>
> The new lock also allows the hwmon_device_register_with_info()
> in acpi_power_meter_notify() to be called outside the inner lock
> because it prevents the other notifications handled by that function
> from manipulating the "resource" object while the hwmon device based
> on it is being registered.  The sending of ACPI netlink messages from
> acpi_power_meter_notify() is serialized by the new lock too which
> generally helps to ensure that the order of handling firmware
> notifications is the same as the order of sending netlink messages
> related to them.
>
> In addition, notice that hwmon_device_register_with_info() may fail
> in which case resource->hwmon_dev will become an error pointer,
> so add checks to avoid attempting to unregister the hwmon device
> pointer to by it in that case to acpi_power_meter_notify() and
> acpi_power_meter_remove().
>
> Fixes: 16746ce8adfe ("hwmon: (acpi_power_meter) Replace the deprecated hwmon_device_register")
> Closes: https://lore.kernel.org/linux-hwmon/CAK8fFZ58fidGUCHi5WFX0uoTPzveUUDzT=k=AAm4yWo3bAuCFg@mail.gmail.com/
> Reported-by: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/hwmon/acpi_power_meter.c | 17 ++++++++++++++---
>  1 file changed, 14 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/hwmon/acpi_power_meter.c b/drivers/hwmon/acpi_power_meter.c
> index 29ccdc2fb7ff8..de408df0c4d78 100644
> --- a/drivers/hwmon/acpi_power_meter.c
> +++ b/drivers/hwmon/acpi_power_meter.c
> @@ -47,6 +47,8 @@
>  static int cap_in_hardware;
>  static bool force_cap_on;
>
> +static DEFINE_MUTEX(acpi_notify_lock);
> +
>  static int can_cap_in_hardware(void)
>  {
>         return force_cap_on || cap_in_hardware;
> @@ -823,18 +825,26 @@ static void acpi_power_meter_notify(struct acpi_device *device, u32 event)
>
>         resource = acpi_driver_data(device);
>
> +       guard(mutex)(&acpi_notify_lock);
> +
>         switch (event) {
>         case METER_NOTIFY_CONFIG:
> +               if (!IS_ERR(resource->hwmon_dev))
> +                       hwmon_device_unregister(resource->hwmon_dev);
> +
>                 mutex_lock(&resource->lock);
> +
>                 free_capabilities(resource);
>                 remove_domain_devices(resource);
> -               hwmon_device_unregister(resource->hwmon_dev);
>                 res = read_capabilities(resource);
>                 if (res)
>                         dev_err_once(&device->dev, "read capabilities failed.\n");
>                 res = read_domain_devices(resource);
>                 if (res && res != -ENODEV)
>                         dev_err_once(&device->dev, "read domain devices failed.\n");
> +
> +               mutex_unlock(&resource->lock);
> +
>                 resource->hwmon_dev =
>                         hwmon_device_register_with_info(&device->dev,
>                                                         ACPI_POWER_METER_NAME,
> @@ -843,7 +853,7 @@ static void acpi_power_meter_notify(struct acpi_device *device, u32 event)
>                                                         power_extra_groups);
>                 if (IS_ERR(resource->hwmon_dev))
>                         dev_err_once(&device->dev, "register hwmon device failed.\n");
> -               mutex_unlock(&resource->lock);
> +
>                 break;
>         case METER_NOTIFY_TRIP:
>                 sysfs_notify(&device->dev.kobj, NULL, POWER_AVERAGE_NAME);
> @@ -953,7 +963,8 @@ static void acpi_power_meter_remove(struct acpi_device *device)
>                 return;
>
>         resource = acpi_driver_data(device);
> -       hwmon_device_unregister(resource->hwmon_dev);
> +       if (!IS_ERR(resource->hwmon_dev))
> +               hwmon_device_unregister(resource->hwmon_dev);
>
>         remove_domain_devices(resource);
>         free_capabilities(resource);
> --
> 2.51.0
>
>
>

Hello, I tested this patch, but unfortunately it does not resolve the
reported issue on our systems the deadlock is still reproducible with
the same iDRAC reset reproducer.

Jaroslav Pulchart
