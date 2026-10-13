Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7425E35E955;
	Tue, 13 Oct 2026 12:48:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895703; cv=none; b=LLjF3acEE4Hq/HvGfzfXdsb376qJoAe7gVs64sUejCGqMEBpmNjgeukj6A0spdRbsG/r5q0MAUWcDsvVYzaoK5BU/N9UrhepK6VE1r7i7SN5VF1KrwmKLbVylrWTvS6eu4ll/Br5DDUV/NfgVlVEAhCjfcSyGDFG/KdRMTrFzEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895703; c=relaxed/simple;
	bh=WVGqSsHNnS7FLZ9QDk18C4jijHFIySzsWZ/qUoVQpJs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1zt7PeWhByqV3ksbiBo/pbyQ2qWkTS9kZBloX1nxpFXCX9i+NJ0bX2JUp08q0e0Mm9O/gDNSj/A3tiCDKWRvydlu1j0LyyngOdsq7uMBjbSAUNLPBgPkMct9mJIMyMjLBKBHlaOTjMuvA4+BpYV0XMuVKOaEN5QxYL93nlpdzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HW+++l3m; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HW+++l3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B081F000FF;
	Tue, 13 Oct 2026 12:48:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895702;
	bh=p3GliQzV9GClwMJeHHMDU/BG0B8dVtXSa1cusY7XbN4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HW+++l3mYHLAJSdzmZuq3/FtJz9Jh7znJNFJAST4jBS/ZCcp6J+ysFd1it+E+s7Cf
	 4rZw1UWt9RRzTvtHcrtzxCBtH885c2smkWMt4s/W5V68qSTBZevcQ5FfIe2hqvkDQC
	 1OIqNFwXMM4HQ8F4e9o1WARU6ZVkWB/KGn1jxCmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Garland <minimelkav@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 362/497] ASoC: amd: yc: Add DMI quirk for Acer Aspire Go 15 (AG15-21P)
Date: Tue, 13 Oct 2026 13:38:49 +0200
Message-ID: <20261013112916.497116719@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Michael Garland <minimelkav@gmail.com>

commit d0cb7a7b2a490c381ad97f53155d02a748b60dea upstream.

The Acer Aspire Go 15 (AG15-21P, board MDC Herbag2_MDU) has two PDM
DMICs connected to the ACP. The BIOS does not set the AcpDmicConnected
_DSD property, so the acp6x machine driver never registers the DMIC
card. The existing Herbag_MDU entry does not match this board name, so
add a DMI quirk for it.

Tested on BIOS V1.11: the acp6x DMIC capture device is registered and
records audio on both channels.

Cc: stable@vger.kernel.org
Signed-off-by: Michael Garland <minimelkav@gmail.com>
Link: https://patch.msgid.link/20261005-acp6x-herbag2-quirk-v1-1-a1f2683d758f@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -699,6 +699,13 @@ static const struct dmi_system_id yc_acp
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "MDC"),
+			DMI_MATCH(DMI_BOARD_NAME, "Herbag2_MDU"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "System76"),
 			DMI_MATCH(DMI_PRODUCT_VERSION, "pang12"),
 		}


