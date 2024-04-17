Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B704365BA8
	for <patches@lists.linux.dev>; Wed, 17 Apr 2024 08:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713340892; cv=none; b=ucQ3hA6kGQ3IHPIPm43fBJs9mwIprL4Za/nEMokaK2Ny+bJZffN2WIiNexRbdIvh5LAkg3/0NMaRyLi2L0QKAz5SFoqrnvpKxh+nHaMVznLCymImKYJ6nGMDfM0Re5eFuQNBPJbBncD3w2Srs32D1tYhMG6cH5Qgzilm0eOGasc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713340892; c=relaxed/simple;
	bh=+AHxkBxgK0JVVQSGYJS1zewwUaQq0VBfzWVYWCsdqJ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AFgeov30MJeS0b4qNI5UjKDLkKogW2E9bQ0y8LWTndIJ83eXXi83cU31JlCS5kjE47HutZC6eiSLHYsSyx9x6fHrna/Rs0Jvs90uNiLhEODdBLlWR5fl2cjVkn5rQE1WLfMn7alvvyyhVSjB5AFBxxP02jo53q/6Nrl2DQapXiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=mzMNYHiF; arc=none smtp.client-ip=198.175.65.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="mzMNYHiF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1713340889; x=1744876889;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+AHxkBxgK0JVVQSGYJS1zewwUaQq0VBfzWVYWCsdqJ0=;
  b=mzMNYHiFIB3UQWJPN3grGTiBRUcZaBshJGEpUNghduJHcpM79o2+8HrO
   W1Kp8Dw6K756ATSyTEsqweliioO5z8imzs0ZbBu7XPuYwBzHKBkK3M4rQ
   C70tZXZCSTSQRzi/6r/Z+GCpXxVmJzT/Bf75bQxTv42ZIqKCbVe/CYeJW
   OJTUfvHkKBWfIxZLLEPt8Oe+ex6/hYkA++t+xFh225+fISJxFJmcOUSEX
   CDCVvPZOxbjJlOxM3Etyfz8laiNKNZGMttu4hB6HUKR2jOrR7K33X4Mec
   slsgiQEKZsPA0tVw0IcGbpOGRxFCV5SfyeNXQqwksUTKFeBJN3XEItKf2
   g==;
X-CSE-ConnectionGUID: /DcMKm4ITkCF1jr4vMhuxA==
X-CSE-MsgGUID: lIgFifLqTn6e9zC6MKdmHQ==
X-IronPort-AV: E=McAfee;i="6600,9927,11046"; a="8645468"
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="8645468"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa112.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 01:01:29 -0700
X-CSE-ConnectionGUID: B+QfucwGScGx7lVtv3A5OA==
X-CSE-MsgGUID: Fe65QYkKT6Cu91ekTALwTQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.07,208,1708416000"; 
   d="scan'208";a="22619310"
Received: from aslawinx-mobl.ger.corp.intel.com (HELO [10.94.0.53]) ([10.94.0.53])
  by fmviesa007-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Apr 2024 01:01:23 -0700
Message-ID: <f75809bb-1594-4bcd-9362-5aee8df04375@linux.intel.com>
Date: Wed, 17 Apr 2024 10:01:21 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 71/74] x86/cpu/vfm: Update
 sound/soc/intel/avs/boards/es8336.c
Content-Language: en-US
To: Tony Luck <tony.luck@intel.com>, Jaroslav Kysela <perex@perex.cz>,
 Takashi Iwai <tiwai@suse.com>
Cc: Cezary Rojewski <cezary.rojewski@intel.com>,
 Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
 Liam Girdwood <liam.r.girdwood@linux.intel.com>,
 Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
 Bard Liao <yung-chuan.liao@linux.intel.com>,
 Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
 Kai Vehmanen <kai.vehmanen@linux.intel.com>, Mark Brown
 <broonie@kernel.org>, Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
 alsa-devel@alsa-project.org, linux-sound@vger.kernel.org,
 linux-kernel@vger.kernel.org, patches@lists.linux.dev
References: <20240416211941.9369-1-tony.luck@intel.com>
 <20240416212257.10009-1-tony.luck@intel.com>
From: =?UTF-8?Q?Amadeusz_S=C5=82awi=C5=84ski?=
 <amadeuszx.slawinski@linux.intel.com>
In-Reply-To: <20240416212257.10009-1-tony.luck@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/16/2024 11:22 PM, Tony Luck wrote:
> New CPU #defines encode vendor and family as well as model.
> 
> Signed-off-by: Tony Luck <tony.luck@intel.com>
> ---
>   sound/soc/intel/avs/boards/es8336.c | 7 ++++---
>   1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/sound/soc/intel/avs/boards/es8336.c b/sound/soc/intel/avs/boards/es8336.c
> index 5c90a6007577..6c86c581877e 100644
> --- a/sound/soc/intel/avs/boards/es8336.c
> +++ b/sound/soc/intel/avs/boards/es8336.c
> @@ -18,6 +18,7 @@
>   #include <sound/pcm_params.h>
>   #include <sound/soc.h>
>   #include <sound/soc-acpi.h>
> +#include <asm/cpu_device_id.h>
>   #include <asm/intel-family.h>
>   #include "../utils.h"
>   
> @@ -153,9 +154,9 @@ static int avs_es8336_hw_params(struct snd_pcm_substream *substream,
>   	int clk_freq;
>   	int ret;
>   
> -	switch (boot_cpu_data.x86_model) {
> -	case INTEL_FAM6_KABYLAKE_L:
> -	case INTEL_FAM6_KABYLAKE:
> +	switch (boot_cpu_data.x86_vfm) {
> +	case INTEL_KABYLAKE_L:
> +	case INTEL_KABYLAKE:
>   		clk_freq = 24000000;
>   		break;
>   	default:

Any chance we could adjust topic to follow subsystem rules?
Something like:
ASoC: Intel: avs: boards: Update defines used in es8336
or something like that?
