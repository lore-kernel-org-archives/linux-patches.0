Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B49544AB76;
	Tue, 21 Jul 2026 21:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668693; cv=none; b=nQhVt/XDpEY5unOfOWzxyhSJgmLtnnHiKAGe03qQvjQ4AjZl6UdBi32Kx1Z6vghXsWX9ezOF1TRKN8AE7oBUsXth9eyLSi1UC5HI+9Y2wavsLutXwR83kHHxW1QFZAy6kJMepUiRM+6hqu6PpC1mA+/r8l1e48CJenweacyYugM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668693; c=relaxed/simple;
	bh=NyA7MfDVz0D238l/kO1NZn9lPvXQRFmD6CI/E/yg5XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XkaMQemRoUTMoCLT2qcUb5EB/iVS1h2hmxpeqUKV6GEjZmSygjP3D9LdV7EeeT0/M9M+I/h/JHYI40e9g15wMQjlDRg9QJCXUDTMvK5lJQNboAejZEJu5J/e/2H1madgCgKshY9+9Q8PN0Gy5TzvbJW5xomvpc+LIzaKLqrw5OI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xpd6w2vu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xpd6w2vu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0FFC1F000E9;
	Tue, 21 Jul 2026 21:18:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668692;
	bh=cLStSyoJt6ErXuLRMK086eOWjQcsXjFGjvCO+lq2CJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xpd6w2vuwQElr/u9LCyoXh0mEijVQ6b4WSDM9Ue1FvYlkxoy5QIZrAzehygin00w7
	 kx9FUKPQjSlAo6oDbOU1USlyaUQqjvkVX4voYgLf/HYEK1rUjMSSkgXiRHFdUWecdD
	 BKfn07aPaSa8iAlt58MmWbQpygan2YUc8vaanQAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guoniu Zhou <guoniu.zhou@oss.nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>,
	Peng Fan <peng.fan@nxp.com>,
	Ulf Hansson <ulfh@kernel.org>
Subject: [PATCH 6.1 0271/1067] dt-bindings: power: imx93: Add MIPI PHY power domain
Date: Tue, 21 Jul 2026 17:14:32 +0200
Message-ID: <20260721152430.657659047@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guoniu Zhou <guoniu.zhou@oss.nxp.com>

commit 6aa38ef0eab32df5409b72d62509de6ba09cea50 upstream.

Add MIPI PHY power domain for shared PHY resources used by both
MIPI DSI and CSI blocks.

Signed-off-by: Guoniu Zhou <guoniu.zhou@oss.nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>
Reviewed-by: Peng Fan <peng.fan@nxp.com>
Fixes: e9aa77d413c9 ("soc: imx: add i.MX93 media blk ctrl driver")
Cc: stable@vger.kernel.org
Signed-off-by: Ulf Hansson <ulfh@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/dt-bindings/power/fsl,imx93-power.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/dt-bindings/power/fsl,imx93-power.h b/include/dt-bindings/power/fsl,imx93-power.h
index 17f9f015bf7d..071221fe5c57 100644
--- a/include/dt-bindings/power/fsl,imx93-power.h
+++ b/include/dt-bindings/power/fsl,imx93-power.h
@@ -11,5 +11,6 @@
 #define IMX93_MEDIABLK_PD_PXP			2
 #define IMX93_MEDIABLK_PD_LCDIF			3
 #define IMX93_MEDIABLK_PD_ISI			4
+#define IMX93_MEDIABLK_PD_MIPI_PHY		5
 
 #endif
-- 
2.55.0



