Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C712E40E
	for <patches@lists.linux.dev>; Wed,  8 Jan 2025 03:55:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736308556; cv=none; b=H5zXIJBC5473W+2pl644tZ2ggyioJyxdiMA0rEPnS6In8iblrbTnv8m93WLPBQ1BQPGKHoljboGtycrKN3g2QkoIBRDyL2dRJQqD98ZGMonzhr3UcsPPgvcKt8KHkKQVknjpt8DIFTvtZKpcSm9dcqKEBAQ5LHlrC9MKrLlrVDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736308556; c=relaxed/simple;
	bh=fJwTItY3WpyPUBts3I2F/xVrqfS1kWCnR52HMF5jmww=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DG7YtxnpCJ/VLJxv9E+el7lpca6uHsOUMV+mSpbVuLz4nXnh+f7lheScLdmDR7psgg64fIHsxJSG7pD58kDVaVlk6KT/6SiX0TeIGKeLu6kb3iw6SHzM/96aB2LEgXwnDws9WY7JLCAxb4w6D5MAxt4xPTGKYmJKH9PV5lD0ylU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=Cq4IVhAx; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Cq4IVhAx"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2ef748105deso18395060a91.1
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 19:55:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1736308554; x=1736913354; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=3JW7pnso5ES5YRv5DQa6Smxjc/jdlHEm/DPvIpOfBQE=;
        b=Cq4IVhAx00pktElI9L2kBvRnMxxGywkS0tce1yQt7MovpEjNLYl6VRjviSuO18wiFW
         lDaqmJZC6+57D4f+YTOOmnqLQ32v8SPjGXwsVzizHBl/TzS4XaqukL/2bYn12h4d4zkZ
         HOXObsmp90d7CnBmyTSstJ9CVQjQbL/HJo4ZM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736308554; x=1736913354;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3JW7pnso5ES5YRv5DQa6Smxjc/jdlHEm/DPvIpOfBQE=;
        b=ivrAAA7MU6NmIeB7wkLh7ThFqlbRXlcf1M+HorU7Sr5X7n6ujkuU5z+N3jdMK/Oeqx
         w9yUGbvhCeIHrX3kKKlW2gGWmc/y/zJKpfnwUUNmcAosKfHvfEtwh8BYxtzQIWXrjjiB
         b1rKXruBZdp9ke1w7HlyMjGHakgXdfc8S+FkNBFiTxIE2SMvLoq/OWa7RCAjbz+A0NQM
         nVmeFeBmU7mkfOVAWTAUp9e+0/ifTYJD77gf6a/twqWEn6qYgKOwQX6WrnUoevN9sQj9
         /5MfKCoTsEPsqsnUj/8KY7+1/rHX047RUQTVU53DklIoUkK4jd4HUwQxEK4Zpvm1K5nZ
         oXsg==
X-Forwarded-Encrypted: i=1; AJvYcCWEu4oJBOZR+FV0OJqv/VW6MGdT5MBZuPJgdhGXuIWfyzD0MqWJw/mi9gE3bpWRL2QqD7eu5Xbv@lists.linux.dev
X-Gm-Message-State: AOJu0Yxwspt3s5Huj+6xtHc9V47yd39RDTsQuAg/WaxV2mKWCA/qgGpv
	3grWo2rodga3fW9YwFoHqFtUGW6x3h2eX6DmSasHikAYaqgCgE+XEUx7vtAgog==
X-Gm-Gg: ASbGnctNvnyoMWTwF8Q5sWmkYI5lqci2+FHa1bysKg3zgQM1WiTaPWMUMRg/ULr2pM3
	Lo2bdygSpYzEWOF15IgsoVoQSnYf86EQi2Pq/mleSJ3g6pmsP9Ex8q60XcaKwyZI4CAtVv0h7J4
	HnnVt0x2LaEW+BG4gp349F9Mt6NGhvAV/uhb4xXjQTskXgrB1UCe7Z3E7/PDVIEH0TKD++oy4hB
	/LCvZ2eAvoSaKy6AS7E6S9nqTvF4m0M/2XhsNq3gAxLwnwvAcktD6hZ5wf5
X-Google-Smtp-Source: AGHT+IGjt0PFakgymYUjJ6WbxlzWJ44dvPtTxDS6yMEemLX4k7Ge3UEc89MnlOVg7obSIp5svSSZHw==
X-Received: by 2002:a17:90b:534c:b0:2ee:f076:20f1 with SMTP id 98e67ed59e1d1-2f548da3a1fmr2395745a91.0.1736308554228;
        Tue, 07 Jan 2025 19:55:54 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:57ef:1197:3074:36c2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2f54a34d87esm385723a91.40.2025.01.07.19.55.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 19:55:53 -0800 (PST)
Date: Wed, 8 Jan 2025 12:55:48 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Kairui Song <kasong@tencent.com>, Desheng Wu <deshengwu@tencent.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.10 098/138] zram: fix uninitialized ZRAM not releasing
 backing device
Message-ID: <ntg2w33w7lwfpx6ichogmvaxnr3h33p53zy2gfnqdxbmpp6qyp@2cu2hxibuudo>
References: <20250106151133.209718681@linuxfoundation.org>
 <20250106151136.941319893@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250106151136.941319893@linuxfoundation.org>

On (25/01/06 16:17), Greg Kroah-Hartman wrote:
> 5.10-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Kairui Song <kasong@tencent.com>
> 
> [ Upstream commit 74363ec674cb172d8856de25776c8f3103f05e2f ]
> 
> Setting backing device is done before ZRAM initialization.  If we set the
> backing device, then remove the ZRAM module without initializing the
> device, the backing device reference will be leaked and the device will be
> hold forever.
> 
> Fix this by always reset the ZRAM fully on rmmod or reset store.
> 
> Link: https://lkml.kernel.org/r/20241209165717.94215-3-ryncsn@gmail.com
> Fixes: 013bf95a83ec ("zram: add interface to specif backing device")
> Signed-off-by: Kairui Song <kasong@tencent.com>
> Reported-by: Desheng Wu <deshengwu@tencent.com>
> Suggested-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Reviewed-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Can we please drop this patch?
