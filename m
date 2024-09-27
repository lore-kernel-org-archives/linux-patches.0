Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F06E4189BBF;
	Fri, 27 Sep 2024 12:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727440226; cv=none; b=aNfMOILOPd6DqfJaN8rgw68IXhMYaKA/Yf1TDVs+y8+8tpoyGZbs7x3OnIMdKm3T2jjoBss5Fn4kAZ1M8jWg6fYfuPfXDCgDyqOZ95PV4288GoqpwLZdlDiSQmHlyoJsyFe2PXVwkM6TeF7kokX9FO99z7Ew08t6kOyl/b+6/ZM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727440226; c=relaxed/simple;
	bh=esGsG5cHb2AmcJ1Y2rkGWfKqMN68aUSoXernVfvRKkY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aDE+3DIdTBlVrOj1R43lPCwqeTrwo13eYaVVyxo77q1vYhy5SdeeqTP8nw1OopuEM+dU4T62cQyOFA/7DsRoFJ9ORoIkG0pte03eyAL86OpqjjI7XzUkCLlNcTbhHHSD6568hDNRD0vSB7d6z/sz6DeIWKQJDGrITv1r4sYwFRE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nYOE/drs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nYOE/drs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4AAC4CEC4;
	Fri, 27 Sep 2024 12:30:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727440225;
	bh=esGsG5cHb2AmcJ1Y2rkGWfKqMN68aUSoXernVfvRKkY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nYOE/drsCPVqqYAsxhZXGHCRVghmWfiOT6RwTmWpXX+N8DJS8yxGHbgrKyu+1gU35
	 XjjRPxqgReeehew6q0xteWA/05untFOJJCeIluw8ppJc5di5Gr+INoqiFwVc6lvk3g
	 KA7ehqoLubMpciLYp+xzAZ1Rxr0kC1ntOebXmz2g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Thomas Leroy <thomas.leroy@suse.com>
Subject: [PATCH 6.11 08/12] Bluetooth: btintel_pcie: Allocate memory for driver private data
Date: Fri, 27 Sep 2024 14:24:11 +0200
Message-ID: <20240927121715.604802414@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20240927121715.213013166@linuxfoundation.org>
References: <20240927121715.213013166@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kiran K <kiran.k@intel.com>

commit 7ffaa200251871980af12e57649ad57c70bf0f43 upstream.

Fix driver not allocating memory for struct btintel_data which is used
to store internal data.

Fixes: 6e65a09f9275 ("Bluetooth: btintel_pcie: Add *setup* function to download firmware")
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Thomas Leroy <thomas.leroy@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btintel_pcie.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -1208,7 +1208,7 @@ static int btintel_pcie_setup_hdev(struc
 	int err;
 	struct hci_dev *hdev;
 
-	hdev = hci_alloc_dev();
+	hdev = hci_alloc_dev_priv(sizeof(struct btintel_data));
 	if (!hdev)
 		return -ENOMEM;
 


