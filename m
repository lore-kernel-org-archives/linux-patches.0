Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050806;
	b=T5cuSwtBXlNWx9z/ICweYTljC6v6FTLWEOuujCyOQ7CI49fYcgSijR2cyuwp2OxJ+tfR
	 +Jt8G7sTRZjxEnIRdk2GVXNfQkKXu+oHizf3cev8YzgDen4G2sEF5435o4Rwf6xygnlYl
	 UMw/+RXlTzof6Qg0GrrgyuynLY/xrrAO9Fcg+Y87GXbpjDkmLCh7DvvuMd+s4fL0zzBQx
	 NzI1zx8cXd7xZkomj9wV2YspDIOt2FmnzdkILkqSUIftKr8ypQOOE4iZYn84kcBpfaQeI
	 2mANc+UPdB3lVG1hLRCjdZA6Fd8NHMrT+iuPgCShxN9IPyNN26JJ6dQL39uteZ7nYFQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050806;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=f5APuip3XfM0V9fTvF8W5TimfXVUm9jhoPa1aq+MGsU=;
	b=sRi4+N4KcLoAmuCjhuwe6eO/Gdo8Rj6dTnxdN8TFOZzvNC6OyyAZ+Vad8P1ME9mVrgb+
	 BAgaPCbAMGuy+K+czA2eVlq6kYXYf3aupJ3PvaijgIspU9IjajMyeYgOwD5c2tsqEQuNH
	 3Am/VPGmG+6d2cxQdG4AaFW4a7r18XthIZagjseaAwzs1fvDqvz1Bueq7EDM/KV2X1SAB
	 wLVlpH4VV1EWjP2F84iyBiifIcwIxjlmFJJgiKlDBMSiTJ8qh165WHWWP+AFKG5iIMXDO
	 bWS/bI6r+g5a3n41gWOhLSkiMeqE8Krg8D6SvFBlHNM2o9Yds3ZmfRw3qi1+MA/DquA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SCnp6rrA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 081CC606A320;
	Thu, 19 Nov 2026 01:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SCnp6rrA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 581AA1F000C4;
	Thu, 19 Nov 2026 01:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050805;
	bh=f5APuip3XfM0V9fTvF8W5TimfXVUm9jhoPa1aq+MGsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SCnp6rrA+W5AuoAy8/VgIUAG2dTPcEp1Eu7QQImpcRKpMU+qJEJ0w10Camvthv/GA
	 dVg4yQ+U5CH50SSNMTaUnEXwHUXte3fC7girNUiLJlDnByE7E3EZM4wQAg1dxzBEvw
	 8FwtElE45fiHIZjjwGkGtHGBbCngYqoFky9aMLPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Hannes Reinecke <hare@kernel.org>,
	=?UTF-8?q?J=C3=A9r=C3=A9my=20Jean?= <Jeremy.Jean@oss.cyber.gouv.fr>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.1 2837/2857] nvmet-auth: reject incomplete DHCHAP messages
Date: Wed, 18 Nov 2026 16:04:31 +0100
Message-ID: <20261118150343.723428508@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -247,7 +247,7 @@ void nvmet_execute_auth_send(struct nvme
 		nvmet_check_transfer_len(req, tl);
 		return;
 	}
-	if (tl < offsetof(struct nvmf_auth_dhchap_success2_data, rsvd1)) {
+	if (tl < sizeof(struct nvmf_auth_dhchap_failure_data)) {
 		status = NVME_SC_INVALID_FIELD | NVME_STATUS_DNR;
 		req->error_loc =
 			offsetof(struct nvmf_auth_send_command, tl);


