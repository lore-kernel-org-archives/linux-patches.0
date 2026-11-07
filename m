Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062060;
	b=YWCROnAqkO5kYm3Nbz3vxFicPz3fHoB+IY7yMKNOaHphQvdR9W7o5MCVbYGLZqLL5pcR
	 u3MxID8QgU9fKF4edXxD1rQGHtiqCY4k6Omy8YOgzaR7HnC6tWpxHNLh25FQwrSrjp9Ow
	 UTKJKeIeavIYkEaW7a3iUzkAWVGh6AOSTZfvEVE1u5qfl8lKPvofggRaEPe0iBpU0v6JG
	 jvbCDUptMn3krpU1Zpj8Ro2hTesrA0nfb/HD7MQQ3q15buyERwfF93MP/Sl88pUymMTQl
	 ByRZfvQUF02XUIr50xAkqKfKa1mGBwCzUmC38lUnk7rTfBqrIKnuyp9fkNNU2K4Kp6A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OFfmSZJabohR0AUrQnjK7Ral75u1nr0SHfrKjP24X4E=;
	b=CpbFcBAVeo1pSAvGdpHrUjna63RtTE6nS24QFj6wz7z13ZJkIF6JthZkjFM8ErmnLwRH
	 OBn/v/OJw6R427BsCUdAdHMHbnWKRtF1YldcfjqYluwkc6kk9NVVd8bktcGk4kafekji0
	 n8RG++UJRiNpkqwIkPNLhB3o1ryIlr/E4OE6oCRxFgeDgLdye2IEVXEbZ0B8VRvEaA0ZK
	 888ddR5qam3EOuHbVZpXLWRtWfu7p/vgKOrlZQEWUmycpFMI4Ct57AY9WeGQ64boI/WCd
	 +LxeFzTwXAo20QTVIQ78KRUa1eP2p+be4XyuVopZYh7yNetblipq4Q/qaDKx8sogbXw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KDgnwg8C;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F5B2606D801;
	Sat,  7 Nov 2026 14:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KDgnwg8C
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C5F41F0089F;
	Sat,  7 Nov 2026 14:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062060;
	bh=OFfmSZJabohR0AUrQnjK7Ral75u1nr0SHfrKjP24X4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KDgnwg8C4JPw2hottI7dzAEhQFeRiSlONz4ShJmeXiTorDkvMz2RbhhQk8XbxMSqK
	 i4PZJXKZQytoiXQNbrBcmil/Djr6CUeSIiXQ5mLTsIpk50PEREZttJNywPOGjBmmmv
	 ItmgeKmL9xYJLM1VYuYd6lC2SyDPqM84yhSCcPnA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+cf896de36144391bcde1@syzkaller.appspotmail.com,
	Hans Verkuil <hverkuil@kernel.org>,
	Rohinthan P <rokinthanp03@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1041/1536] media: v4l2-ctrls: do nothing if controls[0] == NULL in cluster functions
Date: Sat,  7 Nov 2026 08:50:57 -0500
Message-ID: <20261107135026.912323194@linuxfoundation.org>
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
index f3548a82c8e88..fc656c265e110 100644
--- a/drivers/media/v4l2-core/v4l2-ctrls-core.c
+++ b/drivers/media/v4l2-core/v4l2-ctrls-core.c
@@ -2307,7 +2307,10 @@ void v4l2_ctrl_cluster(unsigned ncontrols, struct v4l2_ctrl **controls)
 	int i;
 
 	/* The first control is the master control and it must not be NULL */
-	if (WARN_ON(ncontrols == 0 || controls[0] == NULL))
+	if (WARN_ON(ncontrols == 0))
+		return;
+
+	if (!controls[0])
 		return;
 
 	for (i = 0; i < ncontrols; i++) {
@@ -2329,8 +2332,13 @@ void v4l2_ctrl_auto_cluster(unsigned ncontrols, struct v4l2_ctrl **controls,
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



