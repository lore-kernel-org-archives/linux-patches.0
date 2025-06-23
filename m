Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C572913A265;
	Mon, 23 Jun 2025 13:16:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684578; cv=none; b=P5gBwzuBcIWWwva0OeQzFGVNdfV3h/l4ThvH1ouYB9dC3y919xeit3mEb+gYuI1YJfS7hkyXMQF1trfwjIq9nej5WWaIef8HLG2sCuurM7PZrX7IQlGrrWzdNKRDqTpbcwFsvReS9qXgMRyLhanDBtQJOfmtIBC5p1BOAGpYLRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684578; c=relaxed/simple;
	bh=/JTYK5UJxj31p2tY2q5Rjpqcf1C7ObzH81rmANDAGPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0eDTrLGmoIlm4qGuZh4TzdR1Y0yrN17CHLvlYs4DpdklcMqxw3bE+zgeaTHe/4Gffy8g+kPhe1zTHEEQmsclHmy9WesZR+V1MrUdWIWupiCC8oPUaIbWRHGO1hwhV0vGeUnMUE+JDE+RsgZXD1wzBfd3SWRVVF1v6q3JlTPrT8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jRqiwQmT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jRqiwQmT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD495C4CEEA;
	Mon, 23 Jun 2025 13:16:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684578;
	bh=/JTYK5UJxj31p2tY2q5Rjpqcf1C7ObzH81rmANDAGPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jRqiwQmTBEYC9MKkBhBLzCgS9blFrZeyYQfsQtqyryy9pQZUnOuDtXWwM70k1eSYE
	 bH/qUtSM+ODa8ihH2tF0pQ/JicIW1LRCcu3CYQc59mvx6BW3/XUvUBg/A/ggsrDGyS
	 iJJ5Yg4GZShJl3C4x0ul1OT4zzuv7pNF6PznGb8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Depeng Shao <quic_depengs@quicinc.com>,
	Bryan ODonoghue <bryan.odonoghue@linaro.org>,
	Johan Hovold <johan+linaro@kernel.org>,
	Bryan ODonoghue <bod@kernel.org>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.15 078/592] media: qcom: camss: vfe: suppress VFE version log spam
Date: Mon, 23 Jun 2025 15:00:36 +0200
Message-ID: <20250623130702.127721360@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan+linaro@kernel.org>

commit b6fafb3941fa0f065def304d44d6c3c6d6ac0f64 upstream.

A recent commit refactored the printing of the VFE hardware version, but
(without it being mentioned) also changed the log level from debug to
info.

This results in several hundred lines of repeated log spam during boot
and use, for example, on the Lenovo ThinkPad X13s:

	qcom-camss ac5a000.camss: VFE:1 HW Version = 1.2.2
	qcom-camss ac5a000.camss: VFE:0 HW Version = 1.2.2
	qcom-camss ac5a000.camss: VFE:2 HW Version = 1.2.2
	qcom-camss ac5a000.camss: VFE:2 HW Version = 1.2.2
	qcom-camss ac5a000.camss: VFE:3 HW Version = 1.2.2
	qcom-camss ac5a000.camss: VFE:5 HW Version = 1.3.0
	qcom-camss ac5a000.camss: VFE:6 HW Version = 1.3.0
	qcom-camss ac5a000.camss: VFE:4 HW Version = 1.3.0
	qcom-camss ac5a000.camss: VFE:5 HW Version = 1.3.0
	qcom-camss ac5a000.camss: VFE:6 HW Version = 1.3.0
	qcom-camss ac5a000.camss: VFE:7 HW Version = 1.3.0
	qcom-camss ac5a000.camss: VFE:7 HW Version = 1.3.0
	qcom-camss ac5a000.camss: VFE:7 HW Version = 1.3.0
	...

Suppress the version logging by demoting to debug level again.

Fixes: 10693fed125d ("media: qcom: camss: vfe: Move common code into vfe core")
Cc: stable@vger.kernel.org
Cc: Depeng Shao <quic_depengs@quicinc.com>
Reviewed-by: Bryan O'Donoghue <bryan.odonoghue@linaro.org>
Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
Signed-off-by: Bryan O'Donoghue <bod@kernel.org>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/platform/qcom/camss/camss-vfe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/platform/qcom/camss/camss-vfe.c b/drivers/media/platform/qcom/camss/camss-vfe.c
index cf0e8f5c004a..91bc0cb7781e 100644
--- a/drivers/media/platform/qcom/camss/camss-vfe.c
+++ b/drivers/media/platform/qcom/camss/camss-vfe.c
@@ -428,8 +428,8 @@ u32 vfe_hw_version(struct vfe_device *vfe)
 	u32 rev = (hw_version >> HW_VERSION_REVISION) & 0xFFF;
 	u32 step = (hw_version >> HW_VERSION_STEPPING) & 0xFFFF;
 
-	dev_info(vfe->camss->dev, "VFE:%d HW Version = %u.%u.%u\n",
-		 vfe->id, gen, rev, step);
+	dev_dbg(vfe->camss->dev, "VFE:%d HW Version = %u.%u.%u\n",
+		vfe->id, gen, rev, step);
 
 	return hw_version;
 }
-- 
2.50.0



