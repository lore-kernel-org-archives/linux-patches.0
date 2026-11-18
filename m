Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031739;
	b=H3AulNuSQ9QQ+NTYT9Eoc0WeOA68S347y3qt9F4qSrfclQZRr2F8wA8baPm0s5vSYaS7
	 2dZqGzLOKVSSs1JWNr4UVJI378ZK4/kCEyl2Q5RDtZtClGLbLwWk/0j9MrMtXkaVh3eKU
	 SGgCpoWOaIU0oL/A8OXryRW+1/IBoIWAmoSd0IVsIfsu2SVTh0j2oE8ik9On1R7cYsumO
	 9JFEC+/LwiQHxnM5wRz6JOhH8/71VyLJLMw9YwkGu3ounqFvkeZAqVqid3jV2r0lsTHHj
	 +HDbj7bzQLoc/mABEOc22HltpaB4RruazAJdyHd9K1XqKDFquVbMQ+Z5F77U7dwZ1/Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kN0Tc9eJLQKh6LWCYJPa4PXzqhh7PZFP3XfR/pLEubk=;
	b=x/oUA1nw4mWzZmC0l8im7+8dQH7ouGxDZ7SjFqOj62MuqhreIxIlBI+f2BMk2emHYE6W
	 7hLF9AJqqUXzRB3ESwoaSk5bfOplRH7oWKCqmFyZjxku0lDp90pp9UNHBfyiTYhR0MKE0
	 6jDiI8Qzw1HIFyFY6jrqzafmJCWwQrG3PWFlZzjsP621lkZsy/n02QS5YWdwRZ8YrchAW
	 sjwig39GcRVbnIDhFR1UeqA/G430VfBjh1b9KT7rPFmyjNiz5Ll8dXGF6zzflfrhhiF/C
	 RhjVSmcOG1UT/0tRKeE8hdS0Aam8vQeCCPSF8GSP2YsPsPTIzoUjY04e5uM+elIi/aQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ahp8wKS1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3286606A320;
	Wed, 18 Nov 2026 19:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ahp8wKS1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5459C1F000C4;
	Wed, 18 Nov 2026 19:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031738;
	bh=kN0Tc9eJLQKh6LWCYJPa4PXzqhh7PZFP3XfR/pLEubk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ahp8wKS1ro/wEdDUaAPMoxHAjqV+wLPsMuJlGVVIAR3hjCWvCJyCLjNQt8syc6agd
	 tqobr9x3de7J32uX8x+MfIZfu+WakfxPXRTLK5NETkjuvDVtioksT33aYYYExC4rsx
	 meqauP6IG0XmTJmQl/iqpubnih2X1OPhuM4HK4MI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sung Byeongchan <tjdqudcks0424@naver.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1147/1756] nvmet-auth: reject undersized AUTH_SEND payloads
Date: Wed, 18 Nov 2026 15:54:34 +0100
Message-ID: <20261118150055.701839245@linuxfoundation.org>
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
index cfd1fc6032593..0569f0e120c75 100644
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



