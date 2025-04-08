Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 138C026A0A7;
	Tue,  8 Apr 2025 12:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115065; cv=none; b=lhnmjoaEwPBUCj16aN67KhjjMEoAm6kGy4Jn5EtK2h1In1CDz/s2x+KqrAWgOLDNptB9I2mVS4+UJJKP0ihwJrQa+E4W+8zJXnoVXegYgZBo91nXTneLbzNhB+L6PkUUyeFinWLN2sTy3Lu7qLTvrxXrKOzQpqktmbLuAQ89jKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115065; c=relaxed/simple;
	bh=YanGxqBISbE8K1iD9zz+rjyV9zw4/odQhyccBXUuDco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VzAyKPBzKKT+/wigcGbvKiaTe14IMLfH4RlDy1ShGT5Bt9+yzjfwqPxQZOoz4um7QzaxNGwt9zz1yYmyelI4Ncwx4fRAXUU5Fxk4vPhii2CXAggKIZGjBGkY7mELaFivHv/0eq0IkSkiGHMkXBa4RKQNOu5g/eNxdSUn216/P8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1TpDFc1u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1TpDFc1u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95EEEC4CEE5;
	Tue,  8 Apr 2025 12:24:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115064;
	bh=YanGxqBISbE8K1iD9zz+rjyV9zw4/odQhyccBXUuDco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1TpDFc1us32UiwSfHpr7MGHAiJP//9LP29KOiT/3vAESc/mq+SUK30VhKnx8WXvk6
	 ihJ897DsYC3jny1+yRIyxRLF7d7ojwYuk2zIN/kUFfk9St4PMamc4tw/pUGDc5WDDG
	 zAC7svQ/yo6EVxnLd7DQJFMP+MjSaF/G2EdBaiFA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bard Liao <yung-chuan.liao@linux.intel.com>,
	=?UTF-8?q?P=C3=A9ter=20Ujfalusi?= <peter.ujfalusi@linux.intel.com>,
	Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
	Shuming Fan <shumingf@realtek.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 334/499] ASoC: rt1320: set wake_capable = 0 explicitly
Date: Tue,  8 Apr 2025 12:49:06 +0200
Message-ID: <20250408104859.554181080@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bard Liao <yung-chuan.liao@linux.intel.com>

[ Upstream commit 927e6bec5cf3624665b0a2e9f64a1d32f3d22cdd ]

"generic_new_peripheral_assigned: invalid dev_num 1, wake supported 1"
is reported by our internal CI test.

Rt1320's wake feature is not used in Linux and that's why it is not in
the wake_capable_list[] list in intel_auxdevice.c.
However, BIOS may set it as wake-capable. Overwrite wake_capable to 0
in the codec driver to align with wake_capable_list[].

Signed-off-by: Bard Liao <yung-chuan.liao@linux.intel.com>
Reviewed-by: Péter Ujfalusi <peter.ujfalusi@linux.intel.com>
Reviewed-by: Ranjani Sridharan <ranjani.sridharan@linux.intel.com>
Acked-by: Shuming Fan <shumingf@realtek.com>
Link: https://patch.msgid.link/20250305134113.201326-1-yung-chuan.liao@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt1320-sdw.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/codecs/rt1320-sdw.c b/sound/soc/codecs/rt1320-sdw.c
index 3510c3819074b..d83b236a04503 100644
--- a/sound/soc/codecs/rt1320-sdw.c
+++ b/sound/soc/codecs/rt1320-sdw.c
@@ -535,6 +535,9 @@ static int rt1320_read_prop(struct sdw_slave *slave)
 	/* set the timeout values */
 	prop->clk_stop_timeout = 64;
 
+	/* BIOS may set wake_capable. Make sure it is 0 as wake events are disabled. */
+	prop->wake_capable = 0;
+
 	return 0;
 }
 
-- 
2.39.5



