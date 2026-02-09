Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBE4B27CCF2;
	Mon,  9 Feb 2026 14:46:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648379; cv=none; b=fY7/t6kcj9ON0lb0rBQZ3AS5J+S+Zwhv3Vxp2VYgkLgeadND9FKo155NJFW10fowQRae11A56b/Su4FDi6+NoMzXIrIC9paT51OGKbXkOamUPGOOU3v5tpMG3K/5Xv/Y3EeuVf0pjllxeyDlUiXB2BHS4S494ymq+pS1yFcag+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648379; c=relaxed/simple;
	bh=9ioA0RbT24eTdIIzyX5p9mFn51sRQMTQH4AB6e0qgR4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OspE7W+mynlUWdzZbbZOrhRRlqXLWHn7rDaX5AiRpBIWlKvX1aP8zL4nG0E3XGT2ujR1GFjAJQto5XlR7TjPbdM7VRlvvdUUywUUuTq/SkqO/Jf+v8Xq6Qm7M/1scOdku0sIikNzgRuJqxVra+Y0QhDoAAQXHWPdV0edvpDLxkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RCLDpPdf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RCLDpPdf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 649E8C116C6;
	Mon,  9 Feb 2026 14:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648378;
	bh=9ioA0RbT24eTdIIzyX5p9mFn51sRQMTQH4AB6e0qgR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RCLDpPdfTu59a/t27TkXiziIzWuqPGUFQrr8rJJ23MVgZUPqkVwpEB93UAqnL1ZvK
	 CzsgH6z5KGYSgMBYJ+Cdrg5nM8yWXdHNtt19SrAVnOsGfss75aKR9JfBgebp3v0rt7
	 yD+JAPFGWoH+6NjAa38yCCtIwUjNXcOsgfuF7MVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.6 03/86] platform/x86: intel_telemetry: Fix swapped arrays in PSS output
Date: Mon,  9 Feb 2026 15:23:26 +0100
Message-ID: <20260209142304.899820561@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142304.770150175@linuxfoundation.org>
References: <20260209142304.770150175@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

commit 25e9e322d2ab5c03602eff4fbf4f7c40019d8de2 upstream.

The LTR blocking statistics and wakeup event counters are incorrectly
cross-referenced during debugfs output rendering. The code populates
pss_ltr_blkd[] with LTR blocking data and pss_s0ix_wakeup[] with wakeup
data, but the display loops reference the wrong arrays.

This causes the "LTR Blocking Status" section to print wakeup events
and the "Wakes Status" section to print LTR blockers, misleading power
management analysis and S0ix residency debugging.

Fix by aligning array usage with the intended output section labels.

Fixes: 87bee290998d ("platform:x86: Add Intel Telemetry Debugfs interfaces")
Cc: stable@vger.kernel.org
Signed-off-by: Kaushlendra Kumar <kaushlendra.kumar@intel.com>
Link: https://patch.msgid.link/20251224032053.3915900-1-kaushlendra.kumar@intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/telemetry/debugfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/intel/telemetry/debugfs.c
+++ b/drivers/platform/x86/intel/telemetry/debugfs.c
@@ -449,7 +449,7 @@ static int telem_pss_states_show(struct
 	for (index = 0; index < debugfs_conf->pss_ltr_evts; index++) {
 		seq_printf(s, "%-32s\t%u\n",
 			   debugfs_conf->pss_ltr_data[index].name,
-			   pss_s0ix_wakeup[index]);
+			   pss_ltr_blkd[index]);
 	}
 
 	seq_puts(s, "\n--------------------------------------\n");
@@ -459,7 +459,7 @@ static int telem_pss_states_show(struct
 	for (index = 0; index < debugfs_conf->pss_wakeup_evts; index++) {
 		seq_printf(s, "%-32s\t%u\n",
 			   debugfs_conf->pss_wakeup[index].name,
-			   pss_ltr_blkd[index]);
+			   pss_s0ix_wakeup[index]);
 	}
 
 	return 0;


