Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793829498;
	b=qmBlWEfEIROY/MWH1oWnwR0nCpJCWr+i+T5dOewJIlxY8kfQ8VrXC9zs0S8JPeXMMMg9
	 26uH7sxbWcGX+bFe5ephJk/au8j4SwZ25Kncj07rgPShBOJMc7UFueWV/W2Hb5ZrcTlrS
	 1akh8J+qkPZmC1GCbJtDTXfPCgYG+UtZUIHY//5O5LbVvAAd+2Ldvp4tqFqiZ33PYSOrD
	 iTaQkpHT06BWUBMin32EfM4Q60E1KOicfNNHWPp6qickDWsIZdO7jDTiNnHfOf1FaK4lW
	 Wvj0wSqcmc0ZBwU10gxm5cIJom5pNci8hrarZZzGhiLj3RzxFvIDjBVAeqVWvLuQcTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793829498;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8zOD1u3pHnNDLfFQfsiOROgWc2gIXY11DoKxJVmliHY=;
	b=AVktVf3rrcYJ3HA+OxREo/QEAycuNKcQ507lrFRTMwqx5miqdJtcaGD9vSRzM+7TBQi9
	 bMHabb3TeRgPOv7vsXd9WI6hfbYkaJMTVaeKaRtKR/gustseuYjFx3zBLbRkEIN9xjUmA
	 T/okBKWgwFJij1Awc8C7N4thKwDVbPEfg4Dpl9ynv3pO4Ug00E5vhBAVDFu3DIlun9kVu
	 XtpCXAoz0bedlwd6YBqI79eT1O6tZv85k2IUh2eyyVWDkQR55CEzRGQfe5O3IjE6Hemco
	 1m++e9P4LNOAqolZAfrvutLEsoD6eUXWDxl8WpAdATJezX4MH1/bskN2kpnG/UzJXsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oIWvy4eK;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF1B606A844;
	Wed,  4 Nov 2026 21:58:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=oIWvy4eK
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EDA61F0093A;
	Wed,  4 Nov 2026 21:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793829498;
	bh=8zOD1u3pHnNDLfFQfsiOROgWc2gIXY11DoKxJVmliHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oIWvy4eKa0SOL5SVfSWne+MIoGYqxK8YpB4vU2Mb0zXnzhIPJVgvK/NpAZTs30z0y
	 iPKZXa8IKkqdTv8kOFuu8KjMrPfVNE6ciKpLegcrhc2djrrCjhBP0gA1j6E3qTo+fR
	 fEs+usn9Xrjwec2FPP358BBxdx4Dzs2Ju+ZX8Bd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Tipton <mike.tipton@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0136/1005] pmdomain: qcom: rpmhpd: Skip retention by default
Date: Wed,  4 Nov 2026 15:57:49 -0500
Message-ID: <20261104211047.507623643@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

From: Mike Tipton <mike.tipton@oss.qualcomm.com>

[ Upstream commit 7178817f190496f2bfdec181fb4aa72832448468 ]

Retention is very rarely an operational corner. In the majority of
cases, HW cannot operate properly at Retention levels and so the minimum
operational level when enabling a rail is the first corner above
Retention. A small subset of always-on use cases can operate at
Retention, but those aren't controlled from HLOS.

Currently, we allow Retention by default and only disallow it special
cases. But this leaves us open to various failures when the PD is
enabled without first being voted to an OPP above Retention. Such as
when a child GDSC PD requests to enable its parent RPMh PD. In this
case, the GDSC would get stuck powering on.

Newer chips have started supporting Retention on rails that didn't
previously (such as for MMCX). Instead of adding more special cases to
skip Retention on MMCX, start skipping Retention by default since it's
almost never desired from an HLOS perspective.

Signed-off-by: Mike Tipton <mike.tipton@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pmdomain/qcom/rpmhpd.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/pmdomain/qcom/rpmhpd.c b/drivers/pmdomain/qcom/rpmhpd.c
index 4c3cbf3abc750..fc61ec45755c3 100644
--- a/drivers/pmdomain/qcom/rpmhpd.c
+++ b/drivers/pmdomain/qcom/rpmhpd.c
@@ -41,7 +41,6 @@
  * @addr:		Resource address as looped up using resource name from
  *			cmd-db
  * @state_synced:	Indicator that sync_state has been invoked for the rpmhpd resource
- * @skip_retention_level: Indicate that retention level should not be used for the power domain
  */
 struct rpmhpd {
 	struct device	*dev;
@@ -58,7 +57,6 @@ struct rpmhpd {
 	const char	*res_name;
 	u32		addr;
 	bool		state_synced;
-	bool            skip_retention_level;
 };
 
 struct rpmhpd_desc {
@@ -176,7 +174,6 @@ static struct rpmhpd mxc = {
 	.pd = { .name = "mxc", },
 	.peer = &mxc_ao,
 	.res_name = "mxc.lvl",
-	.skip_retention_level = true,
 };
 
 static struct rpmhpd mxc_ao = {
@@ -184,7 +181,6 @@ static struct rpmhpd mxc_ao = {
 	.active_only = true,
 	.peer = &mxc,
 	.res_name = "mxc.lvl",
-	.skip_retention_level = true,
 };
 
 static struct rpmhpd nsp = {
@@ -974,7 +970,15 @@ static int rpmhpd_update_level_mapping(struct rpmhpd *rpmhpd)
 		return -EINVAL;
 
 	for (i = 0; i < rpmhpd->level_count; i++) {
-		if (rpmhpd->skip_retention_level && buf[i] == RPMH_REGULATOR_LEVEL_RETENTION)
+		/*
+		 * Most HW won't function properly at Retention. The minimum
+		 * operational level is the first level above Retention. The
+		 * small subset of HW that can operate at Retention isn't
+		 * controlled by HLOS. Skip the Retention level to avoid HW
+		 * failures when the PD is enabled without first having an
+		 * explicit OPP level set.
+		 */
+		if (buf[i] == RPMH_REGULATOR_LEVEL_RETENTION)
 			continue;
 
 		rpmhpd->level[i] = buf[i];
-- 
2.53.0



