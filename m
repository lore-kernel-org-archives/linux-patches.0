Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624666;
	b=xM+VUdzUI/9L8bx8s9fiRFX5ZunANVFEXIt6eqNJEVoN1JlhZLQtUwnyOjkrbp5AVPgN
	 Ys+DuhcU+ucHTi/37pDB8rGr2Ek3uK2ago9tdSsMxaL2LWTx6BBABZXrL8oMn2mPFvqQn
	 oHJgB8x9aCmm7GoSBAeJixOp0lSgGrgkQjsDtUm4EMDaAiwvh+KtFa0cppDH5dPX/vHUa
	 IIdUnMbBAl7niyG0en7I2c2lWbFpCQvNvfMenoODalYrmnmC3ZTmMl8uBks/L++2TyHFz
	 hnb+53e4TXsqFU6fCqXbQhBHbegTTluQCgse8tB8A1uN4gMPjGGa4ymh6dj1V+r6mAw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624666;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/sgMz0BeZ7/d8MPokrc4mVSzih8MVx9wQVUDE6+h4mo=;
	b=UK4D7zdjdl6LqXlO7o42c1VSjqr+puXB3xhfhQGfGOeIUvqI8gG3mwqoj9CmK1bxRyOe
	 15uTnLAjdQLaU7qNxvQxgIGkx5jR3xsCuJ2/xjk/D/Wva2xPTf2iOqjsLIw2syVnWH07m
	 iUQwrRH2+9CQ8D74VulNJCidHNrBneTHv2GZNotzInI82ezv+U/dLQctHDFMKW8F02Cer
	 gEQSl3D7DFLbOOLjZgvcfuQhzxLiKWm3ZXU68uzunJb3UuYAcXuxVius/vY1cpJIc0+N6
	 J/FH63+iOOoVfOKA2G9siH/Hv9dovqLUXqcfDuRdpQoDSurH+mGKGqi/yF34Sb8Qjng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SY093eST;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9106B606A33C;
	Wed, 25 Nov 2026 16:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SY093eST
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 306351F000CF;
	Wed, 25 Nov 2026 16:37:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624665;
	bh=/sgMz0BeZ7/d8MPokrc4mVSzih8MVx9wQVUDE6+h4mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SY093eSTzdt4u5amSaNSqNASiJ+KP3s2nX7WPU1uIHBOZmM4p8rddDwyt8oVrvzOV
	 72V7U1ZYCQoLH4HW9fM2U58rg3EDt5TL9gPRyDt9TCK4MaeESU8PHHPLoi437h6ZCF
	 ffjN0+4zLbL8J6M5MsS7vGa1Apd4HdbbjIgkW4qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lifeng Zheng <zhenglifeng1@huawei.com>,
	Viresh Kumar <viresh.kumar@linaro.org>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 265/816] cpufreq: Force sync policy boost with global boost on sysfs update
Date: Wed, 25 Nov 2026 15:30:13 +0100
Message-ID: <20261125143855.343915553@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

From: Viresh Kumar <viresh.kumar@linaro.org>

[ Upstream commit 121baab7b88ed865532dadb7ef1aee6e2bea86f5 ]

If the global boost flag is enabled and policy boost flag is disabled, a
call to `cpufreq_boost_trigger_state(true)` must enable the policy's
boost state.

The current code misses that because of an optimization. Fix it.

Suggested-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Reviewed-by: Lifeng Zheng <zhenglifeng1@huawei.com>
Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
Link: https://patch.msgid.link/852ff11c589e6300730d207baac195b2d9d8b95f.1745511526.git.viresh.kumar@linaro.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Stable-dep-of: 3d5720dff09f ("cpufreq: Serialize global boost updates")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/cpufreq/cpufreq.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 392f15173038a..c4672b95e32e1 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -2825,8 +2825,10 @@ static int cpufreq_boost_trigger_state(int state)
 	unsigned long flags;
 	int ret = 0;
 
-	if (cpufreq_driver->boost_enabled == state)
-		return 0;
+	/*
+	 * Don't compare 'cpufreq_driver->boost_enabled' with 'state' here to
+	 * make sure all policies are in sync with global boost flag.
+	 */
 
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 	cpufreq_driver->boost_enabled = state;
-- 
2.53.0



