Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016831;
	b=j6OWxbq69/adesREugJfYKf/D5Fqyp1lKx63daMY/4jTMe2+gkhAKAdJtf1+dp4e0+hn
	 Ni/gYFTFg5DYDZrV3jJ8K8fY5a6eZWrvGDqtLXTPvC43UC3qHUfeqBgtMhMAF9IKsa6Wo
	 U8fX2lZxuo3o47UOy+MXfahsuoEjY3iIiI4qdbuJV0KloKldUCggyUzw814Pvxrf3LmVG
	 BG2IDQow9xF9xXv5in6StlEcgcwh2JyhHQumDq20OTJon+eV445lJSidmIwfvo1lSOAge
	 +VzrY/1V+fz+GtdI7oRwM+9/c6u0h7ZoAJ/A+pAQSVArgd8p0PSNeq2U8F176Iz77SQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016831;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ITC3wimASs5pTwH0x9+7ZC0TfqwkSE2H2oMQIbFOeGo=;
	b=PftwFfSn29qnpBFhQeXo8IN9mQnUu1rOOhg0C8NZ7feqr5HQpeNdYJs66glY/q1OC8PF
	 cycf4/ecBbLs2EA3aBgH7ozuYqJOQ/bnB5l9RFWiDsAZBzCr3wLadEHvr/lpSLsD8MMjJ
	 AO954TDwvNOkdQjaR+mSh2oMf+zBb4Bn+ahaT4NJLmHQTKSdUq1S9LpKNTmQnVMX8uo2n
	 8GiL+ndH9kSZ+ax/2R7zqSc6LzqKPa9k+k7zAwLNKUNtAtRraRpXzwf9PgvBaPAy9t3OQ
	 D+JUSHaZVLP42S2YMfYc1GaEguut4l8B85qGa54ElFtM80QBic99K00qcyStULkS6GA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a7u+hNlA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73BCE606A320;
	Wed, 18 Nov 2026 15:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=a7u+hNlA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C733F1F000C4;
	Wed, 18 Nov 2026 15:47:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016831;
	bh=ITC3wimASs5pTwH0x9+7ZC0TfqwkSE2H2oMQIbFOeGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=a7u+hNlAZiiqQDrJwrG6ksrbqgfnJ0TItE7mlYUgSgFZaUsCAFXpvPcOCDsrzi0S7
	 0sTpRp8lNw1nG3JT43SttDQj2Prk6KJraxCRXT+rByQy3BenAYjq1r5m/rhqITT8Da
	 Ofo4T2UNj7vHU8fFIknJnJ9FDdz8U9SmVVpgoSeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Niklas Cassel <cassel@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0668/2651] ata: pata_parport: fix parport attach idr_alloc for
Date: Wed, 18 Nov 2026 15:31:48 +0100
Message-ID: <20261118150311.921965419@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 193f5b84a95c02456f51fe5067750ecf73d213d5 ]

idr_alloc() expects an inclusive start and an exclusive end, so passing
port->number as both arguments produces an empty range. Because
idr_alloc() only falls back to INT_MAX when end <= 0, the allocation
succeeds solely for parport0 and returns -ENOSPC for every other port,
which pata_parport_attach() silently ignores. As a result only
parport0 gets probed and any higher-numbered parports are never
attached.

Use port->number + 1 as the end so the range [port->number,
port->number + 1) contains exactly the desired ID.

Fixes: 246a1c4c6b7f ("ata: pata_parport: add driver (PARIDE replacement)")
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Link: https://lore.kernel.org/r/cee1a15d98cd0d55f41fd65ca9d222b68a74e7d3.1790047457.git.xiaopei01@kylinos.cn
Signed-off-by: Niklas Cassel <cassel@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ata/pata_parport/pata_parport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/ata/pata_parport/pata_parport.c b/drivers/ata/pata_parport/pata_parport.c
index cf81a6128f552..f0fe921a10b4e 100644
--- a/drivers/ata/pata_parport/pata_parport.c
+++ b/drivers/ata/pata_parport/pata_parport.c
@@ -723,7 +723,7 @@ static void pata_parport_attach(struct parport *port)
 	int pr_num, id;
 
 	mutex_lock(&pi_mutex);
-	id = idr_alloc(&parport_list, port, port->number, port->number,
+	id = idr_alloc(&parport_list, port, port->number, port->number + 1,
 		       GFP_KERNEL);
 	if (id < 0) {
 		mutex_unlock(&pi_mutex);
-- 
2.53.0



