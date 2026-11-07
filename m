Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063954;
	b=EmFDHz0rWN8hg1BAxIYC6JrMgl7f3dGyciQtg2rqfOn9n+FzDGVjqCSZgpxFfYormXrg
	 GNLJpXdnWNoW/QkDAmAXkyR5ZacBmYp4yu4D4lu1ISlMCTnlGwZo7dK+vz4poYR64ferr
	 j4PNg8DH9DDrzjmpdYH7Wsj323zWTuP6S/3RLvefWrRQi1tFq/DTgHefN0R4nGr1Rexpk
	 e5mvPI31yLtXsic8OtnBVcskx9E/6pIvnjRKCniDV6JTuyEY/mn0EMIN6mzq07L21Ljdt
	 92nPUAACoUIVEyQQxIuhORLpQadWJdKg4LWjAh5j4x4DL5JbGjlKguunh2Z+VrDX83Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063954;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=I+qWEh8iAIpA6DwS9kKuD5g167hM9lQYierjcAiMtq0=;
	b=wAUQh724cyw1sk7lZNGRuK/EcS31EqwdRuRIHWZA3PGgIxUomtPQiHn012tcZbsswmuX
	 yBWFwg4ZU9NAxSHYNc7cqRsbpBIawPQQLH1g7LCvpDr7HpIQd5nUb3ScFx1UebhSAOKtt
	 wo6wImxXSs/0NH5LEZiDcZAb+JgRJ2tWCt/gTYNK3rQpQZbwtQLgypK4NmIdCeyv0+Odh
	 M6xELF23jIBUmEUN/FnGgYx0UmH3gTFjyx76w93++volTgrGizT7ZkI6CAP549/trvyfo
	 NZcKx19l13JJ3ethbvdVbAAVXmNPwhTZFcJfE+KhhX9wHiAR7SM/V+5S/u/ev7fanIw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TSoRgOZP;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B42EE606D829;
	Sat,  7 Nov 2026 15:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TSoRgOZP
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60C321F008A1;
	Sat,  7 Nov 2026 15:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063953;
	bh=I+qWEh8iAIpA6DwS9kKuD5g167hM9lQYierjcAiMtq0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TSoRgOZPKXdAbJ/lE7nDBvHILQcwcyRywSMsNZ6OI6gAxrG2g7U7TWrGXc9WJqski
	 199znphC0xw3EfduLFDXDFkUbCfKESDTRxuZtgUPTJ5fqO+bSvFxFDyXXpcp409OfH
	 B4IpVYbDNwqYuamXwjogOxzikDh96vQw4dHT/dPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Song Li <songl@zju.edu.cn>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0144/1257] media: vivid: cancel svid ctrl work on release
Date: Sat,  7 Nov 2026 08:40:40 -0500
Message-ID: <20261107134943.287390444@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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
index 62cfb5feb2cf5..c042d92db175d 100644
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



