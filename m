Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036042;
	b=RIp/bN+1xW/ImbKDqYgwenxICASpQpMi98JmHGi2fo8W0zKUKVGWOdYrsJshT3VRIU1Z
	 4pc3yaqUwNlZ/0L+T4qVGEKyZ2aXzAohy4mBsgFnn6hxGlKOh5U9PYwIoZ4hwaZY/zE50
	 Cripu7i3BKmQY51Xt81tccXXVTpvTZ4qGxlQ1QHirwAvMybxo7cS77vvFYaRFfvVLymuD
	 1pBBxE/EAyaQdH07ZYcTWGJwb3+4hhgrmD6C7yqu7J+di1Mdf66wOvzpKgxCVkzGVFXqo
	 THJ9j3sk/nh+khZ2cyir/A3Zs6aR4xVofSpcc/ij9aiSkFmafm6j3Czo82M7hAIVIbA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036042;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=fkamENbKD3acQCj6GSRN78X2hFkgwb+ZqCr5QjG3Go8=;
	b=wsm/hW4EYAtx2L8JB0ryrvA6F07Y9RrUir0a+gb5IbhphmqGetxjiucj0LOvlzUAu5JJ
	 NCXyr+mZgWWf7XSmG2Lp3hN1+QqFpvVgKD2OUNC3jimPlKsJXZsoOjYXfgnzLG/FZ+gwV
	 uUO6UGUTKBbp2jXTWyqnlrG+ucOTlNg9P4wuJvGGH4K8DxStJRgLCObw9nzmcWdGzsDQr
	 eiRzNGEQH+d2vI/GSUpnfeUWOTcnIE2w+gGhfC3gjvYQCMjq7a324/jNBmJqhkDaP5gTs
	 sVP/OhGEoJE8WoQP1JWZuVDtTSR6dvzvjdaEj2RJcCCVRhZTMqW6oFAkbixhxhR67aw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="CkPn/W+v";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E3C606A31C;
	Wed, 18 Nov 2026 21:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CkPn/W+v
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4DFC1F000C4;
	Wed, 18 Nov 2026 21:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036042;
	bh=fkamENbKD3acQCj6GSRN78X2hFkgwb+ZqCr5QjG3Go8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CkPn/W+vCSWWsjqf+Fe8kHRhJjKdwZ1G2Zd05wYpIoPpvsfIu8KPOCldfmHgrSQvY
	 yhc04LPmx3xLTpUh+enkQ9wkew4yE7/s/fhXnat7TVfgozO2I5pTAOWTV8ZpIQ8wCV
	 CzWihqkNE0NDrm65Nk2s2Wxhwfa3gioOwl01Zx3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cf896de36144391bcde1@syzkaller.appspotmail.com,
	Hans Verkuil <hverkuil@kernel.org>,
	Rohinthan P <rokinthanp03@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0916/3318] media: v4l2-ctrls: do nothing if controls[0] == NULL in cluster functions
Date: Wed, 18 Nov 2026 15:25:38 +0100
Message-ID: <20261118150347.002105555@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rohinthan P <rokinthanp03@gmail.com>

[ Upstream commit 9ff738f93084351ed6e818d4d58679a9e9083a8d ]

The V4L2 control framework is designed to allow drivers to instantiate
controls and clusters without checking for errors after each call,
checking hdl->error only once at the end.

However, if allocating the master control (controls[0]) fails, e.g. due to
memory allocation failure, v4l2_ctrl_cluster() triggers a WARNING:

      ncontrols == 0 || controls[0] == NULL
      WARNING: drivers/media/v4l2-core/v4l2-ctrls-core.c:2525 at v4l2_ctrl_cluster

Additionally, v4l2_ctrl_auto_cluster() attempts to dereference
master->minimum without checking if controls[0] is NULL, leading to a
NULL pointer dereference when master control creation fails.

Update both v4l2_ctrl_cluster() and v4l2_ctrl_auto_cluster() to silently
return if controls[0] is NULL, preserving the design that control
creation errors are caught at the end when the driver checks hdl->error.
Also update function documentation in include/media/v4l2-ctrls.h.

Fixes: 71c689dc2e73 ("media: v4l2-ctrls: split up into four source files")
Cc: stable@vger.kernel.org
Reported-by: syzbot+cf896de36144391bcde1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=cf896de36144391bcde1
Suggested-by: Hans Verkuil <hverkuil@kernel.org>
Signed-off-by: Rohinthan P <rokinthanp03@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[hverkuil: simplified the v4l2_ctrl_auto_cluster code a bit]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-ctrls-core.c | 12 ++++++++++--
 include/media/v4l2-ctrls.h                |  6 ++++++
 2 files changed, 16 insertions(+), 2 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-ctrls-core.c b/drivers/media/v4l2-core/v4l2-ctrls-core.c
index cef8903ef15f3..de8f10d32c327 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls-core.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-core.c
@@ -2303,7 +2303,10 @@ void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls)
 	int i;
 
 	/* The first control is the master control and it must not be NULL */
-	if (WARN_ON(ncontrols == 0 || controls[0] == NULL))
+	if (WARN_ON(ncontrols == 0))
+		return;
+
+	if (!controls[0])
 		return;
 
 	for (i = 0; i < ncontrols; i++) {
@@ -2325,8 +2328,13 @@ void v4l2_ctrl_auto_cluster(unsigned ncontrols, struct v4l2_ctrl **controls,
 	u32 flag = 0;
 	int i;
 
+	if (WARN_ON(ncontrols <= 1))
+		return;
+
+	if (!master)
+		return;
+
 	v4l2_ctrl_cluster(ncontrols, controls);
-	WARN_ON(ncontrols <= 1);
 	WARN_ON(manual_val < master->minimum || manual_val > master->maximum);
 	WARN_ON(set_volatile && !has_op(master, g_volatile_ctrl));
 	master->is_auto = true;
diff --git a/include/media/v4l2-ctrls.h b/include/media/v4l2-ctrls.h
index 59679a42b3e7f..8a926784b2cf3 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -804,6 +804,9 @@ bool v4l2_ctrl_radio_filter(const struct v4l2_ctrl *ctrl);
  *
  * @ncontrols:	The number of controls in this cluster.
  * @controls:	The cluster control array of size @ncontrols.
+ *
+ *		If controls[0] is NULL, then this function does nothing and just
+ *		returns.
  */
 void v4l2_ctrl_cluster(unsigned int ncontrols, struct v4l2_ctrl **controls);
 
@@ -815,6 +818,9 @@ void v4l2_ctrl_cluster(unsigned int ncontrols, struct v4l2_ctrl **controls);
  * @ncontrols:	The number of controls in this cluster.
  * @controls:	The cluster control array of size @ncontrols. The first control
  *		must be the 'auto' control (e.g. autogain, autoexposure, etc.)
+ *
+ *		If controls[0] is NULL, then this function does nothing and just
+ *		returns.
  * @manual_val: The value for the first control in the cluster that equals the
  *		manual setting.
  * @set_volatile: If true, then all controls except the first auto control will
-- 
2.53.0



