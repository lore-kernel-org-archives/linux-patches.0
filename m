Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042802;
	b=VBmq8Mo4OLqS8otQnyRswJcSzYi5+OuoFCImAKCZcB6Z9eyB+WkMoEVkMEYgETkSD9US
	 UFwxeIbFsdWhkuewjfSMushqln0WKQYiMF7/Pc3wk/CXltqaOYoTqMsWmNJMzVbVprERg
	 DlojIFbB4a9o+98ipCRvjDDh58U5ic8niwV/KP1KCYMuh20qY1Hq5FvvHed6G9iT//UPz
	 9WSAkkcLt1AW5+lpuHw2MBEfr45q2jxUuI4oSDoIZgoppzVtVXvtGM6sRMFCvMLBAzF7L
	 uM0fCfeRZWMom+PEDqAmyVzvezJCM8JE3E4paPkRHIx6X6PAW0q1PCMsmsJechAJLcQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042802;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=paTtQBU9gHc/Kwhmpyf6mARcdvDk2MABIdfTgqtQ7uw=;
	b=u6S6YhGhoGWjrswpopnv8GikoFqjyDQGfg+DJ8eh6ZL5/B2MtRs8sCd/Vya7vhVA1evM
	 4RDyZ7wrV98NZLHccg6bzvCfz3z0K8C4BviiU+Oy5dcgXeCgMNokCtjOyeuOY00ufFc2u
	 fAbxJCrvwfV9T4Y3YPbsJn15SDYkNhENo7h2Zew95GWbH2LNXw4H1dcsggJWMCxba3UeM
	 tl9zAy9sFNPVm9xsgiRICzupqrJfYhKvtmhEA8jNYG/G2+kikg2Hgf+Xa0NnpwzlAW8eC
	 GmXGjeEn7ljTvi/gixJkk9LOMagC30Xdc2AMz/XLWx7sJ0DsXDgzTRlssduIjXLTyNg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HYPxMz9+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E494606A337;
	Wed, 18 Nov 2026 23:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HYPxMz9+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B49E1F000C4;
	Wed, 18 Nov 2026 23:00:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042802;
	bh=paTtQBU9gHc/Kwhmpyf6mARcdvDk2MABIdfTgqtQ7uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HYPxMz9+s22lwUVoXmRZ2T+ptUnBvbkzdJl1wannj/hDRfOE2NpdRL2keFk5FXvY/
	 rJ448ZUwRENY+hA0JZ4cbQ/f+Fm3EcW+X9XgZ2icqNvGVcuVGdk8k7yW97+sPzVIBg
	 coqxdeLxBPD7TVdZ7OwCtDmRMTbT5Q647pKjk4IE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@kernel.org>,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.6 3301/3318] nvmet-auth: reject incomplete DHCHAP messages
Date: Wed, 18 Nov 2026 16:05:23 +0100
Message-ID: <20261118150458.622286407@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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


