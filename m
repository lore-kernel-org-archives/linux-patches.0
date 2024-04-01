Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8652C8F5C;
	Mon,  1 Apr 2024 16:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987933; cv=none; b=XhpwrwJbz1uhGgWyTwinhXJB5z6or1766KC16kJ061YHGYD5oKWKD1HAc4MB2CnhwqV1Enu4VIEINw7/cDnoOdJVzxHoH9dRJZ/wZDx1bz/fMRmKOgHg0Gi2+dY65OZtXSbGee0X9/vgdozwq1VxP8EUTyTBgJ7cb7KfU3Bb93o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987933; c=relaxed/simple;
	bh=Mw2IFut2xxypV687/n+sqiUwClw0oTfYLLefmKAZaNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0Y2ZwhGc1/y6ftrLnOM7Xx8VcPK0v35K9joKa9o8hmp64HxW9ebpYVbGxJRghMu8wPsYRrO6hNouWeaWOgTsY/6gYXIeK59UdX6ID7NsVYBsdEjrnD5l2kNyrp5A608SpziCVlepMKQAc+Scf3v2OiMGEYOnTurZ0CwDluQ5iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IVtX0o7N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IVtX0o7N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7537C433C7;
	Mon,  1 Apr 2024 16:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987933;
	bh=Mw2IFut2xxypV687/n+sqiUwClw0oTfYLLefmKAZaNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IVtX0o7N3zSESr/eCOT7/2ebqaCSKmEmh090ADX0qdk8J1M3pWEzlHtL8bBi2fZID
	 z9L7at91xLREuNl7KHh0uaPnBREALbtEM4hrVtFoWwu+TJJGFQrJJP8YKJOnbnUT4y
	 NbTkRN999Mcv0WXJ+QCaWHgHktaMocfnIHFo+Lu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 034/432] powercap: intel_rapl_tpmi: Fix a register bug
Date: Mon,  1 Apr 2024 17:40:21 +0200
Message-ID: <20240401152554.150108231@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152553.125349965@linuxfoundation.org>
References: <20240401152553.125349965@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit faa9130ce716b286d786d59032bacfd9052c2094 ]

Add the missing Domain Info register. This also fixes the bogus
definition of the Interrupt register.

Neither of these two registers was used previously.

Fixes: 9eef7f9da928 ("powercap: intel_rapl: Introduce RAPL TPMI interface driver")
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Cc: 6.5+ <stable@vger.kernel.org> # 6.5+
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/powercap/intel_rapl_tpmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/powercap/intel_rapl_tpmi.c b/drivers/powercap/intel_rapl_tpmi.c
index 891c90fefd8b7..f1c734ac3c349 100644
--- a/drivers/powercap/intel_rapl_tpmi.c
+++ b/drivers/powercap/intel_rapl_tpmi.c
@@ -40,6 +40,7 @@ enum tpmi_rapl_register {
 	TPMI_RAPL_REG_ENERGY_STATUS,
 	TPMI_RAPL_REG_PERF_STATUS,
 	TPMI_RAPL_REG_POWER_INFO,
+	TPMI_RAPL_REG_DOMAIN_INFO,
 	TPMI_RAPL_REG_INTERRUPT,
 	TPMI_RAPL_REG_MAX = 15,
 };
-- 
2.43.0



