Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6F962264A9
	for <patches@lists.linux.dev>; Mon,  4 May 2026 21:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777931329; cv=none; b=ENmaKOerHhWyX5mGhk073qxkkBfhcPoul11dKW/8Hj77lvpwFxf2/4a/9p0HcOkjSyjncLixFNH9/DItgKmSTAQyQuBC3HbPpZKcLTVxefaeMfp7IGDy67q+USnxJxgZ+QvGqtcUZIPwUszdie9r3NVtg2jiviCeYLxtWtlwlfI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777931329; c=relaxed/simple;
	bh=LEfOvRpQYcrDqT5+S4ih49Shh2djX8a2POcizZgtyEE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=gPcS2S8Swk1kQHtBN5AD2/4Ftj2timGVRTvoq9nlD2Fi78kDmozafx9V/yvf0HnrZ3PXcvKmiVX3HY2XbPfYiB/qOycxMEwlgyjdWNoml+Vai2ycul4qXFWr2JbrKnavLQKs8g7kCdYp/AjzOJdP7aLTcrncS+44rV3a40YnL6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mUlnsh1Q; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mUlnsh1Q"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ad9516a653so20680415ad.0
        for <patches@lists.linux.dev>; Mon, 04 May 2026 14:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777931328; x=1778536128; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=vleGyxmKxeO4GNIP1qujBMrg4IEFuG1bs35WPUgfDlk=;
        b=mUlnsh1QiuCdaarp2QsO9iRJ0dCMnPov6YuU+xrG7P7tOSPdVxjw+9ukY/JALsZQSX
         Q2as/N/vD5OPuSl1/hQD1u2eYMVZvnUjwCDBBX/g7YdkAVObyzFP2KXL+mHEULDK/Wv0
         YZ5ywt1dVcVn5RoFyZGtakYFBoXkqxoYhe9aetsUJBi9qH49kqswGO7CJBhkFj4buNKf
         reeYgffh9WFRW+rQ5xZ633TQfoZ3ac/E1PIFuGUclUmithiKMBjbMSZxa0xJozB4zTOC
         mwIoPudboJ0o6HbCup5JsYmP5ljQTt8j+PctbneBTpCPGrRMUvdYVp7TVzo+zJqNkrdX
         q5+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777931328; x=1778536128;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vleGyxmKxeO4GNIP1qujBMrg4IEFuG1bs35WPUgfDlk=;
        b=L++zNncyi0QUOIXo71PKsPRCxsVhcVwVVl5tJ/FD3AqS/Wxa6ErTP6UcYLm5rixr1Q
         s//YQF/2gecj5ZbpsZSd/tBGNhL9yG6INxcJd4OkHdWV67zB8ocb46T9mywUwS4x7BYa
         ULVodMTOIQC8Yt2HhEx/WE64IVMIhaZ8R+rzq1M76FqxDUmViZQPCWmgfhEyZOaS0rtl
         9qNKfd6xRakKbNcXrUONH3x+f/emn95G8EoaBIm6n645GIxUINfTl2TmY/IU/puKrHaM
         zIMi8qvhSlakRjwONtuChm/IvwJddyizA7+mP198g5pZOy4G2HDaJ+kieDxOIhxwJVZR
         SfxQ==
X-Forwarded-Encrypted: i=1; AFNElJ+ohvD2LI44SSEIlEkSp7tJCvStBTOa5sh3iomNUkXpB30ZFDSKofQSmAkOXMUZp2o4XXoVV3mL@lists.linux.dev
X-Gm-Message-State: AOJu0Ywh4HrRXdZBSkoCo+02qqPoMpN5YRZBz4tASUKYvlMkZoh8q7jy
	chpd36XlJS6TknkL5Uf0JDP45MoxcUP3Mjc048uOxtHO/tSxnPtQsx3fvO3UctBeog==
X-Gm-Gg: AeBDiesaFilED7Q7EeN/+sfI86x6gTLC8YvJctQFbnJqRgbVAYYYKLMXLIrgjeKLxez
	hc15RdX4KLpVDY4jg2m4FtXHHoNuMBUYRYccs+/KRPp5j9dWYonVJhpnhSOooWaryoZ9JwjcGGZ
	9mnX8/+thAlCqWr0423nEc6s9zR7ULeNCoRmJOmnQyxzYEE5Wz9k1jDomTPRNj6wSDImYGOznBo
	fxyBJbR22Wi4DOPbr+ZTMO8eEqmny3nbLibT1bvgbPLvKyinZfJhMmjKtleR886e8+jbMYEB8Z9
	aqjcUDhu2Ksv432C7ISqm5dzWaXEPMMNNMd/3biRY30tOO3fjtO7U4md7/6lCZHt6v9ObNAM2WE
	0yf7rXA9tUoBYlTWnntp0aMvHTycsIg0CAsf/zn7xFobkMdF02iQ9sflx6JVI4hIcZxxKkrhVB+
	CxbS12cik9L5sWbIQi0m4ihGyxBihbrBvqTusuEhxKawhxzqQEQGvJKlSPr0JJybGunTQiho5TG
	DwI7Q==
X-Received: by 2002:a17:903:40d1:b0:2b0:ccad:de1a with SMTP id d9443c01a7336-2b9f260b4a7mr121673915ad.30.1777931327578;
        Mon, 04 May 2026 14:48:47 -0700 (PDT)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b9caa7ebc6sm115903505ad.5.2026.05.04.14.48.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 14:48:47 -0700 (PDT)
Date: Mon, 4 May 2026 21:48:43 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH 05/11] selftests: Add additional kernel functions to
 tools/include/
Message-ID: <afkUO56H6KPy5afA@google.com>
References: <0-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com>
 <5-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com>

On 2026-04-30 09:08 PM, Jason Gunthorpe wrote:
> These are needed by the VFIO mlx5 selftest in the following patches,
> which includes some headers from mlx5 and also needs a few more
> MMIO-related features.
> 
> - DECLARE_FLEX_ARRAY in new tools/include/linux/stddef.h (wraps
>   existing __DECLARE_FLEX_ARRAY from uapi/linux/stddef.h)

Is this needed? I don't see it used anywhere.

  $ git grep DECLARE_FLEX_ARRAY tools/testing/selftests/vfio
