Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795045462;
	b=zfqTLn+Kj0/s4ej/JSpqM4Ii8p37GDCg4KHxhDxj/5aYW41lcu1JQPAOVBSYNieyUYL6
	 TxHwJOhFsuoROPImmx4dfU/aREjy0XkPpEsW0v3eO3ExC89MqBqEVaUZIGGyYoqKH9YpC
	 g7pgTqB11YLeJYUxUniknMMXAaeQ5Ev0FxWH5M41Ds8oLGsJ4tVwvA1JOYExEceqTURbs
	 yWPt10cMU8pGJ6/rYkAqxEiLDns55lhnGtyFRULZxlGz0EBGFr5TOJp6nC42hDtk8zb1u
	 LLEOr1erSUkBspzXBGzcJ0e59lPlUCiVruBx51vzEEEsn6I2ESUqArZMEuzF5J2LUwA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795045462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=Q6F284oBdUC9E/VrvJI6NgINsOytf0Ure+DjZajKNIA=;
	b=LvU84zGY/vXPP2kDmzea64RLoTTGH0Zb+JPca6B8+//tFx9iDCMinbf0HmpEKvhmJXG8
	 t36CdNdw+9THuRytk7GO/pEn49yAxJu/oBktaA1KNE+Cw6xnInWsg9WtDmbEyGW8B8Nrb
	 FGWIJy6aUlCzGjdsihV5ezkWRySHIzZ2iquELyTipoNWRGpfSAs6PQqz5b8PJanAL6M7U
	 pbLiO7YsxYQmg/rnua7dRPyLvZ9mAkRcSzxafTPD9y0emzsFKFUcxM5hg4/3DrUTIQBsj
	 bIxPAwX4xZyAA/FLi8SU5X/517Ml+8vnV/HUGdLqPmbj5Yy9IJiwMPb4fAEbjH7wH/Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pU6ZkNzc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DFF606A320;
	Wed, 18 Nov 2026 23:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=pU6ZkNzc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012951F000C4;
	Wed, 18 Nov 2026 23:44:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795045462;
	bh=Q6F284oBdUC9E/VrvJI6NgINsOytf0Ure+DjZajKNIA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pU6ZkNzcM9g4npOXVss5VHHRUMl4HIENfkqCPaAx4deHs9q2pfUqNNdzaWCL6x/li
	 cb0rWsthAuY0xKMtrIMK609Q2rVmwQWoDOc29eN4GIKIXxs6bbsxjogyNeSR0Uwiy0
	 6A1X9tzcSg1teTaIpILAVMPpWxWWK3j86mkRcJS0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yijia Wang <wangyijia.yeah@bytedance.com>,
	Guixiong Wei <weiguixiong@bytedance.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0930/2857] platform/x86/intel-uncore-freq: Continue restoring limits on resume
Date: Wed, 18 Nov 2026 15:32:44 +0100
Message-ID: <20261118150235.074081704@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guixiong Wei <weiguixiong@bytedance.com>

[ Upstream commit 38998529f45c02edcf96b0a3ddd3c83de6d11bbe ]

The PM notifier iterates over every uncore frequency instance to restore
user-configured MSR_UNCORE_RATIO_LIMIT values after resume. Entries that
have never been configured legitimately have stored_uncore_data set to
zero.

The refactoring that split common and enumeration code changed the
iteration from active control CPUs to all allocated instances. It also
changed the skip for an invalid or unconfigured entry from continue to
return, causing that entry to terminate the entire restore operation.

On a multi-package or multi-die system, configuring only a later instance
therefore leaves its limit unrestored after suspend, hibernation, or
restore if an earlier entry is invalid or unconfigured.

Use continue to skip only the current entry and restore all remaining
configured instances.

Fixes: dbce412a7733 ("platform/x86/intel-uncore-freq: Split common and enumeration part")
Cc: stable@vger.kernel.org
Tested-by: Yijia Wang <wangyijia.yeah@bytedance.com>
Signed-off-by: Guixiong Wei <weiguixiong@bytedance.com>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260929163133.14326-2-weiguixiong@bytedance.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
index 0be3087e21d51..3f56ddf330b3d 100644
--- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
+++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
@@ -184,7 +184,7 @@ static int uncore_pm_notify(struct notifier_block *nb, unsigned long mode,
 			struct uncore_data *data = &uncore_instances[i];
 
 			if (!data || !data->valid || !data->stored_uncore_data)
-				return 0;
+				continue;
 
 			wrmsrl_on_cpu(data->control_cpu, MSR_UNCORE_RATIO_LIMIT,
 				      data->stored_uncore_data);
-- 
2.53.0



