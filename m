Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A82803081C3;
	Mon, 13 Oct 2025 15:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760369147; cv=none; b=pSYEn5fuh3S3hXK9I49IX3geTn5fhHbddc8ekLHrkocibpMizVrmkN3MyrEvgcvjTIpcaUiCeqOSXpVChH2TCuOB8SqIQqqXawjIFjwwclx2MN7JKpR2IKDAPPB8ovYXVY4XMbqOziRqymOY82HM3/U3QQ/vvXjIhvIEZ18iek8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760369147; c=relaxed/simple;
	bh=k65OPWpR9O2rtGbWHz9ACcS01m7lpkzTnzv9c7/uHl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9okkTAfcYL9hHdExwY8JlmFwxBwsVeXQ3WMcuvFbhzXQjmx+xakDowS+4miXEJCRm3aA0iK1nmn3oR6gIGgamhqnpvJCPykyUOFLzz0H96oFEq4E0X1l2Vpdz9ONFDKa3idmur6n4cMJxwQZqKGSA9kCKBXUZDUawGPb/2W/84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hbqXM6Lk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hbqXM6Lk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30D6EC4CEE7;
	Mon, 13 Oct 2025 15:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760369147;
	bh=k65OPWpR9O2rtGbWHz9ACcS01m7lpkzTnzv9c7/uHl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hbqXM6LkPdZbBn3EONmNNe8WUc/pn+FN/zG6iNYvpuzGXM0dQM057yUP8F91ThjSF
	 9E8yCwFDHaJprTpTfEuqW7JBtVgrkB0ux0LQ2Xu+/YZYKe7bLtOma6USQORCIfjwlf
	 VpSG71iVg31fQHd8BQj0A6AowSfCAkKjt09WUqE0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 144/563] arm64: dts: renesas: r9a09g047e57-smarc: Fix gpio keys pin control node
Date: Mon, 13 Oct 2025 16:40:05 +0200
Message-ID: <20251013144416.507729917@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Biju Das <biju.das.jz@bp.renesas.com>

[ Upstream commit 3e5df910b592d47734b6dcd03d57498d4766bf6c ]

Adding pin control node to the child won't parse the pins during driver
bind. Fix the issue by moving it to parent node.

This issue is observed while adding Schmitt input enable for PS0 pin on
later patch. Currently the reset value of the PIN is set to NMI function
and hence there is no breakage.

Fixes: 9e95446b0cf9 ("arm64: dts: renesas: r9a09g047e57-smarc: Add gpio keys")
Signed-off-by: Biju Das <biju.das.jz@bp.renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20250817145135.166591-2-biju.das.jz@bp.renesas.com
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r9a09g047e57-smarc.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r9a09g047e57-smarc.dts b/arch/arm64/boot/dts/renesas/r9a09g047e57-smarc.dts
index 1e67f0a2a945c..9f6716fa10860 100644
--- a/arch/arm64/boot/dts/renesas/r9a09g047e57-smarc.dts
+++ b/arch/arm64/boot/dts/renesas/r9a09g047e57-smarc.dts
@@ -90,10 +90,10 @@ &i2c0 {
 };
 
 &keys {
-	key-sleep {
-		pinctrl-0 = <&nmi_pins>;
-		pinctrl-names = "default";
+	pinctrl-0 = <&nmi_pins>;
+	pinctrl-names = "default";
 
+	key-sleep {
 		interrupts-extended = <&icu 0 IRQ_TYPE_EDGE_FALLING>;
 		linux,code = <KEY_SLEEP>;
 		label = "SLEEP";
-- 
2.51.0



