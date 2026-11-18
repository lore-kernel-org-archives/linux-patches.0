Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041439;
	b=bX7rj2eM6iuQjUNL34eJQBjy8AZYGM3ucVOfk5xMxZtFzWPGpdURWBFENSxvjRQ73mdT
	 MfbFVM7/5zQt0RHSc7ErNug13Nwb/4oJfYJL7KAYMtbo7cHe+86jMCJGN16+4vkYfVVCA
	 egHAjgv4k5WnKL2txKEk3pKKlRNan0rHGvRwtgiqzLbL3N8RXrXdOSQIbCGMTLIFMR0CU
	 h7ViZX5h3wFDV0zRYQJngW+yIyD1Ean72FgsDnKKgzCE2X4KXp3+8j+LHFflaoT4X1nvS
	 RyADn6+0qn1PzkStQ1RiWNLkVMNXVrYBxQDDOGXs1jJIGPPQ9snkN4OsHUJlbnHHatw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041439;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=wwtfg7zCBQ1mMl6UlSfUMeKCZwG15C5TZ0MUwyc4us8=;
	b=YpRQccEDyhHh27COLx9ggavFr08E+yaPmtQXNrfjITXTOZTc3f0UvmEWLrUjP2yg+NIy
	 kT3y+LhXLPP2Pq3pegZL/n1ZzeVno5NbbY1cPPr8Rte7/qp+q91VoeKPDiqAs20/MbflX
	 iMjYPRpvCmaxux49lLCXrORU9nvCcq91PvhJYtY4t1QjqwoJRAyPxil6t7MFqb3s6H+6Y
	 ZN7XMZj1uRTk4MxjaXea8wIC5vIHkca/ioJHQL8YFqmZQEYv2ExO8r9UXR6yBmvN7WJm0
	 nhe9LllSs1Kc/K4YRbdHImcY9ZjIEYwPvHnG334itNjYt9d4p80jJR5unQi8+DqUM/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A8vincav;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2596660A5BCF;
	Wed, 18 Nov 2026 22:37:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=A8vincav
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 749581F00927;
	Wed, 18 Nov 2026 22:37:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041439;
	bh=wwtfg7zCBQ1mMl6UlSfUMeKCZwG15C5TZ0MUwyc4us8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A8vincavenctUT2gT8RaOiEcJ+j88LSzsu9wtZ2ttjGLss/JZHPBhJ3GueEIRhjCU
	 DRqZhs7oGZLkhga+b3dFYUec69cuyW74gWyBESqRdbLaae1xXlX6b70SK9UJlOqiYM
	 nk2eq3sC8snDxeJkMJ/0S4djyVKCUPaCgfVrixj8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sung Byeongchan <tjdqudcks0424@naver.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2815/3318] nvmet-auth: reject undersized AUTH_SEND payloads
Date: Wed, 18 Nov 2026 15:57:17 +0100
Message-ID: <20261118150445.104894581@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sung Byeongchan <tjdqudcks0424@naver.com>

[ Upstream commit c9359401036e8294c007a10e8c8d8da7030fcc76 ]

nvmet_execute_auth_send() allocates and copies the initiator-supplied
transfer length, then reads auth_type and auth_id through a common DHCHAP
message pointer.  The existing zero and transfer-length checks do not
ensure that both common-header bytes are present.

An unauthenticated NVMe/TCP initiator can complete ICReq and admin CONNECT,
then send AUTH_SEND with tl equal to one.  KASAN reports a one-byte slab
out-of-bounds read when auth_id is loaded.

Reject payloads that do not cover the common auth_type/auth_id header
before allocating or parsing them.  The one-byte trigger and
header-minus-one boundary were cleanly rejected in three fixed fresh-boot
runs.  Exact-header, valid DHCHAP, wrong-type, mismatch, and zero-length
controls remained clean, and a following valid AUTH_SEND on the same
connection received a response.  The touched source is unchanged at
0c2669a9f4a1d607e7591ae50ccf3c432a0aff08, where the patch applies and
builds cleanly.

The demonstrated impact is unauthenticated pre-authentication target-kernel
denial of service.  No disclosure, controlled write, RCE, or LPE was
demonstrated.  The source reproducer and complete logs are available on
request and are not included in this public report.

OpenAI Codex assisted source inspection, test design, patch drafting, and
evidence organization.

Fixes: db1312dd9548 ("nvmet: implement basic In-Band Authentication")
Assisted-by: LLM
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sung Byeongchan <tjdqudcks0424@naver.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/fabrics-cmd-auth.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvme/target/fabrics-cmd-auth.c b/drivers/nvme/target/fabrics-cmd-auth.c
index 24bd7b45a6d84..14379fbe42961 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -256,6 +256,12 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
 		nvmet_check_transfer_len(req, tl);
 		return;
 	}
+	if (tl < offsetof(struct nvmf_auth_dhchap_success2_data, rsvd1)) {
+		status = NVME_SC_INVALID_FIELD | NVME_STATUS_DNR;
+		req->error_loc =
+			offsetof(struct nvmf_auth_send_command, tl);
+		goto done;
+	}
 
 	d = kmalloc(tl, GFP_KERNEL);
 	if (!d) {
-- 
2.53.0



