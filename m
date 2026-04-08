Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDDC3DA5AE;
	Wed,  8 Apr 2026 19:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674874; cv=none; b=Fo36uiKKht+O7FpGD2W1MuKY5G4+eSw0gB/+NXUrhK5vlHt+hpHm9LI4sijNtCot6hIT3vF5F0zwWOad/e6b2GGlowHz7uqYwk8eKiExRE7fNKu+TOFPPQ+iRtE0rEpfgUPnPGujm4HFg+SkupFQkkNemP6NNYY/TcUgztGU2eI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674874; c=relaxed/simple;
	bh=hwM93mLyfTf62PyGuBezcevuKTwflTk6mLjhWqrsOTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mxS0Lc8hawQ0iE4p1EYzbiFhBG04l8aiSosQkb0GoLCW+sBgmkWr51Tnhq9qRcPnlQPNFRD+LsSIM5Hw59gykgGNfKKc+YTtW7VGV+mwjbKP3Cjbow0HATxoqxN0ILm3VQq1TzIAOhOI6P6WqEQAseb6gMW9F6Fg4fso7+q+ZOo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gRZsOSIZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gRZsOSIZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC73C19421;
	Wed,  8 Apr 2026 19:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674873;
	bh=hwM93mLyfTf62PyGuBezcevuKTwflTk6mLjhWqrsOTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gRZsOSIZNvRDBLksEh+qyvEqSVmqSTPLDfOoDhPBhqsxhyHUn4bbthtVC0ZS6bcOr
	 +BhPQiGFjjDxglR3s6bfxdFcrJVkV2/v7Kc5rF+BtcX7W1CS61HzV6TC/UeBpG64ze
	 lQQnLXsvBfPoXb40dKNT3CXDniA0b7ghz0GtkQ/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Eggers <ceggers@arri.de>,
	Fabio Estevam <festevam@gmail.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.19 266/311] nvmem: imx: assign nvmem_cell_info::raw_len
Date: Wed,  8 Apr 2026 20:04:26 +0200
Message-ID: <20260408175949.315434031@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Eggers <ceggers@arri.de>

commit 48b5163c957548f5854f14c90bfdedc33afbea3c upstream.

Avoid getting error messages at startup like the following on i.MX6ULL:

nvmem imx-ocotp0: cell mac-addr raw len 6 unaligned to nvmem word size 4
nvmem imx-ocotp0: cell mac-addr raw len 6 unaligned to nvmem word size 4

This shouldn't cause any functional change as this alignment would
otherwise be done in nvmem_cell_info_to_nvmem_cell_entry_nodup().

Cc: stable@vger.kernel.org
Fixes: 13bcd440f2ff ("nvmem: core: verify cell's raw_len")
Signed-off-by: Christian Eggers <ceggers@arri.de>
Signed-off-by: Fabio Estevam <festevam@gmail.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260327131645.3025781-2-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvmem/imx-ocotp-ele.c |    1 +
 drivers/nvmem/imx-ocotp.c     |    1 +
 2 files changed, 2 insertions(+)

--- a/drivers/nvmem/imx-ocotp-ele.c
+++ b/drivers/nvmem/imx-ocotp-ele.c
@@ -131,6 +131,7 @@ static int imx_ocotp_cell_pp(void *conte
 static void imx_ocotp_fixup_dt_cell_info(struct nvmem_device *nvmem,
 					 struct nvmem_cell_info *cell)
 {
+	cell->raw_len = round_up(cell->bytes, 4);
 	cell->read_post_process = imx_ocotp_cell_pp;
 }
 
--- a/drivers/nvmem/imx-ocotp.c
+++ b/drivers/nvmem/imx-ocotp.c
@@ -589,6 +589,7 @@ MODULE_DEVICE_TABLE(of, imx_ocotp_dt_ids
 static void imx_ocotp_fixup_dt_cell_info(struct nvmem_device *nvmem,
 					 struct nvmem_cell_info *cell)
 {
+	cell->raw_len = round_up(cell->bytes, 4);
 	cell->read_post_process = imx_ocotp_cell_pp;
 }
 


