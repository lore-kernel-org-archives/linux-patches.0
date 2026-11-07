Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062330;
	b=rL+O8gkiF5C7xQOQG2UWnhbcpIEHK8Cno6RaIH0LejSee5uGYK0ZVW/9fblexcJA5ZK4
	 Ky8d3rnhLu8xU9pSkFUJgK6eJ/ga2GYSai2O1OqIppY0rNi4QaPrQxNjtoiRv+w7i1R1w
	 sGX2LUPcqY6tb1fKQieNIN2MT3OmnFmbcHPqBfWXJ3LWte73fESHgKq89chmc226/hGy5
	 62VwPu638c4tLZ1+LD88C6GNwp3hJNponVziV1jn83wd25Rxh/v3EDzB2+NVOzIY9VYnD
	 NlyeBWX7zlG9fiqqB4yjQHWZfalbfduN/S/nEL1GNU6iHN1Vat5Pu5c8kHm8NJtqRdg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062330;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=46SFuSiQcO+ltrWgMuoCuWZUGYaJfFnEpaFri8g8RoY=;
	b=GfSfW86T+vuj0XKQAhOS+I/JkBm5OxC667T1YiB9t+2RJls60yo5mpyuTp6YEylwOYUr
	 uds93VGAvTfFJXLWjUuAmTCx9dws6M3vjP/CH+sEJy/euEUGcO0Mt0yWp1B8E5P6XS87x
	 UwU6IAsPpi/QJ8t3qaHLAZzE7Cjk08G0jtcj3P2boR5RWprDMaUxo2/KwKCE8SR95jvcB
	 Dvwi17lw3PpsE7FPvixpXFUEhZDsJat9KxX9FVik3fo0/Wi9VQxhzI96rHTubU6FDGEO2
	 yHui9Zl/9ghI+C4Vx6/k5QL+6rlZ9UfS8RUfk6z/PCJ/eeEtaFRzbkcWo/FvY/YSr9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MlH72MoB;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64016606A660;
	Sat,  7 Nov 2026 14:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MlH72MoB
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BAFB51F0089F;
	Sat,  7 Nov 2026 14:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062330;
	bh=46SFuSiQcO+ltrWgMuoCuWZUGYaJfFnEpaFri8g8RoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MlH72MoBhqOxc8xR2r0HLRrT7ycNthvEXPCbQpzpGAg+7keIKwE5eyPH7ejeaz+qw
	 wJCidm3A7QAZm/UOBXjMlD6/nYl4TRdff/qkLCN/g6bpYad4+KRfQLDBC5x2s1MNeD
	 gMoUIrb/T6zQo0X3JahklZUpCiw6tmx3k+tfHJgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Wentao Guan <guanwentao@uniontech.com>,
	Alexander Usyskin <alexander.usyskin@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1261/1536] mei: vsc: Fix packet CRC computed over pointer size
Date: Sat,  7 Nov 2026 08:54:37 -0500
Message-ID: <20261107135033.186685868@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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
index 27c921c752e9a..1fe760adb2e4f 100644
--- a/drivers/misc/mei/vsc-tp.c
+++ b/drivers/misc/mei/vsc-tp.c
@@ -291,7 +291,7 @@ int vsc_tp_xfer(struct vsc_tp *tp, u8 cmd, const void *obuf, size_t olen,
 	pkt->hdr.seq = cpu_to_le32(++tp->seq);
 	memcpy(pkt->buf, obuf, olen);
 
-	crc = ~crc32(~0, (u8 *)pkt, sizeof(pkt) + olen);
+	crc = ~crc32(~0, (u8 *)pkt, sizeof(pkt->hdr) + olen);
 	memcpy(pkt->buf + olen, &crc, sizeof(crc));
 
 	ret = vsc_tp_wakeup_request(tp);
-- 
2.53.0



