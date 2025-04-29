Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17ABC2522BA;
	Tue, 29 Apr 2025 17:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947270; cv=none; b=icc+4Mfa26JDmhqVaGRiZOFl5iT2P4JZ36/z2nShOrd1m40HI3P5q4T/zkpvTAOTV4GCfgJfAqZgUL2plFYpaK7Km8cFxsb5f0VAxgwx7hIuvxJP6dzJKR12cZ4SJSo70oBGZLYjq3Mr1wjqdKGJoV99QT7VVUI8lJ5V6mW64tY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947270; c=relaxed/simple;
	bh=Q8omofmRTjJhnnnMzgDoK1Kj2vLgUfL8J+dqx0sVdhM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Io11AGfPRPj+YgszoIsUaJI901LZL+njmvdbvZJYZ3gMTQPNzbW475SFJ3/gWSN9CK1cJw4xx+hIHYI49BxSm++/vVu7JbVLxkPYH2nY851my6BPyUM3b1Jfy8qmdntTox7kHp4pXAHJdfqimbvWL4EEY10UdkoOqhY64F4R5hw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XteHeNNC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XteHeNNC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93B99C4CEEA;
	Tue, 29 Apr 2025 17:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947270;
	bh=Q8omofmRTjJhnnnMzgDoK1Kj2vLgUfL8J+dqx0sVdhM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XteHeNNCiiVrTI3IdsQ0TK68/4XZX7QcJCbJiU8Je/frYV6myGLbcVS4OL68O1nBE
	 FPX06tAIo9azF24E1wofbwJmUoqqs3UGIfBweAY7FafjcafNWNzNlaylyNFkFg9oq6
	 TAzKBlLsUWqGxxgpN0IId5/5mLV7G/L0yXGacS0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 197/286] media: streamzap: remove unnecessary ir_raw_event_reset and handle
Date: Tue, 29 Apr 2025 18:41:41 +0200
Message-ID: <20250429161116.066309988@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit 4bed9306050497f49cbe77b842f0d812f4f27593 ]

There is no reason to have a reset after an IR timeout.
Calling ir_raw_event_handle() twice for the same interrupt has no
affect.

Fixes: 56b0ec30c4bc ("[media] rc/streamzap: fix reporting response times")
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Stable-dep-of: f656cfbc7a29 ("media: streamzap: fix race between device disconnection and urb callback")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/streamzap.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/media/rc/streamzap.c b/drivers/media/rc/streamzap.c
index b6bd3cbec7c7c..cd4bb605a7614 100644
--- a/drivers/media/rc/streamzap.c
+++ b/drivers/media/rc/streamzap.c
@@ -215,8 +215,6 @@ static void sz_process_ir_data(struct streamzap_ir *sz, int len)
 				sz->idle = true;
 				if (sz->timeout_enabled)
 					sz_push(sz, rawir);
-				ir_raw_event_handle(sz->rdev);
-				ir_raw_event_reset(sz->rdev);
 			} else {
 				sz_push_full_space(sz, sz->buf_in[i]);
 			}
-- 
2.39.5



