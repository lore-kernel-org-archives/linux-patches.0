Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC28A3E0C55;
	Tue, 21 Jul 2026 17:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653929; cv=none; b=RNOYPSy6bOvaDtHyjalIPGpnDv+glaNEhkIf0yGeM6tPXIGbU+sPlGhXz/FAFmzduQTj6H4RtXWLLW5o3qAONWJXV5NFTnzTZWq79C65WfSpT12vBwjbwPPYXMQAN31AKPTCsxHXOeNLI3r1EMWgclOw46v7dIc1UDQJzK6nV9M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653929; c=relaxed/simple;
	bh=oHGs111zDIa87basBovZI9xnyARSgeqco49kXzwK2eg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FL8A6R6A8KeSDEylTtp8SPCt6uF3La8adhWj+zsCFnNt4FRaMhnWjdLY+c/rdSyVnxV/ac1n6Haq8JLMtUpq6lU/fph6Gkcu6hBuW3SeB6iBWB23fla09PqqqGqNmRSGceQ43Ca4DLArL+nZq0hnyZB65u7cuxMgufW1Moblu/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uppKoko8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uppKoko8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0E11F000E9;
	Tue, 21 Jul 2026 17:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653927;
	bh=/vUMUn1xj81rV2UhUlCrRcEMBwBKUQsuZoNUUjR9u5M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uppKoko8++G/Vgwtsmu2teCdmAl66J3TJzk3PF2Ei4m1xZHcY6ChBTi0Auy9ypS66
	 IN9Wf2lQmJg36OJXrmQb3WdvIxJ+1/4mbf0RG8cZfE5aWCWHb/ErIrP09gsHi4B+AW
	 4SmDJxn8pI6JuBKdLB2zYuR4Rq5kHOzVhFjodLKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alessio Belle <alessio.belle@imgtec.com>,
	Ben Dooks <ben.dooks@codethink.co.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1511/2077] drm/imagination: make pvr_fw_trace_init_mask_ops static
Date: Tue, 21 Jul 2026 17:19:44 +0200
Message-ID: <20260721152628.422926763@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Dooks <ben.dooks@codethink.co.uk>

[ Upstream commit c804aadc4ce3dcb34d6f2ecc9a159c148210805a ]

The pvr_fw_trace_init_mask_ops is not used outside pvr_fw_trace.c
so make it static to avoid the following sparse warning:

drivers/gpu/drm/imagination/pvr_fw_trace.c:74:31: warning: symbol 'pvr_fw_trace_init_mask_ops' was not declared. Should it be static?

Fixes: c6978643ea1c ("drm/imagination: Validate fw trace group_mask")
Reviewed-by: Alessio Belle <alessio.belle@imgtec.com>
Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Link: https://patch.msgid.link/20260703162338.2848039-1-ben.dooks@codethink.co.uk
Signed-off-by: Alessio Belle <alessio.belle@imgtec.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/imagination/pvr_fw_trace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/imagination/pvr_fw_trace.c b/drivers/gpu/drm/imagination/pvr_fw_trace.c
index 6193811ef7bebb..5b2218a7cd663b 100644
--- a/drivers/gpu/drm/imagination/pvr_fw_trace.c
+++ b/drivers/gpu/drm/imagination/pvr_fw_trace.c
@@ -71,7 +71,7 @@ pvr_fw_trace_init_mask_set(const char *val, const struct kernel_param *kp)
 	return 0;
 }
 
-const struct kernel_param_ops pvr_fw_trace_init_mask_ops = {
+static const struct kernel_param_ops pvr_fw_trace_init_mask_ops = {
 	.set = pvr_fw_trace_init_mask_set,
 	.get = param_get_hexint,
 };
-- 
2.53.0



