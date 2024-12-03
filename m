Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B76E1F8921;
	Tue,  3 Dec 2024 15:08:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238517; cv=none; b=IHQAuV483kOq/P7HdCpsEZx2oyQJXRLws5SvoYIVVRHak4icU65AdjJPW7PsaawSGwE3hNK36t50xL/9VhepDUJNvIMVisM7zzzapy5aAvz5jNKILtuO9JBA4kaispudGAgOObh/ghDGIcc2FH36hDK9KrurgoXi8Ym5HCOxwD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238517; c=relaxed/simple;
	bh=YczNpQr36HV9AUpUhSMlkMdQYv729KqToaF2ew/1+Dw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=th+19JM/pZA3iSBC0lxZGJ9tZTqp+DnnSc8MJw5oZNFa8TikMvtvpthx1yTIgNa+oMiaa80Rmrlrfpd+NYHPdFfPdZcTke1k+JAOaG2djaMiIomXEjXHdEebuTgZibreqlsnKtCnQhqAdjZNvjl86/zHywBLKRjrlZaMswv4VtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m0YrR893; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m0YrR893"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDA08C4CECF;
	Tue,  3 Dec 2024 15:08:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238517;
	bh=YczNpQr36HV9AUpUhSMlkMdQYv729KqToaF2ew/1+Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m0YrR893fNqXf2j0Avy/7W4091Nl9818itBP2UWPXvziuw8NUoYytOaRqSTzufM0y
	 ji5frXEiRN/769IOtCZCqWEnBgJpT/mN7wf/U6K40i6SMUE9mwMVUOmmrRhLWDYqLc
	 O5qI+dCRVMOFSS0jFMy2Ao74ugqxZ3AiWhRCNk+Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Everest K.C." <everestkc@everestkc.com.np>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 273/817] ASoC: rt722-sdca: Remove logically deadcode in rt722-sdca.c
Date: Tue,  3 Dec 2024 15:37:25 +0100
Message-ID: <20241203144006.458717648@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Everest K.C <everestkc@everestkc.com.np>

[ Upstream commit 22206e569fb54bf9c95db9a0138a7485ba9e13bc ]

As the same condition was checked in inner and outer if statements.
The code never reaches the inner else statement.
Fix this by removing the logically dead inner else statement.

Fixes: 7f5d6036ca00 ("ASoC: rt722-sdca: Add RT722 SDCA driver")
Reported-by: Shuah Khan <skhan@linuxfoundation.org>
Closes: https://lore.kernel.org/all/e44527e8-b7c6-4712-97a6-d54f02ad2dc9@linuxfoundation.org/
Signed-off-by: Everest K.C. <everestkc@everestkc.com.np>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://patch.msgid.link/20241010175755.5278-1-everestkc@everestkc.com.np
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt722-sdca.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/sound/soc/codecs/rt722-sdca.c b/sound/soc/codecs/rt722-sdca.c
index e5bd9ef812de1..f9f7512ca3608 100644
--- a/sound/soc/codecs/rt722-sdca.c
+++ b/sound/soc/codecs/rt722-sdca.c
@@ -607,12 +607,8 @@ static int rt722_sdca_dmic_set_gain_get(struct snd_kcontrol *kcontrol,
 
 		if (!adc_vol_flag) /* boost gain */
 			ctl = regvalue / boost_step;
-		else { /* ADC gain */
-			if (adc_vol_flag)
-				ctl = p->max - (((vol_max - regvalue) & 0xffff) / interval_offset);
-			else
-				ctl = p->max - (((0 - regvalue) & 0xffff) / interval_offset);
-		}
+		else /* ADC gain */
+			ctl = p->max - (((vol_max - regvalue) & 0xffff) / interval_offset);
 
 		ucontrol->value.integer.value[i] = ctl;
 	}
-- 
2.43.0



