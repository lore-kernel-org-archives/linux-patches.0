Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E761D90D7;
	Thu, 17 Oct 2024 09:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729158577; cv=none; b=RE3j2zdtHpPMjv2Hfs2Y1jrKTE7zEE2ZBTWBloTDCtQap0xJgvY2idAUy0zIHjexjQVBvGrtZx2mZundURrSge/uC0IIehl9J/9cw0y2p3PVxdKqrDG6M5XOoZraNODnU2kL01fthVqR1znwqjQ0RMaL+QRUcMgZMHzyheQbPiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729158577; c=relaxed/simple;
	bh=z/F2MI8fJpqIxQIRSNsvFyR44a7b1hC6VMiYylMi29I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ORznlIq51Uk4MJMusNb2xyZJS3MwxUfgLHzRQ/uSf809j+4PGUsniYBLY41Iw1udPDqdGP7H4hIbIguygQNvbCjmU60q8mD+hnXNu/zq/A+sVLsv1aZrRaqwjVMGNJzDFzy+WELzWVoGd0z/sSA9Vt9aoHeUTWuyVnZjsTPMbQY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z8u8Qftg; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z8u8Qftg"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-43124843b04so7386935e9.2;
        Thu, 17 Oct 2024 02:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729158573; x=1729763373; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=KPwVb1k8I7eied9SbMlFcFAKf9gbOM4HZoWgmX8prLE=;
        b=Z8u8QftgMb/0/IqEyYIc4OKnCIqlDHqm6o7wuqm3CuVlMcIvloMXZXTDMk34JofEwK
         fEPsNNFQb+fi0wYCQL+i01YU51hUX6t1CTvETPEgbv29M60a0r024ppA1ZkI8Tv+TbsI
         GMLhmZqVX7XuBhS0TyNXfLaDAkSaJOnapWGQg4ARexUDX/MmlVbH0HBONloWO8P35Qte
         fpcM33pKys8c7b9zvLwzJzMgwboaAWNob5vWpN29+Vgdu4it5ZK9W4qQomQJzz3HO3Um
         JbwqRlff7bnxKQkoFxC8kcxwF5dhyw9rqMjCREDlnL3bmg8Sjb6ukkKoxgow9Ky4IGpP
         SJsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729158573; x=1729763373;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KPwVb1k8I7eied9SbMlFcFAKf9gbOM4HZoWgmX8prLE=;
        b=QFectjPjLwx090EAY+KQwmoISkVCKSttjhBcT0sUlSkn9TwzDxxw5z/kINT8GqERN3
         8MiE6v0YUF4t5PAFjLU4Ud11dH/5r3g3y8dIVwDoePgKB/v0x7RNjbjot7ju3ZiQR6Ta
         uhCItX9nJAHuSN6yzN2GqMRP//nz12oxxpDKFmskmuR/pAD51eND8Rd6+5lqBSYXRydT
         KdoivTfftV4fVYyD4JJvRhYfrnKUuowm8O8PG0Vn959IiohiX60Bdqv0GooqYui8ljmF
         Cu/0AUViXnVysASF39LL7+EPvKNKw8tz05Wi3vASWTQcN5QMFgiEO64R1rXJaRfpsj0F
         QQRQ==
X-Forwarded-Encrypted: i=1; AJvYcCVAcA5LEVLty+GYpXe2xOMthW1kcG7ODzOJY1G6rQNK/cocQRcENeJgemE8NC52OnCeXMtyvg==@lists.linux.dev, AJvYcCWLHw+CkR1vQ04QGAaZFIVmJXQ5Cl7U29bdvYK7zZmcxbx2ZoRU7vsP3MN1koEdChyfnC86dU70DgVKo4n6@lists.linux.dev, AJvYcCWrV/0ndzQBjRzCUPLGnNNKzTToip8satPi6dAL6kX+xkPVokNI23Qsla9NmKCNYh0BodF45IEzqg==@lists.linux.dev
X-Gm-Message-State: AOJu0Yz/aSe9VzUEqaih73fyQ39kUUAANc3ny4Ub+W5umzAzmbYTL6Gz
	lnNKNaPxsngQGQaFwnrfQ3t7F6F6pDCj53d8G+v8fc+YxZC4Y39F
X-Google-Smtp-Source: AGHT+IFt0cUHCZ5ahYEs2fXHKE3pWSiUyy2TxBbRwORmqH/LcJhpso9UdkuAPEog5QVZtRGBNduh0Q==
X-Received: by 2002:a05:600c:5248:b0:42c:ae76:6cea with SMTP id 5b1f17b1804b1-4311ded433dmr188579435e9.9.1729158573240;
        Thu, 17 Oct 2024 02:49:33 -0700 (PDT)
Received: from egonzo (82-64-73-52.subs.proxad.net. [82.64.73.52])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d80620ffcsm6642036f8f.82.2024.10.17.02.49.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2024 02:49:32 -0700 (PDT)
Date: Thu, 17 Oct 2024 11:49:30 +0200
From: Dave Penkler <dpenkler@gmail.com>
To: Nathan Chancellor <nathan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-staging@lists.linux.dev, llvm@lists.linux.dev,
	patches@lists.linux.dev
Subject: Re: [PATCH] staging: gpib: Fix PCI header include guard
Message-ID: <ZxDdquqB76HJCaI5@egonzo>
References: <20241015-staging-gpib-fix-pci-header-guard-v1-1-dfa45fe8d63f@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241015-staging-gpib-fix-pci-header-guard-v1-1-dfa45fe8d63f@kernel.org>

On Tue, Oct 15, 2024 at 12:55:33PM -0700, Nathan Chancellor wrote:
> Clang warns (or errors with CONFIG_WERROR=y):
> 
>   In file included from drivers/staging/gpib/ines/ines_gpib.c:19:
>   drivers/staging/gpib/include/gpib_pci_ids.h:3:9: error: '__GPIB_PCI_IDS_H' is used as a header guard here, followed by #define of a different macro [-Werror,-Wheader-guard]
>       3 | #ifndef __GPIB_PCI_IDS_H
>         |         ^~~~~~~~~~~~~~~~
>   drivers/staging/gpib/include/gpib_pci_ids.h:4:9: note: '__GPIB_LINUX_PCI_IDS_H' is defined here; did you mean '__GPIB_PCI_IDS_H'?
>       4 | #define __GPIB_LINUX_PCI_IDS_H
>         |         ^~~~~~~~~~~~~~~~~~~~~~
>         |         __GPIB_PCI_IDS_H
> 
> Fix the define to match the guard like the note suggests, as that is
> clearly what was intended here.
> 
> Fixes: 6c52d5e3cde2 ("staging: gpib: Add common include files for GPIB drivers")
> Signed-off-by: Nathan Chancellor <nathan@kernel.org>
> ---
>  drivers/staging/gpib/include/gpib_pci_ids.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/gpib/include/gpib_pci_ids.h b/drivers/staging/gpib/include/gpib_pci_ids.h
> index 162b02deb0ade7ede08ad81ebd41a79727374448..52dcab07a7d188925a4d696d6b658f397f3b0153 100644
> --- a/drivers/staging/gpib/include/gpib_pci_ids.h
> +++ b/drivers/staging/gpib/include/gpib_pci_ids.h
> @@ -1,7 +1,7 @@
>  /* SPDX-License-Identifier: GPL-2.0 */
>  
>  #ifndef __GPIB_PCI_IDS_H
> -#define __GPIB_LINUX_PCI_IDS_H
> +#define __GPIB_PCI_IDS_H
>  
>  #ifndef PCI_VENDOR_ID_AMCC
>  #define PCI_VENDOR_ID_AMCC	0x10e8
> 
> ---
> base-commit: e0eb7cc4d70d672cf9344916aba58136fd6e495e
> change-id: 20241015-staging-gpib-fix-pci-header-guard-997bbc923818
> 
> Best regards,
> -- 
> Nathan Chancellor <nathan@kernel.org>
> 
Thanks.
Reviewed-by: Dave Penkler <dpenkler@gmail.com>
