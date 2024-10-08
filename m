Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE2E165F08;
	Tue,  8 Oct 2024 12:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728390143; cv=none; b=pAZNQ7HL23Tyzww/3Xpo6woZ6lvb6cbYfxhEQ33NM8lswY33rXXQNIXSvqJVj6x2v1ETHY+XOghKhWY9T3F4V2fOVaGKrjkJ9dSmwfWZ8/4hCuHF7NtbLgUMuQY0xxbHsBbp+b9FL0I2VeXoNbu50EhufofGkjSoaJGlzkrkHz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728390143; c=relaxed/simple;
	bh=ETBOntY3KhK+ghs7zzqPuQ3qBuYnlFmx/Pqnz0vk4XQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HBcMkzc9eQ2A6vT3UHhyzFPKLoc8Tgc/OIskk+LTkxmOCGmhP/SMqzydCKxEf85oMkuMGk4uxzFZ1Wg6wT9TDqPOvRxGi8dHtnA1K5PLtHrRD7SQGmph/6AQHUjXWK/MBUoTjXrBDUXH3cyQBbv9uLQgJwWo5M3A70F4PfDnWVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iihNEx3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iihNEx3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12E5EC4CECC;
	Tue,  8 Oct 2024 12:22:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728390143;
	bh=ETBOntY3KhK+ghs7zzqPuQ3qBuYnlFmx/Pqnz0vk4XQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iihNEx3i1F1dRtG3npGUju6Cq8yV50D24RJLhs7vYfMqtuN5gbuhSEIGMb2QjbAJE
	 k/8H/1mygnzPm/FCNWuxEndglHuVKpncVQ2heHf++zvmT2K5VI49IWaLL6pdZ0zdiN
	 kNdu2ATuY/9xsH6oRxxWmkOs6s9+dIrfK8RgWAVg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peng Liu <liupeng01@kylinos.cn>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 204/482] drm/amdgpu: enable gfxoff quirk on HP 705G4
Date: Tue,  8 Oct 2024 14:04:27 +0200
Message-ID: <20241008115656.338541489@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index c86a6363b2c3d..0594eab666a9b 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c
@@ -1174,6 +1174,8 @@ static const struct amdgpu_gfxoff_quirk amdgpu_gfxoff_quirk_list[] = {
 	{ 0x1002, 0x69af, 0x106b, 0x019a, 0xc0 },
 	/* https://bbs.openkylin.top/t/topic/171497 */
 	{ 0x1002, 0x15d8, 0x19e5, 0x3e14, 0xc2 },
+	/* HP 705G4 DM with R5 2400G */
+	{ 0x1002, 0x15dd, 0x103c, 0x8464, 0xd6 },
 	{ 0, 0, 0, 0, 0 },
 };
 
-- 
2.43.0



