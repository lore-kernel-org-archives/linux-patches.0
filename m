Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F574EE858;
	Tue, 13 Oct 2026 11:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791891984; cv=none; b=D8/CrxBga8LyqF+xYhjbw1pwZXlkgHTOfZ9H9VBPWBWdBzYjI/3XW/iqD1ZsOQZTpY00qZ236rB49cRypHZYrePRFCrEcH33MI5WLeTn9Oaj+hh51iV+6FtEogd52Iz+Z0mHW3/sCujx7Jy4z/QTTZa86SR8r9cuH1VGyNnVdno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791891984; c=relaxed/simple;
	bh=iro2Z4CVlwyacRK7+jSH6TUlXNPfBgjh93MtvnAMDXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7k/BRl6FOO5x5HA7N0NYOW1Ax+fNcyxCtoInl+bGyUXpvHxSxAK0jrFu6YrgYx2rwnwOJgCEFTYzjjEK5L+cPDpBDLtEL67akZLHmvssjR3OWemNe4POaHQSsvmf5g2tc6TSGaoQU/MJldyvxVCec4wcalr1osPRBhuoP8ZOAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pkqAZIC/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pkqAZIC/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F881F000FF;
	Tue, 13 Oct 2026 11:46:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791891982;
	bh=r9y1nEW7YwAzwiKEXblA3sSl1Pn19+Lu45O8T8b4UUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pkqAZIC/2I669el05DgkYAzSQnI6A0TrOq5FSu+kn3JSqIaIjP4hoXv+ooSG0Ybap
	 a9hll4XLfTTMhoZIgF3/pZuifVnAPhzmJJqRDa+jSrFUuXqnxSd5fy7CdkBHH0HCM9
	 dwdc50Y9XG3BJWK8LQCX7R4HtgCgkdd6iK4Bedq4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Garland <minimelkav@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 021/281] ASoC: amd: yc: Add DMI quirk for Acer Aspire Go 15 (AG15-21P)
Date: Tue, 13 Oct 2026 13:35:37 +0200
Message-ID: <20261013112855.564502163@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -762,6 +762,13 @@ static const struct dmi_system_id yc_acp
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


