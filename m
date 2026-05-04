Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 633F23264FF
	for <patches@lists.linux.dev>; Mon,  4 May 2026 20:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777928166; cv=none; b=WEG9DDYkZ4clzo6laG96iOsv2G4L+v47w52yfsv5/MnnfVKJyFb8BL2MuuTo/+neBHciUSxURI8g0XGpjxHqGetTmUBDfucc5JV82+SEDeTfZSA2hgCWFn2ohYbG9ZpZh/Lhvb2YuMz/9xzM/OukpXS1IYw+Onheae3xwPpRMg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777928166; c=relaxed/simple;
	bh=6b0uhsWOUueBJikO+3RxwH3ywe4vOaHqBvUoJ1iBG10=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jGTONmj8JHrF1GtfYeukw6WbwNQ1rGbssmF8DOeyrKfCs164oCBQKlDDwygDW3C4zC8Enysj65jWZe6EenkqVvFcP4LlQfTAJ4pFzd0hjwMek6uAy4rstYhKOAf8eQcFpVTWG+WiJnl6z/ldE/vnr5rWGycDP6fLcS9s8HWxdbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eOwEpsBh; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eOwEpsBh"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2ba3e3c4f87so8351215ad.3
        for <patches@lists.linux.dev>; Mon, 04 May 2026 13:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777928163; x=1778532963; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uAEnOAPj5fUgAFUXnOyePT2fFfy+RA0tHhuCu8Z9sp0=;
        b=eOwEpsBhIeqDKF4KOwfsBXrua10MCxvaoQqCYhh1soHKw5wGDJ94KhxvyKmtf2pVdW
         XtOhJd1h3ha9oaSWKCGnubRcZ8MbtEjbPOEAbE87rSPnsNgwgpbpBwD0XORffN1t2UnP
         13RUhuYGN4fsOgODjT1x1m4obOl3dUfc6fZ3CbPBqIjPu5N1Nj06Oeg5puepAb6FY1uW
         rS0Uh9XvYQ6jZAIJiPwhk9IkIxgkYX0N94Kbbvd3g3Jq151XgI85S9aKbvRmMXIEVHFd
         EyJGSL6/4KX2c1nVnEt6MkUnji0bDuR8oLXgDyZQuKGNTYDe2YaS+iFDapVZB1enKB2z
         2GQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777928163; x=1778532963;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uAEnOAPj5fUgAFUXnOyePT2fFfy+RA0tHhuCu8Z9sp0=;
        b=GTyHZIwlOGLW/UleN1KP1gRKxOYdgjz2i7uNcLIlII+XHdKG1aX+NlsQAut5H95Yt/
         sxX8giHf9OXAEKdvzf4ICIJjzLIcpgT+5RgTKYqfxsCxlJIhz0Qbyffzr1xeAW744/16
         t32ZeHUwTYOLXHoV6qx5rBQ3egaGeh5042neOeAFnAC3smOlmfPEPCwc/JbXZBpDsq/R
         PD45A+ou5duZ7z10/F3hG79QpSYDEyEpT2764sg53pOuKL+fbbdqTJxRwnRKTs3/NmCG
         qT4V/sCLe5haqlS5tJsPd4cQ6dS5vRa6TWIEHIDQHLJhLQHP+yxNvTCvFUjG1IrnJRLQ
         BC8w==
X-Forwarded-Encrypted: i=1; AFNElJ+mNV6pxtOShaVVM/PxP2bAe0bYBBBsM9FayuTkQb+bZnAm18ejzdB3QlRwlcJ57R7OR9WdKl4w@lists.linux.dev
X-Gm-Message-State: AOJu0Yx4sEpadIDBwFe6Vh1/lCYnOLRTIgG8nR5jM8x0NFPR5udhpRs8
	s4pTnpXRH9Fp5zUF3TkUr8ZytPB7iFOWv40U9bQCGo5DREKnsdGpVcanKxy/W85ISQ==
X-Gm-Gg: AeBDievV+jA9nHukTqJh0/LWDNuDtbQcoQuLgFDWlqtrnDuwFAHiW6fIxrkWLmo/lTQ
	6dkLnIWFiUQvh726vOtUdJXoRZBMzh6qWVakkI3mPiXR5XeXIyZihHU37uVBDinZUWFNjTFuyl7
	JXoygtFCMj4NwCLVOM1DD1SmDvUAWeZIicnFP0xXX3oh5OFWsiK2VbSft/FF+JKsNqDyOkKUHE0
	uI2778mg2SGFkdJhJT4XTBBwW0Kx63YHQdQ4yzZjzrs5NYR8SWFprEcmizoEdqJDjDC6cYovL4j
	1VLCcyEsTHddgHjbcb5DAmtqKDgn4KkjuuOqj1EDnMuQg13XTvYtYUxYa8aEDjLLlIQt8blnEfz
	ADXxhkAQFWeH8WmFive2nV2PCT1XBdjun7lrb3LNkCT46GE2+tAZeS0izkxYl2jwhijh5bZmNdG
	Qo1ll3Zj4n5mt81f/8WsDW4grNxw7mpEmb1Hou9ERR52I01gZeI3Zc7+xXerGzM84SfYOSWWTu3
	5xucA==
X-Received: by 2002:a17:902:f64a:b0:2b4:5a2e:98d9 with SMTP id d9443c01a7336-2ba53896e5bmr1405745ad.37.1777928162684;
        Mon, 04 May 2026 13:56:02 -0700 (PDT)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9caa7e7besm116816715ad.12.2026.05.04.13.56.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 13:56:02 -0700 (PDT)
Date: Mon, 4 May 2026 20:55:58 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH 07/11] vfio: selftests: Allow drivers to specify required
 region size
Message-ID: <afkH3pMJKkIbElhI@google.com>
References: <0-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com>
 <7-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com>

On 2026-04-30 09:08 PM, Jason Gunthorpe wrote:
> Add a region_size field to struct vfio_pci_driver_ops so drivers can
> declare how much DMA-mapped region they need. The mlx5 driver will
> need ~18MB for firmware pages. Existing drivers leave region_size as
> 0 and get the current default of SZ_2M.

I would like to get rid of the magic SZ_2M to make it easier for other
tests to use the driver framework. Can you make this commit update all
the drivers to set region_size? They can all use the same approach:

  struct vfio_pci_driver_ops foo_driver = {
          ...
          .region_size = roundup_pow_of_two(sizeof(struct foo)),
          ...
  };
