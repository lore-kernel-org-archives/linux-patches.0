Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39706492E33;
	Wed,  9 Sep 2026 13:57:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962273; cv=none; b=qXUn7EixmPYJglVBe9fqrNZO1JJrgTJD8W4a1qXAe/PpqT3TB/0fOnMgLNlB4z/cGIV3WZq0dNPAZtA6qwyJQ97hKhgkpkhwa7/vlbLmIyLx1UfIK8oXQrLIGTSCYEvCDcxwDkLxne+0RVOSvrdLXI1F3OQhONZTCWJMgxFZwg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962273; c=relaxed/simple;
	bh=o+Fm213izPavEyO95ayJY8Itatd0iu4fix3otxBam60=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G7jDp42nMi6+CZhGxfnHuJa6Cb/ZU++Iz9m0y5ikhFiVwU1Hpku34eFpVvAxzcqnhLqfUWdjEEYdUPzj9frSLHxDBkb4Nv6YNj4w397W6kFa9TnmSJjtI+P40GzM7jrZZCqG1H+MeXy3wrNl5gkHdMk5uEXXaN5+dZewT/Ksncs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1Fvt7yvE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1Fvt7yvE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 490EA1F00A3A;
	Wed,  9 Sep 2026 13:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962271;
	bh=PiQWWiRn+WoK7zwOw9rC8xe2bLxZvDmG10oH8tYx6gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1Fvt7yvEwuhIik5HDWUHaYyQIAA84BaxITjt9oy54AuqXGbURMlNhVBQyueaqOMbo
	 tv32aya0hF+UQu3tS7PiVkAJJjxj1WJpQ9tXp+GLHoYV+EaWZs9e+A2ee2yJQ+sKin
	 vpXvqKPNjONf83wEIYjTuec6pu7Y0tkvjf4NQKgE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 233/556] ASoC: pm4125-sdw: sort the register default table
Date: Wed,  9 Sep 2026 15:38:33 +0200
Message-ID: <20260909134238.609768719@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 8dd18d9956bfd74531bfd7088e59586e3e115789 upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

PM4125_SWR_HPHPA_HD2 (0x3090) is listed before
PM4125_ANA_HPHPA_SPARE_CTL (0x308e), which makes the latter unreachable.
regcache_reg_needs_sync() then cannot compare it against its default and
reports that a sync is needed, so it is written to the device on every
regcache_sync() even when it was never touched.

Sort the table by register address.

Fixes: 8ad529484937 ("ASoC: codecs: add new pm4125 audio codec driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805113911.21723-1-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/pm4125-sdw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/pm4125-sdw.c
+++ b/sound/soc/codecs/pm4125-sdw.c
@@ -126,8 +126,8 @@ static const struct reg_default pm4125_d
 	{ PM4125_ANA_HPHPA_FSM_CLK,              0x12 },
 	{ PM4125_ANA_HPHPA_L_GAIN,               0x00 },
 	{ PM4125_ANA_HPHPA_R_GAIN,               0x00 },
-	{ PM4125_SWR_HPHPA_HD2,                  0x1B },
 	{ PM4125_ANA_HPHPA_SPARE_CTL,            0x02 },
+	{ PM4125_SWR_HPHPA_HD2,                  0x1B },
 	{ PM4125_ANA_SURGE_EN,                   0x38 },
 	{ PM4125_ANA_COMBOPA_CTL,                0x35 },
 	{ PM4125_ANA_COMBOPA_CTL_4,              0x84 },


