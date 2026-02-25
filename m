Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 507112D8DCF;
	Wed, 25 Feb 2026 06:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002625; cv=none; b=BFMNK9t9ZBXGSQQFJJn2GP9zQu9uv1XhLXI/FYANIqwDFKxYUwyeVhDgyfTUOlOkasfxt61yeAZez4a0vwFdaGaF865m//Jzl7CZ5pZP4Izy/tlOddCWTCKdMM9+MzMlFXPUrR2PtOtbb1f/LH93ul0+vLzAOXW96WsNdSlCXnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002625; c=relaxed/simple;
	bh=RBeiJDizYEVtGGhvQ1Kw32THGger99+TXmWIxOhkB00=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pg51/q37HmBWWQD9lmTV6UpUEco8H7VCN+v1EH94wVq0BwfYQe8xrv+3SfC4Gj2KStbGFYY4gh4HRzpUyJJkdUt/MX02P9DH8wqT307j543Qd3tAaiHOIGL3yAfs0WnokrFx5M58ePFv416p8PDNuw/jqVwpxhetgq9YnxZBdus=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hnNrhzLi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hnNrhzLi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C6EC116D0;
	Wed, 25 Feb 2026 06:57:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002625;
	bh=RBeiJDizYEVtGGhvQ1Kw32THGger99+TXmWIxOhkB00=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hnNrhzLi0jbQ7fTHjrXm8HzeLbFzQIJptYgYG8ph/EPigPps4vFVMLASg2/zwT0BB
	 sKW1R5fkJNeeyM0gzZK0ovhtIfiKzsjwYELPsgwZK3biYqBzWMR+Nf6o90ZEpWORjc
	 0SWmQywjLobOZovE4uNqnS1kK96+A3mu9UB1uWnk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 385/641] mtd: spinand: Fix kernel doc
Date: Tue, 24 Feb 2026 17:21:51 -0800
Message-ID: <20260225012357.916198460@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit a57b1f07d2d35843a7ada30c8cf9a215c0931868 ]

The @data buffer is 5 bytes, not 4, it has been extended for the need of
devices with an extra ID bytes.

Fixes: 34a956739d29 ("mtd: spinand: Add support for 5-byte IDs")
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mtd/spinand.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/mtd/spinand.h b/include/linux/mtd/spinand.h
index 927c10d787695..1c741145e4971 100644
--- a/include/linux/mtd/spinand.h
+++ b/include/linux/mtd/spinand.h
@@ -287,7 +287,7 @@ struct spinand_device;
 
 /**
  * struct spinand_id - SPI NAND id structure
- * @data: buffer containing the id bytes. Currently 4 bytes large, but can
+ * @data: buffer containing the id bytes. Currently 5 bytes large, but can
  *	  be extended if required
  * @len: ID length
  */
-- 
2.51.0



