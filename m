Received: from mail-io1-f48.google.com (mail-io1-f48.google.com [209.85.166.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9419E155335;
	Wed,  7 May 2025 02:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746585445; cv=none; b=Mwgux7heQdxgZmRIRihmtF4KIHqcs5UJbwtNrC47yPzMaCrfvYRS0R2FFnAs55ypVcHPKV7xyCCqK2txJTqcYzV4xOIbX/CPEGmpnILdNigBI/pDgZanPd9NekD9+bdpAXVpFPnLgxCnFREbIdEsEEg4VlxrKU5SMr3q50zAS9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746585445; c=relaxed/simple;
	bh=gogz/kwTzl09lyXYhB0+fHtcF7vMgDw89ax0lZlRJFA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J5yBZWPq+xfGGudPHIkLr1qPMEl1QjIgop13oEITTmQCesZgPg7FTw6b6oeb1fgZRRyy+tPfqTFpcB3DM7imbyRsjk561Ys6tx/RN9PRyWgeT25SxsRj/ltA61nvFeB7tiunqPG1TiSdFt22vjeOSM+JJEkXP1x0Ew1NM2L0S6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bd1LgG3H; arc=none smtp.client-ip=209.85.166.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bd1LgG3H"
Received: by mail-io1-f48.google.com with SMTP id ca18e2360f4ac-86135d11760so515502239f.2;
        Tue, 06 May 2025 19:37:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746585442; x=1747190242; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YqUzVFahOTWkOm+5toR1pBXsvwL7tjqr3UlY9YuFPvk=;
        b=bd1LgG3HKReEalhAhr8hNZEG0HYGh5aSyJ5dcXC08srh1Jl+DjOpVflyVcuMY+QXzG
         4MThMFzsUyFxYS66MnlnPCeTqhlovcmddz7K4mN/DkkDVXHMMab8nxjxRTKwRxcewg5d
         jKMKKaqdPqkdXYpmKyGRet0NkZjo5DSuI6p4TfsV8i0RC+8XArdseobqbwJzGOe9w+aB
         SDraEYOvZh39vBosKlOdmJpuxyZD+XC/R516T6yBOfA1Wq2giFVCbVcjafv+Fzy9FQMZ
         o58ZzRQ6jH7X+zNGeze6EVpjrSkpdk1uuvvCs2JTJ+LuXVsObvVH0ZZhEr1JMbrL01D2
         N6ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746585442; x=1747190242;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YqUzVFahOTWkOm+5toR1pBXsvwL7tjqr3UlY9YuFPvk=;
        b=BMTfj1CpYgct4iXEtUt3lpCTFEur8fUoyxfNJeDuwW0laXu0kAQVRzEo5A0ai2H1xb
         O2flMB7quvRbeHZ9V54mte7vIZjq33wwRhgsAVxbJeYwaR2AVEPi65gGS1BSAWFAsa4v
         qRT8C1WKnBe4vrJnTkFuT9c/J6b7HG8iYF82fKaPi6SZp+cuTIEhuOSWvDj3oJhiYwra
         5lrjiFCX/zM65rYlnKkqMfRjIHsNNayR9NunUwWhZN+74BaMe7Tax4CBr1evhV03VN5X
         5Pbd2OAB96NdajH5f3rrsl4tRZPl9b9qM+Ltg75Sgrd0QexAhJ/yQ2scd3pVASkdRxH/
         pf6w==
X-Forwarded-Encrypted: i=1; AJvYcCUCiskOLT/AFCqVJvlNEt/IVQBYaQVLdq5T4TQpihvJiZ0CMZF3kdfR/Iq0DFR9Wbd1NBanG8xsow==@lists.linux.dev, AJvYcCUNM3ye3/TpSV82KU28MIkGSjsOlNKWRWOdaHhiaIcetisMrQr65CxCAfyBHdLY2ICJy3ED9A==@lists.linux.dev, AJvYcCViYx2cWw5tu6B2ngMaLBRivIlDPq86zElSWujiKxSkm/Cc0sTh2XHqYvBuuNVzGiw8NiEsTg==@lists.linux.dev
X-Gm-Message-State: AOJu0YzP4cdaJTWTh1k0xx9Y+cy1VqmcpQmdNCadJpKdIW7/0PsSgb5x
	dZkSmzLZoAflUa40ocVFrCUIIrAolI/MCSWpBR2U1B5oGGzkEw1y1zfFNQ==
X-Gm-Gg: ASbGncsvT/w9acjUdYxbgAYzt6UDRlbTbKpZNmL9j+95R9d0jPifjdHKePDfxtz3v5t
	MOsJSo/HhFzzOqZ/ClozNvK1z6CptkvSMl1pecHPJKnUf+c2IEVuo54FvhFzhqlYaDP7pXAZ+4t
	EoFyi4ihQRp9SYhvtszH0sJZ5+XNYPp4slkOppUw4QPI7Kyr9rN4LYGD+cZLrC6CRbMDOTaezb2
	8ziHxgOssbDUI8MEqaCZND2goLHMusXEqouC34uA+HUOClb4tPSyWMOenIOIfT7eGuXhYwyIa7q
	0j11IeBGOxRrEXqSxVx//uLFRBDaQq7FJ4XSqbzA
X-Google-Smtp-Source: AGHT+IGAGS5jySCLGYRIxZ6mcudp65e4oJqBqIYNLeIsf5XVwvZcmPdxBTh5M0+mbZlZhv0ROYBp4g==
X-Received: by 2002:a05:6a00:4c07:b0:73f:eeb:84bb with SMTP id d2e1a72fcca58-7409cffb1femr2113575b3a.19.1746585432232;
        Tue, 06 May 2025 19:37:12 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74059020fb9sm9790293b3a.114.2025.05.06.19.37.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 May 2025 19:37:11 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id 41BF2423E4D9; Wed, 07 May 2025 09:37:07 +0700 (WIB)
Date: Wed, 7 May 2025 09:37:07 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	iommu@lists.linux.dev, Joerg Roedel <joro@8bytes.org>,
	Justin Stitt <justinstitt@google.com>,
	Kevin Tian <kevin.tian@intel.com>, linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org, llvm@lists.linux.dev,
	Bill Wendling <morbo@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Miguel Ojeda <ojeda@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>, Shuah Khan <shuah@kernel.org>,
	Suravee Suthikulpanit <suravee.suthikulpanit@amd.com>,
	Will Deacon <will@kernel.org>
Cc: Alexey Kardashevskiy <aik@amd.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>,
	James Gowans <jgowans@amazon.com>,
	Michael Roth <michael.roth@amd.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>, patches@lists.linux.dev
Subject: Re: [PATCH v2 02/15] genpt: Add Documentation/ files
Message-ID: <aBrHU-OGbfqk1DSq@archie.me>
References: <0-v2-5c26bde5c22d+58b-iommu_pt_jgg@nvidia.com>
 <2-v2-5c26bde5c22d+58b-iommu_pt_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="zxkMD/BAbmzfsfUI"
Content-Disposition: inline
In-Reply-To: <2-v2-5c26bde5c22d+58b-iommu_pt_jgg@nvidia.com>


--zxkMD/BAbmzfsfUI
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 05, 2025 at 11:18:32AM -0300, Jason Gunthorpe wrote:
> +Since each compilation unit can only access one underlying format at a t=
ime,
> +code that is intended to be generic across multiple formats has to compi=
le
> +itself multiple times.
> +
> +In an implementation compilation unit the headers would normally be incl=
uded as
> +follows::
> +
> +	#include <linux/generic_pt/common.h>
> +	#include "fmt/defs_amdv1.h"
> +	#include "pt_defs.h"
> +	#include "fmt/amdv1.h"
> +	#include "pt_common.h"
> +	#include "pt_iter.h"

What do you mean by compiling generic code multiple times? Including
their headers at multiple places like above?

> +
> +Which will build up all the definitions to operate an AMDv1 page table t=
ype.

"This will build up ..."

Thanks.

--=20
An old man doll... just what I always wanted! - Clara

--zxkMD/BAbmzfsfUI
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaBrHTQAKCRD2uYlJVVFO
o9AuAQDK9i2u7JfunI+32q0hoOi2Y/Pvvttw15+KmB1nTp154AD+NPBUOqUnmgTp
ezgVGaJVimmrDW8F1Zgi1EStXo4tPQA=
=K/NH
-----END PGP SIGNATURE-----

--zxkMD/BAbmzfsfUI--
