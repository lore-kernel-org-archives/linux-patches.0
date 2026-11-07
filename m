Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794061977;
	b=ckFkS4WbJx2rsWj649AjZHMK2EEFX2B4P40p0LdeDGoZaKIIGxkMuTwKdGfQJEmibRyN
	 Ze/PgtxI1xPMputmnClCLV+wLiISq6sRcHe8kfTqfmtgiMD+y6Phi0qZfr13HP/SvtbzJ
	 uumLc06f3keVP3hn+SPkzzk26cSVRgqtrPBgsn/KqmVW6GU3ZgB/QiA2YmR8K/NcZQ526
	 URXqELMhiPNN5AvNE21B0OleF7DMuaB+mmJdGq4l56KtMFJXvndN+lhXsmimcGgmyD6Cf
	 KcM6Q1P8fEo/0lt1NoNF4DhOv5inaMw1LEIoJdG+mLvlsr70DoZ0htZufKLjolpPpPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794061977;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OufVeUlKaoXY/oav4Kuj8FAlG9Nez01oD4xAXdVtFoY=;
	b=zsPH8KCeBOX0XqM2dWBUg+L0ektRVUxjgzHizuC2Ce2ll384Az43s9hGkjloEWXKlj1G
	 UnvO73TvsPUV5w4hSdJIQuCLzOSsL7/wLpSkPtMI52+t+8ysPZ5eQyuXgE0t2cfpEFu12
	 0stnQouxxgHW5zRpxYvs9lyQTTMIGgQj+B9dFPhChA2EwMaeWvOwld48fRFnsj54M2/sd
	 O6gBhHPoqpk2bMe+JKXVkeXlgQRg/CJqLWf38w3lTfwYh3Sh1tCtiQQ7RkedUGtVDN5NF
	 qY6rIPeyXhFfdbYBlQ0Q1Y1vpDvGn2mmRwETpBamvGTJTrMsY38miwdMM0rz9VdFdBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VpBLb+sw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8572606A333;
	Sat,  7 Nov 2026 14:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VpBLb+sw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 970B11F0089F;
	Sat,  7 Nov 2026 14:32:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794061976;
	bh=OufVeUlKaoXY/oav4Kuj8FAlG9Nez01oD4xAXdVtFoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VpBLb+swMzEXuyfddft60/eA1itxfuR+9eU6oBI6Uis7FP/XN2lrjW6xwiqx8pbtP
	 WOUiP0sHSEuEQ48Jri9QvpTOm3r+GH52BaDhtMswDgQ/K8Mfr/TPrdzukVMpcOcSdI
	 s4dmoKgLtW+Xk54FKH760TPNnZQpuuCdjdIrhD/Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0971/1536] media: vivid: cancel svid ctrl work on release
Date: Sat,  7 Nov 2026 08:49:47 -0500
Message-ID: <20261107135024.919569187@linuxfoundation.org>
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
index cf9f37bc0c08a..767bcaaa02de4 100644
--- a/drivers/media/test-drivers/vivid/vivid-core.c
+++ b/drivers/media/test-drivers/vivid/vivid-core.c
@@ -852,6 +852,7 @@ static void vivid_dev_release(struct v4l2_device *v4l2_dev)
 	struct vivid_dev *dev = container_of(v4l2_dev, struct vivid_dev, v4l2_dev);
 
 	cancel_work_sync(&dev->update_hdmi_ctrl_work);
+	cancel_work_sync(&dev->update_svid_ctrl_work);
 	vivid_free_controls(dev);
 	v4l2_device_unregister(&dev->v4l2_dev);
 #ifdef CONFIG_MEDIA_CONTROLLER
-- 
2.53.0



