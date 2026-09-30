Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EECA13BD22C;
	Wed, 30 Sep 2026 19:29:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790796543; cv=none; b=S1P0p17NlZYebf3gBIw43oAZfDxuHuamk1Ah5bJ6Xjzh5Zq2AqioWSDRlT6qOgUpA972Y7akexCh+f1g5WHF/7/ujT34ZLdxUz1949XujDMbYL3dtM+CI2fEaS+i1+mmyzARjlkKzYLYExfqZdEDcp04zf5/2VF31Wpy/m5HOE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790796543; c=relaxed/simple;
	bh=TqYY3LMRZywPAapK9oW76KU8FGTJ1e8IDYKv78v8WCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ujr3ICpYR1TjwmHzwR9rOOnDLs4syBVKURMf357jNrAUjRXNf9b7RiFskbnvbhGPPc0RFctGnmWPaLjscR/aSLOHMC61BCabstNaV5rvWEVgIjjqGN76dbkjYVGVmXXgEtmzk21DI3zAICg9xehaOA/7WimeBpKNd3g2k70BO0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0QIK4y3c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0QIK4y3c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 553F31F00898;
	Wed, 30 Sep 2026 19:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790796541;
	bh=DbA0SmJuEW2M/Xsraol1Cg+cPrHY8iaRHCvFCwKO1H8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0QIK4y3cajcCNHmdPYrkGFY2J+cSajIEooBSqTg0b5j+UiZ04XNXDmoIu92aihHLo
	 lvCMlMZcdTt8oKGYk8b3RmiZf/QVJJgOXIwU/xaIGFsiGiSggEqocPXjGWxs6+sIyf
	 8NaaKorSKb8vxGq8qagDfHUmk4D71bdLiRBOCOL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 6.6 0905/1193] hwmon: (pmbus/core) increase number of phases and add new mask
Date: Wed, 30 Sep 2026 17:26:29 +0200
Message-ID: <20260930152454.350805107@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nuno Sá <nuno.sa@analog.com>

commit 06bd6794b5fd2163880ac3bfe973d4cc61f359f3 upstream.

Increase the number of phases to 16 as a new upcoming device supports
such a number.

While at it, add a new mask for controlling the source of the output
voltage.

Note (groeck):

This patch was meant to prepare for support of MAX20826 and compatible
devices, which support more than 10 phases per page. However, Sashiko
reports that the mp2975 driver already supports up to 14 phases, and the
mp2856 driver supports up to 12 phases. This already has the potential for
out-of-bounds writes when probing the affected chips, making this patch a
bug fix.

Fixes: 2c6fcbb21149 ("hwmon: (pmbus) Add support for MPS Multi-phase mp2975 controller")
Fixes: f9e5f289b686 ("hwmon: (pmbus) Add support for MPS Multi-phase mp2856/mp2857 controller")
Signed-off-by: Nuno Sá <nuno.sa@analog.com>
Link: https://patch.msgid.link/20260911-hwmon-max20826-support-v2-1-5e30cbd97d84@analog.com
Cc: stable@vger.kernel.org
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hwmon/pmbus/pmbus.h |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/hwmon/pmbus/pmbus.h
+++ b/drivers/hwmon/pmbus/pmbus.h
@@ -241,6 +241,7 @@ enum pmbus_regs {
 /*
  * OPERATION
  */
+#define PB_OPERATION_CONTROL_V_SRC	GENMASK(5, 4)
 #define PB_OPERATION_CONTROL_ON		BIT(7)
 
 /*
@@ -376,7 +377,7 @@ enum pmbus_sensor_classes {
 };
 
 #define PMBUS_PAGES	32	/* Per PMBus specification */
-#define PMBUS_PHASES	10	/* Maximum number of phases per page */
+#define PMBUS_PHASES	16	/* Maximum number of phases per page */
 
 /* Functionality bit mask */
 #define PMBUS_HAVE_VIN		BIT(0)


