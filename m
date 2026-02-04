Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AD962C3254;
	Wed,  4 Feb 2026 15:30:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770219004; cv=none; b=FEDObRWZzjmcRnGVPrcFaEuyxJ/25dMrsx+aLqVJBraokZmZF7rABbu2WghhLgfhZOBtxtdepLK3rAZiOyPrGMDDp8eHJu4QqP1dVpCHba3HsmhuevP5nn0TzFn4/fPA+PutXbhLizDRdaYSrLsUpj+hCQnkNKGhbQm71hJiHhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770219004; c=relaxed/simple;
	bh=AQDNo6ZxwP4aPkpEjN1S1DPXttUR4AfifxViJog/4e8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=f4qP+IA91cf5Iqd7swkMwusLMR1IB8RpvwYDQcypvr2WqVFNbG6/Tql/EfFxfmp/J0oKWBd7Vto6Yhv1qN1Yzr734M1SV8mGXqBviM1aP6o5gGPlrkCaqJUp+s/I4AGLeyYboosAl2fSqpqbGvzrj6ICXe5K9JORs+z0YtFvk/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V8V/7a0H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V8V/7a0H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6ED72C19423;
	Wed,  4 Feb 2026 15:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770219004;
	bh=AQDNo6ZxwP4aPkpEjN1S1DPXttUR4AfifxViJog/4e8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V8V/7a0Hqr6gvnlwbZdYn2SFmXgTmb7DYDIM4HFKfPQHzX/rBc6usPiMDQNFJFbKj
	 HyLTVQzXZMjpL4Zz9PPgWwPJYOtBEB7OkkesnJ2hTc5wuT5+y1LDUt/hadlqL0VxX+
	 Peuan97KzX5XCqqaJmHoztv8EparlnI10c01cH8s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 039/122] ASoC: soc-acpi-intel-ptl-match: fix name_prefix of rt1320-2
Date: Wed,  4 Feb 2026 15:40:21 +0100
Message-ID: <20260204143853.266922019@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.857060534@linuxfoundation.org>
References: <20260204143851.857060534@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 403a0591be681eebc0c4825f8b42afe7fd13ee7f ]

rt1320_2_group2_adr works with rt1320_1_group2_adr and the name_prefix
should be rt1320-2.

Fixes: ffe450cb6bce ("ASoC: Intel: soc-acpi-intel-ptl-match: add rt713_vb_l3_rt1320_l12 support")
Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260123113809.2238766-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/common/soc-acpi-intel-ptl-match.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/intel/common/soc-acpi-intel-ptl-match.c b/sound/soc/intel/common/soc-acpi-intel-ptl-match.c
index 4853f4f31786f..55505625b3609 100644
--- a/sound/soc/intel/common/soc-acpi-intel-ptl-match.c
+++ b/sound/soc/intel/common/soc-acpi-intel-ptl-match.c
@@ -418,7 +418,7 @@ static const struct snd_soc_acpi_adr_device rt1320_2_group2_adr[] = {
 		.adr = 0x000230025D132001ull,
 		.num_endpoints = 1,
 		.endpoints = &spk_r_endpoint,
-		.name_prefix = "rt1320-1"
+		.name_prefix = "rt1320-2"
 	}
 };
 
-- 
2.51.0



