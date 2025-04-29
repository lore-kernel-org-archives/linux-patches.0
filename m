Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9386B243964
	for <patches@lists.linux.dev>; Tue, 29 Apr 2025 18:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949807; cv=none; b=sw9Fu919JpOalidtM3rOugUeThCgOI6Ojmu53P4/U9JqguOZvqDZxRak3xydb6l5R1JZTu5Nxsvy8qT55eoQgROARBWJu3GV2827ykLR4NtWzWw1qHk3sOTCcay+VveAoQDvtX2Yw6qkdEGY0TWqi0c2RMeNlvY65wFqf6IW9fg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949807; c=relaxed/simple;
	bh=/jKxrEccc/rxDV9flEdrkcq0R1bjej/EwSVckgQxFcs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RIzxRr0eM+OSCKqA8bXwlNSC5IvpFxk+t+7ehBxRVauzJenuOqR090k3KRxCq0J/Hx7N7gbfoLdWjlXzH6CzhkY99J8D6Q0WQpzNaKtpPkOneGRSsuR6/WeJFiLjm28hp4X2V1+Z598HA/TASXSVK7SnBZsxpz+EHu1myYwCqhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=p8zjoPeM; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="p8zjoPeM"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2264c9d0295so199385ad.0
        for <patches@lists.linux.dev>; Tue, 29 Apr 2025 11:03:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1745949805; x=1746554605; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5gO38QVftzp7foJd8AqWRzdImXv3oAewp8XDWFfWfG4=;
        b=p8zjoPeM8W0Wd2yfOpohmzfFo1Q7jplmMqtJ9NwOLErg1KSja9+CV/bDObIdZI8rDn
         iTqofz64bFIVZoL84TMB9wgDv/wxUzXiNE0WZS5BBUZsamTwXQhht6ZOe/6dWBINSnCA
         iRJPaiSErzvnevd6UmgFnrfM9lgSAlvCiTHXUoK0AQ/OHhYyzJRqZ6xgEvrScAQqCIXB
         4ts9Xk1AsQ48yB/yhi5F+HbNnS1R701AqOsP8eh8kjUqjf6/o27uhLIHWi5T1HKY03z7
         E9AYDIl/TDiss+QOJGnWeU3j7I0Er6b9oPwRhTdkBWrnJcRihGGjra2nzommJrfiFzfV
         wX/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745949805; x=1746554605;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5gO38QVftzp7foJd8AqWRzdImXv3oAewp8XDWFfWfG4=;
        b=DjKPymlPOyLZKYb0UiLsFhZbl2NP0K2U4RSklRcMu5qBjI/58kiEFQAIs5au9fgbNA
         44WxCuGVD00BmdANDQQH7y65yF3afC3Vt4DToKH9I5yr1bQ4u3j2hKXWjW07d/vmrx54
         su8UVgNNtg7Cyp319nvmU5c4sDqgzaIl+HMi+W3beHVDyDInmfJgfnWTCw5+fM/XyF0s
         SRfuZF8/esWXmUY2bPR+AVadCXo+4d5OkvjhNsmWs0rb+xdTWBApQ9MAIJJfbiXGCjw7
         qHTfm9/uB2Opg1JrPSwGVGm4OyeeMHgLTlB24OM596X+zD8Ir3mr44+dQVwQU+v1ygu0
         fiHw==
X-Forwarded-Encrypted: i=1; AJvYcCV6KY3/978L4iLNUNKjIQM0ppEvum45OBVlW9JMoqT2rL6iacffpc021TprMbFUrfDqsp424+ze@lists.linux.dev
X-Gm-Message-State: AOJu0YwWLv6Y8gmQe8t+vN9y5lltdiSqOwUejvqxv5tfUmxvDy3ex9IQ
	8L2Q7GeikCFhTmiVLRXrg6bMXYqKtVBMPWW+yPXrQrE2NxLqlfhAGk6raJvBZQ==
X-Gm-Gg: ASbGncuadL/TeTYwpGkz6Na6s9TgJR5kQM/NivNfaPZilq4YBzUqAmdHWNcB76doQRg
	cBG/hlIHqPmvwF43lFeIImKITpLg8QOC+zkKrcC23OQWKrwUMPUjRlKXNXgc8QH4FaRHoC4zPp8
	cLtT4qOjF/6FpbR2Hryv5x4QSXJVcVgI5GWgHEebLnlM92XG5Wy7YIw5Ma3fMNIPb59pwLUuPg0
	3+ojVV+KcGFpL4miQ3xlsM5QHKaQcydQ2d17iZIL0wWMaHPC2F/2wR3OOFBLxfLPeCkoVk8A6tC
	XEbJFFko3PcjezjSI+Q+6B88Q+q8SlwxqcVDz+Yxo/Lf60cCH3sqkX6SI71JZh/5PTgteeXP
X-Google-Smtp-Source: AGHT+IHcbHv78LbKHTcjYARgVuVMIU3PlvzwcFa5Mynrm4iDVnN6pnPgBf3EmKTpPOmaL66ic8Z84Q==
X-Received: by 2002:a17:902:f60a:b0:215:9ab0:402 with SMTP id d9443c01a7336-22df40757bemr145535ad.18.1745949804669;
        Tue, 29 Apr 2025 11:03:24 -0700 (PDT)
Received: from google.com (2.210.143.34.bc.googleusercontent.com. [34.143.210.2])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b15faded711sm9272213a12.66.2025.04.29.11.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Apr 2025 11:03:24 -0700 (PDT)
Date: Tue, 29 Apr 2025 18:03:13 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Nicolin Chen <nicolinc@nvidia.com>
Cc: jgg@nvidia.com, kevin.tian@intel.com, corbet@lwn.net, will@kernel.org,
	bagasdotme@gmail.com, robin.murphy@arm.com, joro@8bytes.org,
	thierry.reding@gmail.com, vdumpa@nvidia.com, jonathanh@nvidia.com,
	shuah@kernel.org, jsnitsel@redhat.com, nathan@kernel.org,
	peterz@infradead.org, yi.l.liu@intel.com, mshavit@google.com,
	zhangzekun11@huawei.com, iommu@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	linux-kselftest@vger.kernel.org, patches@lists.linux.dev,
	mochs@nvidia.com, alok.a.tiwari@oracle.com, vasant.hegde@amd.com
Subject: Re: [PATCH v2 08/22] iommufd: Abstract iopt_pin_pages and
 iopt_unpin_pages helpers
Message-ID: <aBEUYdlCLcH70UlT@google.com>
References: <cover.1745646960.git.nicolinc@nvidia.com>
 <d44272c153e7596c3cef716044de3dc6c2a8254a.1745646960.git.nicolinc@nvidia.com>
 <aA_hm_AD4Xzm3qJZ@google.com>
 <aA/9TZq99TF+MRYv@Asurada-Nvidia>
 <aBAQdq0jeoCdKdsC@Asurada-Nvidia>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aBAQdq0jeoCdKdsC@Asurada-Nvidia>

On Mon, Apr 28, 2025 at 04:34:14PM -0700, Nicolin Chen wrote:
> On Mon, Apr 28, 2025 at 03:12:33PM -0700, Nicolin Chen wrote:
> > On Mon, Apr 28, 2025 at 08:14:19PM +0000, Pranjal Shrivastava wrote:
> > > On Fri, Apr 25, 2025 at 10:58:03PM -0700, Nicolin Chen wrote:
> > > > +	iopt_for_each_contig_area(&iter, area, iopt, iova, last_iova) {
> > > > +		unsigned long last = min(last_iova, iopt_area_last_iova(area));
> > > > +		unsigned long last_index = iopt_area_iova_to_index(area, last);
> > > > +		unsigned long index =
> > > > +			iopt_area_iova_to_index(area, iter.cur_iova);
> > > > +
> > > > +		if (area->prevent_access ||
> > > 
> > > Nit:
> > > Shouldn't we return -EBUSY or something if (area->prevent_access == 1) ?
> > > IIUC, this just means that an unmap attempt is in progress, hence avoid
> > > accessing the area.
> > 
> > Maybe. But this is what it was. So we need a different patch to
> > change that.
> 
> Rereading the code. The prevent_access is set by an unmap(), which
> means there shouldn't be any pin() and rw() as the caller should
> finish unmap() first.
> 
> In the newer use case of vCMDQ, it's similar. If VMM is unmapping
> the stage-2 mapping, it shouldn't try to allocate a vCMDQ.
> 
> -EBUSY makes some sense, but -EINVAL could still stand.
> 
> So, I am leaving it as is, since this patch is just about moving
> the functions for sharing.

Ack. I don't have a strong preference too. This should be fine, we can
re-visit this if needed in the future.

Reviewed-by: Pranjal Shrivastava <praan@google.com>

> 
> Nicolin

Thanks!
