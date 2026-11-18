Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795016284;
	b=R8jyMecFzfk74A8uGpB5SW4e93wmcUcgrZBpUMvmBKgKOYo+/N7erGtSKg6zHWK35cGj
	 KOAIxdO9Sp0LBe4fLfYqo3pC2z2SOf56WQllo7x7BXGTy7vgZPUe3psgUg/feV47iifq+
	 faBoe21WT636jnU2tkcW2UBRA4QDgUdY1u5xXsPma/a+IXRSeThYyUUw6t8Gl9BZPLd/1
	 Pi58kqR5yjHgMvV+RWErJp1TBEOx4r7Qs8WG+AL9VCUoLekUCMmyTS2q5dMZ2WXwbgS0x
	 BzsGyaXW6XtBSM3jOYsfOT3yXeEIwY0d3ro+aPO9KEL0CWch60hoEtxMGwUKAiIa33Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795016284;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gs6db2U2AcYlbyIfn90vcSCD1Swpo6OFO88p8YS2Ons=;
	b=ZyXbMrnNx7FNIkLimct8q8jovl7NbH5T4IBfStvZXQhcMNW96SvgU8hQUPpHgiKg5ZYo
	 jtqQsfgA1/YzPkrvqLUSznBQS2D8GcKbHJhxPZUfP4Zl117Xti4Wvt2hfRtIsWyrZri82
	 axwpOQ7u8J57QWB/gkKXg/dYRBDG+yUH5tqAz00X072NiaK55fR5Z8SV029YcRZJeSd6F
	 yD/np8paL1pbD3kwidAhLm+QfGFWHBNFHCOfU9PPw62caiOdxN/rp6xmT+30IeTMidqGs
	 y1S3dgQE4ECcW/bfmJRoSTbOqN3Q4CafzsZ9IhkJe2DMuM6gVXKPCNHIEv7bqSV3ixA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cnw7P2Ul;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF00606A333;
	Wed, 18 Nov 2026 15:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cnw7P2Ul
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73E621F000C4;
	Wed, 18 Nov 2026 15:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795016284;
	bh=gs6db2U2AcYlbyIfn90vcSCD1Swpo6OFO88p8YS2Ons=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cnw7P2UlrzjyagN0QHtUAw0sKh4kLqcLjsr0HTIpesalt3WXpSYkOx5wWJxKm/32U
	 zWZVszOowBJAGqJm2wkZ5kPGl+9mdoJqgxcBebH1tHEWmezO/46HRqkil1Hkf39dnY
	 V6tby5TMDbUtkxMd+DsvE6S6QUSoYBZ7IPz3WGmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0433/2651] spi: Fix the return value in spi_new_ancillary_device() kernel-doc
Date: Wed, 18 Nov 2026 15:27:53 +0100
Message-ID: <20261118150303.413539990@linuxfoundation.org>
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

From: Karl Mehltretter <kmehltretter@gmail.com>

[ Upstream commit 3742867ce96539100ed5f4c754f04273d8aa00d7 ]

spi_new_ancillary_device() returns the new struct spi_device, or an
ERR_PTR() on failure, but its kernel-doc says "0 on success; negative
errno on failure", which was never true. Describe the pointer.

Fixes: 0c79378c0199 ("spi: add ancillary device support")
Assisted-by: LLM
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Link: https://patch.msgid.link/20260911230211.11755-1-kmehltretter@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 5b5b3bc5f0d8c..172141650b648 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -2893,7 +2893,7 @@ static void of_register_spi_devices(struct spi_controller *ctlr) { }
  *
  * This may only be called from main SPI device's probe routine.
  *
- * Return: 0 on success; negative errno on failure
+ * Return: the new device on success; an ERR_PTR() on failure
  */
 struct spi_device *spi_new_ancillary_device(struct spi_device *spi,
 					     u8 chip_select)
-- 
2.53.0



