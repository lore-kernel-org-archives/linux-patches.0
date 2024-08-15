Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2814F7DA9E;
	Thu, 15 Aug 2024 13:48:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723729714; cv=none; b=eTvpOc9kZKbLKracGLHiCHYnOocbHZ4GGHYBYIN1Zlw9ihHGfPvbzzJAO9rZ54f2gf2iLkPgcA/2rgjTfPTRuqotEd9LOK+7vqJfUtV5RipuH9gFKhXQyXYZBs6V3udhEgHiXw3G1M2xpG2qhb0c47EQ4n+WazNcLRfSR2GN9MM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723729714; c=relaxed/simple;
	bh=CHoX25kifHzcrFmzWjuY/IW/GOEBQN9nNspFFosxh2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oShiM3jNxlUpWm+XhCA4c7MxYJ6zqmc/gAAvG890D/facyPeC58hGbq0RIvdZqMVGCyYCWH7syNr9XhmtCkUO+Hzvlbo1afrKnr8xGkS+LE8zcDO+JCKtfpG3obzGIWa8lxFlAYLSNzuoZSCAgC4ikzj5LB3lBHY/UNLrv84vt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LLy6A9YT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LLy6A9YT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C910C32786;
	Thu, 15 Aug 2024 13:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723729713;
	bh=CHoX25kifHzcrFmzWjuY/IW/GOEBQN9nNspFFosxh2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LLy6A9YTtjTulp250hsfCTnRt4vJwnAZ4zIXiutdMIixYY81urduDG4Yqkruslll+
	 6HEiGYKxQgpE1jdqQ84jBcwFhhFjNBv0xwZ6rKQEjydFIll+l5ybfvZv2Ch/4AB2Ds
	 1S/QBB6jQWQTDg904TNKeqJOxYfZ0tDvKDR7xAbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shreyas Deodhar <sdeodhar@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 5.15 184/484] scsi: qla2xxx: Fix optrom version displayed in FDMI
Date: Thu, 15 Aug 2024 15:20:42 +0200
Message-ID: <20240815131948.521496243@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131941.255804951@linuxfoundation.org>
References: <20240815131941.255804951@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shreyas Deodhar <sdeodhar@marvell.com>

commit 348744f27a35e087acc9378bf53537fbfb072775 upstream.

Bios version was popluated for FDMI response. Systems with EFI would show
optrom version as 0.  EFI version is populated here and BIOS version is
already displayed under FDMI_HBA_BOOT_BIOS_NAME.

Cc: stable@vger.kernel.org
Signed-off-by: Shreyas Deodhar <sdeodhar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240710171057.35066-9-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_gs.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_gs.c
+++ b/drivers/scsi/qla2xxx/qla_gs.c
@@ -1709,7 +1709,7 @@ qla2x00_hba_attributes(scsi_qla_host_t *
 	eiter->type = cpu_to_be16(FDMI_HBA_OPTION_ROM_VERSION);
 	alen = scnprintf(
 		eiter->a.orom_version, sizeof(eiter->a.orom_version),
-		"%d.%02d", ha->bios_revision[1], ha->bios_revision[0]);
+		"%d.%02d", ha->efi_revision[1], ha->efi_revision[0]);
 	alen += FDMI_ATTR_ALIGNMENT(alen);
 	alen += FDMI_ATTR_TYPELEN(eiter);
 	eiter->len = cpu_to_be16(alen);


