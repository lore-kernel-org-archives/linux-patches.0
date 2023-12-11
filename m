Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C22151C2D;
	Mon, 11 Dec 2023 18:51:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hX1oFMEh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6C92C433C7;
	Mon, 11 Dec 2023 18:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1702320719;
	bh=xqhAL008a5tdJHh3x5ZIFMYwVab95ZUnJqT8JEwIE0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hX1oFMEh+OgHI/8hjmbQ3WJ+WNfnh7+sVCkQLP4LKkXm6ZJuk+He4gt1daU7rnVyh
	 pSJrJgPO8IYfjk0CUk9cw7o/I4F09l+fw3u2Pz6YJNN1E5DS44139UKU/qkym/XoYW
	 2i3eMFevFxv/VoD1iorqzEodo2YRiYWPPwTN/NLk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Candice Li <candice.li@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 165/194] drm/amdgpu: Update EEPROM I2C address for smu v13_0_0
Date: Mon, 11 Dec 2023 19:22:35 +0100
Message-ID: <20231211182044.014619623@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231211182036.606660304@linuxfoundation.org>
References: <20231211182036.606660304@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Candice Li <candice.li@amd.com>

[ Upstream commit e0409021e34af50e7b6f31635c8d21583d7c43dd ]

Check smu v13_0_0 SKU type to select EEPROM I2C address.

Signed-off-by: Candice Li <candice.li@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index 47406456e2707..f5f747cfe90a1 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -167,6 +167,12 @@ static bool __get_eeprom_i2c_addr(struct amdgpu_device *adev,
 			control->i2c_address = EEPROM_I2C_MADDR_0;
 		return true;
 	case IP_VERSION(13, 0, 0):
+		if (strnstr(atom_ctx->vbios_pn, "D707",
+			    sizeof(atom_ctx->vbios_pn)))
+			control->i2c_address = EEPROM_I2C_MADDR_0;
+		else
+			control->i2c_address = EEPROM_I2C_MADDR_4;
+		return true;
 	case IP_VERSION(13, 0, 6):
 	case IP_VERSION(13, 0, 10):
 		control->i2c_address = EEPROM_I2C_MADDR_4;
-- 
2.42.0



