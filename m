Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030808;
	b=ueZxQKna7YmPJvM/5ovfauuNBxzb2E7eBJLe59cc4tD0dJaV8WlVy0E4c+tSa3TLS8ri
	 4NW1C23Z9R37OREPNJ35eLNpiz76WbRxL3yoHwwlG/WXm/o1V962lDIzu1ZAkjp+hUVQ3
	 COP1qreIMKeWqtd8wFFh+B34VzhYKiGO5hoxuNEdSGqChjeiLY3WF+X94sX9MhDFfihyO
	 T9YEVvnHB+NcN9FQjGCcFN4CjqKKjRkJg28woMoedNubjimQCqBKRuJIOPSnCifNLZ17f
	 wiqrp1KwAutG/BjouDlPt1yQkdSSCb9JxoYyPdtpTchOmC037KpEgx9rS3B0h7JiqNA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mCeoMsf5UCumX1TlbEBmAHfPaRmiVo0qqk20SkbIkng=;
	b=axqeArFHw1mlGQVFXk3UTT9NTbospP6Zu6T+fbkXln9M9USkFpQYTu8fMwDbE4lt31im
	 zwhfyUWIrQmQQSG2oVzxeAbaMJFIwogn3WiD4lpd/lgBhBoihq7h9NV3ymYtfc7my3R+x
	 fSONds4cvi6VNSBUWnRtr+B1nhdjM4cTTWSlKskUCgZV4p2cAwAkaIKDjQar9AeyqOzuO
	 TWlsiggom0cptkmztYMUaER/5SziWQorp8WCjFWa6VRvp4rSFptKp5QSY0kNlYCkjCgy1
	 XxeEI9oFujyofmtNSUcRsZTBpR9OBrW4CodaYORHID/ODEWMBKlc8rEEsoMM2OsUOUg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nqNJDRsI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D82606A92E;
	Wed, 18 Nov 2026 19:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nqNJDRsI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362851F000C4;
	Wed, 18 Nov 2026 19:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030808;
	bh=mCeoMsf5UCumX1TlbEBmAHfPaRmiVo0qqk20SkbIkng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nqNJDRsISfBZh850DdRI/W37+B6c1Y6EbcKD5lhP8oYIA1Axt2JbeOrR03l0Yydf2
	 mbxvJCWJYNLQxR6T2cGK6ZMPwBhkr9RhkcpoKELjbKcOg3HuMRK6YjhSLAsywsSxs/
	 5oTNoa5ljKZZ275l4wnKbI7aroSbb3UKobG97KQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	John Garry <john.garry@linux.dev>,
	Niklas Cassel <cassel@kernel.org>,
	"Martin K. Petersen (Oracle)" <mkp@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0795/1756] scsi: scsi_debug: Refuse a short WRITE ATOMIC (16) before writing it
Date: Wed, 18 Nov 2026 15:48:42 +0100
Message-ID: <20261118150041.352229670@linuxfoundation.org>
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
index 289f298c759fc..961496432fcb3 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -5379,6 +5379,14 @@ static int resp_atomic_write(struct scsi_cmnd *scp,
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



