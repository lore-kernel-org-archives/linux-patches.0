Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033688;
	b=mjTYHuiLRDzgZLdUGZ95qytjzdXY5Ltvso+Ob+j4xWA4DmoiBaBYYnPc6XBMOqw5ekh1
	 MTYE6bR5POS6M/rYBHomhinwqnpir9pQC66G6mInmUeb2bCiHqbUJ2r+du2/4CCMmo/EH
	 HGtVfCzJg9WSl6jcdbTqnewq1p3BWprHlejJB6km92bpbYFN7IpeQTPMbkYkRh6s7c0cy
	 DQAcfnawEWoXLC6P+SrUekKogx7GxeWFCvUxBFZrPs465L8Sozr3Jz2WI2p0tu75ulZKI
	 HQQE3tRvKIXs7YrsxO8oGK3A/VssAez+/Ej3XHOK7+TqlBHrfPz6MU7H7mFNoMOcgmw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033688;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=h3RQGDPXMP8aQ0gIUjFWu67FYdvLDJ3yt00VCMzLNm0=;
	b=rLR8fH61myyhZDx1jLTzjH14+oOP/jj+V0Slu0bzE4XWzuF9Y455K3hQsnxpCTJkj8gd
	 DG4tiniZBilaCa4MHmZhe7AqJd3nBI9HCYVRJQ9fTf7qoNuJkWj1+i1130sLE1o22XfZw
	 ZssJSR9aHPF3euzSBaXeId1mvMS0iwTY5wJk0PkXBricmqm1inErP3tHziy+Lx7A2npBX
	 SGtEO8Je4dhwVIHyfmqL9fZOpqjKj0r0TpRNdLpCbYgbfSoNVs/kfwBlkkH7bXvb6JsrO
	 oCjldiEAE4M4m7DjPVNsBJHpNiVSptw5uNhT8+sU5nYyniRPS0/GcnUI0QAhcod13bA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZHNKzDSX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A1FA606A31C;
	Wed, 18 Nov 2026 20:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ZHNKzDSX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A54F1F000C4;
	Wed, 18 Nov 2026 20:28:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033688;
	bh=h3RQGDPXMP8aQ0gIUjFWu67FYdvLDJ3yt00VCMzLNm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZHNKzDSXWqsxKORDUyMjosfgMeuXLe31iqKPDUjQnuZT5EXicCd3g4ZxqwzS5sOK+
	 fhfP00Cgtq4cfd2xupju2we8bWINc8PCI+5aXQDbfrEsw7Ck3DE2KXWRt+5gaTIKXG
	 VV0yXSKhII1qMQIKDdnW8Qla92eCjnndUA7mWZn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hari Mishal <harimishal1@gmail.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0102/3318] nvme: bound ns descriptor header and body to identify buffer
Date: Wed, 18 Nov 2026 15:12:04 +0100
Message-ID: <20261118150317.288523126@linuxfoundation.org>
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

From: Hari Mishal <harimishal1@gmail.com>

[ Upstream commit 3c568b35a0d309acb40746552bec2af24cd550ef ]

nvme_identify_ns_descs() allocates a buffer and gives it to the
controller, which populates it and then iterates the buffer with
variable byte increments that vary by type and body size.  But, there is
no bounds check inside the iteration itself except the loop bound
itself.  Fix this by checking and stopping iteration if the next header
or its declared body would go past the buffer itself.

Assisted-by: gkh_clanker_t1000
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Hari Mishal <harimishal1@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/core.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index af71dd259c3c3..7b5410e506a4a 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1400,8 +1400,12 @@ static int nvme_identify_ns_descs(struct nvme_ctrl *ctrl,
 	for (pos = 0; pos < NVME_IDENTIFY_DATA_SIZE; pos += len) {
 		struct nvme_ns_id_desc *cur = data + pos;
 
+		if (pos + sizeof(*cur) > NVME_IDENTIFY_DATA_SIZE)
+			break;
 		if (cur->nidl == 0)
 			break;
+		if (pos + sizeof(*cur) + cur->nidl > NVME_IDENTIFY_DATA_SIZE)
+			break;
 
 		len = nvme_process_ns_desc(ctrl, &info->ids, cur, &csi_seen);
 		if (len < 0)
-- 
2.53.0



