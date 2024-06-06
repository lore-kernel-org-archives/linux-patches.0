Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E2601993B6;
	Thu,  6 Jun 2024 14:14:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683240; cv=none; b=j9lJF9eHq28+MuUABsoySGD+CDW8jQJavQlV/LBss1wyODjFn0nfRx2KyjfDyl3yZylzz3dta26tabDlAE0cqNcWrnnlzL9BIuDGaBBQnzGGFfaZw53kNyQyBOFcvKZDQsEBVScKI4pcMEzPJttlEpD7XBFQ22pIK/f9BJ1BwwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683240; c=relaxed/simple;
	bh=BySjaTD8leZuhZLxYUCrEf61wrvnssc46I8NP3bK7z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pxzpdN0ZIasG+LF1vGCuaq7eWqcIjf9+ZquchkqdKGGI2j0Kgyd19UP6OezhlvyhDpPYdwAQ0KTf1Di+5OMpfy80xQ6SGlOv3EmCjdZvcAxt4ommbY9cadhQrhDxrKBVsi8Is0HLu8q2NHwZHN/tOaJIr0wdfv/JAvawHXth3V0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pCm3yKbI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pCm3yKbI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EE78C2BD10;
	Thu,  6 Jun 2024 14:14:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683240;
	bh=BySjaTD8leZuhZLxYUCrEf61wrvnssc46I8NP3bK7z8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pCm3yKbIrFKroT7HulKfoT8XZ7fJ5trfHo8/QIvk08T1niMi2byZwz2rUKS3myMFj
	 znxa5L8Djvs5f/dKEuQ4YYG2HPZL33VJGzWjhF0B903O3jm+lMZHOQOSe35rIBkptR
	 XlDpP3kmdLKpUjfv07yVDOYYGuBDu0LukUCvxXGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 185/744] wifi: ath10k: Fix an error code problem in ath10k_dbg_sta_write_peer_debug_trigger()
Date: Thu,  6 Jun 2024 15:57:37 +0200
Message-ID: <20240606131738.362107512@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Su Hui <suhui@nfschina.com>

[ Upstream commit c511a9c12674d246916bb16c479d496b76983193 ]

Clang Static Checker (scan-build) warns:

drivers/net/wireless/ath/ath10k/debugfs_sta.c:line 429, column 3
Value stored to 'ret' is never read.

Return 'ret' rather than 'count' when 'ret' stores an error code.

Fixes: ee8b08a1be82 ("ath10k: add debugfs support to get per peer tids log via tracing")
Signed-off-by: Su Hui <suhui@nfschina.com>
Acked-by: Jeff Johnson <quic_jjohnson@quicinc.com>
Signed-off-by: Kalle Valo <quic_kvalo@quicinc.com>
Link: https://msgid.link/20240422034243.938962-1-suhui@nfschina.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath10k/debugfs_sta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/debugfs_sta.c b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
index 87a3365330ff8..5598cf706daab 100644
--- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -438,7 +438,7 @@ ath10k_dbg_sta_write_peer_debug_trigger(struct file *file,
 	}
 out:
 	mutex_unlock(&ar->conf_mutex);
-	return count;
+	return ret ?: count;
 }
 
 static const struct file_operations fops_peer_debug_trigger = {
-- 
2.43.0



