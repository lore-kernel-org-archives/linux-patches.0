Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BADD813FD78
	for <patches@lists.linux.dev>; Tue, 14 May 2024 13:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715691655; cv=none; b=cXVm9/6AQuuoGa5u8cIRjaBnOeMjsppqU19KjVgh1I7aOqguIvGgfZ1tS7JFQs9ggHefDkjcOeUAUciilCKa4wpuj2g2X9JL/z2+XD+Y12aeQB6lN6KhBPRyqQ7X4CSCJdRCfA7+qf9D0yhjenMFX6UeOHUnaJeTiQHdrLTdJ/g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715691655; c=relaxed/simple;
	bh=d8ShiMrXR3emIyflcfbffRIzJLRaSStiK2f67HCN7WU=;
	h=References:From:To:Cc:Subject:Date:In-reply-to:Message-ID:
	 MIME-Version:Content-Type; b=SJXeaxsNaAaK1Hblyzgh8wQR1+apSI0Fs+zB6+w/D3QOBB/JSxZun/ZXsTZ+xbyO3sa6pkfOW/VdWoLXkiRUFUiobYoD961HgwzDvQPjh9fx0VHk1lClLqEs7oNMKN58wgbXzgUUO5WxyXB8VGui3MZsFzXaUkHv8BHl8b9T2Zs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com; spf=pass smtp.mailfrom=baylibre.com; dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b=yjJbfuVJ; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=baylibre.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=baylibre.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=baylibre-com.20230601.gappssmtp.com header.i=@baylibre-com.20230601.gappssmtp.com header.b="yjJbfuVJ"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-420180b58c3so14186135e9.2
        for <patches@lists.linux.dev>; Tue, 14 May 2024 06:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=baylibre-com.20230601.gappssmtp.com; s=20230601; t=1715691652; x=1716296452; darn=lists.linux.dev;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:from:to:cc:subject:date:message-id:reply-to;
        bh=DsS116Yyx1MUvHVpDg7nSKFadAoyOcppPeidrMbDBz0=;
        b=yjJbfuVJWeqmiPzOZaJZFIi3Oly7pm0bHS7c/eQopytdIP7QKWGsj8T4A6wH7j+/Sc
         9td4TmKFfP9vqx8cC4WHxJ7Ae35moZoJqeGAJG3YJVM6Y7JdbJN45FYBU6VCioRyDzc4
         GqRdMSMeZvIuHBdKXL5weGfA+lDPio18VG5U4+r0CQ8Erwpx5sdBaobjqtGH1NuUfJEU
         HWuaWx0GHtnB0IhcEIK71tH0WJFc02MFFFktTI/sHYaiPxluCVhhjNPtV+rNBIZ/zraA
         M7zYA0nD5WMootI0UYJIFvg9/Wtg7zuYfVCvFLeosvk4BKYNtD2FXXJmvAoWpxzi6vr7
         dZug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715691652; x=1716296452;
        h=mime-version:message-id:in-reply-to:date:subject:cc:to:from
         :user-agent:references:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DsS116Yyx1MUvHVpDg7nSKFadAoyOcppPeidrMbDBz0=;
        b=vcaIuTCyxYBnjPzkEoaDRJ5fpJdd2wq0MwRaPcKJrCRkN0+JTJtQnSA3jJStIZECmh
         y8eVPAbmcwPicxxCFhYlFjaQ5ytOtJ7Qkam3I/VMr/8/TVVUOHCRpHG4g6EvqpahEYMO
         TvsftGsZko/n8hb4dLhoC1F+uPFWm/CJRm5e5gvqiOUzAmUTgikFszzbG/E+nbJ/Gg1G
         IiuVC24g8Zzqs3EOC6ssp+kMIQgGXhWuma6wfXURrpeiFh3481ZUilWiPw8H7LisLAko
         VVcKpovI4YuQ+ZT7MY2bayYr8YWIyVLg5pvCnXn2Rutf8RqkSKTLTHlvewIiGVp47NIy
         XuTg==
X-Forwarded-Encrypted: i=1; AJvYcCX+T22gtvjNH0nIrjcud8JAzAmXigxF/gepqS7QX1WVTqC/CAZwVFRNbA0icksp0HKNuW2LHUKY+n7FzGi186/0R/OKEtMVhg==
X-Gm-Message-State: AOJu0YwKJUjd+CqKLJG1qiME8megbElAeyM3z/mfuthxR8wWH6jhlTT/
	Nxt4EYSRu/0wRMjHPPGMZmwlxSvIdmIbiPbmp6oWS1XuQwpti1Rxf8Qnnhd57s1Cc4M9lhJWIm6
	U
X-Google-Smtp-Source: AGHT+IF/kooVLPziGy/T8RjYW2nok5uQj3lsw4aJLqNMyq5n94FloOztr3X9LnFp6kooH/E3rnpuGg==
X-Received: by 2002:a05:600c:1f83:b0:41a:b961:9495 with SMTP id 5b1f17b1804b1-41feac49164mr93979525e9.25.1715691652011;
        Tue, 14 May 2024 06:00:52 -0700 (PDT)
Received: from localhost ([2a01:e0a:3c5:5fb1:3f47:f219:de13:38a7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-42016b88f99sm67585325e9.10.2024.05.14.06.00.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 May 2024 06:00:51 -0700 (PDT)
References: <20240514101006.678521560@linuxfoundation.org>
 <20240514101010.464612719@linuxfoundation.org>
 <1j34qkzh7w.fsf@starbuckisacylon.baylibre.com>
User-agent: mu4e 1.10.8; emacs 29.2
From: Jerome Brunet <jbrunet@baylibre.com>
To: Jerome Brunet <jbrunet@baylibre.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
 patches@lists.linux.dev, Dmitry Shmidt <dimitrysh@google.com>, Neil
 Armstrong <narmstrong@baylibre.com>, Mark Brown <broonie@kernel.org>,
 Sasha  Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.15 100/168] ASoC: meson: axg-card: Fix nonatomic links
Date: Tue, 14 May 2024 14:59:52 +0200
In-reply-to: <1j34qkzh7w.fsf@starbuckisacylon.baylibre.com>
Message-ID: <1jy18cy2d9.fsf@starbuckisacylon.baylibre.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain


On Tue 14 May 2024 at 14:26, Jerome Brunet <jbrunet@baylibre.com> wrote:

> On Tue 14 May 2024 at 12:19, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
>> 5.15-stable review patch.  If anyone has any objections, please let me know.
>>
>
> Patch #100 and #101 should not be applied on v5.15.
>
> A bit of history:
> * 3y ago patches #44 and #45 have been applied to fix a problem in AML
>   audio, but it caused a regression.
> * No solution was found at the time, so the patches were reverted by
>   change #100 and #101
> * Recently I came up with change #43 which fixes the regression from 3y
>   ago, so the fixes for original problem could be applied again (with a
>   different sha1 of course)
>
> The situation was detailed in the cover letter of the related series:
> https://lore.kernel.org/linux-amlogic/20240426152946.3078805-1-jbrunet@baylibre.com
>
> From what I can see the backport is fine on 6.8, 6.6 and 6.1.
> Things starts to be problematic on 5.15.
>
> In general, if upstream commit b11d26660dff is backported, it is fine to
> apply upstream commits:
>  * dcba52ace7d4 ("ASoC: meson: axg-card: make links nonatomic")
>  * f949ed458ad1 ("ASoC: meson: axg-tdm-interface: manage formatters in trigger")
> And the following commits (which are reverts for the 2 above) should not be applied:
>  * 0c9b152c72e5 ("ASoC: meson: axg-card: Fix nonatomic links")
>  * c26830b6c5c5 ("ASoC: meson: axg-tdm-interface: Fix formatters in trigger"")
>
> If b11d26660dff is not backported, the 2 first change should be
> backported, or reverted if they have already been.

If b11d26660dff is not backported, the 2 first change should *NOT* be
backported, or reverted if they have already been.

Sorry for the confusing typo

>
> * v5.15: just dropping change #100 and #101 should be fine
> * v5.10: I suppose this is where the backport starts to be problematic
>          Best would be to drop #31, #32, #73 and #74 for now
> * v5.4: Same drop #26, #27, #60 and #61
> * v4.19: drop #17 and #44
>
> Regards
> Jerome
>
>> ------------------
>>
>> From: Neil Armstrong <narmstrong@baylibre.com>
>>
>> [ Upstream commit 0c9b152c72e53016e96593bdbb8cffe2176694b9 ]
>>
>> This commit e138233e56e9829e65b6293887063a1a3ccb2d68 causes the
>> following system crash when using audio on G12A/G12B & SM1 systems:
>>
>>  BUG: sleeping function called from invalid context at kernel/locking/mutex.c:282
>>   in_atomic(): 1, irqs_disabled(): 128, non_block: 0, pid: 0, name: swapper/0
>>  preempt_count: 10001, expected: 0
>>  RCU nest depth: 0, expected: 0
>>  Preemption disabled at:
>>  schedule_preempt_disabled+0x20/0x2c
>>
>>  mutex_lock+0x24/0x60
>>  _snd_pcm_stream_lock_irqsave+0x20/0x3c
>>  snd_pcm_period_elapsed+0x24/0xa4
>>  axg_fifo_pcm_irq_block+0x64/0xdc
>>  __handle_irq_event_percpu+0x104/0x264
>>  handle_irq_event+0x48/0xb4
>>  ...
>>  start_kernel+0x3f0/0x484
>>  __primary_switched+0xc0/0xc8
>>
>> Revert this commit until the crash is fixed.
>>
>> Fixes: e138233e56e9829e65b6 ("ASoC: meson: axg-card: make links nonatomic")
>> Reported-by: Dmitry Shmidt <dimitrysh@google.com>
>> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
>> Acked-by: Jerome Brunet <jbrunet@baylibre.com>
>> Link: https://lore.kernel.org/r/20220421155725.2589089-2-narmstrong@baylibre.com
>> Signed-off-by: Mark Brown <broonie@kernel.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  sound/soc/meson/axg-card.c | 1 -
>>  1 file changed, 1 deletion(-)
>>
>> diff --git a/sound/soc/meson/axg-card.c b/sound/soc/meson/axg-card.c
>> index cbbaa55d92a66..2b77010c2c5ce 100644
>> --- a/sound/soc/meson/axg-card.c
>> +++ b/sound/soc/meson/axg-card.c
>> @@ -320,7 +320,6 @@ static int axg_card_add_link(struct snd_soc_card *card, struct device_node *np,
>>  
>>  	dai_link->cpus = cpu;
>>  	dai_link->num_cpus = 1;
>> -	dai_link->nonatomic = true;
>>  
>>  	ret = meson_card_parse_dai(card, np, &dai_link->cpus->of_node,
>>  				   &dai_link->cpus->dai_name);


-- 
Jerome
