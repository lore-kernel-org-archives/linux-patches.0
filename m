Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0704630C37A;
	Mon, 13 Oct 2025 15:07:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760368022; cv=none; b=f7lz7s+LbxhSo0JkoLYsXxGuYL5qLeqwqtgImGAtZhyGeFpNpeNJ7DQs1QjeZmXcN93MPZ6N8cc0XANY2bPUDkcuL+rfO9zZ+E2st1go7hHF581EMQVAzcNWl4NbR2wF7cVYVIPTxZ5TY/zcJpDpNDSDbRM6m10Dpsf1pu2w8iE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760368022; c=relaxed/simple;
	bh=dxqr5YYeBOvPCB5fOOPp2RnlHnrlwlnTSJQiV+sYC9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mz+4CgWRZrd2uX+4caevUwF8tT/CL23+9hcslcqsSVy1VJxkCBsLUmKV1Xr5Odcrd/bqeTX9Y9iUCm18hs1nXSxSo0+IFAomNh+Hwj+GH+Y5VZ1ydNKsUNFRmw8OjrmwNDiyB5QpyZ8CFVq+kBLxgsvda6+HZa8xWSw8oEqfUcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bqa9k5l+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bqa9k5l+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F351C4CEE7;
	Mon, 13 Oct 2025 15:07:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760368021;
	bh=dxqr5YYeBOvPCB5fOOPp2RnlHnrlwlnTSJQiV+sYC9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bqa9k5l+YrcQWMWb4yW9Szt1jD7aAGMYiHJ7ypLfKRpZgCEFlHGcW9DiZsMvAhR4/
	 1hcWjK4B0XmSWUrdPn0NT9yMDPf0VBKFcchbdsy0xyoaUsD0c1sXntpoyMVc+YWZfO
	 aT/T3TchMcfkfKj+6TkJVDKP95OZTLzAAEaUtRBw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 017/262] arm64: dts: renesas: rzg2lc-smarc: Disable CAN-FD channel0
Date: Mon, 13 Oct 2025 16:42:39 +0200
Message-ID: <20251013144326.748682078@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
References: <20251013144326.116493600@linuxfoundation.org>
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
index 377849cbb462e..5785a934c28bf 100644
--- a/arch/arm64/boot/dts/renesas/rzg2lc-smarc.dtsi
+++ b/arch/arm64/boot/dts/renesas/rzg2lc-smarc.dtsi
@@ -48,7 +48,10 @@ sound_card {
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



