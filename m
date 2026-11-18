Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795030881;
	b=sAJePUgO5QCIpjLoGpqmAS+t1KQ8Akj4uOa6CRdmCsd1pXzcDXV8BpQe4APSYMTuT07f
	 FZs7O2auH31AKY/hcqzELlOqVdlOk5L/8IQDr+Z3EDvlqRrxQxNbne4qIpXsMxKSmGjMM
	 kVdLNHf9InEfL+AJoXolT+D7bnUftBDRNRLQQyPfWXgR5gh+ImIlsGiRHteWcN5gRFsCh
	 LR7OllxIaI7eoL+4yA3Mwq4/MI//nh+Um5HQh22W3fzebhgtg1yCC2nbpdtF+6ckZDbtr
	 euNcHO3PCjssWYefnWfNzDbEz8NKdSATYZUViHmWXtDHsr5DXGiWt8pR0/pAaNj3ZRA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795030881;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=zVXGpXIXDwjiRRdzb+I7LrA/ec038Tuzt0EvRU4ECBA=;
	b=qaqpizZeuR3mIz9do9IakDaJXu2xv/yy6S3CtYB6mHnCTg+gQfXiLHpFRrTxWy98+guQ
	 4E/QxQYh6bSd21xKRPtGytDxZ3czJpMh4rCjEioV0iZzJS+4PAhWe+4f5xYCFt3f9bdWw
	 1XI/b3fLd8NXSZr5B+7Gy9urMowyWkuZqqnTHbLk1HG7K379b3UJ38WYbDPxmHg1EwYRe
	 QWotH9EtcQp+n0lkXQ/RCSJXIcGIE/1j0YaLhJUiuXBjdVkZNJXG12HTqVLVIlQ71qym0
	 7p6/PDJgaseh/ZTfcPej/V7eKZiQbLqzaYvwWWCgiKF7v/PfatmVmTGemofC6zisx6w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jcOrQ3gD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26E65606D356;
	Wed, 18 Nov 2026 19:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jcOrQ3gD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F6CD1F000C4;
	Wed, 18 Nov 2026 19:41:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795030881;
	bh=zVXGpXIXDwjiRRdzb+I7LrA/ec038Tuzt0EvRU4ECBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jcOrQ3gDsoOknCxwDUlaWP20nQjwcpxbZjpWFU1wqt4+aadSg2BdQFsy4LxAspv41
	 ne5+q+YMYLF315XorWBa9R/dPimrefTZF8SC2Ms2ktZ7kobNtrHxGIEmUvyryaaf3R
	 mK6oevVyINVf/9wm8CWYbvDgB2imibr77oyvhORw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0834/1756] power: supply: ab8500_charger: Handle detection errors
Date: Wed, 18 Nov 2026 15:49:21 +0100
Message-ID: <20261118150042.686422171@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 1098c619ce7595a77a8c2e366a703e9fc5f29bf7 ]

ab8500_charger_detect_chargers() returns either a charger bitmask or
a negative register-access error. The probe and component-bind paths
use a negative return value as a bitmask, making failed reads appear
as both AC and USB connections.

Propagate detection errors and release the bind-time workqueue on
failure.

Fixes: 84edbeeab67c ("ab8500-charger: AB8500 charger driver")
Fixes: 1c1f13a006ed ("power: supply: ab8500: Move to componentized binding")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260916-ab8500-charging-v1-10-e986ed321cc6@kernel.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_charger.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index 9c81f79502870..f530682bfd1e8 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -3463,6 +3463,10 @@ static int ab8500_charger_bind(struct device *dev)
 	}
 
 	ch_stat = ab8500_charger_detect_chargers(di, false);
+	if (ch_stat < 0) {
+		destroy_workqueue(di->charger_wq);
+		return ch_stat;
+	}
 
 	if (ch_stat & AC_PW_CONN) {
 		if (is_ab8500(di->parent))
@@ -3751,6 +3755,10 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 
 	/* Identify the connected charger types during startup */
 	charger_status = ab8500_charger_detect_chargers(di, true);
+	if (charger_status < 0) {
+		ret = charger_status;
+		goto remove_ab8500_bm;
+	}
 	if (charger_status & AC_PW_CONN) {
 		di->ac.charger_connected = 1;
 		di->ac_conn = true;
-- 
2.53.0



