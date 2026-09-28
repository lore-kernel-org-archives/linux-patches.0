Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7117125333F
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 23:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790636630; cv=none; b=sRv5ZqSvqePV9SBfabqZgRmPugUn116LqJeUy0yQsQ94npODWS+jni3P/U97M3VgG5SDmir9W8kYSro59Nuq8YFi94UkUX6r48De/03tcwtfBYmM3dBTWiS3p+yNldaCJziuWvsrb2MUf1xPj5XjumD2IQV/ya1gtz99IaFa9DQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790636630; c=relaxed/simple;
	bh=+NbROVe4afASwW55xJJaNok12pyEvCa8CWrMaS1gt/Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nZlGBqeQla2vBniCzs4hXfecCZu9Ph4Ly3dnjFrRLoRLhKmufEuSp4JIX/PDZRXxcgu1kdff/dQc2OGPzDuSmoCmla9aK3QbeZNghkDUWFEz8eVM8959XUsg+dWbsDYIBdttM4dVqK3oEwN8QtNhW0oWlb9Chi1T8wknaDD+CzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CX2Vh6mW; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CX2Vh6mW"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2db33db4de9so22245ad.0
        for <patches@lists.linux.dev>; Mon, 28 Sep 2026 16:03:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790636629; x=1791241429; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OMftjJLAh8xtsCYYhvQzmmzmnj+Oz+ZcLlSPeG/s0X0=;
        b=CX2Vh6mWLxK+P2GwlsvBpsX/37qV5YkHAYdQiuc3+M7AWk1b197sJhpXGZ3i1QX0Tw
         QEu0Bi4idJOLFetY8cJR5YZnCuctnygYXvesU3W9b2VOSU1DN8AHKEKWxhYAshSC2phq
         7rBUoVlVP22fKcJsckdgD/gJcqVhDwED7uL4VBQ8oMcbnulQOD2eLKT9n8sqIGGVj0jL
         dLS8cwdrmGoqqacETJ245apVgQuQ5cuBdDNpKJZohQ6N4NfPBsRsXbSr2meibgzlWCkV
         SM3L+pGOs8MAp5KykP+/owcEoVIdnLo5PwJx7uNJfqjuitKuWoJcosKqRXzKToPXXaKj
         sfXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790636629; x=1791241429;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=OMftjJLAh8xtsCYYhvQzmmzmnj+Oz+ZcLlSPeG/s0X0=;
        b=g9hHU9qvDjV39e2oaXy0GdowVBOtxqPSsheRabrpHQve+6TMhDIKZYR1rgoURY4Ak2
         Jus9WETdos1G5nsLOYon/fyqzGhn7m5IZF3u1TZSkMsCjvhoveG0kMhNFOQ9VMc3gvsB
         dKKvQrKXUwbP0deVtSFJi+wgqKx3U7xOyMPZ4dS5gzQhWNKS4XzT2Wi5ZdEan3u5uAEa
         i7kSEapyU1Wh3TPX/P98j1B1zcqHFnwTTmPworL46ZfXYg8iRPwxrnR/j0L/lsAOyZJT
         NIlG2hlfTvb3l8I5Nn/qjopagKiips/QN9JKMgXZ4A6tcJ7ZfUqpRkDVhT9ehxlpmK1h
         aP9w==
X-Forwarded-Encrypted: i=1; AKwUvBxc6GWIMMzHR8ii0+FZ2m2qBHPB2XcZha62GIW7hD4Ks77mYDEhHEKIgm/0yuU5Ad0Gmd3ORSfD@lists.linux.dev
X-Gm-Message-State: AFq9FYLqnlg82vV9JPV/OUgOFYuB3MWstD4z/9NNHjglA063oNL1FF5C
	et87HYEIg+aGecBquav1FKknBn40QHaukoLvO8M1TJEiakgEll0e5h0KBNQZtwZL2A==
X-Gm-Gg: AYBFou3X5hkNkcTgvltNn2hOtH52tDMn/EiO39nUAtk/QAXryeJqa6bKcu7NBu3Xvrj
	KL+8YJiXM/W9RFo2rFOUFCZB/qQZNkva9iR+8KKPkkjy4BktrG/rH3JAWoonWaqWURFALeZdIS1
	cLcw57N1vwBOO2KWKLWQ3UOlDN9vx76FSLi35fS66/BUa9dtFoaBZtsD3Aq7c7oEEKehKU2OCte
	zHj3W4HVi6Fi75Ooh3R3KZf6F6Wqr48JkmQGE7qrf0HQOUohot72QnMJe0rRP1hkzC97pLpzCGn
	wMBPIuaJ+Rr4BaY627jbAsNNT6shR0qho8zeihzeytiRp/5tvApikztVFeFLz00Y3K/JSFE5UPZ
	IIGt1rzhH9lL5/SU+3dDBHxgQqUFsVdz4FraSe7K9/2+od+3rujb5aahGOXw5CDhQ7RfCOGClgc
	jkadJIyQLFLWOWWrPhvwGTohmd7kFa6VWu06TVUjzlCvc3kQ+sznID8LHryoVTJ6YXXhOP8w4mM
	fh2I6D72+QLofXfDUCXw9Lwe9FtZaRT+NIK
X-Received: by 2002:a17:902:f707:b0:2c7:f688:f22f with SMTP id d9443c01a7336-2e2c79fbdd5mr691405ad.13.1790636627971;
        Mon, 28 Sep 2026 16:03:47 -0700 (PDT)
Received: from google.com (105.211.142.34.bc.googleusercontent.com. [34.142.211.105])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-87feac93380sm4714358b3a.33.2026.09.28.16.03.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 16:03:47 -0700 (PDT)
Date: Mon, 28 Sep 2026 23:03:41 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: iommu@lists.linux.dev, "Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org,
	Robin Murphy <robin.murphy@arm.com>, Will Deacon <will@kernel.org>,
	David Matlack <dmatlack@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>
Subject: Re: [PATCH v2 1/9] iommupt: Remove the sanity check for
 pt_num_items_lg2() at the top level
Message-ID: <arryTf6sRapjC1uW@google.com>
References: <0-v2-563ee63886f0+1209-iommupt_armv8_jgg@nvidia.com>
 <1-v2-563ee63886f0+1209-iommupt_armv8_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1-v2-563ee63886f0+1209-iommupt_armv8_jgg@nvidia.com>

On Wed, Aug 12, 2026 at 05:09:17PM -0300, Jason Gunthorpe wrote:
> This was ill conceived, the existing formats work OK because they
> happen to support pt_num_items_lg2() at the top level. However the
> documentation is clear that is not permitted because ARMv8 has
> concatenated top levels and we do not want to calculate an exact
> pt_num_items_lg2() for the top level special case.
> 
> The logic to compute the number of items of the top level is shown in
> pt_top_memsize_lg2() which is:
> 
> 	num_items_lg2 = common->max_vasz_lg2 - pt_table_item_lg2sz(&pts);
> 
> Which is pointless to try and sanity check.
> 
> Reviewed-by: Mostafa Saleh <smostafa@google.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Pranjal Shrivastava <praan@google.com>

Thanks,
Praan
