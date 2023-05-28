Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B46A9611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:34:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 408A2C433EF;
	Sun, 28 May 2023 19:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302499;
	bh=6yN+Dtb26/cqXCvGIuawoG4nplPZHAP7CPHSymmKAt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Jde11Ko0bT81GzM1syOs+PE2fakwHjhkPhf+udo/P7zlasIDb3YAcSFzjnJIIBKpQ
	 GHFRShXUXHVzYMtVg06yA5G8WDq/60D+zy6meQxPanzWWf85/P3oFhVm1Tj+NTUvRW
	 ccns5vtOSnGG+RdO218GvlTcsAn+AXzAl24oZE7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Xiao <Jack.Xiao@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	"Gong, Richard" <richard.gong@amd.com>,
	Evan Quan <evan.quan@amd.com>
Subject: [PATCH 6.1 010/119] drm/amdgpu/mes11: enable reg active poll
Date: Sun, 28 May 2023 20:10:10 +0100
Message-Id: <20230528190835.695609526@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jack Xiao <Jack.Xiao@amd.com>

commit a6b3b618c0f7abc3f543dd0c57b2b19a770bffec upstream.

Enable reg active poll in mes11.

Signed-off-by: Jack Xiao <Jack.Xiao@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Tested-and-acked-by: Evan Quan <evan.quan@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: "Gong, Richard" <richard.gong@amd.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v11_0.c
@@ -390,6 +390,7 @@ static int mes_v11_0_set_hw_resources(st
 	mes_set_hw_res_pkt.disable_reset = 1;
 	mes_set_hw_res_pkt.disable_mes_log = 1;
 	mes_set_hw_res_pkt.use_different_vmid_compute = 1;
+	mes_set_hw_res_pkt.enable_reg_active_poll = 1;
 	mes_set_hw_res_pkt.oversubscription_timer = 50;
 
 	return mes_v11_0_submit_pkt_and_poll_completion(mes,


