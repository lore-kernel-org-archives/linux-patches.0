Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026801;
	b=sIPjxlFCvF+TfGNS9oO3/iJmxxUs9yvnLlmX2lz4E/OIE3izUFufxFdLT0gNrhPf3o3s
	 /6J85GsOhD9rwYaUwm5z7wDnw5ibhpr9HFX79RKXw+IAHHpR/PvWt/mOG3VYwwwKipKeF
	 AcHy5RoQeoRB/pnbcUC/gjUi0SOavYNBKN+eRxswdQJnNW7JkWkCLbnwYVFjO/DDnNT/9
	 sXxdY82Adz82g0AiwxZ24f2bEbUwZg8zBMElmfJDq0EFcZN+kqVAYX5X89LsfFDidvuVB
	 tmJMliEzEY7oYB1H1iRdQdkvkU2Q0p38WisT/yM3xG06yqtMVbB6AmAceCr9IQnhiPA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026801;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Uw5XgnsHW+Z1Vje7nwx4eEXgu7fW7PCyeXDVcRw2syw=;
	b=aznsRTtqMmQa8fKDkoBk/a4bVL6b0t+FRhrx+ZahboXu3pWuXxgVHNbKYF8j+LAlvI0d
	 1iDwAZniitypE28Kx3ZJibK5tl7QKIPmpgtDJ1TRImop4Ci6IjfNlNm1sHvhYj4ceDWWI
	 MBpwc7wKR42nQu0AwyYH5iAGGQm+VJtJH1L3ln4O+1Mof9OlDrjnYDx+3DHSIlInVXtnn
	 0aq8pedsCWgfdH4LcX6Ab4qlCqDS773TKzI1yn2EZVdCIHbi2Y+0BDbDPc9hhgdsMSdIj
	 uQXMQkPKENXVo5Y9nBy4m/CLeoSetAxyOztOwbKzGX2+MvKZUb5Xfriru99Sjb8NDmA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BbxdvYr1;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF930606A320;
	Wed, 18 Nov 2026 18:33:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BbxdvYr1
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B1411F000C4;
	Wed, 18 Nov 2026 18:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026801;
	bh=Uw5XgnsHW+Z1Vje7nwx4eEXgu7fW7PCyeXDVcRw2syw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BbxdvYr1idPg6uoretaqcJtz1WoDFA3IdnN7W/MMUa48fhduV3OzAa3KJdtHW07FP
	 p5hM9aUhC5APaW8CwGu3GPMCVNG3sBX7DprO6CmUS12+6dhHzfR/wvhnC/WqhaTwZh
	 w4lcXSjPe/mW+N/A3FLfulStZuz8UkUbkDE2oJoY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fenglin Wu <fenglin.wu@oss.qualcomm.com>,
	Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1565/2151] spmi: pmic-arb: return 0 in spmi_pmic_arb_register_buses() on success
Date: Wed, 18 Nov 2026 15:55:00 +0100
Message-ID: <20261118150218.896661684@linuxfoundation.org>
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
index 91581974ef84e..a2fac1e9e5307 100644
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



