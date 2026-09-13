Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E598738A728
	for <patches@lists.linux.dev>; Sun, 13 Sep 2026 13:21:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789305681; cv=none; b=Lxpoxibx/lDey4pbXyT0IPz7XNqgMVVb4/jFOlyazKd5ILTBDTjNqLdFTNLq7uwYPB3EGEqz5i8Z4nabN83zpyuIvI5jtqT6Hul+GyACy1r8k/849UhBmBy6ubSUGVN0oXlOWXgPWGPlr1cL9XJ11Q9hEkLP2zsYRq1F7v9nbqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789305681; c=relaxed/simple;
	bh=Phi07PPMJdWHszbQDLkmYpvn2FXNZIvtH//ocNjPnZ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=d/ORnEuY9ptqRqCJGEI0/nHVrrBIRzrzgkP0vT4qM7xIEjDxk1h08LPyx7AaHPP/LW/ogclmNWMilHsu2xYJih9EOLEXr0DIFknZVQIg2+iezFo63W2u2M2Ee0VrkMQNuoChIUX+BSSPe75zcQyY/Z/3ieuWvKDgdMmQyGfY938=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=NbKsEn9c; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="NbKsEn9c"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6350f88so538377f8f.2
        for <patches@lists.linux.dev>; Sun, 13 Sep 2026 06:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1789305678; x=1789910478; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ilAntqs10N3cuZV3xb1rPgVYySTl8brlVvPmSH3oaLw=;
        b=NbKsEn9cbIrIIutxaHTGBX4dygbmK3vj4DEJ6f09o5PUGvJEFU4y+Tu91jAawO+I+d
         6S3KWeVU4/Ru7MZHQJeXcVA/hxU0Be2PRFmqiRihtUBhrZ+y4G/xO6OjO0WidZRmqb1+
         ndw0/3XUjZQeKrDJ/gpED1VSvGngSB3zOWYFXeT+OUAfMrqJCU1lBlmRk5JMIQrKVNm+
         Rb5IQjj9viGo60mgVIASLFKdQKZBjm2lgiQ0pLDCQAwnRWRsguHuk2cqeLZEZCn8wcll
         UfGH62E2xoXVrwlr542CNARSf4p1RFKd7URw6iVFGx6GUWFDqu0BjzAeIf/n0ISrcX7N
         hvdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789305678; x=1789910478;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ilAntqs10N3cuZV3xb1rPgVYySTl8brlVvPmSH3oaLw=;
        b=VZlQAuu4eSKVAARjwbthk/tbjLcDdt1skOiEe7UlkrzEmwZlmQKIjIbu8w9QmwU7Gz
         fd/+B8CgEgoqJaSQ1mDS35ojY9Oobp3dLJ+GMQZnz1bqgmjgwrjh7sueTe9PVGo+eWEP
         B6IuZVvNTbp4F/5Hpy6ZwX8Ju695u8hQx0MUqVUY6Y8I1ICCEa7EnIYwKbSpELfmPU5/
         adkUWiPLpNfgq4XV2kYuPqZlD7ccmJL4OpK+faG9DM6NKosIRpTQOcC8l88M8D94T4EZ
         rhSecA2QLh9XBWPXJRiU7eCTQWShHlORC6QgPShhPh6b73spTbTtQ8E0zZOw+A33gP6E
         qaHQ==
X-Gm-Message-State: AFuF++nL1+a18fKUxopm+azCdO5DwrtMlOiYvQtK+7QF4a+7Krk4xJIv
	JsAnTCk2a0VZ8m5cr7y59x4drlE2bR3IYQ1OflLmtzNDucZcUTk6HLU=
X-Gm-Gg: AYBFou1vAf9Nb+SAEYDd80JwMEG38DVcg7Z5ZZzIHZloQyeFHt6BfNvZVBpKX+txK4C
	uNbUakHikG2zVtDhhJt009TmfX1OOfI48lkbz1dt7u6Y9a5o2DhvMfE4fskFAtYkfRgDnUz3Ex5
	OolzDjsL5QWzXUJoUbvqQXM7AriRprYhUGv7b73qwe6k57L9GDPv47o3vBPeKBlZDrqJAOikYbo
	iFsFN/CR2C8Ry5MJBMRVVBNqSTUnTxQJF387d5pz4qoI+shoasRbjudyHxPWjQPePX/xCH8mTJ7
	zT9Hd54IPvEPjOqwAFGVgKpG2IobdN+B0Jv3EBjL+ae/g/drU6D13AAMTo9I5emBZNC3oUeeKgA
	voWPIpivkak3U6nBoVOu/v9N9AdYqmnKbolWY0rpFO0UbtyHznxFUtj3ZwSM/EpDszK66Ecwn5L
	7l6bsruRcHrdh1751XQJ9bHmMG/1zii1X4B+zD5pzWfzIidutt7IqahocrvObi4MeiP8bax8Ngu
	zXSnNtEZf8NTX4H8Ih/L5uSda00BwRJhCS1Q0sdw3vtF0ts
X-Received: by 2002:a05:6000:2902:b0:486:f620:63bd with SMTP id ffacd0b85a97d-486f6a7d6d1mr6273755f8f.0.1789305677847;
        Sun, 13 Sep 2026 06:21:17 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4716.dip0.t-ipconnect.de. [91.43.71.22])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-486eb32d5f1sm20960810f8f.12.2026.09.13.06.21.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Sep 2026 06:21:17 -0700 (PDT)
Message-ID: <e6152171-5c2c-4243-8b64-0a619a0f44e3@googlemail.com>
Date: Sun, 13 Sep 2026 15:21:16 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 0977/1376] scsi: core: sysfs: Make use of bus
 callbacks
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?=
 <u.kleine-koenig@baylibre.com>, Peter Wang <peter.wang@mediatek.com>,
 Bart Van Assche <bvanassche@acm.org>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Sasha Levin <sashal@kernel.org>, Wentao Guan <guanwentao@uniontech.com>,
 linux-scsi@vger.kernel.org
References: <20260912065607.535295758@linuxfoundation.org>
 <20260912065629.342165847@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260912065629.342165847@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 12.09.2026 um 08:56 schrieb Greg Kroah-Hartman:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
> 
> [ Upstream commit f7d4f1bf5724e52de049c619beddd53c62206624 ]
> 
> Introduce a bus-specific probe, remove and shutdown function. For now
> this only allows to get rid of a cast of the generic device to a SCSI
> device in the drivers and changes the remove prototype to return
> void---a non-zero return value is ignored anyhow.
> 
> The objective is to get rid of users of struct device_driver callbacks
> .probe(), .remove() and .shutdown() to eventually remove these. Until
> all SCSI drivers are converted, this results in a runtime warning about
> the drivers needing an update because there is a bus probe function and
> a driver probe function. The in-tree drivers are fixed by the following
> commits.
> 
> Signed-off-by: Uwe Kleine-König <u.kleine-koenig@baylibre.com>
> Reviewed-by: Peter Wang <peter.wang@mediatek.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>
> Link: https://patch.msgid.link/a54e363a3fd2054fb924afd7df44bca7f444b5f1.1766133330.git.u.kleine-koenig@baylibre.com
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Stable-dep-of: bb31844d88b7 ("scsi: sd: Fix special_vec mempool leak when scsi_alloc_sgtables() fails")
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>   drivers/scsi/scsi_sysfs.c  | 73 ++++++++++++++++++++++++++++++++++++--
>   include/scsi/scsi_driver.h |  3 ++
>   2 files changed, 74 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> index 7f69f0613c08c..0b29cbcbd7e1f 100644
> --- a/drivers/scsi/scsi_sysfs.c
> +++ b/drivers/scsi/scsi_sysfs.c
> @@ -554,10 +554,48 @@ static int scsi_bus_uevent(const struct device *dev, struct kobj_uevent_env *env
>   	return 0;
>   }
>   
> +static int scsi_bus_probe(struct device *dev)
> +{
> +	struct scsi_device *sdp = to_scsi_device(dev);
> +	struct scsi_driver *drv = to_scsi_driver(dev->driver);
> +
> +	if (drv->probe)
> +		return drv->probe(sdp);
> +	else
> +		return 0;
> +}
> +
> +static void scsi_bus_remove(struct device *dev)
> +{
> +	struct scsi_device *sdp = to_scsi_device(dev);
> +	struct scsi_driver *drv = to_scsi_driver(dev->driver);
> +
> +	if (drv->remove)
> +		drv->remove(sdp);
> +}
> +
> +static void scsi_bus_shutdown(struct device *dev)
> +{
> +	struct scsi_device *sdp = to_scsi_device(dev);
> +	struct scsi_driver *drv;
> +
> +	if (!dev->driver)
> +		return;
> +
> +	drv = to_scsi_driver(dev->driver);
> +
> +	if (drv->shutdown)
> +		drv->shutdown(sdp);
> +}
> +
> +
>   const struct bus_type scsi_bus_type = {
> -        .name		= "scsi",
> -        .match		= scsi_bus_match,
> +	.name		= "scsi",
> +	.match		= scsi_bus_match,
>   	.uevent		= scsi_bus_uevent,
> +	.probe		= scsi_bus_probe,
> +	.remove		= scsi_bus_remove,
> +	.shutdown	= scsi_bus_shutdown,
>   #ifdef CONFIG_PM
>   	.pm		= &scsi_bus_pm_ops,
>   #endif
> @@ -1609,6 +1647,30 @@ void scsi_remove_target(struct device *dev)
>   }
>   EXPORT_SYMBOL(scsi_remove_target);
>   
> +static int scsi_legacy_probe(struct scsi_device *sdp)
> +{
> +	struct device *dev = &sdp->sdev_gendev;
> +	struct device_driver *driver = dev->driver;
> +
> +	return driver->probe(dev);
> +}
> +
> +static void scsi_legacy_remove(struct scsi_device *sdp)
> +{
> +	struct device *dev = &sdp->sdev_gendev;
> +	struct device_driver *driver = dev->driver;
> +
> +	driver->remove(dev);
> +}
> +
> +static void scsi_legacy_shutdown(struct scsi_device *sdp)
> +{
> +	struct device *dev = &sdp->sdev_gendev;
> +	struct device_driver *driver = dev->driver;
> +
> +	driver->shutdown(dev);
> +}
> +
>   int __scsi_register_driver(struct scsi_driver *sdrv, struct module *owner)
>   {
>   	struct device_driver *drv = &sdrv->gendrv;
> @@ -1616,6 +1678,13 @@ int __scsi_register_driver(struct scsi_driver *sdrv, struct module *owner)
>   	drv->bus = &scsi_bus_type;
>   	drv->owner = owner;
>   
> +	if (!sdrv->probe && drv->probe)
> +		sdrv->probe = scsi_legacy_probe;
> +	if (!sdrv->remove && drv->remove)
> +		sdrv->remove = scsi_legacy_remove;
> +	if (!sdrv->shutdown && drv->shutdown)
> +		sdrv->shutdown = scsi_legacy_shutdown;
> +
>   	return driver_register(drv);
>   }
>   EXPORT_SYMBOL(__scsi_register_driver);
> diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
> index 40aba9a9349a6..249cea724abd1 100644
> --- a/include/scsi/scsi_driver.h
> +++ b/include/scsi/scsi_driver.h
> @@ -12,6 +12,9 @@ struct request;
>   struct scsi_driver {
>   	struct device_driver	gendrv;
>   
> +	int (*probe)(struct scsi_device *);
> +	void (*remove)(struct scsi_device *);
> +	void (*shutdown)(struct scsi_device *);
>   	int (*resume)(struct device *);
>   	void (*rescan)(struct device *);
>   	blk_status_t (*init_command)(struct scsi_cmnd *);


As Wentao Guan pointed out, this is the patch that caused the dmesg warnings I encountered in boot-testing 6.12.110-rc1 
and 6.18.52-rc1 on my machine:

[    2.397237] Driver 'sr' needs updating - please use bus_type methods
...
[   84.031323] Driver 'ses' needs updating - please use bus_type methods

Is this really stable material? I feel that a new stable release should not trigger new warning messages. Feels like a 
regression, even if it does no harm... No?!

Or are there some driver patches missing that still need proper backports?

CC'ing linux-scsi list, too.

Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
