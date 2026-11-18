Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026888;
	b=VhoO+kz93deUz9Qk/fJR7Dajr6viBAcGHzYtH2X0Knu1Qe8XgMw1Oq8CtNHwkvJHMnvx
	 k8QaJbBLs9o7YFdnwJQ3pHKmDxpHYHElqBkni8Dn9G7eNXZMTJid7haKyLRCOvRDl2XjA
	 hZxLc8Cjtwgx/m3dcxRXoTn+B5tl+VuE4VmKcm+MJrw5DPJf/gdVTQsJsBd5iISixMV9/
	 04TZF/Kp4UbZ0Led2URb0KCPKIBWZ/s5HfdpD+uulzalQz2Jx13/uLxN0LG/2b5UtjD6K
	 PwLeXFb77QViWgsvG+AV6i/jX2xmmpH6O3u79E+t1zibCYGw/KDw+fl0sQcAQTr/RHg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026888;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wFHyWO3n30rZMK4VUJYw5aL7gAXZqpoxsOY4jOgPbWo=;
	b=tQblHV/W6TdQKPeN55HtxgJSLcTcv4OWou5ElAQvZ+CRvrp/Ad6k3EnXCdMZthOhn+iM
	 D2PwHQbDHP054aJH3r5ekMfgTh2KkfhVkwBTGZawKX7B+fWajr6vF49fVsv63xBFVCVqL
	 3rRMvjtgnrj/f7NT3XQI3dB9LzbSMwjJyXP7oJBL/PBLTmkfK1/x2xKQOtH6kkhXTJTHl
	 m6N9hyuzD1WXc0ozigplBtBM38kmMEuEiT9IBiM+uqs6wQ40lTGLfLoH6l7nSlA9rzJ/y
	 cZ6AZYsc8MUDOgKNGWHl/x7h8mpgZOzCmqdAgp8U2533FpOOhofZnVzoiD0WrLIN5og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kr9xDd0N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 731E2606A320;
	Wed, 18 Nov 2026 18:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Kr9xDd0N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C48E51F000C5;
	Wed, 18 Nov 2026 18:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026888;
	bh=wFHyWO3n30rZMK4VUJYw5aL7gAXZqpoxsOY4jOgPbWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kr9xDd0NbQc6tl1bAUXD9fyCQTgrEbk4vUJHxPdbmvgbnUFayCuc2xEjUUGYJFv+G
	 giC5Qe/tQ1udrW6ciUhL3nb0a8tXACg1ZE4EUr7LeSe/vPkZ44yydzoGGljFMd0/ZW
	 I/D4uoK1sEb8jD63KWtYbJlc+HjCP6aZV1gC6MO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xingui Yang <yangxingui@huawei.com>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1558/2151] scsi: libsas: Fix out-of-bounds memcpy() in sas_ssp_task_response()
Date: Wed, 18 Nov 2026 15:54:53 +0100
Message-ID: <20261118150218.647629106@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Xingui Yang <yangxingui@huawei.com>

[ Upstream commit 4d7f9c3fdce773f6c69d17c1d4a05bd5e17f4b99 ]

The min_t(int, ...) clamp of the device-provided sense_data_len turns
negative for values >= 0x80000000 and is then used as the memcpy()
length, reading and writing out of bounds. Compare as u32
instead. Well-formed responses are unaffected.

Fixes: 366ca51f30de ("[SCSI] libsas: abstract STP task status into a function")
Signed-off-by: Xingui Yang <yangxingui@huawei.com>
Link: https://patch.msgid.link/20261009033238.1076098-2-yangxingui@huawei.com
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/libsas/sas_task.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/libsas/sas_task.c b/drivers/scsi/libsas/sas_task.c
index e9d291007817b..2080e5836179b 100644
--- a/drivers/scsi/libsas/sas_task.c
+++ b/drivers/scsi/libsas/sas_task.c
@@ -25,7 +25,7 @@ void sas_ssp_task_response(struct device *dev, struct sas_task *task,
 	case SAS_DATAPRES_SENSE_DATA:
 		tstat->stat = SAS_SAM_STAT_CHECK_CONDITION;
 		tstat->buf_valid_size =
-			min_t(int, SAS_STATUS_BUF_SIZE,
+			min_t(u32, SAS_STATUS_BUF_SIZE,
 			      be32_to_cpu(iu->sense_data_len));
 		memcpy(tstat->buf, iu->sense_data, tstat->buf_valid_size);
 
-- 
2.53.0



