Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15ED712F398;
	Wed, 17 Apr 2024 18:24:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713378284; cv=none; b=I8zUbNxIxVrQC0XC+QwsHXl79ksQdPfrU6QclIo321DdvHYDqBDv/q8hEPfMrOM3KiAMmESaKOCpcmf9e2LIzjr3SZALSo74McCKcJYyKO4h0fO+WOPCd3zNznCb2GbO4D1R/veqew3sr+sD3gJKzPai/ZoVlwthOOTB/1P0URE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713378284; c=relaxed/simple;
	bh=rC6fYZoAlfEmkU++TOsOASncl2m62lXgQpEKvON5jQM=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=EJjEuva9lvsgslbb+xm5QbWD+XhgIbvq1mH+lFfc2umzYmSWQ2mpqtjjSHljqvt1WSfp44n629COX2fj2+svdfceYnpl0sXkXYdTPFPX4UcssQ8D/16eY7Fb0iYEXXx2B5/ARHkc6rN1jhvGYnj91gMe4AIGt/ii2ssBdBEafI8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dvsX6Ohj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dvsX6Ohj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D174BC072AA;
	Wed, 17 Apr 2024 18:24:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713378283;
	bh=rC6fYZoAlfEmkU++TOsOASncl2m62lXgQpEKvON5jQM=;
	h=From:Subject:Date:To:Cc:From;
	b=dvsX6Ohj3xfUy735gR3FR3M4TbYT0bVSmJiiMsHfhY4ZSd3tBBM0R/tRFHFZOuES2
	 /IvS1Vu3IIbRgIGIUscggpLo/r68ShYgJ5+tBk0h7DKdJ7cneTgBejpDWkVOxP+TM5
	 8sQJHDNTz6xJqJGk5xgmd1NE9Oz5PNAV2+X9A2pKWzi8/rUvU1HKEw0H5e2lOOPuTQ
	 Ry4Vikjucfp7RpbUd+/zQsmcWStlspOTwN0fbJwsDP9p7gRzSjWSSjyLs5IOO2oQo9
	 52Ucr6JzaFicZMSrEyhUic0yj/Yjs1EfG0S+ua9Bez83N7xld1scwwxiS5GXwRo71c
	 qGzC0ikgw/P3Q==
From: Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 0/3] drivers/s390: Fix instances of
 -Wcast-function-type-strict
Date: Wed, 17 Apr 2024 11:24:34 -0700
Message-Id: <20240417-s390-drivers-fix-cast-function-type-v1-0-fd048c9903b0@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOITIGYC/x2NQQ7CMAwEv1L5jKWkVBT4CuIQ0g34Eio7rUBV/
 47FcaSdnY0MKjC6dhspVjF5V4d46Ci/Un2CZXKmPvRDGOLIdrwEnlRWqHGRD+dkjctSc3OV23c
 Gn2LCOaYCjA/yp1nhy3/ldt/3HxjTem11AAAA
To: akpm@linux-foundation.org, arnd@arndb.de, hca@linux.ibm.com, 
 gor@linux.ibm.com, agordeev@linux.ibm.com
Cc: borntraeger@linux.ibm.com, svens@linux.ibm.com, wintera@linux.ibm.com, 
 twinkler@linux.ibm.com, linux-s390@vger.kernel.org, netdev@vger.kernel.org, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.14-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1218; i=nathan@kernel.org;
 h=from:subject:message-id; bh=rC6fYZoAlfEmkU++TOsOASncl2m62lXgQpEKvON5jQM=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDGkKwq/m2uh8Z775dJLJvzvLlqvPEDv2+PXyWq1dZ73fe
 jtl+4Re6yhlYRDjYpAVU2Spfqx63NBwzlnGG6cmwcxhZQIZwsDFKQAT2bae4X96/t/bIcxdXZcU
 uKZ3a2/2CVr1UuH7WpY1M3jKH3jebhdn+KdUeUr9q+btYhsNWfEza4sZmfbZP/8TseOL8LoPSou
 sS9kA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Hi all,

This series resolves the instances of -Wcast-function-type-strict that
show up in my s390 builds on -next, which has this warning enabled by
default.

The patches should be fairly uncontroversial, as this is the direction
that the kernel as a whole has been taking to resolve these warnings.
They are based on Andrew's mm-nonmm-unstable branch [1], as that has the
patch that enables -Wcast-function-type-strict. There should be no
conflicts if the s390 folks want to take the series but it may make more
sense for Andrew to take them with s390 acks.

[1]: https://git.kernel.org/akpm/mm/l/mm-nonmm-unstable

---
Nathan Chancellor (3):
      s390/vmlogrdr: Remove function pointer cast
      s390/smsgiucv_app: Remove function pointer cast
      s390/netiucv: Remove function pointer cast

 drivers/s390/char/vmlogrdr.c    | 13 +++++--------
 drivers/s390/net/netiucv.c      | 14 ++++++--------
 drivers/s390/net/smsgiucv_app.c |  7 ++++++-
 3 files changed, 17 insertions(+), 17 deletions(-)
---
base-commit: 75c44169c080221080be73998466d2e9c130caa7
change-id: 20240417-s390-drivers-fix-cast-function-type-61ae81afee7b

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

