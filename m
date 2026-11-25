Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617806;
	b=WOIkY5OjsksAyp50tXnwb/+EyF3yCjQzw3fwL3f8cQ4IJJrnDE9wNoKN97fSQ+iCOBqs
	 uypPtJCkHjXAvrSWsvgYikAgEuJGsjM3dAN2j7kQYkUy3toR4TS0NzZqeZyY/kpbU0KdA
	 hjlTpL952st2pu5k98EsKI/gqliavx0vk73wMYMhalB/dMoN2C4qukMKpd13bVOL8L+4c
	 /POL73VRomAoR+8NFBEclXQbmWI17RnNaWyHHrzrWbeBzbMh+akoDdyAk5mcKtwtpgpll
	 q+DxiXq69OTEiV+wgXZEU8xyBE47p8BI9t4ZV+kQhZtn+WYpShMQAvta0abtGzEJKfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617806;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vsOiGDgVtFmZIPPxGqhcAJpuIjzyRj0v7twarPqChSo=;
	b=kdRafpN2BdXqnvbCcPOpgLvLD1+1AI5AEbTBYanUTutTu2+lD5GseEikj+JVfIP/G1ez
	 vz5E41SW+dtry1Nv81C5kLPxIFpGTW9qOivL0eGRnTBCAuyPo6JVYcGp9MJqSts8JDbGj
	 lqvQIA3HYaot/aikHXhnXhwP7h1NSW9PPMmSs6g1pVbWqMTCjS40Ybv2ogZRhwHfC7N2N
	 Zv2YMoIoAbeJLZbTg0fng0ajbPQpcDO1m0oKDsMkCHqTprk+/AxTY4eYQW/3XrzDWSBMf
	 tFDd9gBWVZdXFRyEAWdc0fiGE41EI+l6Iyaa3zNa4eJJf/BNurInc3Ftt995XGj2mew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=avpbF5Ef;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8071E606A323;
	Wed, 25 Nov 2026 14:43:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=avpbF5Ef
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D33B01F000CA;
	Wed, 25 Nov 2026 14:43:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617806;
	bh=vsOiGDgVtFmZIPPxGqhcAJpuIjzyRj0v7twarPqChSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=avpbF5EfPDp1o/N3ESCDoa3hUCU0fvPMbMBGNe3+kUp6fdivf4DyX61++dGSkPa87
	 q53byqXxLRtDL3LOYZKQVWlfIyKwmGm6L2gXp7ZSR3HjAoxQDf4P4OfNgWxPfWvjsT
	 MccMvqE0rJje3lu7nyGpkOrCfELGxSLytR34NaKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Hilliard <james.hilliard1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0081/1005] ptp: unwind partially completed virtual clock creation
Date: Wed, 25 Nov 2026 15:23:39 +0100
Message-ID: <20261125143823.639047279@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

From: James Hilliard <james.hilliard1@gmail.com>

[ Upstream commit 3dea778260e3dddf30651a6913d87a42861346a2 ]

n_vclocks_store() publishes the new clock count only after every child
has been registered. If a later registration fails, it returns without
unregistering the children already created by that request. Those clocks
are left out of n_vclocks, and a subsequent request can overwrite their
index entries without removing them.

Unregister the newly created children in reverse order and clear their
index entries on failure. Leave the previously installed clocks and
their count unchanged. The n_vclocks mutex serializes this rollback with
other sysfs changes, and parent removal drains the store before walking
the children.

This was found by code inspection while adding initial PHC sample error
handling to virtual clock registration.

Fixes: 73f37068d540 ("ptp: support ptp physical/virtual clocks conversion")
Signed-off-by: James Hilliard <james.hilliard1@gmail.com>
Link: https://patch.msgid.link/20261026-ptp-vclock-sampling-v6-2-e705612541f1@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_sysfs.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index 1b4530be42a20..2d46f69e8c100 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -229,7 +229,7 @@ static ssize_t n_vclocks_store(struct device *dev,
 		for (i = 0; i < num - ptp->n_vclocks; i++) {
 			vclock = ptp_vclock_register(ptp);
 			if (!vclock)
-				goto out;
+				goto err_register;
 
 			*(ptp->vclock_index + ptp->n_vclocks + i) =
 				vclock->clock->index;
@@ -261,6 +261,12 @@ static ssize_t n_vclocks_store(struct device *dev,
 	mutex_unlock(&ptp->n_vclocks_mux);
 
 	return count;
+err_register:
+	num = i;
+	if (num)
+		device_for_each_child_reverse(dev, &num, unregister_vclock);
+	for (num = 0; num < i; num++)
+		ptp->vclock_index[ptp->n_vclocks + num] = -1;
 out:
 	mutex_unlock(&ptp->n_vclocks_mux);
 	return err;
-- 
2.53.0



