Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E7E268C70;
	Tue,  8 Apr 2025 11:09:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110584; cv=none; b=ipCzCYvOyFLFNgOloD+2x454gTcn5Xi7oLMXS1fXPOf9rAUXRA2mg31hrKQZhek+SXGa9XF2X/6iabjRrejOU3Xn2sMjKJAhXzURVFj2TFFv9aEl9B5yO427HA1DF+DVPW6TB1LzEMnoO2jjm8CpE41fe8HUrTnVoyJ4UX/977k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110584; c=relaxed/simple;
	bh=b3CFFbMca/9AD/UdcKGY6VqnwrqONDmTRWmFQIAv5x4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=edjcIy9eMvwZyqAgBGthZzLSg32tAWnuvO3pKJeTNJeYAmn4WwNechYHS+SXOy3yhAmOpPEuEIDLuZllUvejy7hrR3JlD9Y42OAC6JvSR9xunXbnJiHYxhTFutbrfNZa00avXKxxJmkAH3UVIXlVjxJSJtlo5rcrcMDaBPvnM1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j4lGkbkm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j4lGkbkm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86FE3C4CEE5;
	Tue,  8 Apr 2025 11:09:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110583;
	bh=b3CFFbMca/9AD/UdcKGY6VqnwrqONDmTRWmFQIAv5x4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j4lGkbkmrEDRoXaU1T8kmZUrPncVB8Xfw1hiaMVn2yfFyTN30OZG/84F+5JZlCjkM
	 H6COeO3z4LDlWxL9D/f/zNS+4Sz4Bo3WmGdqgy4TxGxSefQ+3SFXQL6nI40xPHSuZW
	 2RAZXzNTJ0Qe7SzGrm8QNEjxX4wynyVExIqXcgo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Renesas Test Team via Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 117/731] arm64: dts: renesas: r8a77990: Re-add voltages to OPP table
Date: Tue,  8 Apr 2025 12:40:14 +0200
Message-ID: <20250408104916.998501213@linuxfoundation.org>
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

[ Upstream commit c193f877770291f30d1e00bc6f2bb0757fe7a532 ]

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
Fixes: fb76b0fae3ca8803 ("arm64: dts: renesas: r8a77990: Remove bogus voltages from OPP table")
Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://lore.kernel.org/80890bc244670bc3e8d6fc89fb2c3cb23e7025f5.1728377971.git.geert+renesas@glider.be
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/boot/dts/renesas/r8a77990.dtsi | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/arch/arm64/boot/dts/renesas/r8a77990.dtsi b/arch/arm64/boot/dts/renesas/r8a77990.dtsi
index 233af3081e84a..50fbf7251665a 100644
--- a/arch/arm64/boot/dts/renesas/r8a77990.dtsi
+++ b/arch/arm64/boot/dts/renesas/r8a77990.dtsi
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



