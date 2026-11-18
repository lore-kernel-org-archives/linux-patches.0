Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795051155;
	b=jS65/61+Kg8LeNjDjseeCck8UcVCjXFrE+S1ziBQjU9ThFbj3Y0OCrRGC1gLTDcmHbxk
	 SnQSgw6TJEIy3yLgwoE+JO2qeqJM0Dpq5rCG8In1ZMRHfs6ljFeI8fsQs48IVIaZYCJhU
	 XVFItLpVVbAQ64PYJ82xPGidOPk2ACa4m1NcUW7APbMHV48rtM95x+CZNljST0vUoi0Ej
	 w43f8pq/F08eEmXQexFZaeKUvlm3h/JvAWf10jy+cZSnNetYGWLvxV5FSrZLJuqa0qCHM
	 3VoRhrNWSAJrVCLAi7qQQv+gcDScpObkTwe9cFmntEU1bmsWmB3vjWOb/cjp80aM7kg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795051155;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pcvWGa27PwKh77mqHMFagaPmtikF67XdtoZaH/aPukM=;
	b=ittwO65HWpZOA6zQ/mtp+wt8hPFAFLCwNm+brwyO76MFywXQaewReJwmn0RAdHOc3ISV
	 HQ3NDVBcDBUHZ2weNhUYxv41O20Cv29cc6BmKiXSaqV6rizOsM8U5sf027Tep8o5LqS2N
	 tgWKjkNVKVWXKrc18C5IheutIiLD1vkI2BJrYXM5KA+lwYiv6v7QRFttrBFFUYFw1WMMC
	 y6rRi0LKTKInHpBr+whBgjei/Pe9Tzn3YJ3+5lf6hJrHTgkdn0qCtPEoaTcaNna3z9ZuU
	 i6yKnRE4DkyoeTow7Z17HAo0ezdM7/IrFxxFBVxnQF7zxIFKqhAHZHaroXnJgKg/ALA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IY35PV4F;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01430606A325;
	Thu, 19 Nov 2026 01:19:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IY35PV4F
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D22D1F000C4;
	Thu, 19 Nov 2026 01:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795051154;
	bh=pcvWGa27PwKh77mqHMFagaPmtikF67XdtoZaH/aPukM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IY35PV4FIi8fjbUG5BEPb/WGZmS5jfXi5IZuWOf0rnrJ2KQxPIVdxzhOUe1Q/cLE/
	 sA7fbJ54sQJpA4ZuSAl/9SPkWf2R2o/U2+O1Q74mQe2/a46MpGtPsxi7lRsfyFXFml
	 8nMOeUwCeUAutoLC/oVA9vR28TTxFjcUVB1ut8mE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 0108/2214] greybus: manifest: validate string descriptor header
Date: Wed, 18 Nov 2026 15:29:44 +0100
Message-ID: <20261118150014.237997269@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 18b6510f642dbcb856c3af8be974d1600f3ba2d3 ]

identify_descriptor() computes a string descriptor size from
desc->string.length.

Require the descriptor to contain the fixed string descriptor header
before reading the variable string length. The existing descriptor-size
check then reports the short descriptor.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260706091935.78020-1-pengpeng@iscas.ac.cn
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/greybus/manifest.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/greybus/manifest.c b/drivers/greybus/manifest.c
index dd7040697bde9..469da3f39afb4 100644
--- a/drivers/greybus/manifest.c
+++ b/drivers/greybus/manifest.c
@@ -122,6 +122,8 @@ static int identify_descriptor(struct gb_interface *intf,
 	switch (desc_header->type) {
 	case GREYBUS_TYPE_STRING:
 		expected_size += sizeof(struct greybus_descriptor_string);
+		if (desc_size < expected_size)
+			break;
 		expected_size += desc->string.length;
 
 		/* String descriptors are padded to 4 byte boundaries */
-- 
2.53.0



