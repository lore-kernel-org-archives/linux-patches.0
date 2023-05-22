Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AD68168DC
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:36:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4C79C433D2;
	Mon, 22 May 2023 19:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784183;
	bh=H3j/oO4DXt59iPdtJWNsZHHIFrQHp4uQ31Ak/zsxJHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jI/q1fQ7yWd8WXSotnGGYMwQz76CyWdxL1fQQoa4HIIoHsIwjKuEygFDQyuLf6NSN
	 pmQhl8UI+WaBihu2F1O1J8odbSLdt7OzlMuekBRAgGcHLJhuzYaS0oAHbIsBbjjS4y
	 MD6FoFAoStWFrd9EPE9KrK9x8Rr5HHw/x9RR5XPQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Ma <li.ma@amd.com>,
	Yifan Zhang <yifan1.zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 290/292] drm/amdgpu: declare firmware for new MES 11.0.4
Date: Mon, 22 May 2023 20:10:47 +0100
Message-Id: <20230522190413.198179818@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190405.880733338@linuxfoundation.org>
References: <20230522190405.880733338@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Li Ma <li.ma@amd.com>

commit a462ef872fd1e83ebd075cf82d91f111acaa629e upstream.

To support new mes ip block

Signed-off-by: Li Ma <li.ma@amd.com>
Reviewed-by: Yifan Zhang <yifan1.zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -40,6 +40,8 @@ MODULE_FIRMWARE("amdgpu/gc_11_0_2_mes.bi
 MODULE_FIRMWARE("amdgpu/gc_11_0_2_mes1.bin");
 MODULE_FIRMWARE("amdgpu/gc_11_0_3_mes.bin");
 MODULE_FIRMWARE("amdgpu/gc_11_0_3_mes1.bin");
+MODULE_FIRMWARE("amdgpu/gc_11_0_4_mes.bin");
+MODULE_FIRMWARE("amdgpu/gc_11_0_4_mes1.bin");
 
 static int mes_v11_0_hw_fini(void *handle);
 static int mes_v11_0_kiq_hw_init(struct amdgpu_device *adev);


