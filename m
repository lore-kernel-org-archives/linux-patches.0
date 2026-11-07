Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064370;
	b=IJAjE7zehc0EGsyU3XM4H3DgLel2OMwmbp5WefbpJRxHXv/uxaCJYE8Xrk3AaXOW6R6Z
	 Ek3TymeL4M8l8860G+IfYJd+PFDRBpbAAmANCRaDVExfUB2kQupnIZRZJ5uMjsurBhY93
	 M+yvu15ro92HSCH5IUlQE8eoDjgVaAnKTZOvXyfH68QC872MDn5M5J+DVoa4qbaRG0CXz
	 W8PENk5INPjdQAw6Joqq8K5bw/1NOm4N729wBnMNl3E260254LBL6ZF2LTuNNwCIG2B2K
	 pAUW87AmNdRnp3Rt6ZLoDaHowYgz87wO2rprwoFrMN8i3mz3OxaRAIVvdewwtWY3dxw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064370;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fl1cyuID8k+LpcXRPb5ULvydxEZNj/ZX+wawo2w63es=;
	b=i+W8g+3Angu8gt+8vecuy1Wr0pmXfZuaWdt6LcfyLR/VK0CtfcXgCIFqu49rYWKDTLOv
	 hHlgQnOJoqRxpzr7jWLakM/3YKfDn5md64siu8sXwt5lXJHBMY8lD+2R9F6KX8ObqMzRr
	 km7LE4hwAYMw0pw1MChHWTtVFHhtRB+QuWnqYfvg78AqY0Ck25GohrVZbCvUjpWwbxjEn
	 mEKUIlk4RcUW5UqOfX0P+biU+g82cp3j8IpcbxBYEgpXCs0+mLTUk2/pxoC/RrqkgKMQ8
	 JkEcPk/DCa5O/B8Hutw+k/z3h0TYv9Gw11+nLYabQvGsLsEcQAs0oImoMqa5Hoimn9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mQ6GO/NG";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FEF6606E8CD;
	Sat,  7 Nov 2026 15:12:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mQ6GO/NG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB0CC1F008A1;
	Sat,  7 Nov 2026 15:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064370;
	bh=fl1cyuID8k+LpcXRPb5ULvydxEZNj/ZX+wawo2w63es=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mQ6GO/NGPkpRWNpAE+oVn3GOfBSkl3fO4ql3PlnpbLvyOOjSMqv4CPW7Vkx8QCQga
	 BXb/uaz9UmeabS86W3Y9JUcnuMuq5bwk6dr+E9C+1WM6ndWeqO/4h+bTfV+4WvhVBi
	 RkRliFoGzQ4yCvXpf0bitx1Cc2rr1HoULPC9tc14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Nicolas Dufresne <nicolas.dufresne@collabora.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0449/1257] media: chips-media: wave5: Balance runtime PM on encoder close errors
Date: Sat,  7 Nov 2026 08:45:45 -0500
Message-ID: <20261107134951.879241409@linuxfoundation.org>
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

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit 4009daa5d9a72a67dd497bb4546632b2506a3650 ]

wave5_vpu_enc_close() resumes the device before taking the hardware lock.
Its three error paths call pm_runtime_resume_and_get() again instead of
dropping that reference.  Each failure therefore increments the runtime PM
usage count twice and can prevent the device from suspending afterward.

Replace the extra resume calls with pm_runtime_put_sync() to balance the
reference acquired on entry, matching the successful close path.  This
aligns wave5_vpu_enc_close() with wave5_vpu_dec_close(), which already
releases the reference on its error paths.

Fixes: 2092b3833487 ("media: chips-media: wave5: Support runtime suspend/resume")
Cc: stable@vger.kernel.org
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Reviewed-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Nicolas Dufresne <nicolas.dufresne@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../platform/chips-media/wave5/wave5-vpuapi.c     | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/media/platform/chips-media/wave5/wave5-vpuapi.c b/drivers/media/platform/chips-media/wave5/wave5-vpuapi.c
index f77abd5e122a2..4c1842f02c883 100644
--- a/drivers/media/platform/chips-media/wave5/wave5-vpuapi.c
+++ b/drivers/media/platform/chips-media/wave5/wave5-vpuapi.c
@@ -754,7 +754,7 @@ int wave5_vpu_enc_close(struct vpu_instance *inst, u32 *fail_res)
 
 	ret = mutex_lock_interruptible(&vpu_dev->hw_lock);
 	if (ret) {
-		pm_runtime_resume_and_get(inst->dev->dev);
+		pm_runtime_put_sync(inst->dev->dev);
 		return ret;
 	}
 
@@ -762,16 +762,13 @@ int wave5_vpu_enc_close(struct vpu_instance *inst, u32 *fail_res)
 		ret = wave5_vpu_enc_finish_seq(inst, fail_res);
 		if (ret < 0 && *fail_res != WAVE5_SYSERR_VPU_STILL_RUNNING) {
 			dev_warn(inst->dev->dev, "enc_finish_seq timed out\n");
-			pm_runtime_resume_and_get(inst->dev->dev);
-			mutex_unlock(&vpu_dev->hw_lock);
-			return ret;
+			goto unlock_and_return;
 		}
 
 		if (*fail_res == WAVE5_SYSERR_VPU_STILL_RUNNING &&
 		    retry++ >= MAX_FIRMWARE_CALL_RETRY) {
-			pm_runtime_resume_and_get(inst->dev->dev);
-			mutex_unlock(&vpu_dev->hw_lock);
-			return -ETIMEDOUT;
+			ret = -ETIMEDOUT;
+			goto unlock_and_return;
 		}
 	} while (ret != 0);
 
@@ -787,10 +784,12 @@ int wave5_vpu_enc_close(struct vpu_instance *inst, u32 *fail_res)
 	}
 
 	wave5_vdi_free_dma_memory(vpu_dev, &p_enc_info->vb_task);
+
+unlock_and_return:
 	mutex_unlock(&vpu_dev->hw_lock);
 	pm_runtime_put_sync(inst->dev->dev);
 
-	return 0;
+	return ret;
 }
 
 int wave5_vpu_enc_register_frame_buffer(struct vpu_instance *inst, unsigned int num,
-- 
2.53.0



