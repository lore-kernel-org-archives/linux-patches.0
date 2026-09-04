Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A9F34EF15;
	Fri,  4 Sep 2026 05:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499605; cv=none; b=pTmlXWExb8JSe05A+em3YiHC+kRSxgOj9vmqNTq2tGhyiAy9e2PGxgcD0NOp/Ua14u4Q+M0CjtDTQtUNfqQJQ8VyuzGZxrJHRYGVEV0FcMBhYG3MGsrZL6ZEac22nzRCLo7AkcAHjZtUeCwL4Tb8ZELZ5XTV5C5LADGFpY3TPDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499605; c=relaxed/simple;
	bh=r1epMSMMMVO78ttHWnXf3UB+0IMx1S59TQLdwnhrkTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jDY9DidyU5O7MsZQR+Yy0zkgMnhtxrRENdivFQfzpSN1pf7KcREpKI77ORKTq4XH47lBfiHc/Zz9+lR5hcU2udEmnpT52xJWG6+HyQNM8v42hqjRSfDvBlLGqADvj3Qjga7GKfjJZMHOwa6Z3Dn7AhDOeULDbRJPQ5Xb/mKSGSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QUZfb7EE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QUZfb7EE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCD4C1F00A3D;
	Fri,  4 Sep 2026 05:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499604;
	bh=Owh+sRQhJ4tan5mboIvA3eT9mkmfs3OKvtV7FR1h+sY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QUZfb7EERo5FptnVXjW2MH6SIiem9XBFJXUhFnwPOrwYpQAygvNaz1uyTlhKhU+Fm
	 zjj2bHVJ9T/CdNag9LCjDsdr2XbVoCFAqgzwAoZajgQzGT8/6YcIZI0GQvQr+vBw9Z
	 og9/6hsbuyWyl8ExLJLi4fcb4a9gNVsWRhkGGN3M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christopher Tolang <christophertolang@gmail.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 476/713] ASoC: amd: yc: Add DMI entry for MSI Thin A15 B7UC
Date: Fri,  4 Sep 2026 06:57:24 +0200
Message-ID: <20260904045814.493869565@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

From: Christopher Tolang <christophertolang@gmail.com>

commit e2aa5ad3be41accfcdcccc62348f21af7baa3a38 upstream.

This model requires an additional detection quirk to enable the internal
microphone.

Fixes: fa991481b8b2 ("ASoC: amd: add YC machine driver using dmic")
Cc: stable@vger.kernel.org
Assisted-by: OpenAI Codex
Signed-off-by: Christopher Tolang <christophertolang@gmail.com>
Link: https://patch.msgid.link/20260823113221.19744-1-christophertolang@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/amd/yc/acp6x-mach.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -846,6 +846,13 @@ static const struct dmi_system_id yc_acp
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Micro-Star International Co., Ltd."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Thin A15 B7UC"),
+		}
+	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
 			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
 			DMI_MATCH(DMI_PRODUCT_NAME, "M7601RM"),
 		}


