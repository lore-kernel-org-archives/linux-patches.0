Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8A961531C4
	for <patches@lists.linux.dev>; Tue, 12 Nov 2024 23:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731452670; cv=none; b=hPbXMeMHnSPPfpOp2crOaycTfuWUDiKTHy1VsyiiCw3jb3zb/QgmVcv7l8P8QbI1w7kT9yTjKumn72Vt2CZj8pcXuDysEo8AWuAvuQj6xpYwof35EBmMt9u2DPCk33KCPak/I3jiMo2atSck1tuIAsIV7KGRNTADHiWa7TPqG3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731452670; c=relaxed/simple;
	bh=M8QZHdkR0C/TG//Jvt6IIv8ZeuA/WUQAchDPKwDVZpI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DCajT3F6JaFZz/YqgMlnAxp8nmsvufCL436Hbtjy9wIMMcd8s3JGlac1Sy1qrth8BUpTZNoBIQgr8Hu/XBcl3HgGyVIXJ2aWuKxKoEUQdWs2yelZci35lvoeUiU7Y8hN/ZJPHvFthJ/1ktuScsqvuVBVThhI4bo2c4vRmS3dB50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GjVAb29s; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GjVAb29s"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-20ca03687fdso68145ad.0
        for <patches@lists.linux.dev>; Tue, 12 Nov 2024 15:04:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1731452668; x=1732057468; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=oGcmcooZ3eXi2btPtJV6KWC5Ib7k9JOuUxsYyFpp28w=;
        b=GjVAb29s3VnQNyxgjuGqDnLAYUNKdMWWJRx8PrDATYUDFqDP5p4W3nhPBDvXnS5eGW
         KteY6VIi8fnhn8i2NpLKj8ySGnJKG5o+Er8dOEqt+cK6YXCQ1pL1kSgigoKS76sZa3BJ
         Byku5K0x01ONrHrAC5Pg+Kq/Fu1btYTkmaggSufh/0RQnCjf9XaMPIj54/SBnVYREtdt
         R9oykDnkgd6lQGUOf9Z3n8uXwO/eMJc5R5/G5DKudwaP6kJBIgoYSyMbJVM9SqhwsLkf
         /3BXHKWTRdiSBph2ftKEJY3fw/9m3RarxH+LvVTdUN1UfCgDS3UrulJr+iCbHRYnDmkM
         ExfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731452668; x=1732057468;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oGcmcooZ3eXi2btPtJV6KWC5Ib7k9JOuUxsYyFpp28w=;
        b=qjWR+Nmx7KOt5QOYTVPTXWRZgz3ODlSzgxaeauQoPXR4Lvmda7QmVdgXiZh0zZXT4W
         Cxb9mD3Fi2Cm10ga0tlp8O+McXdbm6uguLgJzzjPHOVwsD8o19WNxj4AMlSK5ERwf9lZ
         Ix12JKWwyjHVeXDjNPL/klL0TTNT+DjVU+QtSn0C9TCGXrmcOQu0kjqJzpq0EtluTUCP
         kDcTVyU3fTwbRCiPiv0NsAalYGEzIeXYa1W9Ex1Fv6rY3q6+bo0VtyWW5sw0+grXEwum
         HZV/+dUPkzcW/ALMB1gFN3d4TvqDML/nySR7T0Sqm4PiYjLtWD+dgKHLbcBGESP1wnOJ
         xKwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJcFf4b4zohMoTiKrMMoEzwhC6fw7EU24v1r84CFyvs94R28iPWCfPj/NtVNg0DUPQZ8W6s+4I@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7E1YKqtuTsvparNZ+En/jnB6siV8Sc1MU7YV8yPblz16IgZOP
	sQcpi8Y819FDUHoyp1MhewdlBEpBOPRebiUrBfy0DYYLVTG0N+JyvvhAfuwKXg==
X-Gm-Gg: ASbGncvTp+SnTM7g2YEWiy+KNnXQ2h8AYHqU0UQ1lS65kfE7YToALgnXYxQSlUfRHhE
	8P9LOfZ+sunjlo7P1uNM6dMftFeu1HiGjC8VpbFFaK+bJgLy+Ebl9QR8qA5wu36zPAT1ifXcU14
	3QuekWcjF5WM+Y7nuBeJhW1lxxUqnWa3ekU560IDpLX4Gi2rqZaBVD8fJLCtZfxjTMdSSodJzOJ
	3XyKjiKij6ocN2lCnL0fDG8Toqxn0YrHL93o8iy
X-Google-Smtp-Source: AGHT+IHOy09+IsPJGVNT6MLd6Ag2vBUkiSWhTo9lb9O6NU0vAC5+WyRM3S3Z/m5iZlqrTpgtb91ezw==
X-Received: by 2002:a17:903:192:b0:20c:e8df:2500 with SMTP id d9443c01a7336-211b6ffbb98mr262825ad.3.1731452667677;
        Tue, 12 Nov 2024 15:04:27 -0800 (PST)
Received: from google.com ([2620:15c:2d3:205:d954:735:c86e:9b56])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-7f41f5ea0d5sm11198004a12.47.2024.11.12.15.04.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Nov 2024 15:04:27 -0800 (PST)
Date: Tue, 12 Nov 2024 15:04:22 -0800
From: Peter Collingbourne <pcc@google.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
	Qun-Wei Lin <qun-wei.lin@mediatek.com>,
	David Rientjes <rientjes@google.com>,
	Vlastimil Babka <vbabka@suse.cz>
Subject: Re: [PATCH 5.4 462/462] mm: krealloc: Fix MTE false alarm in
 __do_krealloc
Message-ID: <ZzPe9ossmfQP_s77@google.com>
References: <20241106120331.497003148@linuxfoundation.org>
 <20241106120342.916487840@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241106120342.916487840@linuxfoundation.org>

On Wed, Nov 06, 2024 at 01:05:55PM +0100, Greg Kroah-Hartman wrote:
> 5.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Qun-Wei Lin <qun-wei.lin@mediatek.com>
> 
> commit 704573851b51808b45dae2d62059d1d8189138a2 upstream.
> 
> This patch addresses an issue introduced by commit 1a83a716ec233 ("mm:
> krealloc: consider spare memory for __GFP_ZERO") which causes MTE
> (Memory Tagging Extension) to falsely report a slab-out-of-bounds error.
> 
> The problem occurs when zeroing out spare memory in __do_krealloc. The
> original code only considered software-based KASAN and did not account
> for MTE. It does not reset the KASAN tag before calling memset, leading
> to a mismatch between the pointer tag and the memory tag, resulting
> in a false positive.
> 
> Example of the error:
> ==================================================================
> swapper/0: BUG: KASAN: slab-out-of-bounds in __memset+0x84/0x188
> swapper/0: Write at addr f4ffff8005f0fdf0 by task swapper/0/1
> swapper/0: Pointer tag: [f4], memory tag: [fe]
> swapper/0:
> swapper/0: CPU: 4 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.12.
> swapper/0: Hardware name: MT6991(ENG) (DT)
> swapper/0: Call trace:
> swapper/0:  dump_backtrace+0xfc/0x17c
> swapper/0:  show_stack+0x18/0x28
> swapper/0:  dump_stack_lvl+0x40/0xa0
> swapper/0:  print_report+0x1b8/0x71c
> swapper/0:  kasan_report+0xec/0x14c
> swapper/0:  __do_kernel_fault+0x60/0x29c
> swapper/0:  do_bad_area+0x30/0xdc
> swapper/0:  do_tag_check_fault+0x20/0x34
> swapper/0:  do_mem_abort+0x58/0x104
> swapper/0:  el1_abort+0x3c/0x5c
> swapper/0:  el1h_64_sync_handler+0x80/0xcc
> swapper/0:  el1h_64_sync+0x68/0x6c
> swapper/0:  __memset+0x84/0x188
> swapper/0:  btf_populate_kfunc_set+0x280/0x3d8
> swapper/0:  __register_btf_kfunc_id_set+0x43c/0x468
> swapper/0:  register_btf_kfunc_id_set+0x48/0x60
> swapper/0:  register_nf_nat_bpf+0x1c/0x40
> swapper/0:  nf_nat_init+0xc0/0x128
> swapper/0:  do_one_initcall+0x184/0x464
> swapper/0:  do_initcall_level+0xdc/0x1b0
> swapper/0:  do_initcalls+0x70/0xc0
> swapper/0:  do_basic_setup+0x1c/0x28
> swapper/0:  kernel_init_freeable+0x144/0x1b8
> swapper/0:  kernel_init+0x20/0x1a8
> swapper/0:  ret_from_fork+0x10/0x20
> ==================================================================
> 
> Fixes: 1a83a716ec233 ("mm: krealloc: consider spare memory for __GFP_ZERO")
> Signed-off-by: Qun-Wei Lin <qun-wei.lin@mediatek.com>
> Acked-by: David Rientjes <rientjes@google.com>
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> ---
>  mm/slab_common.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Hi Greg,

Can this be picked up for the other stable trees as well please? The
patch that caused MTE false positives is in linux-5.10.y, linux-5.15.y,
linux-6.1.y and linux-6.6.y but this fix is not. I checked that it
applies cleanly to all of them.

Peter
