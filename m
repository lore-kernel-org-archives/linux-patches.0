Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 830B0168C4;
	Mon, 27 May 2024 19:26:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716838006; cv=none; b=ZQjxhr+Xpz1DGOmIZSmBuVxM6bIIxstd4FcPE8dgGlefarKxNUH6QAk8VaG0tYRyDSpg6uaKMYC8N8EYEW66r+U+b+BGBF7t4tSn+2tdHg4aDAR7U4j9WcxE4PYu32KUxe8c5TTYggrI9ZuhD9Ax40JZowwFBksg0/HaA1nStCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716838006; c=relaxed/simple;
	bh=MwWeiIp+l+xciVBQMPxlGCbrL+13SL+g3DH4q6EmbFs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ppiX5m+TlwD1Tfg1BQ9vvB67SpHCl80rdWKzBL61QBzOSu71qXdQYjh6CY/P+td0I4UZB8mDKAKyJidlXehNq/cpNFFiUOA+CF6ZSlkRVvQ1bQ3NPIaEN69p6PNHqKDNuaAOGX8P3Q2Y267x1KcVxUqe5fjgFfJowlm/IAxcSgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mrTZr/bc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mrTZr/bc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E76C2BBFC;
	Mon, 27 May 2024 19:26:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716838006;
	bh=MwWeiIp+l+xciVBQMPxlGCbrL+13SL+g3DH4q6EmbFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mrTZr/bcQxYiBCLz2qVs+E7YWNgc/HW57/bUQM10fraGZDyjfVTG5L73tFkrTbL3E
	 T7f2FwmX4+9gGc55MBpI9no+o3uNtGHMLbGylHm0Fx5wFQvFnWi63lgXE2i1xDZufu
	 by8nFunZY36KxM9am6yQMxOXiXieZXKo5nMFsNVk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Su Hui <suhui@nfschina.com>,
	Jeff Johnson <quic_jjohnson@quicinc.com>,
	Kalle Valo <quic_kvalo@quicinc.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 231/493] wifi: ath10k: Fix an error code problem in ath10k_dbg_sta_write_peer_debug_trigger()
Date: Mon, 27 May 2024 20:53:53 +0200
Message-ID: <20240527185637.862293581@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

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
index 394bf3c32abff..0f6de862c3a9b 100644
--- a/drivers/net/wireless/ath/ath10k/debugfs_sta.c
+++ b/drivers/net/wireless/ath/ath10k/debugfs_sta.c
@@ -439,7 +439,7 @@ ath10k_dbg_sta_write_peer_debug_trigger(struct file *file,
 	}
 out:
 	mutex_unlock(&ar->conf_mutex);
-	return count;
+	return ret ?: count;
 }
 
 static const struct file_operations fops_peer_debug_trigger = {
-- 
2.43.0



