Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E0B11AA1C3;
	Wed, 20 Nov 2024 12:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732107556; cv=none; b=uCXYg3y6v49eZaE/eAmObhupe9kH6DwmvhquiZyRGm/MSCxLne5ASNuAAKJ4Kghfqr4M9UttT0bpkdhL8xanC4MMKwz3aAh/KTW42t9E/+PbyCYihrJIRni+X2uSaXKb36CNUeOoAzT7pG/wEhX54cQitotg+S0jNQdNweFqesg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732107556; c=relaxed/simple;
	bh=rQkVLFiEEsg4zhqE2LDoxI3NLrE9Jf2tKd13zJX/uvg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aa3ZeFy9p866FcEPnZwoZEX/k4vxWh4HfqxmEy3xfWmPCBY2XBrJmsYxR6zyuArdA8u+RJDhrElBaI5I8Umpl5hn/XGGdhfocNVPWV6Y5ZDnFa3solqFGeTvPxtUEnqmTSGSdu6c+raiYTSpu4MHT5EIEV/IfytaNanhTjMv0/s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K+JEwgq2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K+JEwgq2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25DB3C4CECD;
	Wed, 20 Nov 2024 12:59:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1732107556;
	bh=rQkVLFiEEsg4zhqE2LDoxI3NLrE9Jf2tKd13zJX/uvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K+JEwgq2FajhP4NsQ2RuyLid8gdvJM4e8ItVgPa0zrzlT7AsvOlZ6qsWNmViRHcjr
	 qnELvtAHgdbEDQrOvTI0A5q553tVsbBRlIZXrDJhiG7o09C7Zqsoq4T02OE9iebs1x
	 bv9Avjx/t+MOIzphvboU1FgoaDQ/bEhMt0N2SoPk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Xiao <Jack.Xiao@amd.com>,
	Hawking Zhang <Hawking.Zhang@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.11 097/107] drm/amdgpu/mes12: correct kiq unmap latency
Date: Wed, 20 Nov 2024 13:57:12 +0100
Message-ID: <20241120125631.912434461@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
References: <20241120125629.681745345@linuxfoundation.org>
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

From: Jack Xiao <Jack.Xiao@amd.com>

commit 79365ea70714427b4dff89b43234ad7c3233d7ba upstream.

Correct kiq unmap queue timeout value.

Signed-off-by: Jack Xiao <Jack.Xiao@amd.com>
Reviewed-by: Hawking Zhang <Hawking.Zhang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit cfe98204a06329b6b7fce1b828b7d620473181ff)
Cc: stable@vger.kernel.org # 6.11.x
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/amdgpu/mes_v12_0.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
+++ b/drivers/gpu/drm/amd/amdgpu/mes_v12_0.c
@@ -524,7 +524,7 @@ static int mes_v12_0_set_hw_resources_1(
 	mes_set_hw_res_1_pkt.header.type = MES_API_TYPE_SCHEDULER;
 	mes_set_hw_res_1_pkt.header.opcode = MES_SCH_API_SET_HW_RSRC_1;
 	mes_set_hw_res_1_pkt.header.dwsize = API_FRAME_SIZE_IN_DWORDS;
-	mes_set_hw_res_1_pkt.mes_kiq_unmap_timeout = 100;
+	mes_set_hw_res_1_pkt.mes_kiq_unmap_timeout = 0xa;
 
 	return mes_v12_0_submit_pkt_and_poll_completion(mes, pipe,
 			&mes_set_hw_res_1_pkt, sizeof(mes_set_hw_res_1_pkt),


