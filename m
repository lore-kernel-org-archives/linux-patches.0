Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026404;
	b=kF7E+GkkwGjFqaMGbJV5Tji39i2BARh3j2Y5u4JCA72MJ/Ymktp+Cj/9kXBU29dGNAZj
	 68PdcjxlbU+Jn9fWl+Hma3GQKdZvQfEc19yb2+Gbnt2Is3+pXPUfH+7tV6/bRLSWLzdEA
	 MduWypdQgMOLt5HXjmZu9fKWH/NaZscrGmEVPeJjgWMdNwqylsKY0/nH4z2yDmiasSG74
	 5tjh5kJ+OKAoMBEZMsavGooMxFkVGGKabhMsyTM4SpTwdiDG2+w6tEi0sobuVTPPORftj
	 jSY8EyQbGsDK1BYGZDuS6/JouqONozRlpZuAQULWtBKdETECJYGoUxSmPyI5BSemiig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026404;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=hlUZKSuOKw1Fsls7J/j2m1qtTZVx0d8NZtuJJTWyetc=;
	b=Gn11CPvCaaVNxfQTE1zVh0Q5oAVh1cbP5SJaaDbnHJZ7/Z/GKFzAd04Mgn6Lgv/Qao5R
	 JEs3cXHfpbe4btQzZVw6y+Uycx8SX2ckpzVnHGOxfOjO4s9O+ALsDRYCcxjiknG649Fdz
	 rsevoWDo/TN9bQ/cvM1Yzd7B+lVjBHMGgFRIeDaDn/mmBtZ143Js1vLdgMsX1nkXTX+iK
	 RqZHF7QTVbHqLz9xSzu+CwuCNvExGYsfmq7aJovcheHx7CCd36LN+E7El5xavlqcaZ3ud
	 Rf0VP63CIsRrMhtpmct8eBIc7XXvRRwngxSPM42TGgiwUlr9f3SWbbPPtqJJGLRfMXQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cWcwdJSO;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E356606A320;
	Wed, 18 Nov 2026 18:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cWcwdJSO
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D711F000C4;
	Wed, 18 Nov 2026 18:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026404;
	bh=hlUZKSuOKw1Fsls7J/j2m1qtTZVx0d8NZtuJJTWyetc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cWcwdJSOFl8EibUKD6GSkOo2BTjuulk6kr88TT36vouEfYeD45QTIeTIE1eocEKBM
	 1oAqXWxeMme9/7ERlXjtIi4DFKQSq5tQo4vjCbB2syldJ4Q0RkxBeIdYxUdwFFRrM6
	 S9I0dJnql6CepTCX9KtPDYIWlESIyG8FgIs6BEJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daasaradhi Mannava <daasaradhimannava@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1382/2151] platform/x86: msi-ec: Report valid charge thresholds when unset
Date: Wed, 18 Nov 2026 15:51:57 +0100
Message-ID: <20261118150212.349607615@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daasaradhi Mannava <daasaradhimannava@gmail.com>

[ Upstream commit a102207eaf4a18c60c2ffbdc421ad3d30bfed591 ]

The charge thresholds are computed by subtracting a fixed offset from
the raw EC value. When no charge limit has been set, the EC can hold a
value below range_min (0x80 on an MSI GL65 Leopard 9SCXK), and reading
the sysfs attributes returns nonsense:

  charge_control_start_threshold: -10
  charge_control_end_threshold:   0

Both attributes are documented to be within 0 - 100, and an end
threshold of 0 wrongly suggests that charging is disabled.

The store path already rejects values outside range_min..range_max.
Apply the same range to the show path and report the maximum threshold
for any value outside of it.

Tested on an MSI GL65 Leopard 9SCXK (EC firmware 16U8EMS2.100) with
the EC holding 0x80: the attributes now read 90 and 100.

Fixes: 392cacf2aa10 ("platform/x86: Add new msi-ec driver")
Assisted-by: LLM
Signed-off-by: Daasaradhi Mannava <daasaradhimannava@gmail.com>
Link: https://patch.msgid.link/20260916174812.11496-1-daasaradhimannava@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/msi-ec.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/platform/x86/msi-ec.c b/drivers/platform/x86/msi-ec.c
index 0cec54d497d1e..e00c4ed7d7b3c 100644
--- a/drivers/platform/x86/msi-ec.c
+++ b/drivers/platform/x86/msi-ec.c
@@ -1197,6 +1197,15 @@ static ssize_t charge_control_threshold_show(u8 offset,
 	if (result < 0)
 		return result;
 
+	/*
+	 * The EC may hold an out-of-range value (e.g. 0x80) when no charge
+	 * limit has been set. Report the maximum threshold instead of a
+	 * meaningless (possibly negative) percentage.
+	 */
+	if (rdata < conf.charge_control.range_min ||
+	    rdata > conf.charge_control.range_max)
+		rdata = conf.charge_control.range_max;
+
 	return sysfs_emit(buf, "%i\n", rdata - offset);
 }
 
-- 
2.53.0



