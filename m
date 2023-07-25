Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 551618F59
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:09:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9D45C433C8;
	Tue, 25 Jul 2023 11:09:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283386;
	bh=OppGpa/h8ZlcbP30JHx3ga6YtaKYFCYpPH2X3hyxitk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0PrPuDYFQihW/WyddrRqUvYSgMOuqaiWn4GQ1DFaDPOEgt2DKHxBRalUkppMUg7cb
	 XUA+J1LNdztcTB2oY+wA/DehemfmyRUQ5rRfO2Cjs8o7XiQtMnASG2ZxlAXsHc915S
	 7qIOCtHHCXWzBMUtN5LHowKpOAjhOAFelRSWXxjM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	hackyzh002 <hackyzh002@gmail.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 29/78] [PATCH AUTOSEL 4.14 1/9] drm/radeon: Fix integer overflow in radeon_cs_parser_init
Date: Tue, 25 Jul 2023 12:46:20 +0200
Message-ID: <20230725104452.439305068@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104451.275227789@linuxfoundation.org>
References: <20230725104451.275227789@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

[ Upstream commit f828b681d0cd566f86351c0b913e6cb6ed8c7b9c ]

The type of size is unsigned, if size is 0x40000000, there will be an
integer overflow, size will be zero after size *= sizeof(uint32_t),
will cause uninitialized memory to be referenced later

Reviewed-by: Christian König <christian.koenig@amd.com>
Signed-off-by: hackyzh002 <hackyzh002@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_cs.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/radeon/radeon_cs.c
+++ b/drivers/gpu/drm/radeon/radeon_cs.c
@@ -270,7 +270,8 @@ int radeon_cs_parser_init(struct radeon_
 {
 	struct drm_radeon_cs *cs = data;
 	uint64_t *chunk_array_ptr;
-	unsigned size, i;
+	u64 size;
+	unsigned i;
 	u32 ring = RADEON_CS_RING_GFX;
 	s32 priority = 0;
 


