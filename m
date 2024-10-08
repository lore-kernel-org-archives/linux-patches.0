Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B41F1DE89F;
	Tue,  8 Oct 2024 13:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393426; cv=none; b=eJUKAXZQMS/Jc0WKU7XorNlR932CfrKPk7fiUcKx+K82z0qsIWW4zWyqOMUJum/BMeMog2Eg9zu0ISjVNzxFF7gWvnSjS8XKt8yu0zE+56wjdamvEc1jCmq4VDt4UrbKlA/4TKMc7NA8NOLIWFKkPkjQdsdmr8N+hOuGaKZAFfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393426; c=relaxed/simple;
	bh=O6ozEWII8R5j28ymJLImngx/U0e1er/7WptZ8wiBWwk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jF1Q0daxJsTCEJj5o7LpNmQeZ22u26nf24PgTNG3isgEhbJg3DwPk5tfigm149A3UGfS7k22CLEo7ihXQxdDd3KTw7PAQQkhA5fVap4wk6gQ90jRkiRuUXFjqAnhuV2AQalyk+r0fk/pZwwliYAAmVUUZZIP+f5YSP/EBTz6urQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RD9KYerF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RD9KYerF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70EB2C4CEC7;
	Tue,  8 Oct 2024 13:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393425;
	bh=O6ozEWII8R5j28ymJLImngx/U0e1er/7WptZ8wiBWwk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RD9KYerF5dbihR2fxdcKoTF7+JjxwE17S7Yq7ZZNv08rRkwg8pzw3Tfb2miXSgvDR
	 MaKMSyDFqbPY37+epaDg80r/J1yfG+kgoOSXKf6XfBXRPsbCyutlorcdcuaNYxzx2e
	 Oomon5ZUt3qyXTwAFP7sQl+ccz1e4NW4j0iymxAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Liu <liupeng01@kylinos.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 148/386] drm/amdgpu: add raven1 gfxoff quirk
Date: Tue,  8 Oct 2024 14:06:33 +0200
Message-ID: <20241008115635.252495083@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peng Liu <liupeng01@kylinos.cn>

[ Upstream commit 0126c0ae11e8b52ecfde9d1b174ee2f32d6c3a5d ]

Fix screen corruption with openkylin.

Link: https://bbs.openkylin.top/t/topic/171497
Signed-off-by: Peng Liu <liupeng01@kylinos.cn>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
index 8168836a08d2e..c28e7ff6ede26 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1172,6 +1172,8 @@ static const struct amdgpu_gfxoff_quirk amdgpu_gfxoff_quirk_list[] = {
 	{ 0x1002, 0x15dd, 0x1002, 0x15dd, 0xc6 },
 	/* Apple MacBook Pro (15-inch, 2019) Radeon Pro Vega 20 4 GB */
 	{ 0x1002, 0x69af, 0x106b, 0x019a, 0xc0 },
+	/* https://bbs.openkylin.top/t/topic/171497 */
+	{ 0x1002, 0x15d8, 0x19e5, 0x3e14, 0xc2 },
 	{ 0, 0, 0, 0, 0 },
 };
 
-- 
2.43.0



