Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07E0DBA3F;
	Mon,  1 Apr 2024 16:53:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990421; cv=none; b=J9blnZfkE9FiEKCF2XhEKT7tGpB2476emOmgNvOPNJYJuSHZqnh/yq+UkcAn3UC9LkGxQyl4a2r/ZNjrNcY2zA5NvRSTK8TO3ZGan3GGFiSUccCZGLOULbyEmlpFGUf0dK9gb5eY68JWfGoQitmX79dfiH2COzknV/N1PTQgS0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990421; c=relaxed/simple;
	bh=NIY8puAGASryV0kPAxeY0Tf9MnhtqA0zEaBUmjLnfjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5WEr2K+90sz01VatWa5mH2+fGjq/gPfypvXnxIl6XCin/31Qe/er96NRwPqmKQ18zT3W156gtXgV0eHhwGNEy8tVgaptO06PpwDhhiI2F9WVQoQpKfUhVqJnmkPSPb8FXR2RGzGt/v8MWcLAJMFyr+NiJE6DEpZgFfE26yvwuE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afsRwCgT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afsRwCgT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82693C433F1;
	Mon,  1 Apr 2024 16:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990420;
	bh=NIY8puAGASryV0kPAxeY0Tf9MnhtqA0zEaBUmjLnfjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=afsRwCgTdxcOdsWx6i2EddsExRb+JpmUEOGx4y1hsZKYont0PgTLhfwhVyK8KIYlW
	 RB6BjoKSkughq0ea8/Pesl0qOp0IQAIjjJxLsc3CNUgwlD6c8/KcaVUXN9BrbwzSxE
	 vWIHELvn4EjKmGVeub2zL9SVAaPqbx+Sr3IEQsAM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ezra Buehler <ezra.buehler@husqvarnagroup.com>,
	Martin Kurbanov <mmkurbanov@salutedevices.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 6.6 348/396] mtd: spinand: Add support for 5-byte IDs
Date: Mon,  1 Apr 2024 17:46:37 +0200
Message-ID: <20240401152558.290857580@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ezra Buehler <ezra.buehler@husqvarnagroup.com>

commit 34a956739d295de6010cdaafeed698ccbba87ea4 upstream.

E.g. ESMT chips will return an identification code with a length of 5
bytes. In order to prevent ambiguity, flash chips would actually need to
return IDs that are up to 17 or more bytes long due to JEDEC's
continuation scheme. I understand that if a manufacturer ID is located
in bank N of JEDEC's database (there are currently 16 banks), N - 1
continuation codes (7Fh) need to be added to the identification code
(comprising of manufacturer ID and device ID). However, most flash chip
manufacturers don't seem to implement this (correctly).

Signed-off-by: Ezra Buehler <ezra.buehler@husqvarnagroup.com>
Reviewed-by: Martin Kurbanov <mmkurbanov@salutedevices.com>
Tested-by: Martin Kurbanov <mmkurbanov@salutedevices.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240125200108.24374-2-ezra@easyb.ch
Cc: Hauke Mehrtens <hauke@hauke-m.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/mtd/spinand.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/include/linux/mtd/spinand.h
+++ b/include/linux/mtd/spinand.h
@@ -169,7 +169,7 @@
 struct spinand_op;
 struct spinand_device;
 
-#define SPINAND_MAX_ID_LEN	4
+#define SPINAND_MAX_ID_LEN	5
 /*
  * For erase, write and read operation, we got the following timings :
  * tBERS (erase) 1ms to 4ms


