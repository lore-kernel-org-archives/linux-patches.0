Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32206360751
	for <patches@lists.linux.dev>; Wed,  5 Aug 2026 18:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785955026; cv=none; b=AOhLioDnAlqEd8eoOF/G04qmaazH8BHCIKmsLHVh6k+PBPp/T8WcTEyivznxHVrs3Sq/TpuW9m5jI+349YFuCql4rsa0rr3cr6/P0cbBf9FjY4YeOezLULZ4SCedAv0k85VLV25gN4C4vm+UKsZc3BPd8mSiGPXc5DaRJ1pcwBg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785955026; c=relaxed/simple;
	bh=Tf9syscAZW5PE8qDFT2Yh4y+Oi/xeH7ih1X/P3PhvsY=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PKRCLFE6XuUTTm+PiXg568zfTHwTFC643IvEANCAocWE5YDFKXtjxry2SpGIWdC+pj+9W3YGx5yKr4yXRdPfRPWNvMhEuICA/Ww3yYBZMOq/BSb4gjUP/Jsj0rGsZYPiDmMLZ5Pltfs8cKKdWvBrG05jvla1evjgjkEkXuzpfpE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca; spf=pass smtp.mailfrom=ziepe.ca; dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b=YhID0wqT; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ziepe.ca
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ziepe.ca header.i=@ziepe.ca header.b="YhID0wqT"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-8f18d92172aso12820896d6.2
        for <patches@lists.linux.dev>; Wed, 05 Aug 2026 11:37:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1785955024; x=1786559824; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Tf9syscAZW5PE8qDFT2Yh4y+Oi/xeH7ih1X/P3PhvsY=;
        b=YhID0wqT2ZudbnqUHhGCslZQ5fqx1ozxOebpbEYDcdCLIMwqH9VX83TIJXicapzUtz
         Y71rpkJO/wJGcPCugZs5Og3xvocBYxc4FA3RZJRs3z1R+u+xwSOF5hgWMFyZNBtUqHf7
         BqLnCqpjN1ySEsDOt+X9a8KdSOxJ8pJVyeJhPpKOkTJMfmTwDiq+gbfJuoHml9z0uT1n
         8e9M0fqmXyNzWQhMH5FaxcRo9GsGKa7VX9XWmq2YOBjnQsrRCxBhWODH+gXz9pqrhE7a
         eT9fuq0gYWFRw+OKtsReZbfARZ+9jCRD4ONH/hap+WZrpvS/LanNqj0k7kSDs0p/GszM
         NWlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785955024; x=1786559824;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Tf9syscAZW5PE8qDFT2Yh4y+Oi/xeH7ih1X/P3PhvsY=;
        b=AqV+CQUH/gOywr9n3rpOPJ89hmFP4SWKhv4f69uKo/LGUuU8aim2DbdUYUqSgaH20t
         +psIGqHju4I5kVjuJ3Wl6U/qy8fO+bi606kawmWRSwoIJhNsf3l0J1Tys3p3R4oVUQyA
         HTCAjeajQYz5yYfmvD+UJ0rOBmaxTfTVfhQ4GMeoQAiys8U7EpVC7Ejij8VPyd/a+Mc2
         Ilng8cTmsP5meZqRmIZ2fZAQ+PocR9flNA9kkM/Qh3DZy57v/OBJxnKeqOWNF/WXC0By
         mdanbaokT+Cn2HecfTYh/+z/qNAiAJQweQoVlcdEwbBIH59Ld035GCL3ECk5a5F5z/Y7
         UBpQ==
X-Gm-Message-State: AOJu0Yz+psAumwg5DktIRaYDBYo/jAkjP2gSN6VIEa6gapmfaxtg+gCW
	lM2jGpHsrZznf9RsatXODdDPron5FWoWTlT2fi4VdCK/Xgfld7G7/qqZPf2b229QusM=
X-Gm-Gg: AR+sD13+PJrx/nsk66u5eNwnFr9G9rUXe06Zb2S+3pBD72kH0T9xeWdp41zlq2zgNxD
	8bCwgwKl58J49DFKYLhAFmmCESIXEt6tGM+d9obryqiF/6nZGGzpiEYolh4CAruQOnyfz26UR7V
	aQQWdR/GJSfla3yxeOdmU8LEGoJdbVH2ifL/QesJQG4RbnjMS2XNUAB1PjUjMhULCh4DnyZA0J4
	/GlvB6rA1Ngz5QXPTU+HcxVcwb0LiIdwSIQhsvkAjCZHhkOIwYW4DmpjOm8LlZQDhLwr7dW7hwd
	GhsjcBuwglFhqBAaDlqg/D0/Eg4/H0LqKBIcB5I7uEpv26GVQfFVuA3E0eIr181zt/YgtkI4Ai+
	1zMbgpOt9bQ70o5Ih7RE9ve+kzQZ24MHJK0kx5as/0xapsSRIcA9S6GSodzmK0nshXAjYhaQMTj
	qXWkddFk7dxkuoyrsqtLNyOrt46deJePGRLBkSaA==
X-Received: by 2002:a05:6214:f08:b0:8f0:a849:f392 with SMTP id 6a1803df08f44-90881203d0cmr103220766d6.14.1785955024046;
        Wed, 05 Aug 2026 11:37:04 -0700 (PDT)
Received: from ziepe.ca ([142.166.156.215])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9087ff9d807sm31895686d6.2.2026.08.05.11.37.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Aug 2026 11:37:03 -0700 (PDT)
From: jgg@ziepe.ca
X-Google-Original-From: Jason Gunthorpe <jgg@nvidia.com>, David Matlack <dmatlack@google.com>
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1wrgUA-00000000Iyd-2zvD;
	Wed, 05 Aug 2026 15:37:02 -0300
Date: Wed, 5 Aug 2026 15:37:02 -0300
To: Alex Williamson <alex@shazbot.org>,
	Justin Stitt <justinstitt@google.com>, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org, llvm@lists.linux.dev,
	Mark Bloch <mbloch@nvidia.com>, Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>, netdev@vger.kernel.org,
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <shuah@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>
Cc: patches@lists.linux.dev
Subject: Re: [PATCH v3 00/11] mlx5 support for VFIO self test
Message-ID: <20260805183702.GA72896@nvidia.com>
References: <0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0-v3-76f117ad04f1+28a90-mlx5st_jgg@nvidia.com>

On Thu, Jul 16, 2026 at 02:03:16PM -0300, Jason Gunthorpe wrote:
> Add an mlx5 driver to VFIO self test. This is largely a remix of the
> existing VFIO mlx5 driver in rdma-core. It uses an RDMA loopback QP
> to issue RDMA WRITE operations which effectively perform memory
> copies using DMA. Since mlx5 has a stable programming ABI this
> should work on devices from CX5 to current HW. The device FW must
> support the QP loopback configuration.

David I was going to respin this to fix the minor nits, do you have
any more feedback or are we good to merge it ?

Thanks,
Jason
