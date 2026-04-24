Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2DA179A3;
	Fri, 24 Apr 2026 13:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777037741; cv=none; b=RNsKt5o2eCtTLRitpOWkJ9kmDSvMyCG9e257nmtIqvKyEcRJZdzLED+l7j9IyOxvxPkMS3kCy7DxrrEYe83JMhO5JIoRURzz/28QvWSLeMRXVirrtrlzlAUOH+oerdOt/Y8RwkPc5gKhV1c+W9i+vFZgjJnbW38SV911sGgFLWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777037741; c=relaxed/simple;
	bh=XSKy4LBX/oAkUv7SZO8PUJ7tXQEfaupJRThjqfqNw44=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cDHVyu09Acqu32ct2YfAlSwHh4MbS7UHQ3GIt3MFYNPNs/g/C3XEZMJsmsobx0hcHv02oxSBFyxgpgXEBm7tEuMnbAGFfhlh81rNsc+OnDH1XMLHkAVZdpkuwfuOXmUEDs1f7RjG2lqUdFgbyXi2BTVH4gKpJUSxf/YDnOZWOmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1bCsA26R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1bCsA26R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11544C2BCB2;
	Fri, 24 Apr 2026 13:35:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777037741;
	bh=XSKy4LBX/oAkUv7SZO8PUJ7tXQEfaupJRThjqfqNw44=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1bCsA26RjSWkdjRUCm+i0dc2BZA44v+jZ81qC5YmXdgTE3qscFEZZEFjUctKsLv1D
	 Tk7oM8QHO8fnRpUg5/e1SXHbkvPX3/MGV8ws2eEk8KUbMouROhAU8THWTxDaLV70x+
	 KWe0AU5qLTlc65uMdNHW1HSYa3/XdvjmnGNzq3Ds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Gilson=20Marquato=20J=C3=BAnior?= <gilsonmandalogo@hotmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/166] ASoC: amd: yc: Add DMI entry for HP Laptop 15-fc0xxx
Date: Fri, 24 Apr 2026 15:28:52 +0200
Message-ID: <20260424132536.615388403@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gilson Marquato Júnior <gilsonmandalogo@hotmail.com>

[ Upstream commit 8ec017cf31299c4b6287ebe27afe81c986aeef88 ]

The HP Laptop 15-fc0xxx (subsystem ID 0x103c8dc9) has an internal
DMIC connected to the AMD ACP6x audio coprocessor. Add a DMI quirk
entry so the internal microphone is properly detected on this model.

Tested on HP Laptop 15-fc0237ns with Fedora 43 (kernel 6.19.9).

Signed-off-by: Gilson Marquato Júnior <gilsonmandalogo@hotmail.com>
Link: https://patch.msgid.link/20260330-hp-15-fc0xxx-dmic-v2-v1-1-6dd6f53a1917@hotmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 05aff73408d51..aaa0f44ef9e01 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -45,6 +45,13 @@ static struct snd_soc_card acp6x_card = {
 };
 
 static const struct dmi_system_id yc_acp_quirk_table[] = {
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "HP Laptop 15-fc0xxx"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0



