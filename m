Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9CA62F49F1
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 16:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765903887; cv=none; b=aftygtJ1MMrYYVbsiPgf9r35GELWmNhBBviaY31ZekZ0QTZd2L2+CTzE2qkQylvVfW99DM8ZTic7JSTQS/avtgU1GeFl5DApb2aU/HhzF8SqMyQ9Hl1tfHA6/AbkD2z2KknMFhZe34UgARG8F8DNAG9TZ98T3yDMtb+2caEEGws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765903887; c=relaxed/simple;
	bh=6EAWakK9hGEZFnjMpke9BtV0raNAkYiS4u+8cjGBWPg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aKxJfz5cStSHt7Lr58JYnmGyKTwPjfF4rrogdyVJP+/k6XBjJI6YpJzWCwHDmKTLQkwdJ7Bsyu/vdyZ2n7v/vwDl2uZq4nL9nlhc6c53xfVF2tpZq/YKaaKcFpoSL3AjMIsHzFojL+/TlxnjA9WZUyfl9uGTGnKaD4UAyeazjNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu; spf=pass smtp.mailfrom=asu.edu; dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b=rdO5ducF; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=asu.edu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=asu.edu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=asu.edu header.i=@asu.edu header.b="rdO5ducF"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-bc17d39ccd2so3011689a12.3
        for <patches@lists.linux.dev>; Tue, 16 Dec 2025 08:51:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=asu.edu; s=google; t=1765903884; x=1766508684; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bXFLxPfMdRy0hynFOSJMIIvcmXhnhbLzVRVWvbqAVjc=;
        b=rdO5ducFFkLpHoQMyihA7l0MUW5f7RiIPXLDVBnweDtpRhVYpNjeiiOLMClrzhMQhG
         xXy7oeArl5fMyJLJHWpoe3RUhhByNVAEiCQ8qb8HP3qiED0J4Br75jJmiuawq8PiB6pK
         Iu2eZUY4wYNkqEJl++HKEbgS5ea+AUi7fH4APm4lOs9oeYmO+r07cYNh7NNVAlY1wfWY
         LI3Y46ArqYXC6yusk5SCdOxObQV31cTKm3A8g7s974enH/uiYRx4ZGblnBxWPojZR4OP
         5ZavYUd60aVXr+jMU9p7PeZ1WM8dpHY4oXkRmA1RHLP/s3bejVWDolD+eUgNADMLQeU0
         MLmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765903884; x=1766508684;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bXFLxPfMdRy0hynFOSJMIIvcmXhnhbLzVRVWvbqAVjc=;
        b=bTad8t+zB3G/tBjPexV5O5vz9BUmWZsOPpLHL4wOJDyE5RvJuU2q0r3lyN1l3peNgu
         Ew16suVx4lzNduZILkDhwQVg/BQQFhyL97CyEMh22RyaeDkDILigN2CjuQ5AO8t4+4zl
         zrGLl7mVlgeHPVUCHB6itY3Xn9R2QYEocA9vPeuivCG2aOWTqwLpklayDvM9KoXYVtnR
         NESLQkqnsMb2TjLXfvBlvgzkzj+k6D1584F/2m6fA4MovuiGEOVUeINeSSUWwyBm+1yp
         shlEn6TTZNHSFoA5CdkoJBl6ma0GUZgsK4WuZwcfaplMrsgrJlLA6LJQo4SSMdotCbo7
         kydg==
X-Forwarded-Encrypted: i=1; AJvYcCWQJvRd805X4CbzXODQGvRXR67kclR6hE9PQ49o6ZYFN17PD/dlHTMB+0dzzveLHL8lu/eCGYvf@lists.linux.dev
X-Gm-Message-State: AOJu0YyRfCWRz1Yc+yooJbArETkdCL9yPPtMfjcwkSK2/+V72FV0dtp+
	WzrHwVkU7Ihb3qgvVlGBsYs2QCg/GaqDI7JKr2cDxbxx69MeHW/v+kuuzVKh0GFVVyBxt8suolh
	R6Zs=
X-Gm-Gg: AY/fxX4ptLZlNMV+xzstKpB93bJHHxrBY1jPMrsNqI1S60BQ0/jEA+WlsTU03nnkKEK
	xus3fck99BHHoj1xXP73UWU5kIZUv5DnwUFE6obqLfvzKn75LtUVqP8F9djZcotFzZbtA5csYXA
	vxMgWVMhFre45R91+SMdB1hoOB+PlUGFBwXGlRbZNrjrKyQeYeC7cblARwUqVkMU5Z8C6rbiQ6H
	G7cAsvZ8FM1tIONfZkn2Dq4ulqosR4wHpN/pT7WqTkPRSpAvDE5EQK/rxLmIQaTxVSY6GD3L67j
	obGkPnSpdIDR7Kj98iC/CZnIE35G/24ytVtANCizCrKEm7ptzH4XYzW1exYC9Mf+gRRcNzNudFp
	0XLMuFwZSROcDTrgPFb2YEdYLdcEwFfqzs/HQOrabzVChc0O/OzM8Oj2M6ZLcGMhR204rp1Vue/
	y3wZbmpEhjKW+lU5xJwnlskgY41wveEnZ4
X-Google-Smtp-Source: AGHT+IEi4jiQdLnZmUxhb2opMxb7EKOqLnq+4SA7fRFnDdACEZ44RjFv4wK+1gwMTFXSt5R/mFB3yw==
X-Received: by 2002:a05:693c:838d:20b0:2ae:55f2:ad57 with SMTP id 5a478bee46e88-2ae55f2ae09mr893197eec.29.1765903884437;
        Tue, 16 Dec 2025 08:51:24 -0800 (PST)
Received: from gmail.com (ip72-200-102-19.tc.ph.cox.net. [72.200.102.19])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-11f446460c8sm18015041c88.10.2025.12.16.08.51.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 08:51:24 -0800 (PST)
Date: Tue, 16 Dec 2025 09:51:22 -0700
From: Will Rosenberg <whrosenb@asu.edu>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Oliver Rosenberg <olrose55@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.17 367/507] kernfs: fix memory leak of kernfs_iattrs in
 __kernfs_new_node
Message-ID: <aUGOCq2MaJsZ0cwp@gmail.com>
References: <20251216111345.522190956@linuxfoundation.org>
 <20251216111358.754182559@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216111358.754182559@linuxfoundation.org>

On Tue, Dec 16, 2025 at 12:13:28PM +0100, Greg Kroah-Hartman wrote:
> 6.17-stable review patch.  If anyone has any objections, please let me know.

Please see https://lkml.org/lkml/2025/12/16/1248.
