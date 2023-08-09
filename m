Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D688C24505;
	Wed,  9 Aug 2023 18:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1691606480; x=1723142480;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Tjc+ZL8zr1dEpEbee1DdKAwTTtNC80suij9zROizXTk=;
  b=D6E/piq7NENW453bIQdV4gQbfGn9KCp32/TMD30rC4OjE51tM+ZfdMNd
   L4rCjdPWVH7vDzwwF8huof90FxSFWfjRYlnBqV6lt6FjGMNYKIK2CbDpX
   UNOIM+RqeIh3tPgGxQZ4W8TTNfw81zX+TEoHQEkVrlA/RhIF0I8aobOqf
   KJ6Z12Drta4dHLmIxjvbgMiA7l5wfLjMlNJTjR/KsO5FJpj1pK2reIoY+
   6vZmz9Ri1sn5+cxhcuouYPzz3Xg0OxI61H05vhNymDLmJx0ZKKRukjLaP
   c6qlwc+PlhSQoxr82RdpZmaUrRiDFwtLnlvv+h15TR4PXXxjhVE3O9PWq
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="374915993"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="374915993"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 11:41:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10797"; a="978511742"
X-IronPort-AV: E=Sophos;i="6.01,159,1684825200"; 
   d="scan'208";a="978511742"
Received: from jcaminer-mobl.amr.corp.intel.com (HELO [10.212.58.36]) ([10.212.58.36])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2023 11:41:18 -0700
Message-ID: <8eed2099-2853-df8d-92db-921d0702f512@linux.intel.com>
Date: Wed, 9 Aug 2023 13:41:18 -0500
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Firefox/102.0 Thunderbird/102.13.0
Subject: Re: [PATCH] ASoC: SOF: Intel: Initialize chip in
 hda_sdw_check_wakeen_irq()
Content-Language: en-US
To: Nathan Chancellor <nathan@kernel.org>, broonie@kernel.org,
 lgirdwood@gmail.com, peter.ujfalusi@linux.intel.com,
 yung-chuan.liao@linux.intel.com, ranjani.sridharan@linux.intel.com,
 daniel.baluta@nxp.com
Cc: kai.vehmanen@linux.intel.com, ndesaulniers@google.com, trix@redhat.com,
 rander.wang@intel.com, sound-open-firmware@alsa-project.org,
 alsa-devel@alsa-project.org, llvm@lists.linux.dev, patches@lists.linux.dev
References: <20230809-intel-hda-missing-chip-init-v1-1-61557ca6fa8a@kernel.org>
From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <20230809-intel-hda-missing-chip-init-v1-1-61557ca6fa8a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 8/9/23 13:12, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR):
> 
>   sound/soc/sof/intel/hda.c:423:6: error: variable 'chip' is uninitialized when used here [-Werror,-Wuninitialized]
>     423 |         if (chip && chip->check_sdw_wakeen_irq)
>         |             ^~~~
>   sound/soc/sof/intel/hda.c:418:39: note: initialize the variable 'chip' to silence this warning
>     418 |         const struct sof_intel_dsp_desc *chip;
>         |                                              ^
>         |                                               = NULL
>   1 error generated.
> 
> Add the missing initialization, following the pattern of the other irq
> functions.
> 
> Fixes: 9362ab78f175 ("ASoC: SOF: Intel: add abstraction for SoundWire wake-ups")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Indeed, thanks Nathan for flagging this obvious mistake. I must have
done something wrong when extracting the patches.

Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

That said, we DO compile with clang and there was no warning
https://github.com/thesofproject/linux/actions/runs/5542372669/job/15010818307

Is this dependent on a specific version of clang? I'd like to make sure
our tools and tests are updated.
