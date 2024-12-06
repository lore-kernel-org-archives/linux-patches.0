Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8AD47F53;
	Fri,  6 Dec 2024 14:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733497103; cv=none; b=j2U7k833o2boo1v96OPw6vJmELAz/aqGXpcmm8a2LRjKXFDxk6Q+cLQfgdsKi+Jy9WJ/z5JmDFR7iobQtFLaUHT25YyqGl5QYxFuAQeV6ryYzoYENwxcOI0wGWcfsgYZKzBZsuJfsDSkFN56LQJLoVF1ObgdE51l2MtHKlSjg4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733497103; c=relaxed/simple;
	bh=R2/p0cFtlUUd4sbXEz1x9BW/8W/PzkD/PdmGoh4CwK0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FxeeienVPIIIzbOeh5QIEYZdQFkds9XcE5kV+lEfQ/tMCX6dbuXt+A9MTd0Cbu+13s0Py0SU7GcZGhCENfwp4Cb86DEG73Lohzp8V1nm/a4uIKcVpnyjeEDWO76F6qXppmcVGoa8vp9cJR0zjnyhGH5RHNGMC3cnPLLL0lS7FF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yBtW111R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yBtW111R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D87C4CED1;
	Fri,  6 Dec 2024 14:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733497102;
	bh=R2/p0cFtlUUd4sbXEz1x9BW/8W/PzkD/PdmGoh4CwK0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yBtW111RV85ID/qkZTZkHEsBcHk7Z4K9ZBFgw3nRE6WZ4Jcp/L0MGFY9IfyM1SE/R
	 OPht65IMeLcjFjuuAO8KRdLCcbnPCwsaxkuU00AwUlsAnFMaqD8+xMX8s+htGP7ADD
	 ZJSjFBIVN+iTCdZNML57k/3NVZus8eE6T+XHEeLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>,
	"Everest K.C." <everestkc@everestkc.com.np>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 195/676] ASoC: rt722-sdca: Remove logically deadcode in rt722-sdca.c
Date: Fri,  6 Dec 2024 15:30:14 +0100
Message-ID: <20241206143700.961848367@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 9ff607984ea19..b9b330375adda 100644
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



