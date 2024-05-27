Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FE0717E90E;
	Mon, 27 May 2024 19:11:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837112; cv=none; b=u0IzUVqFvuX5KW4fPVfL2FSmg5VRC498K53Vo9R04YWBNJ3HwnxjcNH8XSpbowGGqpu9b/qqBYwxM+Yr8ZTeHGquizN+uu+PJQ9liT6YV4iNNt3h9Xto5meGq2+3E+CF9jg4hUEh/NJMdGwF5ZBE8SBX6SGiZEWlvGFik5lZT/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837112; c=relaxed/simple;
	bh=+fmCdDRRtwi2OVWXN5GNtva2gAZ9s8gsrB1j/GIzkg4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DFweLaT/YPrqMEUDvkLgKAzA5jSMP4AI9ZNuInICHiQNsrGz0VrAUOP+AjSfm6hnq3WQ7LCdjg+Sox+nLikhALduiLolG0ZZQiQw0Lm7B8YVv9zoag9c4LiM9Z7wJD8Ca12suoOGRDPQIYsuQE6JWKUZvR1u7PJoumSi/k9R0Go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JjnnxzLC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JjnnxzLC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6F07C2BBFC;
	Mon, 27 May 2024 19:11:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837112;
	bh=+fmCdDRRtwi2OVWXN5GNtva2gAZ9s8gsrB1j/GIzkg4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JjnnxzLCCSb6WCJe9bnrNBD5PfYa+b0b/Vl/0ZHiViveXTdrObwKTTYS13T9azDAr
	 /K9OVDtP9GeD66UuD51JecY6JzAXj43kisCsbF4oMB3chEeh6LocNymMglJvBASH1d
	 6St0PZvVH4njRdxSZVi1bDRQN608Gl4UDClkdG04=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Changhuang Liang <changhuang.liang@starfivetech.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 313/427] staging: media: starfive: Remove links when unregistering devices
Date: Mon, 27 May 2024 20:56:00 +0200
Message-ID: <20240527185631.074146698@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185601.713589927@linuxfoundation.org>
References: <20240527185601.713589927@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Changhuang Liang <changhuang.liang@starfivetech.com>

[ Upstream commit 810dd605e917c716f6f83e6cd8ea23d9155d32a2 ]

Need to remove links when unregistering devices.

Fixes: ac7da4a73b10 ("media: staging: media: starfive: camss: Register devices")

Signed-off-by: Changhuang Liang <changhuang.liang@starfivetech.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/media/starfive/camss/stf-camss.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/staging/media/starfive/camss/stf-camss.c b/drivers/staging/media/starfive/camss/stf-camss.c
index a587f860101ae..323aa70fdeaf1 100644
--- a/drivers/staging/media/starfive/camss/stf-camss.c
+++ b/drivers/staging/media/starfive/camss/stf-camss.c
@@ -162,6 +162,12 @@ static int stfcamss_register_devs(struct stfcamss *stfcamss)
 
 static void stfcamss_unregister_devs(struct stfcamss *stfcamss)
 {
+	struct stf_capture *cap_yuv = &stfcamss->captures[STF_CAPTURE_YUV];
+	struct stf_isp_dev *isp_dev = &stfcamss->isp_dev;
+
+	media_entity_remove_links(&isp_dev->subdev.entity);
+	media_entity_remove_links(&cap_yuv->video.vdev.entity);
+
 	stf_isp_unregister(&stfcamss->isp_dev);
 	stf_capture_unregister(stfcamss);
 }
-- 
2.43.0



