Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CAAA308F32;
	Sat, 30 May 2026 16:17:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780157870; cv=none; b=Ejza2XiuoJ1ZJYDxh/wUWNtkKv5d6R2KNC+33wH9Mu9jeMZ/nuM0tU7qDYJJyYyHAJ0i/O4mWwzg03yKOkDiI6u0EAoVipHShq4I4K5BKUL8CuYwgr2dhOlvXBT8fxj1TcyNGY1qpK2WCYaAcMWi+N+r6fCyPsgBhoX1VapvtlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780157870; c=relaxed/simple;
	bh=znn8WETjHZ0cDEvZAL8aOIuqk4cUYQj5FL1Yn4QHmfw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzgAAp4JLuqTv0TrdsCwWfWjdyfd25FmSBOapMzzv/065RxFyuOPSSkND85pdLPeck0fdHtuoLSqYDf96TdY+ejxCgLxoHLa2dfNfe5HPRQEgFjM7J6c4W38yAxwWqZnuYHkH/exotr+YdeVjmG8nGGzDYWuBOolmceIFRmotPg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWnqt9mj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWnqt9mj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B64501F00893;
	Sat, 30 May 2026 16:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780157869;
	bh=OY1fguQar3dIj4/z98NMgu9u3tzKnFxTcWq0D/PZUHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dWnqt9mjhix1MDQc1qDaHJ4AY42iIJZqDUIKnFpvdjh+vKObUOENI4XssyZSIUXch
	 0J9gSeR9a0jn8KW2mhc4LSDDSkPGXutBmYicRG4Jf+cVmLcx0x45ZgZH5NSq8s3kXy
	 T2pVO/pRhaYy2Trgm9aadroYe/TLW8J7nnYnayHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Heng <zhangheng@kylinos.cn>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/969] ASoC: amd: yc: Add DMI quirk for Thin A15 B7VF
Date: Sat, 30 May 2026 17:52:09 +0200
Message-ID: <20260530160300.634623380@linuxfoundation.org>
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

From: Zhang Heng <zhangheng@kylinos.cn>

[ Upstream commit 1f182ec9d7084db7dfdb2372d453c28f0e5c3f0a ]

Add a DMI quirk for the Thin A15 B7VF fixing the issue where
the internal microphone was not detected.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=220833
Signed-off-by: Zhang Heng <zhangheng@kylinos.cn>
Link: https://patch.msgid.link/20260316080218.2931304-1-zhangheng@kylinos.cn
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/amd/yc/acp6x-mach.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/amd/yc/acp6x-mach.c b/sound/soc/amd/yc/acp6x-mach.c
index be510328c5a0c..d650091d3f302 100644
--- a/sound/soc/amd/yc/acp6x-mach.c
+++ b/sound/soc/amd/yc/acp6x-mach.c
@@ -570,6 +570,13 @@ static const struct dmi_system_id yc_acp_quirk_table[] = {
 			DMI_MATCH(DMI_BOARD_NAME, "BM1403CDA"),
 		}
 	},
+	{
+		.driver_data = &acp6x_card,
+		.matches = {
+			DMI_MATCH(DMI_BOARD_VENDOR, "Micro-Star International Co., Ltd."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Thin A15 B7VE"),
+		}
+	},
 	{}
 };
 
-- 
2.53.0



