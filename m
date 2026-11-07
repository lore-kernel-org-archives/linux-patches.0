Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064718;
	b=aYX0+wUFQf0wZNXbb2Q9erhYAPDdxWVVfNhh3dQv+dRLnQaT6NVF4LTSnZ9Lj5DckVJe
	 EDHoTK/avt18mrmdBlPJTDtm8ExEbgmluWuQJTtaco6TA3K2upGAvfX89Hj8dGgxWMnsa
	 CUqJTVJMN28GN0eJJvZmC1qclHxUIGubcQAr3ficiw3hlbGSiPclKhzrkkYvRhnziH0FQ
	 ujWWMhwXiJ+nxHYOjA9Nar3vyx1hltYSxGcjiAnhaTpS6r6LEvl8PDSBHhtr01eWHT0/w
	 evZUiQ7ix3C0Auqm+WD6GcgGzByoV8k7+0FQZyuAyrIYEONd6utTSU6bbfjq9CKFcig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064718;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Lk5UOhDFHh9El/juchOHNqPOwz8iLm36Vr/lSKWUXA=;
	b=fYnWw7lAZAX6gNe6fzaq7Srj55Pxw2F51jCobs8jfCW0MVMl9erd7JmuFphTIwN34Hnh
	 Z2Aq/f8oEAmjnat3D0HSOItfbu3UuBPRg5YSmubmke9WOJ8UvF+cm5KnDd9wrHq7g0mk8
	 y8VtFPcm0hzv2bWtAvEYJDyEJTiQh/jNPjougJl8kuulO3Dc4umGXGgrOrUKmoBmC9OPT
	 mnCoCo+KmYwTpCvbmJoCAw2pt/6FGPViCDd7GH3JcEN40AZ/iGmqMFmR/xa4nATMJZz+M
	 BvYAAMorHzasAltoJO9Ft0CHW36UQT0+tCK1HyV52MV1rCFa4BH9TOLdynhj5KxAM3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kTKnhWqr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880A0606A333;
	Sat,  7 Nov 2026 15:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kTKnhWqr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA361F008A6;
	Sat,  7 Nov 2026 15:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064718;
	bh=8Lk5UOhDFHh9El/juchOHNqPOwz8iLm36Vr/lSKWUXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kTKnhWqr1lmr7Ab4Gi6q74lkWNsXDNjAQzr2HnZ8w307+nWb7ZYZ6p72M9gXRsEWZ
	 B+s/qWEp3FitvhQkGi8cY75B8Rk/91JfOWKrqHPXAROOvn/qy2T16mj/ws3bmr0IWA
	 +IsRyzhPv3Psh2IqwXRPkeO6adsIGWA6sZVDdc7I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0699/1257] mei: vsc: Fix packet CRC computed over pointer size
Date: Sat,  7 Nov 2026 08:49:55 -0500
Message-ID: <20261107134958.560949278@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Guan <guanwentao@uniontech.com>

[ Upstream commit 1d2a50533aac7046488da78b0d25f69673cbb028 ]

vsc_tp_xfer() computes the packet CRC over sizeof(pkt) + olen bytes,
but pkt is a pointer, so sizeof(pkt) evaluates to the pointer size
instead of the size of struct vsc_tp_packet_hdr. The value correctly
match the 8-byte header on 64-bit builds.

Use sizeof(pkt->hdr), consistent with the header size used everywhere
else in the driver, e.g. in VSC_TP_PACKET_SIZE().

Cc: stable@kernel.org
Fixes: 566f5ca97680 ("mei: Add transport driver for IVSC device")
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Wentao Guan <guanwentao@uniontech.com>
Signed-off-by: Alexander Usyskin <alexander.usyskin@intel.com>
Link: https://patch.msgid.link/20261006-vcs_fix_crc-v1-1-b7b149f13c1d@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/misc/mei/vsc-tp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/misc/mei/vsc-tp.c b/drivers/misc/mei/vsc-tp.c
index 432bc59f11f97..ce877cb957574 100644
--- a/drivers/misc/mei/vsc-tp.c
+++ b/drivers/misc/mei/vsc-tp.c
@@ -293,7 +293,7 @@ int vsc_tp_xfer(struct vsc_tp *tp, u8 cmd, const void *obuf, size_t olen,
 	pkt->hdr.seq = cpu_to_le32(++tp->seq);
 	memcpy(pkt->buf, obuf, olen);
 
-	crc = ~crc32(~0, (u8 *)pkt, sizeof(pkt) + olen);
+	crc = ~crc32(~0, (u8 *)pkt, sizeof(pkt->hdr) + olen);
 	memcpy(pkt->buf + olen, &crc, sizeof(crc));
 
 	ret = vsc_tp_wakeup_request(tp);
-- 
2.53.0



