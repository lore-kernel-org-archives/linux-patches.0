Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB4CB1DF260;
	Tue,  8 Oct 2024 12:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391963; cv=none; b=UGhdfcyvmZB4m0qw6JlpEVxyaufnQbSLqWpI4Jf9sXbrRP+kHDIy3mvqxr4vNxgKicMDdxp1YIkaAkobCt5bH3+h30Kgm6/fWCPjEbVSq3sEXLzwFPQRe+QtvJge6/N37sqf/h8Q3UQ6LZajcdiLRmWZvOH8DsTYd/6e7o8QJ34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391963; c=relaxed/simple;
	bh=7bUgKVIqzHyzZVPO2mO+qPA7L0DRxWWrRhhGJDUL6Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lm0KoNDaGCizYtCtpa6IjacfusXDHkprPcLxeGO1WKr8aMAnvVqCGNDNF5/YS4OwVwNYrJlEzFl3lHaSM5baUdrwejWq/qgZVJ0hbFbc190YYCCHO7O9c4RH3z4Xh+MP3bBEe9jdDcQTLdtSxPXxyMKbRZAlwZW7pRI7joU/LPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G+MaWvUB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G+MaWvUB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B497C4CECE;
	Tue,  8 Oct 2024 12:52:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391963;
	bh=7bUgKVIqzHyzZVPO2mO+qPA7L0DRxWWrRhhGJDUL6Kw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G+MaWvUB9ZeV0ZJa39+bN0S7d0C2gXzPmyD7hYgnUEWdauJJjXeGBsbbxopbDcFVt
	 R/4hU9il9GbAwPpe0KlFZry06xgsxo1yjKwiPqfcGxSfoJP6A/mxcoYrcSgttcGk+Y
	 h5BzHGVaDy4Os9z0Aq5AaKSUDcK5wv8GZJUO9lbQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Liu <liupeng01@kylinos.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 244/558] drm/amdgpu: enable gfxoff quirk on HP 705G4
Date: Tue,  8 Oct 2024 14:04:34 +0200
Message-ID: <20241008115711.941240960@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 9360a4425c4ae..fc4153a87f947 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1303,6 +1303,8 @@ static const struct amdgpu_gfxoff_quirk amdgpu_gfxoff_quirk_list[] = {
 	{ 0x1002, 0x69af, 0x106b, 0x019a, 0xc0 },
 	/* https://bbs.openkylin.top/t/topic/171497 */
 	{ 0x1002, 0x15d8, 0x19e5, 0x3e14, 0xc2 },
+	/* HP 705G4 DM with R5 2400G */
+	{ 0x1002, 0x15dd, 0x103c, 0x8464, 0xd6 },
 	{ 0, 0, 0, 0, 0 },
 };
 
-- 
2.43.0



