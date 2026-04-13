Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4683A2D3225;
	Mon, 13 Apr 2026 16:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776096483; cv=none; b=QBseas0sFUTPTNXrwJubLB8vpBM6qDeqH84NZEMEYgSxCc1Ix6O8Da/eFab2ELgYdgRlm9VYrbec4Fa5ZzOjtgU72PVa8t6vj+I8lSbz81DqOQHgBEy9x5bALJ1WAaHtG6mJajdy0RooaKxORYET8gvgJNDlr6R8iLU0VTN4E70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776096483; c=relaxed/simple;
	bh=JLFA/QnYpVQ3ahjbh2WcYu4wcC7jMh+ibA7tgTco214=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gEmYNGDPuMaM+teXg0AiqFeBYNMfFSYPE7mhnlQobrXtQ9qfmTLNk1lEfFsFT3ccd/A0cAUOcT9NHYmT8c/HJxjR/6/v6StbZJEt+wjCzPjJl4ohrcUULha4Vyjr3v8SWzR57TshnbmcIU2cAEbM37lf7YwRKZP5RkwHH5dU+GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bm06LCq0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bm06LCq0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5444C2BCB4;
	Mon, 13 Apr 2026 16:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776096483;
	bh=JLFA/QnYpVQ3ahjbh2WcYu4wcC7jMh+ibA7tgTco214=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bm06LCq0d/rCXZyh3/w5Njo+MCoAIMZCbYENp6JHTmTwUqdiyXEZl18opa7QYtDAS
	 3Lrhkk9AHf/8ngWsFGo3jvFS0m3F30jWPVw14R6mlaBZyjavuhpiBqoJqQevp7Cv9j
	 oBimxx2NReJjefbVBZvfcXNxw09b5sn31VXJlK58=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>
Subject: [PATCH 6.18 28/83] platform/x86: ISST: Reset core count to 0
Date: Mon, 13 Apr 2026 17:59:56 +0200
Message-ID: <20260413155732.070209685@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155731.019638460@linuxfoundation.org>
References: <20260413155731.019638460@linuxfoundation.org>
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

From: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>

commit e1415b9418eb22b4a7a1ef4b4aec9dd0a49e3fa7 upstream.

Based on feature revision, number of buckets can be less than the
TRL_MAX_BUCKETS. In that case core counts in the remaining buckets
can be set to some invalid values.

Hence reset core count to 0 for all buckets before assigning correct
values.

Fixes: 885d1c2a30b7 ("platform/x86: ISST: Support SST-TF revision 2")
Signed-off-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260325192638.3417281-1-srinivas.pandruvada@linux.intel.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
+++ b/drivers/platform/x86/intel/speed_select_if/isst_tpmi_core.c
@@ -1460,6 +1460,8 @@ static int isst_if_get_turbo_freq_info(v
 					    SST_MUL_FACTOR_FREQ)
 	}
 
+	memset(turbo_freq.bucket_core_counts, 0, sizeof(turbo_freq.bucket_core_counts));
+
 	if (feature_rev >= 2) {
 		bool has_tf_info_8 = false;
 


