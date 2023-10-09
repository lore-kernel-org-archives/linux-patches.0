Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 107A818035
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aeFqq5Oz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1F9C433CB;
	Mon,  9 Oct 2023 13:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858857;
	bh=dG+YnAIz6i7K3AqNcFTNLJnJNoBzs+DttFV173++8lw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aeFqq5OzofJK7QW4djelBmw2xh5vM6WgWVqFz8gFTZ+yD4GnWpSQ+29IvQcqIyAhy
	 /n6/f0ogaecWpMi5t00uRDKQJDi+jSZCByL2ZanfKjTmO4wrTGnEMM2e+muZA85ELy
	 YWgxHhide9khQXFOpv97ZPJVVvQ7rYruZkhruEhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carl Philipp Klemm <philipp@uvos.xyz>,
	Merlijn Wajer <merlijn@wizzup.org>,
	Pavel Machek <pavel@ucw.cz>,
	Sebastian Reichel <sre@kernel.org>,
	Tony Lindgren <tony@atomide.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 094/226] ARM: dts: motorola-mapphone: Configure lower temperature passive cooling
Date: Mon,  9 Oct 2023 15:00:55 +0200
Message-ID: <20231009130129.225140996@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Lindgren <tony@atomide.com>

[ Upstream commit 5c3db2d4d4ed747e714387362afe007e6ae5e2d3 ]

The current cooling device temperature is too high at 100C as we have a
battery on the device right next to the SoC as pointed out by Carl Philipp
Klemm <philipp@uvos.xyz>. Let's configure the max temperature to 80C.

As we only have a tshut interrupt and no talert interrupt on 4430, we have
a passive cooling device configured for 4430. However, we want the poll
interval to be 10 seconds instead of 1 second for power management. The
value of 10 seconds seems like plenty of time to notice the temperature
increase above the 75C temperatures. Having the bandgap temperature change
seems to take several tens of seconds because of heat dissipation above
75C range as monitored with a full CPU load.

Cc: Carl Philipp Klemm <philipp@uvos.xyz>
Cc: Merlijn Wajer <merlijn@wizzup.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Reichel <sre@kernel.org>
Suggested-by: Carl Philipp Klemm <philipp@uvos.xyz>
Signed-off-by: Tony Lindgren <tony@atomide.com>
Stable-dep-of: ac08bda1569b ("ARM: dts: ti: omap: motorola-mapphone: Fix abe_clkctrl warning on boot")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/boot/dts/motorola-mapphone-common.dtsi | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/arch/arm/boot/dts/motorola-mapphone-common.dtsi b/arch/arm/boot/dts/motorola-mapphone-common.dtsi
index 5f8f77cfbe59f..807042a293d0a 100644
--- a/arch/arm/boot/dts/motorola-mapphone-common.dtsi
+++ b/arch/arm/boot/dts/motorola-mapphone-common.dtsi
@@ -192,6 +192,14 @@
 	};
 };
 
+&cpu_thermal {
+	polling-delay = <10000>; /* milliseconds */
+};
+
+&cpu_alert0 {
+        temperature = <80000>; /* millicelsius */
+};
+
 &dss {
 	status = "okay";
 };
-- 
2.40.1



