Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44DE13081B0;
	Mon, 13 Oct 2025 14:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367434; cv=none; b=OExNRXK33ikh7rjRUyiczgTgEpovljcVUX0zQ6lX9iwOFwWqPkulcO+Hx8yIlx236zWQFrkOME6naKPjGpcS18AOr0ProuS094E2FpI3M4RvDQbypKoad+nFJ6pPZmASdf4qRXfRI2yOrvhQUiouSL4/dqEWTZiujYetSMJPhn4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367434; c=relaxed/simple;
	bh=/3wuewW+j1WqSHkuPe+CE4oqRJxAVkL5B8f5Cfb1XgY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BZQS6AGjlmWzhaZsAyuVcDlwL7tDempUG6hgxlPHd1JUi3pMtsfMPfIUfHce0/H4odSGE9M10HYw1FZeRfTcIgDClg9wIL5k4ccMEkJ1Ws2luAGblumyIHwgWOBinwF+ZaH36gSQoD8owMIcNM0JqvC9SZb4e6zn0WW5Ff0EGi8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hbFVg9MW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hbFVg9MW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1F3CC4CEE7;
	Mon, 13 Oct 2025 14:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367434;
	bh=/3wuewW+j1WqSHkuPe+CE4oqRJxAVkL5B8f5Cfb1XgY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hbFVg9MWg1WbJGWm13qh5eIz4vj+9EzSFTowangohEe+pj6EnxVnlgSiuZWzzy/7s
	 oho2FifTWxcsGCaDKk/18gOtV35BciJ44K1UNhk8pObZg0Dk6eUd+e/B1EBfgPOH31
	 a44hM2PNwJg9TecfJSMN7H7msV9D6U9yoepwdLXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 011/196] arm64: dts: renesas: rzg2lc-smarc: Disable CAN-FD channel0
Date: Mon, 13 Oct 2025 16:43:22 +0200
Message-ID: <20251013144315.603525369@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144315.184275491@linuxfoundation.org>
References: <20251013144315.184275491@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit ae014fbc99c7f986ee785233e7a5336834e39af4 ]

On RZ/G2LC SMARC EVK, CAN-FD channel0 is not populated, and currently we
are deleting a wrong and nonexistent node.  Fixing the wrong node would
invoke a dtb warning message, as channel0 is a required property.
Disable CAN-FD channel0 instead of deleting the node.

Fixes: 46da632734a5 ("arm64: dts: renesas: rzg2lc-smarc: Enable CANFD channel 1")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/20250801121959.267424-1-biju.das.jz@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/rzg2lc-smarc.dtsi | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/boot/dts/renesas/rzg2lc-smarc.dtsi b/arch/arm64/boot/dts/renesas/rzg2lc-smarc.dtsi
index 83fce96a25752..0234dbe95413c 100644
--- a/arch/arm64/boot/dts/renesas/rzg2lc-smarc.dtsi
+++ b/arch/arm64/boot/dts/renesas/rzg2lc-smarc.dtsi
@@ -38,7 +38,10 @@ hdmi_con_out: endpoint {
 #if (SW_SCIF_CAN || SW_RSPI_CAN)
 &canfd {
 	pinctrl-0 = <&can1_pins>;
-	/delete-node/ channel@0;
+
+	channel0 {
+		status = "disabled";
+	};
 };
 #else
 &canfd {
-- 
2.51.0



