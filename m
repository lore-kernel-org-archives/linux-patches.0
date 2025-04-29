Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892B3250C15;
	Tue, 29 Apr 2025 17:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947833; cv=none; b=PYKWIzdyXnS+RomZdAru3n4i/btEMfZmSl5DnUaPzBzUuQS6CrCZIru8Npx6aBr7jYxAtulikOmJtAGt2KeGG2n0ZTPKZm/3Nut8HuM5iyn3qYz7Yde3WtuYrflcCZiabKWaJPg56EwstUDmSktlKlX5G0ztIFmVkKGzGdQfdBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947833; c=relaxed/simple;
	bh=H4XWxznAeCeR5T4ZVKmzo83BS5gDwE0ws+88D6yXSOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XO+98I7GsMVEeoeI7tjpV3UsG5inG2PjmL7Hzlz8qILASbf4CH8ToWpX/FGtdXA2R1PgAPy6SeXYXy44NX5JXCuNJqF9ORqzShElnuKW2AHyxt/U9fEMcrU/00YLnKShMws11OWHvW8Pm6oLS6pQqjDp3Sw7Jzef46Cs0wkg4G8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ft2HIds3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ft2HIds3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFE6C4CEE9;
	Tue, 29 Apr 2025 17:30:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947833;
	bh=H4XWxznAeCeR5T4ZVKmzo83BS5gDwE0ws+88D6yXSOk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ft2HIds3tpbUacMGbf7Ug3zG2ETKWixYMlz6yk8ASvy+S8KTtGqOo33G7TklyOnB1
	 JgdlFN+bLoLc3vsXc/4REuTSXMgzV/MiBDuoR/0zz53kw9DiSfmuSbBLKmeUx25c7W
	 ioHCyXwY8E465x7b/QvqoVdw5A9MNonqVmZal5dY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Damien Le Moal <dlemoal@kernel.org>,
	Niklas Cassel <cassel@kernel.org>,
	Igor Pylypiv <ipylypiv@google.com>
Subject: [PATCH 6.12 117/280] ata: libata-scsi: Fix ata_mselect_control_ata_feature() return type
Date: Tue, 29 Apr 2025 18:40:58 +0200
Message-ID: <20250429161119.898197356@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Le Moal <dlemoal@kernel.org>

commit db91586b1e8f36122a9e5b8fbced11741488dd22 upstream.

The function ata_mselect_control_ata_feature() has a return type defined
as unsigned int but this function may return negative error codes, which
are correctly propagated up the call chain as integers.

Fix ata_mselect_control_ata_feature() to have the correct int return
type.

While at it, also fix a typo in this function description comment.

Fixes: df60f9c64576 ("scsi: ata: libata: Add ATA feature control sub-page translation")
Cc: stable@vger.kernel.org
Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Reviewed-by: Niklas Cassel <cassel@kernel.org>
Reviewed-by: Igor Pylypiv <ipylypiv@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/ata/libata-scsi.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3734,12 +3734,11 @@ static int ata_mselect_control_spg0(stru
 }
 
 /*
- * Translate MODE SELECT control mode page, sub-pages f2h (ATA feature mode
+ * Translate MODE SELECT control mode page, sub-page f2h (ATA feature mode
  * page) into a SET FEATURES command.
  */
-static unsigned int ata_mselect_control_ata_feature(struct ata_queued_cmd *qc,
-						    const u8 *buf, int len,
-						    u16 *fp)
+static int ata_mselect_control_ata_feature(struct ata_queued_cmd *qc,
+					   const u8 *buf, int len, u16 *fp)
 {
 	struct ata_device *dev = qc->dev;
 	struct ata_taskfile *tf = &qc->tf;


