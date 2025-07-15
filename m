Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B48529B20C;
	Tue, 15 Jul 2025 19:08:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752606504; cv=none; b=mjUvhmGxIAF0S9f7fACaGx6XryC/Pcryx9AsbWZ5NLBRIBehjYf3gu/dbmR6YHb/PAHp+qQWxXxpy3g8BuXOnkVVAXhHH9tDmtXHHSjBkmNfBHgpl2GZepY0Lgt8bF5UAJ80JAYQRcH18aXwxHSviXpwwxTZXbTUddUxEYJQRAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752606504; c=relaxed/simple;
	bh=C6NSJLdCxzeBZjFXiADceoqSo7HrYuwno6HE5J6teGU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HPdh8fJb884xWWwS4+sCV9BJ9/SFMX4aTxR5LSM037Z9jTNSkyZeNQ2B9nojhgPPPcr6WkGrO3HnlDScFNA6rNppuU1Zf8g78UJPzKq/JHI/Q+XTc2rmnGNcHiCWqjUKdrYexfXk95Ebjh7OflE+qEmZeh84jCxEZkvATVP5tbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KSIMXftV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KSIMXftV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90C68C4CEF5;
	Tue, 15 Jul 2025 19:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752606503;
	bh=C6NSJLdCxzeBZjFXiADceoqSo7HrYuwno6HE5J6teGU=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=KSIMXftV6MD0i82lGLIpdJsXDyWXf/UfNEcd0Nqe3lSlgDY2q/RYm/f01yvpkfm8R
	 CzxPyjdMrJu7BES1mJx4yFYcIQC0NtuLjzi/96zdUTXQY26tOxVlIezQzlxuQ0x9uW
	 6Eky+nAVoZZSDzyb5B6CZhAZP3lXYDZvE96QElBPaNzG6fWc3wSVigMitUVokn4WJj
	 ticixJU3fEmeVPNbEs2oX1QUV1qIF5itKSJLYmoBS6HxlzenLuu+GPs52EmXTX1lWJ
	 vJ/Qe8SaUge1+LkwXZYkK+fK2pgvLNef9cjklwC/MWQMDBe5ByiC5pSNHJ35sI47v3
	 /Ev1DC29cM2LQ==
Date: Tue, 15 Jul 2025 15:06:43 -0400
From: Sasha Levin <sashal@kernel.org>
To: Kurt Borja <kuurtb@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
	patches@lists.linux.dev, Mark Pearson <mpearson-lenovo@squebb.ca>,
	Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: Re: [PATCH 6.1 53/88] platform/x86: think-lmi: Fix sysfs group
 cleanup
Message-ID: <aHamw2kyYlWv3Vnt@lappy>
References: <20250715130754.497128560@linuxfoundation.org>
 <20250715130756.686654974@linuxfoundation.org>
 <DBCUFWL772Z5.2MUF08I4D6AH2@gmail.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <DBCUFWL772Z5.2MUF08I4D6AH2@gmail.com>

On Tue, Jul 15, 2025 at 03:34:51PM -0300, Kurt Borja wrote:
>Hi Greg,
>
>On Tue Jul 15, 2025 at 10:14 AM -03, Greg Kroah-Hartman wrote:
>> 6.1-stable review patch.  If anyone has any objections, please let me know.
>>
>> ------------------
>>
>> From: Zhang Rui <rui.zhang@intel.com>
>>
>> [ Upstream commit 4f30f946f27b7f044cf8f3f1f353dee1dcd3517a ]
>>
>> Many error paths in tlmi_sysfs_init() lead to sysfs groups being removed
>> when they were not even created.
>>
>> Fix this by letting the kobject core manage these groups through their
>> kobj_type's defult_groups.
>>
>> Fixes: a40cd7ef22fb ("platform/x86: think-lmi: Add WMI interface support on Lenovo platforms")
>> Cc: stable@vger.kernel.org
>> Reviewed-by: Mark Pearson <mpearson-lenovo@squebb.ca>
>> Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
>> Signed-off-by: Kurt Borja <kuurtb@gmail.com>
>> Link: https://lore.kernel.org/r/20250630-lmi-fix-v3-3-ce4f81c9c481@gmail.com
>> Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  drivers/powercap/intel_rapl_common.c | 22 ++++++++++++++++++++--
>>  1 file changed, 20 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/powercap/intel_rapl_common.c b/drivers/powercap/intel_rapl_common.c
>> index 26d00b1853b42..02787682b395e 100644
>> --- a/drivers/powercap/intel_rapl_common.c
>> +++ b/drivers/powercap/intel_rapl_common.c
>> @@ -21,6 +21,7 @@
>>  #include <linux/intel_rapl.h>
>>  #include <linux/processor.h>
>>  #include <linux/platform_device.h>
>> +#include <linux/string_helpers.h>
>>
>>  #include <asm/iosf_mbi.h>
>>  #include <asm/cpu_device_id.h>
>> @@ -227,17 +228,34 @@ static int find_nr_power_limit(struct rapl_domain *rd)
>>  static int set_domain_enable(struct powercap_zone *power_zone, bool mode)
>>  {
>>  	struct rapl_domain *rd = power_zone_to_rapl_domain(power_zone);
>> +	u64 val;
>> +	int ret;
>>
>>  	if (rd->state & DOMAIN_STATE_BIOS_LOCKED)
>>  		return -EACCES;
>>
>>  	cpus_read_lock();
>> -	rapl_write_data_raw(rd, PL1_ENABLE, mode);
>> +	ret = rapl_write_data_raw(rd, PL1_ENABLE, mode);
>> +	if (ret)
>> +		goto end;
>> +
>> +	ret = rapl_read_data_raw(rd, PL1_ENABLE, true, &val);
>> +	if (ret)
>> +		goto end;
>> +
>> +	if (mode != val) {
>> +		pr_debug("%s cannot be %s\n", power_zone->name,
>> +			 str_enabled_disabled(mode));
>> +		goto end;
>> +	}
>> +
>>  	if (rapl_defaults->set_floor_freq)
>>  		rapl_defaults->set_floor_freq(rd, mode);
>> +
>> +end:
>>  	cpus_read_unlock();
>>
>> -	return 0;
>> +	return ret;
>>  }
>>
>>  static int get_domain_enable(struct powercap_zone *power_zone, bool *mode)
>
>This diff has no relation to commit 4f30f946f27b ("platform/x86:
>think-lmi: Fix sysfs group cleanup"), which the commit message claims.
>
>It should be removed ASAP. Thanks!

Dropped, thanks!

This was supposed to be a backport of 964209202ebe ("powercap:
intel_rapl: Do not change CLAMPING bit if ENABLE bit cannot be
changed").


-- 
Thanks,
Sasha
