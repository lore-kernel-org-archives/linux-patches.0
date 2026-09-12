Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93AB12DC321;
	Sat, 12 Sep 2026 15:22:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226561; cv=none; b=RCZTROonEmm5z8XK8OvAhaMp9z22mcRbco56o7zv/s4f4CfX1jeFvyJWBDroRj51VjDKccoCVVtN+tQcvlYutv689SY6V8HXnt84YA0MKwcVThj2CbOwfTNQ/wE5LbKNh7kXqI77C0s/NlXKlYKu83d3YZni+gMtWPTSY8wTWxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226561; c=relaxed/simple;
	bh=zkRxf9bFXpKb9MUIRAeFkfRpIkix+NMpUiHhAvrY9xc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZD8z+c043ovMxrq9bFlZ8+DjVsrZDDx5VEKyheXBBLrK8CoS8kX07ytolwaUYnmt2j9BX0449r9ZNQGI1hgcfk6pVikVlr3SsarTKEhOaudZReKVV6e4BwCqVl4arnoDwqerPrmFjyqO2x6ulqH55MlXq9p++UfqmshLWf/jzGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ws4+GlIw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ws4+GlIw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E80B1F000FF;
	Sat, 12 Sep 2026 15:22:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226560;
	bh=iwBm6GQpAcHGlEz9AnB5n2pwL+IvZTqqmerxMDiKQGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ws4+GlIwACfgEiWUEZbznj+Xg152QkzvcXbl1u7GmZdqFraWdIVtG0Gdow4DOwvXT
	 7PSi4dZayTEQEVX8k153Yzt5vcedOA2mY8yJYOxKxGxMu9LY440RuK4cwRFbj/qW/r
	 z7zcdLrULwm6tPoJksj+wjYMuiKrnC/4gcoWm7cY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matvey Kovalev <matvey.kovalev@ispras.ru>,
	Baochen Qiang <baochen.qiang@oss.qualcomm.com>,
	Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>,
	Jeff Johnson <jeff.johnson@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1414/1424] wifi: ath11k: fix NULL dereference in ath11k_qmi_m3_load()
Date: Sat, 12 Sep 2026 09:04:06 +0200
Message-ID: <20260912065638.926015404@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Matvey Kovalev <matvey.kovalev@ispras.ru>

[ Upstream commit 3fd2ef2ae2b5c955584a3bee8e83ae7d7a98f782 ]

If ab->fw.m3_data points to data, then fw pointer remains null.
Further, if m3_mem is not allocated, then fw is dereferenced to be
passed to ath11k_err function.

Replace fw->size by m3_len.

Found by Linux Verification Center (linuxtesting.org) with SVACE.

Fixes: 7db88b962f06 ("wifi: ath11k: add firmware-2.bin support")
Cc: stable@vger.kernel.org
Signed-off-by: Matvey Kovalev <matvey.kovalev@ispras.ru>
Reviewed-by: Baochen Qiang <baochen.qiang@oss.qualcomm.com>
Reviewed-by: Vasanthakumar Thiagarajan <vasanthakumar.thiagarajan@oss.qualcomm.com>
Link: https://patch.msgid.link/20250917192020.1340-1-matvey.kovalev@ispras.ru
Signed-off-by: Jeff Johnson <jeff.johnson@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/ath/ath11k/qmi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath11k/qmi.c b/drivers/net/wireless/ath/ath11k/qmi.c
index dde60ca9d2b8b..c3723e49092ad 100644
--- a/drivers/net/wireless/ath/ath11k/qmi.c
+++ b/drivers/net/wireless/ath/ath11k/qmi.c
@@ -2550,7 +2550,7 @@ static int ath11k_qmi_m3_load(struct ath11k_base *ab)
 					   GFP_KERNEL);
 	if (!m3_mem->vaddr) {
 		ath11k_err(ab, "failed to allocate memory for M3 with size %zu\n",
-			   fw->size);
+			   m3_len);
 		ret = -ENOMEM;
 		goto out;
 	}
-- 
2.53.0



