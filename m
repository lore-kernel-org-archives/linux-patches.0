Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A658614B06E
	for <patches@lists.linux.dev>; Thu, 16 May 2024 15:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715871892; cv=none; b=Lp0Nn+s/7q9eLbEfLrAJoJozOX7FRpDBMIM3igxzdB1BV5qFmreoNaXH5FHgAM2OHWqubePfd5alS/y3BJYPDW813o5rmrsmbKJoxfLUntFSgi9Jh6ekln0xwIzbELiPBFvGvBcaztjrPwN3+iD1nj8bMq0+LWCyqxScygoovH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715871892; c=relaxed/simple;
	bh=1yLuwr5Ny+Gy2jE6b4j91jagshOW1WAMTqW/K2hryZM=;
	h=Date:Subject:In-Reply-To:CC:From:To:Message-ID:Mime-Version:
	 Content-Type; b=Ql/tEqFZFlejy3bjuRC+8d52uLtFofGwsjx7vXX0EJ4+NvVF5VqUkmUxnGZKKybgQ2krgRT3e3O6T//qVs5fCIZUMZXWZHabNJbmJameylBm1ykjM4bWGRaWk8cofKwrY4PIo8S9B6Md/Mbsq9MPsAdNZ58fV2tURxAqzpZoWzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com; spf=pass smtp.mailfrom=dabbelt.com; dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b=yTdlCNFM; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dabbelt.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=dabbelt-com.20230601.gappssmtp.com header.i=@dabbelt-com.20230601.gappssmtp.com header.b="yTdlCNFM"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1ed96772f92so65180475ad.0
        for <patches@lists.linux.dev>; Thu, 16 May 2024 08:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=dabbelt-com.20230601.gappssmtp.com; s=20230601; t=1715871890; x=1716476690; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5tFCjyRy326EuMyapGXcH9cbJEkf5Ts4nwZLLLeQ4rw=;
        b=yTdlCNFMLGNVBj4SIQUvIhttutCM55fXrZ0YquYwVm/WG8FmT2cIdSAze6OF0+VDTq
         345gOBEMAp6IxRJTuxOLmVyz2ej6IdqZSirZD4CRe+vFyJ3ZJo9IjWQq0LYGXB7yYoPu
         9baha4IFNAHum5tP8T/UX02Ms/GUHYQzQtNPCiP+NCqEoxu1l/3RTC1Nhw+zKZjuJocH
         kH59BlG+ohwLECZXgCUDirGGkboL5T9K3eiNIH0oWd2rBk9VDCSFh2XMCU6hGpVuX6de
         SLbizWqRyPTOj0Xv0WU/Qwiwk+WZyN8H7DC8nXQWE2kK1Rsa6cGJhseivU/T1xgEVj+V
         ay8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715871890; x=1716476690;
        h=content-transfer-encoding:mime-version:message-id:to:from:cc
         :in-reply-to:subject:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5tFCjyRy326EuMyapGXcH9cbJEkf5Ts4nwZLLLeQ4rw=;
        b=EYKefXkzM21z/5kJ/k3N2XaSNrYjZg6oRR6yMwcuYdfLo+ZHeGGI0DB8HtxoZ6Tghc
         A3iAV7XSNG6bAdFJBpR8v3b1O8AzltYk+o6qxd8rz2h/rvCYRMVlnv3Gidi5FX1dffxA
         sPuMjg03hwnebftE99200/y/BUObNMfhZoLZJsnnkT4E2r2/DY1C8hpi1784keKAvHCp
         UCcpmARe4X+nIAyRPz9MFD1eC6FIl2gGzDmq/K9aYWcR5w/kLhavz7/L60spgS3EGUHb
         J1pFOm8Knj2+14GqPK2AHt1z7JJKYO9/FjQmHFaSAoUw7ypALd+Z7nZ3qGthVM/5e7GD
         ekfw==
X-Forwarded-Encrypted: i=1; AJvYcCVIy9L2NWyIXdCuggn/sSQT9jPPeQ9PJ590KTT8dJ+6Dtr8HvqB0jPvDg0Xehdpqs5LTYQlvFRy1nwTwECTlSL7YEdtiHQ1Kg==
X-Gm-Message-State: AOJu0YzAYGIM81mG+0GGADXrqJGrCvxa4Prp4cuaDeNRaE2lAK9fVjdX
	8Vj7fCFZBap2dJn9ZnsPiOSf+enkRrW0YQfQtkpv+OL4au6yWBcf0uA4ce1sat4=
X-Google-Smtp-Source: AGHT+IHyr+L3kQts1mekEifNWiW4+PjiSNLgehkncSk5asn5KHFcaUVhYB0qIAyAQvaljXMM2Ch1ig==
X-Received: by 2002:a17:902:6546:b0:1ea:cb6f:ee5b with SMTP id d9443c01a7336-1ef43e2796fmr195159345ad.38.1715871889708;
        Thu, 16 May 2024 08:04:49 -0700 (PDT)
Received: from localhost ([50.145.13.30])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1ef0c2567ccsm139617235ad.301.2024.05.16.08.04.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 May 2024 08:04:49 -0700 (PDT)
Date: Thu, 16 May 2024 08:04:49 -0700 (PDT)
X-Google-Original-Date: Thu, 16 May 2024 08:04:47 PDT (-0700)
Subject:     Re: [PATCH] scsi: mpi3mr: Use proper format specifier in mpi3mr_sas_port_add()
In-Reply-To: <yq1y18bry3h.fsf@ca-mkp.ca.oracle.com>
CC: nathan@kernel.org, sathya.prakash@broadcom.com, kashyap.desai@broadcom.com,
  sumit.saxena@broadcom.com, sreekanth.reddy@broadcom.com, jejb@linux.ibm.com, martin.petersen@oracle.com,
  thenzl@redhat.com, mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
  patches@lists.linux.dev
From: Palmer Dabbelt <palmer@dabbelt.com>
To: martin.petersen@oracle.com
Message-ID: <mhng-c0ff89cb-4699-4ff6-b0c1-a71fadd710f7@palmer-ri-x1c9a>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
Mime-Version: 1.0 (MHng)
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

On Wed, 15 May 2024 06:42:12 PDT (-0700), martin.petersen@oracle.com wrote:
>
> Nathan,
>
>> When building for a 32-bit platform such as ARM or i386, for which
>> size_t is unsigned int, there is a warning due to using an unsigned
>> long format specifier:
>
> Applied to 6.10/scsi-staging, thanks!

This fixes rv32 as well, so

Reviewed-by: Palmer Dabbelt <palmer@rivosinc.com>

(don't worry about up the review, it's mostly here so I can find it 
again if I forget)

Thanks!
