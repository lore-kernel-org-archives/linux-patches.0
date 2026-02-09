Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EACE37BE77;
	Mon,  9 Feb 2026 14:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770648720; cv=none; b=Ogzshksg3lEIFto/gr3Pj8Q3NgjbveQQw7tyv2HnvqVQJj0lv3qjm+ACSbB4HehqksLkP2GLJUxTxkSiLPePDg+0gPcjKjBSA2KMUfoS/xYokDUF+O1NZCkYQ0p3fy7kln8yTz59Jk3a3Ql1qM8vTKEe3MZkOp0XcMDkY7PjE7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770648720; c=relaxed/simple;
	bh=5evf2PfkrgfQOORSIiI6EaepKYQxN4gSWmt3lEvXNBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Cjl6HR8dP6BSC4zMRJCOlGE4QG/vodBlZWWYCnU/T/UyaMk8Czs+8ZwswWTjyQlyi5pyWPre5MTyowwmL85lxAUenh3JyZdRskWZ6KX0pD70+fcrvOlb6DOAY1i26sFLozop+FIst9htBMXMcBGEQ67NVIo+wfPYx0vvNJbHtjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c6aJV97z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c6aJV97z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6655DC116C6;
	Mon,  9 Feb 2026 14:51:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770648719;
	bh=5evf2PfkrgfQOORSIiI6EaepKYQxN4gSWmt3lEvXNBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c6aJV97zhYfJGf1VumqUBwMOfvcbKTl7pnV/TQynBC93sZEpNNzfDhi4n3Nsl8M9a
	 ca6CGobcGc3OsXqwJWH0YrLp32N3yGIRsu0IvEMJlwjfmJqsTemuUdRQcpNDDsdUQU
	 Tb81AmlUBaqgbQdF8zs4e9yRHVyQbKZWW3H0nNBA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 37/41] platform/x86: intel_telemetry: Fix swapped arrays in PSS output
Date: Mon,  9 Feb 2026 15:24:58 +0100
Message-ID: <20260209142258.154219858@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142256.797267956@linuxfoundation.org>
References: <20260209142256.797267956@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kaushlendra Kumar <kaushlendra.kumar@intel.com>

[ Upstream commit 25e9e322d2ab5c03602eff4fbf4f7c40019d8de2 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel_telemetry_debugfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/platform/x86/intel_telemetry_debugfs.c
+++ b/drivers/platform/x86/intel_telemetry_debugfs.c
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


