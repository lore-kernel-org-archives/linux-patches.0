Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018689;
	b=Mi0BjcOZwclEqjYbSDJ3L91mrm/uuDABc+YHc1D9Uilj8mXyM/sjxktqm4mE/A0EjlV/
	 v8F5cdA2VfI6uH+l4zt6YFhgxahO8SiO53DbJt0mFPR5gyZDr9ACvAmagvXm4qc9vIdzq
	 E32cwqSH4CqfDDhMvUrfFp32DvKwlJSREQGnKUPO05mxdNLOcT+ZVk6N9vAX0ulAvkvlc
	 5onh+DeEQZ9WqITom6CWReAJsaO7ISTB9WHxgXXEu8tzafzHWL6pql/hKzbgLOwnwExOZ
	 HYt8Sm+5NDuxfhCh5v8Oiq2IiaL7jQbpC5uTo3pW/bA1hgI/QI0dfpSZlIg/WxeqYew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018689;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=96wiLDBdfH+eCnG7DcyzmU1uOJtCkyqYft/cXua6gck=;
	b=Q4tibEVgegx2ffRT8bObaaudI66ubwfQyLvgg8oaBCGXxZXMmVQrGdnmrNeTXKuLEQyv
	 m5qXtG40T6zgYuMnmeXNP+zvUiqyNH/8jtoZ/hlbX+71ucwlt5qr0pcBJ8zu+n4pxoPkV
	 Z8ukIJVuprpDto+VeGuXLIz+wnykljFbKA8PPrrxNvuTP/kZkjaIaI9BE661KAnEVfXiv
	 MqUXMxzO3whCvEfeE7RooXEPtqZ50SAWo0JIs/Y9aRcV6NaQzcmgPp3QrMeIeZhxqjf3Q
	 V+0qaDyXG4InlBRFPAPWvxqqdDywmXTOBjvh0V5tBPJXL16PzZp1L5PEPscx5Hd9IIA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T934Is2m;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1494F606A31C;
	Wed, 18 Nov 2026 16:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=T934Is2m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 712811F000C4;
	Wed, 18 Nov 2026 16:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018688;
	bh=96wiLDBdfH+eCnG7DcyzmU1uOJtCkyqYft/cXua6gck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T934Is2msXfzWZDYBeLtWZsuM4wikJiC5iNuFSOqbesXdY0UJJlUNBg2lZkPVUvcf
	 +jl5tIEhBmdHlqtisWuWnF12F3AM954sah7uwLDxTREThxujRU3UFGyPiegNdTkL6C
	 e+VGdqazpsepgOC72RsTfvJY1edMM24r2w2w1TS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Jiale Yao <yaojiale02@163.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1329/2651] wifi: ath12k: Reserve space for a string terminator
Date: Wed, 18 Nov 2026 15:42:49 +0100
Message-ID: <20261118150335.852997777@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit 13b15eabe2c541b80406166964cdc8ccb5e9c32a ]

ath12k_write_htt_stats_type() accepts count == size, which fills the
zero-initialized buffer without a terminating NUL. sscanf() then reads
beyond the buffer.

Reject input that leaves no room for the trailing NUL.

Fixes: 8c7a5031a6b0 ("wifi: ath12k: Fix buffer overflow in debugfs")
Reviewed-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Rameshkumar Sundaram <rameshkumar.sundaram@oss.qualcomm.com>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Link: https://patch.msgid.link/20261003095913.575108-1-yaojiale02@163.com
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c b/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
index b772181a496ec..f84f1828275af 100644
--- a/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
+++ b/drivers/net/wireless/ath/ath12k/debugfs_htt_stats.c
@@ -6190,7 +6190,7 @@ static ssize_t ath12k_write_htt_stats_type(struct file *file,
 	const int size = 32;
 	int num_args;
 
-	if (count > size)
+	if (count >= size)
 		return -EINVAL;
 
 	char *buf __free(kfree) = kzalloc(size, GFP_KERNEL);
-- 
2.53.0



