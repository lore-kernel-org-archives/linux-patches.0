Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D7B120FA90;
	Tue, 12 Nov 2024 10:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731408474; cv=none; b=X6BvQsPZqOp54ppIaPddodN+h6ssuLxcttW/F6ZlhVk2YdKWoTZWYe5USSUNZ8sUFuwIqehQ6xFwMITy2IE42SyQvVqBmgVOjBqyT9Gk3hwAYFrrWYCm/U8S/o8vNSe1pjCznxZgcBhHLn7zbDYwB5DKg07iapGEn7xNTbIGjZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731408474; c=relaxed/simple;
	bh=/lcFhw3tGB0/2zEq3HTdzl49/aQ80pY+kagxxkY2Hvo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o/ULd31JCn0/QyNXQEBh4pLyFYaB11q/GKt3U/Q0EPCCKWbkQwV5UzJaqabS7kVc/6IJKWqT5HleNqhyudw7q2hNyhcGM4PzbE1zOEwbPAXEWzsd/BSMoGT9MeadHEJTq6YgRrj0hlNHQ1a5SzMgJzjeC2iASlsXERIguqkmOG0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rOQlf/Xh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rOQlf/Xh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D230C4CECD;
	Tue, 12 Nov 2024 10:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731408474;
	bh=/lcFhw3tGB0/2zEq3HTdzl49/aQ80pY+kagxxkY2Hvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rOQlf/XhywLTbM/mEUwsT8pxQLc8ZM7WV/3rLn+hW1ErJ+ctr4m8PcJ6M3sAsSMKk
	 /AbS2pGzILublpYdN+obbkWcVdF+xM7FOQGG2PaQ5rxD/bFHwWNvNcVWLD+R2UXZtw
	 B+PSpLQqyaKgWhxQ2k74u2raa5OONdFzDiKDvbQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mukesh Ojha <quic_mojha@quicinc.com>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 174/184] firmware: qcom: scm: suppress download mode error
Date: Tue, 12 Nov 2024 11:22:12 +0100
Message-ID: <20241112101907.541735784@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101900.865487674@linuxfoundation.org>
References: <20241112101900.865487674@linuxfoundation.org>
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

From: Johan Hovold <johan+linaro@kernel.org>

[ Upstream commit d67907154808745b0fae5874edc7b0f78d33991c ]

Stop spamming the logs with errors about missing mechanism for setting
the so called download (or dump) mode for users that have not requested
that feature to be enabled in the first place.

This avoids the follow error being logged on boot as well as on
shutdown when the feature it not available and download mode has not
been enabled on the kernel command line:

	qcom_scm firmware:scm: No available mechanism for setting download mode

Fixes: 79cb2cb8d89b ("firmware: qcom: scm: Disable SDI and write no dump to dump mode")
Fixes: 781d32d1c970 ("firmware: qcom_scm: Clear download bit during reboot")
Cc: Mukesh Ojha <quic_mojha@quicinc.com>
Cc: stable@vger.kernel.org	# 6.4
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Reviewed-by: Mukesh Ojha <quic_mojha@quicinc.com>
Link: https://lore.kernel.org/r/20241002100122.18809-2-johan+linaro@kernel.org
Signed-off-by: Bjorn Andersson <andersson@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/firmware/qcom/qcom_scm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/firmware/qcom/qcom_scm.c b/drivers/firmware/qcom/qcom_scm.c
index 26b0eb7d147db..e10500cd4658f 100644
--- a/drivers/firmware/qcom/qcom_scm.c
+++ b/drivers/firmware/qcom/qcom_scm.c
@@ -542,7 +542,7 @@ static void qcom_scm_set_download_mode(u32 dload_mode)
 	} else if (__qcom_scm_is_call_available(__scm->dev, QCOM_SCM_SVC_BOOT,
 						QCOM_SCM_BOOT_SET_DLOAD_MODE)) {
 		ret = __qcom_scm_set_dload_mode(__scm->dev, !!dload_mode);
-	} else {
+	} else if (dload_mode) {
 		dev_err(__scm->dev,
 			"No available mechanism for setting download mode\n");
 	}
-- 
2.43.0



