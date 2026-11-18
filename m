Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795035796;
	b=Ff+QZKO1dBmt4hDn3H1jmsz8b1mNKxCLxZCGdE75l9HMUwdwKuuajt3DFzK1ztoVBtDM
	 GkF8qf8zYAAE+JuHiBySpH0JqELb/Sge9zGJ94uA9B2XTMUQ29ZmF0xcxOOEa44nnUrJL
	 MRv/Us+WQ0d7Or0DaBq1+KzKY012F0TKotf6x61+tUbvVVFbNoJdfmmqNKCTNmje7SrIe
	 AvNNAWnuagf4M5tpm31Jmb9XEW3SuoFos5im+zXKJtGmH5KAUKGLfsH4peTXNa8uHEVL3
	 d/5GTzc8ZQHNjIftuyvh2YAFhQmeZatiBn3NZEYLOI0trliTLdH886/IvpkXtNPP08g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795035796;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cBcKG+5hxleYgnfCd+3osA0Btwk+EP+0guCF9mRf8Kk=;
	b=OPHROoUeGOgY4XPA7HVFvujjCbM7MHCR1iVdSmURYvTYSppjfuC0KSE5DmH+8Ty4nXQh
	 TqtVwDMKhFSllM2IEi8mcv53kHIAlF0lmqojei/ZY/K1kZlvqZQ9BNgBoV2O/I5wM0hwA
	 1hNbBZxJCkL/0yR4suQsKry3hFUEw9NJD7XvmvdzUfBoSQh4ZmzdTi6NY9Vj1CuJx+7Q4
	 9uYHKFOw3CPIcUpYj1w4Qa2qdDIzptjiEJOwGXXsbBFfooDC4JRKrvifoSObdq9bIj7HW
	 QShF8S75iwxa9knwFbprzg+D5qE4iP7R3ksLahkh1Qa4EQU1QrRn8uD+xUnPq2Vywpg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BXsnyw4L;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9246606A320;
	Wed, 18 Nov 2026 21:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BXsnyw4L
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44FF41F000C4;
	Wed, 18 Nov 2026 21:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795035795;
	bh=cBcKG+5hxleYgnfCd+3osA0Btwk+EP+0guCF9mRf8Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BXsnyw4LX3Br+C4qs7AwvGbznrHuoTnuR2f4T592lRGa6NDTgDRohsXny7gttgeSi
	 xTsYFFLbVB15xhp4/eUETjDmbTHkI8sga+1X+MB73QGtREbMZN98SJ1X47If1vqNs3
	 xX7vMgNsNdnBn4PHS6CuJGmFU+QcuiHbWllQ0OO0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0828/3318] thermal: intel: int340x: Fix temperature selection around 0 C
Date: Wed, 18 Nov 2026 15:24:10 +0100
Message-ID: <20261118150343.928713398@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thorsten Blum <blum@kernel.org>

[ Upstream commit e56e2b49c67d132728e52ce493079e83cc914657 ]

Since commit 7251b9e8a007 ("thermal/intel: Fix intel_tcc_get_temp() to
support negative CPU temperature"), intel_tcc_get_temp() can report
negative temperatures.

proc_thermal_get_zone_temp() still uses *temp as the current maximum and
as an implicit "no reading yet" marker. However, this breaks when a CPU
reports 0 C, because a subsequent negative reading can overwrite it.

Use bool temp_valid to track whether a valid temperature has been read.
Initialize *temp with the first valid reading and only update it with
warmer readings.

Fixes: 7251b9e8a007 ("thermal/intel: Fix intel_tcc_get_temp() to support negative CPU temperature")
Cc: 6.3+ <stable@vger.kernel.org> # 6.3+
Signed-off-by: Thorsten Blum <blum@kernel.org>
Acked-by: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Link: https://patch.msgid.link/20260826153144.299746-3-blum@kernel.org
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../intel/int340x_thermal/processor_thermal_device.c   | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
index cdf88cadfc4f1..9d568daa0da45 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
@@ -114,17 +114,21 @@ static int proc_thermal_get_zone_temp(struct thermal_zone_device *zone,
 {
 	int cpu;
 	int curr_temp, ret;
-
-	*temp = 0;
+	bool temp_valid = false;
 
 	for_each_online_cpu(cpu) {
 		ret = intel_tcc_get_temp(cpu, &curr_temp, false);
 		if (ret < 0)
 			return ret;
-		if (!*temp || curr_temp > *temp)
+		if (!temp_valid || curr_temp > *temp) {
 			*temp = curr_temp;
+			temp_valid = true;
+		}
 	}
 
+	if (!temp_valid)
+		return -ENODATA;
+
 	*temp *= 1000;
 
 	return 0;
-- 
2.53.0



