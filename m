Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026460;
	b=DzVgyW45Jc/p9/wP8Z5TfeYUWNozeRDko+fb+O7iRo9i0Wqd+m31YGvgHgpjNCK44KhL
	 7eh6SZ12v65bqrPP/g95OY/OeSXUE/M68YRuflkywh9XX+MOOeEw9kNa0PdhGLCXE+C/2
	 KiDWLj6szKTBjC2YXWaJkTe9jfHuW4JubeuAmogOV/Nj+sLoIyWsjt3xVWK7CDy0LTuI8
	 +hET2rA/jYCp9jFpACDbrQHTNei50AtBUi2e9ut9bQCN5F9vrTlCSm0Sx8gg0XG6X7Kxt
	 6uWOozVMnxXkAW78hzKDLG3isCqsRYtBZ5DEfJ43MK1XGM2MeE53BMV09QhXlXiBxKA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026460;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cpH1w1XAU2z0MU9niRi2rDNxzwoevj3kxfBEDArmfXI=;
	b=2q7+yNq0kIysgrfz979zMTpFJqrrjGzoUGFc7OVKgaY5ztVVITimynIXWQ0sg22ds5R6
	 Om1etm7EoaWZk79OSZMCyOe6nfIy1VM4UPbB96/OGru/ISTHKkMW7aUROS2azqIAyGpV3
	 hrtQ/rp1Hd+la0TJgFMbqxcF2JiF3hib7Z6a+H/Z41yTk9K8SBZuVhgkGjqAX3jLb1Qgd
	 tgONxQ5unrMIhIm8wUYxQPtxjHnjuVpU1JGC5aQnNm8K6A9/dPmjQjffGI/vYDuDqIqXm
	 q8SpW/NVpD2ZW41BOl5jbPSyPW1LlXFRIZAqVaumlfCnnfRIWC5GjAazcSNh1VT/cyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fPPRYWRb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05FCF606A339;
	Wed, 18 Nov 2026 18:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=fPPRYWRb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 528B81F000C7;
	Wed, 18 Nov 2026 18:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026459;
	bh=cpH1w1XAU2z0MU9niRi2rDNxzwoevj3kxfBEDArmfXI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fPPRYWRb/eH45LiVEleqfMO00eGDnETTR2GNHIMrUf5kRFHTJnZrjOvVvdZqcWxOh
	 JYflFSzHi0MzW4Y5PSNV9+oPoi4JvJnMoBqHnavr32fpNYUtEIi5E3OYrzCzra/JHX
	 1jMbw/XsAdZNbEy1jAQUpm92F9f4U6LjJxHfiTS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sung Byeongchan <tjdqudcks0424@naver.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1443/2151] nvmet-auth: reject undersized AUTH_SEND payloads
Date: Wed, 18 Nov 2026 15:52:58 +0100
Message-ID: <20261118150214.499311331@linuxfoundation.org>
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
index 61a36fb54e877..846ba4c8ec249 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -303,6 +303,12 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
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



