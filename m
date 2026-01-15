Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E61891A08AF;
	Thu, 15 Jan 2026 17:09:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496981; cv=none; b=pFOWLhhoGiiVhv92xcvaCmJ6xGxwXJEf2r/ETDClTD5KurIQvkpaX9b3qpg+gQzHFpzcwGC0T1u46ubyB68LUjWtrxbSjaYlrYMELifGnzSEjQWr8LT0tacEZnwevl2mOGaCni8enR8GdAovs1TpcpPqRs8KTK3avfKXq62hwro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496981; c=relaxed/simple;
	bh=cxN7eSLPb8EYAEB8wL4BjPhJJQhxYvCMw/EKRF7zNqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WKOjFBiszmXX76FtyGMMcqqEz9rcQ6VuYZWf8OSgYUbai/vXxxVrPjYKWtbs9c/OVtYgpnr85bhITpOOoLStS3fIhQUWZCrJjj9x2GTf9/z8ua/GqxeOTCYZ4gJnxJjTTA7DDydWBpvdiLi3pTgFNoEQcJzNf/WbI3LfYoRSTJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2SrKGevK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2SrKGevK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70A5BC116D0;
	Thu, 15 Jan 2026 17:09:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496980;
	bh=cxN7eSLPb8EYAEB8wL4BjPhJJQhxYvCMw/EKRF7zNqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2SrKGevKRv7joo/6QXZNiB9t4WsaQ1N4NtWXe5AibvCkVtuq6HC2Sc078UtakHPlp
	 YDBeW8kM40+Ho7vVeDabNS7u8BBNV3KZS7W0gGfo35zZSOCUEcSUAVG3y8aEBGuJd6
	 RK2uulW6dUls+iItkNMchMue5VX8OgHYUm6vDKLg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Elantsev <elantsew.andrew@gmail.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 84/88] ASoC: amd: yc: Add quirk for Honor MagicBook X16 2025
Date: Thu, 15 Jan 2026 17:49:07 +0100
Message-ID: <20260115164149.356104656@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Elantsev <elantsew.andrew@gmail.com>

[ Upstream commit e2cb8ef0372665854fca6fa7b30b20dd35acffeb ]

Add a DMI quirk for the Honor MagicBook X16 2025 laptop
fixing the issue where the internal microphone was
not detected.

Signed-off-by: Andrew Elantsev <elantsew.andrew@gmail.com>
Link: https://patch.msgid.link/20251210203800.142822-1-elantsew.andrew@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 24919e68b3468..54dac6bfc9d18 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -654,6 +654,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Bravo 15 C7UCX"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "HONOR"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "GOH-X"),
+		}
+	},
 	{}
 };
 
-- 
2.51.0



