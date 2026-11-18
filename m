Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022403;
	b=O5ohwcwOT/kBx3llb461utmuBo9rIEBvXRjillM89AGujUUda3KhtvXdH3GVeqDPMtLg
	 4Xbk9b6zTJQbTniYt6Os9sO3SsFZd6cbH+lw4/mer3SQakvFV/pczxNSt1NWvabBXaddQ
	 J3aNhc6aD2Uu6y/iV/AutzrAwq+Z/3tVYbGGJZi9OWGcxyp4oWUxcTtgI49h5i4KkpxJL
	 jD3ukCtepKvcgC7WjGCI7ymKDz/IEgKezWokUJf/UwAgXKcfmtamhYoSmz0TeEl4YyWEx
	 4WqZRYORgekU2ZLI1bfvGo4gHdnFdarrIAZ8xoXtvCCxVT34epLNg/GseW9s92xf3wg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022403;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=+xwqLpD1Qf17YUBbanbPN+OpujxHiKrY2BEgl7GRVUI=;
	b=Ee6Mo9V85B+6ikJRqfDaVMRkuhnfOY1A2EM3ACam7KWx3qQA6gpN4dtt7t1r/sNYNgHT
	 atByVqVUY3K0OLxpPlebvfbino1MCIOiS9W4vwMzTjzvu4TeFgnbdeHBTgEeA41lNDzCA
	 uGJeE8MKMIViYisVHfLpMLYkYKaNKSpLz7MJgek5CTg0hpikN4cdyxE6MAwWF8B+4XT1z
	 S79XbvOIBygyHa6WfP5UwEKdSJi9I2Pkkgo63LXGuviEsQxABPaZEXQ+38/MdGSuaEV35
	 v+0ixwTyKrg6nBML5gV7v0bXSKE83l1W15YdDbHcSt4HlS3a0k/jChCZIob6YDfoKCw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LRiOkrT0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A59E606A31C;
	Wed, 18 Nov 2026 17:20:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LRiOkrT0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B96C1F000C7;
	Wed, 18 Nov 2026 17:20:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022403;
	bh=+xwqLpD1Qf17YUBbanbPN+OpujxHiKrY2BEgl7GRVUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LRiOkrT0ZHkQJ044yJSJXgyBrw8MYMIAMU9P2xPnWJ8g9zhvozihh1rK2Ucj6MKou
	 xyxol+5KIjVS1LFLwZNicc1p2e4NLg/QahMyLvXS0ZlUuz5t17XoiELxYKEGhjDaBq
	 KxlSJXBRRjYjYIbYIDMQnYP9iU96Cwq4aIqWdY/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@kernel.org>,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 7.3 2649/2651] nvmet-auth: reject incomplete DHCHAP messages
Date: Wed, 18 Nov 2026 16:04:49 +0100
Message-ID: <20261118150419.425735979@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -301,7 +301,7 @@ void nvmet_execute_auth_send(struct nvme
 		nvmet_check_transfer_len(req, tl);
 		return;
 	}
-	if (tl < offsetof(struct nvmf_auth_dhchap_success2_data, rsvd1)) {
+	if (tl < sizeof(struct nvmf_auth_dhchap_failure_data)) {
 		status = NVME_SC_INVALID_FIELD | NVME_STATUS_DNR;
 		req->error_loc =
 			offsetof(struct nvmf_auth_send_command, tl);


