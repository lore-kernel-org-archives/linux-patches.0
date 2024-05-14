Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E585763F2
	for <patches@lists.linux.dev>; Tue, 14 May 2024 12:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715691289; cv=none; b=AG5ACRJAozSqYvRQsZanEibZYVGSRvIWtHTb2RMMkAj/gWHjyPFs7HecJZwgEY6ZQF/QVhy4WaQCtAHOiB5PQ46JpuhSlePvqqDZCy8KHVPLHzgkYWGxr6bH3LNxE2RoHMkt8p9NHM+i8ufROhO77lPiSsaEQbnDwxZXwWy3C3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715691289; c=relaxed/simple;
	bh=gyRPJJ0Bqup/vojSEgiOY1KSmt5AEBtY2pPjuk1pS0s=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=H0afNfR3B8MTAH2G6DDN1xCpvzl8wRec9OHRqjjwu0Q7chwhccZAcm482nWlOpdTL1djt2CHhY5jdiLLSTHtU8muTNuDSahddy2G31QFpPVb4y8a3B6X9saNazT5kflR/y0SJ0okOXnxbg7Z6mGm8sbq39wqaaVsywLMJd+HTT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=T9y/X3qt; arc=none smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="T9y/X3qt"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-41fc53252ceso39237205e9.0
        for <patches@lists.linux.dev>; Tue, 14 May 2024 05:54:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1715691285; x=1716296085; darn=lists.linux.dev;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=0+cTGSpitrxo6tJr/u92LI+13bM0ViiSMLK2haL1u6M=;
        b=T9y/X3qtgfFw7lR1iqIojFwYhKboos3l3YkT8lUIwQqIYzId2qdcebe/JLjJvAN0S3
         O427K4w0SahEZI/rkLbj6VMvxYaCKYU/P+NFCpvMdr06pD163y5Ixd+ajfDjxFpBXH2c
         gBC/9HY/mg11QssJ+nvr97B5fyGjg3uiQlSHvvuRqgVEvx2NRRjaZhhrQ+MO6newNnO6
         xr7txDA1Wt6GGZku/eCsK6Y3yfCkuADvQ7uBaZaAe1tTD9+WW2SLC1i/0/Dr3KFvh1Cb
         2Teg8dqd9LSXT/z+JoeTY0mM2//QpLKNbYKIEbDBbDv2mTtbHJfuoN4XTDlvnUVaDrP4
         vhCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715691285; x=1716296085;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0+cTGSpitrxo6tJr/u92LI+13bM0ViiSMLK2haL1u6M=;
        b=Sf1ixg61KRCJMBODxj1cIwRBpGLqhd2rDjRu9aIOOrLdR6eYxaPGMqYqJBezYDE7AZ
         8AQ6H/duFL5iYxDcsKGvMFbn3Y8n+Oyd8gsxpQl5B52Nc/1AiSV9vR75aSjwh85ztkyH
         IxbiS8ja2QLqhMvm1AurZCrKdPoiNIveG+q/mXg9D2mb6233xME8KaYRyPernxIqS8IO
         mZYlY53U087WJzVMuiCMWsQ8gxJSaZcIt92ddWP6xbtRswIifDHWV13dMH0HMtR8/HvG
         kQRMERcn4RRg0XneHT4OvReXpRZdlRZpC6bwCJl4fXCf4j0MQiiCIOHcBBGZE3Ul4vZM
         /VuQ==
X-Forwarded-Encrypted: i=1; AJvYcCWpKjxltqQEnu5lFC2KGqjSIwGu+zHnUMPpTZXlw0VavTb7cVkM+sE/kkz9x5nJZ3/aXNsYgKkNFb5/pFNGuPBopFzxgr3qXQ==
X-Gm-Message-State: AOJu0Yx4Z+IRSHOyAYy+kDIuExfl03mOc7iGMRzCy455HzBfVmRLfnR4
	qlfF1h6yz0qBZQiic0eR94vfgy+XfTvZkxjPpIgIF9dHXCexOc/JoLuUu3xBP8Y=
X-Google-Smtp-Source: AGHT+IEpKZ7BdUxo7eFvi5dr4pREANLXDzvgae6ztSZBfYbsmUCMqR86IPgDWtDdgcEzvbYQJ1xhiw==
X-Received: by 2002:a05:600c:4ba2:b0:41a:9fc2:a6b1 with SMTP id 5b1f17b1804b1-41feaa4352amr94789015e9.22.1715691284859;
        Tue, 14 May 2024 05:54:44 -0700 (PDT)
Received: from localhost ([2a01:e0a:3c5:5fb1:3f47:f219:de13:38a7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-41f88111033sm229322815e9.34.2024.05.14.05.54.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 05:54:44 -0700 (PDT)
References: <20240514101006.678521560@linuxfoundation.org>
 <20240514101010.464612719@linuxfoundation.org>
User-agent: mu4e 1.10.8; emacs 29.2
From: Jerome Brunet <jbrunet@baylibre.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, Dmitry Shmidt
 <dimitrysh@google.com>, Neil Armstrong <narmstrong@baylibre.com>, Jerome
 Brunet <jbrunet@baylibre.com>, Mark Brown <broonie@kernel.org>, Sasha
 Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 100/168] ASoC: meson: axg-card: Fix nonatomic links
Date: Tue, 14 May 2024 14:26:02 +0200
In-reply-to: <20240514101010.464612719@linuxfoundation.org>
Message-ID: <1j34qkzh7w.fsf@starbuckisacylon.baylibre.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


On Tue 14 May 2024 at 12:19, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> 5.15-stable review patch.  If anyone has any objections, please let me know.
>

Patch #100 and #101 should not be applied on v5.15.

A bit of history:
* 3y ago patches #44 and #45 have been applied to fix a problem in AML
  audio, but it caused a regression.
* No solution was found at the time, so the patches were reverted by
  change #100 and #101
* Recently I came up with change #43 which fixes the regression from 3y
  ago, so the fixes for original problem could be applied again (with a
  different sha1 of course)

The situation was detailed in the cover letter of the related series:
https://lore.kernel.org/linux-amlogic/20240426152946.3078805-1-jbrunet@baylibre.com

From what I can see the backport is fine on 6.8, 6.6 and 6.1.
Things starts to be problematic on 5.15.

In general, if upstream commit b11d26660dff is backported, it is fine to
apply upstream commits:
 * dcba52ace7d4 ("ASoC: meson: axg-card: make links nonatomic")
 * f949ed458ad1 ("ASoC: meson: axg-tdm-interface: manage formatters in trigger")
And the following commits (which are reverts for the 2 above) should not be applied:
 * 0c9b152c72e5 ("ASoC: meson: axg-card: Fix nonatomic links")
 * c26830b6c5c5 ("ASoC: meson: axg-tdm-interface: Fix formatters in trigger"")

If b11d26660dff is not backported, the 2 first change should be
backported, or reverted if they have already been.

* v5.15: just dropping change #100 and #101 should be fine
* v5.10: I suppose this is where the backport starts to be problematic
         Best would be to drop #31, #32, #73 and #74 for now
* v5.4: Same drop #26, #27, #60 and #61
* v4.19: drop #17 and #44

Regards
Jerome

> ------------------
>
> From: Neil Armstrong <narmstrong@baylibre.com>
>
> [ Upstream commit 0c9b152c72e53016e96593bdbb8cffe2176694b9 ]
>
> This commit e138233e56e9829e65b6293887063a1a3ccb2d68 causes the
> following system crash when using audio on G12A/G12B & SM1 systems:
>
>  BUG: sleeping function called from invalid context at kernel/locking/mutex.c:282
>   in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 0, name: swapper/0
>  preempt_count: 10001, expected: 0
>  RCU nest depth: 0, expected: 0
>  Preemption disabled at:
>  schedule_preempt_disabled+0x20/0x2c
>
>  mutex_lock+0x24/0x60
>  _snd_pcm_stream_lock_irqsave+0x20/0x3c
>  snd_pcm_period_elapsed+0x24/0xa4
>  axg_fifo_pcm_irq_block+0x64/0xdc
>  __handle_irq_event_percpu+0x104/0x264
>  handle_irq_event+0x48/0xb4
>  ...
>  start_kernel+0x3f0/0x484
>  __primary_switched+0xc0/0xc8
>
> Revert this commit until the crash is fixed.
>
> Fixes: e138233e56e9829e65b6 ("ASoC: meson: axg-card: make links nonatomic")
> Reported-by: Dmitry Shmidt <dimitrysh@google.com>
> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
> Acked-by: Jerome Brunet <jbrunet@baylibre.com>
> Link: https://lore.kernel.org/r/20220421155725.2589089-2-narmstrong@baylibre.com
> Signed-off-by: Mark Brown <broonie@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  sound/soc/meson/axg-card.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/sound/soc/meson/axg-card.c b/sound/soc/meson/axg-card.c
> index cbbaa55d92a66..2b77010c2c5ce 100644
> --- a/sound/soc/meson/axg-card.c
> +++ b/sound/soc/meson/axg-card.c
> @@ -320,7 +320,6 @@ static int axg_card_add_link(struct snd_soc_card *card, struct device_node *np,
>  
>  	dai_link->cpus = cpu;
>  	dai_link->num_cpus = 1;
> -	dai_link->nonatomic = true;
>  
>  	ret = meson_card_parse_dai(card, np, &dai_link->cpus->of_node,
>  				   &dai_link->cpus->dai_name);


-- 
Jerome
