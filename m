Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 100ED50AC30;
	Wed, 30 Sep 2026 16:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785572; cv=none; b=radZt+uhC8+P82vUq0Z60t7TxptSjoZPBxSLC3amW+XmfivsNfMUl36JPCjRqMRxuVYg0FV6wBLXbxYHkYmK3Wgyem9CqjnLf5JKoBvKPSxPn3NGk5ohVFaTKZHFXsa4xZOHeDYWHCadhtDautmX5orIxMw7KDvftmBtIceaZt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785572; c=relaxed/simple;
	bh=kblKfVXzyB3Q16pyDrOjTpoHhPLnbzkV+f9f9apwVNI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UrDL+LtM8fzQ/cKT21Mg38iYKLDc8l0DXmncL60nURPhysdz6OqTnMCvHf4X37fQLLkv0b308gEHQWtLzeaEVyHGrgFZTtVYDnD7TgVjVOat3ikhJwnOi5E+MnSfl4/1DWVlJYyNZjWLF3KR24IoXXeAnnoallTcsZ9tyyDnw2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TBXhhgB+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TBXhhgB+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DA571F00898;
	Wed, 30 Sep 2026 16:26:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785568;
	bh=LCbFfO2G8Yy8C0DZDD6QNtnqulAefu3kj+2cFkxGw7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TBXhhgB+7BLFW2XK2P6QPgAZ5IfRU+AkAi7ewayWqAiu7XZaZVVI0YeXHCebJt2/Q
	 DMZPCTqZ/zI0Li4YT9TRGZ+OiaW9ocSt53HorCLb3iwuRpX944x9BVlETGcL3TrkX+
	 aiLDYKEf9uNO9FN0RB/2DrjsTXBzORXbiHPFnZEs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 556/982] Revert "nvme-apple: Reset q->sq_tail during queue init"
Date: Wed, 30 Sep 2026 17:21:32 +0200
Message-ID: <20260930152428.716596084@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

This reverts commit 225b7af1dbd589c33faabe90b5bd85bd6a73b8b6.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/apple.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index e46048b755d17..060f80c5ebeda 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -1009,7 +1009,6 @@ static void apple_nvme_init_queue(struct apple_nvme_queue *q)
 	unsigned int depth = apple_nvme_queue_depth(q);
 	struct apple_nvme *anv = queue_to_apple_nvme(q);
 
-	q->sq_tail = 0;
 	q->cq_head = 0;
 	q->cq_phase = 1;
 	if (anv->hw->has_lsq_nvmmu)
-- 
2.53.0



