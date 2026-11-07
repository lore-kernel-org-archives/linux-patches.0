Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063325;
	b=YRmSPjQSi6ApUUNJi3WIKgbt6tTk+ojT3LeqBuAgthaojBhs7TRZowuqJkmjbIxILxed
	 DtXWau7jFTTZLwtuFJKjm87ryhGINfjzteXqsUw2M+sJHOVfaOPQnWfcBruajxBOpQOv0
	 ee0B+ygAGD3c2f+mEfV+M+PFu9mwJDdezqCq7DQ07F6AJ3rTIMQaMmpoYQPXsI7F0tXp4
	 Lb5Puf0APw/UgKLjipxTd493mHQcEQjqXuE3hzQdj5fRr3yEgYn8eRrzSZNYgoCTNF4TK
	 Yt9yhdb1F77sZaAazjyWvd3cA5x5ZT2JE/lMIpysNTd4yfV37kC0DWMl9E6valVuHHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BdZVgL7X/nTCN2uZaNPD1wJ0E/1QQz+vCF8BDqW0hEo=;
	b=DF5o7slOlUOq4NNeDYBV3X4MrhkyHZly4hJxRLSzUImZGfT5LQzIc7kaM0e1TBgbtBZs
	 Ba0XiRl6XBn5p+r3FFUxW6p3r6oosU7r1fqxUxvvbLdHg2At4IEFQhlBpM8hJOqQ3L0Dp
	 2GDsC8ZEjicHrH5QAG6tRtUOtWppedvOpyBqfptgK/WCpBp9w+RQIYKpVyi5U4gbherwn
	 T6Rl7XDKsR7PV7kdk3JVlLD34jROWwQ9B5uXNRTIhsyjx4NkSKMvtFlSc7BT9hDMZgQKH
	 Q5DrCiTNFnlvmmnsLy4I8La/NvasCO1yHfhqfOIUFCgVvZcyQV5gGOhjfV2LsHEmw5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mj6dpnvF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C3F606D810;
	Sat,  7 Nov 2026 14:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mj6dpnvF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADDC41F008A1;
	Sat,  7 Nov 2026 14:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063324;
	bh=BdZVgL7X/nTCN2uZaNPD1wJ0E/1QQz+vCF8BDqW0hEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mj6dpnvFztzG1OvKoZLihDPvu+YOgnQF/3GcAX5HQ5jRGCUEX8ns48Bd2C8UG80uY
	 GVlgo/vWhZCRtIuE69FYWju79xrkMFV025d/0HnxRbXZ6m6BBSi8l2EnvC40kMP5RT
	 dCLkrnUdCno/BJtVEDH+QLwGJKOxtkdqSj15lgbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 509/869] mei: vsc: Fix packet CRC computed over pointer size
Date: Sat,  7 Nov 2026 08:53:11 -0500
Message-ID: <20261107134910.843753002@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 5ecf99883996b..e70c07aa0d604 100644
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



