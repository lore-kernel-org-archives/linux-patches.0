Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3224137997D;
	Mon,  9 Feb 2026 14:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647156; cv=none; b=Rx7PFA2rRkcSmSemlxDjJnrPR9mrrn6CnDWdZEhKClf8j+sc0cXxyJrDrXlwGYWwIpIYSaZx8Dft5M2cpdxIOSG8VKGzLF8ki2IHXHtg3jxyHhSImQV+2M20CRt5u5PaR07tKYy/bmH1HBcCDVYtB6n5SwMXsTesuAKlrnlgNKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647156; c=relaxed/simple;
	bh=7SwUD809YsElZVx8Nsk6bwljIkYRwbV2BxrVcyseAM4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rJjnG7aGYNNi6adRTMwpVBmGNPlqQPVU53fWWqIU+jMvgE7lekFiaX11Qyl3RxW6GYJf0k1QrkMYVAKyOKLf4YQrYe7VL8WC8E9itStHTwLruil552SM4Zre7RozCDTLsoAfBdRDOYh70IOwtdYwgCWnpi2Vvdgu+hJk8UMGkZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PvEK2gsc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PvEK2gsc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97BC4C116C6;
	Mon,  9 Feb 2026 14:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647156;
	bh=7SwUD809YsElZVx8Nsk6bwljIkYRwbV2BxrVcyseAM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PvEK2gsc56OgY90tEXnAGHHM8+FBza8m3g6KMtdXiVEirsCjQ0jupdDMb8VVtho6e
	 ITvErJCbNmXWsTGPsq2rhy/7DZZh1D+81u8gNh5U+ViaGPifZN2NNBOAo1k5bga+LP
	 nKJl7o5PxhJKqalF9cPmFhTPpFvGkDO3nTWOItg0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kaushlendra Kumar <kaushlendra.kumar@intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 005/175] platform/x86: intel_telemetry: Fix swapped arrays in PSS output
Date: Mon,  9 Feb 2026 15:21:18 +0100
Message-ID: <20260209142320.672103477@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
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


