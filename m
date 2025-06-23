Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEDFF221DA8;
	Mon, 23 Jun 2025 21:59:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715946; cv=none; b=LSsxHazHo5E1A9q4PwcDZMzdirim3mtsHpYhfbM+MyVeaee0kbGP2JzI8itprHnCn4Sh+ZnVykdxY43wg5QrmdxLKouH0NmuPZec09r9kR+A0T3DMyWzKP7wdhAhBFSB7PfpcFukE4emXoujSV6r91+HmDlQkDeutihNJPswPZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715946; c=relaxed/simple;
	bh=ZDlrXdeBE5noizLqmN/avXc5w5AqRPyM8Hz06s5a3w8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C3LQVMaRIGMqqv6p3PkebiCF5F4A/dJif6J+NpINli0O5sy0HHNVyqcwNIJPUJljPiGbE9G6ytSqrpVdXwZ4KxEd+pAoBRW+KhlhQjhOT4wjnR57tZKC/ldYxoCvM8bTTydp7Kp/NH8DdLuEycwvzAlw7m8E5mUDMLcVFEg+fhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WYdRVESh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WYdRVESh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465C3C4CEEA;
	Mon, 23 Jun 2025 21:59:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715946;
	bh=ZDlrXdeBE5noizLqmN/avXc5w5AqRPyM8Hz06s5a3w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WYdRVEShOBN1Yqte373Tfm03nqrDNaChBox1ICIDrgrG6iqYJGd2ccJvnjPy88VwI
	 wN4w/wKl37bJy+5olnbvIkkbCDQ5Nh9P/25/aCiwGwVJwoFsDm/0UhHYHOz3MxtFrs
	 l3enC9PZsrDpyAHO2enurQtxgkEx1GF+YMGCehtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 293/411] drm/amdgpu/gfx8: fix CSIB handling
Date: Mon, 23 Jun 2025 15:07:17 +0200
Message-ID: <20250623130641.028027955@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit c8b8d7a4f1c5cdfbd61d75302fb3e3cdefb1a7ab ]

We shouldn't return after the last section.
We need to update the rest of the CSIB.

Reviewed-by: Rodrigo Siqueira <siqueira@igalia.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
index e0302c23e9a7e..4f54b0cf51336 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
@@ -1277,8 +1277,6 @@ static void gfx_v8_0_get_csb_buffer(struct amdgpu_device *adev,
 						PACKET3_SET_CONTEXT_REG_START);
 				for (i = 0; i < ext->reg_count; i++)
 					buffer[count++] = cpu_to_le32(ext->extent[i]);
-			} else {
-				return;
 			}
 		}
 	}
-- 
2.39.5



