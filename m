Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030248;
	b=nbQSi2Tm7fxXNYjB5E1MqpdS1zDF51bfN2s2uHUK0VXoVj0LmXH/y4B7gJw3XnEHAv/r
	 4GDJRyyFhOpESbQDKguGW6/vsNh/XzmguQ7lpcqlWuMm2APdLu5wfOMaKuJ7r5N/y6p6I
	 UGaVd+FX2pDcGd1IPE/nN0vEF1N+bXgefwWSdosHZSIGrnAWqUwAcdSU6MhPOWHCWSdfi
	 xjDhXSONiKiSPMA6UjuyqSHVuudY9D6uKNCbr3SqwZMV2RDdeQe8kvSyr30mCK2BBSdqx
	 uNVHJzROmxeCnvIq8AD5F2Zol3sL4umJoyjcobrzFoHei0kxJguC9gTNHjFNwBfaSAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030248;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=o+IUtpbGzvCZStikC24NV818omuuulZ41XRC+NhJJgk=;
	b=4EM/DBGIN1hLIkisrrMhz58Fsi592hJzRBn2EMqO8Yl9mbmts7vEMDE1HDZtvDYLhA2m
	 /Ju/XKe5MeNPbjqtNGMYOobqtjN/abL6OGvPG4fsdJlSUh3MkKIhO97c/vAeiSdYD8kuA
	 E9kGIApkNBse4nj/QcwrsMyh5BfETn7TAgcWXrzghGUNF/MzTQq2FEBdcfctlyTEBdWKA
	 3iBiNC7ka4bffWPetuq61XEWnQgLzvN3FeH6t9PkObi9YI88RK7mn53Kyab6vDF+MhRFn
	 JAX/u437XzphVP/1EO7OefXH2mTym1NEEfYO3fJKdWToM9CcwyPPnAOc3+VaNt4rFtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tPpZfi8r;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A07F606F52A;
	Wed, 18 Nov 2026 19:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tPpZfi8r
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1021B1F000C4;
	Wed, 18 Nov 2026 19:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030247;
	bh=o+IUtpbGzvCZStikC24NV818omuuulZ41XRC+NhJJgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tPpZfi8rLO1aPQW7WgQeXpYjMqmvwlN9ahZhbSGqogxYzHmRqeiVxWtfeXkutpcE4
	 2BtkEYfhjVKArTf/v36HBCL/f+p+Is3fpTnVBAa1Vg0Be9jcQ521NvLm62x4mR3WWY
	 SdH78HBpYJF/nB9GrAi0k0uHKy+bxxyRsd+v0bzs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Abdelnasser Hussein <abdelnasserhussein11@gmail.com>,
	Joshua Crofts <joshua.crofts1@gmail.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0636/1756] staging: iio: adc: ad7816: Sort headers alphabetically
Date: Wed, 18 Nov 2026 15:46:03 +0100
Message-ID: <20261118150034.176878634@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Abdelnasser Hussein <abdelnasserhussein11@gmail.com>

[ Upstream commit 8c7b99ff159d64679c9b3b4d5878e44459f7272a ]

Sort the include directives alphabetically to improve readability and
maintainability. This is a precursor cleanup patch to prepare for the
addition of new headers in subsequent changes.

Signed-off-by: Abdelnasser Hussein <abdelnasserhussein11@gmail.com>
Reviewed-by: Joshua Crofts <joshua.crofts1@gmail.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Stable-dep-of: b96187644664 ("staging: iio: adc: ad7816: Protect sysfs attributes with mutex")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/iio/adc/ad7816.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/iio/adc/ad7816.c b/drivers/staging/iio/adc/ad7816.c
index a46ca0559b6a2..6a402e8877605 100644
--- a/drivers/staging/iio/adc/ad7816.c
+++ b/drivers/staging/iio/adc/ad7816.c
@@ -5,19 +5,19 @@
  * Copyright 2010 Analog Devices Inc.
  */
 
-#include <linux/interrupt.h>
-#include <linux/gpio/consumer.h>
 #include <linux/device.h>
+#include <linux/gpio/consumer.h>
+#include <linux/interrupt.h>
 #include <linux/kernel.h>
-#include <linux/slab.h>
-#include <linux/sysfs.h>
 #include <linux/list.h>
-#include <linux/spi/spi.h>
 #include <linux/module.h>
+#include <linux/slab.h>
+#include <linux/spi/spi.h>
+#include <linux/sysfs.h>
 
+#include <linux/iio/events.h>
 #include <linux/iio/iio.h>
 #include <linux/iio/sysfs.h>
-#include <linux/iio/events.h>
 
 /*
  * AD7816 config masks
-- 
2.53.0



