Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213110;
	b=jlKEEDCUdAXqBMJJLb6z0cSeK6cVHywl61E/TvMBEUKTtsX+iQHByMJznRtJqWY6ttUF
	 0OqrBp3kBKoZ5AJqATaX7mFYHuE5X6KVXVMlXWCEkO1NZ2nklBB6a8u2x6PUumCJ6Q+fB
	 CWRhW5/42A5H7dext0hGJ4u9oIor7mw1UMynLLazSHv6Z9jF6FfTqtcwb3+X76e5iDBec
	 NdwAyINYn5dL3gAtRnurVZfUvjFGH54OL+kvrPQkvIL0Y+SfcZB4zKRXY/6+qL8Gsqjs+
	 azoT69mXm6WnApTqevGar5irD+vRdy4t+DusBlUnRvY4RZQyx9XTFScMBHdbnLhFhiw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213110;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Pprp56bhJMoTYB2PdLUOG9LoopIpfQTRl4BKay0ziCQ=;
	b=URXLIHhz8BBZyHn9JUnYSuvF3cSHLypAt054mcl6P4QeRJho8p/LpkG2h6aJUZknFJGE
	 hMiJvujyX59TN7WZjZ/Vde6diE00esebmoE3Ws2JIenpFeW+wlepHY9776BbnAHE3JvK7
	 ujXwLbiLWVNwjCY+KfuILEo5wDHGHAUxw5HLa5iXugr2hSCz7LQNZr4nbdtJCYDL/dt52
	 IKmCWfc5nug7oIkKV1+xE/MZ0KtNF0JA/lQVAIgTI+T8hSF2GvmuKXqmrpKycekzXQald
	 /ces2ZtMBVhFKGKY2nRG2FybpZq8n3OrSPWAbUOMTXB3PirSaEBxUhbEIXWy4ciFaUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2BQMqyO1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE6EC606A321;
	Wed, 28 Oct 2026 18:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2BQMqyO1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25F281F01825;
	Wed, 28 Oct 2026 18:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213109;
	bh=Pprp56bhJMoTYB2PdLUOG9LoopIpfQTRl4BKay0ziCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2BQMqyO16pH6x4P/j9TtZoD3pyCeH0MLQs/dAZ2rLs+8Q5w38q0EE5c3KOLxRTLJp
	 SRYd3olYMEAHnMQVw/OnDRQ/aC/DrWdLjmuGGxUIFnJbZCj8D3iV8JLhECRCgiKb+a
	 0vO4aCBKm5RxyetApKCLuKmeWuaiC+Tfh3fpxNiM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Jie <zhangjie14@huaqin.corp-partner.google.com>,
	Andy Shevchenko <andriy.shevchenko@intel.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.1 0346/1887] iio: proximity: sx9324: Correct proximity channel resolution
Date: Wed, 28 Oct 2026 17:40:42 +0100
Message-ID: <20261028170507.102376446@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Jie <zhangjie14@huaqin.corp-partner.google.com>

commit fbf33cb18334e7cab1ed4ad2e9a98a1299ad874c upstream.

The proximity channels were previously defined with 12 realbits.
However, PROXDIFF is read from RegDiffMsb (0x65) and RegDiffLsb
(0x66). The SX9324 datasheet assigns bits 7:0 of each register to
PROXDIFF and documents it as a signed two's-complement value
(Revision 3, Section 8, Table 8, page 43). In contrast, RegOffsetMsb
explicitly marks bits 7:6 as reserved. Thus, PROXDIFF is a 16-bit
signed value.

With realbits = 12, sx_common_read_proximity() uses bit 11 as the
sign bit in sign_extend32(), causing samples outside the 12-bit
signed range to wrap into the [-2048, 2047] range.

Correct the realbits value to 16 to accurately reflect the hardware.

Tested on an SX9324-based device: a phase 0 DIFF readback of 0x7fff
was reported as -1 before this change and as 32767 afterward.

Fixes: 4c18a890dff8 ("iio:proximity:sx9324: Add SX9324 support")
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Jie <zhangjie14@huaqin.corp-partner.google.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/proximity/sx9324.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/proximity/sx9324.c
+++ b/drivers/iio/proximity/sx9324.c
@@ -223,7 +223,7 @@ static const struct iio_chan_spec_ext_in
 	.scan_index = idx,					 \
 	.scan_type = {						 \
 		.sign = 's',					 \
-		.realbits = 12,					 \
+		.realbits = 16,					 \
 		.storagebits = 16,				 \
 		.endianness = IIO_BE,				 \
 	},							 \


