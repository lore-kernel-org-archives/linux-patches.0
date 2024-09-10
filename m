Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E208F13B2B0;
	Tue, 10 Sep 2024 09:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961535; cv=none; b=Y0cmWTAzssEnW9YVhmhxtWOUUYKCdMelzFl3O7SeBj9kSx2vUW+iQqFCqCNp6EPJT2eUKjG7hmWurIsRcJXu8QQ0+dPqSKdENUv3s4ANsrr5nlkB4QZJBCuRKyW9ax6Y0bJFSufogw3PrvkPZccI8NPOg7RpzKLTMgJiLqtQTyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961535; c=relaxed/simple;
	bh=zXcY7N99zX/gJSThEtkj1vE9nlCdhUtNT70FyekDUEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BrEjkJFJHEp44w5+lbSGN93VYAAm0Nr3aib0rdZBC+g+9SD4/JooPeeazU6BiC+otbR7X5yIbqlrBzN82tMG3Se2DVVVIpw8zWZdoOpWyHQgXmGwYzo9mEituyjynHsaOXrrMXoYuLiL8kXzyKk/Wj/JX7RXRaeHDM2En8+vN+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wH1fJf7w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wH1fJf7w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69934C4CEC3;
	Tue, 10 Sep 2024 09:45:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961534;
	bh=zXcY7N99zX/gJSThEtkj1vE9nlCdhUtNT70FyekDUEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wH1fJf7wk1tGp7DFvybKqrgGAVQjvvHJVsPsHbwaJnSp4hv9Jqh2CHtIHWureMlHs
	 FLZSdEK+JI31iqdJyRIrh2J+BXR9Cb8XoL7dKOkgujqvAybZ6V7vXZV7tugxgdOTLX
	 LjcZeGB73NJ1AWwdmwNSn52/QmnMZYEjEsEb7UvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baochen Qiang <quic_bqiang@quicinc.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>
Subject: [PATCH 6.10 075/375] Revert "wifi: ath11k: restore country code during resume"
Date: Tue, 10 Sep 2024 11:27:52 +0200
Message-ID: <20240910092624.736148717@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

From: Baochen Qiang <quic_bqiang@quicinc.com>

commit d3e154d7776ba57ab679fb816fb87b627fba21c9 upstream.

This reverts commit 7f0343b7b8710436c1e6355c71782d32ada47e0c.

We are going to revert commit 166a490f59ac ("wifi: ath11k: support hibernation"), on
which this commit depends. With that commit reverted, this one is not needed any
more, so revert this commit first.

Signed-off-by: Baochen Qiang <quic_bqiang@quicinc.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://patch.msgid.link/20240830073420.5790-2-quic_bqiang@quicinc.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath11k/core.c |   10 ----------
 1 file changed, 10 deletions(-)

--- a/drivers/net/wireless/ath/ath11k/core.c
+++ b/drivers/net/wireless/ath/ath11k/core.c
@@ -1009,16 +1009,6 @@ int ath11k_core_resume(struct ath11k_bas
 		return -ETIMEDOUT;
 	}
 
-	if (ab->hw_params.current_cc_support &&
-	    ar->alpha2[0] != 0 && ar->alpha2[1] != 0) {
-		ret = ath11k_reg_set_cc(ar);
-		if (ret) {
-			ath11k_warn(ab, "failed to set country code during resume: %d\n",
-				    ret);
-			return ret;
-		}
-	}
-
 	ret = ath11k_dp_rx_pktlog_start(ab);
 	if (ret)
 		ath11k_warn(ab, "failed to start rx pktlog during resume: %d\n",


