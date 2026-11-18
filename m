Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025315;
	b=ajRU/Ose6PEJkGcByk9a3mRwoIUKrWRnWML7+t6uCBll31EYJTQw0uRWiNBwg/5EqH9z
	 yTEaNdLDNbkyytLoCS5uUIeUxfzsOqN5x2QbGQD5T/t863jBMFzO0s9aQeRJR/wLenrOq
	 T/HfvutQaOZTv3ETkVeBxd8m0dkmoX2znY0dfUsOEiAnV1hzCYFMw5PjPy9T/xi0NtB8A
	 2kVvPXUKG6BswAi6kjMZplD8WKIg/gSAJx43eir7dsncUZVwY1IsKFyoYY/N8lCxoOyc6
	 DEAL4vLZNLJSa2626FY8Rd3Xx//JLXPdZP4iK6FY9x5auoNC5xLeHi1jJtwR/aIIaVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025315;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=c2UzUFQiEsbEcIzyn6k9yif7xLfON9UUJlu1jGJKdNY=;
	b=VFPh808B8ruiYPkGMDZXI87cayDRCDPwKc7+S1GcXRCwzn6NY2sUtHn4I+cFGcfDiuAu
	 3TWHNhuTmHJEhQ29yDr6OctJSnGuOaAsCBXl6bLcmc9HtPQx5FviPCv6UpGRofeyjX3RD
	 HroCjbkxwj8y+i/QGGMTfq0eBGKJSq271Kh0XLkWci/zU7yzDdGFEydU/34ZsSFPPVmFZ
	 2suIrxAB04AXrMpD6HCabXoZ8sP7Yc89+aI9X3LE/D0PaGNHShKybYozfug9k5npTC4ui
	 7eSPxiq5Nw6L+5Tr3Otkn5xzSGDa1Qb47BQu6EA5WTX6t7cIJKXqhOX9p+J1mWVPPPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jQKT3Wts;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71DE7606A31C;
	Wed, 18 Nov 2026 18:08:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jQKT3Wts
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9DDC1F000C4;
	Wed, 18 Nov 2026 18:08:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025315;
	bh=c2UzUFQiEsbEcIzyn6k9yif7xLfON9UUJlu1jGJKdNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jQKT3Wtsz+TD+JegEcb8NDxgthaLTa29jmjVm44nVOVtEmSPAg2eI27J/ssXSAm1F
	 I4i2r/k/qfhT8kB85PVk83o2zQqp6uYNNgVD8dStDcZ0cyYP5JByuUVORdwGWi8jde
	 gespxTuuzNAmpXyGZSUiXDTUzZV3vVWsDsuriXBE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1019/2151] scsi: scsi_debug: Refuse a short WRITE ATOMIC (16) before writing it
Date: Wed, 18 Nov 2026 15:45:54 +0100
Message-ID: <20261118150159.524965527@linuxfoundation.org>
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

From: Niklas Cassel <cassel@kernel.org>

[ Upstream commit b81608b17c5d04c797e6fc1cfb95182c842a4db9 ]

A write whose data-out buffer is shorter than its transfer length is
short. An ordinary write transfers what the buffer holds and reports the
rest as a residual, but an atomic write cannot be short: SBC-6 r02 (T10/BSR
INCITS 587), 4.28.1, requires each atomic write operation to write either
all of its data or none of it, and 4.28.2 requires one that cannot complete
to leave the LBAs that it specifies unaltered.

resp_atomic_write() does fail a short WRITE ATOMIC (16) with DID_ERROR, but
only after do_device_access() has returned, and do_device_access() copies
one logical block at a time, so by then the blocks that the buffer did hold
have been written. An eight block WRITE ATOMIC (16) with a buffer of four
fails having overwritten the first four.

Check the length of the buffer before writing anything, and fail the
command with the same DID_ERROR as before.

Assisted-by: LLM
Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: John Garry <john.garry@linux.dev>
Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Link: https://patch.msgid.link/20260929082456.857423-26-cassel@kernel.org
Signed-off-by: Martin K. Petersen (Oracle) <mkp@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/scsi_debug.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 5654fb8f18362..b1e0af17113eb 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -6080,6 +6080,14 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
 		}
 	}
 
+	/*
+	 * Short atomic writes are not allowed: SBC-6 4.28.2 requires an
+	 * atomic write that cannot complete to leave its LBAs unaltered, and
+	 * do_device_access() would already have written part of it.
+	 */
+	if (scsi_bufflen(scp) < len * sdebug_sector_size)
+		return DID_ERROR << 16;
+
 	ret = do_device_access(sip, scp, 0, lba, len, 0, true, true);
 	if (unlikely(ret == -1))
 		return DID_ERROR << 16;
-- 
2.53.0



