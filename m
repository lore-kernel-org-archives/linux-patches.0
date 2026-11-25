Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622203;
	b=PGW8jnKzZeDGx+g4pLjkudwwiYNum8YodfRWA0G0Geyb2XjjliRzH1q/iMoFF2PUOZ2U
	 iMv/uvwQM7Dj1W1kJQq8GlahoWehHv7Uw6/saJ45EviOVPSX7EB7X/nVbsFhRYI1ZEfOM
	 +RGW+tUR+Wzl/Kvu5yT9OCVTsUtV4IaTb+2y1DtX43oVB8vbTp/AOUEy6iNe/uELbJ3TY
	 FkksLZoQ0iOxh2Z/UbxO6TpbIDmt5oUlzEEd2ltCj5jyyaccOoiYfK9xbNKl/A17kgjhB
	 x3SAtOU5A36A3pubj5gEThrqoPm5QOkDURhP9aV+7rvfm2Kzg5CFYzgazEJEuOSwg0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622203;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=bewt1pNtGpoKWv2N007f8BQCF1Y2A0jbdHG8cNz+PaU=;
	b=qmoLoA+fAqDbEjvM/NSYVS/iVp3cSXR6QoRRnHsKMQjPs4v9aB8cowoIFgiTEOCpwEJi
	 +lLemOsW3Pkz7NRd6I+e4CPCnSgJkeJyEV5XyF1m6GXJ+8NtAw2QRRMYM/72RcYlCIJud
	 DYKFgRKiaNcar1xjy/sdzWWx3yBLBcEmRrig5oUuP35z/VVpP7XvKMtuwph5jDhPuBKV5
	 opRGGKByM8Ge6nCvJL9vvdDw7Jlgd9/WIscQ5qfM298NkAzcXZ0tbB1USGhoPlvTk5KVh
	 5DRerwPFIUorLKwmMN7vsnnFkkzYHGEydh2/N5QOqOZgfc5BgYTCstLfu1Wh3IFW1BQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TVPyazuj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E686C606A326;
	Wed, 25 Nov 2026 15:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TVPyazuj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA2BF1F000C4;
	Wed, 25 Nov 2026 15:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622202;
	bh=bewt1pNtGpoKWv2N007f8BQCF1Y2A0jbdHG8cNz+PaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TVPyazujV9sDUafYIRB1tcpp9YJ+/gkJLcf271qMd+PE6ebcunPyEk+6q4CBTKlQf
	 g9dMFZ/TdhElEKYoCkfiv0EDDCunPPUUGDk42hXtZwQLo8zEkyX3qG+NXFJbc0xipR
	 QMqy50+TL2kdUM5g+eq2R+BH5khliYkSkfrDbGpw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>,
	Matt Roper <matthew.d.roper@intel.com>,
	Shekhar Chauhan <shekhar.chauhan@intel.com>,
	Matt Atwood <matthew.s.atwood@intel.com>,
	Gustavo Sousa <gustavo.sousa@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 463/990] drm/xe: Sync Wa_16023105232 in xe_was to match OOB rule
Date: Wed, 25 Nov 2026 15:30:30 +0100
Message-ID: <20261125143832.941848233@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Gustavo Sousa <gustavo.sousa@intel.com>

[ Upstream commit 557c7b4343781cae9725bf26122d29c26ea12f5d ]

Wa_16023105232 was extended in xe_wa_oob.rules to match extra IP
releases while the respective entry in xe_was[] was overlooked.
Update the latter to be in sync with the former.

Also add comments in the code so that we don't forget to update both
places if new IP versions are added.

Fixes: c96e0df4e9f5 ("drm/xe/xe3: Add support for media IP version 30.02")
Fixes: 4fde66699f1c ("drm/xe/xe3: Add support for graphics IP versions 30.04 & 30.05")
Cc: Dnyaneshwar Bhadane <dnyaneshwar.bhadane@intel.com>
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Shekhar Chauhan <shekhar.chauhan@intel.com>
Reviewed-by: Matt Atwood <matthew.s.atwood@intel.com>
Link: https://patch.msgid.link/20261105-wa_16031259911-v3-2-da6ec790aa29@intel.com
Signed-off-by: Gustavo Sousa <gustavo.sousa@intel.com>
(cherry picked from commit 0cfb54f8f4d69efc847641738d25065049160aca)
Signed-off-by: Matthew Brost <matthew.brost@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/xe/xe_wa.c         | 5 +++--
 drivers/gpu/drm/xe/xe_wa_oob.rules | 1 +
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/xe/xe_wa.c b/drivers/gpu/drm/xe/xe_wa.c
index 0a59fd3ef7690..52f7da9e92481 100644
--- a/drivers/gpu/drm/xe/xe_wa.c
+++ b/drivers/gpu/drm/xe/xe_wa.c
@@ -675,8 +675,9 @@ static const struct xe_rtp_entry_sr engine_was[] = {
 	  XE_RTP_ACTIONS(SET(TDL_TSL_CHICKEN, RES_CHK_SPR_DIS))
 	},
 	{ XE_RTP_NAME("16023105232"),
-	  XE_RTP_RULES(MEDIA_VERSION_RANGE(1301, 3000), OR,
-		       GRAPHICS_VERSION_RANGE(2001, 3001)),
+	  /* IP versions need to be in sync with the respective entry in xe_wa_oob.rules. */
+	  XE_RTP_RULES(MEDIA_VERSION_RANGE(1301, 3002), OR,
+		       GRAPHICS_VERSION_RANGE(2001, 3005)),
 	  XE_RTP_ACTIONS(SET(RING_PSMI_CTL(0), RC_SEMA_IDLE_MSG_DISABLE,
 			     XE_RTP_ACTION_FLAG(ENGINE_BASE)))
 	},
diff --git a/drivers/gpu/drm/xe/xe_wa_oob.rules b/drivers/gpu/drm/xe/xe_wa_oob.rules
index b703055eb6331..598e11ee0ed14 100644
--- a/drivers/gpu/drm/xe/xe_wa_oob.rules
+++ b/drivers/gpu/drm/xe/xe_wa_oob.rules
@@ -50,6 +50,7 @@
 18013179988	GRAPHICS_VERSION(1255)
 		GRAPHICS_VERSION_RANGE(1270, 1274)
 1508761755	GRAPHICS_VERSION(1255)
+# IP versions need to be in sync with the respective entry in xe_wa.c.
 16023105232	GRAPHICS_VERSION_RANGE(2001, 3005)
 		MEDIA_VERSION_RANGE(1301, 3002)
 16026508708	GRAPHICS_VERSION_RANGE(1200, 3005)
-- 
2.53.0



