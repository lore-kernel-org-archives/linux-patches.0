Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033326;
	b=gNm/74NiEONwrdbPLjTfCi3ATlCaY4W8bfZFIpdbCgW3xe4sQmA1qc6RdtEd8/nVWkI6
	 HR5Bir4bLqhVtjX2aZ8Bk0KvLgUyEtQllTciPKmbTamZAvLjt8Mt9JvkRsgrpfTRrM5+a
	 TYjOIYC+/ZP2i8zmI9tiEJ+s3ZwPk+iixqOlj+6n9ukkI3yMeurcN5k3bv2IEUoDG0C11
	 BC+lIqonJvir0VWZwRG1mvAhDzdlVi9oe3Uu4h2rCqDf+ocrRCAY6XzcAVjqMFdh2vJHa
	 Wf1NxBMr8GxfQb878dRkVXWRChOLV3NL/0xUW0IhT+MWHkroQX95EPuSlT9l+/XpOfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033326;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=/qoVA2TLNv7NptFbXx1vWeWjynQFGQ2vMFPAIjG/v1A=;
	b=xSuNZr+fI4wj6G6z6+V0zVwYA7vur180N6av72V9FgR9PuB6tQePW1iRqEzN/oK0IFg/
	 KQlAhh071hVKQdNZRFexEnN1oYaosOl0TtDP0ek3IzpI0nhzbCdvyST6eId0Mqg0HIskh
	 WH0t8GbItkHa+5yOBzfJ7DJVslANlC9JDojl+MuDTiJBuNLufeTHGqLrWSOI3+lSwX8y2
	 9OmKEPgdc0JScuB79G0rWfeSsWzRWyOeOdoVf5nHsjzy8TfEvbT2rLGjUg/mZ6CwJ1yXK
	 pvfRP8rraHPhbS/nS+rWcIH+zVwHg4WnERUxPdTp3swjWaIBbuL3V7DdLvTldEYBCIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="y/SBcMza";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB56D606A31C;
	Wed, 18 Nov 2026 20:22:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=y/SBcMza
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B04071F000C4;
	Wed, 18 Nov 2026 20:22:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033326;
	bh=/qoVA2TLNv7NptFbXx1vWeWjynQFGQ2vMFPAIjG/v1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=y/SBcMzaAQhjD4dKpsePAjhTllUaMlQ0ns0BT4YjChCE3IQZ4ebXJAee7ud8wXbNc
	 40cPTxRd2nMNX3R4jWzVzokPBQqx7nJ/rcGOPVyvBCx326ms05GxGLsPj2mbbuPfdh
	 E777fSEQtuhKfZz6Smn+I4TkkaStlwIMEU6HY/sQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@kernel.org>,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.12 1728/1756] nvmet-auth: reject incomplete DHCHAP messages
Date: Wed, 18 Nov 2026 16:04:15 +0100
Message-ID: <20261118150118.366476748@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -256,7 +256,7 @@ void nvmet_execute_auth_send(struct nvme
 		nvmet_check_transfer_len(req, tl);
 		return;
 	}
-	if (tl < offsetof(struct nvmf_auth_dhchap_success2_data, rsvd1)) {
+	if (tl < sizeof(struct nvmf_auth_dhchap_failure_data)) {
 		status = NVME_SC_INVALID_FIELD | NVME_STATUS_DNR;
 		req->error_loc =
 			offsetof(struct nvmf_auth_send_command, tl);


