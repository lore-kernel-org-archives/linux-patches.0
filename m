Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A1B7225D7
	for <patches@lists.linux.dev>; Wed,  8 Jan 2025 03:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736308738; cv=none; b=P6VEMDEz6ME6u/J6SkN5CA8xCA5xfxyBuiP0yDgTZGHEOl+S5MB4abxddkc3UCqJdLpQ3u/JwEISa56Yx3Ct62eXN+ViotLm6N/rNzm15pRRvl0PLYb6HhTNNgxDvyo4w6einNko12KL4x2dwG2bRsDCK/Dpxz65zsn8DPRUbaQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736308738; c=relaxed/simple;
	bh=Wqsm2OX2pUiC8B3MPlIcLexKxiaNigUMw7QhyjuPCIM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BmLzRl5UOZooVK147POrV8P3+Bm+a42mL7hPdW5JBXt/b7fYiEHl6s7th2Y/JFpZy1HhbSKUnBfwRSfzPkYAfrQjTb0eXf42uRUzlzwAHCp4QI2sO5MsdFECqIhfUoopQNNTzXOJNvoqI5ll5TeArCKFIkXCe5vxglXfpBj5t7s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=ScsA60U9; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="ScsA60U9"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-2ee786b3277so17781567a91.1
        for <patches@lists.linux.dev>; Tue, 07 Jan 2025 19:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1736308736; x=1736913536; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/5SJfDYo1krnMaVXgKeA8KZwOLGlt8uzSPVvBfgdcUw=;
        b=ScsA60U9sXJ4oltL8ZDOUvzhAU2/ie3g0HcblTztHZoDBfIdCiKLVIiaGycYizs5BJ
         CWwo9yZwVvL4qNie81NjtAW0QBlK+/vRTpr2ae6PoSYEsS4rRTmpmK8/M035ODRElbxs
         E6/sC1me6IW16o6I3WWPJUXdkgpvweTFDJmO8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736308736; x=1736913536;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/5SJfDYo1krnMaVXgKeA8KZwOLGlt8uzSPVvBfgdcUw=;
        b=Kq9eDExFvjjgxZD9lsuPJpCQlom6I8+yrDBP7CBpW5jNJ/WFOGs3+wjVX+vOPhWQz/
         B52bH7y2JqOfgdZ4rRMybPRFs6H7b79Xl9EFEYFp/U9tU2IWQ4TUzj/bs7IcJblfXBFW
         CLeiV8NUTj6ZYjk1CS99/8TVCAodZJiLVZDzdVB/9sZx1dR+v6CGSXWQlu8FOy+JeRLx
         vM1UCX1qoKNx+hJ7NKe9ga4gkAB9+WV3ClAB1D02EZ1SZCiX8n3KGuV+GvAg4ttw0vDR
         BxujXxGN3rpUcQWpVs1ZLiw9TXueqnVRZD4ZP70XtI/WVaKVqong4h9aIwq3dVD7UgD0
         RzjQ==
X-Forwarded-Encrypted: i=1; AJvYcCUEHRFKdeDJTuiG81kwFlako0rEutLAYH1ncre7Q6RRBkmUe1WdjBFbnlRNNpTJTm6wpAJM8Cd9@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8url2APTsBKMGQT/iV6Kdue7AuzUOdcYpTfcCiGqU4ayykItT
	Hfd8Kh2fzz3haT7wY8Imo4lxHx6j/AkidyeOjzoEJ08Q2hDnhVGgMHsHOOH5Hw==
X-Gm-Gg: ASbGncvcNlf9cILIAz4hh1wEDGkp/U50p48CEhrJQF5QxFeu4gD79PcFVC1e7vcRruh
	REvArx5oLOQlSGlQiV98myD7GxYH0bJcdCuYlYjr3RI9eU805Se0ZwRo3PeEMQZa+Xyf2LixZYr
	DEMDC0mHgKCze2la+hQUKlVt5asWKHMDOKzxxS1TxbB7pl1X+1Fxp+HAlhFwrX4WCHw1f5xIGiq
	e3KHAEC9piyMyNCFkLUa86lo3Nt9xbJ2EMS+P2tDHqabzba2ruJ2iYHN6BV
X-Google-Smtp-Source: AGHT+IHk9xNeOcJGphe0sHJuFkp76vnbwL90DLnRx4ZAZ8BLyvlFgQKpq5hj9YdtEyneH32ttDxjaA==
X-Received: by 2002:a05:6a00:9294:b0:725:cfa3:bc76 with SMTP id d2e1a72fcca58-72d21f115b4mr2151749b3a.4.1736308736575;
        Tue, 07 Jan 2025 19:58:56 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:57ef:1197:3074:36c2])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad8faf93sm34135735b3a.153.2025.01.07.19.58.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jan 2025 19:58:56 -0800 (PST)
Date: Wed, 8 Jan 2025 12:58:51 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	Kairui Song <kasong@tencent.com>, Desheng Wu <deshengwu@tencent.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6.12 110/160] zram: fix uninitialized ZRAM not releasing
 backing device
Message-ID: <wpzuuv6x4bhfldzk2x56yceyymom7jektmwdz5eizugfx3r6od@w7qllyd6vkvf>
References: <20241223155408.598780301@linuxfoundation.org>
 <20241223155412.926326153@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241223155412.926326153@linuxfoundation.org>

On (24/12/23 16:58), Greg Kroah-Hartman wrote:
> 6.12-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Kairui Song <kasong@tencent.com>
> 
> commit 74363ec674cb172d8856de25776c8f3103f05e2f upstream.
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
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Can we please drop this patch?
