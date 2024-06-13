Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4718E143883;
	Thu, 13 Jun 2024 11:38:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718278710; cv=none; b=aXtW89pG/OI1EmEwP4PxnDagzjE9kyve7DoT9HzbmgiTCJuz9yzjtWzjml2Oye9a/tWAyLY/Bh08Hq8TIbFGU54zZXuZZ1PQJilBRvxiPo1ifPn/Agl4t7ZwewD5vpE+QV5aLmmUmbeYtnQCZFoctc+mR5NQjNFjj2LnMz2g+jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718278710; c=relaxed/simple;
	bh=aK4pjXJXDkyyv8Q3ItL4DLaSpEarVzXyjgZFnVBA8Q8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RbWU/Id9xEh9FziYS9seFgzB5E06kMPxQXU+psK+FDy2PgoCQmsT0TP0YTMbQRXSP6L/ekVpe605qyJWevDDNAP4ebcoR/zGfcWYHTySneIDrgwLL2I+/Sm2HMhGDHHHiB7vAw4r+//Ml7oyLP9Qm4tFCxOC6ELXQs0lftdn2kg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N0LP3moM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N0LP3moM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0B20C32786;
	Thu, 13 Jun 2024 11:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718278710;
	bh=aK4pjXJXDkyyv8Q3ItL4DLaSpEarVzXyjgZFnVBA8Q8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N0LP3moMussS6yw6BlgSNzPxGk+05UA8qvpIP7wCxkJKj1EHpacq6H6F/YgAgO4dP
	 3HvTldTv7Y7f+ismYQubX8l/W+3140P/skgzMq5Po/AQsMTMeCwHT/ylzp5Ovl3NJH
	 notC7EuD5/y9PygEoHbIkmQTWuE/tRvqCMS6MOME=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 042/213] wifi: ath10k: Fix an error code problem in ath10k_dbg_sta_write_peer_debug_trigger()
Date: Thu, 13 Jun 2024 13:31:30 +0200
Message-ID: <20240613113229.626004465@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113227.969123070@linuxfoundation.org>
References: <20240613113227.969123070@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 6f10331e986bd..c7d7fe5d9375c 100644
--- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -449,7 +449,7 @@ ath10k_dbg_sta_write_peer_debug_trigger(struct file *file,
 	}
 out:
 	mutex_unlock(&ar->conf_mutex);
-	return count;
+	return ret ?: count;
 }
 
 static const struct file_operations fops_peer_debug_trigger = {
-- 
2.43.0



