Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585816;
	b=KF5h9eyAlL/ZSybM7x3xQ9JqRaWkjsb5H1hmZnNrASWOJVDel7mExVZNDuqMWP3OvyPq
	 EoY+bDKRaPNsdzdezLzuJNqZX63FYVe/FH3VwHFBifpLPPjI0e6U16YLV8lpzN5Kq6p6p
	 gEy/Kil7XWQirac+vNkz1Q06rxpNgSXCo2cyhxD7fWyL18oWm2SLbE94p7UWpQFgDFdOA
	 cN5Ke+OoA0s/4vvV5Jy8WQx+1GyRDQD8X3Fqd6X7VNH1JpYm1qoHEk1+LMDBSduMtKm73
	 w9FzGOl0nkn5kMgcdvha2xXjDl3GA+F12lw5V1XS9hpSoIjCriPgYS6QnMYdJ9rFhvQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585816;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HgNps8lfHpuP1S5N9tEGVoNN7IsTTvpPh8vkyyeFFRQ=;
	b=EeKITqja3ozxGJ/TSpLsz5Eq+csU33XzaIzD/7aZNfslG9rLbTSeLc1GXIcnrCoaWidv
	 J/x81Wi8fC4ScTO+VPpTwYQtJ1IrDEzI4gfiab0IrP3FFkeWYLFDyJQQxVdysElGlmcBB
	 7JghKYcAN+HqgDt+8KrliBbm0ggQcRBhLW48D53Euw54xKPk0HpGNXZwOQz7dDH6rZ5yU
	 g4oieQf3/nEuprFt5JMI9TG1s12auqPy7cjULPS+5/XGJ5qxym+r0Fxu+BbPGHVnm2tbi
	 iPdZS85Cgv0GvHA6ljqV6Z65fDBYf5tFIHaRT33vOoee+lY2FUzzvBor0qXZYlV2E1Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hqsDQZV8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C9A1606C554;
	Fri, 13 Nov 2026 16:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=hqsDQZV8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 493B41F000C4;
	Fri, 13 Nov 2026 16:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585816;
	bh=HgNps8lfHpuP1S5N9tEGVoNN7IsTTvpPh8vkyyeFFRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hqsDQZV85a/Fok7gPOvmBNR5u6/QWbK+wyQJ2B6lBhkw3f53zJe8NB+ceCqcBfbGc
	 Drd6MhYUwW85uQQrmYpOqVATP8CLn04omiKBfcUC+/gCjdln5qOdC+crfD+dMOt/dc
	 gq4vt5SXQK1x2Lj003DXUD0n0VWXkDnN+nd8fOwQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cristian Castellano <cristian.castellano@icloud.com>,
	Mohamed Yassine Jebabli <med.jebabli@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 398/507] ALSA: hda/tas2781: Only accept CRC-less V1 data if all entries are valid
Date: Fri, 13 Nov 2026 10:51:42 -0500
Message-ID: <20261113153810.235798931@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

From: Mohamed Yassine Jebabli <med.jebabli@gmail.com>

[ Upstream commit 8dbab764f1e0a92c3fac0ce070ce30c0c33c2692 ]

Commit 408249089c48 ("ALSA: hda/tas2781: Accept V1 calibration data
without CRC") only checked the first device entry. On machines where
the BIOS populates fewer entries than p->ndev, the remaining all-zero
entries are applied and tas2781_cali_preproc() divides by zero on
playback open.

Accept CRC-less V1 data only if every expected entry is non-zero and
self-consistent (R0 * 1/R0 close to 1.0), otherwise reject it as
before.

Fixes: 408249089c48 ("ALSA: hda/tas2781: Accept V1 calibration data without CRC")
Reported-by: Cristian Castellano <cristian.castellano@icloud.com>
Closes: https://lore.kernel.org/all/4e500063-d985-46b6-a0a1-3feaa77c4b2f@leemhuis.info/
Cc: stable@vger.kernel.org
Signed-off-by: Mohamed Yassine Jebabli <med.jebabli@gmail.com>
Link: https://patch.msgid.link/20261103-tas2781-v1-nocrc-fix-v1-1-a769c27f21ce@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/hda/codecs/side-codecs/tas2781_hda.c | 27 +++++++++++++++++++++-
 1 file changed, 26 insertions(+), 1 deletion(-)

diff --git a/sound/hda/codecs/side-codecs/tas2781_hda.c b/sound/hda/codecs/side-codecs/tas2781_hda.c
index e0da299df780c..9162173ccb105 100644
--- a/sound/hda/codecs/side-codecs/tas2781_hda.c
+++ b/sound/hda/codecs/side-codecs/tas2781_hda.c
@@ -50,6 +50,31 @@ static void cali_cnv(unsigned char *data, unsigned int base, int offset)
 		(u32 *)&reg_data, TASDEV_CALIB_N);
 }
 
+/*
+ * V1 data without CRC is only trusted if every expected device has a
+ * populated, self-consistent entry: R0 (Q27) * 1/R0 (Q31) must be
+ * close to 1.0 in Q58.
+ */
+static bool tas2781_v1_nocrc_valid(const unsigned int *v, int ndev)
+{
+	const u64 one = 1ULL << 58;
+	int i;
+
+	if (ndev <= 0 || ndev > 4)
+		return false;
+
+	for (i = 0; i < ndev; i++) {
+		const unsigned int *e = &v[i * 5];
+		u64 prod = (u64)e[0] * e[1];
+
+		if (!e[0] || !e[1] ||
+		    prod < one - one / 10 || prod > one + one / 10)
+			return false;
+	}
+
+	return true;
+}
+
 static void tas2781_apply_calib(struct tasdevice_priv *p)
 {
 	struct calidata *cali_data = &p->cali_data;
@@ -145,7 +170,7 @@ static void tas2781_apply_calib(struct tasdevice_priv *p)
 			 * but leave TimeStamp and CRC zeroed.
 			 */
 			if (!tmp_val[20] && !tmp_val[21] &&
-			    tmp_val[0] && tmp_val[1]) {
+			    tas2781_v1_nocrc_valid(tmp_val, p->ndev)) {
 				dev_warn(p->dev,
 					 "%s: V1 data without CRC, accepting\n",
 					 __func__);
-- 
2.53.0



