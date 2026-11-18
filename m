Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049669;
	b=JiDXo+cyr0Lq8LhXeuqg70NM5FTqW67osrmjZCf5rpJs905G3KayYakNB65CIGBeHL+W
	 pdmDkyj3J6Lc+zDvWJgXGGQfGr/0JF4/3DDVSH776Rw6P9sVBZgeHHhsLnr+YWfy7GwMj
	 LGJiy6DlW7GuqzpfLm50gOUdJO9Pg4GxeAD3p3T8QJQfzd1Fsohw4dzTVjAvp5CUeIPIg
	 b0pO0SmIXyJaKGeUEjiYx6a6lC/MfJtpOchklNmu9Nl+MY7KrwA0cM+7S1dWmZ8DrtZGh
	 vHjLnJ6u8n0UIvk0KwW1WaTXlIJvUC+Mw+eykvrzOF5+IEipO4RTQpeRZkDI3IHz3Ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4Jf/k34qweDN4WVOLBgpqmkgQHMxHeWXGo0yU306phk=;
	b=qm/qSu+mbvkOTsI70AagddOPLTl57jRTIWvcdgEXvSuQSptahZEqhRgT8HWfQBFx62F8
	 yErlsflGjxQocg9nZzmIm7Qcva0W4pYPrGnLPKm1DqH/lMa6UurH4eOkTH5xhlT1JT4To
	 nDNQnkLzR/SpIRCRKA13N4DI0D4k88g6dmnMHBK0P1hv+r19DeTfoYL2DuF2tF9qNobML
	 hAuwRZ6dAR8Vz0dYurkzB9wBw3eQx9FUAMceIBywahKKQMVAW4f1eP8HjwNmvCdOZcgBf
	 u7RNf2og+n6BBPMDNFDx43YLHr6yIMMooqkMVzRVpT6eIZV1GWNyiN/CpeQ5RP3R1YQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gQhTDjK8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF279606A325;
	Thu, 19 Nov 2026 00:54:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=gQhTDjK8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547F41F000C6;
	Thu, 19 Nov 2026 00:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049668;
	bh=4Jf/k34qweDN4WVOLBgpqmkgQHMxHeWXGo0yU306phk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gQhTDjK8LN8IV1wbLrR41ZibndD0ks11iYS05/HrXfeeA/pGw0I41QMWGltPDlquB
	 6UIWZVhmzGZ1dWpA9ko3rqNe+Lisz2is1AmhH8vVe2RyEVCo8E49HBibx3Zuw5ZTvG
	 uCy2irYw/bdFHLsSFuv1uWRkoFUysS7fw75CRZVU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sung Byeongchan <tjdqudcks0424@naver.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2433/2857] nvmet-auth: reject undersized AUTH_SEND payloads
Date: Wed, 18 Nov 2026 15:57:47 +0100
Message-ID: <20261118150329.171865795@linuxfoundation.org>
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
index 68815afd41fed..6628be8cd32b4 100644
--- a/drivers/nvme/target/fabrics-cmd-auth.c
+++ b/drivers/nvme/target/fabrics-cmd-auth.c
@@ -247,6 +247,12 @@ void nvmet_execute_auth_send(struct nvmet_req *req)
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



