Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020355;
	b=jIK8Tm3ZBlJclIOedDwLPkQIGxgLjtbMfVySmVbsoLqBABwzj+F8YwmutkSKr5aWAJqT
	 WUHK6yWRpDScc4SgWA5wTfAQS3K5eHA1fp6NgJT7qNAOdrPWvdr5bkPjSMlibqORzOrUh
	 SMO+BRYTC1yRo/d90Grym2f15vbwPQlSFLtxIlU0EeV+r1fVvj7ar9AvIlM+jhP5i4EF9
	 uSkCVcfzGxjl/kVxkti6m/U3FXJlzZvhq2X9KWFTFnPqs+fuJxSkr+SUP/e2BdBNwfkTh
	 1KkzOwIKKIaa27wJj15DgXnK9M94Ym+olviv2lvtzilTyaWLXXrWARCBLePvLoPMjsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020355;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TXjrxj6jtO5xnlcLcezdL/Z90cKA6lnyctUE9xXTcvg=;
	b=tZ1UBktbwW0ueyoY2D1cyW6X7i1iaCdziSzSEuKUKn5oEdDmoyAxaAIAxckwcraKSSnJ
	 XsQ5pvsjv6CfBtmI4p4VhukxS+9AGOT0r3SqwUM8LRWSZj1TvHfQKtLJFWt/cEn6wpBL4
	 FVghMBJsMc59IMeJkZomLxQvfg3RqPoz/zYo6xLvj//Lcir/Bz94pnMv3DJG/44l0IFOk
	 +LaW75X6L0AvTtcPOFwmb+FHxXSy8l1SHQO5wbiBsVcV/sl66X8imzwDpN6PMT8VppDML
	 FkryF9W9uO9GzBQVm0dxKoRfeSeCeJpVMHXU3AdqVahOnpl75LVBds5s0BBU7DATvyw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kEP05SfD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB957606A32C;
	Wed, 18 Nov 2026 16:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=kEP05SfD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1169D1F000C4;
	Wed, 18 Nov 2026 16:45:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020355;
	bh=TXjrxj6jtO5xnlcLcezdL/Z90cKA6lnyctUE9xXTcvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kEP05SfDFVqIQKs/yLcF2LXHW9K/B+wEajCf16a3TqhI3n635vnqbpXXZsXQBlGk+
	 Y6HfeHdnLF2SXNk8aKTFDztcMApOvwbcsiyJbcac9nEsj64GqnTKa91Yi/QE0bySsT
	 M6LXgCP6PJ0qmAo4hV1i1p+5RmlMAofLIUN278VE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fenglin Wu <fenglin.wu@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1920/2651] spmi: pmic-arb: return 0 in spmi_pmic_arb_register_buses() on success
Date: Wed, 18 Nov 2026 15:52:40 +0100
Message-ID: <20261118150355.871000129@linuxfoundation.org>
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
index 2e2cb47741038..402ffeaff8e2b 100644
--- a/drivers/spmi/spmi-pmic-arb.c
+++ b/drivers/spmi/spmi-pmic-arb.c
@@ -2060,7 +2060,7 @@ static int spmi_pmic_arb_register_buses(struct spmi_pmic_arb *pmic_arb,
 		}
 	}
 
-	return ret;
+	return 0;
 }
 
 static void spmi_pmic_arb_deregister_buses(struct spmi_pmic_arb *pmic_arb)
-- 
2.53.0



