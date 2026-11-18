Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061808;
	b=GP2/Hj/JXmIs0nLllgWPcaeW5gjlkBJhoM8h+ysdy9i8y6Wb3x6MQABRLTrtDx8tWwG1
	 oQneCvxTrCwN0vdiTvwsJpJ0mt8CJYy3qnrzVRvNRkKCPW/tqbMexcRmboFvES4pVeBXh
	 WU/xNwZFT9zW9ohDQ9AgSSl9VBUyZBsw4hvVEiKxixJYvAV+W/tDZcyzlWrWabTm8BwUB
	 gmiK6pktbvda1XUsZQnYvUEsftTDxGFKHbfCzcM/FlENKAwwOfgAEkZwwfltJLZQzAQcX
	 onTMGyjWTYZ6bh/h/zQysX1RXIF7SoXCXlHyQCd2epFCCwdRhPeblTtFNr/b8utqvCg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061808;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ke6JuAEPMdgKQYP/G6rkr/b0pSkt4F8wSxba7c5fk8k=;
	b=pySjOY+E6K3xvXvsFp1hcLq2lhlLyrR4mfP38k1VRcEWB/wNc4Vmc4ie4zwN/x65cCr3
	 zg3R863i3eq3cvy3yLXB7abWoz50QxXgSPCYgCyiwKDLs02/NsSytl/DnyyixwOxxaWyU
	 KXrrNnDdy/WL/XtTkfeSi/b4Shnxi+fW6wvW7nU97UvSdobDETLNuDVkKIL0csFy2kQ1A
	 L7BTQccQufTR5r7OsnHdU+6lqXZZq1Y/A2gI3yJghpbW4sYxEPR+BAhc2xnqu+eFV0yX9
	 S9Ozg5vwPP1Batavo2hp+MqtEABqfc/1O+DhPra0CNZh3yDMU06HtGi1G7xbsflFElg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MFQoZdGw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4520B606A320;
	Thu, 19 Nov 2026 04:16:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MFQoZdGw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC501F000C4;
	Thu, 19 Nov 2026 04:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061808;
	bh=Ke6JuAEPMdgKQYP/G6rkr/b0pSkt4F8wSxba7c5fk8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MFQoZdGwkYIFhxhFErGfmBTEYqm6SmZ/IFSUzlY5a8+7t9cII6XJPwrPCsnlvNqyo
	 h1j9VoAnEljzFp5fufRmLODfWXjUanmDaA5QULCqkbrXtS3saC3ribC/a+JHff6XKx
	 2zP1w3vEzJ0KL9tcwNFs3MBE7mJnAKwtVT3+7bnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrice Derepas <fabrice.derepas@canonical.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1683/1848] ima: reject a kexec buffer whose declared size exceeds the buffer
Date: Wed, 18 Nov 2026 16:02:01 +0100
Message-ID: <20261118150030.227278530@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fabrice Derepas <fabrice.derepas@canonical.com>

[ Upstream commit ceb24c7052cc4649e3b52a51a7cca7dfe4896cec ]

ima_restore_measurement_list() parses the measurement list persisted across
kexec.  It computes the parse end directly from the blob:

	bufendp = buf + khdr->buffer_size;

khdr->buffer_size is a u64 read straight from the persisted buffer.  The
only length checks in the function are size >= sizeof(*khdr), version == 1
and count -- none relates buffer_size to size, the actual buffer size the
caller (ima_load_kexec_buffer()) obtained from the ima-kexec-buffer region.
ima_parse_buf() bounds every field read to bufendp, so a blob whose
internal buffer_size exceeds the real size makes the parse loop read past
the end of the buffer (CWE-125).

The buffer's memory range is validated against addressable RAM by
commit cbf9c4b9617b ("of: check previous kernel's ima-kexec-buffer
against memory bounds") and commit c5489d04337b ("x86/kexec: add a
sanity check on previous kernel's ima kexec buffer"), but the blob's
own declared size is never clamped to it.  Reject a buffer_size larger
than size before the loop.

This is on the boot-time kexec-restore path (__init) and the buffer comes
from the previous kernel, so triggering it requires control of the
persisted buffer; it is an out-of-bounds read only.

Fixes: 94c3aac567a9 ("ima: on soft reboot, restore the measurement list")
Assisted-by: copilot-cli:claude-opus-4-6 frama-c
Signed-off-by: Fabrice Derepas <fabrice.derepas@canonical.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/integrity/ima/ima_template.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/security/integrity/ima/ima_template.c b/security/integrity/ima/ima_template.c
index e5d941f485b19..fd7fd3929fd7a 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -399,6 +399,11 @@ int ima_restore_measurement_list(loff_t size, void *buf)
 		return -EINVAL;
 	}
 
+	if (khdr->buffer_size > size) {
+		pr_err("attempting to restore a corrupted measurement list");
+		return -EINVAL;
+	}
+
 	bitmap_zero(hdr_mask, HDR__LAST);
 	bitmap_set(hdr_mask, HDR_PCR, 1);
 	bitmap_set(hdr_mask, HDR_DIGEST, 1);
-- 
2.53.0



