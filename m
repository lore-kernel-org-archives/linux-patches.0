Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063877;
	b=LpWFPOB8+sbnl1QW+AegUbHs8xPwc0gNge9fcSrhDmMoUs79cCaXhH8D6u67Un+cY0d6
	 YJ6wRQ/+YPM9djbRFf7jHaeSyHoFqUv1sYTsYnqp3rDUUzwSdeAAhpu2DyHZC2lPrvZ0Z
	 vq2BO3mcxJs/o448ut/fDUJJwzsJVx9Z5yQWVLbYaCpO2Q6JCjtD/7v+V9XJLE+RnRvg7
	 PnMndnWiLtTLmYW1PyfOqvAgYSF1zFQmdCg5h2oIVVJZTkxmqUAmnUIDnf8KOJyCIOTOR
	 pquQl7pJ3AcSV6q6PXqXCLwO/oOsdRz+VHouW8SKha9jYct4yRD7eyfQIUhqCLCoCFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063877;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=/vWIkIO0HaGT0R7rV31M0UwIJiW0wAGn4AR8PM/YZVs=;
	b=z7phdwbSnTwksBbTG3bQS4CDnDzAKgrW2kcCuRlVWb2ikLskSxCGWmADRzr+zkHIFzuz
	 HIad23cUnk5BxWsV8YpDxrmSrtFreB/Pl5BiN0T2KerfrOrrd03/JLF5DiZYApTZP0miM
	 wUBtMSn+ho2p7K54qNeyUh8yit3/HOg4zemQs4PsqTWffKGfH138DsVr8zxo4sRrJT6nJ
	 di2nuXmt8loEbAoHfM3SA+U5LDAmgIQwiG0flFgoUzZh/DjtHVKcUP6eAQKH6JQT8BM3j
	 VDXEKoDcjnJbNOB1NY0ToXlLtYYqScFVjy1M8RI3Jt4Mb4SVl3NnHPsopkK4mSJoLOQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jl82P3No;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5827606A339;
	Sat,  7 Nov 2026 15:04:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=jl82P3No
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92B391F0089F;
	Sat,  7 Nov 2026 15:04:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063876;
	bh=/vWIkIO0HaGT0R7rV31M0UwIJiW0wAGn4AR8PM/YZVs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jl82P3Noo98lgMaOPLCe0yvWqc19ugi39rIIA8FmMjI0UkKCYkgMYW9TpLvXayLGo
	 KnOLWRmGcxj9y/KWfnjiHVkvk/iT7clWRiykLU4Fi3Hgg8vtinqOnCTHnsKE0Ql8Kb
	 DGat4ibTzx3Q6SX1/NHkXLePQJhHs/bRBFuPbH2w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thorsten Blum <blum@kernel.org>,
	Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0080/1257] thermal: intel: int340x: Fix temperature selection around 0 C
Date: Sat,  7 Nov 2026 08:39:36 -0500
Message-ID: <20261107134941.585231177@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index f80dbe2ca7e47..b0284c2e2e74d 100644
--- a/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
+++ b/drivers/thermal/intel/int340x_thermal/processor_thermal_device.c
@@ -179,17 +179,21 @@ static int proc_thermal_get_zone_temp(struct thermal_zone_device *zone,
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



