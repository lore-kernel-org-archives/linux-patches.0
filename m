Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050065;
	b=4bA+HwGjCjU/f2CU0QetbCFcb908pKFVu3YdEBEP/wO+G1s4CV+CiaApZOUSgjbCkacJ
	 KgULRTSKUgDHs5EUJi+jVUPldAKFL4/mMCR6qTKxD0rMvWymSeSwqpV2UPG8Bzztrgfxb
	 KLqIZA2J9V9on99JDoIvlEUV1CEmsHK9lZekL85/Dkl5j+TN87tEHp7WVm6GEIb8h4UmE
	 scH3wZ5aP1AsNVMhprUMIZVKxJmWieTKczy+BFuPsKN/YBjtotMAuSL1q0DtpWuFP0fiI
	 USvt97C9fnIiNMnPImV76U1roIo3QjnuJ33134caAfeawvEmgPENqLpiCp0aihN6W4Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050065;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XRG1gu4gUkpd5hlROYN/vbogTkycR4+bVimsLp7o/tA=;
	b=rnSzCqn+JHe4bL4xrP0I7wxamBq4+t+eZmofwfN2YARSi2q/s6wIzzFEfuRR59lWeGD/
	 q4ng5PtWQQl3l//CelgbkErDji5Uc1tVzxuRlaevzG94ZihiQtey9WAEsAOFYteyYVbYI
	 LM41a0I66Q1vWUavB6Usbb81lI/nn/dfhY5P7Ku1t9hSjUg5L80B1jaVuEkWHUwIaIpaE
	 l3/fLHRKvinYTPAUdqvdyPNYNpcXdbBr+TYq52Q7dhaxwJ0evlp061BocJV+HMaW1ui+q
	 +J44DFLww3+fQXLAXMukQVwn2DbPAiQ3rUdquyyx41fRaEjDWQss6I+jRSns7KcObmQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=alpkOfF8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3955606A31C;
	Thu, 19 Nov 2026 01:01:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=alpkOfF8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D93B1F000C4;
	Thu, 19 Nov 2026 01:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050065;
	bh=XRG1gu4gUkpd5hlROYN/vbogTkycR4+bVimsLp7o/tA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=alpkOfF8oP/nXHkkasnc2BO2+pW5hWG1PX9gQ54Bhj1P+4dDkDF5JZ32Wo3ZlIbMa
	 aU2LMfJqchnxPl8IWFDxc+gv1P1/mxnUR2A9hTcHr/rHrbw+XTJKF8r/t1KcPdmJN2
	 K3dcayAmxsGmCrMYyd8KQl54pjDkaqhN0Xvh9GjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fabrice Derepas <fabrice.derepas@canonical.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2574/2857] ima: reject a kexec buffer whose declared size exceeds the buffer
Date: Wed, 18 Nov 2026 16:00:08 +0100
Message-ID: <20261118150334.166998644@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
index 04c49f05cb74f..0a802072490a3 100644
--- a/security/integrity/ima/ima_template.c
+++ b/security/integrity/ima/ima_template.c
@@ -449,6 +449,11 @@ int ima_restore_measurement_list(loff_t size, void *buf)
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



