Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E668B221F20;
	Mon, 13 Oct 2025 14:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760367087; cv=none; b=Ack3dIIG2ZmlVCgydslgRthriE2eIL+fvICQhLZk84mv2nJ7Kt1A3mmr11SIWFOf/xji6/gonHqV2kcxOYF+TIRpjr24UASne8hQ6GjzE5aHowO66SlUeTY14K21kmB1MB/AjvZCe7SR0gHSxjZLWiGIpqxbdYpPXDWqWM3SS50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760367087; c=relaxed/simple;
	bh=rznG/JWZU0cCSXpoA7wsuyk0O6o5BhIzwKTLMX8hFqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GujqxMWdYlbGe2eiixYkYJJwDOeemLZzrXQF49x2Z9mXRpqYWErmENQu0y+4GMgu0NVUwFbtzJstRV6VLrEJqs6mjEGQt0chFaRKpjo5epGEfE5IdnczCdoI1YWSWo9T76G6VdGbuLC2Pze0utln9GXgnLuOSVsuLRDWxu6N64Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j4p2R6Nq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j4p2R6Nq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 706BDC113D0;
	Mon, 13 Oct 2025 14:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760367086;
	bh=rznG/JWZU0cCSXpoA7wsuyk0O6o5BhIzwKTLMX8hFqY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j4p2R6Nqi9HcrvE64m8sZRx9SyBg4/J4rsRnG6Vqq+yucGXG3IwOuYttFeqLk11qv
	 bVfil7z3KEDRpJYVbhwWQP1A47FiGbU4SjNbgme1RtLp5T0HvdBgMijT/TSVB+JGmm
	 yBLabzxKWdBUCpxDj94H6/zHqUUlQmSQUvOWdY3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Biju Das <biju.das.jz@bp.renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 054/196] arm64: dts: renesas: rzg2lc-smarc: Disable CAN-FD channel0
Date: Mon, 13 Oct 2025 16:43:47 +0200
Message-ID: <20251013144316.538814307@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144314.549284796@linuxfoundation.org>
References: <20251013144314.549284796@linuxfoundation.org>
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
index 6be25a8a28db7..866f1358d57a4 100644
--- a/arch/arm64/boot/dts/renesas/rzg2lc-smarc.dtsi
+++ b/arch/arm64/boot/dts/renesas/rzg2lc-smarc.dtsi
@@ -50,7 +50,10 @@ aliases {
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



