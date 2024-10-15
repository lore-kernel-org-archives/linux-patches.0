Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A993DABE9;
	Tue, 15 Oct 2024 13:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728998071; cv=none; b=YrLMQAG1jYrZAV/Kuq4JdZvdFkryr8DEoii3yuP0jTpEYSL/wYVKSKwhiVjFH3uJXF5TCNHxGTMDVp4SwmLSCaX/mdJ50sgW9SRzDttL6zYj5cqiTYiDbNkgjyJsCw9dO/1Z9FKPenxCbQ0ZErowfwLgospEiqkZmEdRF0hLZqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728998071; c=relaxed/simple;
	bh=0zRdQ+HTS/lY+SKUQ1yqwBVgzGze+8+p2jk9rHZyunU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WuqbjPMjqomEsWN7XycxFQoQhOYhr9W3/myULcTRRlBhmRg68X7eHl5E3YGN8FC7ysvK4GmjGrDtnpcRXIiRkWfQK3Fj+v105EvrZcA5F5aWo8Nmyx4vvJLW9Hodml0omWi+Wi2fGUSRvNvvaYQ8etfeiolvgA+o0xj+pEd2aoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tjz51rp3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tjz51rp3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48789C4CEC6;
	Tue, 15 Oct 2024 13:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728998070;
	bh=0zRdQ+HTS/lY+SKUQ1yqwBVgzGze+8+p2jk9rHZyunU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tjz51rp3EaaFTIztg65rDmHtf5/ywMA76508OHd5h4X3G1eWqL4tnX6N0c9qV3R3C
	 UYqppwTh8kefrhzkv9MCQMi+F6n6wu1a+DHjzf+4th1MHbfb/8dJFiFyEIMhVnHpP8
	 5ib2+t3CD/n8mTyqCNnmYbojdscHcdrzck4SWaqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Liu <liupeng01@kylinos.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 339/518] drm/amdgpu: enable gfxoff quirk on HP 705G4
Date: Tue, 15 Oct 2024 14:44:03 +0200
Message-ID: <20241015123930.056836463@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Liu <liupeng01@kylinos.cn>

[ Upstream commit 2c7795e245d993bcba2f716a8c93a5891ef910c9 ]

Enabling gfxoff quirk results in perfectly usable
graphical user interface on HP 705G4 DM with R5 2400G.

Without the quirk, X server is completely unusable as
every few seconds there is gpu reset due to ring gfx timeout.

Signed-off-by: Peng Liu <liupeng01@kylinos.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 3f320ead85d12..432c24f3c7981 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1252,6 +1252,8 @@ static const struct amdgpu_gfxoff_quirk amdgpu_gfxoff_quirk_list[] = {
 	{ 0x1002, 0x69af, 0x106b, 0x019a, 0xc0 },
 	/* https://bbs.openkylin.top/t/topic/171497 */
 	{ 0x1002, 0x15d8, 0x19e5, 0x3e14, 0xc2 },
+	/* HP 705G4 DM with R5 2400G */
+	{ 0x1002, 0x15dd, 0x103c, 0x8464, 0xd6 },
 	{ 0, 0, 0, 0, 0 },
 };
 
-- 
2.43.0



