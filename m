Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09244184549;
	Tue, 10 Sep 2024 10:31:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964315; cv=none; b=UHSygjqSYJ0l5rzHl5ZeTR0LrkCxunPPPSdLFuPQmwxHP+5zDw7zkdoi0zg59xCK0/+PM6wtLZXd1UiL8aWNv0+JNHTOMGYqPDrqvOd3d/x/UkVpvaj2/FI9Eim9G7kGTNYbCRy086Ob/RXDRRsBXb0Evv/eCNDtO68DFYZRmC0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964315; c=relaxed/simple;
	bh=0qrXdo0Tzow7S5x9S462ds8Q9bjJgs1eXtwppFhYxxc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=s5taAtVZ2txC7ZaR7ptzLw9IStAZcRrCJN62RTTmM34bvgZaN5mU0pPFfyhd7Qi91zZPrIs1HaeAIRX+FZcG9Cp9uVIf/YkLg+zanSUMlVXktQh1JV4X5zXulWFangDGyJulfuAfGzvgyddyzjO9eU5ooL7sxOtFxz0WVhaJExU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0q5cT5z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0q5cT5z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23E80C4CEC3;
	Tue, 10 Sep 2024 10:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964314;
	bh=0qrXdo0Tzow7S5x9S462ds8Q9bjJgs1eXtwppFhYxxc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0q5cT5zLkxVlrKFjkuOAOkL83gVITb/XFSZ8jOdtjXvfY9++j7OB+5O0MVba2bAe
	 zzraby5qbUltExWP0+DB8U+c9UbqwEaT2ltEgh4PtHNcnAeTM1HL37puuTj1vukm4o
	 JAJnbR3ckK84OmMGH+iUiuKnPD5hXawqja5QQZa0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 140/269] ASoC: topology: Properly initialize soc_enum values
Date: Tue, 10 Sep 2024 11:32:07 +0200
Message-ID: <20240910092613.198937809@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>

[ Upstream commit 8ec2a2643544ce352f012ad3d248163199d05dfc ]

soc_tplg_denum_create_values() should properly set its values field.

Signed-off-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Link: https://patch.msgid.link/20240627101850.2191513-4-amadeuszx.slawinski@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/soc-topology.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/soc/soc-topology.c b/sound/soc/soc-topology.c
index 7e8fca0b0662..a643ef654b9d 100644
--- a/sound/soc/soc-topology.c
+++ b/sound/soc/soc-topology.c
@@ -851,6 +851,8 @@ static int soc_tplg_denum_create_values(struct soc_tplg *tplg, struct soc_enum *
 		se->dobj.control.dvalues[i] = le32_to_cpu(ec->values[i]);
 	}
 
+	se->items = le32_to_cpu(ec->items);
+	se->values = (const unsigned int *)se->dobj.control.dvalues;
 	return 0;
 }
 
-- 
2.43.0



