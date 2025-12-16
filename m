Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B464E35BDDE;
	Tue, 16 Dec 2025 12:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887294; cv=none; b=Li3D29BmHyJad1aiW1dlKhdwnyQajZYwe4XmB2eP8/gCdSApmNcnGYmh584p4tjCUf7OUzQtBwzHML0ejzfr5waCLoyENForFms8S489A62kPjluSCDSaYcBfUoiMUnFfr0EI4v/4iVeUEBQOh7kIMsOm5u9N0MFmF5nSQDEpsw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887294; c=relaxed/simple;
	bh=fFvmQ0SbBVcZ2mzcBDLQheuaAmPfIhadTEu8OYsYJRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VSzlC+Qa0j848VmkVp2NBQlE7e/AtBnaerlZ5BWtyec+pmEFm0QxVSgfHuQAiLZ2H6LSLpFWNiWtsRQFQ5cAOcH/3fJbXx2NmaFDQdbGZMCiDbL0vJNIcHjnrYaje+y594P+UM9Z2DpHvGD6bxq4++0sYyJsEdoMdV4TQjqhkRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t/W87t+u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t/W87t+u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 342D5C4CEF1;
	Tue, 16 Dec 2025 12:14:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887294;
	bh=fFvmQ0SbBVcZ2mzcBDLQheuaAmPfIhadTEu8OYsYJRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t/W87t+uoDKstrMnZjNY160rIbUotNW/cdl5p7xGv82uTGvPG1Z+wM99SkSz+C57Y
	 oA1fuwPIjDWatDlI11LcMDhlL+9vPQyydndDjlIUeEWPhl+Qh25/yy5et8rGrbQZZ2
	 /7fVjBNtxxV2E6VOuhTMvwAr96da1aO3w3i2ILr4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marek.vasut+renesas@mailbox.org>,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 169/614] arm64: dts: renesas: sparrow-hawk: Fix full-size DP connector node name and labels
Date: Tue, 16 Dec 2025 12:08:56 +0100
Message-ID: <20251216111407.472143440@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Vasut <marek.vasut+renesas@mailbox.org>

[ Upstream commit 9d22a34a016313137b9e534a918f1f9aa790aa69 ]

The DisplayPort connector on Retronix R-Car V4H Sparrow Hawk board
is a full-size DisplayPort connector. Fix the copy-paste error and
update the DT node name and labels accordingly. No functional change.

Fixes: a719915e76f2 ("arm64: dts: renesas: r8a779g3: Add Retronix R-Car V4H Sparrow Hawk board support")
Signed-off-by: Marek Vasut <marek.vasut+renesas@mailbox.org>
Reviewed-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20251027184604.34550-1-marek.vasut+renesas@mailbox.org
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a779g3-sparrow-hawk.dts | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/boot/dts/renesas/r8a779g3-sparrow-hawk.dts b/arch/arm64/boot/dts/renesas/r8a779g3-sparrow-hawk.dts
index 1da8e476b2193..ff07d984cbf29 100644
--- a/arch/arm64/boot/dts/renesas/r8a779g3-sparrow-hawk.dts
+++ b/arch/arm64/boot/dts/renesas/r8a779g3-sparrow-hawk.dts
@@ -119,13 +119,13 @@ memory@600000000 {
 	};
 
 	/* Page 27 / DSI to Display */
-	mini-dp-con {
+	dp-con {
 		compatible = "dp-connector";
 		label = "CN6";
 		type = "full-size";
 
 		port {
-			mini_dp_con_in: endpoint {
+			dp_con_in: endpoint {
 				remote-endpoint = <&sn65dsi86_out>;
 			};
 		};
@@ -407,7 +407,7 @@ sn65dsi86_in: endpoint {
 					port@1 {
 						reg = <1>;
 						sn65dsi86_out: endpoint {
-							remote-endpoint = <&mini_dp_con_in>;
+							remote-endpoint = <&dp_con_in>;
 						};
 					};
 				};
-- 
2.51.0



