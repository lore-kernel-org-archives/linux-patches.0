Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034286;
	b=Ma7rqnhKXqHT5JUNvfic9mYDqX43gIR5DWC4yxMyiaTqu07ykg9xUQ4jkKv5wVdkS8UL
	 J6Nn+e7xJKKxdrhs/MenLMeKq+JiueKMA+WyYLa7u4sTQ9/rcF2T92o2JdQZg0jec0wpw
	 e8l2LsSMhWRg9ebdUqW7m5yjasWPrIrpRvXkUYqG/cfZhb236I5a/xNL4NkgWILQljs42
	 56ERIE6Sfz43y79KlOUYWDiKrpP+Wy9A4R8QLECE76Mt4sO/YOwN15Q1nYLpmpLuaGH5W
	 bKApowQzKepw+X1+TAb5/BGtQ0vLnz1XNP+hgtttyrY5h44ZAy55hJp3Pzb8V2hrNGw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034286;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=WypIq5h44lmr8EnDnpQoM0eZhvoLNRJ2qrMdhYco2MI=;
	b=fIReIeOp17Xtk14HVh7jnjmRWl14bsuCCAyjnmxqtCA5WmVQivxiwgnDTlWIUyTEj61W
	 2TGJUx5sZwd+UlsewUVjBNyg5+2HVT+GQosOEjB9Jl1gKv2adAw5F4GnETqb7XjzCm0zz
	 25kQDHk86+/VN6jGblOaOA5Dc+IFl1z9vQTOyjwUKgCf2ET6+PnHRglEVdTz/e4jUmxMj
	 PhS159i5I0GzVORlI5ipBXY9cA6dlEwyrBQul4nYt8qqLwJsLyVVUfdxWTfMUHm49ZPhO
	 MazmdGQiiNh1+16VhP0P5nrwj2Zr8Ngxse7kTxQcNf7GlANHhUL4fqQtrcLk3t5g5XA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o8Xhd4Ys;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6CDD606A331;
	Wed, 18 Nov 2026 20:38:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=o8Xhd4Ys
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30F9A1F000C7;
	Wed, 18 Nov 2026 20:38:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034286;
	bh=WypIq5h44lmr8EnDnpQoM0eZhvoLNRJ2qrMdhYco2MI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o8Xhd4Ysy0awEg8wT1Q/pIpEhZNEe4Z/vJwCz6brTlffLGua7Y2QeRIWSFRuAkD7i
	 /AAXLls7W2Ar1ARidLtcN7LEIhUr9L3s8FXGG7sXwci+Mq5s4IFcSnBOc5dm0p+57D
	 rTjFPD99Lb6rlUYS4U4rEuFCVdZSqihJzQphI5Ls=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robin Everaars <robineveraars@pm.me>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0315/3318] ACPI: button: Add DMI quirk for Razer Blade Pro 17 early 2020 lid switch
Date: Wed, 18 Nov 2026 15:15:37 +0100
Message-ID: <20261118150325.274372642@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Robin Everaars <robineveraars@pm.me>

[ Upstream commit 415125669c2ddc773c579a60df108f75712dfa83 ]

The lid switch reports "close" but can miss the matching "open", leaving
_LID closed after resume. systemd-logind then suspends the system again
roughly every 35 seconds.

Reading the embedded controller's PSTA byte while _LID is stale shows that
bit 0x04 is set, which the DSDT treats as open. The DSDT returns the cached
LIDS byte from _LID. Its wake path aborts in RTEC on an unhandled
SystemCMOS region before copying PSTA to LIDS.

Initialize the lid state to open on resume, matching the existing quirk
for the Razer Blade Stealth 13 late 2019. With
button.lid_init_state=open, a physical close suspended once and resume
reported open without another suspend.

Signed-off-by: Robin Everaars <robineveraars@pm.me>
Link: https://patch.msgid.link/20260817141414.213075-1-robineveraars@pm.me
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/button.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index c760e38df981f..9449580e48429 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -130,6 +130,17 @@ static const struct dmi_system_id dmi_lid_quirks[] = {
 		},
 		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_OPEN,
 	},
+	{
+		/*
+		 * Razer Blade Pro 17 early 2020, notification of the LID device
+		 * only happens on close, not on open and _LID keeps returning closed.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Razer"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Blade Pro 17 (Early 2020) - RZ09-0329"),
+		},
+		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_OPEN,
+	},
 	{
 		/*
 		 * Samsung galaxybook2 ,initial _LID device notification returns
-- 
2.53.0



