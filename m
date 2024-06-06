Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63668199E8E;
	Thu,  6 Jun 2024 14:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683256; cv=none; b=Ae/umwUuJ+xAjtjvQuowzFhlDSCy/MvukPXV1Ufxjz3gYblr1+/TY/rsOh89jMt7KVbUMfIKzl7CebieFJGLaseGDRlCF+JRtnHB24BaoAissjh2aBhuy9WOzwOGqHy1vLN7pvQ/+j8HDXfgChH67rHc8zG2yceUWImpijUZXSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683256; c=relaxed/simple;
	bh=ZgooElYuAEY8MiVZdIHNhTbJnUBOiR5QAuGH2y6rk0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uZhj1gcK+CfIHKwPsjTc4QWrXLy/Mplv7zi59dGeOnbg6s6NobDIo6xRCU0/csfa5T3Iydt4Bhl6BIzsZlMkfsUJ7KK568Ygdz2p5HguRGC6ntCBSrCR6FUoxHogiCShz7OJeJU3Us01L78+oDi4ZMOB7tqVxBr9zdA2TUFqJx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MONJbGPo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MONJbGPo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394F1C2BD10;
	Thu,  6 Jun 2024 14:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683256;
	bh=ZgooElYuAEY8MiVZdIHNhTbJnUBOiR5QAuGH2y6rk0o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MONJbGPonz3nfmuHkwQPo/BK+VXXXBI4gxe4ykej1FtFSWnxnB1Qk+HhjwPtOmbgm
	 DZU1OFGrP95DE821TJr+En1R6F5ftR5AHLBMQVIp1C26FcdO183WLnUG1gttBCPyKv
	 QqtdyNckbB7x9i0Oz9U07bwHLwmIP+KiAq7ZyYzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 132/473] wifi: ath10k: Fix an error code problem in ath10k_dbg_sta_write_peer_debug_trigger()
Date: Thu,  6 Jun 2024 16:01:01 +0200
Message-ID: <20240606131704.291566025@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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



