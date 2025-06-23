Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B196199FBA;
	Mon, 23 Jun 2025 22:21:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717297; cv=none; b=pNrVc/NXh4ai5szbVEyuiQEVOswV59EtYmTPO4Sdv5LBOgg0pVVXr13oZVjetQp4f67Zkh0FssXtSwXrcC5lnLmYcCt7f3huq6/h/NuunMxTYaBuki9NeCfI7i+ablXUxNy63moQpFD3t+3cA3p2tEUwz4WTmVdVXuHJY4mEbwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717297; c=relaxed/simple;
	bh=FaALA4ius8zCVnyifv0jU7dnA0O/2DzBJqtSEpmUX2s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tK9EhQt+1WabGMrc7+RrIg4isyQycsL9R8TQs6XvnPpVZVT8ziJD58YtIlhro0VzTfymK5kgsqPnGWOjUWWmcGmzqKea6gKUcUfWnNZLGXqZsMkAkgPQK/0n8q70JBF0LJ/Ki1Q23KSR8e/iFehmEsLB+nfJIRJrlm0upzqKJyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=atcz+HME; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="atcz+HME"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94578C4CEEA;
	Mon, 23 Jun 2025 22:21:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717296;
	bh=FaALA4ius8zCVnyifv0jU7dnA0O/2DzBJqtSEpmUX2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=atcz+HMEEoAK1HrOS5Q2GYAbLqE8qMuQD1GieB670tXFzy+kSFz7wq4a2JBve4EOz
	 LWhfNTkflBU6HVSCGkOleOOmq9NtgcK9J4Kx1FVpNqWd9r8KwAtgAgTvktlQYe9+Kt
	 JzBw7OnmDc638pJtlPHCzwUbGPe3/UUSptLCutN4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Connor Abbott <cwabbott0@gmail.com>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 355/414] drm/msm: Fix CP_RESET_CONTEXT_STATE bitfield names
Date: Mon, 23 Jun 2025 15:08:12 +0200
Message-ID: <20250623130650.847514247@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Connor Abbott <cwabbott0@gmail.com>

[ Upstream commit b1c9e797ad37d188675505b66a3a4bbeea5d9560 ]

Based on kgsl.

Fixes: af66706accdf ("drm/msm/a6xx: Add skeleton A7xx support")
Signed-off-by: Connor Abbott <cwabbott0@gmail.com>
Patchwork: https://patchwork.freedesktop.org/patch/654922/
Signed-off-by: Rob Clark <robin.clark@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/msm/registers/adreno/adreno_pm4.xml | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/msm/registers/adreno/adreno_pm4.xml b/drivers/gpu/drm/msm/registers/adreno/adreno_pm4.xml
index c6cdc5c003dc0..2ca0ad6efc96e 100644
--- a/drivers/gpu/drm/msm/registers/adreno/adreno_pm4.xml
+++ b/drivers/gpu/drm/msm/registers/adreno/adreno_pm4.xml
@@ -2260,7 +2260,8 @@ opcode: CP_LOAD_STATE4 (30) (4 dwords)
 	<reg32 offset="0" name="0">
 		<bitfield name="CLEAR_ON_CHIP_TS" pos="0" type="boolean"/>
 		<bitfield name="CLEAR_RESOURCE_TABLE" pos="1" type="boolean"/>
-		<bitfield name="CLEAR_GLOBAL_LOCAL_TS" pos="2" type="boolean"/>
+		<bitfield name="CLEAR_BV_BR_COUNTER" pos="2" type="boolean"/>
+		<bitfield name="RESET_GLOBAL_LOCAL_TS" pos="3" type="boolean"/>
 	</reg32>
 </domain>
 
-- 
2.39.5



