Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD1F447253D;
	Tue, 21 Jul 2026 19:50:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784663433; cv=none; b=p/LFBqazF+oqlwQ2bGrnuoTQwbLyrlFKh3oonWlg4E7y6drGwBV2kqcnHwi51qRknTkWb/E+OlYU+4n9cQUM92LffBbNvlgfQTJuAfycQkReR14aNq69suJgO9n/lA8rpekOc3i68tN8UBGtHmqex9L32DlOkAZtXO56J5fPTCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784663433; c=relaxed/simple;
	bh=djXKPeebXGfKugS2l3ExwiuNpSqnwZFQqAf8PgMEo6E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=raJxxo1gn8a2E5V/6LkRqS3kjTFZPFTC6iyA2V2qXyAziQMEVosJmymPhBYnO0nwl0Hw8tyMO6+FDiohf6V8Vx/n6v8vcRrbUJk7AVCq9L0Kx6YFiRoIuFTx/2o3pPqiW+8W7dmw3mp1ci7Ym8ktS2RSFflPQputElp+loU4FO4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qR8FuegB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qR8FuegB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E9AE1F000E9;
	Tue, 21 Jul 2026 19:50:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784663432;
	bh=EKyjfh+/3FKfN9dio7jAlSJ7FDWzK+KnKsnGvNpGa84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qR8FuegBSOB/PyH6VyU6r2O8VjQ1OszB58Ou5UKWtfgEb7fUDQK80DRf5jQdJvzMP
	 XKg97RoE8pPMBM6Yv5MfS7vUChpeXK8TBH8+JEOpozTCtT5hdnvf730/Eo4YfqSKAa
	 YNgvv7H5IUtqdeEnut6s6uP0CMVZ658tBzQLheng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Judith Mendez <jm@ti.com>,
	Nishanth Menon <nm@ti.com>
Subject: [PATCH 6.12 0820/1276] arm64: dts: ti: k3-am62a7-sk: Add bootph-all tag to vqmmc
Date: Tue, 21 Jul 2026 17:21:03 +0200
Message-ID: <20260721152504.415619146@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Judith Mendez <jm@ti.com>

commit d8fe8442366ffd8306575028bda92389d0dfb674 upstream.

Add bootph-all property to vqmmc voltage regulator node and its
corresponding pinmux node to make it available during all boot
phases. This allows to run tuning early in SPL stages of boot.

Fixes: 8f023012eb4a ("arm64: dts: ti: k3-am62a: Enable UHS mode support for SD cards")
Cc: stable@vger.kernel.org
Signed-off-by: Judith Mendez <jm@ti.com>
Link: https://patch.msgid.link/20260324140247.1200631-1-jm@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/boot/dts/ti/k3-am62a7-sk.dts |    2 ++
 1 file changed, 2 insertions(+)

--- a/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
+++ b/arch/arm64/boot/dts/ti/k3-am62a7-sk.dts
@@ -134,6 +134,7 @@
 		gpios = <&main_gpio0 31 GPIO_ACTIVE_HIGH>;
 		states = <1800000 0x0>,
 			 <3300000 0x1>;
+		bootph-all;
 	};
 
 	leds {
@@ -381,6 +382,7 @@
 		pinctrl-single,pins = <
 			AM62AX_MCU_IOPAD(0x000, PIN_INPUT, 7) /* (E11) MCU_GPIO0_0 */
 		>;
+		bootph-all;
 	};
 };
 


