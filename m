Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062317;
	b=vuEmhDnI98L0Jq3vdaI3e9XvLrcTEP7B1fKgZoFOCwgF89fZzSxmDUTfk1wWaebSVCcH
	 V3T9wO4IUGFWW3TXSzp8LEkJyfRdXKyx8GIl3SnMaDzrGf9cFYV2LUnonIu7pDnaDwNlt
	 ALvvSP9hm+KqsxULunG35NrGynr5SorAUX7R2kEHtP5WKm7OkhdYfvM8GxDPKNFKjIIPm
	 kkK8R/5Kb8SIYRUxunjm/aBiss/F+zZP9NQyzLxJ4L/2mTKSZfy6BQUUPmqojcwhTNqOn
	 FVsnXRujR3VbxHWgxXVlJ5oFm3aEjMMhWVi8N9wvb84mQY1fQ2nBpnzbMC/4Izahisw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062317;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=tu2TS6nPRWaAnkeJmHq6a8NnLa8s8XiXI1egBQEjAUw=;
	b=4nOC0bfPhRqH9jFcpxZIlwwLLeFWAVVr2Us66A3TkNOU1pqb3gqg6tlIXYHaM0Oek8uY
	 Rp9vXPMRFeP6315zDgMd/a+4hUncdLguAcWh1zlPiGt5gOW+8vORe/MLgk4YAoGgvufdo
	 JIcbDzNrR7XGx60SfQ3IoJWpXGz9ZyWMR0eQ+Cj42pSKymcSE8c5QoNqGr5D3RncAWTqJ
	 8sVs2Wd156686afcVDyXo45nB49pl4xH/guazZBP2KEU7HztkpTG11CSUJTNSPlELwVmd
	 zn5l01/I+nb5tkeVrWTgBKfdSjQJUQp5iIfAR6GPXGfE48xgr9lfp0b+kq8YjU2Dh+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MLMLYczW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9974606A643;
	Sat,  7 Nov 2026 14:38:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MLMLYczW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98ACE1F0089F;
	Sat,  7 Nov 2026 14:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062316;
	bh=tu2TS6nPRWaAnkeJmHq6a8NnLa8s8XiXI1egBQEjAUw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MLMLYczWZd3PtINJrh/n5UFHoSuKnLT8fcDm9p/BuOmJnFOe1rkAFMAUxs3l1mBhI
	 2NCOL+q5I0VVNv+0dGAJfrZq+/1TyE72vvOmWDZabeHKu27LbPnLANVVl2m8RHZjn2
	 NW/zPJMTjz5/6b/4MZxvH8vK4FL+hT+iP8Vl3ehY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Boykin <jtboykin.jb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1251/1536] platform/x86/amd/pmf: Fix power_supply refcount leak in amd_pmf_get_battery_prop()
Date: Sat,  7 Nov 2026 08:54:27 -0500
Message-ID: <20261107135032.909724297@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Boykin <jtboykin.jb@gmail.com>

[ Upstream commit 9f3eebbbd1033de0abcc2694ba4b455d30fe33f9 ]

power_supply_get_by_name() takes a reference that is only dropped on
the error path. On success it leaks, five times per policy evaluation.
Unregistering the battery later trips the use_cnt WARN_ON in
power_supply_unregister() and never frees it.

While here, return -ENODEV instead of an uninitialised 'value' when
no battery matches, and stop at the first supply found rather than
letting the last one in the table win.

Found by reading the code. Fix and changelog drafted with Claude Code
(Fable 5.1) and reviewed by hand. Compile-tested only (allmodconfig,
W=1, sparse); not run on Smart PC hardware.

Fixes: f4627dfd0e19 ("platform/x86/amd/pmf: Add support to get inputs from other subsystems")
Cc: stable@vger.kernel.org
Assisted-by: LLM sparse
Signed-off-by: Jack Boykin <jtboykin.jb@gmail.com>
Link: https://patch.msgid.link/20260902210217.69483-1-jtboykin.jb@gmail.com
Reviewed-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/amd/pmf/spc.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/amd/pmf/spc.c b/drivers/platform/x86/amd/pmf/spc.c
index 06226eb0eab33..53841ec8bd9b3 100644
--- a/drivers/platform/x86/amd/pmf/spc.c
+++ b/drivers/platform/x86/amd/pmf/spc.c
@@ -116,13 +116,11 @@ static int amd_pmf_get_battery_prop(enum power_supply_property prop)
 			continue;
 
 		ret = power_supply_get_property(psy, prop, &value);
-		if (ret) {
-			power_supply_put(psy);
-			return ret;
-		}
+		power_supply_put(psy);
+		return ret ? ret : value.intval;
 	}
 
-	return value.intval;
+	return -ENODEV;
 }
 
 static int amd_pmf_get_battery_info(struct amd_pmf_dev *dev, struct ta_pmf_enact_table *in)
-- 
2.53.0



