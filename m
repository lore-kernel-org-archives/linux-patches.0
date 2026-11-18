Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047732;
	b=EFOg0BbrAv641h3PyUYoKJyngF0HcWbBfAXIZP60pr2r9hTxVLGXGU5jCE1ASzSlibJV
	 Arqxyv9GCk+7Giq0MRDxsm+rMkq4QL+sU8qjr8M/AHc1EyTP/6LF399EB4Wxv4oRM8RvJ
	 qOK6t5tNu7xgyyCjC+jdKC3Brp4Q70YcdINio+TiWtiP+Ev7K4lzES2NppktRE5Jfp9cr
	 kNRiEDWzujN3IsLqxrGMxW2tAu9gAXyudcfi2o4cIBSfgND/QB6ERphRBWOLhisSz98ls
	 Qo4y0km/8+rjSSyufwyMjDMLeazSpIn+fXdWUyks4VR/W2BIrRoaEoHE4E95VHiTUvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047732;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=HLBHdrGDZrTAhUQ4/DU71sirS7RHCrU+FY7dvd6bnEE=;
	b=hQsNHt+VHuttB0ZzJCyShwSBSKCCzhsjZ30Uxvu1IKgP52FKZsMrCN0+wpQffrzY/1kV
	 ES2ZK0uebAkihx/LNH6y8SKNjEVcB4WmLbsqYNn8I5QeFcqZJvAaLijgFbwllFcJ9iZSe
	 pUlMB4Z4lHY7vFL0F7fejQ/3xEL8ELKAtmrHpeDGBD3f/fptUtrkH+1mWMIf/wTamYM79
	 wSVotCxEbcxtRQyb8SzR8e1tvzogNH5aSn5dsY4YYps9J3l32ZAMUoQh1vkjV+iqG148C
	 5NWQ34wJb7mTa5Ge2DDrx/3o6/oWEj/DZRCYlEC6h9CPzJAQlTKexeYAWbVlQqMuTHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UDXDhE59;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC5D4606A325;
	Thu, 19 Nov 2026 00:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UDXDhE59
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B5A21F000CC;
	Thu, 19 Nov 2026 00:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047732;
	bh=HLBHdrGDZrTAhUQ4/DU71sirS7RHCrU+FY7dvd6bnEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UDXDhE59FGN6PgYVVF2XgILYjDHhRkXDXAm+Pp87M7WcjxD9fY77yn1ZB4/ISud+T
	 pFtnf+rve6NVxcOaJuNC+QwFY465FOT9bWZ/hXsPobzqDjxTnW7XmT14sVD8cJGcdR
	 hjaTZVtWBfhSmxWjPqYRyOtlO6oiPDWkuzoo/5ew=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Claude <noreply@anthropic.com>,
	Steven Price <steven.price@arm.com>,
	Boris Brezillon <boris.brezillon@collabora.com>,
	=?UTF-8?q?Adri=C3=A1n=20Larumbe?= <adrian.larumbe@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1727/2857] drm/panfrost: Prevent division by 0
Date: Wed, 18 Nov 2026 15:46:01 +0100
Message-ID: <20261118150303.502599968@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fe5f12f16a632..c72b5ebf18283 100644
--- a/drivers/gpu/drm/panfrost/panfrost_devfreq.c
+++ b/drivers/gpu/drm/panfrost/panfrost_devfreq.c
@@ -69,7 +69,7 @@ static int panfrost_devfreq_get_dev_status(struct device *dev,
 
 	dev_dbg(pfdev->dev, "busy %lu total %lu %lu %% freq %lu MHz\n",
 		status->busy_time, status->total_time,
-		status->busy_time / (status->total_time / 100),
+		status->busy_time * 100 / MAX(status->total_time, 1),
 		status->current_frequency / 1000 / 1000);
 
 	return 0;
-- 
2.53.0



