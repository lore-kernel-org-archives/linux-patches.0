Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E400546EF73;
	Tue, 21 Jul 2026 18:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656951; cv=none; b=XgsMg63UkBZ9SmYw+Dn/IVhxK7y1I8BrRVdafvb06msQQXV8nG874fFcm6E0GmPQNiekxRdhGVkTw/zMWzQZvyLjgNEEjuY792Qz6aO/kdz2FlyNBqXPEbIystw+Fzackzsc0ikzIChxYvKmFP86dgW8Y0BvE8z6vxrFj8lmOXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656951; c=relaxed/simple;
	bh=9tpa0qJgT8PCs3n0HYWjID/sqavF1ziU2c08njkmSVA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kBAHi0klZzGUJB0joP314UH/OcJzSPrV211AJskR9QGvRm3c3GoC98QlE0SWkBEKhRxEVHCjqgdsjkuSR6SCVaQAzg6n9VXupAW/i21KFaGUH16KT1DTA04oRIemQ81HOHykSo3FU9sTppLJPfC9HnRGQTzmg/tULfSSiXt1yns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7+u38JE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7+u38JE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5AC161F000E9;
	Tue, 21 Jul 2026 18:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656949;
	bh=QWc3/U66hz2vJTwn6mTxLMYlbsai/kA7md08UIqxumk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F7+u38JE5AHz8UFo/1r/FVFdvJHlV2DxtMqpgMOYzOpSx0jljJtxMtRtm43SRcUsg
	 xUTZ4f0aoyI37xCJ0Le3fVWw9xXYxO9qz/gmy5wgfc2Y/fU2x7xsVCCDr5vBFLu/Bu
	 HtQ4a1Z3hOo4SZbfCkOkHctQKA5uhfbVB8o1yaFY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Simon Trimmer <simont@opensource.cirrus.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0580/1611] soundwire: dont program SDW_SCP_BUSCLOCK_SCALE on a unattached Peripheral
Date: Tue, 21 Jul 2026 17:11:36 +0200
Message-ID: <20260721152528.423883920@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit c368dd5cbd61ffab2b6f8a89b0d5775e2e16cde6 ]

The SDW_SCP_BUSCLOCK_SCALE register will be programmed when the
Peripheral is attached. We can and should skip programming the
SDW_SCP_BUSCLOCK_SCALE register when the Peripheral is unattached.

Fixes: 645291cfe5e5 ("Soundwire: stream: program BUSCLOCK_SCALE")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Simon Trimmer <simont@opensource.cirrus.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Link: https://patch.msgid.link/20260428084612.322701-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/stream.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/soundwire/stream.c b/drivers/soundwire/stream.c
index 38c9dbd3560652..ecd0c2889bb421 100644
--- a/drivers/soundwire/stream.c
+++ b/drivers/soundwire/stream.c
@@ -691,6 +691,13 @@ static int sdw_program_params(struct sdw_bus *bus, bool prepare)
 		if (scale_index < 0)
 			return scale_index;
 
+		/* Skip the unattached Peripherals */
+		if (!completion_done(&slave->enumeration_complete)) {
+			dev_warn(&slave->dev,
+				 "Not enumerated, skip programming BUSCLOCK_SCALE\n");
+			continue;
+		}
+
 		ret = sdw_write_no_pm(slave, addr1, scale_index);
 		if (ret < 0) {
 			dev_err(&slave->dev, "SDW_SCP_BUSCLOCK_SCALE register write failed\n");
-- 
2.53.0



