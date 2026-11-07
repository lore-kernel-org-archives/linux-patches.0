Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794060686;
	b=ah02jYr0KvkocKbFJfpCpccgJISpq1jZAeXfLai+nj8VqB1Xp8TuVXwfRQTKtvhpY8E3
	 uDvPO9htlzi8tNxm+3TXdCjhVbWg3AOybQVCJKbTgrD2vPb053zpqgkAqM87en4yvCHwx
	 W/nAlBKarMWcMIZlXHgDzfbI8lUBCk7a5FQ66ZeJrwXvGxR9Ax/+DVcK8dgvAMKncN7zA
	 yr8JzbZHJqhMop/rr0jt7e7mJN2QsuJmZUR6jvAo3Gi3BpcEs428zHESUF19LioNTrPhR
	 x0erqOSm9DUS6huX7By7Pnv9f7IdAc7n081HvqWn1gPmQz7aO3IBK/dtPaS/8MbKF1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794060686;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=y32rtymTpgmBDWJgcapwJLKZpKVNDqUVH2autxpFP/I=;
	b=l+r+eLsvuoG23aiwvPCpxnB7Eidy+tF28le5u1+DskpE8WZggK+c8F+UOXIWHmGLOOcz
	 nWXYXORoqop9NpyrRORrhUowCWL5FsjtuX1B/R7ZObGY0vIAprKCiIKNbuSY+c6Jcmxdi
	 bzHEOZRhqr47Biv7s3Bw55IBqBrPirXbEoiquEMUigyR4EPV/SFjCZe93GTmcYU3B1axZ
	 rF45IMUtsAGcnv8BI8TcOGHWU5AHQl7mCOBKr3O6UvRimXa7gYrRFpXCZjsvije10A17X
	 RuBCxh80MR6uzU4hkDtJ8EK8yjJTgNGHcmNYEJn+lfhr1iomND9LAlbgOPp5ieO6dPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eQQzm1eO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA44606A32C;
	Sat,  7 Nov 2026 14:11:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eQQzm1eO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62E0D1F0089F;
	Sat,  7 Nov 2026 14:11:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794060685;
	bh=y32rtymTpgmBDWJgcapwJLKZpKVNDqUVH2autxpFP/I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eQQzm1eOceflR5PKks1sog7RKjGxkYJN1esA/V/fJ1Zh0a1+s0VrAuyja+FqDkxum
	 oxVXWtIwRC8EU6zruU7LyS5lJEMzk12GNoRg9qBESqh9QUd/uwWGmVmJUxlYaeIl2j
	 kJgqruvsVkL95qtTUgikyGYiyJfJAM8GRqigxRWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mike Tipton <mike.tipton@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Ulf Hansson <ulfh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0117/1536] pmdomain: qcom: rpmhpd: Skip retention by default
Date: Sat,  7 Nov 2026 08:35:33 -0500
Message-ID: <20261107135000.973637365@linuxfoundation.org>
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
index 88cb836e6f67a..32b5f7062d086 100644
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
@@ -826,7 +822,15 @@ static int rpmhpd_update_level_mapping(struct rpmhpd *rpmhpd)
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



