Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795028466;
	b=5PwmhHBjofx7USBt5RLzMwwhmmzyPiwklgqWLtYP9o3Le7ornlYbLVfBXv/8+g5M7YkC
	 zQcCVnjYRbsmSLJaHs9UkXFawE5qXCJXTNS1E1Gi/Oqm75bLju+0WKOhlR0Mip2A4OrJ0
	 DJlllCwKTsP2LlVk51tWL/WjWXcG9zQBeME8nowSRoOTM3zN4r+eTzi64p0Fm2qWXafMA
	 udgkceNhZQ4kyEYzmhd7oFrzhWvDf82NLa6TTGJMaTLTssOxJjEfP+HmbP+N78YZdYD21
	 DqsbIsk/sgbbtROzVmu5a0XtvxquLt3Eru87NJQYGEuZQe1g66/3y5hRT2dyLtk99Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795028466;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=FKpiB57BZt999fRgSOqvLgL6Ktrus0zAxgd4t9BjqlI=;
	b=JNZ5fDwPq3K79m1GRGP089sfowGLBDOq0bvDghZsIRZ6C2s2ZoNtxDW5oselK30TzZQZ
	 GJ5HKnOfqn+pIXysfFPiBdSEjXVi46kLdTTVnft8Gy9Lnl02wiAqE3zflfBkoO/pwYE/y
	 BKNneghlXIjbnedxfvOUOhalJdRYL536Il5mClcu00bMOaC6XeNAjcMRB+Wa9I4mR0n4b
	 gzbSfF4KhD0J/YRuAGstYLFtSLA7CRHxQzagHStekisRFjocO2fPEYxoeLHt/6YonOm36
	 /Fp/DN8KGVRAGN9Ff+ffWFJz1rI+ox2EXKTSjZmvi+CJ6kUUCb3T7t5JJPPmXjFL1lg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wKSR/FJb";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F92606A330;
	Wed, 18 Nov 2026 19:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wKSR/FJb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67DF1F000C4;
	Wed, 18 Nov 2026 19:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795028466;
	bh=FKpiB57BZt999fRgSOqvLgL6Ktrus0zAxgd4t9BjqlI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wKSR/FJbxm2OSEn96An1edgpMuOa+IvnXWeicgIRe5dwyvYEPOUlVCGcR02EwbdY2
	 Ru8Pw5Y8nYgbsLa3V8yd6gtROdff7gXit67o3mE14tDYtUNBaX0k1FIwGR69+joUBH
	 xCxDZjHHP0dpxpNbjQdGWgxcaVZbGabk7W1Y9kKA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@kernel.org>,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.18 2136/2151] nvmet-auth: reject incomplete DHCHAP messages
Date: Wed, 18 Nov 2026 16:04:31 +0100
Message-ID: <20261118150239.486498665@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>

commit 29e027774324dbd5321a67bbd16840e8f7bcd189 upstream.

Commit c9359401036e ("nvmet-auth: reject undersized AUTH_SEND
payloads") only ensures that AUTH_SEND has auth_type and auth_id
before nvmet_execute_auth_send() starts parsing the payload, but the
DHCHAP path reads t_id before it verifies message lengths. A two-byte
DHCHAP NEGOTIATE payload can therefore still trigger an OOB read that
KASAN reports as:

  BUG: KASAN: slab-out-of-bounds in nvmet_execute_auth_send
  Read of size 2 at addr ffff8880030d8364

Require the payload to cover the minimum DHCHAP message length
before parsing it.

Fixes: c9359401036e ("nvmet-auth: reject undersized AUTH_SEND payloads")
Cc: stable@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Signed-off-by: Jérémy Jean <Jeremy.Jean@oss.cyber.gouv.fr>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/fabrics-cmd-auth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -303,7 +303,7 @@ void nvmet_execute_auth_send(struct nvme
 		nvmet_check_transfer_len(req, tl);
 		return;
 	}
-	if (tl < offsetof(struct nvmf_auth_dhchap_success2_data, rsvd1)) {
+	if (tl < sizeof(struct nvmf_auth_dhchap_failure_data)) {
 		status = NVME_SC_INVALID_FIELD | NVME_STATUS_DNR;
 		req->error_loc =
 			offsetof(struct nvmf_auth_send_command, tl);


