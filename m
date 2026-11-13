Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585962;
	b=N1KeNDmIPxKrfNbgWpQRu7Cf2eIYybTLpII/Y7PdFvWzHaHOU6t/NmAR4GWSoYoxjHFS
	 xSvKr9ZctiGIK7dUrJjQ453iQ7FjbKrEfJMEVqyvDgWLVIEPnYYRhzcNYEvodZHzfN94k
	 LbcXQlVPEwnvhm6PWnjKDUEi3LphoUJvKQqYoO/1k31UaEdJzv0RSuHTKWEHfKkwWemgZ
	 TwkwwZ85vJT8JyRpNEggPi2CHAk/Wq+CJ6c9N1rLi/yq3C1TKeqCi2+X8JPHSE+/p+KJN
	 ywho6Zfc4FAdHgg6KXOhgmGltWNv362qcMn/LBKJGCK105YqIVKQ3a5qIHVIZQqIIBw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585962;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Ctekf4lmNivt2w+8R6beWFHC03jSbmHj6GANjs2MZdk=;
	b=wN9QPI6gsw3C48yECQPGZRVIFZIPT/0cDlRiF7nilZ8ldkILIQnSzra6LLyC2WaUTSrS
	 I3g32/NJ+qDwv81LWCAdZCYuE1aNo5BHKULPzcmp2BAXoGRJG98duFM9GmHSZVLGLMgd6
	 PCujgmP6EZu85eoKE+cGZqmdCf3qpXG8bFyn1ElSQqwMHSvjxYqLSD9Hjpd0fh2KmvgDG
	 kZ85lTYLoiI+SKyH4jg+XASTyoGgOqEeoj9rVW5+EMmfIa3e69ZcPcQrHbZI43Tfx0PKz
	 PQ5NSOaL0rgO/pWv6klXsMT9U7aQub5HY4mK3dO3lHscIa0qLS3bKuW2kLrIlxqmIfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rKDMjBmk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7326076E27;
	Fri, 13 Nov 2026 16:06:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rKDMjBmk
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99DA11F000C4;
	Fri, 13 Nov 2026 16:06:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585962;
	bh=Ctekf4lmNivt2w+8R6beWFHC03jSbmHj6GANjs2MZdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rKDMjBmkRY0XZjbabQlmE7X3BQmvWemu+RfC9DyV3ti+x8Ct69v5RgSK/EEUsPX3T
	 vzRUKlb0EFOZlLjusSdXF/bkcZXe06qmz31EUiQrWUs8PBiHK8scUIY3J/iWYpJyn/
	 PmYV/PQnePWNkiQHqmHl68vmHzlAMToG9RXIzOBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gianluca Balboni <gianluca.balboni06@gmail.com>,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 507/507] ASoC: amd: yc: Add DMI quirk for HP OmniBook 3 Laptop 16-by0xxx
Date: Fri, 13 Nov 2026 10:53:31 -0500
Message-ID: <20261113153814.429711929@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gianluca Balboni <gianluca.balboni06@gmail.com>

[ Upstream commit 1e73257dff33ff851af60d5bb00d73893a8b6dc8 ]

The HP OmniBook 3 Laptop 16-by0xxx (board ID 8EE3) has an internal DMIC
connected to the AMD ACP6x audio coprocessor. The BIOS does not set the
AcpDmicConnected _DSD property or the _WOV method, and the board is missing
from yc_acp_quirk_table[], so acp6x_probe() returns -ENODEV and no DMIC
capture device is registered.

Add a DMI quirk entry for this model to enable ACP DMIC support.

Cc: stable@vger.kernel.org
Signed-off-by: Gianluca Balboni <gianluca.balboni06@gmail.com>
Reviewed-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://patch.msgid.link/20261031102136.24600-1-gianluca.balboni06@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
[ sashal: Adjusted DMI table insertion context to place the unchanged entry after 8BD6 because the upstream 8DC2 entry is absent. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 1be8504571ad3..96b0bfeddc061 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -745,6 +745,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "8BD6"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HP"),
+			DMI_MATCH(DMI_BOARD_NAME, "8EE3"),
+		}
+	},
 	{
 		.driver_data = &acp6x_card,
 		.matches = {
-- 
2.53.0



