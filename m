Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FF95F556;
	Tue, 23 Jan 2024 01:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705974423; cv=none; b=m9zudadghiIDZSrgYgXRejA22NfhCBQFZv0iXt+6yIP7pxfsJAxcpV4k2FeCncrVOYSByUesvmDePGftVz29mM0dO2p/SfyE+9oLzxczyfOZhCS6awdbrzvkNLlc272vP2KVSyAnEiPmQ7hRNi9tWAnDE01/qmnfwv/bR/ebls4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705974423; c=relaxed/simple;
	bh=JYCXmh34TUajYffoCQ9aSOSM2ky5stJImP0xJQ5Ch9o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGJctt8l96ijpqNTVxoB0sJkJD0HgWxUGeh+78RFuhDHNEH5WBneOxdkxIhIotcAXgOyj1sv1FStX9au7h8eX01f5Ik70ezrrYKr3stmWKWRF5kVsztmtkfz9qwsPgfzos+SJR+qknO7Yo4upG9EviPZmqhlSrgMdqvIxsX8SQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0G0NNDXU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0G0NNDXU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B0FDC433C7;
	Tue, 23 Jan 2024 01:47:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705974423;
	bh=JYCXmh34TUajYffoCQ9aSOSM2ky5stJImP0xJQ5Ch9o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0G0NNDXUNrCgnWiEP61fal8AYbaW9v6sF3vaKZ2hmuqMxmPZR4N6fhHxlK6L1tfIf
	 ZfADEbjs9iKNco1MvRRujd+VfBYuNbhnZKTm2mFhVz6H7RZuASdFhg3hk5UmV5V0a2
	 PNcXexmw//5CB+rHQsKztfGFr67j/8yLnQ5cjMww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 095/583] scsi: bfa: Use the proper data type for BLIST flags
Date: Mon, 22 Jan 2024 15:52:26 -0800
Message-ID: <20240122235815.085656763@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 0349be31e4ffc79723e46e2e373569567b06347b ]

Fix the following sparse warning:

drivers/scsi/bfa/bfad_bsg.c:2553:50: sparse: sparse: incorrect type in initializer (different base types)

Fixes: 2e5a6c3baccd ("scsi: bfa: Convert bfad_reset_sdev_bflags() from a macro into a function")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202311031255.lmSPisIk-lkp@intel.com/
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Link: https://lore.kernel.org/r/20231115193338.2261972-1-bvanassche@acm.org
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/bfa/bfad_bsg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index 520f9152f3bf..d4ceca2d435e 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -2550,7 +2550,7 @@ bfad_iocmd_vf_clr_stats(struct bfad_s *bfad, void *cmd)
 static void bfad_reset_sdev_bflags(struct bfad_im_port_s *im_port,
 				   int lunmask_cfg)
 {
-	const u32 scan_flags = BLIST_NOREPORTLUN | BLIST_SPARSELUN;
+	const blist_flags_t scan_flags = BLIST_NOREPORTLUN | BLIST_SPARSELUN;
 	struct bfad_itnim_s *itnim;
 	struct scsi_device *sdev;
 	unsigned long flags;
-- 
2.43.0



