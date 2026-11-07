Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062910;
	b=pfT76a2M6T5brXlv619vr+11rmPM5c4iC5nd8j62lf0uTgmemBjGdVaBlyZ2JUntcvmG
	 HJcrCKid8J/RjFeXbIHgUxpvONuoZxjPxzRNAqy4E40n0bI706iIjsrVkvdW5Csv0+YKb
	 j3viwxICA4BQ5Q5K2zI1s72MYOqeqpWJMQvizgSrzqb+C4HTvyZP6lMK7ZZfBk3lmdMp3
	 4VvzXXAA1y/on4T1lVv7czUYtX7VH5O1l7vB+rQFZJipOQH6b6u2qxPSsZEGzOQA1VVEe
	 M+hSrTLhRSYFDJ3LvRG3ehvYybXYyr2nFvK86u3TvETS7CCoo1wE6vtMxiDrV2GMaWw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062910;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ecn1GZl8SroTE/6OZ7VgNs2RsHYpSyWln2fH65v+Isk=;
	b=W9RnO4vCtMkaqnX+sRL1KaMGTbCe1rLme7ep+S7zdh0MM30xdeaB8dpILYP//ZSIlz/N
	 WoDkY8w77N2PrCs7G7KoND7lkmtkWttSlNBBRlgvsez0tdTx6ZDcW0AvpCAOlwVmqkvWC
	 DQ2tbHxZ3kVVV9wUulVAAFWYAjSvfyMu0yi8NZBKK0kEd/zAKqfe/3VIfPpvd//HsYMY/
	 qLedlJz7cI8PKkV2cpGvzWeaMKYas23thoy4hQ84b/Uzqtq/NkjveC7n1Ua7WqPf9npb2
	 AUuiKiCGIKjxnL3eaVg935GKxZRYUoKhCH3dokAev7YV50/Csk4gEj1wmYvZVIZCFuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rWL4uxOg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 771EC606A334;
	Sat,  7 Nov 2026 14:48:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rWL4uxOg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC4F31F0089F;
	Sat,  7 Nov 2026 14:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062910;
	bh=Ecn1GZl8SroTE/6OZ7VgNs2RsHYpSyWln2fH65v+Isk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rWL4uxOgR3TBRjK54Vqq2J19NqA/ozJz4RtlHTsNf+UmN+eMRjmsHcdwO+48aAyAM
	 i2VNTOn36idc6r7hG4v4bxxPpKkrnLO43yP4+hxO6IrGz8cGZC2jv4veSujWrTXW4v
	 FrgCfNXg5X9mWnKjcoUv+AN5Ar+/yZlWHXPzJJ+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 124/869] media: vivid: cancel svid ctrl work on release
Date: Sat,  7 Nov 2026 08:46:46 -0500
Message-ID: <20261107134856.705614781@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fan Wu <fanwu01@zju.edu.cn>

[ Upstream commit 1adaefca7111235ff0a2219dd4899ac24601d6e8 ]

vivid_dev_release() cancels update_hdmi_ctrl_work but not its sibling
update_svid_ctrl_work, which vivid_vid_cap_s_ctrl() queues on
update_svid_ctrls_workqueue when a VIVID_CID_SVID_IS_CONNECTED_TO_OUTPUT
control is changed. The two work items were added together, but only
one of them is cancelled on release.

If the svid work is still pending or running when the last v4l2_device
reference is dropped, update_svid_ctrls_work_handler() runs after
kfree(dev): the handler iterates the global vivid_devs[] array and
calls v4l2_ctrl_modify_range() on every vivid_dev instance, including
this one after it has been freed.

Add the missing cancel_work_sync() next to the hdmi sibling, before
vivid_free_controls() releases the control handlers the work uses.

This issue was found by an in-house static analysis tool.

Fixes: d7c969f37515 ("media: vivid: Add 'Is Connected To' menu controls")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Co-developed-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Song Li <songl@zju.edu.cn>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/test-drivers/vivid/vivid-core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/media/test-drivers/vivid/vivid-core.c b/drivers/media/test-drivers/vivid/vivid-core.c
index f44930502bdaf..64a15a24a9c37 100644
--- a/drivers/media/test-drivers/vivid/vivid-core.c
+++ b/drivers/media/test-drivers/vivid/vivid-core.c
@@ -854,6 +854,7 @@ static void vivid_dev_release(struct v4l2_device *v4l2_dev)
 	struct vivid_dev *dev = container_of(v4l2_dev, struct vivid_dev, v4l2_dev);
 
 	cancel_work_sync(&dev->update_hdmi_ctrl_work);
+	cancel_work_sync(&dev->update_svid_ctrl_work);
 	vivid_free_controls(dev);
 	v4l2_device_unregister(&dev->v4l2_dev);
 #ifdef CONFIG_MEDIA_CONTROLLER
-- 
2.53.0



