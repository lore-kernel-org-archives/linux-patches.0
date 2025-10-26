Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC8819F48D
	for <patches@lists.linux.dev>; Sun, 26 Oct 2025 03:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761449042; cv=none; b=VDycqiDk8uvqxVL2eW3R5DN8TDVhLMme341NbRN4p+UrAzaTCKaArqFnrWangQ1QAmUZMdmzzuIxC8KiFl5guJxWQm5aNnWkhr7A+X8erVbipfWBQHD/g24QuyGfwy3pRu7aRhqdcXC99bXk8NsWrSN9Eysl+ACPF4astSPvnIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761449042; c=relaxed/simple;
	bh=bueBfTECE+wyjvffCJWaKFPOaYzuvYedLe0na1Ra2j4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Sbgx0TZ6CTo8CMAQyi/DbBfdc/IFtVwfLBBvt5zzNlkvbKfg80IQQ1y6UEV6YOSN6KC9/3zxEnNntKnZtU/sDp6z4aiJgqkCZxmXm/j2Ynfqb5oFcYkKOMHhaXFIPwHad0uDuZ/YNr/rXtD6JrzOlHWldbzDJv2/k6PWTXgrSQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20230601.gappssmtp.com header.i=@morsemicro-com.20230601.gappssmtp.com header.b=AarJGucF; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20230601.gappssmtp.com header.i=@morsemicro-com.20230601.gappssmtp.com header.b="AarJGucF"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-339e71ccf48so4466609a91.3
        for <patches@lists.linux.dev>; Sat, 25 Oct 2025 20:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20230601.gappssmtp.com; s=20230601; t=1761449040; x=1762053840; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=d7im5kNRiOdk+Jyo+cdutLIE/HJaHEyQyI3+hJyiygc=;
        b=AarJGucFCGE5y5+22IKyXaKu1PVh3aOhxRRF1GVpzbO/8W1guT7ZF39/EhQ6do5Hn+
         72YgFKDW9JQXqdFvNeS2Luur1pVvtpx/FcYeDNdFQbVtgIMLeUnpN/S5Acp1v5t9lYM5
         QbuVjIvilXLnHnB6zLa+i6WB9a+bfOWDgrPdzKHoeBBiZG6Ax+X4arAlyWt2838hr0Pr
         w6QIwNUh2XOcCua2254QOzq5rs9jCNQrKtt7KKBDETUGVtUwSNW8wBU4wKhpAZatbrOW
         4O5HhEiPDyLkZwaUtBD/fACH0wvqm1lWDL3KRF8O7Yj2LHGL+soH7OLRcZLJnbMF4vju
         Xq9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761449040; x=1762053840;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d7im5kNRiOdk+Jyo+cdutLIE/HJaHEyQyI3+hJyiygc=;
        b=S+IUJ5OC2IW4lEC9vs9juFnjwc4+MOtPbVX9futrQCB5p3+taBExG0Vdyis7uaUJXG
         K3mYmo+j0ZBoQFE3pKy2dakdMkt3YI+pybQMst4OtSgPSvn5HxP5aJZu8l0n5SMRg3+3
         L4/Hr7UXxv3Olaox2TjzAJitttiBOT1Bs2mMyXtDga1pBIz2rIPTNWZHJijfBp2/ldW5
         bRVvKyLsxxMRnFkui3TnHxfzOhM5CVG1p378HhA26NljOYQXZBJPalqYxg5bZbAtvig9
         Cg/7bg+efh5TZXwBQi0n6Be2xvPQ1cpMCg2ZcuRWjA6DeDFCoQvQR7tubvQF3VWvS2aG
         ZjNw==
X-Forwarded-Encrypted: i=1; AJvYcCUIhtbNYOo+BK+vBM/GnEaxc3zEN3WRftVD/v5pRb489eBai1Vs1NRG3WmtNhtlh5pWoZoFerFw@lists.linux.dev
X-Gm-Message-State: AOJu0YyyyInSZRAOesyRlCyYizyGpg/P0gjHqHOEI9PH5O/yyt6Oze7x
	fnAIujIiRhFi7WL3UMok18bGzzVU4qS/RERtA7XL8Lu5IZEKYmF2X5vqcENCyUq+O1c9f4QcDGG
	B0ZdhVmc=
X-Gm-Gg: ASbGnctzFyXxkNFov7BSw2WQDXFbWnguLsSBVi/dvlKhSmGt8gvck/uDjkj5pAeIadn
	GWSEIIdE0K7mtaxB41o4jSfKCY2ns9J7k1EF4bI9rVTu/xBrvis3lpcSNkEEvhqvYPkQHMhfWbz
	Sx5xYyUHDBhPLhAbtlfBWgjJPJiFenmplHLNTIyKlxmhBEEiwfeHUUGIing+/olj/tc69eCrYud
	S4wlTtyyLFCaBm9w0jO6JYOZi+TTuUS7HidsPESM3mhAzpnjrMIfM4x9unKMDk3tbix5e953Qir
	PqUWPnxJqxMsaLElEyx9g957PVYQUxwk2SB9AN8uIzb4pyLhR6xNxGaOCbsFWBYs8GdOoi8HIoO
	5AXetzoach0jat/2FemC8/G1fNtZTDlTW3E2UeM2x6W3CnKRXLNIKOd7ompxBn7OuVndrq3+XDB
	z9HuykPIlfZayruR/AfJP5Xy7OFNA0Q1ZsxOZZVV0nlwfIX+3VeT5MbjLxEWcgBJk=
X-Google-Smtp-Source: AGHT+IHq6wi7kD2Qrjii5aVezO6yzzAevLnvO8Q0TJGlZuunxWrS78THpTzzvJcj4iyYm6SADJp1Yg==
X-Received: by 2002:a17:90b:58b0:b0:33f:ebc2:644 with SMTP id 98e67ed59e1d1-33febc207abmr4170223a91.12.1761449040110;
        Sat, 25 Oct 2025 20:24:00 -0700 (PDT)
Received: from localhost ([60.227.210.150])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b712d7cdf28sm3342523a12.31.2025.10.25.20.23.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Oct 2025 20:23:59 -0700 (PDT)
Date: Sun, 26 Oct 2025 14:23:56 +1100
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Sasha Levin <sashal@kernel.org>, patches@lists.linux.dev, 
	stable@vger.kernel.org, Arien Judge <arien.judge@morsemicro.com>, 
	chunkeey@googlemail.com, pkshih@realtek.com, alexander.deucher@amd.com, 
	alexandre.f.demers@gmail.com, tglx@linutronix.de, namcao@linutronix.de, bhelgaas@google.com, 
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 6.17-6.12] wifi: mac80211: support parsing S1G
 TIM PVB
Message-ID: <ipjmlu4muicsgnm7kbkmp5pbcvjyjobne4zo4p4cjxv45la6cy@clmzwkjamyi7>
References: <20251025160905.3857885-1-sashal@kernel.org>
 <20251025160905.3857885-99-sashal@kernel.org>
 <72966d6ccecfcf51f741ca8243e446a0aaa9b5c1.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72966d6ccecfcf51f741ca8243e446a0aaa9b5c1.camel@sipsolutions.net>

On Sat, Oct 25, 2025 at 08:36:04PM +0200, Johannes Berg wrote:
> On Sat, 2025-10-25 at 11:55 -0400, Sasha Levin wrote:
> > 
> > LLM Generated explanations, may be completely bogus:
> > 
> > YES
> > 
> > - Fixes a real functional gap for S1G (802.11ah):
> 
> I guess, but ... there's no real driver for this, only hwsim, so there
> isn't really all that much point.

This also only includes the decoding side.. so mac80211 would be able to
decode the S1G TIM but not encode it ? Additionally there's _many_ functional
gaps pre 6.17 so I agree that this probably isn't a good candidate.

lachlan
