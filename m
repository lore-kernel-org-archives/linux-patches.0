Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062943;
	b=VjVj1oK4RU9xqi+SbQfODz+rD75fTdYzny2qrt8FpMd43TNclyRf9roxfZ8564jFJI6H
	 UEqmf+Leq6OfQbVMKLyexl7wkLGthXjRqC3Im2ef64/u1DUqkrgkzz+vFFe96MMuicZ/Y
	 +bMnzJZhh3ul0NVuHgEVXMg2ew25KXJzQdXsda7DJyo6G3z8aZzdWBtczPRBLxEa8svp1
	 jM0CbNfV4Nai40xrmk/jiB3WAlr9Fsr2GNy9ByU/ywqWRYCaCIEuWhKigcchSRRvdRNSu
	 itTcr4kk5fjrwjUoyQ1WU0ITZT5Wzsg7dYtMjq15RYtI1aGZrYQhienD6awhPj0OECw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062943;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Lo8uZVLGLtyxZLrX225UsHdS3nPHnrvP1rF1awii4Jk=;
	b=ozG9SpXsevEIgYzUFo6SkSpqBaxOYpylTYfpqAhsSAsbWSWxy2LnGDykoQKKGiJowsX+
	 Hh3fg/JQZwx+jXJ46TtnGCKxa1PH/nA8Vo7yhKWGUfljUysNS+80OZdjoTQZ0xqAx6Ujn
	 URrm93ag93nPviW7bmffujgPEnQqleB2NtUNe3ikb0tb0YnNWpCnJoKb/H9qZqnsbSjNN
	 SuPHv74Rwh13qp9qUH+LiYfAkab/qAkF+ci+RH9gXOqucqO/QGr5uO3wYo+452ZK/VEdP
	 jFMNrn1opKllDXBu0WCKVpgS0Ren3evWsd5SjnrlIrQxvMXj282/V3r0mJifg/dqxVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="d/hUKeO5";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6495606A33E;
	Sat,  7 Nov 2026 14:49:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=d/hUKeO5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D04A1F0089F;
	Sat,  7 Nov 2026 14:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062942;
	bh=Lo8uZVLGLtyxZLrX225UsHdS3nPHnrvP1rF1awii4Jk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d/hUKeO5xKNzPnLMyXOmZoYs+3SzuJqxFdKKFXWPDK/DJwadOL00HZxTOC8Cgf1AF
	 GTzTManYIpnDWQxO3p+wK9MWbh4gOdMvAa+IbMDHbOF5aUgEG4yQ5EDsXfGzFZo3bd
	 wyj73ImAm4VbEkQFiFsijKdGT801iOIdlcZvv54k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cf896de36144391bcde1@syzkaller.appspotmail.com,
	Hans Verkuil <hverkuil@kernel.org>,
	Rohinthan P <rokinthanp03@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 209/869] media: v4l2-ctrls: do nothing if controls[0] == NULL in cluster functions
Date: Sat,  7 Nov 2026 08:48:11 -0500
Message-ID: <20261107134859.060229637@linuxfoundation.org>
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
index 02e2ae93d1764..579787f0be351 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls-core.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-core.c
@@ -2431,7 +2431,10 @@ void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls)
 	int i;
 
 	/* The first control is the master control and it must not be NULL */
-	if (WARN_ON(ncontrols == 0 || controls[0] == NULL))
+	if (WARN_ON(ncontrols == 0))
+		return;
+
+	if (!controls[0])
 		return;
 
 	for (i = 0; i < ncontrols; i++) {
@@ -2453,8 +2456,13 @@ void v4l2_ctrl_auto_cluster(unsigned ncontrols, struct v4l2_ctrl **controls,
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
index 31fc1bee3797b..b900734ee9c1c 100644
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



