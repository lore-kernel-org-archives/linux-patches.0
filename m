Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BC63ACEF7
	for <patches@lists.linux.dev>; Tue,  3 Feb 2026 15:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770131751; cv=none; b=TJqHACB2RBnLNwF86X3ckz1DVMsuvVlPGXseVljWq1bP/9MjPr2UlotgKsx6joIwpZOP8CBe9wPMZ5Xs5SbmOLh+AE8F/iI1mzuUBHptv7kwSfcpeYHlHlJdulR3FxLX0RzCKqFeFnUYADBItmxhXFkjT3zyBr0Dntnmb3gPSD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770131751; c=relaxed/simple;
	bh=1Fi5bzZAG+1cbdUfewtQaIkBwyxLJrJtRKSaoVU2o4s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 In-Reply-To:Content-Type:Content-Disposition; b=si+c09pV/aYsf69vR5NPZpfzI/IyN7xBqaCv4yCDtYaFYeyNSgw3TEtVdfI1aKnxsC72cofok9rJFg7oJV/rq17RO2/VIfcqhtCsdP2TSwXAF1yX+VlnNgGg1C5+lu831NwmwF9XMlY2xLf1y4MneZjJBQDTvmsf4Log5v7J0qQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WEMDz+eK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WEMDz+eK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1770131746;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3GPmx/o94nzL4/jmMhbm+4apVlFi7+ZwJQ/KS0Eum2k=;
	b=WEMDz+eKoMRmwG20Is6Fc8YOjoJC28dRPFwyDxQptw0X8WL8qMnhZTIz/HucxMdcqPXsK+
	RwW+2N+QXNLfEhNKQaZtjA/4jGXZYGh3j+wVmpROolbf6a2xdRThzDb6T42k4RIpD2+OmK
	WgMfkxe2nOxZAN39OcaLnIVCjNxp17s=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-74-ZgEtq0XVNhGwxESGvF0w6Q-1; Tue, 03 Feb 2026 10:15:44 -0500
X-MC-Unique: ZgEtq0XVNhGwxESGvF0w6Q-1
X-Mimecast-MFC-AGG-ID: ZgEtq0XVNhGwxESGvF0w6Q_1770131744
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-5033b4d599eso201288171cf.2
        for <patches@lists.linux.dev>; Tue, 03 Feb 2026 07:15:44 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770131744; x=1770736544;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3GPmx/o94nzL4/jmMhbm+4apVlFi7+ZwJQ/KS0Eum2k=;
        b=soBhVKmvbgkNgZAyH+408+oTuJtx5j9tbvyLreyStihwJSKmQV+Ab9rPRnyh1GGiL/
         HIhxl+peAAxIbXXvyI1AuHAAOHwYJm55xeawnCvQR2SsxWwVv4IQvaeDJZMpIjvN59ZS
         NsLFFu+w8ubpEEDO2k2ZZg/WKaUd2tQpy/ipW+zGHgXxRrwgKQxuaRLEU5ignSlqZkoO
         Z+CViHlTI3VR4ERkGJNskoRYN36rc5wNRQWLrirmh9+f6w15ZAyizQbDaIEOzWHEausP
         8O5afqMYMAHsYrWjujqxmZe7uOqU24JVQwPf7diU9AsDv8k5bmGRihIagc97zRYQ1WU/
         h/Nw==
X-Forwarded-Encrypted: i=1; AJvYcCUx71nadDfnNr+F3ehQanY62E3Bpq2NIE+rM526Y/n4QUglXs415bM7+3oHvr2jK5QTVDMjim3J@lists.linux.dev
X-Gm-Message-State: AOJu0Yx2R+1BNXxGBto9P4nd1h7EyyTFCKLSLInYMHTzyJHxJ5zp+ufS
	uNow6Qj1EBmijmN52VguJURA1IqaQST5+ZGkyL04gjXacTGtQhkdjxhvDnHDjg0vtqN+hFfyA7I
	s5F5K66JKkE1NV4r1M17AEXoFMu6rIezV5VFxCtA9vQZ4c/sCros7Sk3EUEc=
X-Gm-Gg: AZuq6aIuGG19+y3X/K44T+lcPjMdZFiPJN6z+6CDjOpyKRB8bk+kyFz10Gs0XybdzdY
	WT8482z8J/Ct3q19GJyigR1GT2YOVkjNsdvn0s7HsXVwrOGjbmi+XBLyeOhZk6h8+A6ggl9Twob
	ptTY4MchSNvzJ6DoLnXgKeR4MUkhlvtiIzhKjvQH/l2afT34zwwuAO0bM7C8HZRtIv/UIiIvbqI
	/5XJ/JiyFFybwaNNJNYxjr9GAdl2lKZblz7A2DAummglUAA6rWAybM/C1M2n9TKIsaa0xoV7tzv
	NuXp/ezYcdJpAs7OsKs02rctzWDLRUry/iTOxSSohFMOZFchXh1DKoiAbJa+YkORBerVxP2Jxv+
	4P2N9Kla4uexcRYef9282sDRGYFERK9HYk5+H80t4ub7c
X-Received: by 2002:ac8:7dd5:0:b0:4ff:c08a:52c4 with SMTP id d75a77b69052e-505d218ff4fmr206449961cf.18.1770131744167;
        Tue, 03 Feb 2026 07:15:44 -0800 (PST)
X-Received: by 2002:ac8:7dd5:0:b0:4ff:c08a:52c4 with SMTP id d75a77b69052e-505d218ff4fmr206449111cf.18.1770131743486;
        Tue, 03 Feb 2026 07:15:43 -0800 (PST)
Received: from redhat.com (c-73-183-52-120.hsd1.pa.comcast.net. [73.183.52.120])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5033a4de38esm129309391cf.27.2026.02.03.07.15.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 07:15:42 -0800 (PST)
Date: Tue, 3 Feb 2026 10:15:41 -0500
From: Brian Masney <bmasney@redhat.com>
To: Stephen Boyd <sboyd@kernel.org>
Cc: Michael Turquette <mturquette@baylibre.com>,
	linux-kernel@vger.kernel.org, linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Mark Brown <broonie@kernel.org>,
	Nicolas Frattaroli <nicolas.frattaroli@collabora.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>
Subject: Re: [PATCH] Revert "clk: Respect CLK_OPS_PARENT_ENABLE during recalc"
Message-ID: <aYIRHf1njCXmoswF@redhat.com>
References: <20260203002439.1223213-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
In-Reply-To: <20260203002439.1223213-1-sboyd@kernel.org>
User-Agent: Mutt/2.2.14 (2025-02-20)
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: WDakH4RddLz4x_aArL2w--XzAGSNAkE-8dcaKB97G1k_1770131744
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 02, 2026 at 04:24:38PM -0800, Stephen Boyd wrote:
> This reverts commit 669917676e93fca5ea3c66fc9539830312bec58e.
> It's been shown to cause problems on i.MX and STM32 platforms
> where the board doesn't boot. In one case, a clk with
> CLK_IS_CRITICAL and CLK_OPS_PARENT_ENABLE is being registered
> causing the parent to be enabled, the rate recalculated, and then
> the parent is disabled causing the critical clk being registered
> to stop clocking.
> 
> A fix for that would be to calculate the rate of the clk after
> enabling the critical clk itself, but that wouldn't fix another
> problem where a clk with CLK_OPS_PARENT_ENABLE is registered
> before the parent is registered. In this case the hardware access
> in the clk_ops::recalc_rate() function would fail if the parent
> is disabled.
> 
> There are even more problems exposed by this patch because it
> introduces logic that disables clks earlier in system boot than
> has existed previously. Historically we've not disabled clks
> until late init (clk_disable_unused) under the assumption that
> clks have been registered enough to have a consistent view of the
> clk tree. The clk_disable_unused logic doesn't work very well
> though, leading to quite a few devices booting with
> clk_ignore_unused on the kernel command line.
> 
> Long story short, disabling clks during clk registration is full
> of pitfalls. Revert this commit until a proper solution can be
> found.
> 
> Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
> Closes: https://lore.kernel.org/r/6239343.lOV4Wx5bFT@steina-w
> Reported-by: Mark Brown <broonie@kernel.org>
> Closes: https://lore.kernel.org/r/036da7ce-6487-4a6e-9b15-97c6d3bcdcec@sirena.org.uk
> Cc: Nicolas Frattaroli <nicolas.frattaroli@collabora.com>
> Cc: Brian Masney <bmasney@redhat.com>
> Cc: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
> Cc: Chen-Yu Tsai <wenst@chromium.org>
> Signed-off-by: Stephen Boyd <sboyd@kernel.org>

Reviewed-by: Brian Masney <bmasney@redhat.com>

