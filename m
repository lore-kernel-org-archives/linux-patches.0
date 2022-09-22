Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B687C
	for <patches@lists.linux.dev>; Thu, 22 Sep 2022 17:59:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663869545; x=1695405545;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=l49MJjVEZg6dHjjz5rjJy7LXGACd9SGftHKcNu/cLYY=;
  b=HNc2yM/R8Zc5/7w2ULUccoOeukAus6NNac3q8YXVyABqReESJ/5JX0Pv
   zV6/T5oNaHm2fhZLMEvAqRc7lz2g9rujUmVQLSHO6W0w/PqARUz+4Awbs
   OOpBCeiOXJoCUCgjwvTyLWoLQp/DfY8dLWGOC7cCtIEuhZuH0GLbGhjWa
   5mWxMi94BgIC152GDn58w0uPMw8eURY0BXIaKiWAS83ALle/H8kf53Z+R
   e2iNz6DdR+OPo2kgQ57QwIGHZH1U4HTyhoZ+pREPvVEv1FFaBG4IBzgp+
   jOdzBDEizj4QmxQNtShnZ6jC3pwtPMNtcvcbbfKvlAl2IcKgr2nnnK/gH
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10478"; a="280103577"
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="280103577"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 10:59:04 -0700
X-IronPort-AV: E=Sophos;i="5.93,337,1654585200"; 
   d="scan'208";a="688395874"
Received: from icostanz-mobl1.amr.corp.intel.com (HELO [10.251.210.149]) ([10.251.210.149])
  by fmsmga004-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Sep 2022 10:59:01 -0700
Message-ID: <b0595977-7cf4-7261-d006-a43ce6b63e31@linux.intel.com>
Date: Thu, 22 Sep 2022 19:58:55 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Firefox/91.0 Thunderbird/91.11.0
Subject: Re: [PATCH -next] ASoC: Intel: sof_da7219_mx98360a: Access num_codecs
 through dai_link
Content-Language: en-US
To: Nathan Chancellor <nathan@kernel.org>,
 Cezary Rojewski <cezary.rojewski@intel.com>,
 Liam Girdwood <liam.r.girdwood@linux.intel.com>,
 Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
 Bard Liao <yung-chuan.liao@linux.intel.com>,
 Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
 Kai Vehmanen <kai.vehmanen@linux.intel.com>, Mark Brown <broonie@kernel.org>
Cc: Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
 alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
 patches@lists.linux.dev
References: <20220922153752.336193-1-nathan@kernel.org>
From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
In-Reply-To: <20220922153752.336193-1-nathan@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 9/22/22 17:37, Nathan Chancellor wrote:
> After commit 3989ade2d1e7 ("ASoC: soc.h: remove num_cpus/codecs"), the
> following build error occurs:
> 
>   sound/soc/intel/boards/sof_da7219_max98373.c:198:27: error: no member named 'num_codecs' in 'struct snd_soc_pcm_runtime'
>           for (j = 0; j < runtime->num_codecs; j++) {
>                           ~~~~~~~  ^
>   1 error generated.
> 
> This conversion was missed by the aforementioned change. Do it now to
> fix the build error.
> 
> Fixes: 3989ade2d1e7 ("ASoC: soc.h: remove num_cpus/codecs")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>

Acked-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

> ---
>  sound/soc/intel/boards/sof_da7219_max98373.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/sound/soc/intel/boards/sof_da7219_max98373.c b/sound/soc/intel/boards/sof_da7219_max98373.c
> index 34cf849a8344..e048e789e633 100644
> --- a/sound/soc/intel/boards/sof_da7219_max98373.c
> +++ b/sound/soc/intel/boards/sof_da7219_max98373.c
> @@ -195,7 +195,7 @@ static int ssp1_hw_params(struct snd_pcm_substream *substream,
>  	struct snd_soc_pcm_runtime *runtime = asoc_substream_to_rtd(substream);
>  	int ret, j;
>  
> -	for (j = 0; j < runtime->num_codecs; j++) {
> +	for (j = 0; j < runtime->dai_link->num_codecs; j++) {
>  		struct snd_soc_dai *codec_dai = asoc_rtd_to_codec(runtime, j);
>  
>  		if (!strcmp(codec_dai->component->name, MAXIM_DEV0_NAME)) {
> 
> base-commit: a921986f445ad611b441c8ee7749dc6dfc770481
