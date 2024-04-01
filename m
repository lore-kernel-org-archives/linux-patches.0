Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDCA71E86C;
	Mon,  1 Apr 2024 16:31:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989100; cv=none; b=FVvDhqWyqDYepdWoKWdBheh6LDC+GOF49v1wzBfZk00JhhpeNt1IeroyRsYMtx5L1tvOpdx3Q451smCgnOT9L9UcTfoIjesEpQY7Ucb3iX9EOx8pF9O+XrgxDG/IzU9JnM7sg5Htmq6UncbmM3/KErd/1g/Bn2x+JMuhlQGCfkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989100; c=relaxed/simple;
	bh=ZdwGR3dPrVRIYqvun8xd01TzWsvIT608CRVnwramAdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fLq2sKj1+DAbdCDN19nzkKK1SLzydirfVK9GsW0zbpffrJGO82qYixQc4L2KBIoVWIsrXqUOYoo8Z6NXNeYI+J+zieJUw6E8YjN8j7dse6SBatx0KaNmMhgiGl05ByxyQpMlmF9juiCfPZdq3XKqhFJ6+xSZ+yBYD+FBi6N9u/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZY9QC8LW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZY9QC8LW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63555C433F1;
	Mon,  1 Apr 2024 16:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989099;
	bh=ZdwGR3dPrVRIYqvun8xd01TzWsvIT608CRVnwramAdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZY9QC8LW+zPzLLS48ctV7ESTpVtGN8tJH2ONsOr+5PjwbE0ss5m0pRtfbV8mBu4lL
	 QprNcCcqtL0ZVQKSW3PxTJz115FMkKjWuOF1i5CzDwQDvTiKAWE8Rm8/ZomegkFzJW
	 pa9cclr44vx2pO2Y0Kkqx2AESAsK3aar4nhzjNkQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ezra Buehler <ezra.buehler@husqvarnagroup.com>,
	Martin Kurbanov <mmkurbanov@salutedevices.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Hauke Mehrtens <hauke@hauke-m.de>
Subject: [PATCH 6.7 379/432] mtd: spinand: Add support for 5-byte IDs
Date: Mon,  1 Apr 2024 17:46:06 +0200
Message-ID: <20240401152604.599689736@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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


