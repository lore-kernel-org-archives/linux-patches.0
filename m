Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795036497;
	b=qZ8WOwemVZSi4FdNtGLk1qAVg51sT5D3yexxJyVd2KTzUN9PEUlo8eZ/i5njpRfBFHcx
	 MYOgxnuMOaJSYPL0074QnIKV0LOT+K5V1/l+/usJgvPrSYeSthbbc7MNpVw1D8UCXpVyE
	 eqHiJt1lco408CLd3ZiMIAI5c4B91qfF6HDMiGQkDUqlgT9pi3TgEFGW2eWTDtkubJzrZ
	 CxJ+ot9r+rIvfL7UbzqZw/9jYyPAFbpfmtBoQINE7uxfzmFSjEo2/twssiztng4ygvYNX
	 dU6jFCVhCTNZVhXnbNUWIf3Bl8YdHxtGh/DTmHoN7FKOQrRTgNoCQVZWssIIq68Ur6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795036497;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=T5MMHxix5Qj2oSFDTuh7biOzKlrysVZbcCThcjJBeDQ=;
	b=3nziQPWr5t+HrxQbc3OMtV39HMrjtyEqPCLUR9xuYmZOrVVLEDWlYrM30tw4z8Rqv37y
	 cuMfhzy6IWO+Bs1PGt+Zr2NawDiGMO2ujPheFvqxxRVUo9dfJDZ8B532XqkruuluHqFon
	 M49UiKaq3bJxBzefaDDwHwVcMJiQONeO5rMpUVVzJCzIddc2/LY2EOb70+epZ7aGkuZDK
	 tFGpjNNIZN04KRAIDBY1t0zgWhui9vi2mqqLPBtyQDdIVvkPn3yzK83ybBKdoc+qkoyL8
	 lPztqgA/AE2dZ2+83PhctpespzFYOYl9DBrnKR9eYdz1xJX43S17GjyWHYl7klmoMbw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IwdlMv24;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83BE5606A31C;
	Wed, 18 Nov 2026 21:14:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=IwdlMv24
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D44101F000C4;
	Wed, 18 Nov 2026 21:14:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795036497;
	bh=T5MMHxix5Qj2oSFDTuh7biOzKlrysVZbcCThcjJBeDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IwdlMv248X1O8J7tezZhSLjv1k6gk7LeUbu/PLNqeOLSoBddEZ8/QDW7dSruTBa64
	 LkuMsof3xuupzvMmxq0SBY2RREbOKqOk+BiFabg6qQq9U/LKh7VwCghweGo+d0qoAx
	 DN6WG2k278u29a180IK+kIYoOJbqfr/4qKk4Jxbw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yijia Wang <wangyijia.yeah@bytedance.com>,
	Guixiong Wei <weiguixiong@bytedance.com>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1081/3318] platform/x86/intel-uncore-freq: Continue restoring limits on resume
Date: Wed, 18 Nov 2026 15:28:23 +0100
Message-ID: <20261118150352.400320910@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 2c9c5cc7d854e..7068dc85d4512 100644
--- a/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
+++ b/drivers/platform/x86/intel/uncore-frequency/uncore-frequency.c
@@ -185,7 +185,7 @@ static int uncore_pm_notify(struct notifier_block *nb, unsigned long mode,
 			struct uncore_data *data = &uncore_instances[i];
 
 			if (!data || !data->valid || !data->stored_uncore_data)
-				return 0;
+				continue;
 
 			wrmsrl_on_cpu(data->control_cpu, MSR_UNCORE_RATIO_LIMIT,
 				      data->stored_uncore_data);
-- 
2.53.0



