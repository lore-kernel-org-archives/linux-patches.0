Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064098;
	b=w7XYzFt6luQv3FaLjHIg9sh8BzYIWycryEIZziXsd+ignqh/NKRw1LABmfCsqaA8Oha0
	 8/zmo3j4u3et5ZbjpEVPO+BiqIN7z0aELQ0acxCuy00omDdawjgtj+CzPdxKXiJhwaa9X
	 bqamf7gLjs+s0/+rm1Gr2cqfTA4esJEqi5oqNmgX1wsoREzEc+7fHtvk/EntUcLBthiq7
	 v06RNZ8qROzsHnaVn4qfNooEdxrnknNbBiehjw4Az1Zd2657uZlNypotZdrKb2Z8lTDbM
	 jMOdcHQr0ocTvXZ242jCG/rx3JPWdLIuiViAKSo8MfN/XuVD3eX/1aWW8dv1JW4q/cA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064098;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=gXWhjen83rlY5a3iLDNcR0DSgtGTlpu3HMc0i3NOIh8=;
	b=1qw45UPYvh/T9ueEtN0Z9hFtUUIc4y0VKT5wV8oU8PVVgfaANAO+K/VYmOmS17la9ieF
	 4FnO2i/M9UYcFW2eddAx6+OoZ4+1SGaJA8oZ46omIEThygNGOyyMJWwjpC2osAOXdbAbt
	 6gu6TVyZkkyECmZYvDqRvBJtsfEe4sezNpzlSVM4CS3ixWc82ubsbWwwbOiK40XJPKfcX
	 BQ8t8tBGJlcoqtj7HQ1Fy1kaTpCA8HvInZCuBB7uo54UpjPBwRoC4qCucLuNPAzp1rXUo
	 OEjeKM8NQs8XU9vKukc30oH4ylY5cyMsRVLWTh5ES8cNDgdIIAsFgN8RCmVfFoQuOdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S1AYTdWk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E80C606CE56;
	Sat,  7 Nov 2026 15:08:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=S1AYTdWk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 987211F0089F;
	Sat,  7 Nov 2026 15:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064097;
	bh=gXWhjen83rlY5a3iLDNcR0DSgtGTlpu3HMc0i3NOIh8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=S1AYTdWkTBNxXzc9X/UtvoTblqESqdgBXDGPP88+C9N0ekfmgq00uy0357WOrZdh+
	 ZR58x2ikyOfUgEoH7oQCx05JsctDCQSLKClvPTM47CNWVd9pmczmClogf+SkVhxsNT
	 Z+JYlhRBg03rx5bcAEiXZbFEV/uXRW+PcmIm1fg4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cf896de36144391bcde1@syzkaller.appspotmail.com,
	Hans Verkuil <hverkuil@kernel.org>,
	Rohinthan P <rokinthanp03@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0259/1257] media: v4l2-ctrls: do nothing if controls[0] == NULL in cluster functions
Date: Sat,  7 Nov 2026 08:42:35 -0500
Message-ID: <20261107134946.655037378@linuxfoundation.org>
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
index 47fb60b1f0c07..6e751a043a210 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls-core.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-core.c
@@ -2561,7 +2561,10 @@ void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls)
 	int i;
 
 	/* The first control is the master control and it must not be NULL */
-	if (WARN_ON(ncontrols == 0 || controls[0] == NULL))
+	if (WARN_ON(ncontrols == 0))
+		return;
+
+	if (!controls[0])
 		return;
 
 	for (i = 0; i < ncontrols; i++) {
@@ -2583,8 +2586,13 @@ void v4l2_ctrl_auto_cluster(unsigned ncontrols, struct v4l2_ctrl **controls,
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
index 327976b14d50b..cec9217d97ac6 100644
--- a/include/media/v4l2-ctrls.h
+++ b/include/media/v4l2-ctrls.h
@@ -834,6 +834,9 @@ bool v4l2_ctrl_radio_filter(const struct v4l2_ctrl *ctrl);
  *
  * @ncontrols:	The number of controls in this cluster.
  * @controls:	The cluster control array of size @ncontrols.
+ *
+ *		If controls[0] is NULL, then this function does nothing and just
+ *		returns.
  */
 void v4l2_ctrl_cluster(unsigned int ncontrols, struct v4l2_ctrl **controls);
 
@@ -845,6 +848,9 @@ void v4l2_ctrl_cluster(unsigned int ncontrols, struct v4l2_ctrl **controls);
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



