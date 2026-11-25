Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795622128;
	b=D7YGx329RGKcih05N7VA9EuWCXNeaS9y5GWwaFaSFoF1EcTRRWx5BI1b5GyDMkOcF6V8
	 lrr4DKMydJz4w/88EmF5B+d0tz9WQy3V3P+GXWYSyjNn4rqzyGtwl8wA/mRTc1DcYNCJg
	 NtSuk/O+by4KlCGlPZ7s3KavDrw7EnzRf+g48UnqoN1xcGstln6wNG+WSfXKa11tTdg57
	 3pUSbLawUW1QizbzuS0xVsXAf6iw72ZVv4O8Vbby4fT/7u/Q6GYt8gP+elK7Vcaw9lzVZ
	 CJ7WvTEurvHvt2QVYD9o8pDNW3iHImmjBkGntHcPTPDauCfbQDlmpXXmcMCXNBcA8ig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795622128;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HhX/xVmRroMqRGwSu2MVc7l7F/KEu4s0+QjO7SHrkvE=;
	b=lrMwmmj/pgCbeyVNw4rvyKtXtGNK90Vo28CTXFfkj0N3QE6BRPyYq0EbK4vz0ZyieALh
	 NkHGGSx65cswrlJtJ+MK7zkeEKWaPRD+Zg+aWQV1ujtEwDokzCdH1Pv3k1ZVDsqpY4Yyl
	 EO05BzXlwtQY4QVuFR7bNofIFIqKWrSiU4b92FEvNnv5vztwBoU7H03Bn7gyPXHSBUpUc
	 hspBdOK5BqZ7FJCCJN4ye7Hni06E8c3A/RETHm2bYEvShrNlnNq/oGpYJKkUDQdOvz5lQ
	 XQR6XvvXlj9mOk96IageicxJcUnKSra5Kp/d9aD3+60Q/ujXelWuaBodigQmO5SV5QA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ManyUGqT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8498D606A329;
	Wed, 25 Nov 2026 15:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ManyUGqT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1E21F000C4;
	Wed, 25 Nov 2026 15:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795622127;
	bh=HhX/xVmRroMqRGwSu2MVc7l7F/KEu4s0+QjO7SHrkvE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ManyUGqTsjoZz6oa8rCMTIbHlzhcs0dFqEGssMUpcXKxnl/O55QKW2HN1gA2vRkTL
	 MlQOe8pJJCUMmR3FG7M+P8hQydL+hdrEcg5CX4mXALPfFxclW/a8p8VCrWTOC/HMkO
	 GXmhUi/CBF1ZqN0QBwraqNExH/LfmIyCRTnWBY7s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Vecera <ivecera@redhat.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Petr Oros <poros@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 431/990] dpll: notify about a reference sync pair only if it was added
Date: Wed, 25 Nov 2026 15:29:58 +0100
Message-ID: <20261125143832.190163736@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Ivan Vecera <ivecera@redhat.com>

[ Upstream commit 7a3837929d049dac1f931620f30b100993ce2594 ]

dpll_pin_ref_sync_pair_add() sends a pin change notification even when
xa_insert() fails and nothing has changed. zl3073x gets -EBUSY when
another channel has already added the same pair and ignores it, so user
space is notified about a change that did not happen.

Send the notification only after a successful insert.

Found by code review. Reproduced on a ZL30732A board with kprobes on
dpll_pin_ref_sync_pair_add() and __dpll_pin_change_ntf(): loading the
driver adds one pair twice and the add failing with -EBUSY sends a
notification. With this patch it does not, and the successful add still
does. A test module adding one pair twice shows the same on the monitor
group.

Fixes: 58256a26bfb3 ("dpll: add reference sync get/set")
Signed-off-by: Ivan Vecera <ivecera@redhat.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Reviewed-by: Petr Oros <poros@redhat.com>
Link: https://patch.msgid.link/20261105131145.1010406-2-ivecera@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dpll/dpll_core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/dpll/dpll_core.c b/drivers/dpll/dpll_core.c
index 0a8db4dc25786..aaa576562ae42 100644
--- a/drivers/dpll/dpll_core.c
+++ b/drivers/dpll/dpll_core.c
@@ -999,7 +999,8 @@ int dpll_pin_ref_sync_pair_add(struct dpll_pin *pin,
 	mutex_lock(&dpll_lock);
 	ret = xa_insert(&pin->ref_sync_pins, ref_sync_pin->id,
 			ref_sync_pin, GFP_KERNEL);
-	__dpll_pin_change_ntf(pin);
+	if (!ret)
+		__dpll_pin_change_ntf(pin);
 	mutex_unlock(&dpll_lock);
 
 	return ret;
-- 
2.53.0



