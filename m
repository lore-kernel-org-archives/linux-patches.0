Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 362D428EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:06:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92519C433D2;
	Mon, 30 Jan 2023 14:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675087611;
	bh=+FQvQmuigkcGR+nhVTKxVpb8x5WZV8/RnEqeRuUJoqg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FiC3aXmf2XuIVkTIqQo82u66V1XKJjd2LSNnUrow6LRIt8NzFHoqfG4FMvVDw14qI
	 MJxOPX3cY1o+d/ZljgY2hz+SxtjRrJypbMvELX1hHnPdPpTIoFhEVfeRvfS2B9sTHH
	 c5G4nNO0DUTM1JLnif16HXZ7lNrzff/XY/tAkwPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Graham Sider <graham.sider@amd.com>,
	Jonathan Kim <jonathan.kim@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.1 236/313] drm/amdgpu: remove unconditional trap enable on add gfx11 queues
Date: Mon, 30 Jan 2023 14:51:11 +0100
Message-Id: <20230130134347.671849116@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jonathan Kim <jonathan.kim@amd.com>

commit 2de3769830346e68b3de0f4abc0d8e2625ad9dac upstream.

Rebase of driver has incorrect unconditional trap enablement
for GFX11 when adding mes queues.

Reported-by: Graham Sider <graham.sider@amd.com>
Signed-off-by: Jonathan Kim <jonathan.kim@amd.com>
Reviewed-by: Graham Sider <graham.sider@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.1.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -192,7 +192,6 @@ static int mes_v11_0_add_hw_queue(struct
 	mes_add_queue_pkt.trap_handler_addr = input->tba_addr;
 	mes_add_queue_pkt.tma_addr = input->tma_addr;
 	mes_add_queue_pkt.is_kfd_process = input->is_kfd_process;
-	mes_add_queue_pkt.trap_en = 1;
 
 	/* For KFD, gds_size is re-used for queue size (needed in MES for AQL queues) */
 	mes_add_queue_pkt.is_aql_queue = input->is_aql_queue;


