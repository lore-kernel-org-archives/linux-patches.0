Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4DC53365;
	Thu, 12 Dec 2024 16:27:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734020828; cv=none; b=R0N4qh33lM6ScdMb0iTB5gwr9Fh9kumrXNRD9Z010AHzM/AKkCta2fCjOX4kdytfdIQ6byBUUvkJ7ShMiuDB1LoofNTlEXMUeTgl3LFs0RgrWIZPhFll47AXDXMhUKqsfsjek2kyoAqCkmtRlXV+yQ6UX6qKCAOtX/bFDW2K9ng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734020828; c=relaxed/simple;
	bh=CZNtotWW7oQUHxwVpfp4ioX5BEJ+Nqm8HmiNc1aJVP0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tAKOlajebQ2Vp2wTBYOcPzcj1zrxb/FFWrB6WD7OHH+NdLU+0/gM9QrLIJid0Hn2bxmS/AOiM/TKrXmsBkCIIODbjBmBdgfDfchk4ofX8dNTLeef1jPvfWZBuxOTltBMIiXE3CFJL/noC4flxB1v0sw+5mazy2bVFz5EyiSrIno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sam9b44Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sam9b44Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41E31C4CECE;
	Thu, 12 Dec 2024 16:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734020827;
	bh=CZNtotWW7oQUHxwVpfp4ioX5BEJ+Nqm8HmiNc1aJVP0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sam9b44Qv8An5Y9i2VoyP7v2bayrm8KB69lem82of2DYrpnBaO5ZNv13npp4VuBhO
	 L5Z6VZmbXadX+Wz7via3sXke6eG/b2oakAu91nOqCsgRnpnoIAEgTa6IcyZ+xFo7Gy
	 YSixNgZBrMfcrZdfKK76p2OkKeFaFpDVXyw+v0Aw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 570/772] i3c: master: fix kernel-doc check warning
Date: Thu, 12 Dec 2024 15:58:35 +0100
Message-ID: <20241212144413.514433338@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Frank Li <Frank.Li@nxp.com>

[ Upstream commit 34d946b723b53488ab39d8ac540ddf9db255317a ]

Fix warning found by
	'scripts/kernel-doc -v -none include/linux/i3c/master.h'

include/linux/i3c/master.h:457: warning: Function parameter or member 'enable_hotjoin' not described in 'i3c_master_controller_ops'
include/linux/i3c/master.h:457: warning: Function parameter or member 'disable_hotjoin' not described in 'i3c_master_controller_ops'
include/linux/i3c/master.h:499: warning: Function parameter or member 'hotjoin' not described in 'i3c_master_controller'

Signed-off-by: Frank Li <Frank.Li@nxp.com>
Reviewed-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/r/20240109052548.2128133-1-Frank.Li@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 25bc99be5fe5 ("i3c: master: svc: Modify enabled_events bit 7:0 to act as IBI enable counter")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/i3c/master.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/linux/i3c/master.h b/include/linux/i3c/master.h
index b5a568caf4c80..b6cbd00773a3c 100644
--- a/include/linux/i3c/master.h
+++ b/include/linux/i3c/master.h
@@ -425,6 +425,8 @@ struct i3c_bus {
  *		      for a future IBI
  *		      This method is mandatory only if ->request_ibi is not
  *		      NULL.
+ * @enable_hotjoin: enable hot join event detect.
+ * @disable_hotjoin: disable hot join event detect.
  */
 struct i3c_master_controller_ops {
 	int (*bus_init)(struct i3c_master_controller *master);
@@ -466,6 +468,7 @@ struct i3c_master_controller_ops {
  * @ops: master operations. See &struct i3c_master_controller_ops
  * @secondary: true if the master is a secondary master
  * @init_done: true when the bus initialization is done
+ * @hotjoin: true if the master support hotjoin
  * @boardinfo.i3c: list of I3C  boardinfo objects
  * @boardinfo.i2c: list of I2C boardinfo objects
  * @boardinfo: board-level information attached to devices connected on the bus
-- 
2.43.0



