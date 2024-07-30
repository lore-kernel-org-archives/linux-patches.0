Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4350D1A76B3;
	Tue, 30 Jul 2024 17:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360395; cv=none; b=snfts4rLaekHmyCaazeo1H/e/AbiV8/dHsqvtqaGL3lu3Q7UcQLuXzTXt6tX5xPy3ZFRJ2kgajPHdXg6huKOsmssgU8yE+1Ri31dggGtHMe9UK3XZoKwtA7w+xYccYXlxG5BT92N9uYTeLMZb5q1qULqDaD457U3W6u7Zp5Faak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360395; c=relaxed/simple;
	bh=fZbmYiIEqKgDQNW+T687awpaeIB7nWoErv1xV0hcYrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DEqblysk5CBH5NxHIxFS5oHsgJvDo5wpQbCLygyUCqRsiZiXm5O9FQcl3Ij0jWxYngEC2q4bXbBXnxgepO96S9nScw8/fph7y/mYPoGR4/49xcI9nXj86sMzy6LU3jUSMKVSgAn95SbQsmwqYpH2VN3gt3yCvreMZKp3OSGvTY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YdMWMiMR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YdMWMiMR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF256C32782;
	Tue, 30 Jul 2024 17:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360395;
	bh=fZbmYiIEqKgDQNW+T687awpaeIB7nWoErv1xV0hcYrw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YdMWMiMRV0eSCBzDvvuWL0mCBSnrXiLUfNGthl74RetbvMJgpEFJQFJ3IFU4Pdqdp
	 XVC5aiGBRUXV3MvLTzZ3S1f9TxgfX/s/LW/PNhzCWMesQdK2RvrhchfJDR0rmq3B+h
	 DxXizZxU8Z7CKABNoeJh0o7soyiBrgC5FzBWMyIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shreyas Deodhar <sdeodhar@marvell.com>,
	Nilesh Javali <njavali@marvell.com>,
	Himanshu Madhani <himanshu.madhani@oracle.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 6.10 685/809] scsi: qla2xxx: Fix for possible memory corruption
Date: Tue, 30 Jul 2024 17:49:21 +0200
Message-ID: <20240730151751.967719780@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shreyas Deodhar <sdeodhar@marvell.com>

commit c03d740152f78e86945a75b2ad541bf972fab92a upstream.

Init Control Block is dereferenced incorrectly.  Correctly dereference ICB

Cc: stable@vger.kernel.org
Signed-off-by: Shreyas Deodhar <sdeodhar@marvell.com>
Signed-off-by: Nilesh Javali <njavali@marvell.com>
Link: https://lore.kernel.org/r/20240710171057.35066-4-njavali@marvell.com
Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/scsi/qla2xxx/qla_os.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/scsi/qla2xxx/qla_os.c
+++ b/drivers/scsi/qla2xxx/qla_os.c
@@ -4689,7 +4689,7 @@ static void
 qla2x00_number_of_exch(scsi_qla_host_t *vha, u32 *ret_cnt, u16 max_cnt)
 {
 	u32 temp;
-	struct init_cb_81xx *icb = (struct init_cb_81xx *)&vha->hw->init_cb;
+	struct init_cb_81xx *icb = (struct init_cb_81xx *)vha->hw->init_cb;
 	*ret_cnt = FW_DEF_EXCHANGES_CNT;
 
 	if (max_cnt > vha->hw->max_exchg)


