Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.137.202.133
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793304810;
	b=nCI5p4YNllha3eoQZVLq01p33A1VRMWw2pEdJQJE4SPMSPIyuo6lE7wP2rOum3dYbXXH
	 QAk9JuwoSv3mSoCMfNXM2dDwNqz7zUfxY+1pyzKx5V79ZfpOBU/n5EPl+juRWsqJYiHSH
	 GFaGSOaFwhlpdkgJNGRV/93QjDOkjvy2/cFu5BEsmu2MSHDxEaWM2dA1ctHgLa4Z+p2IV
	 FFvWo9l2WEivsaWpKWmzry5+ZRY+HbQpKSBG3xLKqfMXnZQPxblOD5Khf8axKh/qfPu6a
	 CzajRckm4LS/S2Ois+q0Tb71hih3Y5YaKLRD6SXIGH8zrPZfj/OTkPj32sAWmannMjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793304810;
	h=DMARC-Filter:DKIM-Signature:Received:From:To:Cc:Subject:Date:
	 Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Transfer-Encoding;
	bh=/URtJhh5qYgdD+SvrO47CWxV2uFOw6FeCWrobwxfu1o=;
	b=1oJuGbkpdUOsIx1F2gwvVAia5rwZocZ3d1/ERhUvlDJn0pdQE3lI3XC8iV6hNGKr352G
	 CwdsqsVBseQA/1YYSGxdiInx5pSb2UURLqedAHgDEiqMuACsvWroU/SDRNLVW+frOF7ys
	 Xu/Vb4No9KMQ7oi3CmtqXO4OzDNbY/11zmkdI5ty3/ksOVZeEDJWTceoSFkkZgHdNsIxi
	 uXkkT6GsXL9JEDjzPgvOOuQg57a+wuJAeYSt1lqmqX/FrpT6/I3s6wyIy3JBmCcuqzY6G
	 DCEFJoiKx26WM4/wQDawqbdkohcVjKotmHezw2pwLI1d2oLoKHsLhlyEk7xW/8ovS7w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=infradead.org;
	spf=pass smtp.mailfrom=infradead.org;
	dkim=pass header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=GxxHcrkl;
	arc=none smtp.remote-ip=198.137.202.133
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F349606A31C
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 20:13:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5F349606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=GxxHcrkl
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/URtJhh5qYgdD+SvrO47CWxV2uFOw6FeCWrobwxfu1o=; b=GxxHcrklq9Y2GPUYtQO0sbXcvw
	jXtRpo6+w8rV2Vo9X7uOD0aMFHWZy34poWtVGD1XKsj/CqZ9zYfroDl1pvyDfdSRYKrlmwtNESeDO
	IcpP0IaxSPXwFvfAAmTcDw/SoNSoa3fJhxNE6bemYHuQ67ij3PaHzRDyZ3nT3z/d+B1SVgv3OoRl+
	IpU30Re5Nejtg3A7ARl6gY+lLejExhZl2sszXy/BoMrOWPHwjH7Bp/FE1lt8DHvcFVYD18iqN6dGa
	8A8qVeg0QhxqCD6guqrbLNRJzq7Kfhz5O8mPRkgheluwYk7EySV53HZ5Fj3c/GVkHXWb7PfpkQZ0Y
	pd1zy9FA==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xMWV5-0000000AJR2-2yDU;
	Thu, 29 Oct 2026 20:13:27 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: patches@lists.linux.dev
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Geoff Levand <geoff@infradead.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 1/4] powerpc/ps3: platform.h: fix enum ps3_spu_resource_type kernel-doc
Date: Thu, 29 Oct 2026 13:13:23 -0700
Message-ID: <20261029201326.2672284-2-rdunlap@infradead.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261029201326.2672284-1-rdunlap@infradead.org>
References: <20261029201326.2672284-1-rdunlap@infradead.org>
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

Use the correct enum name and member names to eliminate kernel-doc
warnings:

Warning: arch/powerpc/platforms/ps3/platform.h:240 expecting prototype for
 enum spu_resource_type. Prototype was for enum ps3_spu_resource_type
 instead
Warning: arch/powerpc/platforms/ps3/platform.h:240 Enum value
 'PS3_SPU_RESOURCE_TYPE_SHARED' not described in enum
 'ps3_spu_resource_type'
Warning: arch/powerpc/platforms/ps3/platform.h:240 Enum value
 'PS3_SPU_RESOURCE_TYPE_EXCLUSIVE' not described in enum
 'ps3_spu_resource_type'
Warning: arch/powerpc/platforms/ps3/platform.h:240 Excess enum value
 '@spu_resource_type_shared' description in 'ps3_spu_resource_type'
Warning: arch/powerpc/platforms/ps3/platform.h:240 Excess enum value
 '@spu_resource_type_exclusive' description in 'ps3_spu_resource_type'

Also fix misspellings of "partitions."

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Geoff Levand <geoff@infradead.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Michael Ellerman <mpe@ellerman.id.au>
Cc: Nicholas Piggin <npiggin@gmail.com>
Cc: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Cc: linuxppc-dev@lists.ozlabs.org

 arch/powerpc/platforms/ps3/platform.h |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- linux-next-20260828.orig/arch/powerpc/platforms/ps3/platform.h
+++ linux-next-20260828/arch/powerpc/platforms/ps3/platform.h
@@ -228,9 +228,10 @@ int ps3_repository_read_boot_dat_info(u6
 /* repository spu info */
 
 /**
- * enum spu_resource_type - Type of spu resource.
- * @spu_resource_type_shared: Logical spu is shared with other partions.
- * @spu_resource_type_exclusive: Logical spu is not shared with other partions.
+ * enum ps3_spu_resource_type - Type of spu resource.
+ * @PS3_SPU_RESOURCE_TYPE_SHARED: Logical spu is shared with other partitions.
+ * @PS3_SPU_RESOURCE_TYPE_EXCLUSIVE: Logical spu is not shared with other
+ * partitions.
  *
  * Returned by ps3_repository_read_spu_resource_id().
  */
