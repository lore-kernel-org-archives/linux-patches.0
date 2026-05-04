Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D1D301719
	for <patches@lists.linux.dev>; Mon,  4 May 2026 21:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777929347; cv=none; b=OVPGKWV0Y3PBzjOUCSEfaeqSq5/9S+zmxlMmlqHF2AzpJZk55AJcYSYZJhIcFp8WIPgOeXfWEk6GUr1rciRDIiodD3Tr/JWjl/3WpcQcZgJ19tsFQ5as9ztZ4WLMkGD6pUVQDUwngCIrvfbgsLcTLUOScz3GnIc69iTDr2XztlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777929347; c=relaxed/simple;
	bh=DklPH6/6YJ0p6u4Cf1PUxpd4itLk/dZorR5WDOT5W/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=crSk5LBiiugIxAam/qQYZXEdrYjJ3uprBbIPm2hbe1JhXFJuPMzCLtzLDBM5oKafZlRjNwJGw1vrNGQujuJVxQEdAxRzuoay0moIfsv7ajKWr4mL2q3C+O7RMVVpjviSmzbzbpyFW2vF2/ge1n/DIStlh4h5Z/N+Jsd3CpSqvDA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nRicGUOe; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nRicGUOe"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-835c98b659eso1018535b3a.0
        for <patches@lists.linux.dev>; Mon, 04 May 2026 14:15:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777929343; x=1778534143; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=JKpE5oRLemYbfg1MRy2f9zZjvjCWWH6F7jRfRxX1jLc=;
        b=nRicGUOegoqET0P/O5lHNZbJ8wdomSoogcVTYThvDFEDQ4t+crwc2Ysv4M3NU8KrBX
         6LHVOnzfPtSLLYo9dn7vlTflOvh2oL8WGBNrgPtQvg999FGW5ybSw9KP/XkET4GPF9Ab
         jLztR/JImCieszAktyuH+dL4vx00kSn9h2hECjmVUprEpdGOvvgTov9EF+eZb/WIWEhv
         3TsyJTcfnfAr92QUHHO6rloa+cZba51IbembsAo41STYK1p1ROvEDw6JBgrqbFX8xJOD
         0Q8UOwDnt3oblmgXta5SDiqPHk7aJbmqVcRfK9L2jpAjKK0KAOi95LEhxbCPZ/ao4JpS
         o/Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777929343; x=1778534143;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JKpE5oRLemYbfg1MRy2f9zZjvjCWWH6F7jRfRxX1jLc=;
        b=A+PBHSm3phA90OcCc9qaEKQD2nLbAUzinilmqe37MoULs/Nf1dwm3nnCHZw+12Lr5C
         eua0SImRFmSvwvSl8THwVL6yTPsRdUVil6bKfj6EOussfebd0qdEh+5WOQbADAVjXjGJ
         bTt5QWO3YxUAD5PDxaiHHbdaxasfVNvw2csMR0PGF9IUFO878858xGYBg2DcXsvui2lp
         DYiXDf461onCLrrrnZQ0UNS2UWx4HrNU79muflMV7lvLwpy+wAIT5UGalHl4N4hZ9Ao3
         T++qM9uxS31plfl17SMxsbjsFy0DQEEdxUbdExJ7F5qgIGfMQZM6U36xMEIpTauxNAjb
         1AFw==
X-Forwarded-Encrypted: i=1; AFNElJ8gDtXWGkugKAsAXC9T+0RjkUZQIwip1RgTJ2B9WAi97ynaTN0UlHjaT6vOr3zXbqym/tJ3uH0d@lists.linux.dev
X-Gm-Message-State: AOJu0YycsgrT886HK5ZhmHvrnP2YQ5H3XmsQBCmUseHXDdrWpq1Y5lVs
	CJYV88RiTdRpVmjF43lIuDVWd7wvZKRqoSJBRVpfjJRBgBMiyb9rWKjh5n7Qd9tKBMGYd9xDkZf
	vpTZrKw==
X-Gm-Gg: AeBDietyTZhCQS5zCwI7/OVeluqo7GRITQmlbDUeKblyzvGDJaQIfxHBvC7az9SWu5g
	8sKsdG8vRfJXfx6YgOTw/KR2nSzdZ9UcDwf+boUeLkBy5q6f649bJyrrTWObhCN35mpuQjtl11M
	tPbP2z8qkCpaGi4BHyfGU3l7LHdiu4T7HGcQFTU62+e08YeLhngUXO5zFpw2CKWNPY96ZhCeXhZ
	V6efbmrsqGPpoETbAsebw6WehdRIqZ1D0gu/lKGTy7+sbxFYH0XgGmP917TmvoSb/oepuJyd/ov
	1mHgitapcmoZs3PuwxoGpQm7HVbLiWGYnWS515w0AGXqXv+JSaneILLgK3ewgqhqmLKXIqYyBfT
	nzPVkIo/EjwGmIDhofF/ZSA3Fji9fhmVRgWXLMJJBoUfGSZSiGwixAA0D0BBmPxadIhFoMgiTdD
	fwOrrZjvKCkZVHySKMPO0C1lEABbjv75uI3lmXUAfQnMcZC4/vjAE4GJ/InTMR27n1lqP8E2t+3
	/pcZw==
X-Received: by 2002:a05:6a00:428c:b0:829:9a7b:db84 with SMTP id d2e1a72fcca58-8352d2f425bmr10106522b3a.49.1777929342450;
        Mon, 04 May 2026 14:15:42 -0700 (PDT)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83943dde006sm41031b3a.10.2026.05.04.14.15.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2026 14:15:42 -0700 (PDT)
Date: Mon, 4 May 2026 21:15:38 +0000
From: David Matlack <dmatlack@google.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org,
	Leon Romanovsky <leon@kernel.org>, linux-kselftest@vger.kernel.org,
	linux-rdma@vger.kernel.org, Mark Bloch <mbloch@nvidia.com>,
	netdev@vger.kernel.org, Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <shuah@kernel.org>, Tariq Toukan <tariqt@nvidia.com>,
	patches@lists.linux.dev
Subject: Re: [PATCH 08/11] vfio: selftests: Add dev_dbg
Message-ID: <afkMenQ_gfmLUJIy@google.com>
References: <0-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com>
 <8-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8-v1-dc5fa250ca1d+3213-mlx5st_jgg@nvidia.com>

On 2026-04-30 09:08 PM, Jason Gunthorpe wrote:
> Enable it with a #define DEBUG at the top of the file. Allows leaving
> behind debugging prints that are useful in case future changes are
> required.
> 
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
> ---
>  .../selftests/vfio/lib/include/libvfio/vfio_pci_device.h    | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
> index bb4525abd01a22..2d587b988c09fa 100644
> --- a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
> +++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
> @@ -38,6 +38,12 @@ struct vfio_pci_device {
>  #define dev_info(_dev, _fmt, ...) printf("%s: " _fmt, (_dev)->bdf, ##__VA_ARGS__)
>  #define dev_err(_dev, _fmt, ...) fprintf(stderr, "%s: " _fmt, (_dev)->bdf, ##__VA_ARGS__)
>  
> +#ifdef DEBUG
> +#define dev_dbg dev_info
> +#else
> +#define dev_dbg(_dev, _fmt, ...) do { } while (0)

Can you add something to make sure the format strings are still
validated by the compiler even if DEBUG is not defined? (since it
will almost never be defined). e.g.

diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/assert.h b/tools/testing/selftests/vfio/lib/include/libvfio/assert.h
index f4ebd122d9b6..406c430ef28d 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/assert.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/assert.h
@@ -51,4 +51,9 @@
        VFIO_ASSERT_EQ(__ret, 0, "ioctl(%s, %s, %s) returned %d\n", #_fd, #_op, #_arg, __ret); \
 } while (0)

+ __attribute__((__format__(__printf__, 1, 2)))
+static inline void check_format_string(const char *fmt, ...)
+{
+}
+
 #endif /* SELFTESTS_VFIO_LIB_INCLUDE_LIBVFIO_ASSERT_H */
diff --git a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
index 2d587b988c09..3abfa6ff481c 100644
--- a/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
+++ b/tools/testing/selftests/vfio/lib/include/libvfio/vfio_pci_device.h
@@ -39,9 +39,9 @@ struct vfio_pci_device {
 #define dev_err(_dev, _fmt, ...) fprintf(stderr, "%s: " _fmt, (_dev)->bdf, ##__VA_ARGS__)

 #ifdef DEBUG
-#define dev_dbg dev_info
+#define dev_dbg(_dev, _fmt, ...) dev_info
 #else
-#define dev_dbg(_dev, _fmt, ...) do { } while (0)
+#define dev_dbg(_dev, _fmt, ...) check_format_string(_fmt, ##__VA_ARGS__)
 #endif

 struct vfio_pci_device *vfio_pci_device_init(const char *bdf, struct iommu *iommu);
