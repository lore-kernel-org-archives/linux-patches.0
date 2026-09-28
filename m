Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E63B4A92F9
	for <patches@lists.linux.dev>; Mon, 28 Sep 2026 11:34:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790595253; cv=none; b=oeXhf4PKlTvK8yFeLQiHL6YT6QGJd20TBTJYUK9bUW57TDRIT49Om/E7PcGFDVzWGTruo7iZnmEgFdKGjzDW+LZ/1oHI/Igckd8JT2kr+zHHVTn/Axvm2hctUTAHwIev7id1geWB3XseBouWlbzthRvWU3CBi5WkxO/ABW/mhfg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790595253; c=relaxed/simple;
	bh=Jt7kPh9XkqywM/6h7nDHDZz6YThHu04q3E5/FsPi8vs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rp4i8kIYGMwtErQK66RRDIxJHB2DkdMTwBT8NMG86E6OFvy0Oep3m2E3cng6I4+IzpSGNxUeGcLZI945XeD9nObJlpUY67MizjKFL+UZDTcwlsZXv1YQh2sku4Wn6/AiDO3GhnFViXTrHyxXXd+yuKggjyFe6LlViVzN8KunZQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=iLfw62dF; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="iLfw62dF"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2d8fd7a3f38so67605ad.1
        for <patches@lists.linux.dev>; Mon, 28 Sep 2026 04:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790595251; x=1791200051; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bqZIT4CuwAtsItk7lmKS5Bq3DdAgNyIdg2q2F0jacX0=;
        b=iLfw62dFtaB57AuLygdspTv2YK73OW5lPf4P9rFNrk4zCTCfwPqi5zfWZpcH7KsVue
         1IJaA42qx6X0od9lvtWZwOCnjfwxhuxywto195l/4u4YOKDydCUz8EaYbf1cah4yvQ2M
         uysmgMuAP841ut3idQrkQwvni+UZniU7q3Q9x19+OW93JXomtV51ELu1kbkUSp8+xcyy
         wiqqpvtHP+oWmAl1zbEuzG6SEfapKaSWVNC7HowEuoNCvbx0wP5PhOjf5rdAFLL+LfRY
         o6Lq4Ygpo4iIYPmO8YIjm+5Em7lPavEFzlNWeQxCqfe8WlnPGxyKJjrbqRgFP64Prs7S
         9cmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790595251; x=1791200051;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bqZIT4CuwAtsItk7lmKS5Bq3DdAgNyIdg2q2F0jacX0=;
        b=ptNQTNtSvkEjBZpLZ2NWA5LOu5n7fi1qcZC4veRCOya+IlS53HoLcJlXf3GY4wiTi7
         NJ0HI0/grmFfJEgT3+VIPXsIigXecl0SM3JfIvKx+eij84wJI0GMgwvKmy3rHR4mdkLj
         1bu0Ebyv6hzRLySdzc9x8XDU8cPW4xJEpAWQwbUBYvsHNW3BoXli6BKF5vj+UtZjmgBC
         23PXDrdJlTlKkNlGlxyZ2HmLsYuebYvy+Vl6KpnmiUf0l35gf+fA2hyp+4AyIEbfolCm
         SpHTrgJJbJwAwqbxAs56SfOJ3xs+79926rLf0yu3XHn0L8scukityBqsaZKaJrtYQ646
         H2Wg==
X-Forwarded-Encrypted: i=1; AKwUvBx1BWIYp5zVO9PRTKrJYAuyWN/PxQ/ki3NPH3fO3gHfgz4LcS+1RCwLvVGQol8B3+R77ij1MiZ2@lists.linux.dev
X-Gm-Message-State: AFq9FYJHE7uUInJK0NS2szHXNsUKHSh0EgglpnIt7JCBK3YldH5NjKv6
	5OBGXewoZlcihICYf4hNGOLHe3QDBDuLdjfSrC8zp8zAShMuRuF9XzCpTmxhbbUCNA==
X-Gm-Gg: AYBFou3M7k7tcXwpLV/2ln/brc2nxmrUtY3T5D5S9wlm0jWoA/ovel1yMgwLGOS0+eR
	HAEKZMYED7WPqrc5ebM3bd32czUsO7wYf26pwNQ+g5e8+P45ZnLs3GUuY6h7qENTnf9LkoVpMG9
	uT7KH0bq9CfnP66Bm/4iQql68S5vY0MK9mwwDhosbOMqaZyxze1e+Q/PvK5emv5jK+i/b8yssXo
	+ort6TRMvYsxZO/uPJ6G9rp2+GndjOmgSpeTc9T5hQD/1pgRTZX4zs2PF9g0ACrmtHyXSFnPoxd
	fjb+Q7jMrrGb2yvjsUSmX44h5ipUCd2kvnlhvKfeFKQeEiFEqUDUFBO+7QO+/+aNN5a497R883X
	5MjR3DGFNHYNSUyI5LXVh01Pc/pgHdKNfaDzHp2H87ceF4fk7vB5kYZPq2gY7l6nB5PI/Nxr8TC
	lC/46yHERJcuc5NbbBy6OKtb/dZ/QWrifxwiKadsDpxGMqn5o5dxa4J5lT/ku/JuP/C6QfQrdad
	IeI7vJ97jl8Vkd87JjT3Nlo9wvwNNPxGjHC
X-Received: by 2002:a17:902:d54f:b0:2d5:c090:3810 with SMTP id d9443c01a7336-2dfa615a5b9mr4545925ad.2.1790595250807;
        Mon, 28 Sep 2026 04:34:10 -0700 (PDT)
Received: from google.com (105.211.142.34.bc.googleusercontent.com. [34.142.211.105])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0972f111csm26688235a91.2.2026.09.28.04.34.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Sep 2026 04:34:10 -0700 (PDT)
Date: Mon, 28 Sep 2026 11:34:01 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Catalin Marinas <catalin.marinas@arm.com>,
	Jonathan Corbet <corbet@lwn.net>, iommu@lists.linux.dev,
	"Joerg Roedel (AMD)" <joro@8bytes.org>,
	Jean-Philippe Brucker <jpb@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-doc@vger.kernel.org,
	Mark Rutland <mark.rutland@arm.com>,
	Randy Dunlap <rdunlap@infradead.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, David Matlack <dmatlack@google.com>,
	Jean-Philippe Brucker <jean-philippe@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Nicolin Chen <nicolinc@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev,
	Samiullah Khawaja <skhawaja@google.com>,
	Mostafa Saleh <smostafa@google.com>, stable@vger.kernel.org,
	Vijayanand Jitta <vijayanand.jitta@oss.qualcomm.com>
Subject: Re: [PATCH v7 2/9] iommu/arm-smmu-v3: Pass the parameters for the
 invalidation in a struct
Message-ID: <arpQqQXkdkNRBn-l@google.com>
References: <0-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
 <2-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2-v7-e84261bbe7cd+2ea80b-smmu_tlbi_jgg@nvidia.com>

On Mon, Sep 21, 2026 at 08:55:10PM -0300, Jason Gunthorpe wrote:
> From: Jason Gunthorpe <jgg@ziepe.ca>
> 
> These parameters go to a lot of different functions and the next patches
> will add more. Put them into a struct to keep things tidy.
> 
> Reviewed-by: Nicolin Chen <nicolinc@nvidia.com>
> Reviewed-by: Mostafa Saleh <smostafa@google.com>
> Tested-by: Nicolin Chen <nicolinc@nvidia.com>
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Reviewed-by: Pranjal Shrivastava <praan@google.com>
