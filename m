Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F5F34751D
	for <patches@lists.linux.dev>; Wed, 20 May 2026 11:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779277248; cv=none; b=mP79YGdPszUTGBDHuCaVDI9CQaquPzHRzUGsjDPGbp4IiqHp8qwk/LxmvjlXkKkva27CdhDHpePiFf8c/RPEu+kdar1pl15wLjW2LtwXdZozT58CZsgFh+aEf/UtDaOs0K/lOMjVZ2dSHUk2mett7l4J7pKWqcWGxjab0DCT/kc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779277248; c=relaxed/simple;
	bh=JVqcVqCzRl9FvRzvlut3UkWVQD+LeFl5vwBVEalGw3c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BwZllMWmzrIlYF4OA1yeBH31ufAgJA3KiV2pXSLqqVKFXO/iQUDmGdArFmaZwia8Wt9/71DwL1JdCzEutRgoabKAo7j9Hv550jqCESmurWPxqJ3/x7WanOTMtbyzIFhnOGhfsjkJjg+Vnasa1ogyFI49A3/ovMrDsdFxXaqFzno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=F7IRzdmA; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="F7IRzdmA"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-4042fe53946so1807344fac.3
        for <patches@lists.linux.dev>; Wed, 20 May 2026 04:40:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779277245; x=1779882045; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZJL6AQSMLl9+u0hYFPLf47FKOchRWlEKMHwFoxDMDoA=;
        b=F7IRzdmA+IjncOSIsEBiYXA1eWSXYQE0ga3XvkscueG87TQvwzOLidBTcGrsKBvqzB
         kG86R9ZKX5aKcCao178Imv/gQbk0ZUSbN5QOfJ/5LD3uJ9CsYZLD917ToZJj6s3fEFzQ
         N3geCIpx3EGxXOR7PiFADHt3iR4IRzUapQb7ydtVtW2ZNd7VTokmFY07eDUZFAlbbkEq
         XTW+9Z35rUmxVPRMYyjA0csXe3EP5SkAVFWk0Facsa+RpR/qlOKQ3Qxte8iwy7k6LxIY
         MZJjluoQfn2k25tG7Vvut48nsUFhgxAMcki9IBzvKKZAvf/mkyRGr6wWwTuB+jXPrGem
         h8uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779277245; x=1779882045;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZJL6AQSMLl9+u0hYFPLf47FKOchRWlEKMHwFoxDMDoA=;
        b=Thactj5xbAkcq2xhftmaj64R07CZi9r3mwv+Ys2VXn28gN0adCKU7+Z4Ih/Z+vcjOn
         2sihoxUeviSWrgE/RIsXtR29i0CU8ydep1T1rNjCFQzZ6U2irQJPIddVqntT1S8T+ATG
         DUwdYuvu3Nry5DWmImkBUXF8rr3xzSS8cpAJYhH5y0ZxBacckJJaGhwDygckd3PVHk0q
         bBatPMQYNcliYgQl31T1m/m0Ll2jTFP9WsVyaH9d2vXfI7r6Es0zVICYNs/24KiHJ/CI
         st/9bntaWLjFV2tzo02sqx304eoPzz8LOYV/LZSwmso8nngg3DWFNwP4HHrDSoTOTJjQ
         MKMQ==
X-Forwarded-Encrypted: i=1; AFNElJ/VXM4HA4czgmRaHxs7L3yIhzk3+jNxjeF3NLhCvzpGtusJugxXXbpuIwIvL2RFRq3DgHxtPviR@lists.linux.dev
X-Gm-Message-State: AOJu0YzZOzygQcv724vBZ1UbF4gijDSdyX40V4OpYSaNFjLhCSGBDITi
	CuK9WhSATWHcC/DT/GiOS+6EvPhYkYnS7Jx8myuxcdVUqWHVaGXkUTRN+buknIRLqRA=
X-Gm-Gg: Acq92OGn/rVmDpLIZ1DetnmqMemB9dkTDsbedBOeRvahYw8jYQKh2v5QBbZNYgrkCO1
	3ALFphSl4e7ak97yhyFSqf8Tm7Dy+TtVnGPiE07o7IKhNcp3V0PViTxzkxiUZCYNl8CCTtfqJd1
	F+/M4cqP+VpH7X12whjcje/0tRxKqsPMexqmH8eyAvzaMwWaQYFvSXQKNNYYKbBR88hAEuAIFjy
	n05uG5jHi8uAiVMOyowk8nqjkRoZYL1VuG+G/DcxRJe1cNx8Lk99uuRjtI/hgsAGb4dw4mVMeJP
	gwR8UfJGFBAHCd/tSVjbjEA5eFQrdKVKXFX6rLCtYY0JDEzU8c+QDDPokZ2nz3k3X00dou95pyt
	+tidUFfHpSwFKQsr8xX91k21QNBg4akG5ydbbz/96dKOdonGslL2mmmVzrvydxNhrzN8zMl6b/K
	pF9q/qE5I/5VeK8vkGt5cO0+WUN2kYUuAMWcKZXCw4IblyVXL5knIXaxJX3zcHx3ECNVqh10haH
	A/yiwwGfw==
X-Received: by 2002:a05:6870:c443:10b0:43a:d1ec:55d2 with SMTP id 586e51a60fabf-43ad1ecb9c3mr3693924fac.36.1779277244904;
        Wed, 20 May 2026 04:40:44 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43a957639b2sm9692661fac.14.2026.05.20.04.40.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 04:40:42 -0700 (PDT)
Message-ID: <5a50c3f5-a5ef-4b2b-821c-5858d8b1ac13@kernel.dk>
Date: Wed, 20 May 2026 05:40:40 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH AUTOSEL 7.0] io_uring/wait: honour caller's time namespace
 for IORING_ENTER_ABS_TIMER
To: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev,
 stable@vger.kernel.org
Cc: Maoyi Xie <maoyixie.tju@gmail.com>,
 Pavel Begunkov <asml.silence@gmail.com>, Maoyi Xie <maoyi.xie@ntu.edu.sg>,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260520111944.3424570-1-sashal@kernel.org>
 <20260520111944.3424570-26-sashal@kernel.org>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20260520111944.3424570-26-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 5/20/26 5:18 AM, Sasha Levin wrote:
> From: Maoyi Xie <maoyixie.tju@gmail.com>
> 
> [ Upstream commit 45d2b37a37ab98484693533496395c610a2cab96 ]
> 
> io_uring_enter() with IORING_ENTER_ABS_TIMER takes an absolute
> timespec from the caller via ext_arg->ts. It arms an ABS mode
> hrtimer in __io_cqring_wait_schedule(). The conversion path in
> io_uring/wait.c parses ext_arg->ts inline rather than going
> through io_parse_user_time(). It therefore does not pick up the
> time namespace conversion added by the previous patch.

Once again - If you auto-pick this one, please also do the other one in
the series, 9cc6bac1bebf8310d2950d1411a91479e86d69a1. Makes no sense to
do just one of them.

-- 
Jens Axboe
