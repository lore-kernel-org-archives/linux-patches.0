Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795018149;
	b=0IVcc/oZj8jrrBTHCfAWlh/Z9Blp+qW67Ww6bhNsyeyNsdm4Vo103ox/CiaMIhvE6Rsr
	 +eJpDM1PytG/ZJxbIyCeFDRXQp+Vo975/Orx0wV3f2Ton6B8uXWlXLznhzHjGE1BZK8wH
	 FOZMuzR7dqbqEZiAOXR6/HO1XJrPzQe23nrl8C/YN/Oo1QjVTuBKl0kxUbaRe4j+nMubB
	 lACMDEGZ0auy75Ez0L/IUNOCLY0u0UAUkSgfpzcdPwYlijpN/2YASDtrPeWn5GL2v1zuH
	 jqFr8ZZrKLv+FCBylB+/90fHJvP8RxhJjrBzh1jj7nCf5GpVEdCxs4p8Oam3AqRUs6w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795018149;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=4mnhEiRtXz5KR+466qpEgrbQV5Erx/lNC5ulLIy2bsI=;
	b=2wmCHf0XC6l2rS/VvN8t8K3bGc4ddfueCjSLmvfD5Qv+rz7ipwcxaIDdKBYh84BaZFWm
	 oF1/GedDaQyBD+j5/wpOdC4mf8SP8VRhW+VAr0i7PihZSqI5ywqpGffbR3dl/D7UjJKzu
	 eGYVQiDWjiayd0WgLNH8surJ04/j+T8g3+OzJ22BYyU5W9ie7MDhQAJFHCVi6igrepz3J
	 fup2Azj1BFLCJvF2YD2wFFHsJDG0F4o7UTykGK9PCHhUWAoX3/6e4dIxKWLRf38OplZ4x
	 W/5RBoT/tDgvy5h4L749ZRLgHaTuWNBaYrf3il9UEk3ZPxnh8wj9ZEGBJjas7jwxyQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dTdkvwRl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC582606A31C;
	Wed, 18 Nov 2026 16:09:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dTdkvwRl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52E501F000C4;
	Wed, 18 Nov 2026 16:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795018148;
	bh=4mnhEiRtXz5KR+466qpEgrbQV5Erx/lNC5ulLIy2bsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dTdkvwRlzXqzDstSZcBERfLqLNfuDkJqIl17AQRCgIi1zZmTDoRthJMFC+RLbt/5Z
	 CY6Ql9p4NMKnmwVjk9h/VU70+IzhnAD+JrjWHqcOk6FUktqv4XNRCVT7b3hNVULp71
	 WdZSezi15Os4GFUDIlymk3tMceEOhJUOCYgqE5Tk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	YiPeng Chai <YiPeng.Chai@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Tao Zhou <tao.zhou1@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1130/2651] drm/amd/ras: use __le32 pointer type to resolve the sparse warnings
Date: Wed, 18 Nov 2026 15:39:30 +0100
Message-ID: <20261118150328.694869902@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: YiPeng Chai <YiPeng.Chai@amd.com>

[ Upstream commit 7296103acacda6a7514a6215279ef5337a0e19b2 ]

Use __le32 pointer type to resolve the sparse warnings.

sparse warnings:
 ras/core/eeprom.c:275:15: sparse: expected unsigned int [usertype]
 ras/core/eeprom.c:275:15: sparse: got restricted __le32 [usertype]

 ras/core/eeprom.c:277:15: sparse: expected unsigned int [usertype]
 ras/core/eeprom.c:277:15: sparse: got restricted __le32 [usertype]

 ras/core/eeprom.c:288:33: sparse: sparse: cast to restricted __le32
 ras/core/eeprom.c:289:33: sparse: sparse: cast to restricted __le32
 ras/core/eeprom.c:290:33: sparse: sparse: cast to restricted __le32
 ras/core/eeprom.c:291:33: sparse: sparse: cast to restricted __le32

 ras/core/eeprom.c:333:15: sparse: expected unsigned int [usertype]
 ras/core/eeprom.c:333:15: sparse: got restricted __le32 [usertype]
 ras/core/eeprom.c:343:15: sparse: sparse: cast to restricted __le32

Fixes: 5c3be5defc92 ("drm/amd/ras: Add eeprom ras functions")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202609101657.kczNjTnY-lkp@intel.com/
Signed-off-by: YiPeng Chai <YiPeng.Chai@amd.com>
Acked-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Tao Zhou <tao.zhou1@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/ras/core/eeprom.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/ras/core/eeprom.c b/drivers/gpu/drm/amd/ras/core/eeprom.c
index 7afaac81f37a1..08409881a7eda 100644
--- a/drivers/gpu/drm/amd/ras/core/eeprom.c
+++ b/drivers/gpu/drm/amd/ras/core/eeprom.c
@@ -269,7 +269,7 @@ static void
 __encode_table_header_to_buf(struct ras_eeprom_table_header *hdr,
 			     unsigned char *buf)
 {
-	u32 *pp = (uint32_t *)buf;
+	__le32 *pp = (__le32 *)buf;
 
 	pp[0] = cpu_to_le32(hdr->header);
 	pp[1] = cpu_to_le32(hdr->version);
@@ -282,7 +282,7 @@ static void
 __decode_table_header_from_buf(struct ras_eeprom_table_header *hdr,
 			       unsigned char *buf)
 {
-	u32 *pp = (uint32_t *)buf;
+	__le32 *pp = (__le32 *)buf;
 
 	hdr->header	      = le32_to_cpu(pp[0]);
 	hdr->version	      = le32_to_cpu(pp[1]);
@@ -324,7 +324,7 @@ static void
 __encode_table_ras_info_to_buf(struct ras_eeprom_table_ras_info *rai,
 			       unsigned char *buf)
 {
-	u32 *pp = (uint32_t *)buf;
+	__le32 *pp = (__le32 *)buf;
 	u32 tmp;
 
 	tmp = ((uint32_t)(rai->rma_status) & 0xFF) |
-- 
2.53.0



