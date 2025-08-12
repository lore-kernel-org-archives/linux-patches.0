Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C061188715;
	Tue, 12 Aug 2025 18:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755023430; cv=none; b=rpwIOqwyfLlAA1OqEbGtOYRPw+BbvU4wDnrOMeu//0Ry59wBYLy65jYji69nupfOpXu4xdfUhBNgBt4Wf6p3mmsnyBg6dicxG4p6YXa+QDIzRfv/Ze/EtrSKs/Kt2tLKPc9VOfiYdCW8UydJGBGKtvUVpokvrlO+jdJ/F7qSDRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755023430; c=relaxed/simple;
	bh=JCZtA4APqgvrQpQHMv/waPp3qT/D51lWvNUea4ngXC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IF/95PiqsgQZcBBulNb8g9tUcVwYh9KOu20pb3hwmlJILDFISqddFRCo4OVTV9h/8gK2Ql/FzDAydD3w88Ukh0sMj7J2BK7Mwken8oE1/KT5AQQF+wkWiNzCh3m4T3u6qmAoFQJGXAyFSHLURF/dn9eLd0SGmHJJGGisGLOXf6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0cE55Q85; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0cE55Q85"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63510C4CEF0;
	Tue, 12 Aug 2025 18:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755023429;
	bh=JCZtA4APqgvrQpQHMv/waPp3qT/D51lWvNUea4ngXC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0cE55Q85beafNMaqQq0l2WQSBojkvM1jb5M9ndlEmvpTi6w2wfke6mog23TDELdAF
	 g3mZG8NjvosZY+dszYmE7sZO4t/pzkvZnVIIKj9PgLuMqXnXI2/g5hOm0gdeYnF4wI
	 lWpEn+RNnlcm9Zn/08scpotfA1xT8iaVoWQUhapk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	Charles Keepax <ckeepax@opensource.cirrus.com>,
	Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 078/627] ASoC: SDCA: Add missing default in switch in entity_pde_event()
Date: Tue, 12 Aug 2025 19:26:13 +0200
Message-ID: <20250812173422.277631370@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812173419.303046420@linuxfoundation.org>
References: <20250812173419.303046420@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Charles Keepax <ckeepax@opensource.cirrus.com>

[ Upstream commit 2ed526bf04a6d81592b314f81e7719a14048f732 ]

The current code should be safe as the PDE widget only registers for the
two events handled in the switch statement. However, it is causing a
smatch warning and also is a little fragile to future code changes, add
a default case to avoid the warning and make the code more robust.

Fixes: 2c8b3a8e6aa8 ("ASoC: SDCA: Create DAPM widgets and routes from DisCo")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Signed-off-by: Charles Keepax <ckeepax@opensource.cirrus.com>
Reviewed-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.dev>
Link: https://patch.msgid.link/20250624122844.2761627-3-ckeepax@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/sdca/sdca_asoc.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/sdca/sdca_asoc.c b/sound/soc/sdca/sdca_asoc.c
index 7bc8f6069f3d..e96e696cb107 100644
--- a/sound/soc/sdca/sdca_asoc.c
+++ b/sound/soc/sdca/sdca_asoc.c
@@ -397,6 +397,8 @@ static int entity_pde_event(struct snd_soc_dapm_widget *widget,
 		from = widget->off_val;
 		to = widget->on_val;
 		break;
+	default:
+		return 0;
 	}
 
 	for (i = 0; i < entity->pde.num_max_delay; i++) {
-- 
2.39.5



