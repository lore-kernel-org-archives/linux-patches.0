Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46537264614;
	Tue,  8 Apr 2025 11:09:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110581; cv=none; b=JKdizJXl0jiiB+14cyZ6BCJtSALyfOTW/C20d9hYleRWA8u1iePK6a4Pen7xv2udOtauZjXLtJ3xMv0PIG3aQI73b8VLb/R+28TfjNJ9IzfscOo5+eaUABFH9DPbrybEIiICEmeLWtp2aESfJIJanczugH3fube4DkfN1MH4cKo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110581; c=relaxed/simple;
	bh=l5y8zi8bOBY8I8yZVBxxTUJhcQcWpg2/wTSHTgtHBvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NtZ/5gYt4qVpQfXiZ2U9+sqZmgi8+b0f2qdDkf4yfo4sePWkkprO6eg19NG54EOJAmz/2cLiGITWPEyamI0dhmoyLRYYevpq6hhGzSpRR+cZBTgylQBLcqFIR8F7HfKhzlllDU0UXsSuyx5VZ0amScfzfg3tVRd5C7mbWgek3cw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xPPgMjfZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xPPgMjfZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF58C4CEE5;
	Tue,  8 Apr 2025 11:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110581;
	bh=l5y8zi8bOBY8I8yZVBxxTUJhcQcWpg2/wTSHTgtHBvw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xPPgMjfZnWLCbjRa5oMSOD6hy+lkmKoa545ecn5yznB5tNsBHxMB1+rx0KA/2HmVB
	 BC/pQPQwU4n7YG7wtl82JqumH1vjCnHjfpG9qkoIPAGHM2dRo8zW2sK68RcIZtBlsD
	 D2Bf77O5Wh9MvG91LtHQ8ld9k71OaKg7/A1WORgY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Renesas Test Team via Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 116/731] arm64: dts: renesas: r8a774c0: Re-add voltages to OPP table
Date: Tue,  8 Apr 2025 12:40:13 +0200
Message-ID: <20250408104916.975814286@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Geert Uytterhoeven <geert+renesas@glider.be>

[ Upstream commit ea34dd0f029f4a30c055ddb6daaf7a6f3bee21ed ]

When CONFIG_ENERGY_MODEL=y:

    cpu cpu0: EM: invalid perf. state: -22

When removing the (incorrect) voltages from the Operating Points
Parameters tables, it was assumed they were optional, and unused, when
none of the CPU nodes is tied to a regulator using the "cpu-supply"
property.  This assumption turned out to be incorrect, causing the
reported error message.

Fix this by re-adding the (correct) voltages.  Note that because all
voltages are identical, all operating points are considered to have the
same efficiency, and the energy model always picks the one with the
highest clock rate.

Reported-by: Renesas Test Team via Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>
Fixes: 554edc3e9239bb81 ("arm64: dts: renesas: r8a774c0: Remove bogus voltages from OPP table")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/2046da75f3db95b62f86c0482063c4d04c2b47d5.1728377971.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a774c0.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a774c0.dtsi b/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
index 7655d5e3a0341..522e20924e94a 100644
--- a/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a774c0.dtsi
@@ -47,16 +47,20 @@
 	cluster1_opp: opp-table-1 {
 		compatible = "operating-points-v2";
 		opp-shared;
+
 		opp-800000000 {
 			opp-hz = /bits/ 64 <800000000>;
+			opp-microvolt = <1030000>;
 			clock-latency-ns = <300000>;
 		};
 		opp-1000000000 {
 			opp-hz = /bits/ 64 <1000000000>;
+			opp-microvolt = <1030000>;
 			clock-latency-ns = <300000>;
 		};
 		opp-1200000000 {
 			opp-hz = /bits/ 64 <1200000000>;
+			opp-microvolt = <1030000>;
 			clock-latency-ns = <300000>;
 			opp-suspend;
 		};
-- 
2.39.5



