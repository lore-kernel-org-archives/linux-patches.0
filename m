Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033669;
	b=ZKKYI7zU+H4ST47zZ+gy1zB8hG7BFS+YoQZKqUjfOlbrqIqP/hMEnompGYp9l3vRh4Ir
	 cfw+I0gyBgy9QFvzf6l6h5B4IoFx6vYZNJZc7MzbPmqom2Y+Z++Qd4PUdUrEgwJqqn3cn
	 tw/vFtYpn5BbdKikPGJFg74LGeim4N54Om5kY4k40/nrIFfNoD21T2qUbbpzayBu85tWS
	 yAD0SnaRvFnIfN6tCsAzW1A/x65AVftlRn2ROMxrH70g/1SCt8dyUqzIgT1fIxGPWR+FI
	 /CIj/S5LCgEtwsuKuYPlNWXeoXL8Zb9hrOX0tFJlDFDvY1y9nHwmsBS+n37bVzqGjtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033669;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ihZVRQUClZbjIr+DGs0/qyoQWvLwbGLf/UHndXZB2Gc=;
	b=tSiuw0eSu+KINkiyKIqaej66SdXqQFOoI28ibemkeYF5M//zJac7ONkOMYM75l7gOCoi
	 MzT6ONaB3kC8xvC3RMtriFqiUSwm970PaHe1BhlGz54pUnlJ/qsHuurIlvMJyaGt22ImH
	 SEcxJoln/WkZyAhkPtfuht0sBct4vD+mCShp6TLOBXXx18SGtm+kHkkeagWQKNMe5Zns/
	 Uybe7PWFvMqpsXJPmeKh7s7P53hXEmsuSxll/BHnLuge9EkAcd1ExOfXOhJj7pG3ehH9j
	 jnyom9IEhLOHN3yM7qu39BXMHKe85uXIR/FxfsRhF8PafDC0UTJ1nyHZLCLVLK5OahA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WYr1rC4j;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 986EF606A320;
	Wed, 18 Nov 2026 20:27:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WYr1rC4j
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87641F000C4;
	Wed, 18 Nov 2026 20:27:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033669;
	bh=ihZVRQUClZbjIr+DGs0/qyoQWvLwbGLf/UHndXZB2Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WYr1rC4jqFJ6xd558jTeC8OZzRtkQ4LLXeR2Sc/mEjk58KDyE7QzmtDdMfJmdlVqY
	 FsG1HJ4lN4MaoC2p/gYesLbnqXsDkTkYHYD7koej3Kn0ct9QrGm9QHNUgPd6Un74kJ
	 3/PdlIxelnWZq13DfPbDjORZ6XzqeYujrJFgGZBI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Tipton <mike.tipton@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0097/3318] pmdomain: qcom: rpmhpd: Skip retention by default
Date: Wed, 18 Nov 2026 15:11:59 +0100
Message-ID: <20261118150317.104842133@linuxfoundation.org>
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
index 823604952b5ec..78f0ac5bb0019 100644
--- a/drivers/pmdomain/qcom/rpmhpd.c
+++ b/drivers/pmdomain/qcom/rpmhpd.c
@@ -40,7 +40,6 @@
  * @addr:		Resource address as looped up using resource name from
  *			cmd-db
  * @state_synced:	Indicator that sync_state has been invoked for the rpmhpd resource
- * @skip_retention_level: Indicate that retention level should not be used for the power domain
  */
 struct rpmhpd {
 	struct device	*dev;
@@ -57,7 +56,6 @@ struct rpmhpd {
 	const char	*res_name;
 	u32		addr;
 	bool		state_synced;
-	bool            skip_retention_level;
 };
 
 struct rpmhpd_desc {
@@ -175,7 +173,6 @@ static struct rpmhpd mxc = {
 	.pd = { .name = "mxc", },
 	.peer = &mxc_ao,
 	.res_name = "mxc.lvl",
-	.skip_retention_level = true,
 };
 
 static struct rpmhpd mxc_ao = {
@@ -183,7 +180,6 @@ static struct rpmhpd mxc_ao = {
 	.active_only = true,
 	.peer = &mxc,
 	.res_name = "mxc.lvl",
-	.skip_retention_level = true,
 };
 
 static struct rpmhpd nsp = {
@@ -757,7 +753,15 @@ static int rpmhpd_update_level_mapping(struct rpmhpd *rpmhpd)
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



