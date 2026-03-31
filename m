Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4727B36402E
	for <patches@lists.linux.dev>; Tue, 31 Mar 2026 19:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774984388; cv=none; b=fN71gujQCx0kQk8wFU/DeNe9QlQff4I4Fm3XUXZDfaV4KtdjTOA7FaRIXA4Msm6vSEaxUTTwzJF5xYdmfWile2HGYRj8F1E0jcDQxglLHKbk4Sg02vXHG0Yio++Gkf5mug5P267HXw0kGYfuQ4lq9c5J+mES5vgO2MzMrxgRfoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774984388; c=relaxed/simple;
	bh=hl8AtJX6I7d4e7IwG035sd2dO77DSoqLPGsnHW6EB0w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rJzuPTsOUr+ZWaBDcT0MBTX6+rgvQKVcrG+eIfMBwmAtoVMSHcs5wyV3n5sJ5kvuqLYt45ZbdK4i05D4cNi1Chc/pgNlNftu+Y+5VKOWFMQWA4fKqFs6m7ZKZXlpUnG3a3VLA8YG9yy9xPhyFEE4hQMmxInE+vPIkoEF5pGQp3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NRqSga5H; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NRqSga5H"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7d7f92bde91so3960133a34.1
        for <patches@lists.linux.dev>; Tue, 31 Mar 2026 12:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1774984386; x=1775589186; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JFbNda8GpywTskESpPvkrm6fXAaL7MDAY2UtfW+3Q7k=;
        b=NRqSga5HQWdQSRhU6lsyMOnNGTwULF0tG2rU+D2YD1Oox+bPMmKH195y2N1HouN9g7
         r5hmglc822HLfYNBMEdXPQAGfpKhv0MzNO3ty3CSZ5DNXxZn0OtM71xsdwodlwMsDFJN
         YIHR8CwFexWGq9+EvoggigCL5f5vh8K9ADd88=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774984386; x=1775589186;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JFbNda8GpywTskESpPvkrm6fXAaL7MDAY2UtfW+3Q7k=;
        b=MCnMGJN31hXlrYbOH5fcZAA7mijTIWBg9Gmjc3B/MrSwcOL81VOXnIEjsvcbCIijGU
         wNfR6RxizYfl+INvNlKCzk88fKKb/7MK+g2Ued55MaklJfC3TD14Xfs6oM8wanfMmD97
         Gqkuc/cdyZ8bZcHs+pWnnDWB0x2FWPWqIpnytvFXqPHc85bjxyp4zn66jC1MvkXwVx1p
         doyWaEIYdHMH+7zQGJ48YPTdRoPXoyUkWRMJNuBi3J7+TPM3m6wN0KuH/9705Z8CjQ1W
         T1FYPbPMPdHuljbWzs2R54MKsmvjfPIFBPwChKxbe5uYlTJBdvxhVbYpkjar5vqEkS3h
         p26Q==
X-Forwarded-Encrypted: i=1; AJvYcCUDTB8xiIGMmztlP1rHcw0ty5zk89dryMBIJj1/119U0KUmDIEEjKDsNDcNK5CzqbN7dAhMBsKH@lists.linux.dev
X-Gm-Message-State: AOJu0YygkNh1CZt5LoqQEqlN4FKaHGoHongm7lpH3ohrxif5dSjY6IiA
	6k2K4xWLLgxz1lscVwwS4pDSUj9mi3ZaYoWhArIqpO+1fJWqYpIzsPy+vqV86L+IFyY=
X-Gm-Gg: ATEYQzweAyfGpbw+U5iNjlUcrYx8HMpJ6RikHR3vymjLvzwcg0k/5so/CvfFheouPn+
	95ofV691UHs4DbtnL1AIx/0CgKxY/GAFXxZz2Q/6SrmQAZ8Bw/CDWGq1T9ayBsDyvpRApr4Czn0
	tAkW2ENkrZzMkMd2bfinYF+O1+/+8y6BRjAovjrfI98hfT6R0rAcmPSASpH+QK2EqfFj0jK626y
	A9n+CY2LwdiZOEQxJInTe25LuL6FRbFtj5Z9zTVcPcu6U4WpI+raEqjqeGS7UW8I78tKjYJM0Kk
	iUst64kuXup04JM+ykWN7Z5sxSzi4wU3SuZg/tGuviycvNYpP+80GvFmTFtb9beK2a88nfOv2oL
	DNexdB/5Nx9KWW+hggQXbrsBc7L1mehpDrheNcsL8IINCKfC6QNiJNvePfFIWi3byRYBBbfPmDU
	oKRcatRid2xeF6hScZTaw7OdPjzQd6u5kFO0HXUp9w8Jd2Gg==
X-Received: by 2002:a05:6820:1a0f:b0:67e:160c:36a1 with SMTP id 006d021491bc7-67fabca3628mr286496eaf.31.1774984385963;
        Tue, 31 Mar 2026 12:13:05 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-67e2305db5dsm7419592eaf.4.2026.03.31.12.13.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2026 12:13:05 -0700 (PDT)
Message-ID: <17b0f9ea-ea81-489c-8a8b-f3118d3d28f3@linuxfoundation.org>
Date: Tue, 31 Mar 2026 13:13:03 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 00/10] selftests/resctrl: Fixes and improvements
 focused on Intel platforms
To: Reinette Chatre <reinette.chatre@intel.com>, shuah@kernel.org,
 Dave.Martin@arm.com, james.morse@arm.com, tony.luck@intel.com,
 babu.moger@amd.com, ilpo.jarvinen@linux.intel.com
Cc: fenghuay@nvidia.com, peternewman@google.com, zide.chen@intel.com,
 dapeng1.mi@linux.intel.com, ben.horgan@arm.com, yu.c.chen@intel.com,
 jason.zeng@intel.com, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev,
 Shuah Khan <skhan@linuxfoundation.org>
References: <cover.1773432891.git.reinette.chatre@intel.com>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <cover.1773432891.git.reinette.chatre@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/13/26 14:32, Reinette Chatre wrote:
> Changes since v2:
> - v2: https://lore.kernel.org/linux-patches/cover.1772582958.git.reinette.chatre@intel.com/
> - Rebased on top of v7.0-rc3.
> - Split "selftests/resctrl: Improve accuracy of cache occupancy test" into
>    changes impacting L3 and L2 respectively. (Ilpo)
> - "long_mask" -> "full_mask", "return_value" -> "measurement", "org_count"
>    -> "orig_count". (Ilpo)
> - Use PATH_MAX where appropriate. (Ilpo)
> - Handle errors first to reduce indentation. (Ilpo)
> - Detailed changes in changelogs.
> - No functional changes since v2. Series tested by running 20 iterations of all
>    tests on Emerald Rapids, Granite Rapids, Sapphire Rapids, Ice Lake, Sierra
>    Forest, and Broadwell.
> 
> Changes since v1:
> - v1: https://lore.kernel.org/lkml/cover.1770406608.git.reinette.chatre@intel.com/
> - The new perf interface that resctrl selftests can utilize has been accepted and
>    merged into v7.0-rc2. This series can thus now be considered for inclusion.
>    For reference,
>    commit 6a8a48644c4b ("perf/x86/intel/uncore: Add per-scheduler IMC CAS count events")
>    The resctrl selftest changes making use of the new perf interface are backward
>    compatible. The selftests do not require a v7.0-rc2 kernel to run but the
>    tests can only pass on recent Intel platforms running v7.0-rc2 or later.
> - Combine the two outstanding resctrl selftest submissions into one series
>    for easier tracking:
>    https://lore.kernel.org/lkml/084e82b5c29d75f16f24af8768d50d39ba0118a5.1769101788.git.reinette.chatre@intel.com/
>    https://lore.kernel.org/lkml/cover.1770406608.git.reinette.chatre@intel.com/
> - Fix typo in changelog of "selftests/resctrl: Improve accuracy of cache
>    occupancy test": "the data my be in L2" -> "the data may be in L2"
> - Add Zide Chen's RB tags.
> 
> Cover letter updated to be accurate wrt perf changes:
> 
> The resctrl selftests fail on recent Intel platforms. Intermittent failures
> in the CAT test and permanent failures of MBM and MBA tests on new platforms
> like Sierra Forest and Granite Rapids.
> 
> The MBM and MBA resctrl selftests both generate memory traffic and compare the
> memory bandwidth measurements between the iMC PMUs and MBM to determine pass or
> fail. Both these tests are failing on recent platforms like Sierra Forest and
> Granite Rapids that have two events that need to be read and combined
> for a total memory bandwidth count instead of the single event available on
> earlier platforms.
> 
> resctrl selftests prefer to obtain event details via sysfs instead of adding
> model specific details on which events to read. Enhancements to perf to expose
> the new event details are available since:
>   commit 6a8a48644c4b ("perf/x86/intel/uncore: Add per-scheduler IMC CAS count events")
> This series demonstrates use of the new sysfs interface to perf
> to obtain accurate iMC read memory bandwidth measurements.
> 
> An additional issue with all the tests is that these selftests are part
> performance tests and determine pass/fail on performance heuristics selected
> after running the tests on a variety of platforms. When new platforms
> arrive the previous heuristics may cause the tests to fail. These failures are
> not because of an issue with the resctrl subsystem the tests intend to test
> but because of the architectural changes in the new platforms.
> 
> Adapt the resctrl tests to not be as sensitive to architectural changes
> while adjusting the remaining heuristics to ensure tests pass on a variety
> of platforms. More details in individual patches.
> 
> Tested by running 100 iterations of all tests on Emerald Rapids, Granite
> Rapids, Sapphire Rapids, Ice Lake, Sierra Forest, and Broadwell.
> 
> Reinette Chatre (10):
>    selftests/resctrl: Improve accuracy of cache occupancy test
>    selftests/resctrl: Reduce interference from L2 occupancy during cache
>      occupancy test
>    selftests/resctrl: Do not store iMC counter value in counter config
>      structure
>    selftests/resctrl: Prepare for parsing multiple events per iMC
>    selftests/resctrl: Support multiple events associated with iMC
>    selftests/resctrl: Increase size of buffer used in MBM and MBA tests
>    selftests/resctrl: Raise threshold at which MBM and PMU values are
>      compared
>    selftests/resctrl: Remove requirement on cache miss rate
>    selftests/resctrl: Simplify perf usage in CAT test
>    selftests/resctrl: Reduce L2 impact on CAT test
> 

Let me know if this series is ready to go into Linux 7.1

thanks,
-- Shuah
