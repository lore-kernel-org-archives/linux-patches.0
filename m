Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060216;
	b=AQ+GhGKtQfwmiYhctFVMDQorJSSB1AdvtlX/5WEuVNnJdDaPva8BGl8FnYEqjZE80dCx
	 4Lj1nUdtEfB8TMoS3Ggt9IcdO5sXhhVlIvnKYwNhwdNq52Mpm3ipR1Y4qy+k2/r6DShiI
	 nYfa7JPwAbEBpMe9yACpMwACKYCWWUPp2y4NYwvLvW5Ok6ORSGPrer/GTJbQgsQ+Qvq9C
	 9wJxry2vDRwOHm+3s0gwPTVCLeim1QwNswz+EK/9qATwAqEadW3cFG8Xpwj6dHryoFZxw
	 doWOSEyUojkHCM4v3+T0GO5DTsQGkrdpsvEaRm6mUIkF/oBKM8aMPUTAXASrKIatDwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060216;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=BbHT0MkKV9879MHhHKG99k74VBxOqmwYg06Aaghbd3I=;
	b=0cKtZT7kTno8A2SH1J28YpIpmzvbP2jQtIhU1BJ+Fu1wg8PQb31xkQuDwFfh6L19KGZA
	 ixM/Ta9xOKoTV2561hFKn5FAhtZIrbOlSC+ReUbMOxZyzLvlTByMzzTV4HI18bCzPKOLm
	 IP+UBxsD3mVcPCdXtWoLKHfhTkRfOvU0HVdyZ1n3fqT065sT3or/jAp/Bw+CVq/eWh9xe
	 WABqRTQgf3QQwVs4ykgq2YoYUijMjR4PkNyKGrX+Znq57g6JcXjMEaDtWS1nAFAIaRoZr
	 GxvtnFqbtEO6YtTgjio+Y9p3HH5k2AS1WKTOfhqKpl2bkZQ0hWzKB1wdbJv167V38yA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="oE/kNuHu";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABC8606A325;
	Thu, 19 Nov 2026 03:50:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oE/kNuHu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90CC01F000C4;
	Thu, 19 Nov 2026 03:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060216;
	bh=BbHT0MkKV9879MHhHKG99k74VBxOqmwYg06Aaghbd3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oE/kNuHu2rojfAKD5ILFxh7oTMm1Gj1hT5bhiUZQDOEMP88w5yWRXX8o1M0EzJ8GN
	 KILkOtB70LVf63w8Z8CPhZv8Nnl5M5LD1Wf4BhlnTI1M71f72N+ySmD99RsyBuhqfq
	 dG+REcn/ZVq5T1Wa5h+x5MWhzI7WyPuIoHLLyBA8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claude <noreply@anthropic.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1120/1848] drm/panfrost: Prevent division by 0
Date: Wed, 18 Nov 2026 15:52:38 +0100
Message-ID: <20261118150006.212937008@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adrián Larumbe <adrian.larumbe@collabora.com>

[ Upstream commit fd4227f03546c323b5b21568f727233e9792d298 ]

When updating and debug-printing devfreq stats, in the very unlikely
off-chance that total device time is less than 100 ns, division by 0
would happen. Fix the divisor when relevant and rearrange operands.

Reported-by: Claude <noreply@anthropic.com>
Closes: https://gitlab.freedesktop.org/panfrost/linux/-/work_items/88
Fixes: f3ba91228e8e ("drm/panfrost: Add initial panfrost driver")
Reviewed-by: Steven Price <steven.price@arm.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://patch.msgid.link/20260820-b4-panfrost-fixes-v1-2-1b2c2376f4bc@collabora.com
Signed-off-by: Adrián Larumbe <adrian.larumbe@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panfrost/panfrost_devfreq.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panfrost/panfrost_devfreq.c b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
index 8ab025d0035f3..891075bd82db1 100644
--- a/drivers/gpu/drm/panfrost/panfrost_devfreq.c
+++ b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
@@ -74,7 +74,7 @@ static int panfrost_devfreq_get_dev_status(struct device *dev,
 
 	dev_dbg(pfdev->dev, "busy %lu total %lu %lu %% freq %lu MHz\n",
 		status->busy_time, status->total_time,
-		status->busy_time / (status->total_time / 100),
+		status->busy_time * 100 / MAX(status->total_time, 1),
 		status->current_frequency / 1000 / 1000);
 
 	return 0;
-- 
2.53.0



