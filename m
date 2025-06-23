Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2755E1EE7C6;
	Mon, 23 Jun 2025 21:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714787; cv=none; b=aiDi5coyjPpbl+vzSE5FZZcNZXbu1jEwWbkN0ttSRpSUJNiI9yHZpSQuBGOJsnHDoCbVBBQ9/Q8BscYTbSUX4Sb5HfgELI40pEz6q+CLEK8NUbY54CGLc5DlM59gEnWsu2eSQ5bZhPaMp3v7JKvDfBiudurQe71gDoaBC7a8LTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714787; c=relaxed/simple;
	bh=ROzTJh6cCkEnfd+K71nipFv0C9f7IFG53o77G6X469w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=soQ/M1njX8EZQb7MOSLIzJn4hIwEeM1QlsdwM6/+t/ASdJvNlznAw8Xnta5l63VH9ZcQA9+dmigWB+LPNqzsTXCQ+o+73wvbqrrDPrkuIHJBBVZ0a1I8T7lpNyGV9Jd97Ub5rcqioHSuFoyHKGvtwE7if3jZDmZw9pXfexKepx0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YlU3oV5i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YlU3oV5i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B43CEC4CEEA;
	Mon, 23 Jun 2025 21:39:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714787;
	bh=ROzTJh6cCkEnfd+K71nipFv0C9f7IFG53o77G6X469w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YlU3oV5iPcP6RFp3tIHMFDLX1uZORrzVmscTjU7/0X/z94JXrg0XIk3NMtqm2Wync
	 fJWmO6yd6POG7G1GBR6cjjcpGd1IMRThZVVM/gHh+7n33TxAwL1hMKbAXKQQaJ0Cyj
	 kBIEJyZ8xicVp3UGViS0wgAeomVPDJJ1Wk8tmDIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rodrigo Siqueira <siqueira@igalia.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 238/355] drm/amdgpu/gfx8: fix CSIB handling
Date: Mon, 23 Jun 2025 15:07:19 +0200
Message-ID: <20250623130633.904326120@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.716971725@linuxfoundation.org>
References: <20250623130626.716971725@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index c36258d56b445..0459e7b71945c 100644
--- a/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/gfx_v8_0.c
@@ -1268,8 +1268,6 @@ static void gfx_v8_0_get_csb_buffer(struct amdgpu_device *adev,
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



