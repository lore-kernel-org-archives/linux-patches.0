Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031995;
	b=pwxBCO9NESySeWNemJWB8lZgr/nU+mXrNNTfZHfVlM9x4X48U1eIOxeJ6F5JmrihLXNw
	 6/jdQPC6MzJZEyMwRvuYHIgiybJRsVKsDGIOGoHqgKRKMk9u39Vg90GUEtGx9Uc+vELbK
	 XXh71YYX1WkJSEyPsmI6IfKAF8jBCO+STFG7KUgBz0bkBeyyaJpYdD/D4Q+fulylrz9HI
	 bjRa8z5oVxB01UKsvxrqsIZX6nVQuj0mJC4XEfXLQmrpGGA+G76xNoA730nxEchZwEg1A
	 GEui27vTLhPfkZ8gH20kXRfxT4SqKqvIQQXCT0AEkDWAY9+4gjtBWnUhHxqqIkTqEaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031995;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FW2TDjmZHTT4KqPuBNxmZWFfwOK3TH5ckmPVO7R6bDM=;
	b=wNgma/WZCHMuGa6NfPb1MOynxufu8BqDS5gclyQOrGlgC7Ozm2Spw43RMYt+3m/NMskU
	 ja7rTbYQUXagc3Ku7HeeD+yKEVNojql/DvqBw6tEzeghPA1CwmmxeZf9BUbI202LTFBTW
	 bbaoUnYgzIpLaVx/f75JPi+f1EDGUmFrPbjhWd/hwUswh3v7c+LowsXXaGE/aTXYwSetI
	 9W6SFWSIrdjs045HpOL1vJbwDLuvgQsdL+DEtpfRBFX8P9Qa7ZaoXtfJBLb4pQCcQNi8C
	 f4bNK/TRGzLRYKk8/IvAxRbGsnEOUFKMbRKzGBe9H08XgVi7X7EsTX3gzW3JH8BxBpA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zv8oNDXm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE0C1606A333;
	Wed, 18 Nov 2026 19:59:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zv8oNDXm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2848F1F000C4;
	Wed, 18 Nov 2026 19:59:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031995;
	bh=FW2TDjmZHTT4KqPuBNxmZWFfwOK3TH5ckmPVO7R6bDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zv8oNDXm0z+Rzd9wWRWaTklQhdNZfL0ZUcrfS62nmMqhXGfG+w+1xrMOtuE1HJVxJ
	 ZpGn9QKabv2Ya5sIX16p+NyrxnvYuz2Pg/61/hGuFeCMaakkdMRnHkBzZ4KHRZkXcA
	 o19tK5O8eGs+LAsuJ1+DN4L43dJ1f85b5pbqEsiQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fenglin Wu <fenglin.wu@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1255/1756] spmi: pmic-arb: return 0 in spmi_pmic_arb_register_buses() on success
Date: Wed, 18 Nov 2026 15:56:22 +0100
Message-ID: <20261118150059.661188999@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fenglin Wu <fenglin.wu@oss.qualcomm.com>

[ Upstream commit 82f4c1948a4f951d7d501757a31c6a10eccd37ae ]

The "ret" could be returned with an uninitialized value. Fix it.

Fixes: 979987371739 ("spmi: pmic-arb: Add multi bus support")
Signed-off-by: Fenglin Wu <fenglin.wu@oss.qualcomm.com>
Reviewed-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spmi/spmi-pmic-arb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spmi/spmi-pmic-arb.c b/drivers/spmi/spmi-pmic-arb.c
index ea843159b745d..4e1974fd4acd3 100644
--- a/drivers/spmi/spmi-pmic-arb.c
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -1777,7 +1777,7 @@ static int spmi_pmic_arb_register_buses(struct spmi_pmic_arb *pmic_arb,
 		}
 	}
 
-	return ret;
+	return 0;
 }
 
 static void spmi_pmic_arb_deregister_buses(struct spmi_pmic_arb *pmic_arb)
-- 
2.53.0



