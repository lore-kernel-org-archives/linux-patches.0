Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1551247885C;
	Fri,  7 Aug 2026 15:36:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786117012; cv=none; b=qAtrKydK/Pv+VqbGMlx2I7RBeeW2+7BVwDoFcVNoMQfWgwIzZAB5zH6I5BPH69zkSDhUZMrBB11uJa0py3WR1Rif7bs6S/xdIpuHrTqJctP6xEjxpJUQn5QRRIebufdXhg3dqx2wfVxy2igroACK3yPVm0V3Yuc5UCcPq+mrc/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786117012; c=relaxed/simple;
	bh=R8YomU0mP8JzgXn41sVpqNwtkCRgQswyorVcpSlPNVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1YJdGQXCBJ9+YZPspjTDtr+zNzGNNBmDnWOaJKHCIXdIARpRFxDYRjFcAZKEiuPDYI1/+9zR2ugJHVFZJhzlwstWAjFxG3oy0uqFyJfNvwK3sPxU9vzfXCy7UBAmcLKO5Af4UTLn0O0JMSlQh3WfvZ4BnGRs55/zx7Q9XqKAWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ty0SRwG0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ty0SRwG0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC751F000E9;
	Fri,  7 Aug 2026 15:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786117011;
	bh=b/8JjgLnPkAgKHqNLCVi7Kmm3IZrGJQp4fMTzu5Vrq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ty0SRwG0ZbakicJ3wMIBWZJUwr3jCx/o0Aroyv4AqQvlSjw8QNMQIxmKkb5nJxQkR
	 VobOhc0cn+SvRtpveZ88BKoELiuJGg5vMvPiu80wfXuMX7jklZU5Ek90ga2TaS3KHo
	 E0Oj2bemDV2pmc5rSfxBi3U1frDTEyZc+Rq9N654=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <thorsten.blum@linux.dev>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 114/438] powerpc/boot: Fix treeboot-akebono CPU node lookup check
Date: Fri,  7 Aug 2026 16:35:10 +0200
Message-ID: <20260807143430.425435925@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143428.008222056@linuxfoundation.org>
References: <20260807143428.008222056@linuxfoundation.org>
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

From: Thorsten Blum <thorsten.blum@linux.dev>

[ Upstream commit b24fc8278b70a9d27ec801a427ab4de9b769d69a ]

fdt_node_offset_by_prop_value() returns a negative error code on
failure - fix the check accordingly.

Fixes: 2a2c74b2efcb ("IBM Akebono: Add the Akebono platform")
Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260702211554.56923-6-thorsten.blum@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/boot/treeboot-akebono.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/boot/treeboot-akebono.c b/arch/powerpc/boot/treeboot-akebono.c
index e3cc2599869cc..1b529037480fb 100644
--- a/arch/powerpc/boot/treeboot-akebono.c
+++ b/arch/powerpc/boot/treeboot-akebono.c
@@ -146,7 +146,7 @@ void platform_init(char *userdata)
 
 	node = fdt_node_offset_by_prop_value(_dtb_start, -1, "device_type",
 					     "cpu", sizeof("cpu"));
-	if (!node)
+	if (node < 0)
 		fatal("Cannot find cpu node\n");
 	timebase = fdt_getprop(_dtb_start, node, "timebase-frequency", &size);
 	if (timebase && (size == 4))
-- 
2.53.0



