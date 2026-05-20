Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5BD3D3D1C;
	Wed, 20 May 2026 16:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296285; cv=none; b=tXRP7PetUiHxhm39+ZFj0VpeZR9/ZaeTTYE0LDwfHQsjuUgj6uWdFKVmAQ3MnrPvJRCAKtBEPOeXzyXR3wjbncL1bimql2ZPzAS3MIZcZETRFfo2Cp+O0KzSwAr2kFxNxO3qZrxTFajI+Pi2fUgw9mx+0lrgH1/kBIk9e+r+fU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296285; c=relaxed/simple;
	bh=m/S/nh0+H8rb0T1/SYCmqg1jAH7g2v7Wp4F7Ga3mYFA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rsbelnLdevDCViqs/jCwzilXg2ucCAbzcmCY3Bp25ii1DNohuCGQbk6cWYRyUqjqnhUIeP9j775/MUbDqRsnFEiLu6HkO9LD+VCmTzofuxEMheHE+OWvydZ+eqgNd4WoqMT1xU/zdgVFaS8oHRRiOU1KsTIjaT1ydJL3bBvYT48=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QTd2mNhb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QTd2mNhb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E23DE1F00893;
	Wed, 20 May 2026 16:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296284;
	bh=BAs5+q3IIiLECBNjp6r+F+JvFBIOmHYx3LwzHN1ekK8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QTd2mNhbRJvsG1jDl9nqQ8Zpsm1Uju7X+d1e6WuoRIUoOj/8OnPHIRKmdazjFH2AV
	 PS8ev8IJk5jM7EAYO7p+4n2Bie6mpJC+5FRrZGVRCjb55wlOjADCBGegYeOpdAsv9S
	 iO0MXfVlGWpQRW0CtpVn3/9cRVzgR69a2g38rczI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Don Brace <don.brace@microchip.com>,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0734/1146] scsi: hpsa: Enlarge controller and IRQ name buffers
Date: Wed, 20 May 2026 18:16:24 +0200
Message-ID: <20260520162204.817782518@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

[ Upstream commit 8e8cb6f39930e836144f51cdb6d409c9e4cb71fe ]

hpsa formats the controller name into h->devname[8] and derives
interrupt names from it in h->intrname[][16]. Once host_no reaches four
digits, "hpsa%d" no longer fits in devname, and the derived IRQ names
can then overrun the interrupt-name buffers as well.

The previous fix switched these builders to bounded formatting, but that
would truncate user-visible controller and IRQ names. Keep the existing
names intact instead by enlarging the fixed buffers to cover the current
formatted strings.

Fixes: 2946e82bdd76 ("hpsa: use scsi host_no as hpsa controller number")
Fixes: 8b47004a5512 ("hpsa: add interrupt number to /proc/interrupts interrupt name")
Acked-by: Don Brace <don.brace@microchip.com>
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260401120552.78541-1-pengpeng@iscas.ac.cn
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/scsi/hpsa.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/hpsa.h b/drivers/scsi/hpsa.h
index 99b0750850b2b..f6bfe75dd696d 100644
--- a/drivers/scsi/hpsa.h
+++ b/drivers/scsi/hpsa.h
@@ -164,7 +164,7 @@ struct bmic_controller_parameters {
 struct ctlr_info {
 	unsigned int *reply_map;
 	int	ctlr;
-	char	devname[8];
+	char	devname[16];
 	char    *product_name;
 	struct pci_dev *pdev;
 	u32	board_id;
@@ -255,7 +255,7 @@ struct ctlr_info {
 	int remove_in_progress;
 	/* Address of h->q[x] is passed to intr handler to know which queue */
 	u8 q[MAX_REPLY_QUEUES];
-	char intrname[MAX_REPLY_QUEUES][16];	/* "hpsa0-msix00" names */
+	char intrname[MAX_REPLY_QUEUES][32];	/* controller and IRQ names */
 	u32 TMFSupportFlags; /* cache what task mgmt funcs are supported. */
 #define HPSATMF_BITS_SUPPORTED  (1 << 0)
 #define HPSATMF_PHYS_LUN_RESET  (1 << 1)
-- 
2.53.0



