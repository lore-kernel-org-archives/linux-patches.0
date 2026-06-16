Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E1947A0B0;
	Tue, 16 Jun 2026 17:07:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629679; cv=none; b=XICfhSUYfI6FOFBfIq5s5/bn86hZlE+GTobSU0tQR2K4FsIDn0XMDwKB0AfTz59InyU9oCPGCmCfd42qtndzMV93VlZYAY42lA00Gaf9diLlqzdr9cvO7woH6YPRvYz7C8UeYV3AV5UfUcH1o9txgd1yp4RnpYfhSt5BoAkbBDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629679; c=relaxed/simple;
	bh=lb4QxJtYn6Kd+KAiJ4pzpVEYjGXkCaNXm7Q3lUIq/+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WPfHP7qwysjjc/AuUIighVo+jXfivlvMyRYncGhYFYQ10O3cTXy7RN5anhEU6PFyKT+fRTmiZtKVaYdBnn7zroQ+KQUQbsLK2Bww7RxVsVh3fQ+LKAxP13ti7W7i1URf/JaQN6Vkl1iY87S881A46mQF5B2AdKO1CmCutGejeBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S5gE7l2I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S5gE7l2I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B6CD1F00A3E;
	Tue, 16 Jun 2026 17:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629678;
	bh=GI+2P0FNVAjj7u7k3e6zObksRfgrfEW0uSUBfA4+n8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S5gE7l2Irimz4ioUYc5aztN25lsvP51YOSMLxuto+SICLM8G+JUBM5ZLA+iSmO+VY
	 Y2lD6c42o373kGRziwY08/nPS6VBhaM8IGxhaxYVMhafJi2dl7XeWuPbTmsk9/hK4f
	 cByOChqhPdD2RMgnSK15Ubto0gFfPcA3qtssQSfQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongfei Ren <lcrhf@outlook.com>,
	stable@kernel.org,
	Cryolitia PukNgae <cryolitia.pukngae@linux.dev>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 6.6 331/452] Input: atkbd - skip deactivate for HONOR BCC-Ns internal keyboard
Date: Tue, 16 Jun 2026 20:29:18 +0530
Message-ID: <20260616145134.758640956@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cryolitia PukNgae <cryolitia.pukngae@linux.dev>

commit fb402386af4cdce108ff991a796386de55439735 upstream.

After commit 9cf6e24c9fbf17e52de9fff07f12be7565ea6d61 ("Input: atkbd -
do not skip atkbd_deactivate() when skipping ATKBD_CMD_GETID"), HONOR
BCC-N, aka HONOR MagicBook 14 2026's internal keyboard stops
working. Adding the atkbd_deactivate_fixup quirk fixes it.

DMI: HONOR BCC-N/BCC-N-PCB, BIOS 1.04 04/07/2026

Fixes: 9cf6e24c9fbf17e52de9fff07f12be7565ea6d61 ("Input: atkbd - do not skip atkbd_deactivate() when skipping ATKBD_CMD_GETID")
Reported-by: Hongfei Ren <lcrhf@outlook.com>
Link: https://github.com/colorcube/Linux-on-Honor-Magicbook-14-Pro/issues/1#issuecomment-4562679891
Tested-by: Hongfei Ren <lcrhf@outlook.com>
Cc: stable@kernel.org
Signed-off-by: Cryolitia PukNgae <cryolitia.pukngae@linux.dev>
Link: https://patch.msgid.link/20260605-honor-v1-1-78e05e491193@linux.dev
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/keyboard/atkbd.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/drivers/input/keyboard/atkbd.c
+++ b/drivers/input/keyboard/atkbd.c
@@ -1952,6 +1952,13 @@ static const struct dmi_system_id atkbd_
 		},
 		.callback = atkbd_deactivate_fixup,
 	},
+	{
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "HONOR"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "BCC-N"),
+		},
+		.callback = atkbd_deactivate_fixup,
+	},
 	{ }
 };
 


