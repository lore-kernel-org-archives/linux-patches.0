Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1836B33F59D;
	Sat, 30 May 2026 16:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780157496; cv=none; b=N/1w4R/bUkoTKMaRnk3fRxYM7j3mq8zrLiGj+ghLVQXRGtYYSoo8JC/HtdmnWfcpCAQ8bwAG/lzxBbDsnDa3kyxOO/h2AbKnObvhPxgM05CegerO0Q0n3N+U3lVJ3u4QPR+99cagBNWMgcA5pplo5lap2wci30gs8PHhiLAvDo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780157496; c=relaxed/simple;
	bh=fFIINafoX0Al2f7kT6onb8KxbLGc5S0Zp/XXWG3brV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SbA1UvV1qRuYc2SORbVSsm937pY0bkkdP1TfEq4ikXa6w7gEv3QmsFM0FTXSM04awGqSe6c8QlaQszP5D63TZDBxj8mu1iIZ11oGuleOXHyGcqU7ABmvzhNVp3olYPU5W212cC+dUH/WXVUzHFNIL6CKFRlFaDRgGp4SUwOSbJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fVeoui2X; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fVeoui2X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E0F91F00893;
	Sat, 30 May 2026 16:11:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780157494;
	bh=hhqVy4uoTZS0IqkvNwrOORAsjl9eJ8HbL9n311+ggF0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=fVeoui2XDmm7yL5NFnxsP+nHa7DSSZOOolTYj85BDy6NToVFIIXZ0RCuIRd0RDwg5
	 ZBUx3zh3BHNI1bns4rJLvOHsQ0FtMdrdUxPhd8aBo/SI65FjmESHOkn5Ano8iocRdF
	 qFbaoQSyuD/evnBr4St8BZqPX0HpO67I+yeUw5Xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vee Satayamas <vsatayamas@gmail.com>,
	Zhang Heng <zhangheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/969] ASoC: amd: yc: Add DMI quirk for ASUS EXPERTBOOK BM1403CDA
Date: Sat, 30 May 2026 17:52:05 +0200
Message-ID: <20260530160300.534009046@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vee Satayamas <vsatayamas@gmail.com>

[ Upstream commit f200b2f9a810c440c6750b56fc647b73337749a1 ]

Add a DMI quirk for the Asus Expertbook BM1403CDA to resolve the issue of the
internal microphone not being detected.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=221236
Signed-off-by: Vee Satayamas <vsatayamas@gmail.com>
Reviewed-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260315142511.66029-2-vsatayamas@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index 991f8777cc859..be510328c5a0c 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -563,6 +563,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "PM1503CDA"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "ASUSTeK COMPUTER INC."),
+			DMI_MATCH(DMI_BOARD_NAME, "BM1403CDA"),
+		}
+	},
 	{}
 };
 
-- 
2.53.0



