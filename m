Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76B451922F6;
	Fri,  2 May 2025 03:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746157814; cv=none; b=ljQy9WWomkBDlGVle1IqZmQAQLCCVLbmGovDjyoLt8aYOHSvqBlMdvC33Gw8mb0im86NFRpmN9SieF15KRgOYCyFZGIadjMiVYN9sXqyt4NZGC4cG5FZfOzxzNl+xPIYkr/AKohfQ+Qns0Er3JeahOBxuiL8WPPU7t3LNQNUjoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746157814; c=relaxed/simple;
	bh=3c1nlzF8RZhIa2IfkWpFCztfXW4famdPY+LgthBQ6Fo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=h/3YveLl5LlFg4Bx7C2h02G5ZY76vrj7z00WwgJ6ZWarsHKWA6AVIvWATsdAUwPhiZE2k2ObV79GwidaSM0TLWseo3oSTAECJbNYBSi8I0rKmTzEliViRQ587RNXE8ZVSYnbP6RpuVqEuu6xchADugXcfiUhlGdUgqNaC+m9/ns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QsgiDIV1; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QsgiDIV1"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-3035858c687so1282918a91.2;
        Thu, 01 May 2025 20:50:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746157812; x=1746762612; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q9Fmb2BpvFenPgSBSx7aFW99AUa48pruOHMxG4AYI/0=;
        b=QsgiDIV1VLIcGwzN9A/sLRpADNK31EXRBsBMPkrEPZu/G+pDa10SnF0nFTC02mHL79
         yLsFfionTpZKdznEaB0D+RMc9mOykumZT40xOKQKOcN6q8K3y9ko4L0bvvZ6071l9fu8
         fkih3Z8oQ1EI5Bb/JjHoN0BPmmcMdKtyUJDWy2czCmXAfaRrLpNEN+qiXdiPAnpY07zD
         CpByCcro1jZWpvIBK7/jWGWsj3Xnunev/LOLnCX9w1rltYOQlRKQfXr8blzU5wW0Kk1C
         e0QuD1j8kZ4/+xE8U+xAP0NZqEnLoDa0vVObbzo0BWjHiwSIwRb07G+dA66nt8vaIj7x
         8gwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746157812; x=1746762612;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q9Fmb2BpvFenPgSBSx7aFW99AUa48pruOHMxG4AYI/0=;
        b=mxwZUEF9HFFIwXNmsYQIJPxmhjs/9twDT4t2gMFXaGYP/r3+I8T6TLJySZS/jayr/q
         D6x5kVHzC+aHNs1QMCzArq0RQU6EMOESZj+0mfcjYJIRwQoRp7/I1XAvF6sefTzKKRRb
         wm6vG616Fv+yVqoRaAnZ1eXM+LNwPG+k7E6H9NC6N+GcKx67LLcmdWJUPhsKXp/GAwOP
         9RT0C3/lo044UvlDr7Fmbdhu9sZEKS6RwExNk2svLLlyWwXj00b/bzru236fjbBm9NOg
         bWHpVXxhlpmd6sOvhKva8zqeI0GuM6Je6iJQn+qatJR/WoKcJpaxufaDAQen+ymr1lfI
         U8mg==
X-Forwarded-Encrypted: i=1; AJvYcCWkTwv8FYwsQsD5vLcgVBgrx+vn2VTpRz+mZDhO/9suqeXjX4ULAPc9kz9GdhMRfSTv/rkTkW9Bqw==@lists.linux.dev, AJvYcCXdlbvwdeI0zbwPosl3xk3TLSF9yp9YkI+eue6b1eodGzW0s8mfkFDPLz3hyCUyJBTBDHAfRA==@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2YjonzUNfH1K8UoQ5icvKS1y5NQsKFip92evdHMnPeaV68RoH
	jxVbeH56QcpAw2cuei/4/1mLHShGozMEA2nztuxJjbWi7FyBGy1g
X-Gm-Gg: ASbGncufjDFVVcAbGO+t4fOkETbWLNmHd5dUC3Y6LkxeJIOcZlvxoBs3VI2E6dM4f5H
	qAZaTE5Hyq5qI5V0dQ++8+qroa49AZUe35kJin3hxIExnybCc3aIarcQjeCoH4eMoUw9rou1h6p
	pRKMuiGQAYE5RM67b4bh7A8EnY+qSPvAGpyEamPy5stkf7X7JWYbImMOZU8uyJ0xoHIfX1drY+4
	EFUw7jJqqqnwN2zzBAQUcLfVXskATwLt+8WXXBGHh/J6OopLkUuEf6s8KHjWaCKKEWXb3dzVM1j
	+cv0bKPdvaIGHh+0L8YIJmOTyVGUnowhrfaEyts0
X-Google-Smtp-Source: AGHT+IFusSWo1BAwwXVBEu66ZFOQHwzVAGyr3p079qazgApC+Wzq8zZL3bsDTFLCQouzn2+zKuFDTg==
X-Received: by 2002:a17:90b:586c:b0:2f8:b2c:5ef3 with SMTP id 98e67ed59e1d1-30a4e59f952mr2796823a91.14.1746157811349;
        Thu, 01 May 2025 20:50:11 -0700 (PDT)
Received: from archie.me ([103.124.138.155])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-30a4748e852sm1776417a91.23.2025.05.01.20.50.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 May 2025 20:50:10 -0700 (PDT)
Received: by archie.me (Postfix, from userid 1000)
	id CE99B420A6AB; Fri, 02 May 2025 10:50:07 +0700 (WIB)
Date: Fri, 2 May 2025 10:50:07 +0700
From: Bagas Sanjaya <bagasdotme@gmail.com>
To: Nicolin Chen <nicolinc@nvidia.com>, jgg@nvidia.com,
	kevin.tian@intel.com, corbet@lwn.net, will@kernel.org
Cc: robin.murphy@arm.com, joro@8bytes.org, thierry.reding@gmail.com,
	vdumpa@nvidia.com, jonathanh@nvidia.com, shuah@kernel.org,
	jsnitsel@redhat.com, nathan@kernel.org, peterz@infradead.org,
	yi.l.liu@intel.com, mshavit@google.com, praan@google.com,
	zhangzekun11@huawei.com, iommu@lists.linux.dev,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-tegra@vger.kernel.org,
	linux-kselftest@vger.kernel.org, patches@lists.linux.dev,
	mochs@nvidia.com, alok.a.tiwari@oracle.com, vasant.hegde@amd.com
Subject: Re: [PATCH v3 16/23] Documentation: userspace-api: iommufd: Update
 vQUEUE
Message-ID: <aBRA75V9l9WlI2Q3@archie.me>
References: <cover.1746139811.git.nicolinc@nvidia.com>
 <0beddeaaa4a8a7a45ce93ff21c543ae58be64908.1746139811.git.nicolinc@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="VfsLxvgoTsplys2W"
Content-Disposition: inline
In-Reply-To: <0beddeaaa4a8a7a45ce93ff21c543ae58be64908.1746139811.git.nicolinc@nvidia.com>


--VfsLxvgoTsplys2W
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 01, 2025 at 04:01:22PM -0700, Nicolin Chen wrote:
> +- IOMMUFD_OBJ_VQUEUE, representing a hardware accelerated virtual queue,=
 as a
> +  subset of IOMMU's virtualization features, for the IOMMU HW to directl=
y read
> +  or write the virtual queue memory owned by a guest OS. This HW-acceler=
ation
> +  allows VM to work with the IOMMU HW directly without a VM Exit, i.e. r=
educing
> +  overhead from the hypercalls. Along with this vQUEUE object, iommufd p=
rovides
> +  user space an mmap interface for VMM to mmap a physical MMIO region fr=
om the
> +  host physical address space to the guest physical address space, allow=
ing the
> +  guest OS to control the allocated vQUEUE HW. Thus, when allocating a v=
QUEUE,
> +  the VMM must request a pair of VMA info (vm_pgoff/size) for an mmap sy=
scall.
> +  The length argument of an mmap syscall can be smaller than the given s=
ize for
> +  a partial mmap, but the addr argument of the mmap syscall should never=
 offset
> +  from the returned vm_pgoff, which implies that an mmap will always sta=
rt from

Did you mean never be offset from returned vm_pgoff?

> +  the beginning of the physical MMIO region.
> +

Confused...

--=20
An old man doll... just what I always wanted! - Clara

--VfsLxvgoTsplys2W
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iHUEABYKAB0WIQSSYQ6Cy7oyFNCHrUH2uYlJVVFOowUCaBRA6wAKCRD2uYlJVVFO
o+SZAQDJ/gcFcLrWtK7lcL67yMIrbhi/Ip66m8FOzciKz7X4gAEAu6K/kN2zgCb1
Up14Fvx9ssPG1/hIFF+QXlsxiG4N0Ag=
=Umti
-----END PGP SIGNATURE-----

--VfsLxvgoTsplys2W--
