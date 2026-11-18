Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025745;
	b=OU84FwAMVHmGhIUOfMNYpslrPqrlzUOgLVSv6OomugW5VfFTHgrN9aSHZ5+dxQ5lx2Y1
	 p+M+nvllj+tvJf/w0rCmz4JNNj0DOtDnnA/lv6XTG0D9X3X+/jgOk5mJd9+jmQmze/497
	 12P0CadI1eRt60JdHrcyIkIBKoxEB45sEHtiotl54P0Ko6Op0s0az6ONNmzO4RvwRaEGo
	 He6HmLCwxtT4aKp3HHdO05m/x4fP5pjAdVQ2kXH2IfqIMXgi63vd/BcsgDoNK8irS8niq
	 pr8kqXCaZQKd8PpPvfMtc6PGgF3qx5eCD+1mExWXlKRbPjGuL9KBiidb0TLafpe+u9A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025745;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NPW7kGJ6dsSe8OOhuEzz2kDH57IqaeMe/0EnlaRsuHg=;
	b=t60bHR1nrVvlR9H9X9/PwuyeYsgCT87FvJm35C+7hyOLw89SNl0MzMV/i8o23214cYiA
	 4c+ePloE/mItIAlZPFT/C54U50N6SDy9mBBRL8VnC2CdLn5jhThkuyQASIPLPbB58MwOn
	 65iq/znurX4u+Z5/b13mhbCktPooXt752hYlV3VejCn8ZZ7riZt5e7GvGzlVATTfDsiWH
	 ME05ZF83x5qjUpLWgoHqbO2NyzUtkmsBGyKE2+g0hRWUsmpCatk/oDO7VeyWf83+gNqr/
	 Lwsgi6Ihj/FccVnTbTPANuzF0N5edrc5rNZQjbXIIYVMuMpK+0LPXUpg+50Q/AfJx3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=axWWRP5+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE3C606A320;
	Wed, 18 Nov 2026 18:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=axWWRP5+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3759D1F000C4;
	Wed, 18 Nov 2026 18:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025745;
	bh=NPW7kGJ6dsSe8OOhuEzz2kDH57IqaeMe/0EnlaRsuHg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=axWWRP5+Xreh0jtc2VTHg5GSqpw/M4Pc+o2GTxr1QatMXW5hzxqtSYy4LufDHQC6A
	 bmE4zLGLRL0ADV0sx45hjpGatoz886qEb3c2Yh1nu7g52EybI0xj22TrgJME/jNjC/
	 Nvf4MJm/HGVCR1ueF5g4y8W51SnWiK1m22K4zEgc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiale Yao <yaojiale02@163.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Linus Walleij <linusw@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1187/2151] pinctrl: sprd: free maps on DT map failure
Date: Wed, 18 Nov 2026 15:48:42 +0100
Message-ID: <20261118150205.467393281@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiale Yao <yaojiale02@163.com>

[ Upstream commit e873c665e503ebfb6dafaf9346c3956695686226 ]

sprd_dt_node_to_map() reserves map storage before adding mux and
configuration entries.  If a later operation fails, the error path only
frees the temporary configurations and leaves the map allocation reachable
through the output pointer.

Free the partially built map on failure.  The caller ignores the output
parameters when the mapping callback returns an error, so they do not need
to be reset after freeing the map.

Fixes: 41d32cfce1ae ("pinctrl: sprd: Add Spreadtrum pin control driver")
Signed-off-by: Jiale Yao <yaojiale02@163.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/sprd/pinctrl-sprd.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/pinctrl/sprd/pinctrl-sprd.c b/drivers/pinctrl/sprd/pinctrl-sprd.c
index 16cf9d15f2470..a565d4fd4233c 100644
--- a/drivers/pinctrl/sprd/pinctrl-sprd.c
+++ b/drivers/pinctrl/sprd/pinctrl-sprd.c
@@ -326,6 +326,9 @@ static int sprd_dt_node_to_map(struct pinctrl_dev *pctldev,
 
 out:
 	kfree(configs);
+	if (ret < 0)
+		pinctrl_utils_free_map(pctldev, *map, *num_maps);
+
 	return ret;
 }
 
-- 
2.53.0



