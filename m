Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064737;
	b=oSBKrQoss9eXpnjdVAQdQpL7qKq0eg22KN+0MMi8PEPvF3766f9O9ODfSDryzwCrggFH
	 XWod0342OUe/rCKkOE4x6+NkT4DQ918gLX1gFnx4rjx/2kTr5oT1fp2lDQPUdzCRTqqft
	 qd6dCxn0rsv1dedAcvNzSMdbhQEp6jKdFosrygywnnWmIPHb5QhpNibft4F5X/Ra9KwfM
	 5YCWIfNpvTQco9SDV30blFja/evOpcMiTfPvbYWrhIsaID7vTrKmFkdqu1WhxsnYIM1p9
	 SCudzsM3/JybFFV6UO90HS2dl6pfo5+o+Sk+fAV19nXvrh2+AcAfKgh/lS1NIXZWKsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=lae1KDA3bApdfOVWlfIpjM2uTe9vPkssvhnydjHIhWk=;
	b=BMIAAcQ9auxzSkY/CPdd3G30CXw48I0mMYkcfJV1veJeVLwfBZsPy+clYLQcmx48bHBD
	 ktCdLS9Tk2QRTvGBEtfHow4vRXlQksLXBlSAhxR76GSuCYwDWnM2PfwxRXmgHLrOWNcMj
	 w/yI9wJRrGzOMHrtWcdjAbDtGQib2t0ag7G6YsWd77QPySU8svc1QGO0G1gEm91D63INw
	 3phBDeZFMFqkKLzvHJnpMr+t8VCwurBSp5VMtghX8ffHLsWLu03GvZuY4CNTdTvknj6Pm
	 mVK5wZqu/TfMieFI2RfYEQkkhvqTwmY5+Y9fjfc363B3U4ReHrln1dU9r/WK9BTVvUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CHgOuZeZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 864DA606A9C9;
	Sat,  7 Nov 2026 15:18:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CHgOuZeZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EBE11F008A1;
	Sat,  7 Nov 2026 15:18:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064737;
	bh=lae1KDA3bApdfOVWlfIpjM2uTe9vPkssvhnydjHIhWk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CHgOuZeZULZKvFmrTchEPPf1s6aqQ4+4TOlouLkuX6yMXtAM3625V3eJnKs2FYu4P
	 F2HiSBVyhQeNsmlsnpL9yKYK2CTMrcqGEc3maVEDedciZ+6R6+VUtMW8asae/iQI7k
	 xNGwPvAVHHzUqqw6Q8GIwMTby3qrpEwbnQQJKNYA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jack Boykin <jtboykin.jb@gmail.com>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0674/1257] platform/x86/amd/pmf: Fix power_supply refcount leak in amd_pmf_get_battery_prop()
Date: Sat,  7 Nov 2026 08:49:30 -0500
Message-ID: <20261107134957.871962204@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 592ba4de4c7f1..efb09a7915f72 100644
--- a/drivers/platform/x86/amd/pmf/spc.c
+++ b/drivers/platform/x86/amd/pmf/spc.c
@@ -199,13 +199,11 @@ static int amd_pmf_get_battery_prop(enum power_supply_property prop)
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



