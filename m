Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060708;
	b=bi8p9P1gPuTIF3cJ7XLUDMpkpkeAGsyWhzBlHJOsvdM28Kutok5EYEoS3BNup73DbL/n
	 Pn1tP3/fxZ8oXszhRvUPXOpu+5nchx6SifRNn9P+skireO306vALCfcRbAkiP7YMAEpb/
	 f7LmIQxTD90iOg/2my8Yo9S+VsTANTQFMT4X6MKj2MWtZWs/b1Sb07gKznIQnSafaf0lR
	 Lyopp2GGosPvr2b8/SRePcn6c4P84N7vKBSwIiStfN4AyNeLciEKBGhUnxgA83U+vDvp7
	 SmcuQdQZTb1nSywaO4MbKW28aCISBRi+ulxTtxduqfev18I/IaCAQJC/vnKdet59/xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060708;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=pa+ByNIHggKE4QbYmXW8q9NQsTW38A9a0MTH287y7H8=;
	b=ekC04woIBGdMLpkDhM1wWe3JIgTaru/R+qevnbEQ8zqP+rjclkUnaues3l3RL4RssnMf
	 A7Cit/ftIMoUBrDoN81AIzq6JJNtkospcn2o7u8t5xP/ygXDbg0p+WHxLE4P1pJF+YUG0
	 wdsFvbHrOtuzpqOEZQLUKLioL9Q7wLCSVY8VS4v8KhBLUZnYDZ2eUDqcZsdJTsT7lzQuv
	 XRmq3clvtTKAD5uYBeq/vjbV3Huqg5Rhb6JKeXm+iDglXg+FzSlDg5ndzg1Y5UVFanskv
	 7O6UUS6Y4HfWmPUmUhtrt5UBVRO5UkCznVZNtG7w07D+vp3jfP9JjpI99H3uiYIC0Xw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tJkZDc55;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B790606A326;
	Sat,  7 Nov 2026 14:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tJkZDc55
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24D4B1F008A1;
	Sat,  7 Nov 2026 14:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060708;
	bh=pa+ByNIHggKE4QbYmXW8q9NQsTW38A9a0MTH287y7H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tJkZDc5529RBK6ZbePj0zKsS1zj7IbLYYF1amdBUVSyqLSLdsO2USwsEDZpeDQzuZ
	 4JJDEoWTotqDprQJ21WmlZeoNf/KcrnZF+wjhWA9EEvfQPXXZIpR7FpnW7FUyK2S0S
	 mNFuKQzyxLQgzvJukH9JmxVkqgA2HtmpUxW1LnGw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Thierry Reding <treding@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0136/1536] gpu: host1x: Wait for timeout worker completion on channel free
Date: Sat,  7 Nov 2026 08:35:52 -0500
Message-ID: <20261107135001.508882143@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikko Perttunen <mperttunen@nvidia.com>

[ Upstream commit 7a39b9856acccc8e9b05845ca2bf62494fcd3dfa ]

cdma_timeout_destroy() used cancel_delayed_work() to cancel pending
timeout work when destroying the CDMA. Usually this is fine, but
there is a narrow race condition where the timeout handler has started
execution but has not taken cdma->lock; the channel is freed causing
cdma_stop to take cdma->lock and flush the channel; host1x_cdma_deinit
then proceeds with deinitializing cdma while the handler is waiting to
take cdma->lock.

Therefore change cdma_timeout_destroy to use cancel_delayed_work_sync
instead to ensure any pending timeout work completes before proceeding.

Signed-off-by: Mikko Perttunen <mperttunen@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://patch.msgid.link/20260609-b4-host1x-small-fixes-a-v1-1-7c1131c0b3ad@nvidia.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/host1x/hw/cdma_hw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/host1x/hw/cdma_hw.c b/drivers/gpu/host1x/hw/cdma_hw.c
index 1b65a10b9dfcf..9607330000f24 100644
--- a/drivers/gpu/host1x/hw/cdma_hw.c
+++ b/drivers/gpu/host1x/hw/cdma_hw.c
@@ -343,7 +343,7 @@ static int cdma_timeout_init(struct host1x_cdma *cdma)
 static void cdma_timeout_destroy(struct host1x_cdma *cdma)
 {
 	if (cdma->timeout.initialized)
-		cancel_delayed_work(&cdma->timeout.wq);
+		cancel_delayed_work_sync(&cdma->timeout.wq);
 
 	cdma->timeout.initialized = false;
 }
-- 
2.53.0



